From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: arm/arm64: prefer IS_ENABLED to a static variable
Date: Thu,  5 Mar 2015 12:26:06 +0100
Message-ID: <1425554766-4119-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AA4947D38
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 06:20:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PTc9fespnNvu for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2015 06:20:10 -0500 (EST)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1547547C39
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 06:20:09 -0500 (EST)
Received: by wivr20 with SMTP id r20so5997898wiv.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Mar 2015 03:26:14 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

IS_ENABLED gives compile-time checking and keeps the code clearer.

The one exception is inside kvm_vm_ioctl_check_extension, where
the established idiom is to wrap the case labels with an #ifdef.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
--
	Untested...
---
 arch/arm/kvm/arm.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 07e7eb1d7ab6..706769fb0f2e 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -61,8 +61,6 @@ static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
 static u8 kvm_next_vmid;
 static DEFINE_SPINLOCK(kvm_vmid_lock);
 
-static bool vgic_present;
-
 static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
 {
 	BUG_ON(preemptible());
@@ -172,9 +170,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
 	switch (ext) {
+#ifdef CONFIG_KVM_ARM_VGIC
 	case KVM_CAP_IRQCHIP:
-		r = vgic_present;
-		break;
+#endif
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SYNC_MMU:
@@ -831,7 +829,7 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 
 	switch (dev_id) {
 	case KVM_ARM_DEVICE_VGIC_V2:
-		if (!vgic_present)
+		if (!IS_ENABLED(CONFIG_KVM_ARM_VGIC))
 			return -ENXIO;
 		return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
 	default:
@@ -847,10 +845,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
-		if (vgic_present)
-			return kvm_vgic_create(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
-		else
+		if (!IS_ENABLED(CONFIG_KVM_ARM_VGIC))
 			return -ENXIO;
+		return kvm_vgic_create(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 	}
 	case KVM_ARM_SET_DEVICE_ADDR: {
 		struct kvm_arm_device_addr dev_addr;
@@ -1035,10 +1032,6 @@ static int init_hyp_mode(void)
 	if (err)
 		goto out_free_context;
 
-#ifdef CONFIG_KVM_ARM_VGIC
-		vgic_present = true;
-#endif
-
 	/*
 	 * Init HYP architected timer support
 	 */
-- 
2.3.0
