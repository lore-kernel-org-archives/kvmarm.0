Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 550CA53E308
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074410; cv=none; b=P0oobGmmVWZM8CCJvxayPIqES6FeYtaxBZMjPgU8pTfgCvy4Bmu/ViDKUBlJw1+dqMSYfqepoVBbofnFBvkpAtEB2qcOgd+HTmLZcHTNFSk/Hi3bK80J6KjszI7F+d4hCG07YSPDVVNn/KibYmoftyCWwypD2s2BT5/zwQE89Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074410; c=relaxed/simple;
	bh=wB4MTPixrrjJCP1k8dsbnh9C7KUEDgE8i3GREwrcmnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hj9FrwEQZv6cGq/DpII+3ywI82Cai+PUQs5a0HxI7/KkA5n6wCh+O7m1jGraiPOrbroiUwW2eL9uqGRt+a4CzZpgLywh6klKu7zpAnFfktHNhk2d+dJTAqf9WwnJZ+hcc+bafjwGpyCOTBnXbGVEeGeUdQsaVdO8gW/LiOgPm9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g+H2F8RA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g+H2F8RA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F8F61576;
	Thu, 15 Oct 2026 07:26:32 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D9393F871;
	Thu, 15 Oct 2026 07:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074395; bh=wB4MTPixrrjJCP1k8dsbnh9C7KUEDgE8i3GREwrcmnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+H2F8RAL/0mCdSAIr3PWIg8+LTLhBpdtel4jpkuCGOwNCqHAmI34T0S55dajBE/W
	 DGp5IVLPrvQyhDlO6JbvFKqFm98L2OdGV7jaivK1TjfGtF2dISD7DOEhDpPfUytxRS
	 fHJzvbY7wUWFIQ3CPyGzt9mxEYG4iTbRJ3T7CU/8=
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
Subject: [RFC PATCH v2 09/15] misc/arm-cla: Add userspace interface
Date: Thu, 15 Oct 2026 15:25:43 +0100
Message-ID: <20261015142552.4128028-10-ryan.roberts@arm.com>
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

Expose CLA devices through a character device so userspace can enumerate
the available hardware and map accelerator register frames.

Provide ioctl interface to report device topology, CPU affinity, domain
membership, mmap offsets, architecture version and attached accelerator
masks, together with the IIDR, DEVARCH and REVIDR of each accelerator.

CLA registers can only be read from the CPU local to the device, while
enumeration may occur on any CPU. Validate the supported CLA
architecture version during device setup and cache the CLA and
accelerator identification registers for later ioctl queries.

Support shared read-write mmap of one or more CLA register pages. Create
a context for every domain covered by the mapping and resolve faults
only while that context owns the domain. Queue unassigned contexts with
the domain scheduler, drop mmap_lock while waiting for assignment and
retry the fault after the context is woken.

Co-developed-by: Jean-Philippe Brucker <jpb@kernel.org>
Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 MAINTAINERS                         |   1 +
 drivers/misc/arm-cla/Makefile       |   3 +-
 drivers/misc/arm-cla/arm-cla-regs.h |   2 +
 drivers/misc/arm-cla/arm-cla.h      |  14 +
 drivers/misc/arm-cla/cla-init.c     |  27 ++
 drivers/misc/arm-cla/cla-regs.c     |  10 +
 drivers/misc/arm-cla/cla-user.c     | 541 ++++++++++++++++++++++++++++
 include/uapi/linux/arm-cla.h        | 198 ++++++++++
 8 files changed, 795 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/arm-cla/cla-user.c
 create mode 100644 include/uapi/linux/arm-cla.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 98a25b3de9b4..f77d75e8a9a8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2216,6 +2216,7 @@ S:	Supported
 F:	Documentation/devicetree/bindings/misc/arm,cla.yaml
 F:	Documentation/misc-devices/arm-cla.rst
 F:	drivers/misc/arm-cla/
+F:	include/uapi/linux/arm-cla.h
 
 ARM ETHOS-U NPU DRIVER
 M:	Rob Herring (Arm) <robh@kernel.org>
diff --git a/drivers/misc/arm-cla/Makefile b/drivers/misc/arm-cla/Makefile
index a92c3594e5c9..f848c608e8f1 100644
--- a/drivers/misc/arm-cla/Makefile
+++ b/drivers/misc/arm-cla/Makefile
@@ -7,6 +7,7 @@ arm-cla-y := \
 	cla-ops.o \
 	cla-regs.o \
 	cla-sched.o \
-	cla-topology.o
+	cla-topology.o \
+	cla-user.o
 
 obj-$(CONFIG_ARM_CLA) += arm-cla.o
