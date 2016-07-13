From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v9 10/17] KVM: arm64: introduce new KVM ITS device
Date: Wed, 13 Jul 2016 02:59:02 +0100
Message-ID: <20160713015909.28793-11-andre.przywara@arm.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76F8849B7D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2016 21:53:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7FYfz9fTEQMV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2016 21:53:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3221F49B8C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2016 21:53:16 -0400 (EDT)
In-Reply-To: <20160713015909.28793-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Introduce a new KVM device that represents an ARM Interrupt Translation
Service (ITS) controller. Since there can be multiple of this per guest,
we can't piggy back on the existing GICv3 distributor device, but create
a new type of KVM device.
On the KVM_CREATE_DEVICE ioctl we allocate and initialize the ITS data
structure and store the pointer in the kvm_device data.
Upon an explicit init ioctl from userland (after having setup the MMIO
address) we register the handlers with the kvm_io_bus framework.
Any reference to an ITS thus has to go via this interface.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt |  25 +++--
 arch/arm/kvm/arm.c                             |   1 +
 arch/arm64/include/uapi/asm/kvm.h              |   2 +
 include/kvm/arm_vgic.h                         |   3 +
 include/uapi/linux/kvm.h                       |   2 +
 virt/kvm/arm/vgic/vgic-its.c                   | 144 ++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic-kvm-device.c            |   7 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c               |   2 +-
 virt/kvm/arm/vgic/vgic.h                       |   8 ++
 9 files changed, 183 insertions(+), 11 deletions(-)

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
index 557e390..0d5c255 100644
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
index f209ea1..3051f86 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -87,9 +87,11 @@ struct kvm_regs {
 /* Supported VGICv3 address types  */
 #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
+#define KVM_VGIC_ITS_ADDR_TYPE		4
 
 #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
+#define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
 
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 685f339..8609fac 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -134,6 +134,7 @@ struct vgic_its {
 	gpa_t			vgic_its_base;
 
 	bool			enabled;
+	bool			initialized;
 	struct vgic_io_device	iodev;
 };
 
@@ -167,6 +168,8 @@ struct vgic_dist {
 
 	struct vgic_io_device	dist_iodev;
 
+	bool			has_its;
+
 	/*
 	 * Contains the attributes and gpa of the LPI configuration table.
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
index 06ad94d..393ad3a 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -21,6 +21,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
+#include <linux/uaccess.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
 
@@ -79,7 +80,7 @@ static struct vgic_register_region its_registers[] = {
 		VGIC_ACCESS_32bit),
 };
 
-int vgic_its_register(struct kvm *kvm, struct vgic_its *its)
+static int vgic_its_register(struct kvm *kvm, struct vgic_its *its)
 {
 	struct vgic_io_device *iodev = &its->iodev;
 	int ret;
@@ -93,8 +94,147 @@ int vgic_its_register(struct kvm *kvm, struct vgic_its *its)
 	iodev->its = its;
 	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
-				      SZ_64K, &iodev->dev);
+				      KVM_VGIC_V3_ITS_SIZE, &iodev->dev);
 	mutex_unlock(&kvm->slots_lock);
 
 	return ret;
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
+	its->initialized = false;
+	its->enabled = false;
+
+	dev->private = its;
+
+	return 0;
+}
+
+static void vgic_its_destroy(struct kvm_device *kvm_dev)
+{
+	struct vgic_its *its = kvm_dev->private;
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
+		if (its->initialized)
+			return -EBUSY;
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
+			if (its->initialized)
+				return 0;
+
+			if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base))
+				return -ENXIO;
+
+			ret = vgic_its_register(dev->kvm, its);
+			if (ret)
+				return ret;
+
+			its->initialized = true;
+			return 0;
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
index 4169e22..6cb52dd 100644
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
index 31807c1..9dc7207 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -42,6 +42,9 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
 void vgic_kick_vcpus(struct kvm *kvm);
 
+int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
+		      phys_addr_t addr, phys_addr_t alignment);
+
 void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu);
 void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
@@ -73,6 +76,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 bool vgic_has_its(struct kvm *kvm);
+int kvm_vgic_register_its_device(void);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -130,6 +134,10 @@ static inline bool vgic_has_its(struct kvm *kvm)
 	return false;
 }
 
+static inline int kvm_vgic_register_its_device(void)
+{
+	return -ENODEV;
+}
 #endif
 
 int kvm_register_vgic_device(unsigned long type);
-- 
2.9.0
