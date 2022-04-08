Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A85C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 11:56:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33BE043399;
	Fri,  8 Apr 2022 07:56:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2W9P92rb9LfV; Fri,  8 Apr 2022 07:56:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07B964B220;
	Fri,  8 Apr 2022 07:56:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42F684B1F4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:56:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id prYQccJdpZPw for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 07:56:24 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D39FB4B211
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 07:56:24 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 429E062067;
 Fri,  8 Apr 2022 11:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DF8C385A3;
 Fri,  8 Apr 2022 11:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649418983;
 bh=IgQmCXJBE2ycdQoQEp6rpnOwcUiocLTkhM4XALt/TLE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=s9yXSip+T+rwF0geLqmnSBEhw+LCiazFF+dgKT08KCU41j19JN+45qBbnIFs1JAHK
 JOoOYYZTXw8aswy0aV3Ez63JwNojzv7AS9rOg7rOrCU1Ge/JBrulEgnE+q5CK/uEsK
 9Llr66GXzCQXWcBNqjrhF+lDmlUbrjbT+Ro3DClIz/QjyHTGqJ+XstxVJq3TvQXm6n
 THESjugbcj6uap7c7BD45fye3nijBwlZo+yf3amgzaGWEE1BRAFGNxLTQrCuD07QWs
 1KjFM8OF8kRiNcNC8OS+rTtVgKq/XcPrrJYNj4UEFOORVUhf+tJ0cTkiqk1LK4fpd2
 rLT3C8D/2SUMw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v13 17/39] arm64/sme: Disable ZA and streaming mode when
 handling signals
Date: Fri,  8 Apr 2022 12:43:06 +0100
Message-Id: <20220408114328.1401034-18-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220408114328.1401034-1-broonie@kernel.org>
References: <20220408114328.1401034-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1047; h=from:subject;
 bh=IgQmCXJBE2ycdQoQEp6rpnOwcUiocLTkhM4XALt/TLE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiUB/MNGzbGwQFros5j+TYXHHtF3i8QyvzP5YLP2js
 TRShsaKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYlAfzAAKCRAk1otyXVSH0DR/CA
 CF/lS7py2hHrn3w+TGcIG2waMCPpXXtaw5A3PWm8shZgXJKLmDDspNsvxvmRmIYQzp0iAFDQaLlz1a
 NBhO9Q9rUd32XfGSa2o12gt0my8bLZt3MYuMZAKm1EhB7wy6+NVBvhaM1grXU4nw0ZQh28AgnZ4kSa
 hY5jEU7FPK69LoO5QyYOj8B0LxcDNWuG2GHeetXAZxR3bRqzL++R4FuotgZRRYooE2ipmjHQtfuYR7
 2rKivu72y3+8k19kakrat3KnSUM7lKE0MrL3xVRFbFjYd8fBxmHHWD9JvikmQ7bRjn+wDLNkObSek3
 Uen/EUIpk03hZAO5VwuJGFotoPfZC7
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>,
 Luca Salabrino <luca.scalabrino@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The ABI requires that streaming mode and ZA are disabled when invoking
signal handlers, do this in setup_return() when we prepare the task state
for the signal handler.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/signal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 4a4122ef6f39..42efa464e46e 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -759,6 +759,13 @@ static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
 	/* TCO (Tag Check Override) always cleared for signal handlers */
 	regs->pstate &= ~PSR_TCO_BIT;
 
+	/* Signal handlers are invoked with ZA and streaming mode disabled */
+	if (system_supports_sme()) {
+		current->thread.svcr &= ~(SYS_SVCR_EL0_ZA_MASK |
+					  SYS_SVCR_EL0_SM_MASK);
+		sme_smstop();
+	}
+
 	if (ka->sa.sa_flags & SA_RESTORER)
 		sigtramp = ka->sa.sa_restorer;
 	else
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
