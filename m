From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 13/21] KVM: arm/arm64: implement kvm_arm_[halt,resume]_guest
Date: Wed,  4 Nov 2015 15:49:52 +0100
Message-ID: <1446648600-27297-14-git-send-email-christoffer.dall@linaro.org>
References: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0A7F49928
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:50:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G2vTvumXvgEk for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2015 09:49:59 -0500 (EST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79632499D2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:49:58 -0500 (EST)
Received: by wmff134 with SMTP id f134so112372272wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2015 06:53:11 -0800 (PST)
In-Reply-To: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

We introduce kvm_arm_halt_guest and resume functions. They
will be used for IRQ forward state change.

Halt is synchronous and prevents the guest from being re-entered.
We use the same mechanism put in place for PSCI former pause,
now renamed power_off. A new flag is introduced in arch vcpu state,
pause, only meant to be used by those functions.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   |  3 +++
 arch/arm/kvm/arm.c                | 35 +++++++++++++++++++++++++++++++----
 arch/arm64/include/asm/kvm_host.h |  3 +++
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 107374f..6692982 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -129,6 +129,9 @@ struct kvm_vcpu_arch {
 	/* vcpu power-off state */
 	bool power_off;
 
+	 /* Don't run the guest (internal implementation need) */
+	bool pause;
+
 	/* IO related fields */
 	struct kvm_decode mmio_decode;
 
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 3b3384c..ed15747 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -353,7 +353,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
 	return ((!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
-		&& !v->arch.power_off);
+		&& !v->arch.power_off && !v->arch.pause);
 }
 
 /* Just ensure a guest exit from a particular CPU */
@@ -479,11 +479,38 @@ bool kvm_arch_intc_initialized(struct kvm *kvm)
 	return vgic_initialized(kvm);
 }
 
+static void kvm_arm_halt_guest(struct kvm *kvm) __maybe_unused;
+static void kvm_arm_resume_guest(struct kvm *kvm) __maybe_unused;
+
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
 static void vcpu_sleep(struct kvm_vcpu *vcpu)
 {
 	wait_queue_head_t *wq = kvm_arch_vcpu_wq(vcpu);
 
-	wait_event_interruptible(*wq, !vcpu->arch.power_off);
+	wait_event_interruptible(*wq, ((!vcpu->arch.power_off) &&
+				       (!vcpu->arch.pause)));
 }
 
 static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
@@ -533,7 +560,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		update_vttbr(vcpu->kvm);
 
-		if (vcpu->arch.power_off)
+		if (vcpu->arch.power_off || vcpu->arch.pause)
 			vcpu_sleep(vcpu);
 
 		/*
@@ -561,7 +588,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		}
 
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
-			vcpu->arch.power_off) {
+			vcpu->arch.power_off || vcpu->arch.pause) {
 			local_irq_enable();
 			kvm_timer_sync_hwstate(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4b4157b..a35ce72 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -152,6 +152,9 @@ struct kvm_vcpu_arch {
 	/* vcpu power-off state */
 	bool power_off;
 
+	/* Don't run the guest (internal implementation need) */
+	bool pause;
+
 	/* IO related fields */
 	struct kvm_decode mmio_decode;
 
-- 
2.1.2.330.g565301e.dirty
