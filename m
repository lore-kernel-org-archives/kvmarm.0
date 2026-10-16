Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C79D257845
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166328; cv=none; b=YdR/i7MHcWng+wlCYgL/MSxI+2lmJDsi71FojQDCzCVG89fsaRAus+HjxiGl6QoB9wxDPfMM6KGl0jL/X74NsV3UHaSwrf6T7WyOoCLAWvkj9cSrMX1YaRqzKT8czBk4pHEsr7YjIEe4kX3wrrRhOEt5cRLoo56ERv4Vqq9RZQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166328; c=relaxed/simple;
	bh=X4fFti4arKiBTPUxtPKOpAGCQ2jJuLPsUVAud7zVDVk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UO9OFIGM8Qiw4cah+mqbJO7v5nfdZHTjUFCWhs7RHbgzMBOKQELfCuM4Q1dfweR9gQOEDcgBsSpXnRwghIJdSZFQT1tt+CK9v9ScbZBh5qO8yq1KHj/79pOG+0E/qGHvRbD6OxHC1A6vSoVDeEzwzyTjOvdIG5xEnUaKUZF0qvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uHcWGiJk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uHcWGiJk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69E001516;
	Fri, 16 Oct 2026 08:58:42 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B204C3F673;
	Fri, 16 Oct 2026 08:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792166325; bh=X4fFti4arKiBTPUxtPKOpAGCQ2jJuLPsUVAud7zVDVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHcWGiJkAaQaR//wJOE+ijRdOBansRQUFtJ35UvwekPFvXbFHV1O36qlf4d74Nzdo
	 xi+D7L62y9i5Qiljw4fPl3GCuqrZnoZTkRbTHtSzkc91leP5u61EJPMHB3+ulvtNyv
	 CKQEKfxIxZHeZ3xuSncjDFda6U5m9bnuBBCcW3/U=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	peter.maydell@linaro.org,
	lpieralisi@kernel.org,
	timothy.hayes@arm.com,
	fuad.tabba@linux.dev
Subject: [PATCH 05/16] KVM: arm64: gic-v5: Add ITS device skeleton
Date: Fri, 16 Oct 2026 16:57:30 +0100
Message-Id: <20261016155741.979985-6-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016155741.979985-1-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce the basic KVM device plumbing for a GICv5 ITS. This adds the
GICv5 ITS device type and address attribute, registers the device ops,
and wires a GICv5 ITS IODEV into the generic VGIC MMIO dispatch path.

Add struct vgic_v5_its to hold the ITS base address, the IODEV plumbing,
the backing KVM device pointer, and the general ITS mutex. Allocate this
state from the KVM device create path, initialise the mutex and base
address, and mark the VM as having an ITS. GICv5 MSIs require a DeviceID,
so set msis_require_devid when the ITS is created.

Record the VGIC model required by an ITS and reject mismatched device
creation in either order. Check GICv3 ITS creation as well, so the two
ITS models cannot be combined in one VM.

The MMIO region is registered once userspace provides the ITS base
address through KVM_VGIC_V5_ADDR_TYPE_ITS. For now the IODEV only
provides a RAZ/WI placeholder region; the actual ITS register emulation
is added separately.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h     |   2 +
 arch/arm64/kvm/Makefile               |   1 +
 arch/arm64/kvm/vgic/vgic-init.c       |   5 +
 arch/arm64/kvm/vgic/vgic-its-v5.c     | 187 ++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-its.c        |   9 ++
 arch/arm64/kvm/vgic/vgic-kvm-device.c |   4 +
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    |  10 --
 arch/arm64/kvm/vgic/vgic-mmio.c       |  18 +++
 arch/arm64/kvm/vgic/vgic-mmio.h       |   1 +
 arch/arm64/kvm/vgic/vgic.h            |   1 +
 include/kvm/arm_vgic.h                |  18 ++-
 include/uapi/linux/kvm.h              |   2 +
 tools/include/uapi/linux/kvm.h        |   2 +
 13 files changed, 249 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-its-v5.c

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 65ee09bd14636..8c701173a2d88 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -99,8 +99,10 @@ struct kvm_regs {
 
 /* Supported VGICv5 address types  */
 #define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+#define KVM_VGIC_V5_ADDR_TYPE_ITS	7
 
 #define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+#define KVM_VGIC_V5_ITS_SIZE		(2 * SZ_64K)
 
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 7aaeeb84e788e..47923e1047f16 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -25,6 +25,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
 	 vgic/vgic-v5.o vgic/vgic-v5-tables.o vgic/vgic-irs-v5.o \
+	 vgic/vgic-its-v5.o \
 	 vgic-sys-reg-v5.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index b5ea1e39c6862..48a92555fa6ab 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -125,6 +125,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		goto out_unlock;
 	}
 
