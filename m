Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F3E849B
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:55 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id l8so12606625wms.3
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jBsZPV3gipM57S7lAbp42QSD9Ff7K7v1FMixncXNZ8=;
        b=jqqn6lEE7IVGOwDOGUD7sfXW39/KCeRyDY2/IuSjMlatK+c9ZDof8lJLlOvnpmvWTA
         tlSQGbKWdoTrC/MOU9HAgwktipxQF610xlaH/dYWp+pmmSLnjBtuGF9Qz95H06qb4MwO
         yAncx8QkWUkTvExb8Th18C0UWALTn9rEn+/sdpo30zE2K+g2rBF/PNys2yCbMr6w+Wmp
         DDS1ImzyVxYg4MQ2uUELVaL6vRyTQgT4Fqez6mH6JQcaaAothn5+3OPvFjFMrR8thoAg
         NqSNMBiuDqpmnSyRybV9FGZN/QmMk9u78DMmhJDZ3DZf9x1VV6qC7nVG8reMe3AtwLcM
         EisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6jBsZPV3gipM57S7lAbp42QSD9Ff7K7v1FMixncXNZ8=;
        b=bwt5hCP2OhR/IeczIbl3FplU/gD+Nq+eA4JXbOX0eTXQppwVr17kArX3rom5oi4ljy
         IIsbtKZNmfP5wqOIq4ZnsmhkmZLYYyhfdnGE9oVtRj/5Z6zLkKv0CXd8R8XdT6KAelpL
         gSFszkxRlglvHpVlLdkGLmnT2nK8I8UOG8bqK3f5+Ro5J+uTySOVTLKMnmHaW6Cvw0lQ
         BvdmKh2vjx3GogcZzBdccqn4QjyLJAx4uLRBepKm4H4Eetlnqr4riXjg5lcPIY8qUbc3
         lcmXZXlPNgZHsBhIi1R96bOrI8pEgahms8FtJLpcJ26HHAQ5Pz7fDAsj0TK3PRXjO/H8
         Wc/A==
X-Gm-Message-State: AO0yUKXpSv+8fIOjRXp0siTlYDZgojBjcx82cNcflh0uh6mmO3OLhnJu
	n3Um4G4dfnhTreAAR13lPfDzig==
X-Google-Smtp-Source: AK7set8FozBKO7/9zd4lyvhy8/1NGzLPtlJydoeNS4hNBerIjmIljLa1nO5xlOdJHO+Uy2Ds9zc7/A==
X-Received: by 2002:a05:600c:3d0b:b0:3d0:7fee:8a70 with SMTP id bh11-20020a05600c3d0b00b003d07fee8a70mr2118223wmb.19.1675256394202;
        Wed, 01 Feb 2023 04:59:54 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:53 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 44/45] iommu/arm-smmu-v3-kvm: Support power management with SCMI SMC
Date: Wed,  1 Feb 2023 12:53:28 +0000
Message-Id: <20230201125328.2186498-45-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Discover SCMI parameters for the SMMUv3 power domain, and pass them to
the hypervisor. Power management must use a method based on SMC, so the
hypervisor driver can catch them and keep the software state in sync
with the hardware.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 930d78f6e29f..198e41d808b0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -6,6 +6,7 @@
  */
 #include <asm/kvm_mmu.h>
 #include <linux/local_lock.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 
 #include <kvm/arm_smmu_v3.h>
@@ -495,6 +496,75 @@ static int kvm_arm_smmu_device_reset(struct host_arm_smmu_device *host_smmu)
 	return 0;
 }
 
+static int kvm_arm_probe_scmi_pd(struct device_node *scmi_node,
+				 struct kvm_power_domain *pd)
+{
+	int ret;
+	struct resource res;
+	struct of_phandle_args args;
+
+	pd->type = KVM_POWER_DOMAIN_ARM_SCMI;
+
+	ret = of_parse_phandle_with_args(scmi_node, "shmem", NULL, 0, &args);
+	if (ret)
+		return ret;
+
+	ret = of_address_to_resource(args.np, 0, &res);
+	if (ret)
+		goto out_put_nodes;
+
+	ret = of_property_read_u32(scmi_node, "arm,smc-id",
+				   &pd->arm_scmi.smc_id);
+	if (ret)
+		goto out_put_nodes;
+
+	/*
+	 * The shared buffer is unmapped from the host while a request is in
+	 * flight, so it has to be on its own page.
+	 */
+	if (!IS_ALIGNED(res.start, SZ_64K) || resource_size(&res) < SZ_64K) {
+		ret = -EINVAL;
+		goto out_put_nodes;
+	}
+
+	pd->arm_scmi.shmem_base = res.start;
+	pd->arm_scmi.shmem_size = resource_size(&res);
+
+out_put_nodes:
+	of_node_put(args.np);
+	return ret;
+}
+
+/* TODO: Move this. None of it is specific to SMMU */
+static int kvm_arm_probe_power_domain(struct device *dev,
+				      struct kvm_power_domain *pd)
+{
+	int ret;
+	struct device_node *parent;
+	struct of_phandle_args args;
+
+	if (!of_get_property(dev->of_node, "power-domains", NULL))
+		return 0;
+
+	ret = of_parse_phandle_with_args(dev->of_node, "power-domains",
+					 "#power-domain-cells", 0, &args);
+	if (ret)
+		return ret;
+
+	parent = of_get_parent(args.np);
+	if (parent && of_device_is_compatible(parent, "arm,scmi-smc") &&
+	    args.args_count > 0) {
+		pd->arm_scmi.domain_id = args.args[0];
+		ret = kvm_arm_probe_scmi_pd(parent, pd);
+	} else {
+		dev_err(dev, "Unsupported PM method for %pOF\n", args.np);
+		ret = -EINVAL;
+	}
+	of_node_put(parent);
+	of_node_put(args.np);
+	return ret;
+}
+
 static void *kvm_arm_smmu_alloc_domains(struct arm_smmu_device *smmu)
 {
 	return (void *)devm_get_free_pages(smmu->dev, GFP_KERNEL | __GFP_ZERO,
@@ -513,6 +583,7 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct host_arm_smmu_device *host_smmu;
 	struct hyp_arm_smmu_v3_device *hyp_smmu;
+	struct kvm_power_domain power_domain = {};
 
 	if (kvm_arm_smmu_cur >= kvm_arm_smmu_count)
 		return -ENOSPC;
@@ -530,6 +601,10 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	if (ret || bypass)
 		return ret ?: -EINVAL;
 
+	ret = kvm_arm_probe_power_domain(dev, &power_domain);
+	if (ret)
+		return ret;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	size = resource_size(res);
 	if (size < SZ_128K) {
@@ -606,6 +681,7 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	hyp_smmu->mmio_size = size;
 	hyp_smmu->features = smmu->features;
 	hyp_smmu->iommu.pgtable_cfg = cfg;
+	hyp_smmu->iommu.power_domain = power_domain;
 
 	kvm_arm_smmu_cur++;
 
-- 
2.39.0

