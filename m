Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D00C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  7 Feb 2022 15:24:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6F27407ED;
	Mon,  7 Feb 2022 10:24:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jBZojvokCvs6; Mon,  7 Feb 2022 10:24:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A20740BF0;
	Mon,  7 Feb 2022 10:24:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23938407ED
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:24:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id INyLYy5nAExn for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 10:24:09 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF6E249EB5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 10:24:08 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id EDE51B815A6;
 Mon,  7 Feb 2022 15:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0626C340F0;
 Mon,  7 Feb 2022 15:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644247446;
 bh=3ak/TkOEva2A1EWWMZ6rEAo+xuM7bHsmgGI8j+vb0mA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=HSeK0+hglpkeQ+ybvXtdF3aTR8lC+9v2dcFxSHi+6XKrkcFbZfmq0ruFdbY+tfire
 78HpG1QUJ6y5MTmq6+WnLZfmH1WJW0Y8rkNRrLMUhnRmKBB84uQJTweSjs3qJ5DRTt
 D50Go8eGCliElsmX784j6Ghewqky2o+kuIdW8mpnd961j5gudCErq80EVcYZkIcDkW
 Xh4RN+0dEJfx3/DU6QfB2njXxZ+C2DyfDvnBsAAXbDm2Qnn7k6ZGisN3CyuEEY245J
 hf1Lth5c1g1CKqjpQhig7NCM4vPxZWE9LlkkqjaPobqFy3/HWk+WRJEEweh7k28CNg
 f6HycjtuGordw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v11 15/40] arm64/sme: Implement SVCR context switching
Date: Mon,  7 Feb 2022 15:20:44 +0000
Message-Id: <20220207152109.197566-16-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207152109.197566-1-broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6142; h=from:subject;
 bh=3ak/TkOEva2A1EWWMZ6rEAo+xuM7bHsmgGI8j+vb0mA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiATjQxHICk/aRefIWC+RRWEwIqJy9Ttg8s+gBA7Ye
 7XUSftuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYgE40AAKCRAk1otyXVSH0Bz2B/
 41/or6wJnJWLV0WkgGyQT8I0f8OnsMLtBUv0hk9K4RLkwXVh6lUPytIWi4PUyECInGqbVTlTbn/3fi
 vjyJivi2pQXY/60bmEb2/nze0Yd1M2nWTNgxrx6sskYBf1jJKDfYYx+fd1ZCM3ptp/6mcc5J4TLa7L
 i07xzAsUKUpKh5HYH0vrqsaH1iw8I2jpjFSv404pLNvV34YPSje7KNpKT6+kCiDLGQg/jDlL39lmc0
 ca1gHWcTxWv6Fdb61Fcqmd3vhsF1+Joxa3kz4PIliPpTSHAsCwqO/oALhMTVN6LFO4Q56o4sYlsEyD
 hiqKKU9P4atiI78Qm2va4sIjP3dIiK
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

In SME the use of both streaming SVE mode and ZA are tracked through
PSTATE.SM and PSTATE.ZA, visible through the system register SVCR.  In
order to context switch the floating point state for SME we need to
context switch the contents of this register as part of context
switching the floating point state.

Since changing the vector length exits streaming SVE mode and disables
ZA we also make sure we update SVCR appropriately when setting vector
length, and similarly ensure that new threads have streaming SVE mode
and ZA disabled.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h      |  3 ++-
 arch/arm64/include/asm/processor.h   |  1 +
 arch/arm64/include/asm/thread_info.h |  1 +
 arch/arm64/kernel/fpsimd.c           | 18 +++++++++++++++++-
 arch/arm64/kernel/process.c          |  2 ++
 arch/arm64/kvm/fpsimd.c              |  4 ++++
 6 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index babf944e7c0c..d1bae65d3dba 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -46,7 +46,8 @@ extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
 
 extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
