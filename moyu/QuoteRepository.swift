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
        ]),
        Quote(id: 36, localizedTexts: [
            .simplifiedChinese: "会议的本质，是一群人一起证明这封邮件本来也可以发。",
            .english: "A meeting is just a group proving this could have been an email.",
            .spanish: "Una reunión es un grupo demostrando que esto pudo ser un correo.",
            .japanese: "会議の本質は、これがメールで済んだと皆で証明することだ。"
        ]),
        Quote(id: 37, localizedTexts: [
            .simplifiedChinese: "别把周日晚上献给焦虑，老板又不会给你补周末。",
            .english: "Don’t donate Sunday night to anxiety; your boss won’t refund the weekend.",
            .spanish: "No regales el domingo por la noche a la ansiedad; tu jefe no te devolverá el fin de semana.",
            .japanese: "日曜の夜を不安に差し出すな。上司は週末を返してくれない。"
        ]),
        Quote(id: 38, localizedTexts: [
            .simplifiedChinese: "你不是效率机器，电量低了就该充电。",
            .english: "You’re not a productivity machine. Low battery means recharge.",
            .spanish: "No eres una máquina de productividad. Batería baja significa recargar.",
            .japanese: "君は生産性マシンじゃない。充電切れなら休むべきだ。"
        ]),
        Quote(id: 39, localizedTexts: [
            .simplifiedChinese: "把人生押给工位的人，最后只会得到更结实的工位。",
            .english: "Bet your life on the desk, and all you get is a sturdier desk.",
            .spanish: "Si apuestas tu vida al escritorio, lo único que ganas es un escritorio más sólido.",
            .japanese: "人生をデスクに賭けても、得られるのはもっと頑丈なデスクだけだ。"
        ]),
        Quote(id: 40, localizedTexts: [
            .simplifiedChinese: "今天少回一条消息，地球不会停止自转。",
            .english: "Reply to one fewer message today. The planet will keep spinning.",
            .spanish: "Responde un mensaje menos hoy. El planeta seguirá girando.",
            .japanese: "今日は返信を一通減らせ。地球はちゃんと回り続ける。"
        ]),
        Quote(id: 41, localizedTexts: [
            .simplifiedChinese: "有些事不是重要，只是声音大。",
            .english: "Some things aren’t important. They’re just loud.",
            .spanish: "Algunas cosas no son importantes; solo hacen mucho ruido.",
            .japanese: "重要なのではなく、ただ声が大きいだけのこともある。"
        ]),
        Quote(id: 42, localizedTexts: [
            .simplifiedChinese: "你的待办清单没有尽头，所以今天可以先去吃饭。",
            .english: "Your to-do list is endless, so you can go eat first.",
            .spanish: "Tu lista de tareas no se acaba nunca, así que primero ve a comer.",
            .japanese: "やることリストに終わりはない。だから先にご飯を食べていい。"
        ]),
        Quote(id: 43, localizedTexts: [
            .simplifiedChinese: "如果大家都装忙，那真正休息的人反而最诚实。",
            .english: "If everyone is pretending to be busy, the one resting is the honest one.",
            .spanish: "Si todos fingen estar ocupados, quien descansa es el más honesto.",
            .japanese: "皆が忙しいフリをしているなら、休んでいる人が一番正直だ。"
        ]),
        Quote(id: 44, localizedTexts: [
            .simplifiedChinese: "别总想着提升自己，先把自己还给自己。",
            .english: "Stop trying to optimize yourself. Give yourself back to yourself first.",
            .spanish: "Deja de intentar optimizarte. Primero devuélvete a ti mismo.",
            .japanese: "自分を最適化し続けるのはやめよう。まず自分を自分に返せ。"
        ]),
        Quote(id: 45, localizedTexts: [
            .simplifiedChinese: "工牌只是通行证，不是人格说明书。",
            .english: "Your badge is just access control, not your identity.",
            .spanish: "Tu credencial solo abre puertas; no define quién eres.",
            .japanese: "社員証は通行証であって、君の人格説明書じゃない。"
        ]),
        Quote(id: 46, localizedTexts: [
            .simplifiedChinese: "摸鱼不是逃避工作，是提醒自己别被工作吞掉。",
            .english: "Slacking isn’t avoiding work. It’s avoiding being swallowed by work.",
            .spanish: "Holgazanear no es evitar el trabajo; es evitar que el trabajo te trague.",
            .japanese: "サボりは仕事から逃げることじゃない。仕事に飲み込まれないためだ。"
        ]),
        Quote(id: 47, localizedTexts: [
            .simplifiedChinese: "你的人生不是冲刺赛，别把每一天都跑成加时。",
            .english: "Your life isn’t a sprint. Stop pushing every day into overtime.",
            .spanish: "Tu vida no es una carrera corta. No conviertas cada día en horas extra.",
            .japanese: "人生は短距離走じゃない。毎日を残業に変えるな。"
        ]),
        Quote(id: 48, localizedTexts: [
            .simplifiedChinese: "老板说再坚持一下，通常是让你替他坚持。",
            .english: "When your boss says ‘hang in there,’ they usually mean ‘for me.’",
            .spanish: "Cuando tu jefe dice ‘aguanta un poco más’, normalmente quiere decir ‘por mí’.",
            .japanese: "上司の「もう少し頑張って」は、だいたい「私のために」だ。"
        ]),
        Quote(id: 49, localizedTexts: [
            .simplifiedChinese: "把午休过好，比把汇报写漂亮更接近幸福。",
            .english: "A good lunch break gets you closer to happiness than a polished status report.",
            .spanish: "Un buen descanso al mediodía te acerca más a la felicidad que un informe bonito.",
            .japanese: "完璧な進捗報告より、ちゃんとした昼休みのほうが幸せに近い。"
        ]),
        Quote(id: 50, localizedTexts: [
            .simplifiedChinese: "人生要紧的事，通常不在抄送名单里。",
            .english: "The important things in life are usually not on the CC line.",
            .spanish: "Las cosas importantes de la vida casi nunca están en copia en un correo.",
            .japanese: "人生で大事なことは、たいていCC欄には入っていない。"
        ]),
        Quote(id: 51, localizedTexts: [
            .simplifiedChinese: "不要把“我很忙”误会成“我很值钱”。",
            .english: "Don’t confuse ‘I’m busy’ with ‘I’m valuable.’",
            .spanish: "No confundas ‘estoy ocupado’ con ‘valgo más’.",
            .japanese: "「忙しい」と「価値がある」を取り違えるな。"
        ]),
        Quote(id: 52, localizedTexts: [
            .simplifiedChinese: "今天按时下班，不是摆烂，是对生命守时。",
            .english: "Leaving on time today isn’t slacking. It’s being punctual for your life.",
            .spanish: "Salir a tiempo hoy no es rendirse; es ser puntual con tu vida.",
            .japanese: "今日定時で帰るのは怠けじゃない。人生との約束を守ることだ。"
        ]),
        Quote(id: 53, localizedTexts: [
            .simplifiedChinese: "真正急的事会打电话，不会只会在群里艾特你。",
            .english: "If it’s truly urgent, they’ll call. Not just tag you in chat.",
            .spanish: "Si de verdad urge, te llamarán; no solo te mencionarán en el chat.",
            .japanese: "本当に緊急なら電話が来る。チャットでメンションされるだけじゃない。"
        ]),
        Quote(id: 54, localizedTexts: [
            .simplifiedChinese: "与其把自己卷成文件夹，不如先出去晒十分钟太阳。",
            .english: "Instead of folding yourself into a spreadsheet, go get ten minutes of sun.",
            .spanish: "En vez de doblarte dentro de una hoja de cálculo, sal diez minutos al sol.",
            .japanese: "自分を表計算ソフトに折りたたむ前に、十分だけ日を浴びよう。"
        ]),
        Quote(id: 55, localizedTexts: [
            .simplifiedChinese: "你可以认真工作，但没必要把灵魂也一起提交。",
            .english: "You can work seriously without submitting your soul with it.",
            .spanish: "Puedes trabajar en serio sin entregar también el alma.",
            .japanese: "真面目に働いてもいい。でも魂まで提出する必要はない。"
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

    func randomQuotes(count: Int) -> [Quote] {
        guard !QuoteRepository.quotes.isEmpty else { return [] }

        var result: [Quote] = []
        result.reserveCapacity(max(0, count))

        while result.count < count {
            let remaining = count - result.count
            if remaining >= QuoteRepository.quotes.count {
                result.append(contentsOf: QuoteRepository.quotes.shuffled())
            } else {
                result.append(contentsOf: QuoteRepository.quotes.shuffled().prefix(remaining))
            }
        }

        return result
    }
}
