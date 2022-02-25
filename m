Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3085AC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 17:35:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC0EE49E2B;
	Fri, 25 Feb 2022 12:35:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MinpPPn+ePmX; Fri, 25 Feb 2022 12:35:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B3624B9B5;
	Fri, 25 Feb 2022 12:35:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 530854B503
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:35:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kZvqnLYL8R+O for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 12:35:40 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEA094B910
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 12:35:38 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C3F28B832E0;
 Fri, 25 Feb 2022 17:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A03BC340F3;
 Fri, 25 Feb 2022 17:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645810536;
 bh=InKrBD2vMdmkBp7Q0QxHEgxWxIqiXPP3qW3BD5lYOp4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=bN1i3Zfkf8YaU7r7q09nJVDuZIk3ooQOxjydYMUxZoNCptATJxvntfZM7QoF0xeAE
 17+j5LWzM9dV2NYHxN2RVsx/zSwsyANGo4qCtmMd+wv3ZUbTYSGiYx6B8G9Jek3jJp
 L1w9SwnL+idt19tc0xeXFEi1fzsgj4KAN9rVgqmoKklGrEWxz4F1OFVsx9XOtBVD3g
 deZZxzFY/HqBjeKMYdgAcW35TikvYdthApyWsJrHRJVOoc5sbgqE/5GpXLu5d4cSOj
 nyBgfgivwbXlCjTYb6NAxwxYuzgbMJupic0y05BLproVz0dxy42fa8mdZbdlZqbutR
 o0RhEyIbgDSsQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v12 19/40] arm64/sme: Disable ZA and streaming mode when
 handling signals
Date: Fri, 25 Feb 2022 16:59:02 +0000
Message-Id: <20220225165923.1474372-20-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225165923.1474372-1-broonie@kernel.org>
References: <20220225165923.1474372-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1047; h=from:subject;
 bh=InKrBD2vMdmkBp7Q0QxHEgxWxIqiXPP3qW3BD5lYOp4=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiGQrZMkiujPktFI/rEXtS+3UDJnROtLYonJUy0xWx
 PrTzAz+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYhkK2QAKCRAk1otyXVSH0A1AB/
 9+3TU9k7VOwcoKeIx5YqG/HH1svo0g15RO/5LovV/phRjfdQjixZQKcrG4lV8OGw1KtVZr0Gk9+j6j
 CDDHIrQMG5JK+Ww+JYvClYZCHktZErlcZVD5wfv8U0UcIcyEIYMV8uuxtLUTdGKy6tbRiY/m85vmv6
 sQ+UZwWP7tebnjNAGQF2Zs+koThWeFNy2AEq6le44B5aXezx9U2yUUzPro5CADgWhpOWvHp2mEMdnB
 EHzEuaCA/VAAz1SQHYSfhlJTaoJplaF7yyrMyiyKScz/3FURwdekuuyZh2ZdenC/g70CiVAEA9tlhz
 xxnHsJFSGZIBH9d9DnqAlVh0Z2Udq4
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>
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
index d8aaf4b6f432..cda04fd73333 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -758,6 +758,13 @@ static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
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
