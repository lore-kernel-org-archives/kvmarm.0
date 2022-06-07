Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA19FC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 13:23:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 606444B367;
	Tue,  7 Jun 2022 09:23:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PS+04VjVogi2; Tue,  7 Jun 2022 09:23:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 368304B375;
	Tue,  7 Jun 2022 09:23:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78F464B2E6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:23:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6Lgomq0yNitj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 09:23:39 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B59B84B2AE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:23:38 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 32E2761447;
 Tue,  7 Jun 2022 13:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83739C341C0;
 Tue,  7 Jun 2022 13:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654608217;
 bh=QzUVFo4IuojTMAuIaRZDh+Ukfi7rswOZ0KmMJjXT/CQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=VhZZnyhX0LHvcxPQN+4rDAarKWVvCT46lp7Qkuu4x4Z55i5dvrCXRCvovBHAcGaco
 O7fYA8attvQF7tHXa1FsngmRyksT9C4ZdWHfTjeKpSCdtmOIAnIJn5B+R6D/yCgDCw
 qfLXZXGKraFF3/ZXHE6anizVB/9KD0QhWr4DmH3elbmyKnKjAb782b0ZSjFhamVW7h
 uPd2+PRyOh5BikGzqsXwgKU0EL5n71qIbaZAzDDBxwi1zDcmoVpzKazt0gof3pLsdc
 jy2mpsMu8SmsSusCbLbPt8trMyGEeuQU99NxIfWxUhr9pnQNznbgpiWleoDusgbGY9
 E4+Fq2DeqaRcA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v1 5/7] arm64/fpsimd: Load FP state based on recorded data type
Date: Tue,  7 Jun 2022 14:17:33 +0100
Message-Id: <20220607131735.1300726-6-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220607131735.1300726-1-broonie@kernel.org>
References: <20220607131735.1300726-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2267; h=from:subject;
 bh=QzUVFo4IuojTMAuIaRZDh+Ukfi7rswOZ0KmMJjXT/CQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBin0/rv2V3s96vs41VQQPjmo95LPpkX8aheQ32A5+r
 MQMq2neJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYp9P6wAKCRAk1otyXVSH0HL2B/
 96PQQfRB3za86wUPR5LBamcaC59ek28smgsCHyXKyvodjmm6XEFmXQHQ9AvgH/jZai895/Z8C0N93t
 vjKCpjLyJ0JPVMHnzpB4aNQ4V4gKximi0o5QP+d+/a09jyHsNRyptHaTFycPQzcx3TkNkG2hv40GBe
 3Do1OXAVP05s/i2R2v2irhabBMOM0q+naAcfM8yd4CSzU+kEak76ifL9HGoy1rWwcLQ7Y49n3thiZY
 LEA0jC1b/LvDoRMBGUx0AXaPjKiOLvLdz3ejVxXaIFOcbhwhODG5z3Pjo74wH9TQ5tWrQpaR19nPwn
 p+Alx4R9Obcel2JwBCSb6wFmAObTnZ
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
 arch/arm64/kernel/fpsimd.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index aa23bd855414..e7d5eea39e0c 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -389,11 +389,37 @@ static void task_fpsimd_load(void)
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
+			 * A thread without SVE enabled should not
+			 * have saved SVE state.
+			 */
+			if (!WARN_ON_ONCE(!test_and_set_thread_flag(TIF_SVE)))
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
