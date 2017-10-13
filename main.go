package main

import (
	"bufio"
	"fmt"
	"gopkg.in/src-d/go-git.v4"
	"gopkg.in/src-d/go-git.v4/plumbing/object"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"time"
)

func Info(format string, args ...interface{}) {
	fmt.Printf("\x1b[34;1m%s\x1b[0m\n", fmt.Sprintf(format, args...))
}

func main() {

	// Info("git clone https://github.com/src-d/go-siva")

	tempDirRootPath, err := ioutil.TempDir("", "boostrap-gerrit")
	if err != nil {
		log.Fatal(err)
	}

	defer os.RemoveAll(tempDirRootPath) // clean up

	gitPath := filepath.Join(tempDirRootPath, "myGit")

	r, err := git.PlainInit(gitPath, false)

	if err != nil {
		log.Fatal(err)
	}

	ws, err := r.Worktree()
	if err != nil {
		log.Fatal(err)
	}

	FileNameNo1 := "mon_fichier1.txt"

	f, err := os.Create(gitPath + "/" + FileNameNo1)

	w := bufio.NewWriter(f)
	_, err = w.WriteString("buffered\n")

	if err != nil {
		log.Fatalln(err)
	}

	fmt.Println(ws.Status())

	ws.Add(FileNameNo1)

	fmt.Println(ws.Status())

	ws.Commit("Voici mon commit de test", &git.CommitOptions{
		Author: &object.Signature{
			Name:  "John Doe",
			Email: "john@doe.org",
			When:  time.Now(),
		},
	},
	)

	fmt.Println(ws.Status())

}
