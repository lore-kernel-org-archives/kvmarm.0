From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 06/15] KVM: arm64: Introduce new MMIO region for the ITS base address
Date: Fri, 10 Jul 2015 15:21:42 +0100
Message-ID: <1436538111-4294-7-git-send-email-andre.przywara@arm.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu
Cc: eric.auger@linaro.org, Pavel Fedin <p.fedin@samsung.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARM GICv3 ITS controller requires a separate register frame to
cover ITS specific registers. Add a new VGIC address type and store
the address in a field in the vgic_dist structure.
Provide a function to check whether userland has provided the address,
so ITS functionality can be guarded by that check.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt |  9 +++++++++
 arch/arm64/include/uapi/asm/kvm.h              |  2 ++
 include/kvm/arm_vgic.h                         |  3 +++
 virt/kvm/arm/vgic-v3-emul.c                    |  2 ++
 virt/kvm/arm/vgic.c                            | 16 ++++++++++++++++
 virt/kvm/arm/vgic.h                            |  1 +
 6 files changed, 33 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 3fb9054..ec715f9e 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -39,6 +39,15 @@ Groups:
       Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
       This address needs to be 64K aligned.
 
+    KVM_VGIC_V3_ADDR_TYPE_ITS (rw, 64-bit)
+      Base address in the guest physical address space of the GICv3 ITS
+      control register frame. The ITS allows MSI(-X) interrupts to be
+      injected into guests. This extension is optional, if the kernel
+      does not support the ITS, the call returns -ENODEV.
+      This memory is solely for the guest to access the ITS control
+      registers and does not cover the ITS translation register.
+      Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
+      This address needs to be 64K aligned and the region covers 64 KByte.
 
   KVM_DEV_ARM_VGIC_GRP_DIST_REGS
   Attributes:
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index d268320..a89b407c 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -81,9 +81,11 @@ struct kvm_regs {
 /* Supported VGICv3 address types  */
 #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
+#define KVM_VGIC_V3_ADDR_TYPE_ITS	4
 
 #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
+#define KVM_VGIC_V3_ITS_SIZE		SZ_64K
 
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b18e2c5..3ee063b 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -178,6 +178,9 @@ struct vgic_dist {
 		phys_addr_t		vgic_redist_base;
 	};
 
+	/* The base address of the ITS control register frame */
+	phys_addr_t		vgic_its_base;
+
 	/* Distributor enabled */
 	u32			enabled;
 
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index 1f42348..a8cf669 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -887,6 +887,7 @@ void vgic_v3_init_emulation(struct kvm *kvm)
 
 	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
 	dist->vgic_redist_base = VGIC_ADDR_UNDEF;
+	dist->vgic_its_base = VGIC_ADDR_UNDEF;
 
 	kvm->arch.max_vcpus = KVM_MAX_VCPUS;
 }
@@ -1059,6 +1060,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 			return -ENXIO;
 		case KVM_VGIC_V3_ADDR_TYPE_DIST:
 		case KVM_VGIC_V3_ADDR_TYPE_REDIST:
+		case KVM_VGIC_V3_ADDR_TYPE_ITS:
 			return 0;
 		}
 		break;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 59f1801..15e447f 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -930,6 +930,16 @@ int vgic_register_kvm_io_dev(struct kvm *kvm, gpa_t base, int len,
 	return ret;
 }
 
+bool vgic_has_its(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
+		return false;
+
+	return !IS_VGIC_ADDR_UNDEF(dist->vgic_its_base);
+}
+
 static int vgic_nr_shared_irqs(struct vgic_dist *dist)
 {
 	return dist->nr_irqs - VGIC_NR_PRIVATE_IRQS;
@@ -1927,6 +1937,12 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		block_size = KVM_VGIC_V3_REDIST_SIZE;
 		alignment = SZ_64K;
 		break;
+	case KVM_VGIC_V3_ADDR_TYPE_ITS:
+		type_needed = KVM_DEV_TYPE_ARM_VGIC_V3;
+		addr_ptr = &vgic->vgic_its_base;
+		block_size = KVM_VGIC_V3_ITS_SIZE;
+		alignment = SZ_64K;
+		break;
 #endif
 	default:
 		r = -ENODEV;
diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
index 0df74cb..a093f5c 100644
--- a/virt/kvm/arm/vgic.h
+++ b/virt/kvm/arm/vgic.h
@@ -136,5 +136,6 @@ int vgic_get_common_attr(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_init(struct kvm *kvm);
 void vgic_v2_init_emulation(struct kvm *kvm);
 void vgic_v3_init_emulation(struct kvm *kvm);
+bool vgic_has_its(struct kvm *kvm);
 
 #endif
-- 
2.3.5

