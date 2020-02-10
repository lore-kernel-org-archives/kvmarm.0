Return-Path: <SRS0=nwVD=36=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF147C352A3
	for <kvmarm@archiver.kernel.org>; Mon, 10 Feb 2020 11:48:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 304B820733
	for <kvmarm@archiver.kernel.org>; Mon, 10 Feb 2020 11:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 304B820733
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A1B94A65C;
	Mon, 10 Feb 2020 06:48:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tmISPLmtFQvQ; Mon, 10 Feb 2020 06:48:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F4B24A588;
	Mon, 10 Feb 2020 06:48:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B9074A51F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb 2020 06:48:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SKCixAOqN9Ls for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Feb 2020 06:48:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8A314A4FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Feb 2020 06:48:02 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67CFF1FB;
 Mon, 10 Feb 2020 03:48:02 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2F8373F6CF;
 Mon, 10 Feb 2020 03:48:01 -0800 (PST)
From: Mark Rutland <mark.rutland@arm.com>
To: maz@kernel.org
Subject: [PATCH] kvm: arm/arm64: fold VHE entry/exit work into
 kvm_vcpu_run_vhe()
Date: Mon, 10 Feb 2020 11:47:57 +0000
Message-Id: <20200210114757.2889-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

With VHE, running a vCPU always requires the sequence:

1. kvm_arm_vhe_guest_enter();
2. kvm_vcpu_run_vhe();
3. kvm_arm_vhe_guest_exit()

... and as we invoke this from the shared arm/arm64 KVM code, 32-bit arm
has to provide stubs for all three functions.

To simplify the common code, and make it easier to make further
modifications to the arm64-specific portions in the near future, let's
fold kvm_arm_vhe_guest_enter() and kvm_arm_vhe_guest_exit() into
kvm_vcpu_run_vhe().

The 32-bit stubs for kvm_arm_vhe_guest_enter() and
kvm_arm_vhe_guest_exit() are removed, as they are no longer used. The
32-bit stub for kvm_vcpu_run_vhe() is left as-is.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm/include/asm/kvm_host.h   |  3 ---
 arch/arm64/include/asm/kvm_host.h | 32 --------------------------------
 arch/arm64/kvm/hyp/switch.c       | 39 +++++++++++++++++++++++++++++++++++++--
 virt/kvm/arm/arm.c                |  2 --
 4 files changed, 37 insertions(+), 39 deletions(-)

Hi Marc,

This is a preparatory patch for the arm64 entry rework I'm doing: I need to
move the DAIF manipulation into the same function so that I can replace that
with a common DAIF+PMR save/restore sequence.

If it's possible to queue this patch for v5.6-rc*, it would help to minimize
conflict in the v5.7 merge window, and would be much appreciated.

I've tested this on a ThunderX2 machine atop v5.6-rc1 defconfig, booting the
host and running a test VM.

Thanks,
Mark.

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index c3314b286a61..a827b4d60d38 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -392,9 +392,6 @@ static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
 
-static inline void kvm_arm_vhe_guest_enter(void) {}
-static inline void kvm_arm_vhe_guest_exit(void) {}
-
 #define KVM_BP_HARDEN_UNKNOWN		-1
 #define KVM_BP_HARDEN_WA_NEEDED		0
 #define KVM_BP_HARDEN_NOT_REQUIRED	1
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d87aa609d2b6..57fd46acd058 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -626,38 +626,6 @@ static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u32 clr) {}
 #endif
 
-static inline void kvm_arm_vhe_guest_enter(void)
-{
-	local_daif_mask();
-
-	/*
-	 * Having IRQs masked via PMR when entering the guest means the GIC
-	 * will not signal the CPU of interrupts of lower priority, and the
-	 * only way to get out will be via guest exceptions.
-	 * Naturally, we want to avoid this.
-	 *
-	 * local_daif_mask() already sets GIC_PRIO_PSR_I_SET, we just need a
-	 * dsb to ensure the redistributor is forwards EL2 IRQs to the CPU.
-	 */
-	pmr_sync();
-}
-
-static inline void kvm_arm_vhe_guest_exit(void)
-{
-	/*
-	 * local_daif_restore() takes care to properly restore PSTATE.DAIF
-	 * and the GIC PMR if the host is using IRQ priorities.
-	 */
-	local_daif_restore(DAIF_PROCCTX_NOIRQ);
-
-	/*
-	 * When we exit from the guest we change a number of CPU configuration
-	 * parameters, such as traps.  Make sure these changes take effect
-	 * before running the host or additional guests.
-	 */
-	isb();
-}
-
 #define KVM_BP_HARDEN_UNKNOWN		-1
 #define KVM_BP_HARDEN_WA_NEEDED		0
 #define KVM_BP_HARDEN_NOT_REQUIRED	1
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index dfe8dd172512..925086b46136 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -625,7 +625,7 @@ static void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 }
 
 /* Switch to the guest for VHE systems running in EL2 */
-int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
+static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
@@ -678,7 +678,42 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	return exit_code;
 }
-NOKPROBE_SYMBOL(kvm_vcpu_run_vhe);
+NOKPROBE_SYMBOL(__kvm_vcpu_run_vhe);
+
+int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	local_daif_mask();
+
+	/*
+	 * Having IRQs masked via PMR when entering the guest means the GIC
+	 * will not signal the CPU of interrupts of lower priority, and the
+	 * only way to get out will be via guest exceptions.
+	 * Naturally, we want to avoid this.
+	 *
+	 * local_daif_mask() already sets GIC_PRIO_PSR_I_SET, we just need a
+	 * dsb to ensure the redistributor is forwards EL2 IRQs to the CPU.
+	 */
+	pmr_sync();
+
+	ret = __kvm_vcpu_run_vhe(vcpu);
+
+	/*
+	 * local_daif_restore() takes care to properly restore PSTATE.DAIF
+	 * and the GIC PMR if the host is using IRQ priorities.
+	 */
+	local_daif_restore(DAIF_PROCCTX_NOIRQ);
+
+	/*
+	 * When we exit from the guest we change a number of CPU configuration
+	 * parameters, such as traps.  Make sure these changes take effect
+	 * before running the host or additional guests.
+	 */
+	isb();
+
+	return ret;
+}
 
 /* Switch to the guest for legacy non-VHE systems */
 int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index d65a0faa46d8..eda7b624eab8 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -742,9 +742,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		guest_enter_irqoff();
 
 		if (has_vhe()) {
-			kvm_arm_vhe_guest_enter();
 			ret = kvm_vcpu_run_vhe(vcpu);
-			kvm_arm_vhe_guest_exit();
 		} else {
 			ret = kvm_call_hyp_ret(__kvm_vcpu_run_nvhe, vcpu);
 		}
-- 
2.11.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
