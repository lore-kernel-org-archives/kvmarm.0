From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v6 08/15] KVM: arm64: introduce new KVM ITS device
Date: Fri, 17 Jun 2016 13:08:40 +0100
Message-ID: <1466165327-32060-9-git-send-email-andre.przywara@arm.com>
References: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Introduce a new KVM device that represents an ARM Interrupt Translation
Service (ITS) controller. Since there can be multiple of this per guest,
we can't piggy back on the existing GICv3 distributor device, but create
a new type of KVM device.
On the KVM_CREATE_DEVICE ioctl we malloc and initialize the ITS data
structure and store the pointer in the kvm_device data.
Upon an explicit init ioctl from userland (after having setup the MMIO
address) we register the handlers with the kvm_io_bus framework.
Any reference to an ITS thus has to go via MMIO accesses.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt |  25 +++--
 arch/arm/kvm/arm.c                             |   1 +
 arch/arm64/include/uapi/asm/kvm.h              |   2 +
 include/kvm/vgic/vgic.h                        |   1 +
 include/uapi/linux/kvm.h                       |   2 +
 virt/kvm/arm/vgic/vgic-its.c                   | 131 ++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic-kvm-device.c            |   7 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c               |   2 +-
 virt/kvm/arm/vgic/vgic.h                       |   8 ++
 9 files changed, 168 insertions(+), 11 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 59541d4..89182f8 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -4,16 +4,22 @@ ARM Virtual Generic Interrupt Controller (VGIC)
 Device types supported:
   KVM_DEV_TYPE_ARM_VGIC_V2     ARM Generic Interrupt Controller v2.0
   KVM_DEV_TYPE_ARM_VGIC_V3     ARM Generic Interrupt Controller v3.0
+  KVM_DEV_TYPE_ARM_VGIC_ITS    ARM Interrupt Translation Service Controller
 
-Only one VGIC instance may be instantiated through either this API or the
-legacy KVM_CREATE_IRQCHIP api.  The created VGIC will act as the VM interrupt
-controller, requiring emulated user-space devices to inject interrupts to the
-VGIC instead of directly to CPUs.
+Only one VGIC instance of the V2/V3 types above may be instantiated through
+either this API or the legacy KVM_CREATE_IRQCHIP api.  The created VGIC will
+act as the VM interrupt controller, requiring emulated user-space devices to
+inject interrupts to the VGIC instead of directly to CPUs.
 
 Creating a guest GICv3 device requires a host GICv3 as well.
 GICv3 implementations with hardware compatibility support allow a guest GICv2
 as well.
 
+Creating a virtual ITS controller requires a host GICv3 (but does not depend
+on having physical ITS controllers).
+There can be multiple ITS controllers per guest, each of them has to have
+a separate, non-overlapping MMIO region.
+
 Groups:
   KVM_DEV_ARM_VGIC_GRP_ADDR
   Attributes:
@@ -39,6 +45,13 @@ Groups:
       Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
       This address needs to be 64K aligned.
 
+    KVM_VGIC_V3_ADDR_TYPE_ITS (rw, 64-bit)
+      Base address in the guest physical address space of the GICv3 ITS
+      control register frame. The ITS allows MSI(-X) interrupts to be
+      injected into guests. This extension is optional. If the kernel
+      does not support the ITS, the call returns -ENODEV.
+      Only valid for KVM_DEV_TYPE_ARM_VGIC_ITS.
+      This address needs to be 64K aligned and the region covers 128K.
 
   KVM_DEV_ARM_VGIC_GRP_DIST_REGS
   Attributes:
@@ -109,8 +122,8 @@ Groups:
   KVM_DEV_ARM_VGIC_GRP_CTRL
   Attributes:
     KVM_DEV_ARM_VGIC_CTRL_INIT
