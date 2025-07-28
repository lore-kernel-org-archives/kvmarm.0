Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11079283FF5
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725234; cv=none; b=GqsnJANbiZ7k2sGfJfKr4UweLSdMUZkSfl2m8klvl4Fz6PaHIUnbOjD37FAKcb6aI/94RNfPqLt1p2by07FRy/Bd3ae2xcwuoUU5nN+0yGiXXwBR4acy/qM46fakpc9uWV+d2ttDGV9kwuhVazIUn15k2FFXaUpgH729yY1q0ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725234; c=relaxed/simple;
	bh=iUAPvh90F7xw1smx2NYZbBpxRCpRJZPB/00pjmytjgc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KlTmvRpQlgzjp/+Apf9MNvOeBkdeMMY6hLJ5abhtFD7RVdDG+qyeYt4vzvFMBeBca2vWoJjLKj6oqgjsOBCI9Dv1/rLhwO9rIysZWUpnvnEjQZh/6AyQ7P9cmfTFewpniMANhobDAg5aKi/aA+K54KWIX0ujbh2l4B38b/3AqNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1iFIqvTi; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1iFIqvTi"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-451d7de4ae3so22265345e9.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725229; x=1754330029; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jMj7CyXERBbRhhok3Kl0AYfjJc+Eliaw2DG7Dg7hsI4=;
        b=1iFIqvTiq2yOXXwOMDPLyVCqamTmbkLeNiMjvegPJsyxKxBes+tQKXfa8kmhUmQbh/
         LhkE+2/IQGvRo2NSfucNlFrvthlL20kZ5oGHaYnz2VUyv1u56FYU3k1DTcx6QVrBiZ2a
         nrN+o4ueLzb0DUj8xs6mdNbN4BT/d68YuT1iwKoCqrIYXRa3ZTLAhfmZLkWrRyiLNSlb
         hp5GROK6iUy5zjbZI1sY+EKhqsC+k2xaCTvhG1CvEdboJYmwvDYqO78xSMhsEvCDtEg8
         3bTIZgXC9VOZB/Arw6q1bqm/bx0Zwk+F4EfoCwNeHPnur9zXMaJDHQ3Q/KRZHhUXi/Av
         2/pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725229; x=1754330029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jMj7CyXERBbRhhok3Kl0AYfjJc+Eliaw2DG7Dg7hsI4=;
        b=WJKXQJyOnsGlbnONFSa1HFqchacDkXmuh3VIuHGSr+uC2AiWi5XXiOyhBtJ3jYTpfU
         Knm0mz2OzkPzy3J2TjSQM7CtpslmPsfOau1HIB/bLi3jB8D32wVuouIFq85W52aFDn3t
         EDDYXIhqghjJ9yl1/mQcb74rNap3/iDDXsvLPumiXxBGSqkh4yl/BvxKorLxhZs4Tmuy
         iJs6Q3a66PhHiEdDEPTO0Ntw1PUaRIAm+F4T0Ignnh0eCTpXbXbRXYRtNBefvQKEPX2l
         6EKxgBDHUoB49U4opXi/LCD4JNS3pEGEJct90oYeNlGNsiT4VfFzFmYc77w2WHpkCVZy
         cKbg==
X-Forwarded-Encrypted: i=1; AJvYcCWlWWOS69UkI4rovwWVUj1pmwkGggsx4U4JWVSLMKpicVP6TARbMt6iJ35L6Mk7gdy6lcyQSxg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJmZhBXKp85oMJOvH64Pvt+xGmMXTtWy41OZ6DH4wg7CC2gdtC
	+EhYof4acQlf8ZTyJPZRFeLKcLdfvBfQhICtvc7G6vlwoGJsrVAijaIniKS/KT9XikC0nxNJ9Ex
	fOzkbuLKpUwOPSg==
