From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 2/2] Detect vGIC presence at runtime
Date: Tue, 07 Jul 2015 13:38:49 +0300
Message-ID: <8f44081ef96f51c6f2a5753e5933d7de1e3c2c2f.1436264839.git.p.fedin@samsung.com>
References: <cover.1436264839.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFFCB57DDB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 06:27:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tpI0A1-QRJNh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2015 06:27:27 -0400 (EDT)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 91BC257DE0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 06:27:27 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NR4000AY5KUPG80@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 07 Jul 2015 11:38:54 +0100 (BST)
In-reply-to: <cover.1436264839.git.p.fedin@samsung.com>
In-reply-to: <cover.1436264839.git.p.fedin@samsung.com>
References: <cover.1436264839.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: KVM-ARM mailing list <kvmarm@lists.cs.columbia.edu>
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Allows to use KVM on hardware without vGIC. Interrupt controller has to be
emulated in userspace in this case.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm/kvm/arm.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index d9631ec..f2f7a13 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -61,6 +61,8 @@ static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
 static u8 kvm_next_vmid;
 static DEFINE_SPINLOCK(kvm_vmid_lock);
 
+static bool vgic_present;
+
 static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
 {
 	BUG_ON(preemptible());
@@ -172,6 +174,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
 	case KVM_CAP_IRQFD:
+		r = vgic_present;
+		break;
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
@@ -850,6 +854,8 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 
 	switch (dev_id) {
 	case KVM_ARM_DEVICE_VGIC_V2:
+		if (!vgic_present)
+			return -ENXIO;
 		return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
 	default:
 		return -ENODEV;
@@ -864,6 +870,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
+		if (!vgic_present)
+			return -ENXIO;
 		return kvm_vgic_create(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 	}
 	case KVM_ARM_SET_DEVICE_ADDR: {
@@ -1046,8 +1054,17 @@ static int init_hyp_mode(void)
 	 * Init HYP view of VGIC
 	 */
 	err = kvm_vgic_hyp_init();
-	if (err)
+	switch (err) {
+	case 0:
+		vgic_present = true;
+		break;
+	case -ENODEV:
+	case -ENXIO:
+		vgic_present = false;
+		break;
+	default:
 		goto out_free_context;
+	}
 
 	/*
 	 * Init HYP architected timer support
-- 
2.4.4
