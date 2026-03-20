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
        Quote(id: 3, localizedTexts: [
            .simplifiedChinese: "老板的梦想不等于你的人生目标。",
            .english: "Your boss’s dream isn’t your life mission.",
            .spanish: "El sueño de tu jefe no es tu misión de vida.",
            .japanese: "上司の夢は、あなたの人生目標じゃない。"
        ]),
        Quote(id: 4, localizedTexts: [
            .simplifiedChinese: "工作是谋生，摸鱼是生活。",
            .english: "Work is for survival; ‘slacking’ is for living.",
            .spanish: "Trabajar es para sobrevivir; “holgazanear” es para vivir.",
            .japanese: "仕事は生きるため、サボりは生きている実感のため。"
        ]),
        Quote(id: 5, localizedTexts: [
            .simplifiedChinese: "你努力工作，老板才能过上梦想生活。",
            .english: "You work hard so your boss can live the dream life.",
            .spanish: "Trabajas duro para que tu jefe viva como quiere.",
            .japanese: "あなたが必死に働くから、上司は望む生活を送れる。"
        ]),
        Quote(id: 6, localizedTexts: [
            .simplifiedChinese: "摸鱼不是懒，是人类为了生存进化出的保护机制。",
            .english: "Slacking isn’t lazy; it’s a protective mechanism evolved for human survival.",
            .spanish: "Holgazanear no es pereza; es un mecanismo de defensa evolucionado para sobrevivir.",
            .japanese: "サボりは怠けじゃない。生き残るために進化した防御反応だ。"
        ]),
        Quote(id: 7, localizedTexts: [
            .simplifiedChinese: "你对公司很重要，直到你要求加薪的那一刻。",
            .english: "You are essential to the company, right up until you ask for a raise.",
            .spanish: "Eres vital para la empresa… hasta que pides un aumento.",
            .japanese: "君は会社にとって重要——給料アップを願い出るその瞬間までは。"
        ]),
        Quote(id: 8, localizedTexts: [
            .simplifiedChinese: "拿命换钱，最后都得拿钱换命。前提是，你还有命。",
            .english: "Trade your health for money, and you'll just trade that money back for health. If you’re lucky.",
            .spanish: "Cambias vida por dinero y luego dinero por vida, si es que aún te queda vida.",
            .japanese: "命を削って稼いだ金は、結局命を買い戻すために使う。命が残っていればね。"
        ]),
        Quote(id: 9, localizedTexts: [
            .simplifiedChinese: "如果一份工作毫无意义，那准时下班就是你对它最大的尊重。",
            .english: "If a job is meaningless, leaving on time is the highest respect you can pay it.",
            .spanish: "Si un trabajo no tiene sentido, salir a tiempo es el mayor respeto.",
            .japanese: "意味のない仕事なら、定時で帰るのが最大の敬意。"
        ]),
        Quote(id: 10, localizedTexts: [
            .simplifiedChinese: "世界那么大，你却只看得见你的电脑屏幕。",
            .english: "The world is so big, yet you only see your computer screen.",
            .spanish: "El mundo es enorme y solo miras la pantalla.",
            .japanese: "世界はこんなに広いのに、君は画面しか見てない。"
        ]),
        Quote(id: 11, localizedTexts: [
            .simplifiedChinese: "别在办公室假装努力，去楼下咖啡馆真诚地发呆。",
            .english: "Stop pretending to work at your desk; go to the cafe downstairs and genuinely zone out.",
            .spanish: "No finjas trabajar en la oficina; baja al café y desconecta de verdad.",
            .japanese: "オフィスで頑張ってるフリはやめて、下のカフェで堂々とぼーっとしよう。"
        ]),
        Quote(id: 12, localizedTexts: [
            .simplifiedChinese: "拉磨的驴都还有休息的时候呢。",
            .english: "Even the donkey turning the millstone gets a break.",
            .spanish: "Hasta el burro del molino descansa.",
            .japanese: "石臼を引くロバだって休憩はある。"
        ]),
        Quote(id: 13, localizedTexts: [
            .simplifiedChinese: "没有你，公司（大概）也能转。没有你，你的生活就停了。",
            .english: "The company will (probably) run without you. Your life won’t.",
            .spanish: "Sin ti la empresa (probablemente) sigue. Sin ti, tu vida se detiene.",
            .japanese: "君がいなくても会社は（たぶん）回る。君がいなければ君の人生は止まる。"
        ]),
        Quote(id: 14, localizedTexts: [
            .simplifiedChinese: "“超越期待”是给“超越的薪水”准备的。",
            .english: "‘Going above and beyond’ is reserved for ‘above and beyond’ pay.",
            .spanish: "“Superar expectativas” es para sueldos que también las superan.",
            .japanese: "期待を超えるのは、給料も超えてからでいい。"
        ]),
        Quote(id: 15, localizedTexts: [
            .simplifiedChinese: "精神离职，是为了肉体能更久地在此地领薪。",
            .english: "Quietly quitting in spirit, so my body can physically continue to collect a salary here.",
            .spanish: "Renuncio en espíritu para que mi cuerpo siga cobrando.",
            .japanese: "心だけ退職しておけば、体はここで給料をもらい続けられる。"
        ]),
        Quote(id: 16, localizedTexts: [
            .simplifiedChinese: "世界上最蠢的事：闷头做事，等老板主动提拔。",
            .english: "Dumbest move ever: keeping your head down and hoping the boss promotes you.",
            .spanish: "Lo más tonto: trabajar en silencio esperando que tu jefe te ascienda solo.",
            .japanese: "世界で一番愚かなことは、ひたすら働いて上司が勝手に昇進させてくれるのを待つこと。"
        ]),
        Quote(id: 17, localizedTexts: [
            .simplifiedChinese: "公司说“我们是家人”，一种随时可以把你踢出家门的家人。",
            .english: "The company says ‘We are family’ — the kind of family that can fire you at any moment.",
            .spanish: "La empresa dice ‘Somos familia’… el tipo de familia que te puede despedir en cualquier momento.",
            .japanese: "会社は「我々は家族だ」と言う。いつでも君を勘当できるタイプの家族だ。"
        ]),
        Quote(id: 18, localizedTexts: [
            .simplifiedChinese: "努力工作的唯一回报，就是更多的工作。",
            .english: "The only reward for hard work... is more work.",
            .spanish: "La única recompensa por el trabajo duro... es más trabajo.",
            .japanese: "努力がもたらす唯一の報酬は…さらなる仕事だ。"
        ]),
        Quote(id: 19, localizedTexts: [
            .simplifiedChinese: "如果我一个月什么也不做，（可能）根本没人会发现。",
            .english: "If I did nothing for an entire month, (probably) no one would even notice.",
            .spanish: "Si no hiciera nada durante un mes entero, (probablemente) nadie se daría cuenta.",
            .japanese: "もし一ヶ月丸ごと何もしなくても、（たぶん）誰も気づかないだろう。"
        ]),
        Quote(id: 20, localizedTexts: [
            .simplifiedChinese: "每一个“十万火急”的需求，最后都会在老板的收件箱里安详地躺三天。",
            .english: "Every 'urgent, top priority' request will end up sitting peacefully in the boss's inbox for three days.",
            .spanish: "Cada solicitud ‘urgente y prioritaria’ terminará reposando tranquilamente en la bandeja de entrada del jefe por tres días.",
            .japanese: "すべての「最優先」リクエストは、上司の受信トレイで三日間安らかに眠ることになる。"
        ]),
        Quote(id: 21, localizedTexts: [
            .simplifiedChinese: "90%的会议，其实发一句‘收到’就能解决。",
            .english: "90% of meetings could be resolved by just replying 'Noted'.",
            .spanish: "El 90% de las reuniones podrían resolverse simplemente respondiendo 'Entendido'.",
            .japanese: "90%の会議は、実は「承知しました」と返信するだけで解決する。"
        ]),
        Quote(id: 22, localizedTexts: [
            .simplifiedChinese: "别把周日晚上献给焦虑，老板又不会给你补周末。",
            .english: "Don’t donate Sunday night to anxiety; your boss won’t refund the weekend.",
            .spanish: "No regales el domingo por la noche a la ansiedad; tu jefe no te devolverá el fin de semana.",
            .japanese: "日曜の夜を不安に差し出すな。上司は週末を返してくれない。"
        ]),
        Quote(id: 23, localizedTexts: [
            .simplifiedChinese: "手机剩20%电你都会慌，自己剩5%电怎么还在加班？",
            .english: "You panic when your phone hits 20%, so why are you still working at 5%?",
            .spanish: "Entras en pánico cuando tu teléfono llega al 20%, ¿por qué sigues trabajando al 5%?",
            .japanese: "スマホの充電が20%になると焦るのに、自分の充電が5%でまだ残業してるの？"
        ]),
        Quote(id: 24, localizedTexts: [
            .simplifiedChinese: "把人生押给工位的人，最后只会得到更结实的工位。",
            .english: "Bet your life on the desk, and all you get is a sturdier desk.",
            .spanish: "Si apuestas tu vida al escritorio, lo único que ganas es un escritorio más sólido.",
            .japanese: "人生をデスクに賭けても、得られるのはもっと頑丈なデスクだけだ。"
        ]),
        Quote(id: 25, localizedTexts: [
            .simplifiedChinese: "今天少回一条消息，地球不会停止自转。",
            .english: "Reply to one fewer message today. The planet will keep spinning.",
            .spanish: "Responde un mensaje menos hoy. El planeta seguirá girando.",
            .japanese: "今日は返信を一通減らせ。地球はちゃんと回り続ける。"
        ]),
        Quote(id: 26, localizedTexts: [
            .simplifiedChinese: "有些事不是重要，只是声音大。",
            .english: "Some things aren’t important. They’re just loud.",
            .spanish: "Algunas cosas no son importantes; solo hacen mucho ruido.",
            .japanese: "重要なのではなく、ただ声が大きいだけのこともある。"
        ]),
        Quote(id: 27, localizedTexts: [
            .simplifiedChinese: "你的待办清单没有尽头，所以今天可以先去吃饭。",
            .english: "Your to-do list is endless, so you can go eat first.",
            .spanish: "Tu lista de tareas no se acaba nunca, así que primero ve a comer.",
            .japanese: "やることリストに終わりはない。だから先にご飯を食べていい。"
        ]),
        Quote(id: 28, localizedTexts: [
            .simplifiedChinese: "如果大家都装忙，那真正休息的人反而最诚实。",
            .english: "If everyone is pretending to be busy, the one resting is the honest one.",
            .spanish: "Si todos fingen estar ocupados, quien descansa es el más honesto.",
            .japanese: "皆が忙しいフリをしているなら、休んでいる人が一番正直だ。"
        ]),
        Quote(id: 29, localizedTexts: [
            .simplifiedChinese: "别总想着提升自己，先把自己还给自己。",
            .english: "Stop trying to optimize yourself. Give yourself back to yourself first.",
            .spanish: "Deja de intentar optimizarte. Primero devuélvete a ti mismo.",
            .japanese: "自分を最適化し続けるのはやめよう。まず自分を自分に返せ。"
        ]),
        Quote(id: 30, localizedTexts: [
            .simplifiedChinese: "工牌只是通行证，不是人格说明书。",
            .english: "Your badge is just access control, not your identity.",
            .spanish: "Tu credencial solo abre puertas; no define quién eres.",
            .japanese: "社員証は通行証であって、君の人格説明書じゃない。"
        ]),
        Quote(id: 31, localizedTexts: [
            .simplifiedChinese: "摸鱼不是逃避工作，是提醒自己别被工作吞掉。",
            .english: "Slacking isn’t avoiding work. It’s avoiding being swallowed by work.",
            .spanish: "Holgazanear no es evitar el trabajo; es evitar que el trabajo te trague.",
            .japanese: "サボりは仕事から逃げることじゃない。仕事に飲み込まれないためだ。"
        ]),
        Quote(id: 32, localizedTexts: [
            .simplifiedChinese: "既然人生是场马拉松，那我现在走两步怎么了？",
            .english: "Since life is a marathon, what's wrong with taking a stroll right now?",
            .spanish: "Ya que la vida es un maratón, ¿qué tiene de malo caminar un rato ahora?",
            .japanese: "人生がマラソンなら、今ちょっと歩いたっていいじゃないか。"
        ]),
        Quote(id: 33, localizedTexts: [
            .simplifiedChinese: "老板说再坚持一下，通常是让你替他坚持。",
            .english: "When your boss says ‘hang in there,’ they usually mean ‘for me.’",
            .spanish: "Cuando tu jefe dice ‘aguanta un poco más’, normalmente quiere decir ‘por mí’.",
            .japanese: "上司の「もう少し頑張って」は、だいたい「私のために」だ。"
        ]),
        Quote(id: 34, localizedTexts: [
            .simplifiedChinese: "把午休过好，比把汇报写漂亮更接近幸福。",
            .english: "A good lunch break gets you closer to happiness than a polished status report.",
            .spanish: "Un buen descanso al mediodía te acerca más a la felicidad que un informe bonito.",
            .japanese: "完璧な進捗報告より、ちゃんとした昼休みのほうが幸せに近い。"
        ]),
        Quote(id: 35, localizedTexts: [
            .simplifiedChinese: "人生要紧的事，通常不在抄送名单里。",
            .english: "The important things in life are usually not on the CC line.",
            .spanish: "Las cosas importantes de la vida casi nunca están en copia en un correo.",
            .japanese: "人生で大事なことは、たいていCC欄には入っていない。"
        ]),
        Quote(id: 36, localizedTexts: [
            .simplifiedChinese: "不要把“我很忙”误会成“我很值钱”。",
            .english: "Don’t confuse ‘I’m busy’ with ‘I’m valuable.’",
            .spanish: "No confundas ‘estoy ocupado’ con ‘valgo más’.",
            .japanese: "「忙しい」と「価値がある」を取り違えるな。"
        ]),
        Quote(id: 37, localizedTexts: [
            .simplifiedChinese: "今天按时下班，不是摆烂，是对生命守时。",
            .english: "Leaving on time today isn’t slacking. It’s being punctual for your life.",
            .spanish: "Salir a tiempo hoy no es rendirse; es ser puntual con tu vida.",
            .japanese: "今日定時で帰るのは怠けじゃない。人生との約束を守ることだ。"
        ]),
        Quote(id: 38, localizedTexts: [
            .simplifiedChinese: "真正急的事会打电话，不会只会在群里艾特你。",
            .english: "If it’s truly urgent, they’ll call. Not just tag you in chat.",
            .spanish: "Si de verdad urge, te llamarán; no solo te mencionarán en el chat.",
            .japanese: "本当に緊急なら電話が来る。チャットでメンションされるだけじゃない。"
        ]),
        Quote(id: 39, localizedTexts: [
            .simplifiedChinese: "你又不是长在工位上的蘑菇，没事多出去晒晒太阳。",
            .english: "You're not a mushroom growing on your desk. Go out and get some sun.",
            .spanish: "No eres un hongo creciendo en tu escritorio. Sal a tomar un poco de sol.",
            .japanese: "デスクに生えるキノコじゃないんだから、たまには外で太陽を浴びよう。"
        ]),
        Quote(id: 40, localizedTexts: [
            .simplifiedChinese: "你可以认真工作，但没必要把灵魂也一起提交。",
            .english: "You can work seriously without submitting your soul with it.",
            .spanish: "Puedes trabajar en serio sin entregar también el alma.",
            .japanese: "真面目に働いてもいい。でも魂まで提出する必要はない。"
        ]),
        Quote(id: 41, localizedTexts: [
            .simplifiedChinese: "KPI 的唯一作用，就是让那些毫无意义的工作看起来可以被量化。",
            .english: "The only purpose of KPIs is to make meaningless work look quantifiable.",
            .spanish: "El único propósito de los KPI es hacer que el trabajo sin sentido parezca cuantificable.",
            .japanese: "KPIの唯一の目的は、無意味な仕事を数値化できるように見せかけることだ。"
        ]),
        Quote(id: 42, localizedTexts: [
            .simplifiedChinese: "你每天花8小时填写的表格，最终归宿是某个永远不会被打开的共享文件夹。",
            .english: "The spreadsheet you spend 8 hours a day filling out will ultimately rest in a shared folder no one will ever open.",
            .spanish: "La hoja de cálculo que llenas durante 8 horas al día terminará en una carpeta compartida que nadie abrirá jamás.",
            .japanese: "毎日8時間かけて埋めたスプレッドシートの最終的な行き先は、誰も開かない共有フォルダだ。"
        ]),
        Quote(id: 43, localizedTexts: [
            .simplifiedChinese: "中层管理的核心技能：把一封邮件转发给你，并附上一句‘你怎么看？’",
            .english: "The core skill of middle management: forwarding an email to you and adding 'Thoughts?'",
            .spanish: "La habilidad principal de un mando intermedio: reenviarte un correo y añadir '¿Qué opinas?'",
            .japanese: "中間管理職のコアスキル：メールを転送して「どう思う？」と付け加えること。"
        ]),
        Quote(id: 44, localizedTexts: [
            .simplifiedChinese: "很多工作存在的唯一原因，是为了让另一个人觉得自己像个领导。",
            .english: "The only reason many jobs exist is to make someone else feel like a boss.",
            .spanish: "La única razón por la que existen muchos trabajos es para hacer que otra persona se sienta como un jefe.",
            .japanese: "多くの仕事が存在する唯一の理由は、誰かに「自分はボスだ」と感じさせるためだ。"
        ]),
        Quote(id: 45, localizedTexts: [
            .simplifiedChinese: "如果你的岗位明天突然消失，世界不仅照常运转，甚至可能变得更好。",
            .english: "If your job disappeared tomorrow, the world would not only keep spinning, it might actually improve.",
            .spanish: "Si tu trabajo desapareciera mañana, el mundo no solo seguiría girando, sino que podría mejorar.",
            .japanese: "もし明日あなたの仕事が消滅しても、世界は回り続けるどころか、むしろ良くなるかもしれない。"
        ]),
        Quote(id: 46, localizedTexts: [
            .simplifiedChinese: "所谓‘流程优化’，就是发明十个新表格，来解释为什么原来的工作做不完。",
            .english: "'Process optimization' means inventing ten new forms to explain why the original work isn't getting done.",
            .spanish: "La 'optimización de procesos' consiste en inventar diez formularios nuevos para explicar por qué no se hace el trabajo original.",
            .japanese: "「プロセス最適化」とは、元の仕事が終わらない理由を説明するために、10個の新しいフォームを発明することだ。"
        ]),
        Quote(id: 47, localizedTexts: [
            .simplifiedChinese: "开会的最大意义，是让所有人共同分担‘浪费时间’的罪恶感。",
            .english: "The main purpose of a meeting is to distribute the guilt of wasting time among a group of people.",
            .spanish: "El propósito principal de una reunión es distribuir la culpa de perder el tiempo entre un grupo de personas.",
            .japanese: "会議の最大の目的は、時間を無駄にしているという罪悪感を全員で分かち合うことだ。"
        ]),
        Quote(id: 48, localizedTexts: [
            .simplifiedChinese: "你写了整整三天的PPT，老板只看了三秒钟。所以，下次用三秒钟写吧。",
            .english: "You spent three days on a presentation the boss looked at for three seconds. Next time, spend three seconds on it.",
            .spanish: "Pasaste tres días en una presentación que el jefe miró por tres segundos. La próxima vez, dedícale tres segundos.",
            .japanese: "3日間かけて作ったプレゼン資料を、上司は3秒しか見なかった。だから次回は3秒で作ろう。"
        ]),
        Quote(id: 49, localizedTexts: [
            .simplifiedChinese: "公司把你当家人，是为了让你像在家一样无偿干活。",
            .english: "The company treats you like family so you'll work for free, just like at home.",
            .spanish: "La empresa te trata como familia para que trabajes gratis, igual que en casa.",
            .japanese: "会社が君を家族扱いするのは、家と同じようにタダ働きさせるためだ。"
        ]),
        Quote(id: 50, localizedTexts: [
            .simplifiedChinese: "如果工作真的那么好，他们就不会付钱让你去了。",
            .english: "If work were actually that great, they wouldn't have to pay you to go.",
            .spanish: "Si el trabajo fuera tan bueno, no tendrían que pagarte para ir.",
            .japanese: "もし仕事がそんなに素晴らしいものなら、お金を払ってまで行かせる必要はないはずだ。"
        ]),
        Quote(id: 51, localizedTexts: [
            .simplifiedChinese: "你的薪水不是对你能力的认可，而是对你放弃自由的赔偿。",
            .english: "Your salary isn't a reward for your skills; it's compensation for surrendering your freedom.",
            .spanish: "Tu salario no es un premio a tus habilidades; es una compensación por renunciar a tu libertad.",
            .japanese: "給料は君のスキルへの報酬じゃない。自由を放棄したことへの賠償金だ。"
        ]),
        Quote(id: 52, localizedTexts: [
            .simplifiedChinese: "‘弹性工作制’的意思是：下班后你也要弹性地处理工作。",
            .english: "'Flexible working hours' just means you have to be flexible enough to work after hours.",
            .spanish: "'Horario flexible' solo significa que debes ser lo suficientemente flexible para trabajar fuera de hora.",
            .japanese: "「フレックスタイム制」とは、退勤後もフレキシブルに働くべきだという意味だ。"
        ]),
        Quote(id: 53, localizedTexts: [
            .simplifiedChinese: "老板画的饼，卡路里为零，但能让你胃疼。",
            .english: "The pie in the sky your boss draws for you has zero calories, but it still gives you a stomachache.",
            .spanish: "Las promesas vacías de tu jefe tienen cero calorías, pero igual te dan dolor de estómago.",
            .japanese: "上司が描く絵に描いた餅はカロリーゼロだが、それでも胃痛を引き起こす。"
        ]),
        Quote(id: 54, localizedTexts: [
            .simplifiedChinese: "每天叫醒我的不是梦想，是贫穷和打卡机。",
            .english: "It's not my dreams that wake me up every morning; it's poverty and the time clock.",
            .spanish: "No son mis sueños los que me despiertan cada mañana; es la pobreza y el reloj de fichar.",
            .japanese: "毎朝私を起こすのは夢じゃない。貧困とタイムカードだ。"
        ]),
        Quote(id: 55, localizedTexts: [
            .simplifiedChinese: "不要在周五下午安排会议，这是职场仅存的日内瓦公约。",
            .english: "No meetings on Friday afternoons. It's the only Geneva Convention left in the workplace.",
            .spanish: "Nada de reuniones los viernes por la tarde. Es la única Convención de Ginebra que queda en la oficina.",
            .japanese: "金曜の午後に会議を入れないこと。それは職場に残された唯一のジュネーブ条約だ。"
        ]),
        Quote(id: 56, localizedTexts: [
            .simplifiedChinese: "你以为你在改变世界，其实你只是在美化一份PPT。",
            .english: "You think you're changing the world, but you're really just beautifying a PowerPoint slide.",
            .spanish: "Crees que estás cambiando el mundo, pero en realidad solo estás embelleciendo una diapositiva de PowerPoint.",
            .japanese: "世界を変えているつもりかもしれないが、実際はパワポのスライドを綺麗にしているだけだ。"
        ]),
        Quote(id: 57, localizedTexts: [
            .simplifiedChinese: "所谓‘团队建设’，就是占用你的周末，让你和不想见的人玩尴尬的游戏。",
            .english: "'Team building' is just stealing your weekend to play awkward games with people you want to avoid.",
            .spanish: "El 'team building' es robarte el fin de semana para jugar juegos incómodos con gente que prefieres evitar.",
            .japanese: "「チームビルディング」とは、週末を奪って、顔も見たくない人たちと気まずいゲームをさせることだ。"
        ]),
        Quote(id: 58, localizedTexts: [
            .simplifiedChinese: "工作群里的‘收到’，翻译过来就是‘别再烦我了’。",
            .english: "Replying 'Received' in the group chat translates to 'Please stop bothering me'.",
            .spanish: "Responder 'Recibido' en el chat del grupo se traduce como 'Por favor, dejen de molestarme'.",
            .japanese: "グループチャットの「承知しました」は、「もう邪魔しないでくれ」の翻訳だ。"
        ]),
        Quote(id: 59, localizedTexts: [
            .simplifiedChinese: "你缺的不是时间管理，你缺的是不用上班的钱。",
            .english: "You don't lack time management skills; you lack the money to not have to work.",
            .spanish: "No te falta gestión del tiempo; te falta el dinero para no tener que trabajar.",
            .japanese: "君に足りないのは時間管理術じゃない。働かなくて済むだけのお金だ。"
        ]),
        Quote(id: 60, localizedTexts: [
            .simplifiedChinese: "如果吃苦能赚钱，那首富应该是头牛。",
            .english: "If suffering made you rich, the wealthiest creature on earth would be a plow ox.",
            .spanish: "Si sufrir te hiciera rico, la criatura más rica de la tierra sería un buey de arado.",
            .japanese: "もし苦労がお金になるなら、世界一の金持ちは畑を耕す牛のはずだ。"
        ]),
        Quote(id: 61, localizedTexts: [
            .simplifiedChinese: "‘能者多劳’的潜台词是：既然你这么好用，那就往死里用。",
            .english: "The subtext of 'the capable do more work' is 'since you're so useful, we'll use you to death'.",
            .spanish: "El mensaje oculto de 'el capaz hace más' es 'ya que eres tan útil, te usaremos hasta la muerte'.",
            .japanese: "「有能な人ほど忙しい」の裏の意味は、「君は便利だから死ぬまでこき使うよ」だ。"
        ]),
        Quote(id: 62, localizedTexts: [
            .simplifiedChinese: "不要轻易展现你的实力，否则它会变成你的日常KPI。",
            .english: "Never easily reveal your true capabilities, or they will become your daily KPIs.",
            .spanish: "Nunca reveles fácilmente tus verdaderas capacidades, o se convertirán en tus KPI diarios.",
            .japanese: "自分の本当の能力を安易に見せてはいけない。それが君の毎日のKPIになってしまうからだ。"
        ]),
        Quote(id: 63, localizedTexts: [
            .simplifiedChinese: "‘扁平化管理’的意思是：除了老板，所有人都是底层。",
            .english: "'Flat management' means everyone is at the bottom except the boss.",
            .spanish: "La 'gestión plana' significa que todos están en el fondo excepto el jefe.",
            .japanese: "「フラットな組織」とは、社長以外の全員が底辺だという意味だ。"
        ]),
        Quote(id: 64, localizedTexts: [
            .simplifiedChinese: "打工人的三大错觉：快下班了、今天不加班、老板很看重我。",
            .english: "The three great illusions of an employee: it's almost time to leave, no overtime today, and the boss values me.",
            .spanish: "Las tres grandes ilusiones de un empleado: ya casi es hora de salir, hoy no hay horas extra, y el jefe me valora.",
            .japanese: "会社員の三大錯覚：もうすぐ退勤時間、今日は残業なし、そして上司は私を評価している。"
        ]),
        Quote(id: 65, localizedTexts: [
            .simplifiedChinese: "你以为的职业瓶颈，其实是这破公司不配你的才华。",
            .english: "What you think is a career bottleneck is actually just this garbage company not deserving your talent.",
            .spanish: "Lo que crees que es un estancamiento profesional es en realidad esta empresa basura que no merece tu talento.",
            .japanese: "キャリアの壁だと思っているものは、実はこのクソ会社が君の才能に値しないだけだ。"
        ]),
        Quote(id: 66, localizedTexts: [
            .simplifiedChinese: "‘狼性文化’的本质，就是想让你吃草，还指望你跑得像狼。",
            .english: "The essence of 'wolf culture' is wanting you to eat grass while expecting you to run like a wolf.",
            .spanish: "La esencia de la 'cultura del lobo' es querer que comas pasto mientras esperan que corras como un lobo.",
            .japanese: "「ウルフ・カルチャー」の本質は、草を食わせながら狼のように走れと期待することだ。"
        ]),
        Quote(id: 67, localizedTexts: [
            .simplifiedChinese: "下班后不回消息，是打工人最后的倔强。",
            .english: "Not replying to messages after work is an employee's final act of stubborn rebellion.",
            .spanish: "No responder mensajes después del trabajo es el último acto de rebelión obstinada de un empleado.",
            .japanese: "退勤後にメッセージを返さないことは、会社員に残された最後の意地だ。"
        ]),
        Quote(id: 68, localizedTexts: [
            .simplifiedChinese: "你不是在赚钱，你是在用寿命换取生存物资。",
            .english: "You're not making money; you're trading your lifespan for survival supplies.",
            .spanish: "No estás ganando dinero; estás intercambiando tu esperanza de vida por suministros de supervivencia.",
            .japanese: "君はお金を稼いでいるのではない。寿命を生存物資と交換しているだけだ。"
        ]),
        Quote(id: 69, localizedTexts: [
            .simplifiedChinese: "‘未来可期’的意思是：现在啥也没有，你先忍忍。",
            .english: "'The future is promising' means: you have nothing right now, just endure it.",
            .spanish: "'El futuro es prometedor' significa: ahora mismo no tienes nada, solo aguanta.",
            .japanese: "「未来は明るい」とは、「今は何もないから、とりあえず我慢しろ」という意味だ。"
        ]),
        Quote(id: 70, localizedTexts: [
            .simplifiedChinese: "职场里最没用的东西，就是你那无处安放的责任心。",
            .english: "The most useless thing in the workplace is your misplaced sense of responsibility.",
            .spanish: "Lo más inútil en el lugar de trabajo es tu sentido de la responsabilidad mal ubicado.",
            .japanese: "職場で最も役に立たないものは、君のその行き場のない責任感だ。"
        ]),
        Quote(id: 71, localizedTexts: [
            .simplifiedChinese: "只要我足够废物，就没有人能利用我。",
            .english: "As long as I am useless enough, no one can exploit me.",
            .spanish: "Mientras sea lo suficientemente inútil, nadie podrá explotarme.",
            .japanese: "私が十分に役立たずである限り、誰も私を搾取することはできない。"
        ]),
        Quote(id: 72, localizedTexts: [
            .simplifiedChinese: "‘复盘’的真正目的，是找个人出来背锅。",
            .english: "The real purpose of a 'post-mortem' meeting is to find someone to take the blame.",
            .spanish: "El verdadero propósito de una reunión 'post-mortem' es encontrar a alguien a quien echarle la culpa.",
            .japanese: "「振り返り会議」の本当の目的は、責任を押し付ける誰かを見つけることだ。"
        ]),
        Quote(id: 73, localizedTexts: [
            .simplifiedChinese: "你每天都在出卖灵魂，但月底一看工资，发现灵魂真不值钱。",
            .english: "You sell your soul every day, but when you check your paycheck at the end of the month, you realize your soul is dirt cheap.",
            .spanish: "Vendes tu alma todos los días, pero al ver tu sueldo a fin de mes, te das cuenta de que tu alma no vale nada.",
            .japanese: "毎日魂を売っているのに、月末の給与明細を見ると、自分の魂が激安であることに気づく。"
        ]),
        Quote(id: 74, localizedTexts: [
            .simplifiedChinese: "‘拥抱变化’的意思是：我们又要瞎折腾了，你最好配合点。",
            .english: "'Embrace change' means: we're about to mess things up again, you better cooperate.",
            .spanish: "'Abrazar el cambio' significa: vamos a arruinar las cosas de nuevo, mejor que cooperes.",
            .japanese: "「変化を受け入れろ」とは、「また無駄なことを始めるから、おとなしく協力しろ」という意味だ。"
        ]),
        Quote(id: 75, localizedTexts: [
            .simplifiedChinese: "世界上最遥远的距离，是你在工位，而你的心在马尔代夫。",
            .english: "The furthest distance in the world is between your body at the desk and your heart in the Maldives.",
            .spanish: "La distancia más grande del mundo es entre tu cuerpo en el escritorio y tu corazón en las Maldivas.",
            .japanese: "世界で最も遠い距離は、デスクにいる君の体と、モルディブにある君の心の間だ。"
        ]),
        Quote(id: 76, localizedTexts: [
            .simplifiedChinese: "如果迟到要扣钱，那加班为什么不加钱？",
            .english: "If being late deducts money, why doesn't working overtime add money?",
            .spanish: "Si llegar tarde te descuenta dinero, ¿por qué trabajar horas extra no te suma dinero?",
            .japanese: "遅刻すると給料が引かれるのに、なぜ残業しても給料が足されないのか？"
        ]),
        Quote(id: 77, localizedTexts: [
            .simplifiedChinese: "上班是为了下班，活着是为了退休。",
            .english: "We go to work just to get off work, and we stay alive just to retire.",
            .spanish: "Vamos a trabajar solo para salir del trabajo, y nos mantenemos vivos solo para jubilarnos.",
            .japanese: "出社するのは退勤するためであり、生きているのは定年退職するためだ。"
        ]),
        Quote(id: 78, localizedTexts: [
            .simplifiedChinese: "你以为你在工作，其实你只是在参与一场名为‘假装很忙’的真人秀。",
            .english: "You think you're working, but you're actually just participating in a reality show called 'Pretending to be Busy'.",
            .spanish: "Crees que estás trabajando, pero en realidad solo participas en un reality show llamado 'Fingir estar ocupado'.",
            .japanese: "君は仕事をしているつもりかもしれないが、実は「忙しいフリ」というリアリティ番組に参加しているだけだ。"
        ]),
        Quote(id: 79, localizedTexts: [
            .simplifiedChinese: "你的狗不在乎你是不是总监，它只在乎你今天有没有空扔飞盘。",
            .english: "Your dog doesn't care if you're a director; they just care if you have time to throw the frisbee today.",
            .spanish: "A tu perro no le importa si eres director; solo le importa si tienes tiempo para lanzarle el frisbee hoy.",
            .japanese: "犬はあなたが部長かどうかなんて気にしない。今日フリスビーを投げる時間があるかどうかだけだ。"
        ]),
        Quote(id: 80, localizedTexts: [
            .simplifiedChinese: "父母老去的速度，可不会停下来等你做完这个项目。",
            .english: "Your parents' aging won't hit pause while you finish this project.",
            .spanish: "El envejecimiento de tus padres no se pondrá en pausa mientras terminas este proyecto.",
            .japanese: "親が老いるスピードは、あなたがこのプロジェクトを終えるのを待ってはくれない。"
        ]),
        Quote(id: 81, localizedTexts: [
            .simplifiedChinese: "家里等你吃饭的人，比群里催你交报告的人重要一万倍。",
            .english: "The person waiting for you at home for dinner is ten thousand times more important than the one rushing your report in the group chat.",
            .spanish: "La persona que te espera en casa para cenar es diez mil veces más importante que quien te apura por el informe en el chat.",
            .japanese: "家でご飯を待っている人は、チャットで報告書を急かす人より一万倍重要だ。"
        ]),
        Quote(id: 82, localizedTexts: [
            .simplifiedChinese: "孩子的童年只有一次，错过了，用多少年终奖都买不回来。",
            .english: "Your child's childhood only happens once. Miss it, and no year-end bonus can buy it back.",
            .spanish: "La infancia de tu hijo solo ocurre una vez. Si te la pierdes, ningún bono de fin de año podrá comprarla.",
            .japanese: "子供の子供時代は一度きり。見逃したら、どれだけボーナスをもらっても買い戻せない。"
        ]),
        Quote(id: 83, localizedTexts: [
            .simplifiedChinese: "多和朋友喝酒吹牛，少在KPI上屎上雕花。",
            .english: "Spend more time drinking and bragging with friends, and less time polishing turds for your KPIs.",
            .spanish: "Pasa más tiempo bebiendo y charlando con amigos, y menos tiempo puliendo basura para tus KPIs.",
            .japanese: "友達と酒を飲んで語り合う時間を増やし、KPIのためにクソを磨く時間を減らそう。"
        ]),
        Quote(id: 84, localizedTexts: [
            .simplifiedChinese: "今天的晚霞很美，别让它只倒映在办公室的玻璃上。",
            .english: "The sunset is beautiful today. Don't let it only reflect on the office windows.",
            .spanish: "El atardecer es hermoso hoy. No dejes que solo se refleje en las ventanas de la oficina.",
            .japanese: "今日の夕焼けは美しい。オフィスの窓ガラスに反射させるだけじゃもったいない。"
        ]),
        Quote(id: 85, localizedTexts: [
            .simplifiedChinese: "下班路上给家里打个电话吧，他们比老板更想听你的声音。",
            .english: "Call your family on the way home. They want to hear your voice much more than your boss does.",
            .spanish: "Llama a tu familia de camino a casa. Quieren escuchar tu voz mucho más que tu jefe.",
            .japanese: "帰り道に家族に電話しよう。彼らは上司よりもずっとあなたの声を聞きたがっている。"
        ]),
        Quote(id: 86, localizedTexts: [
            .simplifiedChinese: "临终前，没有人会后悔自己当年没多加几天班，只会后悔没多陪陪爱的人。",
            .english: "On their deathbed, no one ever regrets not working more overtime; they only regret not spending more time with loved ones.",
            .spanish: "En el lecho de muerte, nadie se arrepiente de no haber hecho más horas extra; solo se arrepienten de no haber pasado más tiempo con sus seres queridos.",
            .japanese: "死ぬ間際に「もっと残業すればよかった」と後悔する人はいない。愛する人と過ごさなかったことだけを後悔するのだ。"
        ]),
        Quote(id: 87, localizedTexts: [
            .simplifiedChinese: "周末是用来制造回忆的，不是用来回邮件的。",
            .english: "Weekends are for making memories, not for replying to emails.",
            .spanish: "Los fines de semana son para crear recuerdos, no para responder correos.",
            .japanese: "週末は思い出を作るためのものであり、メールに返信するためのものではない。"
        ]),
        Quote(id: 88, localizedTexts: [
            .simplifiedChinese: "把时间浪费在喜欢的人身上，那就不叫浪费时间。",
            .english: "Time wasted with people you love is not wasted time.",
            .spanish: "El tiempo que pierdes con las personas que amas no es tiempo perdido.",
            .japanese: "好きな人と一緒に無駄にする時間は、決して無駄な時間ではない。"
        ]),
        Quote(id: 89, localizedTexts: [
            .simplifiedChinese: "陪父母散散步，比参加任何一场会议都更有意义。",
            .english: "Taking a walk with your parents is more meaningful than attending any meeting.",
            .spanish: "Dar un paseo con tus padres tiene más sentido que asistir a cualquier reunión.",
            .japanese: "両親と散歩することは、どんな会議に出席するよりも意味がある。"
        ]),
        Quote(id: 90, localizedTexts: [
            .simplifiedChinese: "你的猫不知道什么是OKR，它只知道你今天回家晚了。",
            .english: "Your cat doesn't know what an OKR is; it only knows you came home late today.",
            .spanish: "Tu gato no sabe qué es un OKR; solo sabe que hoy llegaste tarde a casa.",
            .japanese: "あなたの猫はOKRなんて知らない。今日帰りが遅かったことだけを知っている。"
        ]),
        Quote(id: 91, localizedTexts: [
            .simplifiedChinese: "别把最好的脾气给了客户，却把最差的耐心留给家人。",
            .english: "Don't give your best temper to clients and leave your worst patience for your family.",
            .spanish: "No le des tu mejor humor a los clientes y dejes tu peor paciencia para tu familia.",
            .japanese: "一番良い愛想を顧客に使い、一番悪い態度を家族に向けるのはやめよう。"
        ]),
        Quote(id: 92, localizedTexts: [
            .simplifiedChinese: "你的健康是家人的全世界，但在公司只是一个可以被替换的工号。",
            .english: "Your health means the world to your family, but to the company, it's just a replaceable employee number.",
            .spanish: "Tu salud es el mundo entero para tu familia, pero para la empresa es solo un número de empleado reemplazable.",
            .japanese: "あなたの健康は家族にとって世界のすべてだが、会社にとっては代わりが効く社員番号にすぎない。"
        ]),
        Quote(id: 93, localizedTexts: [
            .simplifiedChinese: "趁着阳光正好，去见那个你想见的人，别等下班，别等下次。",
            .english: "While the sun is shining, go see the person you want to see. Don't wait until after work, don't wait until next time.",
            .spanish: "Mientras brille el sol, ve a ver a la persona que quieres ver. No esperes a salir del trabajo, no esperes a la próxima vez.",
            .japanese: "日差しが良いうちに、会いたい人に会いに行こう。退勤まで待つな、次回まで待つな。"
        ]),
        Quote(id: 94, localizedTexts: [
            .simplifiedChinese: "努力工作的初衷是为了更好地生活，而不是失去生活。",
            .english: "The original purpose of working hard is to live a better life, not to lose it.",
            .spanish: "El propósito original de trabajar duro es vivir mejor, no perder la vida en ello.",
            .japanese: "一生懸命働く本来の目的は、より良い生活を送るためであり、生活を失うためではない。"
        ]),
        Quote(id: 95, localizedTexts: [
            .simplifiedChinese: "别总反思自己为什么效率低，有些破公司的流程连 AI 来了都得宕机。",
            .english: "Stop blaming yourself for low productivity. Some of this company's broken processes would make an AI crash.",
            .spanish: "Deja de culparte por tu baja productividad. Algunos de los procesos rotos de esta empresa harían que una IA colapsara.",
            .japanese: "自分の生産性が低いと反省するのはやめよう。この会社のクソみたいなプロセスは、AIでさえフリーズするレベルだ。"
        ]),
        Quote(id: 96, localizedTexts: [
            .simplifiedChinese: "攒工资是为了有一天能理直气壮地说‘老子不干了’。",
            .english: "Saving your salary is for that one day you can confidently say, 'I quit.'",
            .spanish: "Ahorrar tu sueldo es para el día en que puedas decir con orgullo: 'Renuncio'.",
            .japanese: "給料を貯めるのは、いつか堂々と「もう辞めてやる」と言うためだ。"
        ]),
        Quote(id: 97, localizedTexts: [
            .simplifiedChinese: "老板说你‘还需要沉淀’，翻译过来就是‘我还不想给你涨工资’。",
            .english: "When the boss says you 'need more time to grow,' it translates to 'I don't want to give you a raise yet.'",
            .spanish: "Cuando el jefe dice que 'necesitas más tiempo para crecer', se traduce como 'aún no quiero darte un aumento'.",
            .japanese: "上司の「君にはまだ成長が必要だ」は、「まだ給料を上げたくない」の翻訳だ。"
        ]),
        Quote(id: 98, localizedTexts: [
            .simplifiedChinese: "别让一个连打车费都不给报销的公司，否定了你的人生价值。",
            .english: "Don't let a company that won't even reimburse your cab fare dictate your self-worth.",
            .spanish: "No dejes que una empresa que ni siquiera te reembolsa el taxi dicte tu valor como persona.",
            .japanese: "タクシー代すら経費で落とさないような会社に、君の人生の価値を否定させてはいけない。"
        ]),
        Quote(id: 99, localizedTexts: [
            .simplifiedChinese: "泰坦尼克号沉没，可不是因为乘客不会游泳。",
            .english: "The Titanic didn't sink because the passengers couldn't swim.",
            .spanish: "El Titanic no se hundió porque los pasajeros no supieran nadar.",
            .japanese: "タイタニック号が沈んだのは、乗客が泳げなかったからではない。"
        ]),
        Quote(id: 100, localizedTexts: [
            .simplifiedChinese: "薪水越少，敷衍越多。",
            .english: "The lower the pay, the higher the half-assing.",
            .spanish: "A menor salario, mayor mediocridad.",
            .japanese: "給料が少ないほど、手抜きは増える。"
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
