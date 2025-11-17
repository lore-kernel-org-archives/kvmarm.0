Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA5133BBC2
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405325; cv=none; b=Z16po+YAVBJzwjOV+X0CeG4kFqZgdtD0EQ2Qq6yXVxBK16YpKaaiG0FUrWPWM5qTdzs/5bShBO2Ii7uJO9gdAudR9vxYMFEts233SR1JMXdhOvKgQxtz9TB+NKtVSO47ZDcMFKqCVpbnMMXLfsjb1tUDjsqe0dik4DSn8i6GCQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405325; c=relaxed/simple;
	bh=i72KEyIIF7BldyepX+BF2QCGkIH25YglohZoplhDZ30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r9QwNnl2GhvkhsUYIQlgQ5+bxd9eEGhA6RP7ky57/ZloLYlfXyGS5Dno3FzHIjk7d81ld8ywu7BquZeASHi+HL4CV01+XAZWOgw0UdrchWpuja7BGfNNSOOsioEvG3XmjZzG9FmCLtpxBsUpIgNgpChmK2JcGvTwQq51riFkubc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EZhENVOe; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EZhENVOe"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b733b21a138so494327466b.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405321; x=1764010121; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pg6/d7tYH7Fa8SuxEA+vck9sHqkvG7ZrFQ8YnS0s4pY=;
        b=EZhENVOeVm23SPPNgyfsdwqmKle/K1FnXd635I2zd0Hr7zwRHNeG4Dbh+AWtCNNFET
         eF+nmvLPzwqzc7+sgY1ftTWFO5sULEVJ7j3qPi16oOm9rxHaO7AzmWGgQw4DZcSdJXC3
         xbfWtWwFYtpj/8tWlE6A3Xq56Zz6OnDb2wNua/azBm4T3aiyqY81WwSO+xQ4OZLAwqFd
         7u58YvV+3o1x0uPcoq5Dda4pVt+dM89j1v+/Fa/ILPkVyPX1cJjk5a6RA3EFkB37AnBO
         bnEwYciXs384iaxAAU919evEmd8oee63d8wjFVqN81xSOtT9lvXVD/aovGk0uWlDnwkf
         j3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405321; x=1764010121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pg6/d7tYH7Fa8SuxEA+vck9sHqkvG7ZrFQ8YnS0s4pY=;
        b=inZpYk8kYWziHg2agx3tUaLF9sQtpfq5BpogCX7k8D0KKt4EA3RCt9gs2I925Or0wM
         Tmosib0KXXEOPRyFSYJsVM3eXPxqyXeZ1MeEOXiWqyZnvyws2dup2naekMPIMUDAJczT
         COPC/r8Zrbd/nt8i01fuhntbC4WA/dAaLZCUtMR0CqT6RfSRCCCCgAZF2/nNnCWighMf
         POtclEDw2jk5YxBggP31zopFJaQrGXuBaDf9iqeq6cQy8omcQPkgdsuCttKYYQDvlFdf
         0g7ZBYvgaohCVw0ffibySl3ZRWA9KONtzTIDPKUyBjhC6l12lPuIX1oalnh0E3ers+aP
         bw0Q==
X-Forwarded-Encrypted: i=1; AJvYcCX1KBspJnRhLzWO5txmr1uhtqCOxnZuvAtoxPBeOx0IXkClxwn4VVKrjHa5LbvLKLV7mosP8Ow=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJLsAA2o+TLIioazE5P+dFjsUPvyNvcmbexlvZnLE3vdeeItO4
	nAFFnqStcY4IHbFFyjXIl94SGczvdQKpwIbeDU3vk4ptqgqKuVTJjCTPaNsuMwem9OHWs9Hg5hQ
	xtxkDwabhC6X5jw==
X-Google-Smtp-Source: AGHT+IEDmtdye0WfWxlkb3rtc6UM9OGL+b9K1JFhVnvxv97zVFh9YFE5Gri7gLnInPVmef/IeMxDtKAYgxWvdw==
X-Received: from ejczi1.prod.google.com ([2002:a17:907:e981:b0:b70:b2b1:8ca])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:97c9:b0:b73:5db5:b6d9 with SMTP id a640c23a62f3a-b7367c16560mr1552133566b.55.1763405320730;
 Mon, 17 Nov 2025 10:48:40 -0800 (PST)
Date: Mon, 17 Nov 2025 18:48:02 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-16-smostafa@google.com>
Subject: [PATCH v5 15/27] iommu/arm-smmu-v3-kvm: Create array for hyp SMMUv3
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

