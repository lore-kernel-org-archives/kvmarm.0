Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A08C43334
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 12:42:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BCAC4B2B4;
	Mon, 20 Jun 2022 08:42:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kmqYCYpdTQMd; Mon, 20 Jun 2022 08:42:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77B644B3A2;
	Mon, 20 Jun 2022 08:42:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E6E34B309
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7kchpmMIqwKP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 08:42:31 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DEF0C4B4FF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:30 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 07DE4B8114D;
 Mon, 20 Jun 2022 12:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD76DC341C5;
 Mon, 20 Jun 2022 12:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1655728948;
 bh=sCLGhjBv8cXl/zBWmTUuMj1EjUf/TBRKwhmY/6vG9jw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=oidSXjwQkExCnQCcl6OnTfeCqs5THK+/AATFIwHlGPa+sUeDc0ak9jAb7NpHcQlz8
 ljPT0eg1PlRAQff0vUKnQkTlGu+lvVaJBzez+qhIjfTCBNTBWiOMmN7Kv65ugqHSyD
 8C8sZwkMwBOnyQAN+SxXNl0wVgfPDQusRnLEwGZY7XumUv1QC7ddWSxF1sKEyXaLyA
 t4wV8DNxLSBC6Ra2zCushYJCT+8QIgc2Suhs7Vmt+pKb5Hljy9B7Kc519ZIum5v29C
 Ndbh5ciGGJ7iVlDWg+eQPqqBxWFzEHXWl+AgFz009GPU5JTjup6jW+46fHBTtq2ZGn
 F/pHVnwk3JwYQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 5/7] arm64/fpsimd: Load FP state based on recorded data type
Date: Mon, 20 Jun 2022 13:41:56 +0100
Message-Id: <20220620124158.482039-6-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620124158.482039-1-broonie@kernel.org>
References: <20220620124158.482039-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2343; h=from:subject;
 bh=sCLGhjBv8cXl/zBWmTUuMj1EjUf/TBRKwhmY/6vG9jw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBisGsRys7u5U+5Z4oKEo2l05zMCH6Tonoz070LzE0z
 FzVyVsqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYrBrEQAKCRAk1otyXVSH0DnVCA
 CAGUP1etILPKlNvThDPZU6Vfq11K47cnSGYP5ldwxz/mt8mDQsS60ZGoBLME8DMxURhYtwNHf7FfRd
 XW3PGQPkVhX1qMeA3B3Xvyrp0yOsOv/Y5wGUZ7bvgoK+EgfGCsEhuhkg+/1offU5YpYnDCDOB93dUc
 9PjmtbDiakxuk5iAVMN1Qtq70R0ArV+7LPIYW5/Jwowcx4oDNhy/SxCmivtopjqmrOZHMEpgoDIFtK
 GQmvVDdFnOPKoqnvXCsMK2SPoml1+zXwLZvq906X20rbLNrhMR+bkZ3IEGzspjECwXLs81BKxF1pOx
 1i+Z42MsabZgFvpMEocGhS/uTyQeGU
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Marc Zyngier <maz@kernel.org>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Mark Brown <broonie@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Now that we are recording the type of floating point register state we
are saving when we save it we can use that information when we load to
decide which register state is required and bring the TIF_SVE state into
sync with the loaded register state.

The SME state detauls are already recorded directly in the saved
SVCR and handled based on the information there.

Since we are not changing any of the save paths there should be no
functional change from this patch, further patches will make use of this
to optimise and clarify the code.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index ebe66d8c66e8..f14452b7a629 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -391,11 +391,38 @@ static void task_fpsimd_load(void)
 	WARN_ON(!system_supports_fpsimd());
 	WARN_ON(!have_cpu_fpsimd_context());
 
-	/* Check if we should restore SVE first */
-	if (IS_ENABLED(CONFIG_ARM64_SVE) && test_thread_flag(TIF_SVE)) {
-		sve_set_vq(sve_vq_from_vl(task_get_sve_vl(current)) - 1);
-		restore_sve_regs = true;
-		restore_ffr = true;
+	if (system_supports_sve()) {
+		switch (current->thread.fp_type) {
+		case FP_STATE_FPSIMD:
+			/* Stop tracking SVE for this task until next use. */
+			if (test_and_clear_thread_flag(TIF_SVE))
+				sve_user_disable();
+			break;
+		case FP_STATE_SVE:
+			/*
+			 * A thread with SVE state should either be in
+			 * streaming mode or already have SVE enabled.
+			 */
+			if (!thread_sm_enabled(&current->thread) &&
+			    !WARN_ON_ONCE(!test_and_set_thread_flag(TIF_SVE)))
+				sve_user_enable();
+
+			sve_set_vq(sve_vq_from_vl(task_get_sve_vl(current)) - 1);
+			restore_sve_regs = true;
+			restore_ffr = true;
+			break;
+		default:
+			/*
+			 * This should never happen, we should always
+			 * record what we saved when we save. We
+			 * always at least have the memory allocated
+			 * for FPSMID registers so try that and hope
+			 * for the best.
+			 */
+			WARN_ON_ONCE(1);
+			clear_thread_flag(TIF_SVE);
+			break;
+		}
 	}
 
 	/* Restore SME, override SVE register configuration if needed */
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
