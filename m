Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4DDC25B08
	for <kvmarm@archiver.kernel.org>; Mon, 15 Aug 2022 22:58:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 829624D870;
	Mon, 15 Aug 2022 18:58:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o+1bWQRf70wc; Mon, 15 Aug 2022 18:58:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CBD14D893;
	Mon, 15 Aug 2022 18:58:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D2B44D869
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hS7oQiHIZnDv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Aug 2022 18:58:10 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EB6164D870
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:09 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id AE94C612C8;
 Mon, 15 Aug 2022 22:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAEFC43142;
 Mon, 15 Aug 2022 22:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1660604288;
 bh=823IuBZN/UQBWZKcE77mIapeCPQvkiuDby1PUeAxHQk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=PryybBb9ZIt6BB13lQMXZxhb+KSTjF3wEtABm8oJGzp2rEkQbGmxdrTrLRbJ1P06r
 UC6/Y8GxLldPMmGu6r22sPggOhwI/+1y1ahB/FVWrm0KQt03Y8wlbHwb2Sp6RPIRG6
 KYRz/QySif+S9eN+o3dt3BaVGzUQ9oeJUjGy9vxcIyfA1C97EENS23xX0eEMDlEJoV
 iI01VnWc/E//UGIxmhroRmorQ2aaa5OjjbxgpHJBE6at3oJ7r4wrnmLFfBGQRnUb7q
 67f54vrrIpL7ItSdaJYieF+/1HuwgtqmCqJ/N5qc0X+xuspstoWwYCkgYfgzaEaAFX
 VxCN0Ikelckvw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 1/7] KVM: arm64: Discard any SVE state when entering KVM
 guests
Date: Mon, 15 Aug 2022 23:55:23 +0100
Message-Id: <20220815225529.930315-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815225529.930315-1-broonie@kernel.org>
References: <20220815225529.930315-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2925; i=broonie@kernel.org;
 h=from:subject; bh=823IuBZN/UQBWZKcE77mIapeCPQvkiuDby1PUeAxHQk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBi+s7amhSF70GLC1s3r6PC8tLEwnpZe6ROW9vphpBD
 6SVOdPCJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYvrO2gAKCRAk1otyXVSH0A2tB/
 0RG1cYJZdBUPkZgtJwaeQIv0OMi1+b3wNUmlqzveht4ypsLJQKu4mAnrF0ugyPRoYobgEiGJxLRKmL
 +/WPuigBEgmXV1N4ITZY7l2dXfja0ODO91+MzB0RLncFgiaJpk4OITKFs1h+tHaE3Dz0SNyppmxZxa
 YlnqsfSVSPc1onzAZB8K+mHTs/JNJozM1zMcJ8W6+LTnBWR7d89MnPqA43Rwq4uG2ESq+HBWmNNeGC
 Kr38kgvmsftsxLvcchJqOur7oHNbByxm4REzf4MLDMtlPybmkYrZIkecxC4wmeQgx+g1JGiUVgSKde
 ZwRC6ef/ODe986bK8BqZwWN37PS4cV
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

Since 8383741ab2e773a99 (KVM: arm64: Get rid of host SVE tracking/saving)
KVM has not tracked the host SVE state, relying on the fact that we
currently disable SVE whenever we perform a syscall. This may not be true
in future since performance optimisation may result in us keeping SVE
enabled in order to avoid needing to take access traps to reenable it.
Handle this by clearing TIF_SVE and converting the stored task state to
FPSIMD format when preparing to run the guest.  This is done with a new
call fpsimd_kvm_prepare() to keep the direct state manipulation
functions internal to fpsimd.c.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h |  1 +
 arch/arm64/kernel/fpsimd.c      | 23 +++++++++++++++++++++++
 arch/arm64/kvm/fpsimd.c         |  3 ++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 6f86b7ab6c28..c07e4abaca3d 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -56,6 +56,7 @@ extern void fpsimd_signal_preserve_current_state(void);
 extern void fpsimd_preserve_current_state(void);
 extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
+extern void fpsimd_kvm_prepare(void);
 
 extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
 				     void *sve_state, unsigned int sve_vl,
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 23834d96d1e7..549e11645e0f 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1627,6 +1627,29 @@ void fpsimd_signal_preserve_current_state(void)
 		sve_to_fpsimd(current);
 }
 
+/*
+ * Called by KVM when entering the guest.
+ */
+void fpsimd_kvm_prepare(void)
+{
+	if (!system_supports_sve())
+		return;
+
+	/*
+	 * KVM does not save host SVE state since we can only enter
+	 * the guest from a syscall so the ABI means that only the
+	 * non-saved SVE state needs to be saved.  If we have left
+	 * SVE enabled for performance reasons then update the task
+	 * state to be FPSIMD only.
+	 */
+	get_cpu_fpsimd_context();
+
+	if (test_and_clear_thread_flag(TIF_SVE))
+		sve_to_fpsimd(current);
+
+	put_cpu_fpsimd_context();
+}
+
 /*
  * Associate current's FPSIMD context with this cpu
  * The caller must have ownership of the cpu FPSIMD context before calling
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index ec8e4494873d..1c1b309ef420 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -75,7 +75,8 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 {
 	BUG_ON(!current->mm);
-	BUG_ON(test_thread_flag(TIF_SVE));
+
+	fpsimd_kvm_prepare();
 
 	if (!system_supports_fpsimd())
 		return;
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