diff --git a/drivers/misc/arm-cla/arm-cla-regs.h b/drivers/misc/arm-cla/arm-cla-regs.h
index d20a88780032..167e9ab64051 100644
--- a/drivers/misc/arm-cla/arm-cla-regs.h
+++ b/drivers/misc/arm-cla/arm-cla-regs.h
@@ -64,6 +64,8 @@
 					 CLA_STATUS_EXCEPT | \
 					 CLA_STATUS_SRMODE)
 
+#define CLA_AIDR_PREP(maj, min)		((ULL(maj) << 8) | ULL(min))
+
 /* Standard accelerator registers */
 #define CLA_REG_IIDR			0x0000
 #define CLA_REG_DEVARCH			0x0001
diff --git a/drivers/misc/arm-cla/arm-cla.h b/drivers/misc/arm-cla/arm-cla.h
index a797330956d9..e047094dd49c 100644
--- a/drivers/misc/arm-cla/arm-cla.h
+++ b/drivers/misc/arm-cla/arm-cla.h
@@ -42,6 +42,12 @@ struct cla_call_on_cpu {
 	struct kthread_work switch_ctx;
 };
 
+struct cla_accel_desc {
+	u64 iidr;
+	u64 devarch;
+	u64 revidr;
+};
+
 /**
  * struct cla_dev - CLA device
  *
@@ -54,6 +60,8 @@ struct cla_call_on_cpu {
  * @pg_offset:		Mmap offset of this device.
  * @iassizes:		Combined regstate of all accels in bytes.
  * @domain:		The domain this CLA belongs to.
+ * @aidr:		CLA Architecture ID.
+ * @accel_descs:	Accelerator ID registers.
  *
  * Mutable, protected by CPU hotplug locking:
  * @discovered:		Discovered state is cached.
@@ -70,6 +78,8 @@ struct cla_dev {
 	unsigned long pg_offset;
 	unsigned long iassizes;
 	struct cla_domain *domain;
+	u64 aidr;
+	struct cla_accel_desc accel_descs[CLA_NUM_ACC];
 
 	bool discovered;
 	bool broken;
@@ -291,4 +301,8 @@ int cla_mtc_get_ctx(struct cla_ctx *ctx);
 void cla_mtc_put_ctx(struct cla_ctx *ctx);
 void cla_mtc_leak_ctx(struct cla_ctx *ctx);
 
+int cla_user_init(void);
+void cla_user_exit(void);
+u8 cla_user_accels(struct cla_dev *dev, struct file *file);
+
 #endif /* _ARM_CLA_H_ */
diff --git a/drivers/misc/arm-cla/cla-init.c b/drivers/misc/arm-cla/cla-init.c
index e1694f84e05d..1afe20aa877f 100644
--- a/drivers/misc/arm-cla/cla-init.c
+++ b/drivers/misc/arm-cla/cla-init.c
@@ -84,6 +84,7 @@ static int cla_reset_pmu(struct cla_dev *dev, unsigned int accid)
  */
 static int cla_dev_discover_accel(struct cla_dev *dev, unsigned int accid)
 {
+	struct cla_accel_desc *desc = &dev->accel_descs[accid];
 	unsigned long iassizes;
 	u64 iassize;
 	u64 acap;
@@ -102,6 +103,20 @@ static int cla_dev_discover_accel(struct cla_dev *dev, unsigned int accid)
 		return 1;
 	}
 
+	/*
+	 * Cache some standard accelerator registers that user space may query
+	 * via ioctl from a remote CPU.
+	 */
+	ret = cla_op_regread(dev, accid, CLA_REG_IIDR, 1, &desc->iidr);
+	if (ret)
+		return ret;
+	ret = cla_op_regread(dev, accid, CLA_REG_DEVARCH, 1, &desc->devarch);
+	if (ret)
+		return ret;
+	ret = cla_op_regread(dev, accid, CLA_REG_REVIDR, 1, &desc->revidr);
+	if (ret)
+		return ret;
+
 	ret = cla_op_regread(dev, accid, CLA_REG_IASSIZE, 1, &iassize);
 	if (ret)
 		return ret;
@@ -248,6 +263,12 @@ static int cla_dev_setup(unsigned int cpu)
 		return -EINVAL;
 
 	if (!dev->discovered) {
+		dev->aidr = cla_reg_read(dev, CLA_REG_CLAAIDR);
+
+		/* Check for supported CLA architecture version. */
+		if (dev->aidr != CLA_AIDR_PREP(2, 0))
+			return -EPROTONOSUPPORT;
+
 		/* Discard partial results from an earlier, failed discovery. */
 		dev->accelerators = 0;
 		dev->iassizes = 0;
@@ -498,6 +519,11 @@ static int __init cla_module_init(void)
 		cla_cpuhp_state = ret;
 	}
 
+	/* Must be last fallible step; see cla_user_init(). */
+	ret = cla_user_init();
+	if (ret)
+		goto err_hardware;
+
 	return 0;
 
 err_hardware:
