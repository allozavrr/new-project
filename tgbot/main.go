package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/spf13/cobra"
	"gopkg.in/telebot.v3"
)

var (
	rootCmd = &cobra.Command{
		Use:   "telegram-bot",
		Short: "Telegram bot for handling messages",
		Run:   run,
	}
)

type GitHubRepo struct {
	StargazersCount int `json:"stargazers_count"`
}

func getGitHubStars(username string) (int, error) {
	url := fmt.Sprintf("https://api.github.com/users/%s/repos", username)
	resp, err := http.Get(url)
	if err != nil {
		return 0, err
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return 0, err
	}

	var repos []GitHubRepo
	err = json.Unmarshal(body, &repos)
	if err != nil {
		return 0, err
	}

	totalStars := 0
	for _, repo := range repos {
		totalStars += repo.StargazersCount
	}

	return totalStars, nil
}

func run(cmd *cobra.Command, args []string) {
	pref := telebot.Settings{
		Token:  os.Getenv("TELE_TOKEN"),
		Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
	}

	b, err := telebot.NewBot(pref)
	if err != nil {
		log.Fatal(err)
		return
	}

	var userName string
	var githubUser string

	b.Handle("/start", func(m telebot.Context) {
		userName = ""
		githubUser = ""
		b.Send(m.Sender, "Привіт! Я Telegram-бот. Як тебе звати?")
	})

	b.Handle(telebot.OnText, func(m telebot.Context) {
		if userName == "" {
			userName = m.Text
			b.Send(m.Sender, fmt.Sprintf("Привіт, %s! Введіть ваш GitHub користувачське ім'я у форматі 'github.com/імʼя користувача'", userName))
		} else if githubUser == "" {
			githubUser = strings.TrimPrefix(m.Text, "https://")
			githubUser = strings.TrimPrefix(githubUser, "github.com/")
			stars, err := getGitHubStars(githubUser)
			if err != nil {
				b.Send(m.Sender, "Виникла помилка при отриманні даних. Будь ласка, спробуйте ще раз пізніше.")
				return
			}
			b.Send(m.Sender, fmt.Sprintf("У вас на GitHub є %d зірочок!", stars))
			userName = ""
			githubUser = ""
		} else {
			b.Send(m.Sender, "Не розумію вас. Повторіть будь ласка команду.")
		}
	})

	b.Start()
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
