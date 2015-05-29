From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 04/13] KVM: arm64: Introduce new MMIO region for the ITS base address
Date: Fri, 29 May 2015 10:53:20 +0100
Message-ID: <1432893209-27313-5-git-send-email-andre.przywara@arm.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARM GICv3 ITS controller requires a separate register frame to
cover ITS specific registers. Add a new VGIC address type and store
the address in a field in the vgic_dist structure.
Provide a function to check whether userland has provided the address,
so ITS functionality can be guarded by that check.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt |  7 +++++++
 arch/arm64/include/uapi/asm/kvm.h              |  3 +++
 include/kvm/arm_vgic.h                         |  3 +++
 virt/kvm/arm/vgic-v3-emul.c                    |  1 +
 virt/kvm/arm/vgic.c                            | 17 +++++++++++++++++
 virt/kvm/arm/vgic.h                            |  1 +
 6 files changed, 32 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 3fb9054..1f89001 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -39,6 +39,13 @@ Groups:
       Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
       This address needs to be 64K aligned.
 
+    KVM_VGIC_V3_ADDR_TYPE_ITS (rw, 64-bit)
+      Base address in the guest physical address space of the GICv3 ITS
+      register frame. The ITS allows MSI(-X) interrupts to be injected
+      into guests. This extension is optional, if the kernel does not
+      support the ITS, the call returns -ENODEV.
+      Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
+      This address needs to be 64K aligned and the region covers 64 KByte.
 
   KVM_DEV_ARM_VGIC_GRP_DIST_REGS
   Attributes:
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index d268320..e42435c 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -82,8 +82,11 @@ struct kvm_regs {
 #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
 
+#define KVM_VGIC_V3_ADDR_TYPE_ITS	4
+
 #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
+#define KVM_VGIC_V3_ITS_SIZE		SZ_64K
 
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b18e2c5..37725bb 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -178,6 +178,9 @@ struct vgic_dist {
 		phys_addr_t		vgic_redist_base;
 	};
 
+	/* The base address for the MSI control block (V2M/ITS) */
+	phys_addr_t		vgic_its_base;
+
 	/* Distributor enabled */
 	u32			enabled;
 
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index fbfdd6f..16c6d8a 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -1012,6 +1012,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 			return -ENXIO;
 		case KVM_VGIC_V3_ADDR_TYPE_DIST:
 		case KVM_VGIC_V3_ADDR_TYPE_REDIST:
+		case KVM_VGIC_V3_ADDR_TYPE_ITS:
 			return 0;
 		}
 		break;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 6ea30e0..2e9723aa 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -932,6 +932,16 @@ int vgic_register_kvm_io_dev(struct kvm *kvm, gpa_t base, int len,
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
@@ -1835,6 +1845,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 	kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
 	kvm->arch.vgic.vgic_redist_base = VGIC_ADDR_UNDEF;
+	kvm->arch.vgic.vgic_its_base = VGIC_ADDR_UNDEF;
 
 out_unlock:
 	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
@@ -1932,6 +1943,12 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
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

