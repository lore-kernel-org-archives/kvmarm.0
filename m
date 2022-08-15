Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49967C25B0D
	for <kvmarm@archiver.kernel.org>; Mon, 15 Aug 2022 22:58:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04D1B4D883;
	Mon, 15 Aug 2022 18:58:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rzAFiYPd4UuS; Mon, 15 Aug 2022 18:58:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C91924D8B6;
	Mon, 15 Aug 2022 18:58:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8861A4D896
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5k8QCaddK+QH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Aug 2022 18:58:21 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDE3E4D8C4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:19 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 4FCF16129A;
 Mon, 15 Aug 2022 22:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA33C433C1;
 Mon, 15 Aug 2022 22:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1660604298;
 bh=qGPDpCXz2YL6dN3kNIjYGBAtKEVpNxINegywa4hHB4E=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=UlSkCdmkIfnXiUbyt7AkHw4deL0uSiijrNq6FIu/moq2zwt06/P0d96rzJ5E33F+9
 sTcZ7xpcFpbvKwdNWi+kjeZ+qkOoyZxSYxKFGlqBb2uwtjQmG3HPNo5EKGgxV1vFjC
 j+j5bp3Zxs83vn18TEYfnssGg6gFamsfya/EGZk/0/9QBUi/7NeYckfBZRaAUwJAyk
 uinIzyYWZZi2GM6s5nwhIqFJVGTHrzfkRQgPxuAo3i3A0NGa7Cx+FLWq+PkLubyQCb
 /CFPSk5TOla8KNA6TXocW5+fQ05D0U2A3tEco4cM6P62GbvXdz5FYqp0PWVh2ePh4T
 BVitBz+Ob9eCA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 5/7] arm64/fpsimd: Load FP state based on recorded data type
Date: Mon, 15 Aug 2022 23:55:27 +0100
Message-Id: <20220815225529.930315-6-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815225529.930315-1-broonie@kernel.org>
References: <20220815225529.930315-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2620; i=broonie@kernel.org;
 h=from:subject; bh=qGPDpCXz2YL6dN3kNIjYGBAtKEVpNxINegywa4hHB4E=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBi+s7eAyrM11iPSB6OoF3I3XTgzayVC16Om6CyNAyc
 DsPlAiWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYvrO3gAKCRAk1otyXVSH0C0vB/
 4p+JHgeEeitXp8EoNT8FEgntgYRNJ7UScZMT2ZW3oaNrwHA7QkbvMPzjbaBkEwGEgP1ICxb/6n0HGJ
 mWa9ZUz2CRsvtN06rQDoVMpw/nUxwge/TZrm3jtab8UpVzT2qNzfkfjdc7fK2UJTfwHqy68MHCV/RP
 ezLQafae8pLmcwZZZ3Ktf1YTx3q3NMVGuwo6IhejTlr7u7jow7eROc4V2R2aroa5C6o8andzwWwXA1
 pKz1BvB3evXwjYYHxhk30yBC3MGFFW/mqpuli5tlILmah7s3MtqeUJsSsMiCsEZodgtveKTc4fmvML
 cm3mWtdD5DExO1ad49d+stwzGCUI+b
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
 arch/arm64/kernel/fpsimd.c | 39 ++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index aaea2dc02cbd..4096530dd4c6 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -392,11 +392,36 @@ static void task_fpsimd_load(void)
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
+			if (!thread_sm_enabled(&current->thread) &&
+			    !WARN_ON_ONCE(!test_and_set_thread_flag(TIF_SVE)))
+				sve_user_enable();
+
+			if (test_thread_flag(TIF_SVE))
+				sve_set_vq(sve_vq_from_vl(task_get_sve_vl(current)) - 1);
+
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
@@ -412,10 +437,8 @@ static void task_fpsimd_load(void)
 		if (thread_za_enabled(&current->thread))
 			za_load_state(current->thread.za_state);
 
-		if (thread_sm_enabled(&current->thread)) {
-			restore_sve_regs = true;
+		if (thread_sm_enabled(&current->thread))
 			restore_ffr = system_supports_fa64();
-		}
 	}
 
 	if (restore_sve_regs) {
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
