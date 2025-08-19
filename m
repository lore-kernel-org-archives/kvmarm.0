Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ADE3451A0
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640363; cv=none; b=V8EkG/fg/zLIRSIo+6nKmErZr3q1ilrqu7t7Sh/EElrkhKVTGxRsbrXLIeuLGXsmQMfGmWB3Lk0sPrbNYhdS9+5DslNJ5OnZjg1JQm5Hljbae/kFMqbS0uxr8sDag2sAatO3UPmSFY6EnJItE+hLS0t7KhSlAQTkT4x7lmicEO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640363; c=relaxed/simple;
	bh=XwAPL7cCuKQZyzoDsXxWaKOvvw7cbqN7O6Uc5m8Oi5Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MCsF9J8uh/dISgiLb0gGyixvAP6w/yM7QZe6Qqjel0+rAfZUfUTTPUknwZkcPzXwecmbasIfVt868qLvqVuOoqX8dvxjVx1OCoMU3anqIU0ngMsmtzRB1lPsCSjBqOq7rufJ3YvW0OgmWIUbObj57tflB9pK/QclJEAZkHnUzRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hTNbdskR; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hTNbdskR"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0cfbafso36591195e9.2
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640359; x=1756245159; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xwu1qRO+eOJjyAwUn9pi1Q+O90cBvLjGAkOSG+zhKow=;
        b=hTNbdskRAkPJAlj991gvadFWp1ANicBRJGGbEWBw28cyq7yxrD1mWhjA361vjkW8Fv
         Bt7V2sfigIkeB1N/w3LxIfVmsyy4tLsgFTzANLlVRE7J5/O9KVmbNaa6Pf76o5UTvT2C
         QN1S2dsE5hGiP2Pf6u3qjmuwmWeCgm4uoFhg/zWYm0ZQWyOaCjE0pYDjzwa8qR3580/2
         HHmUFoIwqvijsxo8vpFMlFh4jSWPwE8qB5mz8/YtasXoCDDv9FC+HxsyZ2CcpCrqi/N/
         aKrOJ9n3z+FTDBcbk1EIZzpP4wpYme48VgUGUZkFuMOwOwanc3cz7iHpGnVECHBuuXFT
         fqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640359; x=1756245159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xwu1qRO+eOJjyAwUn9pi1Q+O90cBvLjGAkOSG+zhKow=;
        b=Cvk0zZ/XVnnNPy5727hXe0B37Vp+NU6WllPHI9ZY3pgAT8ezhqgkKzfoQ3Ms9OFMUx
         jgyc/Oa/wVaJo0lSReoOUlMEx5LENeScRmjBFwdkyhX43dx+qQKLpYkruzmKDW9uHNse
         xKRKLFhNtudmHi13A8Z65jHP0kEh4zwbUJGKC1Qm6zHNR17RuARN4Oq4TnzMzFb+N4E/
         uYQdzwvimGkxI0l1qYk62WMmXqthT5QJ89hgjNCt6Mi1kr2Fxo/BEd3Butc+fizu35OO
         yDgBT5SrlYWQzN4utdOYUC9hhVm2AtbqFb0bgle50FfhSR929ZjAapfaWkwLCom8+c+C
         FsEg==
X-Forwarded-Encrypted: i=1; AJvYcCVvUPkPxQALo5f0pd001S6HJ+Ju/FvfACy4WnmAkcAaBv7FO14KrCFguWCPjJNNJDZgVsIBw+U=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz48ZKADPGaDqCnHI3/X2+xwP3xYFpz3KbGqDzJ0/RR5S7tLtUI
	rFNaZCNc6ngisb2BoMZG98a0nlH5kEsWDCoxgWxC9/M457egY5cYKoVjPmINtZ0eOl+HFhacXVv
	hasydl5hMRfugHA==
X-Google-Smtp-Source: AGHT+IEhkGtNHGU6UMmeB0BAIZ4sLir5Qlb/i2T9JqWqyDJv4XQTeVZhQ/vtD+ljWCO9zlGmXGV9Ovms10Lr6A==
X-Received: from wmbhc5.prod.google.com ([2002:a05:600c:8705:b0:458:6799:d779])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b05:b0:43d:745a:5a50 with SMTP id 5b1f17b1804b1-45b479ea5a9mr2802145e9.19.1755640359305;
 Tue, 19 Aug 2025 14:52:39 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:44 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-17-smostafa@google.com>
Subject: [PATCH v4 16/28] iommu/arm-smmu-v3-kvm: Create array for hyp SMMUv3
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

As the hypervisor has no access to firmware tables, the device discovery
is done from the kernel, where it parses firmware tables and populates a
list of devices to the hypervisor, which later takes over.

At the moment only the device tree is supported.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 93 ++++++++++++++++++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  | 13 +++
 2 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index ac4eac6d567f..27ea39c0fb1f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -7,6 +7,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_pkvm.h>
 
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 
 #include "arm-smmu-v3.h"
@@ -14,6 +15,75 @@
 
 extern struct kvm_iommu_ops kvm_nvhe_sym(smmu_ops);
 
+static size_t				kvm_arm_smmu_count;
+static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
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
+	int ret;
+	int i = 0;
+
+	kvm_arm_smmu_count = 0;
+	for_each_compatible_node(np, NULL, "arm,smmu-v3")
+		kvm_arm_smmu_count++;
+
+	if (!kvm_arm_smmu_count)
+		return -ENODEV;
+
+	smmu_order = get_order(kvm_arm_smmu_count * sizeof(*kvm_arm_smmu_array));
+	kvm_arm_smmu_array = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, smmu_order);
+	if (!kvm_arm_smmu_array)
+		return -ENOMEM;
+
+	/* Basic device tree parsing. */
+	for_each_compatible_node(np, NULL, "arm,smmu-v3") {
+		struct resource res;
+
+		ret = of_address_to_resource(np, 0, &res);
+		if (ret)
+			goto out_err;
+		kvm_arm_smmu_array[i].mmio_addr = res.start;
+		kvm_arm_smmu_array[i].mmio_size = resource_size(&res);
+		if (kvm_arm_smmu_array[i].mmio_size < SZ_128K) {
+			pr_err("SMMUv3(%s) has unsupported size(0x%lx)\n", np->name,
+			       kvm_arm_smmu_array[i].mmio_size);
+			ret = -EINVAL;
+			goto out_err;
+		}
+
+		if (of_dma_is_coherent(np))
+			kvm_arm_smmu_array[i].features |= ARM_SMMU_FEAT_COHERENCY;
+
+		i++;
+	}
+
+	return 0;
+
+out_err:
+	kvm_arm_smmu_array_free();
+	return ret;
+}
+
 size_t smmu_hyp_pgt_pages(void)
 {
 	/*
@@ -27,10 +97,31 @@ size_t smmu_hyp_pgt_pages(void)
 
 static int kvm_arm_smmu_v3_register(void)
 {
+	int ret;
+
 	if (!is_protected_kvm_enabled())
 		return 0;
 
-	return kvm_iommu_register_driver(kern_hyp_va(lm_alias(&kvm_nvhe_sym(smmu_ops))));
+	ret = kvm_arm_smmu_array_alloc();
+	if (ret)
+		return ret;
+
+	ret = kvm_iommu_register_driver(kern_hyp_va(lm_alias(&kvm_nvhe_sym(smmu_ops))));
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
 
 core_initcall(kvm_arm_smmu_v3_register);
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
2.51.0.rc1.167.g924127e9c0-goog

