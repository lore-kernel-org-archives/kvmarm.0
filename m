Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B33C43334
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 12:42:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B2A34B27B;
	Mon, 20 Jun 2022 08:42:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ol6StNgy6b36; Mon, 20 Jun 2022 08:42:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C3254B282;
	Mon, 20 Jun 2022 08:42:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0A874B4DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uglfD7IKKPg7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 08:42:27 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AB8A4B4E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:27 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id CA9AD6149E;
 Mon, 20 Jun 2022 12:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C19C3411C;
 Mon, 20 Jun 2022 12:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1655728946;
 bh=L6RJvcYmGpyN41lsIb62MkEkWZtrLa0waSWlt5gfaeE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=NmaVZ/rFKq/a7URvwiVint9SqyJhn09Nt5TCTRJ5yrEJkV2sxD1Xl1Ehxt+/wg8pc
 jOEH2FkXUlkIE0PEppeVcCg5nUBUt/ax7L6vVtdWPDSR1xXdi0RjA/UaY7mfLll1k3
 64QFOtLddeP0kg5UFCvZke+xXA6sAKWwu7GhOPqvPubKX0uYaX/8I6StJQ5isYOGGb
 7g8x4o6BAEy017oVZXGTVYqpdidaIAnrWcqtidBtVGCRMAD2JFgCFjw1UYbp9QWp/i
 tYp8rYJPJUrfr7Kcsft5NW/3bpT24egABizC2Y4niCWf4sT2+JqeqFQX81PTix4Aet
 JGgW+Djr7feWw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 4/7] arm64/fpsimd: Stop using TIF_SVE to manage register
 saving in KVM
Date: Mon, 20 Jun 2022 13:41:55 +0100
Message-Id: <20220620124158.482039-5-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620124158.482039-1-broonie@kernel.org>
References: <20220620124158.482039-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2656; h=from:subject;
 bh=L6RJvcYmGpyN41lsIb62MkEkWZtrLa0waSWlt5gfaeE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBisGsQsPwNi5MAdIAtnN/L2q4kj5eOfXLc1owMgq/a
 LuoIFwGJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYrBrEAAKCRAk1otyXVSH0Mm2B/
 oChsEN/CBdHuIEkrm7mS8sjc0MaWDa+VGlviG8sBVmH4nwhQEJcFq2/DLAXL3ezBTznPL+gYTMgEkJ
 DHIp/g8NiSbyH094QNDMwDBeV1fP7BrDh+QfI1jVwjK6XclNi9+ktO5o68bMjdVIVwr0zWij9ha1qW
 w56ySAGzw4AT1tHKIO20r0j9KOmThLBnjsYR2+flK/nYOWWlc4NhSmx1/pVEd2yPXf807sCSuKIjLp
 TMorH8tgf0CY5MFGG2+wE9PuohStqHPuq/xmCwW25/qLTSiALYabRJbwIOCpFuRPNt49tVLfceMv7z
 ga1h3r2LBXWauLT9Pdxd7rFQM05An4
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

Now that we are explicitly telling the host FP code which register state
it needs to save we can remove the manipulation of TIF_SVE from the KVM
code, simplifying it and allowing us to optimise our handling of normal
tasks. Remove the manipulation of TIF_SVE from KVM and instead rely on
to_save to ensure we save the correct data for it.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/fpsimd.c | 22 ++++------------------
 arch/arm64/kvm/fpsimd.c    |  3 ---
 2 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 95c95411bd42..ebe66d8c66e8 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -435,8 +435,8 @@ static void task_fpsimd_load(void)
  * last, if KVM is involved this may be the guest VM context rather
  * than the host thread for the VM pointed to by current. This means
  * that we must always reference the state storage via last rather
- * than via current, other than the TIF_ flags which KVM will
- * carefully maintain for us.
+ * than via current, if we are saving KVM state then it will have
+ * ensured that the type of registers to save is set in last->to_save.
  */
 static void fpsimd_save(void)
 {
@@ -453,27 +453,13 @@ static void fpsimd_save(void)
 	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
 		return;
 
-	if (test_thread_flag(TIF_SVE)) {
+	if ((last->to_save == FP_STATE_TASK && test_thread_flag(TIF_SVE)) ||
+	    last->to_save == FP_STATE_SVE) {
 		save_sve_regs = true;
 		save_ffr = true;
 		vl = last->sve_vl;
 	}
 
-	/*
-	 * For now we're just validating that the requested state is
-	 * consistent with what we'd otherwise work out.
-	 */
-	switch (last->to_save) {
-	case FP_STATE_TASK:
-		break;
-	case FP_STATE_FPSIMD:
-		WARN_ON_ONCE(save_sve_regs);
-		break;
-	case FP_STATE_SVE:
-		WARN_ON_ONCE(!save_sve_regs);
-		break;
-	}
-
 	if (system_supports_sme()) {
 		u64 *svcr = last->svcr;
 		*svcr = read_sysreg_s(SYS_SVCR);
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 542c71b16451..54131a57130e 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -150,7 +150,6 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 					 &vcpu->arch.fp_type, fp_type);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
-		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));
 	}
 }
 
@@ -207,7 +206,5 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
 	}
 
-	update_thread_flag(TIF_SVE, 0);
-
 	local_irq_restore(flags);
 }
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
