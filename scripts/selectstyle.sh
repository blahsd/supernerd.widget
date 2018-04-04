
cd $HOME/Library/Application\ Support/Übersicht/widgets/supernerd.widget/styles

cp "$1.css" 'applied.css'

osascript -e 'tell application "'$(ps ax | grep sicht | awk '{print $5}' | head -1 | cut -d/ -f3 | cut -d. -f1)'" to refresh'
