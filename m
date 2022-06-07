Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EADA5C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 13:23:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A543E4B32E;
	Tue,  7 Jun 2022 09:23:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H8dGrQnUGaZL; Tue,  7 Jun 2022 09:23:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81DD24B352;
	Tue,  7 Jun 2022 09:23:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 480A24B2CC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:23:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fP+shyMs9WqA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 09:23:37 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E543F4B35D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:23:36 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id A2A0E612D2;
 Tue,  7 Jun 2022 13:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0593C3411F;
 Tue,  7 Jun 2022 13:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654608215;
 bh=9GaoGFxstBMQL0vg6niStdUGr6CJ/XF+w7cock9Rbz0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=RI6yYWKgZnr4ma39VsAmG7px4i9NBut7Y3IZLQhbrUGbPdX7eVrIiLx56eOHZRxs3
 001XYyOHFKBaz+30TnV0YwZqMjpt2hDF5+FV9KYtzwQPiOY+WGksfEbUfZdt754I82
 vlSjWwrsVzdewITT3fx/TQRzUqfNSGGm2vRv8ceb6MDP7mprPq6nIn2v1DAoSf4Hya
 L/5YAZLuLTYV9y82rhEVL41E7DlXu8U8befu6F3VwpNVGCNd0kVKO2m8ovlmSUmWyW
 tZixhd1LK22MNYLDfyCSr9LXSpJIlwTVx/W0UGJAcTLlKekSrez+Lx3JdJGu5wl0zf
 UXtCOCl7LaPDg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v1 4/7] arm64/fpsimd: Stop using TIF_SVE to manage register
 saving in KVM
Date: Tue,  7 Jun 2022 14:17:32 +0100
Message-Id: <20220607131735.1300726-5-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220607131735.1300726-1-broonie@kernel.org>
References: <20220607131735.1300726-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2656; h=from:subject;
 bh=9GaoGFxstBMQL0vg6niStdUGr6CJ/XF+w7cock9Rbz0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBin0/qmcOVb7R+bgdungw25juB59UnxuVZm2t1fpC6
 LqppihuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYp9P6gAKCRAk1otyXVSH0M+QB/
 4yhG1fioHRrxEeQ/KiBqB0Rov6AtsualfXlCjoKugUu7Fwq1P5i7Q+N/KokR9x38rz2kBHx7VNvFHy
 XeYMA/01ni//G6T0NV9KfslhNyo06htF+SVu+qYk/OCerkNoqP4f83aSMbqrt9fiy6C+7eeYssyM1v
 xtMKka8R0Zc/NZhteRhZ1s3yFynebF6729L+wwF3JiOrHhEnvggAn/IOoz7biviHWfJPSapdKcElS1
 i/zxeOWClD5RAZiyA5Q5TnhJ/qNOBpKc3toBw59sQjKH5EhO452cZFQyLRglQDSoVZGXuLLDlRPqkr
 VzScSiu0LcUcERWycRvW4PWlcGcfkj
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
index f23be4247e75..aa23bd855414 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -433,8 +433,8 @@ static void task_fpsimd_load(void)
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
@@ -451,27 +451,13 @@ static void fpsimd_save(void)
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
index b614aa3f8266..77af63e0b177 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -148,7 +148,6 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 					 &vcpu->arch.fp_type, fp_type);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
-		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));
 	}
 }
 
@@ -205,7 +204,5 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
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
