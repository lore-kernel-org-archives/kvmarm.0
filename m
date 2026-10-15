Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C027B55408F
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074422; cv=none; b=AVsEWqG0tz5VIf090WiLGqkDC3FMGzth00GQCterIboX6MJbl7dQEQc5k58eEVjShdxYxenQrOmdmzTs0JY8XEZ9twyJxjHy4aC7SxZ9IVc6XO4nbCK8oJneT7gFTvJ7MyoYjC2RPX39T55YxVudVM/INqAJMrAni/yI499e3qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074422; c=relaxed/simple;
	bh=6zJkdln/lwFAx0j11y2Tqo0Fge5mRgoV7t4ssd1rzXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfhQOhqwBv1+Aq5kXwYmc+/NlMP9lu7Z9H/M4h28Byyrc7t1VMwS0fjyOquSuR5+TldVr4lIj+uXb+iTuAVbE/wpknEuM8K83hFGyp4XtOcPOgD7HM5e2J34bf99HvYqPo2rwF+zn8E6tZfTjPP57BA05LfUP9cIGrzmvXK000g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cfBWzX7Y; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cfBWzX7Y"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C81816F8;
	Thu, 15 Oct 2026 07:26:52 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7FB6E3F871;
	Thu, 15 Oct 2026 07:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074415; bh=6zJkdln/lwFAx0j11y2Tqo0Fge5mRgoV7t4ssd1rzXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cfBWzX7YPsIAlT14io4tMDz1ApqxSWGQAponpdxy92FR0NicTQ6CvbEAXL0Snq6VR
	 npc9Am0ZYDfuvMJaqXoltnafkNQU4MUvyeECZEJdiKCeICKnEZAcfC+WBY+3gGeECa
	 YLoJCi0InAcmjyCJ5ixTEw7KaLM2Owbk2D/l14UM=
From: Ryan Roberts <ryan.roberts@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 15/15] misc/arm-cla: Add vfio-mdev user interface
Date: Thu, 15 Oct 2026 15:25:49 +0100
Message-ID: <20261015142552.4128028-16-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015142552.4128028-1-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jpb@kernel.org>

Implement an interface to assign CLA devices to KVM guests. To creates a
CLA instance:

    uuid=$(uuidgen)
    echo $uuid > /sys/class/mdev_bus/<pdev>/mdev_supported_types/arm-cla-pl1/create
    cla_cpu=$(< /sys/bus/mdev/devices/$uuid/cpu)

This creates a user interface in /dev/vfio: a VFIO group in
/dev/vfio/<n>, discoverable by reading the symlink
/sys/bus/mdev/devices/$uuid/iommu_group. Although CLA does not use an
IOMMU, VFIO relies on IOMMU groups as an assignable unit. Here they
correspond to CLA domains, whose devices communicate through a private
bus.

The CLA device gets assigned exclusively to the first VMM that opens the
VFIO group and device. To launch a VM with a CLA attached to vCPU #4,
with kvmtool:

    lkvm run -k Image --console virtio -c 8
	--vfio-platform $uuid,type=arm-cla,vcpu=4
	--vcpu-affinity 4=$cla_cpu	# Bind vCPU 4 to the CLA's CPU

Opens the group, gets the device fd, mmaps the frame, and launches the
guest. The given vCPU thread is pinned to the CLA's CPU.

Pinning vCPUs is not guaranteed. If the host decides to power off the
CPUs with assigned CLAs, the guest application can't access the assigned
device anymore. It would now access a RAZ/WI memory region.

For DMA, because the TLB entries tagged with VMID+ASID are shared
between CPU and accelerator, we pin the VMID. The stage 2 page tables
are shared between CPU and CLA. CLA reports DMA page faults directly to
the user, who performs the access from the CPU to handle both stage 1
and stage 2 faults.

Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
---
 drivers/misc/arm-cla/Kconfig        |  16 +
 drivers/misc/arm-cla/Makefile       |   2 +
 drivers/misc/arm-cla/arm-cla.h      |  48 +++
 drivers/misc/arm-cla/cla-init.c     |  11 +-
 drivers/misc/arm-cla/cla-mdev.c     | 469 ++++++++++++++++++++++++++++
 drivers/misc/arm-cla/cla-topology.c |   9 +-
 6 files changed, 553 insertions(+), 2 deletions(-)
 create mode 100644 drivers/misc/arm-cla/cla-mdev.c

