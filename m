Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3975F5335B6
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074385; cv=none; b=hMWjZSSNwvFV4wrzYN4JBhqc2LrbrCusUgu777pqBN0ejTfdeoSTDmTcQsPzzpOz8AKxKBjSqF3kMfu+kde51+X2xYPVXjas+i+Oiis00dIZSgvAovj3os9ILhY7DU05obU+fZF6SMwFKtj1pLRA0QVzqqCsO6qsQcZs1r5QSkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074385; c=relaxed/simple;
	bh=92g4f16JkFzfa2eJ04OERqd5V71ETIp+E0Q4Liww/Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbB1UtQiMPUf6imzy11RcU7yoe19CQiCirU89czfVf0SjrOXg1k8Iu08Io0BVsdvrUkeNCOWCz9R1tEV0rEkMIRbVidvW4eg9T42SaDhoS3Sb73uqHCHFYfYlAtqdb6N3lWRX1SpJNkoTxBtjPUX7UA/5m+fd79bqYhIiSdb5KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aGfkQgtI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aGfkQgtI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCBD01516;
	Thu, 15 Oct 2026 07:26:14 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D28EE3F871;
	Thu, 15 Oct 2026 07:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074378; bh=92g4f16JkFzfa2eJ04OERqd5V71ETIp+E0Q4Liww/Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGfkQgtItwhplFdngNnFUSeRIjclF8TsuG5CJFFS6DBauQHwmKAGxv7D2TNyk2rRE
	 HHS0Qj5G/ETDBBVZc0dLDGIyxEBFJOVCv2qNbRCiDwOHGKeYHooYGvowUaMMePaKBp
	 hHmREOSZSxfKv11x7ANwu6wtkR0NFaX423eAFcvo=
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
Subject: [RFC PATCH v2 04/15] misc/arm-cla: Probe firmware-described devices
Date: Thu, 15 Oct 2026 15:25:38 +0100
Message-ID: <20261015142552.4128028-5-ryan.roberts@arm.com>
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

Discover CLA devices from firmware and instantiate the driver with
platform_driver_probe(), since the set of devices is fixed at boot. Map
the MMIO frame, select the kernel-accessible privilege-level frame and
associate each CLA with the CPU named by firmware.

Add the topology code used to group CLAs into domains. Domains represent
the smallest unit that can be assigned independently, because CLAs in
the same domain cannot be isolated from each other. Build lookup tables
indexed by CPU and by mmap page offset for later fast access.

Register CPU hotplug callbacks so that hardware setup and teardown can
run on the CPU local to each CLA, which is the only CPU allowed to
access that CLA's registers.

Co-developed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
---
 drivers/misc/arm-cla/Makefile       |   3 +-
 drivers/misc/arm-cla/arm-cla.h      |  46 ++++++
 drivers/misc/arm-cla/cla-init.c     | 222 ++++++++++++++++++++++++++++
 drivers/misc/arm-cla/cla-topology.c | 172 +++++++++++++++++++++
 4 files changed, 442 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/arm-cla/cla-topology.c

diff --git a/drivers/misc/arm-cla/Makefile b/drivers/misc/arm-cla/Makefile
index 3fa8567c8b3e..84ed1a054a21 100644
--- a/drivers/misc/arm-cla/Makefile
+++ b/drivers/misc/arm-cla/Makefile
@@ -2,6 +2,7 @@
 
 arm-cla-y := \
 	cla-init.o \
-	cla-ops.o
+	cla-ops.o \
+	cla-topology.o
 
 obj-$(CONFIG_ARM_CLA) += arm-cla.o
diff --git a/drivers/misc/arm-cla/arm-cla.h b/drivers/misc/arm-cla/arm-cla.h
index 4884e4804ab3..61176c4fce0f 100644
--- a/drivers/misc/arm-cla/arm-cla.h
+++ b/drivers/misc/arm-cla/arm-cla.h
@@ -17,6 +17,8 @@
 #define CLA_NUM_DATA_REGS	8
 #define CLA_SRSTATE_LEN		8
 
