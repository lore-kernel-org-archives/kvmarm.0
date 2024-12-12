Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D49B236958
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026741; cv=none; b=Slc8p/kehDRawUFq83cGUbXh3GF25RsWDmYchQnAa9CM3n1wMz6AGBywMgUc93qugfzelpZCMxvF9vI7e52ETJWzZc+76igTWi9Bw+BkC/D0+BBf2jaHNYugN+s5MZsg9IYwiV1XhDE3EUCm1/6j/7q89gYVlyXLiXM0lNg2CTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026741; c=relaxed/simple;
	bh=zZ1Nzljx/w3TaRRu2FIWD04CjYa8X5+HeWRzj5ds/lk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KaraZdQyeNFnXr90HP/lMf3fvzB1Q0YjXkvRe7n7zA7YKcdXB/TnU75GDWR5yRTowCMnuB6qmDSkCcTMSxXhEC8TQnnm94uiyoGEZANnvgrgSmLPWbX4R9/hAzW/VBXB2R1CO64mJEHv4b/CHMlxWavlqHlcaofdvvK2dQ9Clug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cnqbnfDi; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cnqbnfDi"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-385e9c698e7so504800f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026738; x=1734631538; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ybNvGVgl/hoCzKNXbffTwzQBiR9JZU3Un5nM2P0DGi4=;
        b=cnqbnfDi69l3VxBNNEb5TrvAD3gryGWX9d0Hkff5oa5iNjSr99giSgpDmhDmdDx+D9
         1gaDhGrSf+YgiyuoFJSH15i4NwXYYgF9Q8G1ejxW/Z+zXCnmb/iHSfxucKWyd0jVX/rI
         eKg0sKOnbptR5JFHU7NQigbXzqMz9IvFy0qw5ymQu/w3oXamZPGo2sSOcC1UsnouwP59
         bA/1iqNksxTLU2bFylN5UTzqkiz9zRDlhTISCgxjFQcTB8lyvtaBKKT8+BHDlC7CoMlQ
         Z0uwArnCVJ04GUooNMhG0a6gIgtNjMnCEG/B2jJsr4spGUWcSccMbDBhoKV1axJs5ny8
         j5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026738; x=1734631538;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ybNvGVgl/hoCzKNXbffTwzQBiR9JZU3Un5nM2P0DGi4=;
        b=uaWW2WoJb7i+tT3+rRep9+gjwBHgC6TQXVFDCgJOvfRikv1hVhK69rBiJpMfM0w1HH
         QzQLh19Lp73R3FxHk2qZ/CE8pwKXrFPtuGVgBXD/zuRueKhGfUBB8zZN1mnzsBwaVSPP
         tp7RY5aEQj0hBOuySpvYNCzny/XVPaPFdLANc/6toqTcF4fB+jPs2zEuKUkyc2e0LBku
         SjNI6e0rqOy/8OAt01nyWP51+58GrHJNEutJmnO5/DrCQgb/XC0we663mtH8p7Tqy3tg
         EpLpBuoEqXRn6sJT+OunC5qbRUl4EKsubv9phoQfSEMRdk1BJrOCkytiy5eruxwzG2fv
         hKHQ==
X-Forwarded-Encrypted: i=1; AJvYcCULUXq7iJbctlOmjdGhqvcUYFhhlZJsNRADihnGByTnMhvdP/FOHvNBReKJr6mloTUZqyljeP4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3DZ+ksUCFSLPMQkad64tbwfMU7xOc15q9elJDdcfYSNhW4zml
	0C7qL5eJZObtvLXjjDOtMzvuMbUP5sJRBBMBTM2tV+LzErYfWjTMRXxbu9b+HGhkNuiFy/fvnBW
	uG2pJwsmHGA==
X-Google-Smtp-Source: AGHT+IE0b7txsRIOyvGxW20/4w0Q8YO5iAlMJIT7VhEN6QmR2/Vq39IVy03R+zOk9tpZ9g+gCkzVceXKRYZllw==
X-Received: from wmbg5.prod.google.com ([2002:a05:600c:a405:b0:434:fddf:5c1a])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:18a2:b0:385:faf5:ebc8 with SMTP id ffacd0b85a97d-38788847313mr3909644f8f.21.1734026737836;
 Thu, 12 Dec 2024 10:05:37 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:50 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-27-smostafa@google.com>
Subject: [RFC PATCH v2 26/58] KVM: arm64: smmu-v3: Initialize registers
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

Ensure all writable registers are properly initialized. We do not touch
registers that will not be read by the SMMU due to disabled features.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 130 +++++++++++++++++++-
 include/kvm/arm_smmu_v3.h                   |  11 ++
 2 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index d2a570c9f3ec..f7e60c188cb0 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -4,16 +4,144 @@
  *
  * Copyright (C) 2022 Linaro Ltd.
  */
+#include <asm/arm-smmu-v3-common.h>
 #include <asm/kvm_hyp.h>
 #include <kvm/arm_smmu_v3.h>
 #include <nvhe/iommu.h>
