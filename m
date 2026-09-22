Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CA554DAD4
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082801; cv=none; b=Y+/fcOVz8oOo7JdIN0+Iqx+cWnzlmiqubKudxaxwyMAIS16o8visbmRtHwpxr7MupFhU69xNIp255VBsLnMgPHGRH8CAjbpS6yxkpn9Ow5o9LMy8fTzuV6GjdK6wAyei1xAdQrqXm6zRv8cNfadz+MHAU8TzL3b8oKU3hymi0ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082801; c=relaxed/simple;
	bh=KMX7cIYnIjX2qiqQ3Y7F64fSjguRivhQW/PB20GkG04=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PQWKoW4KC1vI75ZuQTxW7RXZekXNYzu4PXq6yqfKFHDoqW76k4t0OK7KSSjd3oR6UTbpXdhP2Wu8orIGWg5p8+uA2mly15X2oUAuaTLwwh48NfGG08CnVuZaoZsvXvTjS9ht9k6X3S8M15f/SI6RT0jnLnfRVr4gng2l6D/4eg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cpd1FnKw; arc=none smtp.client-ip=209.85.218.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cpd1FnKw"
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c29bc25836fso478637066b.3
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082796; x=1790687596; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nOp2axD6H9O+xfB99xRrvquImzm/JRxih28x/6xdp6c=;
        b=Cpd1FnKwTlNhVnyoAai/D8rF+xFk7oEEzqYVgEJ0Cfj7+a1uURobcJPqH4/xo8re8M
         5bd3wM1cy1nivsYlDEyJlZKyCwPU5qMFX6P53l3xNQuFiWe585Sh40W6Hm9wxuO7lsiq
         AO5QXw3zSt02y4pYkIzdPnHG7gZiKW5UsWF4LsPXMfVDLblSP+dquwyVpqapIkYo5WWU
         e6L8suQQXzSDNeuGpli0+AQvlFpgl6mDbWa1BQR77kq54NsT+Zgy17vXwOuKEj0JhmFw
         ztwC8Ol/QR8CCKFZJXvideWPEanldjgpC+ATLY6DoxFXeTpi2ELJAqTB/hJXrbio6bB7
         eFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082796; x=1790687596;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nOp2axD6H9O+xfB99xRrvquImzm/JRxih28x/6xdp6c=;
        b=bJIWQmxMKRxbyzegjkpsuFLp6sBUBvDT3HkFwV97u7UfQ3B8TpW3lQdSbF+KwS1RyJ
         RprB6BKdkCrS6bTZWvF1ZpdMeRmwZaEf89e7rhvPPc8SHsR8ZtUj1f9cXkoqbj23mz6x
         WR5ITOMnrGbeXPu+hxsEovcHmEnXcxXkZBkmGzFUQ35BgqQSzwOAbNN3/aiPKUSgCWQ6
         RLPzow1LpacDTT+fS/WP1etvhCC06+pJgBT09nlM5akAgFvhoj8YDY1+VRD0/a7Y7ZFn
         W5qsvfcMS9ZrXbYXuRAe+oFjWa8yQz6iTuGNmTTlo40RmmLXNsHCHl88KXiT7X4kJ2Fp
         HGXA==
X-Forwarded-Encrypted: i=1; AKwUvBwYTH9E7hUYsdhaMJHu0MU9zqOHg0DizLGIOc9yz0aGEJ8XkMzpaB97bJO8FOE/lkC8GXgCeJA=@lists.linux.dev
X-Gm-Message-State: AFuF++nFlrqqsqyS6DefChoe2LVt1Z7pnh4/sn5MNMOhBDe/yYQic981
	CRp9BBP8zLzIEzvMbDRysxqcXTDHUn+xNQm/+QUxD+liJxnyEBOE/TdYmvr2hHx6ZyAmmuB7ve9
	o9SD3AfAvvxE3mQ==
