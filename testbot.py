from telegram import Update
from telegram.ext import ApplicationBuilder, CommandHandler, ContextTypes

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text("543211ПОГНАЛИ1! алеха1!!!")

if __name__ == '__main__':
    TOKEN = "8413828802:AAHIiFNgyuWeSjDEQBTjKlVuwFRQEZTElSA"
    app = ApplicationBuilder().token(TOKEN).build()

    app.add_handler(CommandHandler("start", start))

    print("Бот запущен...")
    app.run_polling()
