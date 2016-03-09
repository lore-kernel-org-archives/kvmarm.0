From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 04/95] ARM: KVM: Move VFP registers to a CPU context structure
Date: Wed,  9 Mar 2016 07:29:58 +0000
Message-ID: <1457508689-19672-5-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to turn the WS code into something that looks a bit
more like the arm64 version, move the VFP registers into a
CPU context container for both the host and the guest.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h | 11 +++++++----
 arch/arm/kernel/asm-offsets.c   |  5 +++--
 arch/arm/kvm/coproc.c           | 20 ++++++++++----------
 arch/arm/kvm/interrupts.S       | 10 ++++++----
 4 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index f1e86f1..b64ac8e 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -88,9 +88,15 @@ struct kvm_vcpu_fault_info {
 	u32 hyp_pc;		/* PC when exception was taken from Hyp mode */
 };
 
-typedef struct vfp_hard_struct kvm_cpu_context_t;
+struct kvm_cpu_context {
+	struct vfp_hard_struct vfp;
+};
+
+typedef struct kvm_cpu_context kvm_cpu_context_t;
 
 struct kvm_vcpu_arch {
+	struct kvm_cpu_context ctxt;
+
 	struct kvm_regs regs;
 
 	int target; /* Processor target */
@@ -111,9 +117,6 @@ struct kvm_vcpu_arch {
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
-	/* Floating point registers (VFP and Advanced SIMD/NEON) */
-	struct vfp_hard_struct vfp_guest;
-
 	/* Host FP context */
 	kvm_cpu_context_t *host_cpu_context;
 
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 871b826..346bfca 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -173,8 +173,9 @@ int main(void)
   DEFINE(VCPU_KVM,		offsetof(struct kvm_vcpu, kvm));
   DEFINE(VCPU_MIDR,		offsetof(struct kvm_vcpu, arch.midr));
   DEFINE(VCPU_CP15,		offsetof(struct kvm_vcpu, arch.cp15));
-  DEFINE(VCPU_VFP_GUEST,	offsetof(struct kvm_vcpu, arch.vfp_guest));
-  DEFINE(VCPU_VFP_HOST,		offsetof(struct kvm_vcpu, arch.host_cpu_context));
+  DEFINE(VCPU_GUEST_CTXT,	offsetof(struct kvm_vcpu, arch.ctxt));
+  DEFINE(VCPU_HOST_CTXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
+  DEFINE(CPU_CTXT_VFP,		offsetof(struct kvm_cpu_context, vfp));
   DEFINE(VCPU_REGS,		offsetof(struct kvm_vcpu, arch.regs));
   DEFINE(VCPU_USR_REGS,		offsetof(struct kvm_vcpu, arch.regs.usr_regs));
   DEFINE(VCPU_SVC_REGS,		offsetof(struct kvm_vcpu, arch.regs.svc_regs));
diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index f3d88dc..1a643f3 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -901,7 +901,7 @@ static int vfp_get_reg(const struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 	if (vfpid < num_fp_regs()) {
 		if (KVM_REG_SIZE(id) != 8)
 			return -ENOENT;
-		return reg_to_user(uaddr, &vcpu->arch.vfp_guest.fpregs[vfpid],
+		return reg_to_user(uaddr, &vcpu->arch.ctxt.vfp.fpregs[vfpid],
 				   id);
 	}
 
@@ -911,13 +911,13 @@ static int vfp_get_reg(const struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 
 	switch (vfpid) {
 	case KVM_REG_ARM_VFP_FPEXC:
-		return reg_to_user(uaddr, &vcpu->arch.vfp_guest.fpexc, id);
+		return reg_to_user(uaddr, &vcpu->arch.ctxt.vfp.fpexc, id);
 	case KVM_REG_ARM_VFP_FPSCR:
-		return reg_to_user(uaddr, &vcpu->arch.vfp_guest.fpscr, id);
+		return reg_to_user(uaddr, &vcpu->arch.ctxt.vfp.fpscr, id);
 	case KVM_REG_ARM_VFP_FPINST:
-		return reg_to_user(uaddr, &vcpu->arch.vfp_guest.fpinst, id);
+		return reg_to_user(uaddr, &vcpu->arch.ctxt.vfp.fpinst, id);
 	case KVM_REG_ARM_VFP_FPINST2:
-		return reg_to_user(uaddr, &vcpu->arch.vfp_guest.fpinst2, id);
+		return reg_to_user(uaddr, &vcpu->arch.ctxt.vfp.fpinst2, id);
 	case KVM_REG_ARM_VFP_MVFR0:
 		val = fmrx(MVFR0);
 		return reg_to_user(uaddr, &val, id);
@@ -945,7 +945,7 @@ static int vfp_set_reg(struct kvm_vcpu *vcpu, u64 id, const void __user *uaddr)
 	if (vfpid < num_fp_regs()) {
 		if (KVM_REG_SIZE(id) != 8)
 			return -ENOENT;
-		return reg_from_user(&vcpu->arch.vfp_guest.fpregs[vfpid],
+		return reg_from_user(&vcpu->arch.ctxt.vfp.fpregs[vfpid],
 				     uaddr, id);
 	}
 
@@ -955,13 +955,13 @@ static int vfp_set_reg(struct kvm_vcpu *vcpu, u64 id, const void __user *uaddr)
 
 	switch (vfpid) {
 	case KVM_REG_ARM_VFP_FPEXC:
-		return reg_from_user(&vcpu->arch.vfp_guest.fpexc, uaddr, id);
+		return reg_from_user(&vcpu->arch.ctxt.vfp.fpexc, uaddr, id);
 	case KVM_REG_ARM_VFP_FPSCR:
-		return reg_from_user(&vcpu->arch.vfp_guest.fpscr, uaddr, id);
+		return reg_from_user(&vcpu->arch.ctxt.vfp.fpscr, uaddr, id);
 	case KVM_REG_ARM_VFP_FPINST:
-		return reg_from_user(&vcpu->arch.vfp_guest.fpinst, uaddr, id);
+		return reg_from_user(&vcpu->arch.ctxt.vfp.fpinst, uaddr, id);
 	case KVM_REG_ARM_VFP_FPINST2:
-		return reg_from_user(&vcpu->arch.vfp_guest.fpinst2, uaddr, id);
+		return reg_from_user(&vcpu->arch.ctxt.vfp.fpinst2, uaddr, id);
 	/* These are invariant. */
 	case KVM_REG_ARM_VFP_MVFR0:
 		if (reg_from_user(&val, uaddr, id))
diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 9d9cb71..7bfb289 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -172,10 +172,11 @@ __kvm_vcpu_return:
 
 #ifdef CONFIG_VFPv3
 	@ Switch VFP/NEON hardware state to the host's
-	add	r7, vcpu, #VCPU_VFP_GUEST
+	add	r7, vcpu, #(VCPU_GUEST_CTXT + CPU_CTXT_VFP)
 	store_vfp_state r7
-	add	r7, vcpu, #VCPU_VFP_HOST
+	add	r7, vcpu, #VCPU_HOST_CTXT
 	ldr	r7, [r7]
+	add	r7, r7, #CPU_CTXT_VFP
 	restore_vfp_state r7
 
 after_vfp_restore:
@@ -482,10 +483,11 @@ switch_to_guest_vfp:
 	set_hcptr vmtrap, (HCPTR_TCP(10) | HCPTR_TCP(11))
 
 	@ Switch VFP/NEON hardware state to the guest's
-	add	r7, r0, #VCPU_VFP_HOST
+	add	r7, r0, #VCPU_HOST_CTXT
 	ldr	r7, [r7]
+	add	r7, r7, #CPU_CTXT_VFP
 	store_vfp_state r7
-	add	r7, r0, #VCPU_VFP_GUEST
+	add	r7, r0, #(VCPU_GUEST_CTXT + CPU_CTXT_VFP)
 	restore_vfp_state r7
 
 	pop	{r3-r7}
-- 
2.1.4

