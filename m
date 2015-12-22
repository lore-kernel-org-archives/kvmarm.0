From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v8 15/20] KVM: ARM64: Add a helper to forward trap to guest EL1
Date: Tue, 22 Dec 2015 16:08:10 +0800
Message-ID: <1450771695-11948-16-git-send-email-zhaoshenglong@huawei.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

This helper forward the trap caused by MRS/MSR for arch64 and MCR/MRC,
MCRR/MRRC for arch32 CP15 to guest EL1.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  1 +
 arch/arm64/kvm/inject_fault.c        | 52 +++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3066328..88b2958 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -36,6 +36,7 @@ unsigned long *vcpu_spsr32(const struct kvm_vcpu *vcpu);
 bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr);
 
+void kvm_forward_trap_to_el1(struct kvm_vcpu *vcpu);
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 648112e..052ef25 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -27,7 +27,10 @@
 
 #define PSTATE_FAULT_BITS_64 	(PSR_MODE_EL1h | PSR_A_BIT | PSR_F_BIT | \
 				 PSR_I_BIT | PSR_D_BIT)
-#define EL1_EXCEPT_SYNC_OFFSET	0x200
+#define EL1_EXCEPT_BAD_SYNC_OFFSET	0x0
+#define EL1_EXCEPT_SYNC_OFFSET		0x200
+#define EL0_EXCEPT_SYNC_OFFSET_64	0x400
+#define EL0_EXCEPT_SYNC_OFFSET_32	0x600
 
 static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 {
@@ -201,3 +204,50 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu)
 	else
 		inject_undef64(vcpu);
 }
+
+/**
+ * kvm_forward_trap_to_el1 - forward access trap to the guest EL1
+ *
+ * It is assumed that this code is called from the VCPU thread and that the
+ * VCPU therefore is not currently executing guest code.
+ */
+void kvm_forward_trap_to_el1(struct kvm_vcpu *vcpu)
+{
+	unsigned long cpsr;
+	u32 esr = vcpu->arch.fault.esr_el2;
+	u32 esr_ec = (esr & ESR_ELx_EC_MASK) >> ESR_ELx_EC_SHIFT;
+
+	if (esr_ec == ESR_ELx_EC_SYS64) {
+		u64 exc_offset;
+
+		cpsr = *vcpu_cpsr(vcpu);
+		*vcpu_spsr(vcpu) = cpsr;
+		*vcpu_elr_el1(vcpu) = *vcpu_pc(vcpu);
+
+		*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
+
+		switch (cpsr & (PSR_MODE_MASK | PSR_MODE32_BIT)) {
+		case PSR_MODE_EL0t:
+			exc_offset = EL0_EXCEPT_SYNC_OFFSET_64;
+			break;
+		case PSR_MODE_EL1t:
+			exc_offset = EL1_EXCEPT_BAD_SYNC_OFFSET;
+			break;
+		case PSR_MODE_EL1h:
+			exc_offset = EL1_EXCEPT_SYNC_OFFSET;
+			break;
+		default:
+			exc_offset = EL0_EXCEPT_SYNC_OFFSET_32;
+		}
+
+		*vcpu_pc(vcpu) = vcpu_sys_reg(vcpu, VBAR_EL1) + exc_offset;
+
+		if (kvm_vcpu_trap_il_is32bit(vcpu))
+			esr |= ESR_ELx_IL;
+
+		vcpu_sys_reg(vcpu, ESR_EL1) = esr;
+	} else if (esr_ec == ESR_ELx_EC_CP15_32 ||
+		   esr_ec == ESR_ELx_EC_CP15_64) {
+		prepare_fault32(vcpu, COMPAT_PSR_MODE_UND, 4);
+	}
+}
-- 
2.0.4


