import Foundation

struct Quote: Identifiable, Hashable {
    let id: Int
    private let localizedTexts: [AppLanguage: String]

    init(id: Int, localizedTexts: [AppLanguage: String]) {
        self.id = id
        self.localizedTexts = localizedTexts
    }

    func text(for language: AppLanguage) -> String {
        if let value = localizedTexts[language] {
            return value
        }
        if let fallback = localizedTexts[.english] {
            return fallback
        }
        return localizedTexts.values.first ?? ""
    }
}

struct QuoteRepository {
    private static let anchorDate: Date = {
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        components.calendar = Calendar(identifier: .gregorian)
        return components.date ?? Date(timeIntervalSince1970: 0)
    }()

    private static let quotes: [Quote] = [
        Quote(id: 1, localizedTexts: [
            .simplifiedChinese: "今天加班？恭喜你为老板的新车出了一份力。",
            .english: "Overtime today? Congrats on upgrading your boss’s car.",
            .spanish: "¿Horas extra hoy? Felicidades, ya contribuiste para el coche nuevo de tu jefe.",
            .japanese: "今日も残業？上司の新車をグレードアップしてあげたね。"
        ]),
        Quote(id: 2, localizedTexts: [
            .simplifiedChinese: "把时间花给重要的人，KPI 不会在你葬礼上致辞。",
            .english: "Spend time on people who matter; KPIs won’t give your eulogy.",
            .spanish: "Dedica tiempo a quienes importan; ningún KPI hablará en tu funeral.",
            .japanese: "大切な人に時間を使って。KPIはあなたの葬式で弔辞を読まない。"
        ]),
        Quote(id: 6, localizedTexts: [
            .simplifiedChinese: "老板的梦想不等于你的人生目标。",
            .english: "Your boss’s dream isn’t your life mission.",
            .spanish: "El sueño de tu jefe no es tu misión de vida.",
            .japanese: "上司の夢は、あなたの人生目標じゃない。"
        ]),
        Quote(id: 9, localizedTexts: [
            .simplifiedChinese: "工作是谋生，摸鱼是生活。",
            .english: "Work is for survival; ‘slacking’ is for living.",
            .spanish: "Trabajar es para sobrevivir; “holgazanear” es para vivir.",
            .japanese: "仕事は生きるため、サボりは生きている実感のため。"
        ]),
        Quote(id: 10, localizedTexts: [
            .simplifiedChinese: "你努力工作，老板才能过上梦想生活。",
            .english: "You work hard so your boss can live the dream life.",
            .spanish: "Trabajas duro para que tu jefe viva como quiere.",
            .japanese: "あなたが必死に働くから、上司は望む生活を送れる。"
        ]),
        Quote(id: 12, localizedTexts: [
            .simplifiedChinese: "摸鱼不是懒，是人类为了生存进化出的保护机制。",
            .english: "Slacking isn’t lazy; it’s a protective mechanism evolved for human survival.",
            .spanish: "Holgazanear no es pereza; es un mecanismo de defensa evolucionado para sobrevivir.",
            .japanese: "サボりは怠けじゃない。生き残るために進化した防御反応だ。"
        ]),
        Quote(id: 13, localizedTexts: [
            .simplifiedChinese: "你对公司很重要，直到你要求加薪的那一刻。",
            .english: "You are essential to the company, right up until you ask for a raise.",
            .spanish: "Eres vital para la empresa… hasta que pides un aumento.",
            .japanese: "君は会社にとって重要——給料アップを願い出るその瞬間までは。"
        ]),
        Quote(id: 15, localizedTexts: [
            .simplifiedChinese: "拿命换钱，最后都得拿钱换命。前提是，你还有命。",
            .english: "Trade your health for money, and you'll just trade that money back for health. If you’re lucky.",
            .spanish: "Cambias vida por dinero y luego dinero por vida, si es que aún te queda vida.",
            .japanese: "命を削って稼いだ金は、結局命を買い戻すために使う。命が残っていればね。"
        ]),
        Quote(id: 16, localizedTexts: [
            .simplifiedChinese: "如果一份工作毫无意义，那准时下班就是你对它最大的尊重。",
            .english: "If a job is meaningless, leaving on time is the highest respect you can pay it.",
            .spanish: "Si un trabajo no tiene sentido, salir a tiempo es el mayor respeto.",
            .japanese: "意味のない仕事なら、定時で帰るのが最大の敬意。"
        ]),
        Quote(id: 17, localizedTexts: [
            .simplifiedChinese: "世界那么大，你却只看得见你的电脑屏幕。",
            .english: "The world is so big, yet you only see your computer screen.",
            .spanish: "El mundo es enorme y solo miras la pantalla.",
            .japanese: "世界はこんなに広いのに、君は画面しか見てない。"
        ]),
        Quote(id: 18, localizedTexts: [
            .simplifiedChinese: "别在办公室假装努力，去楼下咖啡馆真诚地发呆。",
            .english: "Stop pretending to work at your desk; go to the cafe downstairs and genuinely zone out.",
            .spanish: "No finjas trabajar en la oficina; baja al café y desconecta de verdad.",
            .japanese: "オフィスで頑張ってるフリはやめて、下のカフェで堂々とぼーっとしよう。"
        ]),
        Quote(id: 19, localizedTexts: [
            .simplifiedChinese: "拉磨的驴都还有休息的时候呢。",
            .english: "Even the donkey turning the millstone gets a break.",
            .spanish: "Hasta el burro del molino descansa.",
            .japanese: "石臼を引くロバだって休憩はある。"
        ]),
        Quote(id: 20, localizedTexts: [
            .simplifiedChinese: "没有你，公司（大概）也能转。没有你，你的生活就停了。",
            .english: "The company will (probably) run without you. Your life won’t.",
            .spanish: "Sin ti la empresa (probablemente) sigue. Sin ti, tu vida se detiene.",
            .japanese: "君がいなくても会社は（たぶん）回る。君がいなければ君の人生は止まる。"
        ]),
        Quote(id: 24, localizedTexts: [
            .simplifiedChinese: "“超越期待”是给“超越的薪水”准备的。",
            .english: "‘Going above and beyond’ is reserved for ‘above and beyond’ pay.",
            .spanish: "“Superar expectativas” es para sueldos que también las superan.",
            .japanese: "期待を超えるのは、給料も超えてからでいい。"
        ]),
        Quote(id: 27, localizedTexts: [
            .simplifiedChinese: "精神离职，是为了肉体能更久地在此地领薪。",
            .english: "Quietly quitting in spirit, so my body can physically continue to collect a salary here.",
            .spanish: "Renuncio en espíritu para que mi cuerpo siga cobrando.",
            .japanese: "心だけ退職しておけば、体はここで給料をもらい続けられる。"
        ]),
        Quote(id: 28, localizedTexts: [
            .simplifiedChinese: "世界上最蠢的事：闷头做事，等老板主动提拔。",
            .english: "Dumbest move ever: keeping your head down and hoping the boss promotes you.",
            .spanish: "Lo más tonto: trabajar en silencio esperando que tu jefe te ascienda solo.",
            .japanese: "世界で一番愚かなことは、ひたすら働いて上司が勝手に昇進させてくれるのを待つこと。"
        ]),
        Quote(id: 30, localizedTexts: [
            .simplifiedChinese: "公司说“我们是家人”，一种随时可以把你踢出家门的家人。",
            .english: "The company says ‘We are family’ — the kind of family that can fire you at any moment.",
            .spanish: "La empresa dice ‘Somos familia’… el tipo de familia que te puede despedir en cualquier momento.",
            .japanese: "会社は「我々は家族だ」と言う。いつでも君を勘当できるタイプの家族だ。"
        ]),
        Quote(id: 31, localizedTexts: [
            .simplifiedChinese: "努力工作的唯一回报，就是更多的工作。",
            .english: "The only reward for hard work... is more work.",
            .spanish: "La única recompensa por el trabajo duro... es más trabajo.",
            .japanese: "努力がもたらす唯一の報酬は…さらなる仕事だ。"
        ]),
        Quote(id: 33, localizedTexts: [
            .simplifiedChinese: "如果我一个月什么也不做，（可能）根本没人会发现。",
            .english: "If I did nothing for an entire month, (probably) no one would even notice.",
            .spanish: "Si no hiciera nada durante un mes entero, (probablemente) nadie se daría cuenta.",
            .japanese: "もし一ヶ月丸ごと何もしなくても、（たぶん）誰も気づかないだろう。"
        ]),
        Quote(id: 35, localizedTexts: [
            .simplifiedChinese: "每一个“十万火急”的需求，最后都会在老板的收件箱里安详地躺三天。",
            .english: "Every 'urgent, top priority' request will end up sitting peacefully in the boss's inbox for three days.",
            .spanish: "Cada solicitud ‘urgente y prioritaria’ terminará reposando tranquilamente en la bandeja de entrada del jefe por tres días.",
            .japanese: "すべての「最優先」リクエストは、上司の受信トレイで三日間安らかに眠ることになる。"
        ])
    ]

    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func quote(for date: Date = Date()) -> Quote {
        let startOfDay = calendar.startOfDay(for: date)
        let base = calendar.startOfDay(for: QuoteRepository.anchorDate)
        let days = calendar.dateComponents([.day], from: base, to: startOfDay).day ?? 0
        let count = QuoteRepository.quotes.count
        let index = ((days % count) + count) % count
        return QuoteRepository.quotes[index]
    }

    func allQuotes() -> [Quote] {
        QuoteRepository.quotes
    }
}
