From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v2 2/3] KVM: arm: Detect vGIC presence at runtime
Date: Tue, 14 Jul 2015 15:06:04 +0300
Message-ID: <e664e112531093dcb47c2028c72670d755e76f08.1436874248.git.p.fedin@samsung.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1436874248.git.p.fedin@samsung.com>
In-reply-to: <cover.1436874248.git.p.fedin@samsung.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Allows to use KVM on hardware without vGIC. Interrupt controller has to be
emulated in userspace in this case.

-ENODEV return code from probe function means there's no GIC at all. -ENXIO
happens when, for example, there is GIC node in the device tree, but it does
not specify vGIC resources. Normally this means that vGIC hardware is defunct.
Any other code is still treated as full stop because it might mean some really
serious problems.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm/kvm/arm.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 5668c4e..7e389fd 100644
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
@@ -172,6 +175,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
 	case KVM_CAP_IRQFD:
+		r = vgic_present;
+		break;
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
@@ -850,6 +855,8 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 
 	switch (dev_id) {
 	case KVM_ARM_DEVICE_VGIC_V2:
+		if (!vgic_present)
+			return -ENXIO;
 		return kvm_vgic_addr(kvm, type, &dev_addr->addr, true);
 	default:
 		return -ENODEV;
@@ -864,6 +871,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
+		if (!vgic_present)
+			return -ENXIO;
 		return kvm_vgic_create(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 	}
 	case KVM_ARM_SET_DEVICE_ADDR: {
@@ -1046,8 +1055,17 @@ static int init_hyp_mode(void)
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