+#include <nvhe/mem_protect.h>
+#include <nvhe/mm.h>
+#include <nvhe/pkvm.h>
+
+#define ARM_SMMU_POLL_TIMEOUT_US	100000 /* 100ms arbitrary timeout */
 
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 
+#define for_each_smmu(smmu) \
+	for ((smmu) = kvm_hyp_arm_smmu_v3_smmus; \
+	     (smmu) != &kvm_hyp_arm_smmu_v3_smmus[kvm_hyp_arm_smmu_v3_count]; \
+	     (smmu)++)
+
+/*
+ * Wait until @cond is true.
+ * Return 0 on success, or -ETIMEDOUT
+ */
+#define smmu_wait(_cond)					\
+({								\
+	int __i = 0;						\
+	int __ret = 0;						\
+								\
+	while (!(_cond)) {					\
+		if (++__i > ARM_SMMU_POLL_TIMEOUT_US) {		\
+			__ret = -ETIMEDOUT;			\
+			break;					\
+		}						\
+		pkvm_udelay(1);					\
+	}							\
+	__ret;							\
+})
+
+static int smmu_write_cr0(struct hyp_arm_smmu_v3_device *smmu, u32 val)
+{
+	writel_relaxed(val, smmu->base + ARM_SMMU_CR0);
+	return smmu_wait(readl_relaxed(smmu->base + ARM_SMMU_CR0ACK) == val);
+}
+
+/* Transfer ownership of structures from host to hyp */
+static int smmu_take_pages(u64 phys, size_t size)
+{
+	WARN_ON(!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size));
+	return __pkvm_host_donate_hyp(phys >> PAGE_SHIFT, size >> PAGE_SHIFT);
+}
+
+static void smmu_reclaim_pages(u64 phys, size_t size)
+{
+	WARN_ON(!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size));
+	WARN_ON(__pkvm_hyp_donate_host(phys >> PAGE_SHIFT, size >> PAGE_SHIFT));
+}
+
+static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u64 val, old;
+	int ret;
+
+	if (!(readl_relaxed(smmu->base + ARM_SMMU_GBPA) & GBPA_ABORT))
+		return -EINVAL;
+
+	/* Initialize all RW registers that will be read by the SMMU */
+	ret = smmu_write_cr0(smmu, 0);
+	if (ret)
+		return ret;
+
+	val = FIELD_PREP(CR1_TABLE_SH, ARM_SMMU_SH_ISH) |
+	      FIELD_PREP(CR1_TABLE_OC, CR1_CACHE_WB) |
+	      FIELD_PREP(CR1_TABLE_IC, CR1_CACHE_WB) |
+	      FIELD_PREP(CR1_QUEUE_SH, ARM_SMMU_SH_ISH) |
+	      FIELD_PREP(CR1_QUEUE_OC, CR1_CACHE_WB) |
+	      FIELD_PREP(CR1_QUEUE_IC, CR1_CACHE_WB);
+	writel_relaxed(val, smmu->base + ARM_SMMU_CR1);
+	writel_relaxed(CR2_PTM, smmu->base + ARM_SMMU_CR2);
+	writel_relaxed(0, smmu->base + ARM_SMMU_IRQ_CTRL);
+
+	val = readl_relaxed(smmu->base + ARM_SMMU_GERROR);
+	old = readl_relaxed(smmu->base + ARM_SMMU_GERRORN);
+	/* Service Failure Mode is fatal */
+	if ((val ^ old) & GERROR_SFM_ERR)
+		return -EIO;
+	/* Clear pending errors */
+	writel_relaxed(val, smmu->base + ARM_SMMU_GERRORN);
+
+	return 0;
+}
+
+static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int ret;
+
+	if (!PAGE_ALIGNED(smmu->mmio_addr | smmu->mmio_size))
+		return -EINVAL;
+
+	ret = ___pkvm_host_donate_hyp(smmu->mmio_addr >> PAGE_SHIFT,
+				      smmu->mmio_size >> PAGE_SHIFT,
+				      /* accept_mmio */ true);
+	if (ret)
+		return ret;
+
+	smmu->base = hyp_phys_to_virt(smmu->mmio_addr);
+
+	ret = smmu_init_registers(smmu);
+	if (ret)
+		return ret;
+
+	return kvm_iommu_init_device(&smmu->iommu);
+}
+
 static int smmu_init(void)
 {
-	return -ENOSYS;
+	int ret;
+	struct hyp_arm_smmu_v3_device *smmu;
+	size_t smmu_arr_size = PAGE_ALIGN(sizeof(*kvm_hyp_arm_smmu_v3_smmus) *
+					  kvm_hyp_arm_smmu_v3_count);
+	phys_addr_t smmu_arr_phys;
+
+	kvm_hyp_arm_smmu_v3_smmus = kern_hyp_va(kvm_hyp_arm_smmu_v3_smmus);
+
+	smmu_arr_phys = hyp_virt_to_phys(kvm_hyp_arm_smmu_v3_smmus);
+
+	ret = smmu_take_pages(smmu_arr_phys, smmu_arr_size);
+	if (ret)
+		return ret;
+
+	for_each_smmu(smmu) {
+		ret = smmu_init_device(smmu);
+		if (ret)
+			goto out_reclaim_smmu;
+	}
+
+	return 0;
+out_reclaim_smmu:
+	smmu_reclaim_pages(smmu_arr_phys, smmu_arr_size);
+	return ret;
 }
 
 /* Shared with the kernel driver in EL1 */
diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
index 521028b3ff71..fb24bcef1624 100644
--- a/include/kvm/arm_smmu_v3.h
+++ b/include/kvm/arm_smmu_v3.h
@@ -5,8 +5,19 @@
 #include <asm/kvm_asm.h>
 #include <kvm/iommu.h>
 
+/*
+ * Parameters from the trusted host:
+ * @mmio_addr		base address of the SMMU registers
+ * @mmio_size		size of the registers resource
+ *
+ * Other members are filled and used at runtime by the SMMU driver.
+ */
 struct hyp_arm_smmu_v3_device {
 	struct kvm_hyp_iommu	iommu;
+	phys_addr_t		mmio_addr;
+	size_t			mmio_size;
+
+	void __iomem		*base;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.47.0.338.g60cca15819-goog

