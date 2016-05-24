From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 14/59] KVM: arm/arm64: Provide functionality to pause and
 resume a guest
Date: Tue, 24 May 2016 11:09:08 +0200
Message-ID: <1464080993-10884-15-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22719499A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ktb6jo3M1tBX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:06:38 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED1B149B9A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:35 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id z87so15342560wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:09 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

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
index ceb9345..e89329d 100644
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
2.1.2.330.g565301e.dirty
