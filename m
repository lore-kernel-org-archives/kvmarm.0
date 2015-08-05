From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v3 2/3] Detect vGIC presence at runtime
Date: Wed, 05 Aug 2015 13:53:58 +0300
Message-ID: <cad42f98c38c042430da47bf69ac2db81cb957af.1438770954.git.p.fedin@samsung.com>
References: <cover.1438770954.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7E505A0CA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2015 06:41:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UC1+F2l22pPM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2015 06:41:23 -0400 (EDT)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 630AA5A0D2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2015 06:41:23 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NSL00HOAVM8PZ10@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 05 Aug 2015 11:54:08 +0100 (BST)
In-reply-to: <cover.1438770954.git.p.fedin@samsung.com>
In-reply-to: <cover.1438770954.git.p.fedin@samsung.com>
References: <cover.1438770954.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Before commit 662d9715840aef44dcb573b0f9fab9e8319c868a is was possible to
compile the kernel without vGIC and vTimer support. Commit message says
about possibility to detect vGIC support in runtine, but this has never
been implemented.

This patch introdices runtime check, restoring the lost functionality. It
again allows to use KVM on hardware without vGIC. Interrupt controller has
to be emulated in userspace in this case.

-ENODEV return code from probe function means there's no GIC at all.
-ENXIO happens when, for example, there is GIC node in the device tree,
but it does not specify vGIC resources. Normally this means that vGIC
hardware is defunct. Any other error code is still treated as full stop
because it might mean some really serious problems.

This patch does not touch any virtual timer code, suggesting that timer
hardware is actually in place. Normally on boards in question it is true,
however since vGIC is missing, it is impossible to correctly utilize
interrupts from the virtual timer. Since virtual timer handling is in
active redevelopment now, handling in it userspace is out of scope at
the moment. The guest is currently suggested to use some memory-mapped
timer which can be emulated in userspace.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm/kvm/arm.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 199a50a..1039161 100644
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
@@ -131,7 +133,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.vmid_gen = 0;
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
-	kvm->arch.max_vcpus = kvm_vgic_get_max_vcpus();
+	kvm->arch.max_vcpus = vgic_present ?
+				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 
 	return ret;
 out_free_stage2_pgd:
@@ -171,6 +174,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	int r;
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
+		r = vgic_present;
+		break;
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
@@ -849,6 +854,8 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 
 	switch (dev_id) {
 	case KVM_ARM_DEVICE_VGIC_V2:
+		if (!vgic_present)
+			return -ENXIO;
 		return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
 	default:
 		return -ENODEV;
@@ -863,6 +870,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
+		if (!vgic_present)
+			return -ENXIO;
 		return kvm_vgic_create(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 	}
 	case KVM_ARM_SET_DEVICE_ADDR: {
@@ -1045,8 +1054,12 @@ static int init_hyp_mode(void)
 	 * Init HYP view of VGIC
 	 */
 	err = kvm_vgic_hyp_init();
-	if (err)
+	if (err == -ENODEV || err == -ENXIO)
+		vgic_present = false;
+	else if (err)
 		goto out_free_context;
+	else
+		vgic_present = true;
 
 	/*
 	 * Init HYP architected timer support
-- 
2.4.4