X-Received: from ejbop17.prod.google.com ([2002:a17:906:bcf1:b0:c15:cf52:157e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:ba89:b0:c29:5151:16b8 with SMTP id a640c23a62f3a-c2a1581803amr1073780166b.2.1790082795608;
 Tue, 22 Sep 2026 06:13:15 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:44 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-12-smostafa@google.com>
Subject: [PATCH v8 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

When KVM runs in protected mode, and CONFIG_ARM_SMMU_V3_PKVM
is enabled, it will manage the SMMUv3 HW using trap and emulate
and present emulated SMMUs to the host kernel.

In that case, those SMMUs will be on the aux bus, so make it
possible to the driver to probe those devices.

Otherwise, everything else is the same, as the KVM emulation
complies with the architecture,so the driver doesn't need
to be modified.

Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   1 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 187 ++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  67 +++++++
 3 files changed, 255 insertions(+)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c

diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index c9ce392e6d31..c3fc5c4a4a1e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -4,5 +4,6 @@ arm_smmu_v3-y := arm-smmu-v3.o arm-smmu-v3-common-lib.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_IOMMUFD) += arm-smmu-v3-iommufd.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
+arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_PKVM) += arm-smmu-v3-kvm.o
 
 obj-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
new file mode 100644
index 000000000000..9947d3a44304
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pKVM host driver for the Arm SMMUv3
+ *
+ * Copyright (C) 2022 Linaro Ltd.
+ */
+#include <asm/kvm_mmu.h>
+#include <asm/kvm_pkvm.h>
+
+#include <linux/auxiliary_bus.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+#include "arm-smmu-v3.h"
+#include "pkvm/arm-smmu-v3-hyp.h"
+
+extern struct pkvm_iommu_ops kvm_nvhe_sym(smmu_ops);
+
+static size_t				kvm_arm_smmu_count;
+static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
+static size_t				kvm_arm_smmu_cur;
+
+static void kvm_arm_smmu_array_free(void)
+{
+	int order;
+
+	order = get_order(kvm_arm_smmu_count * sizeof(*kvm_arm_smmu_array));
+	free_pages((unsigned long)kvm_arm_smmu_array, order);
+}
+
+static int kvm_arm_smmu_array_alloc(void)
+{
+	int smmu_order;
+	struct device_node *np;
+
+	for_each_compatible_node(np, NULL, "arm,smmu-v3")
+		kvm_arm_smmu_count++;
+
+	if (!kvm_arm_smmu_count)
+		return -ENODEV;
+	smmu_order = get_order(kvm_arm_smmu_count * sizeof(*kvm_arm_smmu_array));
+	kvm_arm_smmu_array = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, smmu_order);
+	if (!kvm_arm_smmu_array)
+		return -ENOMEM;
+	return 0;
+}
+
+static unsigned int smmu_hyp_pgt_pages(void)
+{
+	struct device_node *np = of_find_compatible_node(NULL, NULL, "arm,smmu-v3");
+
+	/*
+	 * SMMUv3 uses the same format as the CPU stage-2 and hence have the same memory
+	 * requirements, we add extra 500 pages for L2 STEs.
+	 * Only one set of memory is allocated as the page table is shared between all
+	 * the SMMUs.
+	 */
+	if (np) {
+		of_node_put(np);
+		return host_s2_pgtable_pages() + 500;
+	}
+
+	return 0;
+}
+
+static struct platform_driver smmuv3_nesting_driver;
+static int smmuv3_nesting_probe(struct platform_device *pdev)
+{
+	struct hyp_arm_smmu_v3_device *smmu = &kvm_arm_smmu_array[kvm_arm_smmu_cur];
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+
+	/* Only device tree, ACPI not supported. */
+	if (!dev->of_node)
+		return -EINVAL;
+
+	if (kvm_arm_smmu_cur >= kvm_arm_smmu_count)
+		return -ENOSPC;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	if (of_property_read_bool(dev->of_node, "cavium,cn9900-broken-page1-regspace"))
+		return -EINVAL;
+
+	smmu->mmio_addr = res->start;
+	smmu->mmio_size = resource_size(res);
+	if (smmu->mmio_size < SZ_128K) {
+		dev_err(dev, "MMIO region too small(%pr)\n", res);
+		return -EINVAL;
+	}
+
+	if (of_dma_is_coherent(dev->of_node))
+		smmu->features |= ARM_SMMU_FEAT_COHERENCY;
+
+	kvm_arm_smmu_cur++;
+	return 0;
+}
+
+static int __init kvm_arm_smmu_v3_register(void)
+{
+	size_t nr_pages = smmu_hyp_pgt_pages();
+	int ret;
+
+	if (!is_protected_kvm_enabled() || !nr_pages)
+		return 0;
+
+	ret = kvm_arm_smmu_array_alloc();
+	if (ret)
+		goto out_err;
+
+	ret = platform_driver_probe(&smmuv3_nesting_driver, smmuv3_nesting_probe);
+	if (ret)
+		goto out_free;
+
+	ret = pkvm_iommu_register_driver(kern_hyp_va(lm_alias(&kvm_nvhe_sym(smmu_ops))),
+					 nr_pages);
+	if (ret)
+		goto out_unregister;
+
+	/*
+	 * These variables are stored in the nVHE image, and won't be accessible
+	 * after KVM initialization. Ownership of kvm_arm_smmu_array will be
+	 * transferred to the hypervisor as well.
+	 */
+	kvm_hyp_arm_smmu_v3_smmus = kvm_arm_smmu_array;
+	kvm_hyp_arm_smmu_v3_count = kvm_arm_smmu_cur;
+	return ret;
+
+out_unregister:
+	platform_driver_unregister(&smmuv3_nesting_driver);
+out_free:
+	kvm_arm_smmu_array_free();
+out_err:
+	kvm_arm_smmu_count = 0;
+	kvm_arm_smmu_array = NULL;
+	return ret;
+};
+
+static int smmu_create_aux_device(struct device *dev, void *data)
+{
+	static int dev_id;
+	struct auxiliary_device *auxdev;
+
+	auxdev = __devm_auxiliary_device_create(dev, "protected_kvm",
+						"smmu_v3_emu", NULL, dev_id++);
+	if (!auxdev)
+		return -ENODEV;
+	return 0;
+}
+
+static int kvm_arm_smmu_v3_post_init(void)
+{
+	if (!kvm_arm_smmu_count)
+		return 0;
+
+	/*
+	 * If the hypervisor part of the driver fails, KVM will not initialise.
+	 */
+	if (!is_kvm_arm_initialised()) {
+		kvm_arm_smmu_array_free();
+		platform_driver_unregister(&smmuv3_nesting_driver);
+		return 0;
+	}
+
+	WARN_ON(driver_for_each_device(&smmuv3_nesting_driver.driver, NULL,
+				       NULL, smmu_create_aux_device));
+
+	return 0;
+}
+
+static const struct of_device_id smmuv3_nested_of_match[] = {
+	{ .compatible = "arm,smmu-v3", },
+	{ },
+};
+
+static struct platform_driver smmuv3_nesting_driver = {
+	.driver = {
+		.name = "smmuv3-nesting",
+		.of_match_table = smmuv3_nested_of_match,
+		.suppress_bind_attrs = true,
+	},
+};
+late_initcall(kvm_arm_smmu_v3_post_init);
+subsys_initcall(kvm_arm_smmu_v3_register);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2043c6dc1bdf..d6d1e2d30ef6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -11,6 +11,7 @@
 
 #include <linux/acpi.h>
 #include <linux/acpi_iort.h>