+struct cla_domain;
+
 /**
  * struct cla_dev - CLA device
  *
@@ -24,13 +26,41 @@
  * @cpu:		The CPU this CLA is attached to.
  * @regs:		Registers accessed by the kernel.
  * @dev:		The platform device.
+ * @pfn:		Page of registers assigned to user.
+ * @pg_offset:		Mmap offset of this device.
+ * @domain:		The domain this CLA belongs to.
  */
 struct cla_dev {
 	unsigned int cpu;
 	void __iomem *regs;
 	struct device *dev;
+	unsigned long pfn;
+	unsigned long pg_offset;
+	struct cla_domain *domain;
+};
+
+/**
+ * struct cla_domain - Collection of cla_dev
+ *
+ * Immutable state:
+ * @id:			Consecutive userspace domain identifier.
+ * @pg_offset:		Mmap offset of the first device.
+ * @nr_devs:		Number of devices in the domain.
+ * @devs:		Devices.
+ */
+struct cla_domain {
+	unsigned int id;
+	unsigned long pg_offset;
+	unsigned int nr_devs;
+	struct cla_dev **devs;
 };
 
+extern struct xarray cla_domains;
+extern unsigned int cla_nr_domains;
+extern struct cla_dev **cla_lut_cpu;
+extern struct cla_dev **cla_lut_pg;
+extern unsigned int cla_nr_devs;
+
 #define cla_dbg(_dev, fmt, ...) \
 	dev_dbg((_dev)->dev, "[%u] " fmt, (_dev)->cpu, ##__VA_ARGS__)
 #define cla_info(_dev, fmt, ...) \
@@ -38,6 +68,13 @@ struct cla_dev {
 #define cla_err(_dev, fmt, ...) \
 	dev_err((_dev)->dev, "[%u] " fmt, (_dev)->cpu, ##__VA_ARGS__)
 
+#define CLA_REG_SIZE	SZ_64K
+#define CLA_FRAME_SIZE	(4 * CLA_REG_SIZE)
+
+/* Return the registers corresponding to this privilege level */
+#define cla_get_regs(base, pl) \
+	((typeof(base))((uintptr_t)(base) + (pl) * CLA_REG_SIZE))
+
 static inline u64 cla_reg_read(struct cla_dev *dev, off_t reg)
 {
 	/* MMIO reads are all relaxed, since the driver doesn't use DMA. */
@@ -50,6 +87,15 @@ static inline void cla_reg_write(struct cla_dev *dev, off_t reg, u64 val)
 	return writeq_relaxed(val, dev->regs + reg);
 }
 
+/*
+ * If we're at EL2, use PL2. If we're a guest or nVHE host, use PL1.
+ */
+#define cla_kernel_pl (is_kernel_in_hyp_mode() ? 2 : 1)
+
+struct cla_domain *cla_dev_domain_get(struct cla_dev *dev);
+int cla_domains_finalise(void);
+void cla_domains_free(void);
+
 int cla_op_wait_lresp(struct cla_dev *dev, u64 *lresp);
 int cla_op_reset(struct cla_dev *dev, unsigned int accid);
 int cla_op_regread(struct cla_dev *dev, unsigned int accid, unsigned int regidx,
diff --git a/drivers/misc/arm-cla/cla-init.c b/drivers/misc/arm-cla/cla-init.c
index 3d1f47592842..6818fb8c38ed 100644
--- a/drivers/misc/arm-cla/cla-init.c
+++ b/drivers/misc/arm-cla/cla-init.c
@@ -5,7 +5,229 @@
  * Copyright 2026 Arm Limited.
  */
 
+#include <linux/cpuhotplug.h>
+#include <linux/cpuhplock.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/smp.h>
+
+#include <asm/virt.h>
+
+#include "arm-cla.h"
+
+static int cla_cpuhp_state = -1;
+
+static int cla_dev_setup(unsigned int cpu)
+{
+	struct cla_dev *dev;
+
+	dev = cla_lut_cpu[cpu];
+	if (!dev)
+		return 0;
+
+	if (WARN_ON(smp_processor_id() != cpu || dev->cpu != cpu))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int cla_dev_teardown(unsigned int cpu)
+{
+	struct cla_dev *dev;
+
+	/*
+	 * Careful what we return here, the teardown path isn't really allowed
+	 * to fail (BUG_ON in kernel/cpu.c)
+	 */
+	dev = cla_lut_cpu[cpu];
+	if (!dev)
+		return 0;
+
+	return 0;
+}
+
+static int cla_of_to_cpu(struct device_node *of_node)
+{
+	int cpu;
+	int ret;
+	u32 cpu_phandle;
+	struct device_node *cpu_node;
+
+	if (!of_node)
+		return -ENODEV;
+
+	ret = of_property_read_u32(of_node, "cpu", &cpu_phandle);
+	if (WARN_ON(ret))
+		return -EINVAL;
+
+	cpu_node = of_find_node_by_phandle(cpu_phandle);
+	if (WARN_ON(!cpu_node))
+		return -EINVAL;
+
+	cpu = of_cpu_node_to_id(cpu_node);
+	of_node_put(cpu_node);
+
+	return cpu;
+}
+
+static struct cla_dev *cla_dev_alloc(struct device *parent, int cpu,
+				     void __iomem *regs, phys_addr_t base)
+{
+	struct cla_dev *dev;
+
+	dev = devm_kzalloc(parent, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return ERR_PTR(-ENOMEM);
+
+	dev->pfn = __phys_to_pfn(base);
+	dev->regs = cla_get_regs(regs, cla_kernel_pl);
+	dev->cpu = cpu;
+	dev->dev = parent;
+
+	/* Attempt to find device domain, or allocate a new one */
+	dev->domain = cla_dev_domain_get(dev);
+	if (IS_ERR(dev->domain))
+		return ERR_CAST(dev->domain);
+
+	cla_nr_devs++;
+
+	return dev;
+}
+
+static int cla_probe(struct platform_device *pdev)
+{
+	int cpu;
+	void __iomem *reg;
+	size_t reg_size;
+	struct cla_dev *dev;
+	struct resource *res;
+
+	/*
+	 * TODO: the firmware maps this as well to access PL3, and the guest
+	 * will map PL1 and PL0. Avoid TLB attr mismatches by only mapping what
+	 * we need.
+	 */
+	reg = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
+	if (IS_ERR(reg)) {
+		dev_err(&pdev->dev, "could not map CLA registers\n");
+		return PTR_ERR(reg);
+	}
+
+	if (!IS_ALIGNED(res->start, SZ_256K)) {
+		dev_err(&pdev->dev, "invalid CLA registers alignment\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * As a guest we may not get PL3 or PL2. Tolerate CLAs smaller
+	 * than 4*CLA_REG_SIZE.
+	 */
+	reg_size = resource_size(res);
+	if (reg_size > CLA_FRAME_SIZE ||
+	    reg_size < (cla_kernel_pl + 1) * CLA_REG_SIZE) {
+		dev_err(&pdev->dev, "unexpected CLA registers size\n");
+		return -EINVAL;
+	}
+
+	cpu = cla_of_to_cpu(pdev->dev.of_node);
+	if (cpu < 0)
+		return cpu;
+
+	/* Reject CLAs for offline CPUs. See cla_module_init(). */
+	if (!cpu_online(cpu))
+		return -ENODEV;
+
+	dev = cla_dev_alloc(&pdev->dev, cpu, reg, res->start);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+
+	return 0;
+}
+
+static const struct of_device_id cla_of_match[] = {
+	{.compatible = "arm,cla",},
+	{},
+};
+MODULE_DEVICE_TABLE(of, cla_of_match);
+
+static struct platform_driver cla_driver = {
+	.driver	= {
+		.name			= "arm-cla",
+		.of_match_table		= cla_of_match,
+	},
+};
+
+static int __init cla_module_init(void)
+{
+	bool driver_registered = false;
+	int ret;
+
+	/*
+	 * For now, we reject any CLAs discovered via FW tables, whose CPU is
+	 * offline during init. This keeps things simple by allowing us to probe
+	 * all HW at init time. Keep the online CPU set stable so that the
+	 * cpu_online() check in cla_probe() is consistent with the online cpus
+	 * when we call cpuhp_setup_state().
+	 */
+	scoped_guard(cpus_read_lock) {
+		/*
+		 * CPUs may be hotplugged, but all CLAs are described by
+		 * firmware so the probe can be synchronous. This only sets up
+		 * the resources, and CPUHP callbacks do the actual peeking and
+		 * poking. This returns an error when no CLA has an online CPU.
+		 */
+		ret = platform_driver_probe(&cla_driver, cla_probe);
+		if (ret) {
+			if (ret != -ENODEV)
+				pr_err("arm-cla: probe failed with %d\n", ret);
+			/* Some domains may have been created during probe. */
+			goto err_hardware;
+		}
+		driver_registered = true;
+
+		ret = cla_domains_finalise();
+		if (ret) {
+			pr_err("arm-cla: failed to finalise domains: %d", ret);
+			goto err_hardware;
+		}
+
+		/*
+		 * Each CPU initializes their own CLA. CPUHP uses a pair of
+		 * smp_mb() when calling the startup callback, ensuring that
+		 * cla_dev_setup() reads fully initialized cla_lut_cpu and
+		 * cla_dev structures.
+		 */
+		ret = cpuhp_setup_state_cpuslocked(CPUHP_AP_ONLINE_DYN,
+						   "arm-cla", cla_dev_setup,
+						   cla_dev_teardown);
+		if (ret < 0) {
+			pr_err("arm-cla: failed to setup cpuhp: %d", ret);
+			goto err_hardware;
+		}
+		cla_cpuhp_state = ret;
+	}
+
+	return 0;
+
+err_hardware:
+	if (cla_cpuhp_state >= 0)
+		cpuhp_remove_state(cla_cpuhp_state);
+	cla_domains_free();
+	if (driver_registered)
+		platform_driver_unregister(&cla_driver);
+	return ret;
+}
+
+static void __exit cla_module_exit(void)
+{
+	cpuhp_remove_state(cla_cpuhp_state);
+	cla_domains_free();
+	platform_driver_unregister(&cla_driver);
+}
+
+module_init(cla_module_init);
+module_exit(cla_module_exit);
 
 MODULE_DESCRIPTION("Arm Core Local Accelerator");
 MODULE_AUTHOR("Arm Limited");
diff --git a/drivers/misc/arm-cla/cla-topology.c b/drivers/misc/arm-cla/cla-topology.c
new file mode 100644
index 000000000000..5137a0e041e5
--- /dev/null
+++ b/drivers/misc/arm-cla/cla-topology.c
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Arm CLA driver - device topology initialization
+ *
+ * A CLA domain is a group of devices that work together and cannot be isolated
+ * from each other. They are owned by a single user at a time.
+ *
+ * Copyright 2026 Arm Limited.
+ */
+
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+
+#include "arm-cla.h"
+
+DEFINE_XARRAY(cla_domains);
+unsigned int cla_nr_domains;
+
+/*
+ * Some CPUs may not have a CLA. So cla_lut_cpu (indexed by CPU) may be sparse,
+ * but cla_lut_pg (indexed by page offset in mmap'ed file) is a contiguous array
+ * of all devices, of size cla_nr_devs, sorted by domain.
+ */
+struct cla_dev **cla_lut_cpu;
+struct cla_dev **cla_lut_pg;
+unsigned int cla_nr_devs;
+
+static struct cla_domain *cla_domain_alloc(struct cla_dev *dev, unsigned int fwid)
+{
+	int ret;
+	struct cla_domain *domain;
+
+	domain = kzalloc_obj(*domain);
+	if (!domain)
+		return ERR_PTR(-ENOMEM);
+
+	ret = xa_insert(&cla_domains, fwid, domain, GFP_KERNEL);
+	if (ret < 0)
+		goto err_free_domain;
+
+	domain->nr_devs = 1;
+	domain->devs = kzalloc_obj(*domain->devs);
+	if (!domain->devs) {
+		ret = -ENOMEM;
+		goto err_free_id;
+	}
+	domain->devs[0] = dev;
+
+	return domain;
+
+err_free_id:
+	xa_erase(&cla_domains, fwid);
+err_free_domain:
+	kfree(domain);
+	return ERR_PTR(ret);
+}
+
+/**
+ * cla_dev_domain_get - get or create a CLA domain for a device
+ * @dev: CLA device
+ *
+ * Return: CLA domain pointer on success, or an ERR_PTR() on failure.
+ */
+struct cla_domain *cla_dev_domain_get(struct cla_dev *dev)
+{
+	int ret;
+	unsigned int fwid;
+	struct cla_dev **devs;
+	struct cla_domain *domain;
+
+	/* Domain ID is provided by firmware */
+	ret = of_property_read_u32(dev->dev->of_node, "arm,domain", &fwid);
+	if (WARN_ON(ret))
+		return ERR_PTR(-EINVAL);
+
+	domain = xa_load(&cla_domains, fwid);
+	if (domain) {
+		devs = krealloc_array(domain->devs, domain->nr_devs + 1,
+				      sizeof(*devs), GFP_KERNEL);
+		if (!devs)
+			return ERR_PTR(-ENOMEM);
+		domain->devs = devs;
+		domain->devs[domain->nr_devs++] = dev;
+		return domain;
+	}
+
+	return cla_domain_alloc(dev, fwid);
+}
+
+/**
+ * cla_domains_finalise - build CLA device lookup tables
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+int __init cla_domains_finalise(void)
+{
+	int ret = -ENOMEM;
+	unsigned int j;
+	unsigned long fwid;
+	struct cla_domain *domain;
+	unsigned int pg_offset = 0;
+
+	cla_lut_cpu = kzalloc_objs(*cla_lut_cpu, nr_cpu_ids);
+	if (!cla_lut_cpu)
+		goto err_free;
+
+	cla_lut_pg = kzalloc_objs(*cla_lut_pg, cla_nr_devs);
+	if (!cla_lut_pg)
+		goto err_free;
+
+	ret = -EINVAL;
+	cla_nr_domains = 0;
+
+	/*
+	 * Populate the lookup tables. Domains are keyed by fwid (which may be
+	 * arbitrary) in xarray. Provide domain with a suitable, consecutive id
+	 * for user space.
+	 */
+	xa_for_each(&cla_domains, fwid, domain) {
+		domain->id = cla_nr_domains++;
+		domain->pg_offset = pg_offset;
+
+		for (j = 0; j < domain->nr_devs; j++) {
+			struct cla_dev *dev = domain->devs[j];
+
+			if (WARN_ON(dev->cpu >= nr_cpu_ids) ||
+			    WARN_ON(pg_offset >= cla_nr_devs) ||
+			    WARN_ON(cla_lut_cpu[dev->cpu]) ||
+			    WARN_ON(cla_lut_pg[pg_offset]))
+				goto err_free;
+
+			cla_lut_cpu[dev->cpu] = dev;
+			cla_lut_pg[pg_offset] = dev;
+			dev->pg_offset = pg_offset;
+			pg_offset++;
+		}
+	}
+
+	return 0;
+
+err_free:
+	kfree(cla_lut_cpu);
+	kfree(cla_lut_pg);
+	cla_lut_cpu = NULL;
+	cla_lut_pg = NULL;
+	return ret;
+}
+
+/**
+ * cla_domains_free - free CLA domains and lookup tables
+ *
+ * Domain schedulers must be stopped and CPU hotplug callbacks removed first.
+ */
+void cla_domains_free(void)
+{
+	unsigned long fwid;
+	struct cla_domain *domain;
+
+	kfree(cla_lut_cpu);
+	kfree(cla_lut_pg);
+	cla_lut_cpu = NULL;
+	cla_lut_pg = NULL;
+	xa_for_each(&cla_domains, fwid, domain) {
+		xa_erase(&cla_domains, fwid);
+		kfree(domain->devs);
+		kfree(domain);
+	}
+	cla_nr_domains = 0;
+}
-- 
2.43.0