As the hypervisor has no access to firmware tables, the device discovery
is done from the kernel, where it parses firmware tables and populates a
list of devices to the hypervisor, which later takes over.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 82 ++++++++++++++++++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  | 13 +++
 2 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index ca12560639c5..1d72951b7b53 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -8,6 +8,7 @@
 #include <asm/kvm_pkvm.h>
 
 #include <linux/auxiliary_bus.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 
@@ -16,6 +17,45 @@
 
 extern struct kvm_iommu_ops kvm_nvhe_sym(smmu_ops);
 
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
+/*
+ * The hypervisor have to know the basic information about the SMMUs
+ * from the firmware.
+ * This has to be done before the SMMUv3 probes and does anything meaningful
+ * with the hardware, otherwise it becomes harder to reason about the SMMU
+ * state and we'd require to hand-off the state to the hypervisor at certain point
+ * while devices are live, which is complicated and dangerous.
+ * Instead, the hypervisor is interested in a very small part of the probe path,
+ * so just add a separate logic for it.
+ */
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
 static size_t smmu_hyp_pgt_pages(void)
 {
 	/*
@@ -30,6 +70,21 @@ static size_t smmu_hyp_pgt_pages(void)
 static struct platform_driver smmuv3_nesting_driver;
 static int smmuv3_nesting_probe(struct platform_device *pdev)
 {
+	struct resource *res;
+	struct hyp_arm_smmu_v3_device *smmu = &kvm_arm_smmu_array[kvm_arm_smmu_cur];
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	smmu->mmio_addr = res->start;
+	smmu->mmio_size = resource_size(res);
+	if (smmu->mmio_size < SZ_128K) {
+		dev_err(&pdev->dev, "MMIO region too small(%pr)\n", &res);
+		return -EINVAL;
+	}
+
+	if (of_dma_is_coherent(pdev->dev.of_node))
+		smmu->features |= ARM_SMMU_FEAT_COHERENCY;
+
+	kvm_arm_smmu_cur++;
 	return 0;
 }
 
@@ -41,12 +96,31 @@ static int kvm_arm_smmu_v3_register(void)
 	if (!is_protected_kvm_enabled() || !nr_pages)
 		return 0;
 
-	ret = platform_driver_probe(&smmuv3_nesting_driver, smmuv3_nesting_probe);
+	ret = kvm_arm_smmu_array_alloc();
 	if (ret)
 		return ret;
 
-	return kvm_iommu_register_driver(kern_hyp_va(lm_alias(&kvm_nvhe_sym(smmu_ops))),
-					 nr_pages);
+	ret = platform_driver_probe(&smmuv3_nesting_driver, smmuv3_nesting_probe);
+	if (ret)
+		goto out_err;
+
+	ret = kvm_iommu_register_driver(kern_hyp_va(lm_alias(&kvm_nvhe_sym(smmu_ops))),
+					nr_pages);
+	if (ret)
+		goto out_err;
+
+	/*
+	 * These variables are stored in the nVHE image, and won't be accessible
+	 * after KVM initialization. Ownership of kvm_arm_smmu_array will be
+	 * transferred to the hypervisor as well.
+	 */
+	kvm_hyp_arm_smmu_v3_smmus = kvm_arm_smmu_array;
+	kvm_hyp_arm_smmu_v3_count = kvm_arm_smmu_count;
+	return ret;
+
+out_err:
+	kvm_arm_smmu_array_free();
+	return ret;
 };
 
 static int smmu_create_aux_device(struct device *dev, void *data)
@@ -67,7 +141,7 @@ static int smmu_create_aux_device(struct device *dev, void *data)
 static struct platform_driver smmuv3_nesting_driver;
 static int kvm_arm_smmu_v3_post_init(void)
 {
-	if (!is_protected_kvm_enabled())
+	if (!is_protected_kvm_enabled() || !kvm_arm_smmu_cur)
 		return 0;
 
 	WARN_ON(driver_for_each_device(&smmuv3_nesting_driver.driver, NULL,
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index f6ad91d3fb85..744ee2b7f0b4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -4,7 +4,20 @@
 
 #include <asm/kvm_asm.h>
 
+/*
+ * Parameters from the trusted host:
+ * @mmio_addr		base address of the SMMU registers
+ * @mmio_size		size of the registers resource
+ * @features		Features of SMMUv3, subset of the main driver
+ *
+ * Other members are filled and used at runtime by the SMMU driver.
+ * @base		Virtual address of SMMU registers
+ */
 struct hyp_arm_smmu_v3_device {
+	phys_addr_t		mmio_addr;
+	size_t			mmio_size;
+	void __iomem		*base;
+	u32			features;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.52.0.rc1.455.g30608eb744-goog