-      request the initialization of the VGIC, no additional parameter in
-      kvm_device_attr.addr.
+      request the initialization of the VGIC or ITS, no additional parameter
+      in kvm_device_attr.addr.
   Errors:
     -ENXIO: VGIC not properly configured as required prior to calling
      this attribute
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index a268c85..f4a953e 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -20,6 +20,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f209ea1..f8c257b 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -87,9 +87,11 @@ struct kvm_regs {
 /* Supported VGICv3 address types  */
 #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
+#define KVM_VGIC_ITS_ADDR_TYPE		4
 
 #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
+#define KVM_VGIC_V3_ITS_SIZE		SZ_64K
 
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index a66ba9a..979d8c3 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -158,6 +158,7 @@ struct vgic_dist {
 
 	struct vgic_io_device	dist_iodev;
 
+	bool			has_its;
 	/*
 	 * Contains the address of the LPI configuration table.
 	 * Since we report GICR_TYPER.CommonLPIAff as 0b00, we can share
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7de96f5..d8c4c32 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1077,6 +1077,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_FLIC		KVM_DEV_TYPE_FLIC
 	KVM_DEV_TYPE_ARM_VGIC_V3,
 #define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
+	KVM_DEV_TYPE_ARM_VGIC_ITS,
+#define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
 	KVM_DEV_TYPE_MAX,
 };
 
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index c02d9df..4ae3c82 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -21,6 +21,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
+#include <linux/uaccess.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
 
@@ -81,7 +82,7 @@ struct vgic_register_region its_registers[] = {
 		VGIC_ACCESS_32bit),
 };
 
-int vits_register(struct kvm *kvm, struct vgic_its *its)
+static int vits_register(struct kvm *kvm, struct vgic_its *its)
 {
 	struct vgic_io_device *iodev = &its->iodev;
 	int ret;
@@ -100,8 +101,134 @@ int vits_register(struct kvm *kvm, struct vgic_its *its)
 	return ret;
 }
 
-void vits_destroy(struct kvm *kvm, struct vgic_its *its)
+static void vits_destroy(struct kvm *kvm, struct vgic_its *its)
 {
 
 	its->enabled = false;
 }
+
+static int vgic_its_create(struct kvm_device *dev, u32 type)
+{
+	struct vgic_its *its;
+
+	if (type != KVM_DEV_TYPE_ARM_VGIC_ITS)
+		return -ENODEV;
+
+	its = kzalloc(sizeof(struct vgic_its), GFP_KERNEL);
+	if (!its)
+		return -ENOMEM;
+
+	its->vgic_its_base = VGIC_ADDR_UNDEF;
+
+	dev->kvm->arch.vgic.has_its = true;
+	its->enabled = false;
+
+	dev->private = its;
+
+	return 0;
+}
+
+static void vgic_its_destroy(struct kvm_device *dev)
+{
+	struct vgic_its *its = dev->private;
+
+	vits_destroy(dev->kvm, its);
+
+	kfree(its);
+}
+
+static int vgic_its_has_attr(struct kvm_device *dev,
+			     struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+		switch (attr->attr) {
+		case KVM_VGIC_ITS_ADDR_TYPE:
+			return 0;
+		}
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return 0;
+		}
+		break;
+	}
+	return -ENXIO;
+}
+
+static int vgic_its_set_attr(struct kvm_device *dev,
+			     struct kvm_device_attr *attr)
+{
+	struct vgic_its *its = dev->private;
+	int ret;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		unsigned long type = (unsigned long)attr->attr;
+		u64 addr;
+
+		if (type != KVM_VGIC_ITS_ADDR_TYPE)
+			return -ENODEV;
+
+		if (copy_from_user(&addr, uaddr, sizeof(addr)))
+			return -EFAULT;
+
+		ret = vgic_check_ioaddr(dev->kvm, &its->vgic_its_base,
+					addr, SZ_64K);
+		if (ret)
+			return ret;
+
+		its->vgic_its_base = addr;
+
+		return 0;
+	}
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return vits_register(dev->kvm, its);
+		}
+		break;
+	}
+	return -ENXIO;
+}
+
+static int vgic_its_get_attr(struct kvm_device *dev,
+			     struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
+		struct vgic_its *its = dev->private;
+		u64 addr = its->vgic_its_base;
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		unsigned long type = (unsigned long)attr->attr;
+
+		if (type != KVM_VGIC_ITS_ADDR_TYPE)
+			return -ENODEV;
+
+		if (copy_to_user(uaddr, &addr, sizeof(addr)))
+			return -EFAULT;
+		break;
+	default:
+		return -ENXIO;
+	}
+	}
+
+	return 0;
+}
+
+struct kvm_device_ops kvm_arm_vgic_its_ops = {
+	.name = "kvm-arm-vgic-its",
+	.create = vgic_its_create,
+	.destroy = vgic_its_destroy,
+	.set_attr = vgic_its_set_attr,
+	.get_attr = vgic_its_get_attr,
+	.has_attr = vgic_its_has_attr,
+};
+
+int kvm_vgic_register_its_device(void)
+{
+	return kvm_register_device_ops(&kvm_arm_vgic_its_ops,
+				       KVM_DEV_TYPE_ARM_VGIC_ITS);
+}
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 2f24f13..1813f93 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -21,8 +21,8 @@
 
 /* common helpers */
 
-static int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
-			     phys_addr_t addr, phys_addr_t alignment)
+int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
+		      phys_addr_t addr, phys_addr_t alignment)
 {
 	if (addr & ~KVM_PHYS_MASK)
 		return -E2BIG;
@@ -223,6 +223,9 @@ int kvm_register_vgic_device(unsigned long type)
 	case KVM_DEV_TYPE_ARM_VGIC_V3:
 		ret = kvm_register_device_ops(&kvm_arm_vgic_v3_ops,
 					      KVM_DEV_TYPE_ARM_VGIC_V3);
+		if (ret)
+			break;
+		ret = kvm_vgic_register_its_device();
 		break;
 #endif
 	}
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 4eee0d7..3a72308 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -49,7 +49,7 @@ bool vgic_has_its(struct kvm *kvm)
 	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
 		return false;
 
-	return false;
+	return dist->has_its;
 }
 
 static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index b09590d..24150f7 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -46,6 +46,9 @@ static inline void vgic_put_irq(struct vgic_irq *irq)
 bool vgic_queue_irq_put(struct kvm *kvm, struct vgic_irq *irq);
 void vgic_kick_vcpus(struct kvm *kvm);
 
+int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
+		      phys_addr_t addr, phys_addr_t alignment);
+
 void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu);
 void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
@@ -77,6 +80,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 bool vgic_has_its(struct kvm *kvm);
+int kvm_vgic_register_its_device(void);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -134,6 +138,10 @@ static inline bool vgic_has_its(struct kvm *kvm)
 	return false;
 }
 
+static inline int kvm_vgic_register_its_device(void)
+{
+	return -ENODEV;
+}
 #endif
 
 int kvm_register_vgic_device(unsigned long type);
-- 
2.8.2