+#include <linux/auxiliary_bus.h>
 #include <linux/bitops.h>
 #include <linux/crash_dump.h>
 #include <linux/delay.h>
@@ -5203,6 +5204,72 @@ static struct platform_driver arm_smmu_driver = {
 module_driver(arm_smmu_driver, platform_driver_register,
 	      arm_smmu_driver_unregister);
 
+#ifdef CONFIG_ARM_SMMU_V3_PKVM
+/*
+ * Now we have 2 devices, the aux device bound to this driver, and pdev
+ * which is the physical platform device bound to the KVM driver but not used.
+ * However, this driver keeps using the platform device for 2 reasons:
+ * 1) Simplicity: Avoiding changing big parts of the code assuming
+ *    the underlying device is a platform device.
+ * 2) Dealing with DMA-API, irqs(MSIs), RPM... requires the physical device.
+ *
+ * That means arm_smmu_device_probe() allocates its devm resources on the
+ * platform device, where they are not freed when the aux device unbinds.
+ * The devres group bounds them to the lifetime of this binding instead.
+ *
+ * The platform device is never unbound, as both drivers set
+ * suppress_bind_attrs and ARM_SMMU_V3_PKVM requires ARM_SMMU_V3=y.
+ */
+static int arm_smmu_device_probe_emu(struct auxiliary_device *auxdev,
+				     const struct auxiliary_device_id *id)
+{
+	struct device *parent = auxdev->dev.parent;
+	void *group;
+	int ret;
+
+	dev_info(&auxdev->dev, "Probing from %s\n", dev_name(parent));
+	group = devres_open_group(parent, NULL, GFP_KERNEL);
+	if (!group)
+		return -ENOMEM;
+
+	ret = arm_smmu_device_probe(to_platform_device(parent));
+	if (ret)
+		devres_release_group(parent, group);
+	else
+		devres_close_group(parent, group);
+	return ret;
+}
+
+static void arm_smmu_device_remove_emu(struct auxiliary_device *auxdev)
+{
+	arm_smmu_device_remove(to_platform_device(auxdev->dev.parent));
+}
+
+static void arm_smmu_device_shutdown_emu(struct auxiliary_device *auxdev)
+{
+	arm_smmu_device_shutdown(to_platform_device(auxdev->dev.parent));
+}
+
+static const struct auxiliary_device_id arm_smmu_aux_table[] = {
+	{ .name = "protected_kvm.smmu_v3_emu" },
+	{ },
+};
+MODULE_DEVICE_TABLE(auxiliary, arm_smmu_aux_table);
+
+static struct auxiliary_driver arm_smmu_driver_emu = {
+	.driver = {
+		.suppress_bind_attrs = true,
+	},
+	.name = "arm-smmu-v3-emu",
+	.id_table = arm_smmu_aux_table,
+	.probe = arm_smmu_device_probe_emu,
+	.remove = arm_smmu_device_remove_emu,
+	.shutdown = arm_smmu_device_shutdown_emu,
+};
+
+module_auxiliary_driver(arm_smmu_driver_emu);
+#endif
+
 MODULE_DESCRIPTION("IOMMU API for ARM architected SMMUv3 implementations");
 MODULE_AUTHOR("Will Deacon <will@kernel.org>");
 MODULE_ALIAS("platform:arm-smmu-v3");
-- 
2.55.0.1082.g2b9226bbc0-goog

