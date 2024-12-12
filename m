Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BCB241F47
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026797; cv=none; b=A9fNqXCzQOzS1xwixQeblvDn/VjrpLKD7BqXeLbfieWgmyk1omJj6M1Umb41BXm+CHIueN8WLepIXo08PRExS1CeX/bdFn64GLG2LMio48Y3IgzZZfocqRHq9aiWKODyxedVXN5/qHV6FSSH2mD5cDFzA1QXaULBKg7yY5mM4Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026797; c=relaxed/simple;
	bh=7/D79MYPdDU2T6iY5awYcWs+bBtc+h6wuBQGuuIFMIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KYWHUL7PeZvnoWS6RqAlz5bJzpu/zh4N7b7z+KK4eUQSaFYSZryo0Tw9WvqIYo5X8MVxtomE2jX3+f9xCL+ERpVh2o6xekopmfEiR8Zzdl2dCq6StN+LjlUic1ExhGxChtjQeK6tVi9/VTuQ4cAjFHyI1Z4hAeKe6EF//DPyrNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SGEPyeAi; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SGEPyeAi"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361efc9dc6so5740635e9.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026794; x=1734631594; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NKQvLMAR4pXvIl9rjZ9gjgm+IMNIvYiup7Xyty4Kn6A=;
        b=SGEPyeAiMUSO9oOHO5M0Y9xFkRScLtqI1SsbAdxhi5aMMEjAWnh5QIDCvDdjRJ8TJP
         nkIbvtwmd6hUvde+V1xOEiFSWhzWi0ffX0fC18dU5jlAPQsM4EVxBilH7crpSmlH06dF
         XE2iQ8ZotAH/HEt1LvGHHz1wLTj9y9mL0uHxEWHQYILAKzi2+a7cGVEc2xU1ffV6mNY1
         Kmdsl5mC07PzRVfj4eAhgeEsDtdKdx1Y1MgwY5i7k1UALx7OIfrB2yKbNCwltUVBP1IG
         dZEI0ISDZ2SSJ6QFAUK5BmDS7iEzqz/UgmVKTz0jl9UPIuf/KwGISgGzqn75oTYIk1Iq
         rO6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026794; x=1734631594;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NKQvLMAR4pXvIl9rjZ9gjgm+IMNIvYiup7Xyty4Kn6A=;
        b=rbWJ9I+HwuYO8BmbNVCKNZuRxyEJFPnbu2lbxEEM79sgBk3v9uDrSVciXz0aJZoa6G
         36MtRwv5ta018QNCq7EA3YDy1Z9ElwxNaMXEpTAvNaPQMiu7Ycp9n7n2S6rz2UnhtKzq
         HKNXdZiSw/9dlMuBnWe0U+uDnj/3w+B+LIYKVd7qaTpewCroOFdXptL24PyzCcI8qu68
         U0k/kmsDBLv4ZIHMffIrWRSjUuAlL/Cc702qtFDkr/nXHW8MY1SUZ+MhELZK2q3JEtpV
         NXiD4Bh0fEZUyxOHW8Hxd4Za2a0iptCWADgVm/91b2SoFB7Y8f0z6eUO14tFLlAgWTJM
         3DJg==
X-Forwarded-Encrypted: i=1; AJvYcCU1kYdDcwsTBS3f3HYJ6qYAA3gP1UHnMI+H8CuPttJT981V93KYq+BA0M9gj3wf+8BjeYxG08A=@lists.linux.dev
X-Gm-Message-State: AOJu0YySUzeNVg3NFN+DEPOUfB8sxET3QPmQmdr5+3rfwAYG6oYrOJx+
	13NtfAaqX1ZfKPTv6BrsUPtJk0cxT98/JZV2j8pX+SeSVyQgmXgotwlecT0QUXeEq6F8VBTjUVt
	fjs6ZvspTwA==
X-Google-Smtp-Source: AGHT+IFkHgsqAYvLOBec6cgNAQkg3vmQRCOKbFIfkLxDpGopMY/6t1JJbqk9n+vF2FSRrh/Pk6B9mVEKRUOq9Q==
X-Received: from wmbjl5.prod.google.com ([2002:a05:600c:6a85:b0:434:f119:f1a])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3583:b0:434:f871:1b9d with SMTP id 5b1f17b1804b1-4362287091cmr39041375e9.33.1734026794478;
 Thu, 12 Dec 2024 10:06:34 -0800 (PST)
Date: Thu, 12 Dec 2024 18:04:17 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-54-smostafa@google.com>
Subject: [RFC PATCH v2 53/58] iommu/arm-smmu-v3-kvm: Probe power domains
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Try to use SCMI if possible, otherwise rely on HVC to the hypervisor
to notify about power changes, this is ONLY safe if the SMMU resets
to blocking DMA.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 674ce2b02a4b..deeed994a131 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -8,6 +8,7 @@
 #include <asm/kvm_mmu.h>
 
 #include <linux/arm-smccc.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 
@@ -21,6 +22,7 @@ struct host_arm_smmu_device {
 	struct arm_smmu_device		smmu;
 	pkvm_handle_t			id;
 	u32				boot_gbpa;
+	struct kvm_power_domain		power_domain;
 };
 
 #define smmu_to_host(_smmu) \
@@ -654,6 +656,77 @@ static int kvm_arm_smmu_device_reset(struct host_arm_smmu_device *host_smmu)
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
+		dev_warn(dev, "Unknown PM method for %pOF, using HVC\n",
+			 args.np);
+		pd->type = KVM_POWER_DOMAIN_HOST_HVC;
+		pd->device_id = kvm_arm_smmu_cur;
+	}
+	of_node_put(parent);
+	of_node_put(args.np);
+	return ret;
+}
+
 static int kvm_arm_smmu_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -681,6 +754,10 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	ret = kvm_arm_probe_power_domain(dev, &host_smmu->power_domain);
+	if (ret)
+		return ret;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	size = resource_size(res);
 	if (size < SZ_128K) {
@@ -738,6 +815,7 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	hyp_smmu->mmio_addr = ioaddr;
 	hyp_smmu->mmio_size = size;
 	hyp_smmu->features = smmu->features;
+	hyp_smmu->iommu.power_domain = host_smmu->power_domain;
 	kvm_arm_smmu_cur++;
 
 	return arm_smmu_register_iommu(smmu, &kvm_arm_smmu_ops, ioaddr);
-- 
2.47.0.338.g60cca15819-goog

