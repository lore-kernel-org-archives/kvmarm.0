From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 12/56] KVM: arm/arm64: Provide functionality to pause and resume a guest
Date: Mon, 16 May 2016 10:53:57 +0100
Message-ID: <1463392481-26583-70-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

For some rare corner cases in our VGIC emulation later we have to stop
the guest to make sure the VGIC state is consistent.
Provide the necessary framework to pause and resume a guest.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |  4 ++++
 arch/arm/kvm/arm.c                | 25 +++++++++++++------------
 arch/arm64/include/asm/kvm_host.h |  4 ++++
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 3850701..832be03 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -41,6 +41,8 @@
 
 #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
 
+#define KVM_REQ_VCPU_EXIT	8
+
 u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
@@ -225,6 +227,8 @@ static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
 
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
 struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
+void kvm_arm_halt_guest(struct kvm *kvm);
+void kvm_arm_resume_guest(struct kvm *kvm);
 
 int kvm_arm_copy_coproc_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
 unsigned long kvm_arm_num_coproc_regs(struct kvm_vcpu *vcpu);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index be4b639..3b4fd03 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -492,30 +492,31 @@ bool kvm_arch_intc_initialized(struct kvm *kvm)
 	return vgic_initialized(kvm);
 }
 
-static void kvm_arm_halt_guest(struct kvm *kvm) __maybe_unused;
-static void kvm_arm_resume_guest(struct kvm *kvm) __maybe_unused;
-
-static void kvm_arm_halt_guest(struct kvm *kvm)
+void kvm_arm_halt_guest(struct kvm *kvm)
 {
 	int i;
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		vcpu->arch.pause = true;
-	force_vm_exit(cpu_all_mask);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_VCPU_EXIT);
+}
+
+static void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
+
+	vcpu->arch.pause = false;
+	swake_up(wq);
 }
 
-static void kvm_arm_resume_guest(struct kvm *kvm)
+void kvm_arm_resume_guest(struct kvm *kvm)
 {
 	int i;
 	struct kvm_vcpu *vcpu;
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
-
-		vcpu->arch.pause = false;
-		swake_up(wq);
-	}
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_arm_resume_vcpu(vcpu);
 }
 
 static void vcpu_sleep(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4cd4196..fa94f91 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -44,6 +44,8 @@
 
 #define KVM_VCPU_MAX_FEATURES 4
 
+#define KVM_REQ_VCPU_EXIT	8
+
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 int kvm_arch_dev_ioctl_check_extension(long ext);
@@ -325,6 +327,8 @@ static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
 
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
+void kvm_arm_halt_guest(struct kvm *kvm);
+void kvm_arm_resume_guest(struct kvm *kvm);
 
 u64 __kvm_call_hyp(void *hypfn, ...);
 #define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
-- 
2.8.2

