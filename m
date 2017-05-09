From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 06/11] KVM: arm/arm64: Slightly rework kvm_vgic_addr
Date: Tue,  9 May 2017 10:56:13 +0200
Message-ID: <20170509085618.28311-7-cdall@linaro.org>
References: <20170509085618.28311-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170509085618.28311-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to handle setting the address for the redistributor base
region separately from some of the other base addresses, let's rework
this function to leave a little more room for being flexible in what
each type of base address does.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-kvm-device.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index d48743c..69ccfd5 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -37,6 +37,14 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 	return 0;
 }
 
+static int vgic_check_type(struct kvm *kvm, int type_needed)
+{
+	if (kvm->arch.vgic.vgic_model != type_needed)
+		return -ENODEV;
+	else
+		return 0;
+}
+
 /**
  * kvm_vgic_addr - set or get vgic VM base addresses
  * @kvm:   pointer to the vm struct
@@ -57,40 +65,36 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 {
 	int r = 0;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
-	int type_needed;
 	phys_addr_t *addr_ptr, alignment;
 
 	mutex_lock(&kvm->lock);
 	switch (type) {
 	case KVM_VGIC_V2_ADDR_TYPE_DIST:
-		type_needed = KVM_DEV_TYPE_ARM_VGIC_V2;
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 		addr_ptr = &vgic->vgic_dist_base;
 		alignment = SZ_4K;
 		break;
 	case KVM_VGIC_V2_ADDR_TYPE_CPU:
-		type_needed = KVM_DEV_TYPE_ARM_VGIC_V2;
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
 		addr_ptr = &vgic->vgic_cpu_base;
 		alignment = SZ_4K;
 		break;
 	case KVM_VGIC_V3_ADDR_TYPE_DIST:
-		type_needed = KVM_DEV_TYPE_ARM_VGIC_V3;
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
 		addr_ptr = &vgic->vgic_dist_base;
 		alignment = SZ_64K;
 		break;
 	case KVM_VGIC_V3_ADDR_TYPE_REDIST:
-		type_needed = KVM_DEV_TYPE_ARM_VGIC_V3;
+		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
 		addr_ptr = &vgic->vgic_redist_base;
 		alignment = SZ_64K;
 		break;
 	default:
 		r = -ENODEV;
-		goto out;
 	}
 
-	if (vgic->vgic_model != type_needed) {
-		r = -ENODEV;
+	if (r)
 		goto out;
-	}
 
 	if (write) {
 		r = vgic_check_ioaddr(kvm, addr_ptr, *addr, alignment);
-- 
2.9.0
