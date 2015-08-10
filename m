From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v4 09/15] KVM: arm: redefine kvm_cpu_context_t to save the host cp14 states
Date: Mon, 10 Aug 2015 21:26:01 +0800
Message-ID: <1439213167-8988-10-git-send-email-zhichao.huang@linaro.org>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Redefine kvm_cpu_context_t as a new struct that include the cp14 states,
which we used to save the host cp14 states.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
---
 arch/arm/include/asm/kvm_host.h | 6 +++++-
 arch/arm/kernel/asm-offsets.c   | 4 +++-
 arch/arm/kvm/interrupts.S       | 6 ++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 63ac005..fc461ac 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -91,7 +91,11 @@ struct kvm_vcpu_fault_info {
 	u32 hyp_pc;		/* PC when exception was taken from Hyp mode */
 };
 
-typedef struct vfp_hard_struct kvm_cpu_context_t;
+struct kvm_cpu_context {
+	struct vfp_hard_struct vfp;
+	u32 cp14[NR_CP14_REGS];
+};
+typedef struct kvm_cpu_context kvm_cpu_context_t;
 
 struct kvm_vcpu_arch {
 	struct kvm_regs regs;
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 9158de0..cee4254 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -175,7 +175,9 @@ int main(void)
   DEFINE(VCPU_CP14,		offsetof(struct kvm_vcpu, arch.cp14));
   DEFINE(VCPU_CP15,		offsetof(struct kvm_vcpu, arch.cp15));
   DEFINE(VCPU_VFP_GUEST,	offsetof(struct kvm_vcpu, arch.vfp_guest));
-  DEFINE(VCPU_VFP_HOST,		offsetof(struct kvm_vcpu, arch.host_cpu_context));
+  DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
+  DEFINE(VCPU_VFP_HOST,		offsetof(struct kvm_cpu_context, vfp));
+  DEFINE(VCPU_CP14_HOST,	offsetof(struct kvm_cpu_context, cp14));
   DEFINE(VCPU_REGS,		offsetof(struct kvm_vcpu, arch.regs));
   DEFINE(VCPU_USR_REGS,		offsetof(struct kvm_vcpu, arch.regs.usr_regs));
   DEFINE(VCPU_SVC_REGS,		offsetof(struct kvm_vcpu, arch.regs.svc_regs));
diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 48333ff..d4ff22e 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -176,8 +176,9 @@ __kvm_vcpu_return:
 	@ Switch VFP/NEON hardware state to the host's
 	add	r7, vcpu, #VCPU_VFP_GUEST
 	store_vfp_state r7
-	add	r7, vcpu, #VCPU_VFP_HOST
+	add	r7, vcpu, #VCPU_HOST_CONTEXT
 	ldr	r7, [r7]
+	add	r7, r7, #VCPU_VFP_HOST
 	restore_vfp_state r7
 
 after_vfp_restore:
@@ -484,8 +485,9 @@ switch_to_guest_vfp:
 	set_hcptr vmtrap, (HCPTR_TCP(10) | HCPTR_TCP(11))
 
 	@ Switch VFP/NEON hardware state to the guest's
-	add	r7, r0, #VCPU_VFP_HOST
+	add	r7, r0, #VCPU_HOST_CONTEXT
 	ldr	r7, [r7]
+	add	r7, r7, #VCPU_VFP_HOST
 	store_vfp_state r7
 	add	r7, r0, #VCPU_VFP_GUEST
 	restore_vfp_state r7
-- 
1.7.12.4

