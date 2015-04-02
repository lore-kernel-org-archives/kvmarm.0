From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/27] KVM: arm/arm64: prefer IS_ENABLED to a static variable
Date: Thu,  2 Apr 2015 11:05:06 +0100
Message-ID: <1427969131-8445-3-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9885C4AD13
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 05:57:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KL3yqeJ2snVP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2015 05:57:47 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91B0C4AD12
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 05:57:47 -0400 (EDT)
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Paolo Bonzini <pbonzini@redhat.com>

IS_ENABLED gives compile-time checking and keeps the code clearer.

The one exception is inside kvm_vm_ioctl_check_extension, where
the established idiom is to wrap the case labels with an #ifdef.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm/kvm/arm.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 5560f74..e0e9434 100644
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
2.1.4
