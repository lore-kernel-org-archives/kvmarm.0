From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 08/17] kvm: arm/arm64: implement kvm_arm_[halt,resume]_guest
Date: Thu,  2 Jul 2015 15:17:18 +0200
Message-ID: <1435843047-6327-9-git-send-email-eric.auger@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DB61576F5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:06:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rwPC62GbxF8v for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 09:06:55 -0400 (EDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
 [209.85.212.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 18CA0576F4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:06:54 -0400 (EDT)
Received: by wicgi11 with SMTP id gi11so73561671wic.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jul 2015 06:18:11 -0700 (PDT)
In-Reply-To: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, pbonzini@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On halt, the guest is forced to exit and prevented from being
re-entered. This is synchronous.

Those two operations will be needed for IRQ forwarding setting.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

RFC:
- rename the function and this latter becomes static
- remove __KVM_HAVE_ARCH_HALT_GUEST

v4 -> v5: add arm64 support
- also defines __KVM_HAVE_ARCH_HALT_GUEST for arm64
- add pause field
---
 arch/arm/include/asm/kvm_host.h   |  3 +++
 arch/arm/kvm/arm.c                | 32 +++++++++++++++++++++++++++++---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 304004d..899ae27 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -132,6 +132,9 @@ struct kvm_vcpu_arch {
 	/* vcpu power-off state */
 	bool power_off;
 
+	/* Don't run the guest */
+	bool pause;
+
 	/* IO related fields */
 	struct kvm_decode mmio_decode;
 
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 7537e68..4be6715 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -471,11 +471,36 @@ bool kvm_arch_intc_initialized(struct kvm *kvm)
 	return vgic_initialized(kvm);
 }
 
+static void kvm_arm_halt_guest(struct kvm *kvm)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		vcpu->arch.pause = true;
+	force_vm_exit(cpu_all_mask);
+}
+
+static void kvm_arm_resume_guest(struct kvm *kvm)
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
@@ -525,7 +550,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		update_vttbr(vcpu->kvm);
 
-		if (vcpu->arch.power_off)
+		if (vcpu->arch.power_off || vcpu->arch.pause)
 			vcpu_pause(vcpu);
 
 		/*
@@ -551,7 +576,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			run->exit_reason = KVM_EXIT_INTR;
 		}
 
-		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm)) {
+		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
+		    vcpu->arch.pause) {
 			local_irq_enable();
 			preempt_enable();
 			kvm_vgic_sync_hwstate(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 009da6b..69e3785 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -125,6 +125,9 @@ struct kvm_vcpu_arch {
 	/* vcpu power-off state */
 	bool power_off;
 
+	/* Don't run the guest */
+	bool pause;
+
 	/* IO related fields */
 	struct kvm_decode mmio_decode;
 
-- 
1.9.1