diff --git a/drivers/misc/arm-cla/Kconfig b/drivers/misc/arm-cla/Kconfig
index f8436a12c1e6..5def727b7a34 100644
--- a/drivers/misc/arm-cla/Kconfig
+++ b/drivers/misc/arm-cla/Kconfig
@@ -8,3 +8,19 @@ config ARM_CLA
 	  accelerators. It is only accessible from its associated CPU.
 
 	  If unsure, say N.
+
+config ARM_CLA_MDEV
+	bool "Mediated device for Arm CLA"
+	default y
+	depends on KVM
+	depends on VFIO
+	depends on ARM_CLA
+	depends on VFIO_GROUP
+	select VFIO_MDEV
+	help
+	  Enable the VFIO mediated device interface for assigning Arm Core Local
+	  Accelerators (CLAs) to KVM guests. Guests can access the CLA PL0 and
+	  PL1 registers, while the host controls stage 2 address translation.
+	  Devices in the same CLA domain can only be assigned to the same guest.
+
+	  If unsure, say N.
diff --git a/drivers/misc/arm-cla/Makefile b/drivers/misc/arm-cla/Makefile
index f848c608e8f1..973390d0b428 100644
--- a/drivers/misc/arm-cla/Makefile
+++ b/drivers/misc/arm-cla/Makefile
@@ -11,3 +11,5 @@ arm-cla-y := \
 	cla-user.o
 
 obj-$(CONFIG_ARM_CLA) += arm-cla.o
+
+arm-cla-$(CONFIG_ARM_CLA_MDEV) += cla-mdev.o
diff --git a/drivers/misc/arm-cla/arm-cla.h b/drivers/misc/arm-cla/arm-cla.h
index 43a58a329525..93365f525abb 100644
--- a/drivers/misc/arm-cla/arm-cla.h
+++ b/drivers/misc/arm-cla/arm-cla.h
@@ -14,6 +14,7 @@
 #include <linux/kref.h>
 #include <linux/kthread.h>
 #include <linux/list.h>
+#include <linux/mdev.h>
 #include <linux/mm.h>
 #include <linux/mm_types.h>
 #include <linux/mutex.h>
@@ -51,6 +52,11 @@ struct cla_accel_desc {
 	u64 revidr;
 };
 
