From: Christoffer Dall <cdall@linaro.org>
Subject: [RFC PATCH v2 14/19] KVM: arm/arm64: Support EL1 phys timer register access in set/get reg
Date: Mon, 17 Jul 2017 16:27:13 +0200
Message-ID: <20170717142718.13853-15-cdall@linaro.org>
References: <20170717142718.13853-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170717142718.13853-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Add suport for the physical timer registers in kvm_arm_timer_set_reg and
kvm_arm_timer_get_reg so that these functions can be reused to interact
with the rest of the system.

Note that this paves part of the way for the physical timer state
save/restore, but we still need to add those registers to
KVM_GET_REG_LIST before we support migrating the physical timer state.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/include/uapi/asm/kvm.h   |  6 ++++++
 arch/arm64/include/uapi/asm/kvm.h |  6 ++++++
 virt/kvm/arm/arch_timer.c         | 33 +++++++++++++++++++++++++++++++--
 3 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 5db2d4c..665c454 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -151,6 +151,12 @@ struct kvm_arch_memory_slot {
 	(__ARM_CP15_REG(op1, 0, crm, 0) | KVM_REG_SIZE_U64)
 #define ARM_CP15_REG64(...) __ARM_CP15_REG64(__VA_ARGS__)
 
+/* PL1 Physical Timer Registers */
+#define KVM_REG_ARM_PTIMER_CTL		ARM_CP15_REG32(0, 14, 2, 1)
+#define KVM_REG_ARM_PTIMER_CNT		ARM_CP15_REG64(0, 14)
+#define KVM_REG_ARM_PTIMER_CVAL		ARM_CP15_REG64(2, 14)
+
+/* Virtual Timer Registers */
 #define KVM_REG_ARM_TIMER_CTL		ARM_CP15_REG32(0, 14, 3, 1)
 #define KVM_REG_ARM_TIMER_CNT		ARM_CP15_REG64(1, 14)
 #define KVM_REG_ARM_TIMER_CVAL		ARM_CP15_REG64(3, 14)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9f3ca24..07be6e2 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -195,6 +195,12 @@ struct kvm_arch_memory_slot {
 
 #define ARM64_SYS_REG(...) (__ARM64_SYS_REG(__VA_ARGS__) | KVM_REG_SIZE_U64)
 
+/* EL1 Physical Timer Registers */
+#define KVM_REG_ARM_PTIMER_CTL		ARM64_SYS_REG(3, 3, 14, 2, 1)
+#define KVM_REG_ARM_PTIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 2, 2)
+#define KVM_REG_ARM_PTIMER_CNT		ARM64_SYS_REG(3, 3, 14, 0, 1)
+
+/* EL0 Virtual Timer Registers */
 #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
 #define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
 #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 70110ea..d5b632d 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -626,10 +626,11 @@ static void kvm_timer_init_interrupt(void *info)
 int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	switch (regid) {
 	case KVM_REG_ARM_TIMER_CTL:
-		vtimer->cnt_ctl = value;
+		vtimer->cnt_ctl = value & ~ARCH_TIMER_CTRL_IT_STAT;
 		break;
 	case KVM_REG_ARM_TIMER_CNT:
 		update_vtimer_cntvoff(vcpu, kvm_phys_timer_read() - value);
@@ -637,6 +638,13 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 	case KVM_REG_ARM_TIMER_CVAL:
 		vtimer->cnt_cval = value;
 		break;
+	case KVM_REG_ARM_PTIMER_CTL:
+		ptimer->cnt_ctl = value & ~ARCH_TIMER_CTRL_IT_STAT;
+		break;
+	case KVM_REG_ARM_PTIMER_CVAL:
+		ptimer->cnt_cval = value;
+		break;
+
 	default:
 		return -1;
 	}
@@ -645,17 +653,38 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 	return 0;
 }
 
+static u64 read_timer_ctl(struct arch_timer_context *timer)
+{
+	/*
+	 * Set ISTATUS bit if it's expired.
+	 * Note that according to ARMv8 ARM Issue A.k, ISTATUS bit is
+	 * UNKNOWN when ENABLE bit is 0, so we chose to set ISTATUS bit
+	 * regardless of ENABLE bit for our implementation convenience.
+	 */
+	if (!kvm_timer_compute_delta(timer))
+		return timer->cnt_ctl | ARCH_TIMER_CTRL_IT_STAT;
+	else
+		return timer->cnt_ctl;
+}
+
 u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
 {
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	switch (regid) {
 	case KVM_REG_ARM_TIMER_CTL:
-		return vtimer->cnt_ctl;
+		return read_timer_ctl(vtimer);
 	case KVM_REG_ARM_TIMER_CNT:
 		return kvm_phys_timer_read() - vtimer->cntvoff;
 	case KVM_REG_ARM_TIMER_CVAL:
 		return vtimer->cnt_cval;
+	case KVM_REG_ARM_PTIMER_CTL:
+		return read_timer_ctl(ptimer);
+	case KVM_REG_ARM_PTIMER_CVAL:
+		return ptimer->cnt_cval;
+	case KVM_REG_ARM_PTIMER_CNT:
+		return kvm_phys_timer_read();
 	}
 	return (u64)-1;
 }
-- 
2.9.0
