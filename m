From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 4/8] KVM: arm/arm64: Initialize the emulated EL1 physical timer
Date: Mon, 26 Dec 2016 12:12:02 -0500
Message-ID: <1482772326-29110-5-git-send-email-jintack@cs.columbia.edu>
References: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2726A40693
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:22:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VtAU5Uqi7Tni for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Dec 2016 12:22:56 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3527B401B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:22:56 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uBQHK4BJ061678
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:20 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id D30DC6D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:20 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id AA0CC6D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:20 -0500 (EST)
Received: from mail-qk0-f199.google.com (mail-qk0-f199.google.com
 [209.85.220.199])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uBQHOKCk047597
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:20 -0500
Received: by mail-qk0-f199.google.com with SMTP id h201so146294884qke.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 09:24:20 -0800 (PST)
In-Reply-To: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Initialize the emulated EL1 physical timer with the default irq number.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/kvm/reset.c         |  9 ++++++++-
 arch/arm64/kvm/reset.c       |  9 ++++++++-
 include/kvm/arm_arch_timer.h |  3 ++-
 virt/kvm/arm/arch_timer.c    | 12 ++++++++++--
 4 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kvm/reset.c b/arch/arm/kvm/reset.c
index 4b5e802..1da8b2d 100644
--- a/arch/arm/kvm/reset.c
+++ b/arch/arm/kvm/reset.c
@@ -37,6 +37,11 @@
 	.usr_regs.ARM_cpsr = SVC_MODE | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT,
 };
 
+static const struct kvm_irq_level cortexa_ptimer_irq = {
+	{ .irq = 30 },
+	.level = 1,
+};
+
 static const struct kvm_irq_level cortexa_vtimer_irq = {
 	{ .irq = 27 },
 	.level = 1,
@@ -58,6 +63,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_regs *reset_regs;
 	const struct kvm_irq_level *cpu_vtimer_irq;
+	const struct kvm_irq_level *cpu_ptimer_irq;
 
 	switch (vcpu->arch.target) {
 	case KVM_ARM_TARGET_CORTEX_A7:
@@ -65,6 +71,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		reset_regs = &cortexa_regs_reset;
 		vcpu->arch.midr = read_cpuid_id();
 		cpu_vtimer_irq = &cortexa_vtimer_irq;
+		cpu_ptimer_irq = &cortexa_ptimer_irq;
 		break;
 	default:
 		return -ENODEV;
@@ -77,5 +84,5 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	kvm_reset_coprocs(vcpu);
 
 	/* Reset arch_timer context */
-	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
+	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq, cpu_ptimer_irq);
 }
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 5bc4608..74322c2 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -46,6 +46,11 @@
 			COMPAT_PSR_I_BIT | COMPAT_PSR_F_BIT),
 };
 
+static const struct kvm_irq_level default_ptimer_irq = {
+	.irq	= 30,
+	.level	= 1,
+};
+
 static const struct kvm_irq_level default_vtimer_irq = {
 	.irq	= 27,
 	.level	= 1,
@@ -110,6 +115,7 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	const struct kvm_irq_level *cpu_vtimer_irq;
+	const struct kvm_irq_level *cpu_ptimer_irq;
 	const struct kvm_regs *cpu_reset;
 
 	switch (vcpu->arch.target) {
@@ -123,6 +129,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 
 		cpu_vtimer_irq = &default_vtimer_irq;
+		cpu_ptimer_irq = &default_ptimer_irq;
 		break;
 	}
 
@@ -136,5 +143,5 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	kvm_pmu_vcpu_reset(vcpu);
 
 	/* Reset timer */
-	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
+	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq, cpu_ptimer_irq);
 }
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index d21652a..04ed9c1 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -61,7 +61,8 @@ struct arch_timer_cpu {
 int kvm_timer_enable(struct kvm_vcpu *vcpu);
 void kvm_timer_init(struct kvm *kvm);
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
-			 const struct kvm_irq_level *irq);
+			 const struct kvm_irq_level *virt_irq,
+			 const struct kvm_irq_level *phys_irq);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 3bd6063..ed80864 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -339,9 +339,11 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 }
 
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
-			 const struct kvm_irq_level *irq)
+			 const struct kvm_irq_level *virt_irq,
+			 const struct kvm_irq_level *phys_irq)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	/*
 	 * The vcpu timer irq number cannot be determined in
@@ -349,7 +351,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * kvm_vcpu_set_target(). To handle this, we determine
 	 * vcpu timer irq number when the vcpu is reset.
 	 */
-	vtimer->irq.irq = irq->irq;
+	vtimer->irq.irq = virt_irq->irq;
+	ptimer->irq.irq = phys_irq->irq;
 
 	/*
 	 * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
@@ -358,6 +361,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * the ARMv7 architecture.
 	 */
 	vtimer->cnt_ctl = 0;
+	ptimer->cnt_ctl = 0;
 	kvm_timer_update_state(vcpu);
 
 	return 0;
@@ -477,11 +481,15 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 	struct irq_desc *desc;
 	struct irq_data *data;
 	int phys_irq;
 	int ret;
 
+	/* Always enable emulated the EL1 physical timer */
+	ptimer->enabled = 1;
+
 	if (vtimer->enabled)
 		return 0;
 
-- 
1.9.1
