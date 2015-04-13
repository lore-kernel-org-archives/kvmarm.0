From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v6 14/16] kvm: arm/arm64: implement kvm_arch_halt_guest and
 kvm_arch_resume_guest
Date: Mon, 13 Apr 2015 14:29:29 +0200
Message-ID: <1428928171-18884-15-git-send-email-eric.auger@linaro.org>
References: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5BAA4C47D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:25:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vvq70KN+0+Zr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:25:17 -0400 (EDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
 [209.85.212.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAA1D4C447
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:25:16 -0400 (EDT)
Received: by wiun10 with SMTP id n10so64604447wiu.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:33:03 -0700 (PDT)
In-Reply-To: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com
Cc: feng.wu@intel.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch defines __KVM_HAVE_ARCH_HALT_GUEST and implements
kvm_arch_halt_guest and kvm_arch_resume_guest for ARM.

On halt, the guest is forced to exit and prevented from being
re-entered.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v4 -> v5: add arm64 support
- also defines __KVM_HAVE_ARCH_HALT_GUEST for arm64
- add pause field
---
 arch/arm/include/asm/kvm_host.h   |  4 ++++
 arch/arm/kvm/arm.c                | 32 +++++++++++++++++++++++++++++---
 arch/arm64/include/asm/kvm_host.h |  4 ++++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 79a919c..b829f93 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -28,6 +28,7 @@
 #include <kvm/arm_arch_timer.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
+#define __KVM_HAVE_ARCH_HALT_GUEST
 
 #if defined(CONFIG_KVM_ARM_MAX_VCPUS)
 #define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
@@ -132,6 +133,9 @@ struct kvm_vcpu_arch {
 	/* vcpu power-off state */
 	bool power_off;
 
+	/* Don't run the guest */
+	bool pause;
+
 	/* IO related fields */
 	struct kvm_decode mmio_decode;
 
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 08e12dc..ebc0b55 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -454,11 +454,36 @@ bool kvm_arch_intc_initialized(struct kvm *kvm)
 	return vgic_initialized(kvm);
 }
 
+void kvm_arch_halt_guest(struct kvm *kvm)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		vcpu->arch.pause = true;
+	force_vm_exit(cpu_all_mask);
+}
+
+void kvm_arch_resume_guest(struct kvm *kvm)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
+
+		vcpu->arch.pause = false;
+		wake_up_interruptible(wq);
+	}
+}
+
+
 static void vcpu_pause(struct kvm_vcpu *vcpu)
 {
 	wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
 
-	wait_event_interruptible(*wq, !vcpu->arch.power_off);
+	wait_event_interruptible(*wq, ((!vcpu->arch.power_off) &&
+				       (!vcpu->arch.pause)));
 }
 
 static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
@@ -508,7 +533,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		update_vttbr(vcpu->kvm);
 
-		if (vcpu->arch.power_off)
+		if (vcpu->arch.power_off || vcpu->arch.pause)
 			vcpu_pause(vcpu);
 
 		kvm_vgic_flush_hwstate(vcpu);
@@ -526,7 +551,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			run->exit_reason = KVM_EXIT_INTR;
 		}
 
-		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
+		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
+		    vcpu->arch.pause) {
 			kvm_timer_sync_hwstate(vcpu);
 			local_irq_enable();
 			kvm_timer_finish_sync(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a713b0c..ffcc698 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -29,6 +29,7 @@
 #include <asm/kvm_mmio.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
+#define __KVM_HAVE_ARCH_HALT_GUEST
 
 #if defined(CONFIG_KVM_ARM_MAX_VCPUS)
 #define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
@@ -125,6 +126,9 @@ struct kvm_vcpu_arch {
 	/* vcpu power-off state */
 	bool power_off;
 
+	/* Don't run the guest */
+	bool pause;
+
 	/* IO related fields */
 	struct kvm_decode mmio_decode;
 
-- 
1.9.1