+	if (kvm->arch.vgic.its_model && kvm->arch.vgic.its_model != type) {
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
 	if (kvm_id_regs_final(kvm))
 		goto out_unlock;
 	ret = 0;
diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
new file mode 100644
index 0000000000000..f8184b4ae0ccd
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 ARM Limited, All Rights Reserved.
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/slab.h>
+
+#include <asm/kvm_mmu.h>
+
+#include <kvm/arm_vgic.h>
+
+#include "vgic.h"
+#include "vgic-mmio.h"
+
+static unsigned long vgic_v5_mmio_read_its_raz(struct kvm *kvm, void *dev,
+					       gpa_t addr, unsigned int len)
+{
+	return 0;
+}
+
+static void vgic_v5_mmio_write_its_wi(struct kvm *kvm, void *dev, gpa_t addr,
+				      unsigned int len, unsigned long val)
+{
+}
+
+#define REGISTER_ITS_V5_DESC(off, rd, wr, length, acc)                 \
+	{                                                              \
+		.reg_offset = off, .len = length, .access_flags = acc, \
+		.its_read = rd, .its_write = wr,                       \
+	}
+
+static const struct vgic_register_region vgic_v5_its_registers[] = {
+	REGISTER_ITS_V5_DESC(0, vgic_v5_mmio_read_its_raz,
+			     vgic_v5_mmio_write_its_wi, KVM_VGIC_V5_ITS_SIZE,
+			     VGIC_ACCESS_32bit),
+};
+
+static int vgic_v5_its_create(struct kvm_device *dev, u32 type)
+{
+	struct vgic_v5_its *its;
+
+	if (type != KVM_DEV_TYPE_ARM_VGIC_V5_ITS)
+		return -ENODEV;
+
+	its = kzalloc_obj(*its, GFP_KERNEL_ACCOUNT);
+	if (!its)
+		return -ENOMEM;
+
+	mutex_init(&its->its_lock);
+
+	guard(mutex)(&dev->kvm->arch.config_lock);
+	if ((irqchip_in_kernel(dev->kvm) && !vgic_is_v5(dev->kvm)) ||
+	    (dev->kvm->arch.vgic.its_model &&
+	     dev->kvm->arch.vgic.its_model != KVM_DEV_TYPE_ARM_VGIC_V5)) {
+		kfree(its);
+		return -ENODEV;
+	}
+
+	its->vgic_v5_its_base = VGIC_ADDR_UNDEF;
+	its->dev = dev;
+
+	dev->kvm->arch.vgic.msis_require_devid = true;
+	dev->kvm->arch.vgic.has_its = true;
+	dev->kvm->arch.vgic.its_model = KVM_DEV_TYPE_ARM_VGIC_V5;
+	dev->private = its;
+
+	return 0;
+}
+
+static void vgic_v5_its_destroy(struct kvm_device *kvm_dev)
+{
+	struct vgic_v5_its *its = kvm_dev->private;
+
+	kfree(its);
+	kfree(kvm_dev);
+}
+
+static int vgic_v5_register_its_iodev(struct kvm *kvm, struct vgic_v5_its *its,
+				      u64 addr)
+{
+	struct vgic_io_device *iodev = &its->iodev;
+	int ret;
+
+	mutex_lock(&kvm->slots_lock);
+	if (!IS_VGIC_ADDR_UNDEF(its->vgic_v5_its_base)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (!IS_ALIGNED(addr, SZ_64K)) {
+		kvm_err("ITS Base address is not aligned to 64k\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	its->vgic_v5_its_base = addr;
+	iodev->base_addr = addr;
+	iodev->regions = vgic_v5_its_registers;
+	iodev->nr_regions = ARRAY_SIZE(vgic_v5_its_registers);
+	iodev->iodev_type = IODEV_GICV5_ITS;
+	iodev->redist_vcpu = NULL;
+	iodev->v5its = its;
+	kvm_iodevice_init(&iodev->dev, &kvm_io_gic_ops);
+
+	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
+				      KVM_VGIC_V5_ITS_SIZE, &iodev->dev);
+out:
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+
+static int vgic_v5_its_set_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	struct vgic_v5_its *its = dev->private;
+	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+	unsigned long type = (unsigned long)attr->attr;
+	u64 addr;
+	int ret;
+
+	if (attr->group != KVM_DEV_ARM_VGIC_GRP_ADDR)
+		return -ENXIO;
+
+	if (type != KVM_VGIC_V5_ADDR_TYPE_ITS)
+		return -ENODEV;
+
+	if (copy_from_user(&addr, uaddr, sizeof(addr)))
+		return -EFAULT;
+
+	ret = vgic_check_iorange(dev->kvm, its->vgic_v5_its_base, addr,
+				 SZ_64K, KVM_VGIC_V5_ITS_SIZE);
+	if (ret)
+		return ret;
+
+	return vgic_v5_register_its_iodev(dev->kvm, its, addr);
+}
+
+static int vgic_v5_its_get_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	struct vgic_v5_its *its = dev->private;
+	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+	unsigned long type = (unsigned long)attr->attr;
+	u64 addr = its->vgic_v5_its_base;
+
+	if (attr->group != KVM_DEV_ARM_VGIC_GRP_ADDR)
+		return -ENXIO;
+
+	if (type != KVM_VGIC_V5_ADDR_TYPE_ITS)
+		return -ENODEV;
+
+	if (copy_to_user(uaddr, &addr, sizeof(addr)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int vgic_v5_its_has_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	if (attr->group != KVM_DEV_ARM_VGIC_GRP_ADDR)
+		return -ENXIO;
+
+	switch (attr->attr) {
+	case KVM_VGIC_V5_ADDR_TYPE_ITS:
+		return 0;
+	default:
+		return -ENXIO;
+	}
+}
+
+static struct kvm_device_ops kvm_arm_vgic_v5_its_ops = {
+	.name = "kvm-arm-vgic-v5-its",
+	.create = vgic_v5_its_create,
+	.destroy = vgic_v5_its_destroy,
+	.set_attr = vgic_v5_its_set_attr,
+	.get_attr = vgic_v5_its_get_attr,
+	.has_attr = vgic_v5_its_has_attr,
+};
+
+int kvm_vgic_v5_register_its_device(void)
+{
+	return kvm_register_device_ops(&kvm_arm_vgic_v5_its_ops,
+				       KVM_DEV_TYPE_ARM_VGIC_V5_ITS);
+}
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index dff942b4f4233..6dfc2bab3ba60 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1823,6 +1823,14 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 
 	mutex_lock(&dev->kvm->arch.config_lock);
 
+	if ((irqchip_in_kernel(dev->kvm) && !vgic_is_v3(dev->kvm)) ||
+	    (dev->kvm->arch.vgic.its_model &&
+	     dev->kvm->arch.vgic.its_model != KVM_DEV_TYPE_ARM_VGIC_V3)) {
+		mutex_unlock(&dev->kvm->arch.config_lock);
+		kfree(its);
+		return -ENODEV;
+	}
+
 	if (vgic_initialized(dev->kvm)) {
 		ret = vgic_v4_init(dev->kvm);
 		if (ret < 0) {
@@ -1851,6 +1859,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 
 	dev->kvm->arch.vgic.msis_require_devid = true;
 	dev->kvm->arch.vgic.has_its = true;
+	dev->kvm->arch.vgic.its_model = KVM_DEV_TYPE_ARM_VGIC_V3;
 	its->enabled = false;
 	its->dev = dev;
 
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 1c205cb1361fd..e7630f68e2a74 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -369,6 +369,10 @@ int kvm_register_vgic_device(unsigned long type)
 	case KVM_DEV_TYPE_ARM_VGIC_V5:
 		ret = kvm_register_device_ops(&kvm_arm_vgic_v5_ops,
 					      KVM_DEV_TYPE_ARM_VGIC_V5);
+		if (ret)
+			break;
+
+		ret = kvm_vgic_v5_register_its_device();
 		break;
 	}
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5ab789accc9d4..f5e6c1fe52431 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -38,16 +38,6 @@ u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
 	return reg | ((u64)val << lower);
 }
 
-bool vgic_has_its(struct kvm *kvm)
-{
-	struct vgic_dist *dist = &kvm->arch.vgic;
-
-	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
-		return false;
-
-	return dist->has_its;
-}
-
 bool vgic_supports_direct_msis(struct kvm *kvm)
 {
 	/*
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index fddb9da0403d5..755bc2d74c352 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -1068,6 +1068,9 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 	case IODEV_GICV5_IRS:
 		data = region->read(vcpu, addr, len);
 		break;
+	case IODEV_GICV5_ITS:
+		data = region->its_read(vcpu->kvm, iodev->v5its, addr, len);
+		break;
 	}
 
 	vgic_data_host_to_mmio_bus(val, len, data);
@@ -1101,6 +1104,9 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 	case IODEV_GICV5_IRS:
 		region->write(vcpu, addr, len, data);
 		break;
+	case IODEV_GICV5_ITS:
+		region->its_write(vcpu->kvm, iodev->v5its, addr, len, data);
+		break;
 	}
 
 	return 0;
@@ -1135,3 +1141,15 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 	return kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, dist_base_address,
 				       len, &io_device->dev);
 }
+
+bool vgic_has_its(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	if (vgic_is_v3(kvm) && dist->has_its)
+		return true;
+	if (vgic_is_v5(kvm) && dist->has_its)
+		return true;
+
+	return false;
+}
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
index c3b6d3e752d8d..37fee94ac2a0a 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.h
+++ b/arch/arm64/kvm/vgic/vgic-mmio.h
@@ -218,6 +218,7 @@ unsigned int vgic_v2_init_cpuif_iodev(struct vgic_io_device *dev);
 unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
 
 unsigned int vgic_v5_init_irs_iodev(struct vgic_io_device *dev);
+unsigned int vgic_v5_init_its_iodev(struct vgic_io_device *dev);
 
 u64 vgic_sanitise_outer_cacheability(u64 reg);
 u64 vgic_sanitise_inner_cacheability(u64 reg);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 66044232ae025..5a9aa9bd11dd7 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -361,6 +361,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu);
 
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
+int kvm_vgic_v5_register_its_device(void);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu);
 int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7be81b936bf10..f3bfeee6104c2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -324,7 +324,8 @@ enum iodev_type {
 	IODEV_DIST,
 	IODEV_REDIST,
 	IODEV_ITS,
-	IODEV_GICV5_IRS
+	IODEV_GICV5_IRS,
+	IODEV_GICV5_ITS
 };
 
 struct vgic_io_device {
@@ -332,6 +333,7 @@ struct vgic_io_device {
 	union {
 		struct kvm_vcpu *redist_vcpu;
 		struct vgic_its *its;
+		struct vgic_v5_its *v5its;
 	};
 	const struct vgic_register_region *regions;
 	enum iodev_type iodev_type;
@@ -496,6 +498,18 @@ struct vgic_v5_irs {
 	bool lpi_ist_restore_pending;
 };
 
+/*** GICv5 ***/
+struct vgic_v5_its {
+	/* base addresses in guest physical address space: */
+	gpa_t vgic_v5_its_base;
+
+	struct vgic_io_device iodev;
+	struct kvm_device *dev;
+
+	/* Protects the device in general */
+	struct mutex		its_lock;
+};
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
@@ -548,6 +562,8 @@ struct vgic_dist {
 	struct vgic_io_device	cpuif_iodev;
 
 	bool			has_its;
+	/* VGIC model required by the VM's ITS devices. */
+	u32			its_model;
 	bool			table_write_in_progress;
 
 	/*
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ac2d77d149635..4e16c55902f5e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1238,6 +1238,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_DMSINTC	KVM_DEV_TYPE_LOONGARCH_DMSINTC
 	KVM_DEV_TYPE_ARM_VGIC_V5,
 #define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
+	KVM_DEV_TYPE_ARM_VGIC_V5_ITS,
+#define KVM_DEV_TYPE_ARM_VGIC_V5_ITS	KVM_DEV_TYPE_ARM_VGIC_V5_ITS
 
 	KVM_DEV_TYPE_MAX,
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 419011097fa8e..99cf4775ed083 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1236,6 +1236,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_DMSINTC	KVM_DEV_TYPE_LOONGARCH_DMSINTC
 	KVM_DEV_TYPE_ARM_VGIC_V5,
 #define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
+	KVM_DEV_TYPE_ARM_VGIC_V5_ITS,
+#define KVM_DEV_TYPE_ARM_VGIC_V5_ITS	KVM_DEV_TYPE_ARM_VGIC_V5_ITS
 
 	KVM_DEV_TYPE_MAX,
 
-- 
2.34.1