-				     void *sve_state, unsigned int sve_vl);
+				     void *sve_state, unsigned int sve_vl,
+				     u64 *svcr);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
 extern void fpsimd_save_and_flush_cpu_state(void);
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 008a1767ebff..7e08a4d48c24 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -168,6 +168,7 @@ struct thread_struct {
 	u64			mte_ctrl;
 #endif
 	u64			sctlr_user;
+	u64			svcr;
 	u64			tpidr2_el0;
 };
 
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 4e6b58dcd6f9..848739c15de8 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -82,6 +82,7 @@ int arch_dup_task_struct(struct task_struct *dst,
 #define TIF_SVE_VL_INHERIT	24	/* Inherit SVE vl_onexec across exec */
 #define TIF_SSBD		25	/* Wants SSB mitigation */
 #define TIF_TAGGED_ADDR		26	/* Allow tagged user addresses */
+#define TIF_SME			27	/* SME in use */
 #define TIF_SME_VL_INHERIT	28	/* Inherit SME vl_onexec across exec */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 40ef89120774..a1918b71d335 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -121,6 +121,7 @@
 struct fpsimd_last_state_struct {
 	struct user_fpsimd_state *st;
 	void *sve_state;
+	u64 *svcr;
 	unsigned int sve_vl;
 };
 
@@ -359,6 +360,9 @@ static void task_fpsimd_load(void)
 	WARN_ON(!system_supports_fpsimd());
 	WARN_ON(!have_cpu_fpsimd_context());
 
+	if (IS_ENABLED(CONFIG_ARM64_SME) && test_thread_flag(TIF_SME))
+		write_sysreg_s(current->thread.svcr, SYS_SVCR_EL0);
+
 	if (IS_ENABLED(CONFIG_ARM64_SVE) && test_thread_flag(TIF_SVE)) {
 		sve_set_vq(sve_vq_from_vl(task_get_sve_vl(current)) - 1);
 		sve_load_state(sve_pffr(&current->thread),
@@ -384,6 +388,12 @@ static void fpsimd_save(void)
 	if (test_thread_flag(TIF_FOREIGN_FPSTATE))
 		return;
 
+	if (IS_ENABLED(CONFIG_ARM64_SME) &&
+	    test_thread_flag(TIF_SME)) {
+		u64 *svcr = last->svcr;
+		*svcr = read_sysreg_s(SYS_SVCR_EL0);
+	}
+
 	if (IS_ENABLED(CONFIG_ARM64_SVE) &&
 	    test_thread_flag(TIF_SVE)) {
 		if (WARN_ON(sve_get_vl() != last->sve_vl)) {
@@ -735,6 +745,10 @@ int vec_set_vector_length(struct task_struct *task, enum vec_type type,
 	if (test_and_clear_tsk_thread_flag(task, TIF_SVE))
 		sve_to_fpsimd(task);
 
+	if (system_supports_sme() && type == ARM64_VEC_SME)
+		task->thread.svcr &= ~(SYS_SVCR_EL0_SM_MASK |
+				       SYS_SVCR_EL0_ZA_MASK);
+
 	if (task == current)
 		put_cpu_fpsimd_context();
 
@@ -1398,6 +1412,7 @@ static void fpsimd_bind_task_to_cpu(void)
 	last->st = &current->thread.uw.fpsimd_state;
 	last->sve_state = current->thread.sve_state;
 	last->sve_vl = task_get_sve_vl(current);
+	last->svcr = &current->thread.svcr;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	if (system_supports_sve()) {
@@ -1412,7 +1427,7 @@ static void fpsimd_bind_task_to_cpu(void)
 }
 
 void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
-			      unsigned int sve_vl)
+			      unsigned int sve_vl, u64 *svcr)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1421,6 +1436,7 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
 	last->st = st;
+	last->svcr = svcr;
 	last->sve_state = sve_state;
 	last->sve_vl = sve_vl;
 }
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index e69a3dcdb0d9..f2d32a29641c 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -310,6 +310,8 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 	dst->thread.sve_state = NULL;
 	clear_tsk_thread_flag(dst, TIF_SVE);
 
+	dst->thread.svcr = 0;
+
 	/* clear any pending asynchronous tag fault raised by the parent */
 	clear_tsk_thread_flag(dst, TIF_MTE_ASYNC_FAULT);
 
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 2f48fd362a8c..04698c4bcd30 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -103,6 +103,10 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
+		/*
+		 * Currently we do not support SME guests so SVCR is
+		 * always 0 and we just need a variable to point to.
+		 */
 		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.fp_regs,
 					 vcpu->arch.sve_state,
 					 vcpu->arch.sve_max_vl);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