@@ -512,6 +538,7 @@ static int __init cla_module_init(void)
 
 static void __exit cla_module_exit(void)
 {
+	cla_user_exit();
 	cla_domains_sched_exit();
 	cpuhp_remove_state(cla_cpuhp_state);
 	cla_domains_free();
diff --git a/drivers/misc/arm-cla/cla-regs.c b/drivers/misc/arm-cla/cla-regs.c
index d8ed74230e16..d48311d0ef92 100644
--- a/drivers/misc/arm-cla/cla-regs.c
+++ b/drivers/misc/arm-cla/cla-regs.c
@@ -162,6 +162,8 @@ static int cla_regs_install_pl0(struct cla_dev *dev, struct cla_ctx *ctx,
 {
 	int i;
 	int ret;
+	u64 pl0ctrl = 0;
+	u8 accelerators;
 	unsigned int accid;
 	size_t regstate_off = 0;
 	struct cla_regs_pl0 *regs = ctx->regs[ctx_id];
@@ -192,6 +194,14 @@ static int cla_regs_install_pl0(struct cla_dev *dev, struct cla_ctx *ctx,
 		cla_reg_write(dev, CLA_REG_DATA(i), regs->data[i]);
 	cla_reg_write(dev, CLA_REG_LRESP, regs->lresp);
 
+	/* Restrict which accelerators this context can access at PL0. */
+	accelerators = cla_user_accels(dev, ctx->key.file);
+	cla_for_each_accid(dev, accid) {
+		if (accelerators & BIT(accid))
+			pl0ctrl |= CLA_PLxCTRL_PREP(accid, CLA_PLxCTRL_AVAIL);
+	}
+	cla_reg_write(dev, CLA_REG_PL0CTRL, pl0ctrl);
+
 	return 0;
 }
 
diff --git a/drivers/misc/arm-cla/cla-user.c b/drivers/misc/arm-cla/cla-user.c
new file mode 100644
index 000000000000..41cd5e4a7d01
--- /dev/null
+++ b/drivers/misc/arm-cla/cla-user.c
@@ -0,0 +1,541 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Arm CLA driver - userspace interface
+ *
+ * Copyright 2026 Arm Limited.
+ */
+
+#include <linux/cdev.h>
+#include <linux/cpu.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#include "arm-cla.h"
+#include <uapi/linux/arm-cla.h>
+
+static struct class *cla_class;
+static dev_t cla_devt;
+static struct cdev cla_cdev;
+static bool cla_cdev_added;
+static unsigned int cla_nr_minors;
+static unsigned int cla_nr_classes;
+static struct cla_accel_class **cla_accel_classes;
+
+struct cla_accel_class {
+	struct cla_accel_desc desc;
+	struct device dev;
+};
+
+static bool cla_accel_class_same(const struct cla_accel_desc *a,
+				 const struct cla_accel_desc *b)
+{
+	u64 mask = CLA_IIDR_IMPLEMENTER | CLA_IIDR_PRODUCTID;
+
+	return (a->iidr & mask) == (b->iidr & mask);
+}
+
+u8 cla_user_accels(struct cla_dev *dev, struct file *file)
+{
+	struct cla_accel_class *aclass = file->private_data;
+	struct cla_accel_desc *desc = &aclass->desc;
+	unsigned int accid;
+	u8 mask = 0;
+
+	cla_for_each_accid(dev, accid) {
+		if (cla_accel_class_same(&dev->accel_descs[accid], desc))
+			mask |= BIT(accid);
+	}
+
+	return mask;
+}
+
+#define dev_nospec(idx) array_index_nospec(idx, cla_nr_devs)
+#define accel_nospec(idx) array_index_nospec(idx, CLA_NUM_ACC)
+
+#define cla_for_each_mapped_domain(_vma, _domain)			\
+	for (unsigned long __pg = (_vma)->vm_pgoff;			\
+	     __pg < (_vma)->vm_pgoff + vma_pages(_vma) &&		\
+	     ((_domain) = cla_lut_pg[dev_nospec(__pg)]->domain);	\
+	     __pg = (_domain)->pg_offset + (_domain)->nr_devs)
+
+static long cla_ioctl_validate_param(struct file *file,
+				     struct arm_cla_param *param)
+{
+	u8 accelerators;
+	int accel_id;
+	int dev_id;
+
+	switch (param->param) {
+	case ARM_CLA_PARAM_DEV_NR:
+		if (param->index != 0)
+			return -EINVAL;
+		break;
+	case ARM_CLA_PARAM_DEV_CPU_ID:
+	case ARM_CLA_PARAM_DEV_DOMAIN_ID:
+	case ARM_CLA_PARAM_DEV_PGOFF:
+	case ARM_CLA_PARAM_DEV_AIDR:
+	case ARM_CLA_PARAM_DEV_ACCELS:
+		if (param->index >= cla_nr_devs)
+			return -EINVAL;
+		break;
+	case ARM_CLA_PARAM_ACCEL_IIDR:
+	case ARM_CLA_PARAM_ACCEL_DEVARCH:
+	case ARM_CLA_PARAM_ACCEL_REVIDR:
+		dev_id = ARM_CLA_PARAM_INDEX_DEV(param->index);
+		accel_id = ARM_CLA_PARAM_INDEX_ACCEL(param->index);
+		if (dev_id >= cla_nr_devs || accel_id >= CLA_NUM_ACC)
+			return -EINVAL;
+		dev_id = dev_nospec(dev_id);
+		accelerators = cla_user_accels(cla_lut_pg[dev_id], file);
+		if ((accelerators & BIT(accel_id)) == 0)
+			return -ENODEV;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static long cla_ioctl_get_param(struct file *file, unsigned long arg)
+{
+	struct arm_cla_param __user *uparam = (void __user *)arg;
+	struct arm_cla_param param;
+	int accel_id;
+	int dev_id;
+	int ret;
+
+	if (copy_from_user(&param, uparam, sizeof(param)))
+		return -EFAULT;
+
+	ret = cla_ioctl_validate_param(file, &param);
+	if (ret)
+		return ret;
+
+	dev_id = dev_nospec(ARM_CLA_PARAM_INDEX_DEV(param.index));
+	accel_id = accel_nospec(ARM_CLA_PARAM_INDEX_ACCEL(param.index));
+
+	switch (param.param) {
+	case ARM_CLA_PARAM_DEV_NR:
+		param.value = cla_nr_devs;
+		break;
+	case ARM_CLA_PARAM_DEV_CPU_ID:
+		param.value = cla_lut_pg[dev_id]->cpu;
+		break;
+	case ARM_CLA_PARAM_DEV_DOMAIN_ID:
+		param.value = cla_lut_pg[dev_id]->domain->id;
+		break;
+	case ARM_CLA_PARAM_DEV_PGOFF:
+		param.value = cla_lut_pg[dev_id]->pg_offset;
+		break;
+	case ARM_CLA_PARAM_DEV_AIDR:
+		param.value = cla_lut_pg[dev_id]->aidr;
+		break;
+	case ARM_CLA_PARAM_DEV_ACCELS:
+		param.value = cla_user_accels(cla_lut_pg[dev_id], file);
+		break;
+	case ARM_CLA_PARAM_ACCEL_IIDR:
+		param.value = cla_lut_pg[dev_id]->accel_descs[accel_id].iidr;
+		break;
+	case ARM_CLA_PARAM_ACCEL_DEVARCH:
+		param.value = cla_lut_pg[dev_id]->accel_descs[accel_id].devarch;
+		break;
+	case ARM_CLA_PARAM_ACCEL_REVIDR:
+		param.value = cla_lut_pg[dev_id]->accel_descs[accel_id].revidr;
+		break;
+	}
+
+	if (copy_to_user(uparam, &param, sizeof(param)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static void cla_vma_open(struct vm_area_struct *vma)
+{
+	/*
+	 * A vma previously created with cla_file_mmap() has been duplicated
+	 * within the same mm (most likely due to mremap). While this could also
+	 * be called for duplication into a new mm (via fork), we set
+	 * VM_DONTCOPY on the original mmap, so this will never happen. So the
+	 * contexts covered by this new vma already exist.
+	 */
+	struct cla_ctx_key key = CLA_CTX_KEY_PL0(vma->vm_mm, vma->vm_file);
+	struct cla_domain *domain;
+
+	cla_for_each_mapped_domain(vma, domain)
+		cla_ctx_create(domain, &key);
+}
+
+static void cla_vma_close(struct vm_area_struct *vma)
+{
+	struct cla_ctx_key key = CLA_CTX_KEY_PL0(vma->vm_mm, vma->vm_file);
+	struct cla_domain *domain;
+
+	/* On munmap() or exit_mmap(), kill the context. */
+	cla_for_each_mapped_domain(vma, domain)
+		cla_ctx_destroy(domain, &key);
+}
+
+static vm_fault_t cla_vma_fault(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct cla_ctx_key key = CLA_CTX_KEY_PL0(vma->vm_mm, vma->vm_file);
+	struct cla_domain *domain;
+	struct cla_dev *dev;
+	struct cla_ctx *ctx;
+	unsigned long pg;
+
+	/*
+	 * Reassignment needs mmap_lock, so we cannot wait while holding it.
+	 * The private futex fault-in path can reach here without allowing
+	 * mmap_lock to be dropped. Reject faults that do not allow retry.
+	 */
+	if (!(vmf->flags & FAULT_FLAG_ALLOW_RETRY))
+		return VM_FAULT_SIGBUS;
+
+	pg = vma->vm_pgoff + ((vmf->address - vma->vm_start) >> PAGE_SHIFT);
+	dev = cla_lut_pg[pg];
+	domain = dev->domain;
+
+	mutex_lock(&domain->lock);
+	ctx = cla_domain_lookup_ctx(domain, &key);
+	if (WARN_ON(!ctx) || cla_ctx_is_dying(ctx) || domain->broken) {
+		mutex_unlock(&domain->lock);
+		return domain->broken ? VM_FAULT_SIGBUS : VM_FAULT_SIGSEGV;
+	}
+
+	/* If our ctx is the assigned one, map the device into memory. */
+	if (domain->assigned_ctx == ctx) {
+		vm_fault_t ret;
+
+		ret = vmf_insert_pfn(vma, vmf->address, dev->pfn);
+		mutex_unlock(&domain->lock);
+		return ret;
+	}
+
+	/* Enqueue if not already, starting current assignee's time slice. */
+	if (list_empty(&ctx->queue_node)) {
+		bool was_empty = list_empty(&domain->queued_ctxs);
+
+		list_add_tail(&ctx->queue_node, &domain->queued_ctxs);
+		if (was_empty)
+			cla_domain_schedule_reassignment(domain);
+	}
+
+	mutex_unlock(&domain->lock);
+
+	/* If waiting is not permitted, return indicating we need to retry. */
+	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
+		return VM_FAULT_RETRY;
+
+	/*
+	 * Drop the fault lock prior to sleeping and return VM_FAULT_RETRY when
+	 * we wake up to rerun the fault. We must get the ctx while sleeping to
+	 * prevent it from being freed while we are asleep on the contained wait
+	 * queue.
+	 */
+	cla_ctx_get(ctx);
+	release_fault_lock(vmf);
+	wait_event_interruptible(ctx->waitq,
+				 READ_ONCE(domain->assigned_ctx) == ctx ||
+				 cla_ctx_is_dying(ctx) ||
+				 READ_ONCE(domain->broken));
+	cla_ctx_put(ctx);
+	return VM_FAULT_RETRY;
+}
+
+static int cla_vma_may_split(struct vm_area_struct *vma, unsigned long addr)
+{
+	/*
+	 * Forbid splitting cla mappings to prevent refcount leaks.
+	 * cla_file_mmap()/cla_vma_open() track a context per domain mapped by
+	 * the vma. If there were fewer domains mapped by the vma at
+	 * cla_vma_close() then contexts would get leaked.
+	 */
+	return -EINVAL;
+}
+
+static const struct vm_operations_struct cla_vma_ops = {
+	.open = cla_vma_open,
+	.close = cla_vma_close,
+	.fault = cla_vma_fault,
+	.may_split = cla_vma_may_split,
+};
+
+static int cla_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	unsigned long nr_pages = vma_pages(vma);
+	struct cla_ctx_key key = CLA_CTX_KEY_PL0(vma->vm_mm, vma->vm_file);
+	struct cla_domain *rollback;
+	struct cla_domain *domain;
+	struct cla_ctx *ctx;
+
+	/* Ensure the requested mapping is within range. */
+	if (!nr_pages)
+		return -EINVAL;
+	if (vma->vm_pgoff >= cla_nr_devs)
+		return -EINVAL;
+	if (nr_pages > cla_nr_devs - vma->vm_pgoff)
+		return -EINVAL;
+
+	/* Only allow shared RW mappings. Nothing else makes sense for CLA. */
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+	if (!(vma->vm_flags & VM_READ))
+		return -EINVAL;
+	if (!(vma->vm_flags & VM_WRITE))
+		return -EINVAL;
+	if (vma->vm_flags & VM_EXEC)
+		return -EINVAL;
+
+	/*
+	 * Iterate over each domain covered by the vma and get-or-alloc its
+	 * context. If any fails, we need to rollback with a put.
+	 */
+	cla_for_each_mapped_domain(vma, domain) {
+		ctx = cla_ctx_create(domain, &key);
+		if (IS_ERR(ctx)) {
+			cla_for_each_mapped_domain(vma, rollback) {
+				if (rollback == domain)
+					return PTR_ERR(ctx);
+				cla_ctx_destroy(rollback, &key);
+			}
+		}
+	}
+
+	vm_flags_mod(vma, VM_DONTCOPY | VM_DONTDUMP | VM_DONTEXPAND |
+			  VM_IO | VM_PFNMAP, VM_MAYEXEC);
+	vma->vm_page_prot = pgprot_device(vma->vm_page_prot);
+	vma->vm_ops = &cla_vma_ops;
+
+	return 0;
+}
+
+static long cla_file_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
+{
+	switch (cmd) {
+	case ARM_CLA_IOCTL_GET_PARAM:
+		return cla_ioctl_get_param(file, arg);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int cla_file_open(struct inode *inode, struct file *file)
+{
+	unsigned int index = iminor(inode) - MINOR(cla_devt);
+
+	if (index >= cla_nr_classes)
+		return -ENODEV;
+
+	file->private_data = cla_accel_classes[index];
+
+	return 0;
+}
+
+static const struct file_operations cla_fops = {
+	.owner = THIS_MODULE,
+	.open = cla_file_open,
+	.mmap = cla_file_mmap,
+	.unlocked_ioctl = cla_file_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
+};
+
+static char *cla_devnode(const struct device *dev, umode_t *mode)
+{
+	if (mode)
+		*mode = 0666;
+	return kasprintf(GFP_KERNEL, "cla/%s", dev_name(dev));
+}
+
+static void cla_accel_class_release(struct device *dev)
+{
+	kfree(container_of(dev, struct cla_accel_class, dev));
+}
+
+static bool __init cla_accel_class_seen(unsigned int dev_id, unsigned int accid)
+{
+	const struct cla_accel_desc *desc = &cla_lut_pg[dev_id]->accel_descs[accid];
+	unsigned int i, j;
+
+	for (i = 0; i <= dev_id; i++) {
+		struct cla_dev *dev = cla_lut_pg[i];
+
+		cla_for_each_accid(dev, j) {
+			/* Only compare accelerator slots preceding this one. */
+			if (i == dev_id && j == accid)
+				return false;
+			if (cla_accel_class_same(desc, &dev->accel_descs[j]))
+				return true;
+		}
+	}
+
+	return false;
+}
+
+static int __init cla_accel_class_add(const struct cla_accel_desc *desc)
+{
+	struct cla_accel_class *aclass;
+	unsigned int i;
+	int ret;
+
+	/* Check if an appropriate accel class was already created. */
+	for (i = 0; i < cla_nr_classes; i++) {
+		if (cla_accel_class_same(desc, &cla_accel_classes[i]->desc))
+			return 0;
+	}
+
+	aclass = kzalloc_obj(*aclass);
+	if (!aclass)
+		return -ENOMEM;
+
+	aclass->desc = *desc;
+	device_initialize(&aclass->dev);
+	aclass->dev.class = cla_class;
+	aclass->dev.devt = cla_devt + cla_nr_classes;
+	aclass->dev.release = cla_accel_class_release;
+
+	ret = dev_set_name(&aclass->dev, "%03lx:%03lx",
+			   FIELD_GET(CLA_IIDR_IMPLEMENTER, desc->iidr),
+			   FIELD_GET(CLA_IIDR_PRODUCTID, desc->iidr));
+	if (ret)
+		goto err_put;
+
+	/* The node cannot be opened until cla_user_init() adds the cdev. */
+	ret = device_add(&aclass->dev);
+	if (ret)
+		goto err_put;
+
+	cla_accel_classes[cla_nr_classes++] = aclass;
+	return 0;
+
+err_put:
+	put_device(&aclass->dev);
+	return ret;
+}
+
+/**
+ * cla_user_init - Initialize and publish the CLA userspace interface
+ *
+ * Create a device for each unique accelerator class, then publish all class
+ * minors through a single cdev. Device discovery must have completed before
+ * calling this function.
+ *
+ * This must be the last fallible step of module initialization: cdev_add()
+ * cannot fail after making the devices openable. On failure, all resources
+ * allocated here are released without allowing any opens.
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+int __init cla_user_init(void)
+{
+	unsigned int dev_id, accid;
+	int ret;
+
+	if (!cla_nr_devs)
+		return -EINVAL;
+
+	/* Count unique classes before allocating the minor range and lookup. */
+	for (dev_id = 0; dev_id < cla_nr_devs; dev_id++) {
+		struct cla_dev *dev = cla_lut_pg[dev_id];
+
+		cla_for_each_accid(dev, accid) {
+			if (cla_accel_class_seen(dev_id, accid))
+				continue;
+			if (++cla_nr_minors > MINORMASK + 1)
+				return -EINVAL;
+		}
+	}
+
+	if (!cla_nr_minors)
+		return 0;
+
+	cla_class = class_create("arm-cla");
+	if (IS_ERR(cla_class))
+		return PTR_ERR(cla_class);
+	cla_class->devnode = cla_devnode;
+
+	ret = alloc_chrdev_region(&cla_devt, 0, cla_nr_minors, KBUILD_MODNAME);
+	if (ret)
+		goto err_class_destroy;
+
+	cla_accel_classes = kvzalloc_objs(*cla_accel_classes, cla_nr_minors);
+	if (!cla_accel_classes) {
+		ret = -ENOMEM;
+		goto err_user_exit;
+	}
+
+	/* Prepare every unique accelerator class before publishing the cdev. */
+	for (dev_id = 0; dev_id < cla_nr_devs; dev_id++) {
+		struct cla_dev *dev = cla_lut_pg[dev_id];
+
+		cla_for_each_accid(dev, accid) {
+			ret = cla_accel_class_add(&dev->accel_descs[accid]);
+			if (ret)
+				goto err_user_exit;
+		}
+	}
+
+	/*
+	 * Once cdev_add() succeeds, user space can open the device file. Module
+	 * initialization must not fail after this point because the cdev
+	 * depends on the module.
+	 */
+	cdev_init(&cla_cdev, &cla_fops);
+	cla_cdev.owner = THIS_MODULE;
+	ret = cdev_add(&cla_cdev, cla_devt, cla_nr_classes);
+	if (ret) {
+		kobject_put(&cla_cdev.kobj);
+		goto err_user_exit;
+	}
+	cla_cdev_added = true;
+
+	return 0;
+
+err_user_exit:
+	cla_user_exit();
+	return ret;
+err_class_destroy:
+	class_destroy(cla_class);
+	return ret;
+}
+
+/**
+ * cla_user_exit - Remove the CLA userspace interface
+ *
+ * Remove the cdev, unregister the accelerator class devices, and release the
+ * minor lookup, device numbers and device class.
+ *
+ * Called during module exit or by cla_user_init() to unwind a failure before
+ * cdev publication. No open files may remain: the module references held by
+ * open files ensure this during normal module removal.
+ */
+void cla_user_exit(void)
+{
+	unsigned int i;
+
+	if (!cla_nr_minors)
+		return;
+
+	if (cla_cdev_added) {
+		cdev_del(&cla_cdev);
+		cla_cdev_added = false;
+	}
+
+	for (i = 0; i < cla_nr_classes; i++)
+		device_unregister(&cla_accel_classes[i]->dev);
+
+	kvfree(cla_accel_classes);
+	cla_accel_classes = NULL;
+	cla_nr_classes = 0;
+	unregister_chrdev_region(cla_devt, cla_nr_minors);
+	cla_nr_minors = 0;
+	class_destroy(cla_class);
+}
diff --git a/include/uapi/linux/arm-cla.h b/include/uapi/linux/arm-cla.h
new file mode 100644
index 000000000000..f65f1b760c34
--- /dev/null
+++ b/include/uapi/linux/arm-cla.h
@@ -0,0 +1,198 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * UAPI definitions for the CLA character device.
+ */
+
+#ifndef _UAPI_LINUX_CLA_H
+#define _UAPI_LINUX_CLA_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+#define ARM_CLA_IOC_MAGIC	'C'
+
+/**
+ * define ARM_CLA_IOCTL_GET_PARAM - Get the value of a parameter.
+ *
+ * ioctl command whose argument is a pointer to &struct arm_cla_param.
+ * &arm_cla_param->param and &arm_cla_param->index are input parameters.
+ * &arm_cla_param->value is an output parameter.
+ *
+ * Return:
+ * * %0 - OK
+ * * %-EINVAL - Unrecognised param or param does not support GET
+ * * Return code as defined for param
+ */
+#define ARM_CLA_IOCTL_GET_PARAM	\
+	_IOWR(ARM_CLA_IOC_MAGIC, 0x00, struct arm_cla_param)
+
+/**
+ * define ARM_CLA_PARAM_DEV_NR - Number of attached CLA devices (RO).
+ *
+ * &arm_cla_param->index must be 0.
+ *
+ * Return:
+ * * %0 - OK
+ * * %-EINVAL - index not 0
+ */
+#define ARM_CLA_PARAM_DEV_NR		1
+
+/**
+ * define ARM_CLA_PARAM_DEV_CPU_ID - CPU to which the CLA is attached (RO).
+ *
+ * &arm_cla_param->index is the dev_id in range [0, DEV_NR).
+ *
+ * Return:
+ * * %0 - OK
+ * * %-EINVAL - dev_id (index) not in range
+ */
+#define ARM_CLA_PARAM_DEV_CPU_ID	2
+
+/**
+ * define ARM_CLA_PARAM_DEV_DOMAIN_ID - Domain to which the CLA belongs (RO).
+ *
+ * &arm_cla_param->index is the dev_id in range [0, DEV_NR).
+ *
+ * A CLA domain contains a set of CLA devices whose accelerators can communicate
+ * with each other. All CLA devices within a CLA domain are atomically assigned
+ * to a single context at a time.
+ *
+ * Return:
+ * * %0 - OK
+ * * %-EINVAL - dev_id (index) not in range
+ */
+#define ARM_CLA_PARAM_DEV_DOMAIN_ID	3
+
+/**
+ * define ARM_CLA_PARAM_DEV_PGOFF - CLA's ``mmap()`` page offset (RO).
+ *
+ * &arm_cla_param->index is the dev_id in range [0, DEV_NR).
+ *
+ * The page offset at which the selected CLA device's register page is exposed
+ * through ``mmap()``.
+ *
+ * Return:
+ * * %0 - OK
+ * * %-EINVAL - dev_id (index) not in range
+ */
+#define ARM_CLA_PARAM_DEV_PGOFF		4
+
+/**
+ * define ARM_CLA_PARAM_DEV_AIDR - CLA Architecture Identification Register
+ * (RO).
+ *
+ * &arm_cla_param->index is the dev_id in range [0, DEV_NR).
+ *
+ * The CLA Architecture Identification Register is used to obtain version
+ * information of the CLA Programming model.
+ *
+ * Return:
+ * * %0 - OK
+ * * %-EINVAL - dev_id (index) not in range
+ */
+#define ARM_CLA_PARAM_DEV_AIDR		5
+
+/**
+ * define ARM_CLA_PARAM_DEV_ACCELS - CLA accelerators in opened class (RO).
+ *
+ * &arm_cla_param->index is the dev_id in range [0, DEV_NR).
+ *
+ * A bitmask of accelerator slots on the selected CLA device that belong to the
+ * class of the opened character device. Class membership is determined by
+ * matching IIDR.IMPLEMENTER and IIDR.PRODUCTID.
+ *
+ * Each bit corresponds to an accel_id in the range [0, 8). The mask is zero if
+ * the selected CLA has no accelerators belonging to the opened class.
+ *
+ * Return:
+ * * %0 - OK
+ * * %-EINVAL - dev_id (index) not in range
+ */
+#define ARM_CLA_PARAM_DEV_ACCELS	6
+
+/**
+ * define ARM_CLA_PARAM_ACCEL_IIDR - Accelerator IIDR register (RO).
+ *
+ * &arm_cla_param->index is ARM_CLA_PARAM_ACCEL_INDEX(accel_id, dev_id).
+ *
+ * Return:
+ * * %0 - OK
+ * * %-EINVAL - dev_id not in range
+ * * %-EINVAL - accel_id not in range
+ * * %-ENODEV - accel_id not attached or does not belong to opened class
+ */
+#define ARM_CLA_PARAM_ACCEL_IIDR	7
+
+/**
+ * define ARM_CLA_PARAM_ACCEL_DEVARCH - Accelerator DEVARCH register (RO).
+ *
+ * &arm_cla_param->index is ARM_CLA_PARAM_ACCEL_INDEX(accel_id, dev_id).
+ *
+ * Return:
+ * * %0 - OK
+ * * %-EINVAL - dev_id not in range
+ * * %-EINVAL - accel_id not in range
+ * * %-ENODEV - accel_id not attached or does not belong to opened class
+ */
+#define ARM_CLA_PARAM_ACCEL_DEVARCH	8
+
+/**
+ * define ARM_CLA_PARAM_ACCEL_REVIDR - Accelerator REVIDR register (RO).
+ *
+ * &arm_cla_param->index is ARM_CLA_PARAM_ACCEL_INDEX(accel_id, dev_id).
+ *
+ * Return:
+ * * %0 - OK
+ * * %-EINVAL - dev_id not in range
+ * * %-EINVAL - accel_id not in range
+ * * %-ENODEV - accel_id not attached or does not belong to opened class
+ */
+#define ARM_CLA_PARAM_ACCEL_REVIDR	9
+
+/**
+ * ARM_CLA_PARAM_ACCEL_INDEX() - encode index for specific accelerator.
+ * @accel_id:	accelerator id in the range [0, 8).
+ * @dev_id:	CLA device id in the range [0, DEV_NR).
+ *
+ * Return: encoded index for use in &arm_cla_param->index.
+ */
+#define ARM_CLA_PARAM_ACCEL_INDEX(accel_id, dev_id) \
+	(((accel_id) << 24) | (dev_id))
+
+/**
+ * ARM_CLA_PARAM_INDEX_ACCEL() - extract accel_id from index.
+ * @index:	Encoded index as returned by ARM_CLA_PARAM_ACCEL_INDEX()
+ *
+ * Return: extracted accel_id.
+ */
+#define ARM_CLA_PARAM_INDEX_ACCEL(index) (((index) >> 24) & 0xff)
+
+/**
+ * ARM_CLA_PARAM_INDEX_DEV() - extract dev_id from index.
+ * @index:	Encoded index as returned by ARM_CLA_PARAM_ACCEL_INDEX()
+ *
+ * Return: extracted dev_id.
+ */
+#define ARM_CLA_PARAM_INDEX_DEV(index) ((index) & 0xffffff)
+
+/**
+ * struct arm_cla_param - Get/Set CLA parameters.
+ */
+struct arm_cla_param {
+	/**
+	 * @param: Param selector - One of the ARM_CLA_PARAM_* values.
+	 */
+	__u64 param;
+
+	/**
+	 * @index: Index for params that have multiple instances.
+	 */
+	__u64 index;
+
+	/**
+	 * @value: Param value.
+	 */
+	__u64 value;
+};
+
+#endif /* _UAPI_LINUX_CLA_H */
-- 
2.43.0