+enum cla_mdev_type {
+	CLA_MDEV_TYPE_PL1,
+	CLA_MDEV_NUM_TYPES,
+};
+
 /**
  * struct cla_dev - CLA device
  *
@@ -71,6 +77,11 @@ struct cla_accel_desc {
  * @broken:		Hardware failure.
  * @worker:		CPU-bound worker to communicate with CLA.
  * @call:		Scheduling work.
+ *
+ * Other mutable state:
+ * @mdev_parent:	Mdev structure for the VFIO interface.
+ * @mdev_types:		Mdev types that can be created from this device.
+ * @mdev_types_ptr:	Pointers to @mdev_type.
  */
 struct cla_dev {
 	unsigned int cpu;
@@ -88,6 +99,12 @@ struct cla_dev {
 	bool broken;
 	struct kthread_worker *worker;
 	struct cla_call_on_cpu call;
+
+#if IS_ENABLED(CONFIG_ARM_CLA_MDEV)
+	struct mdev_parent mdev_parent;
+	struct mdev_type mdev_types[CLA_MDEV_NUM_TYPES];
+	struct mdev_type *mdev_types_ptr[CLA_MDEV_NUM_TYPES];
+#endif
 };
 
 /**
@@ -100,6 +117,7 @@ struct cla_dev {
  * @pg_offset:		Mmap offset of the first device.
  * @nr_devs:		Number of devices in the domain.
  * @devs:		Devices.
+ * @iommu_group:	Handle for VFIO group.
  *
  * Mutable, only accessed under @lock:
  * @lock:		Protects the following members.
@@ -127,6 +145,10 @@ struct cla_domain {
 	struct cla_ctx *assigned_ctx;
 	struct kthread_worker *worker;
 	struct kthread_delayed_work reassign;
+
+#if IS_ENABLED(CONFIG_ARM_CLA_MDEV)
+	struct iommu_group *iommu_group;
+#endif
 };
 
 /**
@@ -187,6 +209,12 @@ struct cla_ctx_key {
 		.file = (_file),		\
 	}
 
+#define CLA_CTX_KEY_PL1(_kvm)			\
+	{					\
+		.type = CLA_CTX_PL1,		\
+		.kvm = (_kvm),			\
+	}
+
 /**
  * struct cla_ctx - Domain context
  *
@@ -342,4 +370,24 @@ int cla_user_init(void);
 void cla_user_exit(void);
 u8 cla_user_accels(struct cla_dev *dev, struct file *file);
 
+#if IS_ENABLED(CONFIG_ARM_CLA_MDEV)
+int cla_mdev_init(void);
+void cla_mdev_exit(void);
+void cla_mdev_enable(void);
+int cla_domain_mdev_init(struct cla_domain *domain);
+void cla_domain_mdev_exit(struct cla_domain *domain);
+#else
+static inline int cla_mdev_init(void)
+{
+	return 0;
+}
+static inline void cla_mdev_exit(void) {}
+static inline void cla_mdev_enable(void) {}
+static inline int cla_domain_mdev_init(struct cla_domain *domain)
+{
+	return 0;
+}
+static inline void cla_domain_mdev_exit(struct cla_domain *domain) {}
+#endif
+
 #endif /* _ARM_CLA_H_ */
diff --git a/drivers/misc/arm-cla/cla-init.c b/drivers/misc/arm-cla/cla-init.c
index 1afe20aa877f..a0067240809a 100644
--- a/drivers/misc/arm-cla/cla-init.c
+++ b/drivers/misc/arm-cla/cla-init.c
@@ -393,6 +393,7 @@ static struct cla_dev *cla_dev_alloc(struct device *parent, int cpu,
 	dev->regs = cla_get_regs(regs, cla_kernel_pl);
 	dev->cpu = cpu;
 	dev->dev = parent;
+	dev_set_drvdata(parent, dev);
 
 	kthread_init_work(&dev->call.switch_ctx, cla_dev_switch_ctx_work);
 
@@ -519,13 +520,20 @@ static int __init cla_module_init(void)
 		cla_cpuhp_state = ret;
 	}
 
+	ret = cla_mdev_init();
+	if (ret)
+		goto err_hardware;
+
 	/* Must be last fallible step; see cla_user_init(). */
 	ret = cla_user_init();
 	if (ret)
-		goto err_hardware;
+		goto err_mdev_exit;
 
+	cla_mdev_enable();
 	return 0;
 
+err_mdev_exit:
+	cla_mdev_exit();
 err_hardware:
 	cla_domains_sched_exit();
 	if (cla_cpuhp_state >= 0)
@@ -539,6 +547,7 @@ static int __init cla_module_init(void)
 static void __exit cla_module_exit(void)
 {
 	cla_user_exit();
+	cla_mdev_exit();
 	cla_domains_sched_exit();
 	cpuhp_remove_state(cla_cpuhp_state);
 	cla_domains_free();
diff --git a/drivers/misc/arm-cla/cla-mdev.c b/drivers/misc/arm-cla/cla-mdev.c
new file mode 100644
index 000000000000..66c5dd197542
--- /dev/null
+++ b/drivers/misc/arm-cla/cla-mdev.c
@@ -0,0 +1,469 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Arm CLA driver - vfio-mdev interface
+ *
+ * Copyright 2026 Arm Limited.
+ */
+
+#include <linux/cpuhplock.h>
+#include <linux/vfio.h>
+#include <linux/mdev.h>
+
+#include "arm-cla.h"
+
+struct cla_mdev {
+	struct vfio_device vdev;
+	struct cla_dev *dev;
+	enum cla_mdev_type type;
+};
+
+static bool cla_mdev_ready;
+
+/*
+ * Logical CPU number. After mdev creation, this attribute appears in
+ * /sys/bus/mdev/devices/$uuid/cpu
+ *
+ * This information is crucial to the user, because the device is only
+ * accessible from this CPU.
+ */
+static ssize_t cpu_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct cla_mdev *mdev = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%u\n", mdev->dev->cpu);
+}
+DEVICE_ATTR_RO(cpu);
+
+static const struct attribute *const cla_mdev_sysfs_attrs[] = {
+	&dev_attr_cpu.attr, /* CPU ID */
+	NULL,
+};
+ATTRIBUTE_GROUPS(cla_mdev_sysfs);
+
+static const struct mdev_type cla_mdev_types[CLA_MDEV_NUM_TYPES] = {
+	/*
+	 * Assign the PL0 and PL1 registers, with PL2 controlled by the
+	 * kernel (or hypervisor)
+	 */
+	[CLA_MDEV_TYPE_PL1] = {
+		.sysfs_name = "pl1",
+		.pretty_name = "CLA PL1 and PL0 registers exclusively owned",
+	},
+};
+
+static int cla_mdev_switch_ctx(struct cla_dev *dev, struct cla_ctx *prev,
+			       struct cla_ctx *next)
+{
+	struct cla_call_on_cpu *call = &dev->call;
+
+	lockdep_assert_cpus_held();
+
+	/*
+	 * No race with reassignment work because we're holding the domain lock
+	 * and we're domain->assigned_ctx.
+	 */
+	call->sched.prev_ctx = prev;
+	call->sched.next_ctx = next;
+	call->ret = 0;
+	if (dev->worker && !dev->broken)
+		kthread_queue_work(dev->worker, &call->switch_ctx);
+
+	kthread_flush_work(&call->switch_ctx);
+
+	return call->ret;
+}
+
+/*
+ * Perform a RESET on all accelerators for this dev and clear the CLA
+ * regs. The VMM calls this when rebooting a VM. It doesn't need to be
+ * efficient. Other devices in the domain are not reset.
+ */
+static int cla_mdev_reset(struct cla_mdev *mdev)
+{
+	int ret = 0;
+	struct cla_ctx *ctx;
+	struct cla_dev *dev = mdev->dev;
+	struct cla_domain *domain = dev->domain;
+
+	/* Hotplug callbacks may take domain->lock, so acquire this first. */
+	cpus_read_lock();
+	mutex_lock(&domain->lock);
+	if (domain->broken) {
+		ret = -EIO;
+		goto out_unlock;
+	}
+
+	ctx = domain->assigned_ctx;
+	/*
+	 * This function is only reachable when a valid PL1 ctx corresponding to
+	 * the VM is assigned to the domain: cla_mdev_open_device() waits for
+	 * the ctx to be assigned, and the ctx only gets deassigned when the
+	 * file has no reference anymore (no ioctl possible). So the following
+	 * are all bugs.
+	 */
+	if (WARN_ON(!ctx) ||
+	    WARN_ON(!cla_ctx_is_pl1(ctx)) ||
+	    WARN_ON(ctx->key.kvm != mdev->vdev.kvm)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/*
+	 * This provides a clean config. The stage 1 MTC is clear. The
+	 * accelerators and CLA regs are reset.
+	 */
+	ret = cla_mdev_switch_ctx(dev, ctx, NULL);
+	if (ret)
+		goto out_unlock;
+
+	ret = cla_mdev_switch_ctx(dev, NULL, ctx);
+out_unlock:
+	if (ret)
+		cla_domain_set_broken(domain);
+	mutex_unlock(&domain->lock);
+	cpus_read_unlock();
+	return ret;
+}
+
+static int cla_mdev_open_device(struct vfio_device *vdev)
+{
+	struct cla_mdev *mdev =
+		container_of(vdev, struct cla_mdev, vdev);
+	struct cla_domain *domain = mdev->dev->domain;
+	struct cla_ctx_key key = CLA_CTX_KEY_PL1(vdev->kvm);
+	struct cla_ctx *ctx;
+	int ret;
+
+	/*
+	 * The user registers a KVM instance with this VFIO group. We use it to
+	 * program the stage-2 MTC. stage-1 MTC is managed by the user/guest.
+	 * KVM, if present, is valid for the lifetime of the vfio device file.
+	 */
+	if (!vdev->kvm)
+		return -EINVAL;
+
+	/*
+	 * Obtain a context for exclusive assignment. If other contexts exist
+	 * for this domain, this returns an error. Other devices assigned to the
+	 * same VM within the same domain get the same context.
+	 */
+	ctx = cla_ctx_create(domain, &key);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	mutex_lock(&domain->lock);
+	if (domain->broken) {
+		ret = -EIO;
+		goto err_destroy;
+	}
+
+	/* Not assigned and not queued, assign it. */
+	if (domain->assigned_ctx != ctx && list_empty(&ctx->queue_node)) {
+		list_add_tail(&ctx->queue_node, &domain->queued_ctxs);
+		cla_domain_schedule_reassignment(domain);
+	}
+	mutex_unlock(&domain->lock);
+
+	ret = wait_event_interruptible(ctx->waitq,
+				       READ_ONCE(domain->assigned_ctx) == ctx ||
+				       READ_ONCE(domain->broken));
+
+	mutex_lock(&domain->lock);
+	/*
+	 * At this point the context is either assigned or still in the queue
+	 * (if we were interrupted). In case of error, cla_ctx_destroy() kills the
+	 * context and deassigns it.
+	 */
+	if (ret)
+		goto err_destroy;
+
+	if (domain->broken) {
+		ret = -EIO;
+		goto err_destroy;
+	}
+	mutex_unlock(&domain->lock);
+	return 0;
+
+err_destroy:
+	mutex_unlock(&domain->lock);
+	cla_ctx_destroy(domain, &key);
+	return ret;
+}
+
+static void cla_mdev_close_device(struct vfio_device *vdev)
+{
+	struct cla_mdev *mdev =
+		container_of(vdev, struct cla_mdev, vdev);
+	struct cla_ctx_key key = CLA_CTX_KEY_PL1(vdev->kvm);
+
+	cla_ctx_destroy(mdev->dev->domain, &key);
+}
+
+static long cla_mdev_ioctl(struct vfio_device *vdev, unsigned int cmd,
+			       unsigned long arg)
+{
+	struct cla_mdev *mdev =
+		container_of(vdev, struct cla_mdev, vdev);
+	unsigned long minsz;
+
+	switch (cmd) {
+	case VFIO_DEVICE_GET_INFO:
+	{
+		struct vfio_device_info info;
+
+		minsz = offsetofend(struct vfio_device_info, num_irqs);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		info.flags = VFIO_DEVICE_FLAGS_PLATFORM |
+			     VFIO_DEVICE_FLAGS_RESET;
+		info.num_regions = 1;
+		info.num_irqs = 0;
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			return -EFAULT;
+
+		return 0;
+	}
+	case VFIO_DEVICE_RESET:
+		return cla_mdev_reset(mdev);
+	case VFIO_DEVICE_GET_IRQ_INFO:
+	case VFIO_DEVICE_SET_IRQS:
+	default:
+		return -EINVAL;
+	}
+	return -ENOTTY;
+}
+
+static int cla_mdev_get_region_info_caps(struct vfio_device *vdev,
+					  struct vfio_region_info *region_info,
+					  struct vfio_info_cap *caps)
+{
+	if (region_info->index != 0)
+		return -EINVAL;
+
+	region_info->offset = 0;
+	region_info->size = 2 * CLA_REG_SIZE;
+	region_info->flags = VFIO_REGION_INFO_FLAG_MMAP |
+			     VFIO_REGION_INFO_FLAG_READ |
+			     VFIO_REGION_INFO_FLAG_WRITE;
+	return 0;
+}
+
+/* Mmap PL0 + PL1 frames. */
+static int cla_mdev_mmap(struct vfio_device *vdev, struct vm_area_struct *vma)
+{
+	struct cla_mdev *mdev =
+		container_of(vdev, struct cla_mdev, vdev);
+	unsigned long vm_flags_required = VM_SHARED | VM_READ | VM_WRITE;
+	size_t map_size = vma->vm_end - vma->vm_start;
+	size_t region_size = 2 * CLA_REG_SIZE;
+
+	if (vma->vm_pgoff != 0)
+		return -EINVAL;
+
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if (map_size != region_size)
+		return -EINVAL;
+	if ((vma->vm_flags & vm_flags_required) != vm_flags_required)
+		return -EINVAL;
+	if (vma->vm_flags & VM_EXEC)
+		return -EINVAL;
+
+	vm_flags_mod(vma, VM_DONTCOPY | VM_DONTDUMP | VM_DONTEXPAND |
+			  VM_IO | VM_PFNMAP, VM_MAYEXEC);
+	vma->vm_page_prot = pgprot_device(vma->vm_page_prot);
+
+	return remap_pfn_range(vma, vma->vm_start, mdev->dev->pfn, map_size,
+			       vma->vm_page_prot);
+}
+
+static const struct vfio_device_ops cla_mdev_pl1_ops = {
+	.name = "vfio-arm-cla-pl1",
+	.open_device = cla_mdev_open_device,
+	.close_device = cla_mdev_close_device,
+	.ioctl = cla_mdev_ioctl,
+	.get_region_info_caps = cla_mdev_get_region_info_caps,
+	.mmap = cla_mdev_mmap,
+};
+
+/*
+ * Admin creates an mdev device
+ *
+ *	uuid=$(uuidgen)
+ *	echo $uuid > /sys/class/mdev_bus/<pdev>/mdev_supported_types/arm-cla-pl1/create
+ */
+static int cla_mdev_probe(struct mdev_device *mdev)
+{
+	int ret = -ENODEV;
+	struct cla_dev *dev;
+	enum cla_mdev_type type;
+	struct cla_mdev *cla_mdev;
+
+	/* Ensure the module isn't being removed */
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	/* Ensure the module has finished initializing */
+	if (!smp_load_acquire(&cla_mdev_ready))
+		goto err_put_module;
+
+	dev = dev_get_drvdata(mdev->dev.parent);
+	type = mdev->type - dev->mdev_types;
+
+	ret = -EINVAL;
+	if (WARN_ON(type < 0 || type >= CLA_MDEV_NUM_TYPES))
+		goto err_put_module;
+
+	cla_mdev = vfio_alloc_device(cla_mdev, vdev, &mdev->dev,
+				     &cla_mdev_pl1_ops);
+	if (IS_ERR(cla_mdev)) {
+		ret = PTR_ERR(cla_mdev);
+		goto err_put_module;
+	}
+
+	cla_mdev->dev = dev;
+	cla_mdev->type = type;
+
+	dev_set_drvdata(&mdev->dev, cla_mdev);
+
+	ret = iommu_group_add_device(dev->domain->iommu_group, &mdev->dev);
+	if (ret)
+		goto err_put_vdev;
+
+	ret = vfio_register_cpu_mmu_dev(&cla_mdev->vdev);
+	if (ret)
+		goto err_put_group;
+
+	return 0;
+
+err_put_group:
+	iommu_group_remove_device(&mdev->dev);
+err_put_vdev:
+	dev_set_drvdata(&mdev->dev, NULL);
+	vfio_put_device(&cla_mdev->vdev);
+err_put_module:
+	module_put(THIS_MODULE);
+	return ret;
+}
+
+/*
+ * Admin removes an mdev device
+ *
+ *	echo 1 > /sys/bus/mdev/devices/$uuid/remove
+ */
+static void cla_mdev_remove(struct mdev_device *mdev)
+{
+	struct cla_mdev *cla_mdev = dev_get_drvdata(&mdev->dev);
+
+	vfio_unregister_group_dev(&cla_mdev->vdev);
+	iommu_group_remove_device(&mdev->dev);
+	dev_set_drvdata(&mdev->dev, NULL);
+	vfio_put_device(&cla_mdev->vdev);
+	module_put(THIS_MODULE);
+}
+
+static struct mdev_driver cla_mdev_driver = {
+	.device_api = VFIO_DEVICE_API_PLATFORM_STRING,
+	.max_instances = 1,
+	.driver = {
+		.name = "arm-cla-mdev",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+		.dev_groups = cla_mdev_sysfs_groups,
+	},
+	.probe = cla_mdev_probe,
+	.remove	= cla_mdev_remove,
+};
+
+/* Allocate IOMMU groups so VFIO can create its groups based on CLA domains */
+int cla_domain_mdev_init(struct cla_domain *domain)
+{
+	struct iommu_group *iommu_group;
+
+	if (cla_kernel_pl < 2)
+		return 0;
+
+	iommu_group = iommu_group_alloc();
+	if (IS_ERR(iommu_group))
+		return PTR_ERR(iommu_group);
+
+	domain->iommu_group = iommu_group;
+	return 0;
+}
+
+void cla_domain_mdev_exit(struct cla_domain *domain)
+{
+	iommu_group_put(domain->iommu_group);
+}
+
+int __init cla_mdev_init(void)
+{
+	int i, j;
+	int ret;
+	struct cla_dev *dev;
+
+	if (cla_kernel_pl < 2)
+		return 0;
+
+	ret = mdev_register_driver(&cla_mdev_driver);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < cla_nr_devs; i++) {
+		dev = cla_lut_pg[i];
+
+		/*
+		 * mdev_type is a kobj in sysfs, so it cannot be shared between
+		 * CLAs. Each CLA needs its own instance.
+		 */
+		BUILD_BUG_ON(sizeof(cla_mdev_types) != sizeof(dev->mdev_types));
+		memcpy(dev->mdev_types, cla_mdev_types, sizeof(cla_mdev_types));
+		for (j = 0; j < CLA_MDEV_NUM_TYPES; j++)
+			dev->mdev_types_ptr[j] = &dev->mdev_types[j];
+
+		ret = mdev_register_parent(&dev->mdev_parent, dev->dev,
+					   &cla_mdev_driver, dev->mdev_types_ptr,
+					   CLA_MDEV_NUM_TYPES);
+		if (ret)
+			goto err_unregister;
+	}
+
+	return 0;
+
+err_unregister:
+	for (i--; i >= 0; i--) {
+		dev = cla_lut_pg[i];
+		mdev_unregister_parent(&dev->mdev_parent);
+	}
+	mdev_unregister_driver(&cla_mdev_driver);
+	return ret;
+}
+
+/* Enable the interface, once the module initialization is complete */
+void __init cla_mdev_enable(void)
+{
+	/* Synchronize with cla_mdev_probe() */
+	smp_store_release(&cla_mdev_ready, true);
+}
+
+void cla_mdev_exit(void)
+{
+	int i;
+
+	if (cla_kernel_pl < 2)
+		return;
+
+	for (i = 0; i < cla_nr_devs; i++) {
+		struct cla_dev *dev = cla_lut_pg[i];
+
+		mdev_unregister_parent(&dev->mdev_parent);
+	}
+	mdev_unregister_driver(&cla_mdev_driver);
+}
diff --git a/drivers/misc/arm-cla/cla-topology.c b/drivers/misc/arm-cla/cla-topology.c
index ed7acec70019..ead6c25c6391 100644
--- a/drivers/misc/arm-cla/cla-topology.c
+++ b/drivers/misc/arm-cla/cla-topology.c
@@ -51,12 +51,18 @@ static struct cla_domain *cla_domain_alloc(struct cla_dev *dev, unsigned int fwi
 	}
 	domain->devs[0] = dev;
 
-	ret = cla_domain_sched_init(domain);
+	ret = cla_domain_mdev_init(domain);
 	if (ret)
 		goto err_free_devs;
 
+	ret = cla_domain_sched_init(domain);
+	if (ret)
+		goto err_exit_mdev;
+
 	return domain;
 
+err_exit_mdev:
+	cla_domain_mdev_exit(domain);
 err_free_devs:
 	kfree(domain->devs);
 err_free_id:
@@ -187,6 +193,7 @@ void cla_domains_free(void)
 	cla_lut_cpu = NULL;
 	cla_lut_pg = NULL;
 	xa_for_each(&cla_domains, fwid, domain) {
+		cla_domain_mdev_exit(domain);
 		xa_erase(&cla_domains, fwid);
 		kfree(domain->devs);
 		kfree(domain);
-- 
2.43.0

