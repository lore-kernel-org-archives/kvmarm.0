Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B664C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 11:24:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1836C4B20E;
	Tue, 19 Apr 2022 07:24:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MXRXbZLLVQ19; Tue, 19 Apr 2022 07:24:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 132594B200;
	Tue, 19 Apr 2022 07:24:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0A4040E62
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:24:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JMREm05CmhBF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 07:24:40 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C858E40BED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:24:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E7444B81849;
 Tue, 19 Apr 2022 11:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285FEC385A8;
 Tue, 19 Apr 2022 11:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650367477;
 bh=IgQmCXJBE2ycdQoQEp6rpnOwcUiocLTkhM4XALt/TLE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=NipyCTm6aOhDxlULTGm5DiNJYlv/O9yw2ymObb6K/6ie9NqGDhIXw7vrvW4zTXu7r
 BUMjSUcefjxG4W+pxQ30zVfcGhuE8F9GdaQyWBgCzVw6ffO/sKz/WFaWgtvRPQNhrd
 lGHoocjf6ZfmmMNazL0j5B+ZQ0FpIw5weFg6C/AXr6YlSPJR71U0rbrSF6o4+S0uHc
 1TznWNQ8kxWUF3GPMMqh83utEkjXDOUZmm3rfsj7am1uUsLnL7UYF8zb7T6QibJnHN
 iOAMyqhH80u05m2KTIEMy0qUKEWa0iN1ag389TBeLTHlrza2dRiCFI7Cp1yhDw8UBB
 dWvmdSUicRQ0A==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v14 17/39] arm64/sme: Disable ZA and streaming mode when
 handling signals
Date: Tue, 19 Apr 2022 12:22:25 +0100
Message-Id: <20220419112247.711548-18-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419112247.711548-1-broonie@kernel.org>
References: <20220419112247.711548-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1047; h=from:subject;
 bh=IgQmCXJBE2ycdQoQEp6rpnOwcUiocLTkhM4XALt/TLE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiXpt1NGzbGwQFros5j+TYXHHtF3i8QyvzP5YLP2js
 TRShsaKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYl6bdQAKCRAk1otyXVSH0Fx5CA
 CFOdMEDMidXxyCWrnDbnkd6gNtPvdnJIP8qJ6nHTq1zLgcbCU0RrXA8u2X/g2a3KYcUtwFdqQGFgni
 JV4jTDo5tUFcNH1f6GUVw6C5VGEfkkMGBS4cEohT6J9AGcz+8xheLP0ap+/BB8HRzYzlkIK8lkO/A5
 D/+OpwHkhPqiOmVqe9lBYNJ4CjkaPwLV6vg24n1Pj6EfwDcsSqYHCoQ3bzfCrTsXvYo34ra+704cfH
 cFntoDFR06VnVe5qxg5IaeuI41DQqcy4Y8SZJsuQ+sMbkeiazCw25L/YSN0iTStv+meabk2vVBk/YF
 WS89rMfbrz7TsXz3ONjCYYLkZdtSw7
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