X-Google-Smtp-Source: AGHT+IHGBEMNWMKylKuu/FAAD8mciBjhdEaRLqrqR0Cf/8KRjBl1KjBNnc9kjb20/qxDpGrYsboTcaiSOpQbJA==
X-Received: from wmbdv17.prod.google.com ([2002:a05:600c:6211:b0:442:ea0c:c453])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1992:b0:456:1b6f:c888 with SMTP id 5b1f17b1804b1-45876554f82mr88636195e9.23.1753725229065;
 Mon, 28 Jul 2025 10:53:49 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:53:06 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-20-smostafa@google.com>
Subject: [PATCH v3 19/29] iommu/arm-smmu-v3-kvm: Initialize registers
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Ensure all writable registers are properly initialized. We do not touch
registers that will not be read by the SMMU due to disabled features.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 149 +++++++++++++++++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |  12 ++
 2 files changed, 160 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 2f43804e08e0..e9bc35e019b6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -7,15 +7,162 @@
 #include <asm/kvm_hyp.h>
 
 #include <nvhe/iommu.h>
+#include <nvhe/mem_protect.h>
 
 #include "arm_smmu_v3.h"
 
+#define ARM_SMMU_POLL_TIMEOUT_US	100000 /* 100ms arbitrary timeout */
+
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
+	int __ret = 0;						\
+	u64 delay = pkvm_time_get() + ARM_SMMU_POLL_TIMEOUT_US;	\
+								\
+	while (!(_cond)) {					\
+		if (pkvm_time_get() >= delay) {			\
+			__ret = -ETIMEDOUT;			\
+			break;					\
+		}						\
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
+/* Put the device in a state that can be probed by the host driver. */
+static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int i;
+	size_t nr_pages = smmu->mmio_size >> PAGE_SHIFT;
+
+	for (i = 0 ; i < nr_pages ; ++i) {
+		u64 pfn = (smmu->mmio_addr >> PAGE_SHIFT) + i;
+
+		WARN_ON(__pkvm_hyp_donate_host_mmio(pfn));
+	}
+}
+
+static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int i;
+	size_t nr_pages;
+	int ret;
+
+	if (!PAGE_ALIGNED(smmu->mmio_addr | smmu->mmio_size))
+		return -EINVAL;
+
+	nr_pages = smmu->mmio_size >> PAGE_SHIFT;
+	for (i = 0 ; i < nr_pages ; ++i) {
+		u64 pfn = (smmu->mmio_addr >> PAGE_SHIFT) + i;
+
+		/*
+		 * This should never happen, so it's fine to be strict to avoid
+		 * complicated error handling.
+		 */
+		WARN_ON(__pkvm_host_donate_hyp_mmio(pfn));
+	}
+	smmu->base = hyp_phys_to_virt(smmu->mmio_addr);
+
+	ret = smmu_init_registers(smmu);
+	if (ret)
+		goto out_err;
+	return ret;
+
+out_err:
+	smmu_deinit_device(smmu);
+	return ret;
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
+	while (smmu != kvm_hyp_arm_smmu_v3_smmus)
+		smmu_deinit_device(--smmu);
+	smmu_reclaim_pages(smmu_arr_phys, smmu_arr_size);
+	return ret;
 }
 
 /* Shared with the kernel driver in EL1 */
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index f6ad91d3fb85..9b1d021ada63 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -4,7 +4,19 @@
 
 #include <asm/kvm_asm.h>
 
+#include "../arm-smmu-v3-common.h"
+
+/*
+ * Parameters from the trusted host:
+ * @mmio_addr		base address of the SMMU registers
+ * @mmio_size		size of the registers resource
+ * @base		Virtual address of SMMU registers
+ * Other members are filled and used at runtime by the SMMU driver.
+ */
 struct hyp_arm_smmu_v3_device {
+	phys_addr_t		mmio_addr;
+	size_t			mmio_size;
+	void __iomem		*base;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.50.1.552.g942d659e1b-goog

