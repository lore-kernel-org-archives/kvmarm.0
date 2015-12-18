From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v7] arm/arm64: KVM: Detect vGIC presence at runtime
Date: Fri, 18 Dec 2015 14:38:43 +0300
Message-ID: <01b201d13988$a73a3400$f5ae9c00$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AA5649731
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2015 06:36:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Aujo+DyWk270 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Dec 2015 06:36:20 -0500 (EST)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CC21412E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2015 06:36:19 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NZJ00FQLXOMYM30@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 18 Dec 2015 11:38:46 +0000 (GMT)
Content-language: ru
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
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Before commit 662d9715840aef44dcb573b0f9fab9e8319c868a
("arm/arm64: KVM: Kill CONFIG_KVM_ARM_{VGIC,TIMER}") is was possible to
compile the kernel without vGIC and vTimer support. Commit message says
about possibility to detect vGIC support in runtime, but this has never
been implemented.

This patch introduces runtime check, restoring the lost functionality.
It again allows to use KVM on hardware without vGIC. Interrupt
controller has to be emulated in userspace in this case.

-ENODEV return code from probe function means there's no GIC at all.
-ENXIO happens when, for example, there is GIC node in the device tree,
but it does not specify vGIC resources. Any other error code is still
treated as full stop because it might mean some really serious problems.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
v6 => v7:
- Fixed up commit message

v5 => v6:
- KVM_CAP_IRQFD patch also dropped, causing many problems on PowerPC and
  S390
- Rebased on top of 4.3-rc3

v4 => v5:
- Tested on top of kvmarm/next
- Dropped already applied part
- Fixed minor checkpatch issues

v3 => v4:
- Revert back to using switch on kvm_vgic_hyp_init() return code. I decided
  to leave 'vgic_present = false' statement because it helps to understand
  the code.

v2 => v3:
- Improved commit messages, added references to commits where the respective
  functionality was broken
- Explicitly specify that the solution currently affects only vGIC and has
  nothing to do with timer.
- Fixed code style according to previous notes
- Removed ARM64 save/restore patch introduced in v2 because it was already
  obsolete for linux-next
- Modify KVM_CAP_IRQFD handling in correct place

v1 => v2:
- Do not use defensive approach in patch 0001. Use correct conditions in
  callers instead
- Added ARM64-specific code, without which attempt to run a VM ends in a
  HYP crash because of unset vGIC save/restore function pointers
---
 arch/arm/kvm/arm.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index e06fd29..66f90c1 100644
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
@@ -132,7 +134,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.vmid_gen = 0;
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
-	kvm->arch.max_vcpus = kvm_vgic_get_max_vcpus();
+	kvm->arch.max_vcpus = vgic_present ?
+				kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
 
 	return ret;
 out_free_stage2_pgd:
@@ -172,6 +175,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	int r;
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
+		r = vgic_present;
+		break;
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
@@ -913,6 +918,8 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 
 	switch (dev_id) {
 	case KVM_ARM_DEVICE_VGIC_V2:
+		if (!vgic_present)
+			return -ENXIO;
 		return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
 	default:
 		return -ENODEV;
@@ -927,6 +934,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
+		if (!vgic_present)
+			return -ENXIO;
 		return kvm_vgic_create(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 	}
 	case KVM_ARM_SET_DEVICE_ADDR: {
@@ -1111,8 +1120,17 @@ static int init_hyp_mode(void)
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
