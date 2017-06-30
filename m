From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 21/58] KVM: arm/arm64: Move timer IRQ default init to
 arch_timer.c
Date: Fri, 30 Jun 2017 09:44:37 +0100
Message-ID: <20170630084514.6779-22-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB24240D16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vkqLIkt8hxUb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:46:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4553641005
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:27 -0400 (EDT)
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Stefan Traby <stefan@hello-penguin.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Hu Huajun <huhuajun@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

We currently initialize the arch timer IRQ numbers from the reset code,
presumably because we once intended to model multiple CPU or SoC types
from within the kernel and have hard-coded reset values in the reset
code.

As we are moving towards userspace being in charge of more fine-grained
CPU emulation and stitching together the pieces needed to emulate a
particular type of CPU, we should no longer have a tight coupling
between resetting a VCPU and setting IRQ numbers.

Therefore, move the logic to define and use the default IRQ numbers to
the timer code and set the IRQ number immediately when creating the
VCPU.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/reset.c         | 16 +---------------
 arch/arm64/kvm/reset.c       | 16 +---------------
 include/kvm/arm_arch_timer.h |  4 +---
 virt/kvm/arm/arch_timer.c    | 28 ++++++++++++++++------------
 4 files changed, 19 insertions(+), 45 deletions(-)

diff --git a/arch/arm/kvm/reset.c b/arch/arm/kvm/reset.c
index 1da8b2d14550..5ed0c3ee33d6 100644
--- a/arch/arm/kvm/reset.c
+++ b/arch/arm/kvm/reset.c
@@ -37,16 +37,6 @@ static struct kvm_regs cortexa_regs_reset = {
 	.usr_regs.ARM_cpsr = SVC_MODE | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT,
 };
 
-static const struct kvm_irq_level cortexa_ptimer_irq = {
-	{ .irq = 30 },
-	.level = 1,
-};
-
-static const struct kvm_irq_level cortexa_vtimer_irq = {
-	{ .irq = 27 },
-	.level = 1,
-};
-
 
 /*******************************************************************************
  * Exported reset function
@@ -62,16 +52,12 @@ static const struct kvm_irq_level cortexa_vtimer_irq = {
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_regs *reset_regs;
-	const struct kvm_irq_level *cpu_vtimer_irq;
-	const struct kvm_irq_level *cpu_ptimer_irq;
 
 	switch (vcpu->arch.target) {
 	case KVM_ARM_TARGET_CORTEX_A7:
 	case KVM_ARM_TARGET_CORTEX_A15:
 		reset_regs = &cortexa_regs_reset;
 		vcpu->arch.midr = read_cpuid_id();
-		cpu_vtimer_irq = &cortexa_vtimer_irq;
-		cpu_ptimer_irq = &cortexa_ptimer_irq;
 		break;
 	default:
 		return -ENODEV;
@@ -84,5 +70,5 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	kvm_reset_coprocs(vcpu);
 
 	/* Reset arch_timer context */
-	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq, cpu_ptimer_irq);
+	return kvm_timer_vcpu_reset(vcpu);
 }
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 561badf93de8..3256b9228e75 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -46,16 +46,6 @@ static const struct kvm_regs default_regs_reset32 = {
 			COMPAT_PSR_I_BIT | COMPAT_PSR_F_BIT),
 };
 
-static const struct kvm_irq_level default_ptimer_irq = {
-	.irq	= 30,
-	.level	= 1,
-};
-
-static const struct kvm_irq_level default_vtimer_irq = {
-	.irq	= 27,
-	.level	= 1,
-};
-
 static bool cpu_has_32bit_el1(void)
 {
 	u64 pfr0;
@@ -108,8 +98,6 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
-	const struct kvm_irq_level *cpu_vtimer_irq;
-	const struct kvm_irq_level *cpu_ptimer_irq;
 	const struct kvm_regs *cpu_reset;
 
 	switch (vcpu->arch.target) {
@@ -122,8 +110,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 			cpu_reset = &default_regs_reset;
 		}
 
-		cpu_vtimer_irq = &default_vtimer_irq;
-		cpu_ptimer_irq = &default_ptimer_irq;
 		break;
 	}
 
@@ -137,5 +123,5 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	kvm_pmu_vcpu_reset(vcpu);
 
 	/* Reset timer */
-	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq, cpu_ptimer_irq);
+	return kvm_timer_vcpu_reset(vcpu);
 }
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 295584f31a4e..f1c967a4f603 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -57,9 +57,7 @@ struct arch_timer_cpu {
 
 int kvm_timer_hyp_init(void);
 int kvm_timer_enable(struct kvm_vcpu *vcpu);
-int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
-			 const struct kvm_irq_level *virt_irq,
-			 const struct kvm_irq_level *phys_irq);
+int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 7933b1f8f7b7..72d5aa7d4c64 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -35,6 +35,16 @@ static struct timecounter *timecounter;
 static unsigned int host_vtimer_irq;
 static u32 host_vtimer_irq_flags;
 
+static const struct kvm_irq_level default_ptimer_irq = {
+	.irq	= 30,
+	.level	= 1,
+};
+
+static const struct kvm_irq_level default_vtimer_irq = {
+	.irq	= 27,
+	.level	= 1,
+};
+
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	vcpu_vtimer(vcpu)->active_cleared_last = false;
@@ -445,23 +455,12 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 	kvm_timer_update_state(vcpu);
 }
 
-int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
-			 const struct kvm_irq_level *virt_irq,
-			 const struct kvm_irq_level *phys_irq)
+int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	/*
-	 * The vcpu timer irq number cannot be determined in
-	 * kvm_timer_vcpu_init() because it is called much before
-	 * kvm_vcpu_set_target(). To handle this, we determine
-	 * vcpu timer irq number when the vcpu is reset.
-	 */
-	vtimer->irq.irq = virt_irq->irq;
-	ptimer->irq.irq = phys_irq->irq;
-
-	/*
 	 * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
 	 * and to 0 for ARMv7.  We provide an implementation that always
 	 * resets the timer to be disabled and unmasked and is compliant with
@@ -496,6 +495,8 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	/* Synchronize cntvoff across all vtimers of a VM. */
 	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
@@ -504,6 +505,9 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	INIT_WORK(&timer->expired, kvm_timer_inject_irq_work);
 	hrtimer_init(&timer->timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	timer->timer.function = kvm_timer_expire;
+
+	vtimer->irq.irq = default_vtimer_irq.irq;
+	ptimer->irq.irq = default_ptimer_irq.irq;
 }
 
 static void kvm_timer_init_interrupt(void *info)
-- 
2.11.0
