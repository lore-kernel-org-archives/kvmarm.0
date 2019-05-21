Return-Path: <SRS0=AfIE=TV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C76F6C04AAF
	for <kvmarm@archiver.kernel.org>; Tue, 21 May 2019 17:22:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 82304217D7
	for <kvmarm@archiver.kernel.org>; Tue, 21 May 2019 17:22:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82304217D7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27EA54A51B;
	Tue, 21 May 2019 13:22:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OwV5uHUCZUsX; Tue, 21 May 2019 13:22:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC8944A518;
	Tue, 21 May 2019 13:22:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B20B04A515
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 May 2019 13:21:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XSaT+td0qsLR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 May 2019 13:21:58 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4241E4A47E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 May 2019 13:21:58 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEA4115A2;
 Tue, 21 May 2019 10:21:57 -0700 (PDT)
Received: from e108454-lin.cambridge.arm.com (e108454-lin.cambridge.arm.com
 [10.1.196.50])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76F4A3F718;
 Tue, 21 May 2019 10:21:55 -0700 (PDT)
From: Julien Grall <julien.grall@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 2/3] arch/arm64: fpsimd: Introduce
 fpsimd_save_and_flush_cpu_state() and use it
Date: Tue, 21 May 2019 18:21:38 +0100
Message-Id: <20190521172139.21277-3-julien.grall@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190521172139.21277-1-julien.grall@arm.com>
References: <20190521172139.21277-1-julien.grall@arm.com>
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com,
 will.deacon@arm.com, Julien Grall <julien.grall@arm.com>, Dave.Martin@arm.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The only external user of fpsimd_save() and fpsimd_flush_cpu_state() is
the KVM FPSIMD code.

A following patch will introduce a mechanism to acquire owernship of the
FPSIMD/SVE context for performing context management operations. Rather
than having to export the new helpers to get/put the context, we can just
introduce a new function to combine fpsimd_save() and
fpsimd_flush_cpu_state().

This has also the advantage to remove any external call of fpsimd_save()
and fpsimd_flush_cpu_state(), so they can be turned static.

Lastly, the new function can also be used in the PM notifier.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>

---
    kernel_neon_begin() does not use fpsimd_save_and_flush_cpu_state()
    because the next patch will modify the function to also grab the
    FPSIMD/SVE context.

    Changes in v4:
        - Remove newline before the new prototype
        - Add Dave's reviewed-by

    Changes in v3:
        - Rework the commit message
        - Move the prototype of fpsimd_save_and_flush_cpu_state()
        further down in the header
        - Remove comment in kvm_arch_vcpu_put_fp()

    Changes in v2:
        - Patch added
---
 arch/arm64/include/asm/fpsimd.h |  4 +---
 arch/arm64/kernel/fpsimd.c      | 17 +++++++++++++----
 arch/arm64/kvm/fpsimd.c         |  4 +---
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index b73d12fcc7f9..4154851c21ab 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -48,8 +48,6 @@ struct task_struct;
 extern void fpsimd_save_state(struct user_fpsimd_state *state);
 extern void fpsimd_load_state(struct user_fpsimd_state *state);
 
-extern void fpsimd_save(void);
-
 extern void fpsimd_thread_switch(struct task_struct *next);
 extern void fpsimd_flush_thread(void);
 
@@ -63,7 +61,7 @@ extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
 				     void *sve_state, unsigned int sve_vl);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
-extern void fpsimd_flush_cpu_state(void);
+extern void fpsimd_save_and_flush_cpu_state(void);
 
 /* Maximum VL that SVE VL-agnostic software can transparently support */
 #define SVE_VL_ARCH_MAX 0x100
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index a38bf74bcca8..6448921a2f59 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -246,7 +246,7 @@ static void task_fpsimd_load(void)
  *
  * Softirqs (and preemption) must be disabled.
  */
-void fpsimd_save(void)
+static void fpsimd_save(void)
 {
 	struct fpsimd_last_state_struct const *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1122,12 +1122,22 @@ void fpsimd_flush_task_state(struct task_struct *t)
  * Invalidate any task's FPSIMD state that is present on this cpu.
  * This function must be called with softirqs disabled.
  */
-void fpsimd_flush_cpu_state(void)
+static void fpsimd_flush_cpu_state(void)
 {
 	__this_cpu_write(fpsimd_last_state.st, NULL);
 	set_thread_flag(TIF_FOREIGN_FPSTATE);
 }
 
+/*
+ * Save the FPSIMD state to memory and invalidate cpu view.
+ * This function must be called with softirqs (and preemption) disabled.
+ */
+void fpsimd_save_and_flush_cpu_state(void)
+{
+	fpsimd_save();
+	fpsimd_flush_cpu_state();
+}
+
 #ifdef CONFIG_KERNEL_MODE_NEON
 
 DEFINE_PER_CPU(bool, kernel_neon_busy);
@@ -1284,8 +1294,7 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
 {
 	switch (cmd) {
 	case CPU_PM_ENTER:
-		fpsimd_save();
-		fpsimd_flush_cpu_state();
+		fpsimd_save_and_flush_cpu_state();
 		break;
 	case CPU_PM_EXIT:
 		break;
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 6e3c9c8b2df9..525010504f9d 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -112,9 +112,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
 		u64 *guest_zcr = &vcpu->arch.ctxt.sys_regs[ZCR_EL1];
 
-		/* Clean guest FP state to memory and invalidate cpu view */
-		fpsimd_save();
-		fpsimd_flush_cpu_state();
+		fpsimd_save_and_flush_cpu_state();
 
 		if (guest_has_sve)
 			*guest_zcr = read_sysreg_s(SYS_ZCR_EL12);
-- 
2.11.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
