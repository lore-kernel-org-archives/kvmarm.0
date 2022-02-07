Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571ACC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  7 Feb 2022 15:24:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE1E749E49;
	Mon,  7 Feb 2022 10:24:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rgzhsgfL-Da6; Mon,  7 Feb 2022 10:24:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EC0649ED9;
	Mon,  7 Feb 2022 10:24:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D9DA49E49
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:24:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U4g1x6zFPjPp for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 10:24:24 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA2864086F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:24:24 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 2A98B6077B;
 Mon,  7 Feb 2022 15:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F28C340F0;
 Mon,  7 Feb 2022 15:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644247463;
 bh=CyYorHNQCHBoqo8xQvMZzI3T4+46kiWpXhSL8tXeuog=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=cvLfVWvDfmYSuyjXYex1xBQ9gPyeht5ydOaTKISojTjjKGHIG9295GdPG82prp482
 9jqBoMxoubjef/He2tMmwoB7IXLZTRgBLeJcdJf/pxND91R1Pnr55aOBVKUToJeiij
 Zep6I5WuQx+f5t7ktJB4PuysR5qGvxLT7H7l9LiKrPbRoYAfuuWXHf8NIR1TjeFUXe
 3LPAoB7EEaZxKaG0xaIfPW2I94lXsWvlJat6aDW1KAri9qLChHf2dH42t1xMpdTN5i
 du4rwWlt6CdsB2JMdnMgdhC+C7GNbEVZ+LYZoh6SkBZTzBRbHerHmM9qbWFJHcXxwy
 a55OHGBDrFhyA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v11 19/40] arm64/sme: Disable ZA and streaming mode when
 handling signals
Date: Mon,  7 Feb 2022 15:20:48 +0000
Message-Id: <20220207152109.197566-20-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207152109.197566-1-broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=991; h=from:subject;
 bh=CyYorHNQCHBoqo8xQvMZzI3T4+46kiWpXhSL8tXeuog=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiATjTGMK5oeSY6nFUOtibYupakncbZg936OSHhw4h
 4O/+R66JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYgE40wAKCRAk1otyXVSH0LxCB/
 454egnpD5PCrECVP5HSHQwc34prahK5O2UeOwYA8GKdzCWm2CQUxKv/NwgfNrghmSTESgeQcb78Nt1
 Iugdh2d/83YioKoWfNCnIUQQuH4Nj0DngdM8SC9Sf7CXng/Q94n2Qv0+44OgPPAO4VoT4wiztIVfvf
 CNA/QwZt8h4JGo22d3V8V+KPLvJ/lbFKmHQRwNrhw3BBokC4CclEnhsUlr+0AxBsIlZAGIgakJupCO
 2dlQMxBu7dF8kvjLWXiQ9JaEObM/ppG34Ecppd+VYT54p03wKwaUEed6Qsh9FnBkGSB9vrdcIKNX51
 TIKRbx9TMvAYBh1gZ2sZFJFS81obBO
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
