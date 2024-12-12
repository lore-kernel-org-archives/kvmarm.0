Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1905223E94
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026716; cv=none; b=hUex6l6qGzbYxBmBSVow+p9Mo2V3UQss13pRFpSnDc391OlO3+wmT8+3AkaazF5sWygEMryCSeAHKwo7MVT7In3NtNfpxPw2fSg8OIO/kON70riH+ThwIsqgTrau/rBssil/QHFn/RHqKaXPzzuiM1qne7F0OKc+GzSbDfZ4z+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026716; c=relaxed/simple;
	bh=3HJivu/WpNNE5R01tWNoZyPnqq7fKgTYFZUtNkKWCGs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WYs2J4UPvmuwF9S1rpCKgk/CYrEW/0nNbPcJ4t4saP8UszOp2oWXFJwfVkXfbsPEhxco3WHHbW6WPPsqMjSur94N5R4DvLfde76NCe99iqr0SVqGgqqQvX9wanJ6VqeIF/ERjv27hoxJzbw/JWoR3duyydHGrWwlym7qFetYzJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wku6mTw6; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wku6mTw6"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-385e1fd40acso549491f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026713; x=1734631513; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cwdSo/iBYWKLrbHTG+HyNIQbWdtp/PGNH3wAwUOLzAc=;
        b=wku6mTw6c5NXPnQsqo/l0OnDhkXnZD3Fj95iWr7moAdAwUuOwf6LADWBpwqZsvr3mU
         Pl1XkvdXh9eaS3fcPEhVMBdU58aPnKM7Asr4jLoti/S6FzRNCh7lPU0EAWkOKTIqP8mr
         19jRZE0k1EtGS3uUQgiDloQgVYp7i1FoE0O6PrQYD9hKKuHwlLAgmCDXRg0IaxWKAtRr
         dXJBjIl1HgY8dW0ihlWVIz2z5EMszsOKo5YkVoW95y8LADUxxGqU2gY+aGHkanz+XhUw
         i2vd8e+mcl6GuY10RjjRrLPqbNv7zzPEk4oICK8RVbZ+rRQ0gvdA5ZVXpD8qtw9rEMVn
         eUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026713; x=1734631513;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cwdSo/iBYWKLrbHTG+HyNIQbWdtp/PGNH3wAwUOLzAc=;
        b=TSQZQbP78pW0kzrRVAeelnAcmfvWpy8YQIpXWrl50CZZ3EpyN6JAF/Cf+9ysap5iZE
         Plwhri6wosDRk+HFWAYrNMOqXCW4j7RFQClcLnJqtGJu6rniwjrORK6tkGRtdHylXTMN
         8gMEn8ESINeNs4SD7bkDqBI3pyM4/2WyEhzale0o0Fiecn4m4a6rED4DVo2n6WrkH0Sh
         0tE4R9jCEG5AdpiXNH4ot8DvFvfBCsEt2keDojlHunL3wXWoLPOSmt5JrYCn4m0JAQAJ
         MFRXa47OEq+ypG2yCKMYQRD9PenRUqRA0gpg1Iy7VrWKhWZclqYRB22DfqrFM9yejLpx
         Q4nQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsglDViUs3UBn/TEO1RvkMOPix7bqECXgmXem2HnuMP6bRbCFwrDx3v6K/XqBnjAml+B2XYQU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxgmwViCrZI7BTr7W9wcuEwAYR9sn+o15jE97Q5BkMvT79ziR2X
	Q0QRAdqMBberd3PKBUnfcsamMHIzee1hu+l1lKUUVafn8M9KisNxNhQ0rNx2jxaXmWQAJ8K4ZKO
	XSv7mWr/kQg==
X-Google-Smtp-Source: AGHT+IFmbvEzDhykMqyy8OjOsZ2NeXlkTbt4cjtUEyGjwEAdXiFcByoXchIDeMneglUtq2nV1Br6AHE0eUe6Bg==
X-Received: from wmom6.prod.google.com ([2002:a05:600c:4606:b0:436:16c6:831])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2b0e:b0:386:8ff:d20b with SMTP id ffacd0b85a97d-3864ce9f344mr5120606f8f.27.1734026713289;
 Thu, 12 Dec 2024 10:05:13 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:38 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-15-smostafa@google.com>
Subject: [RFC PATCH v2 14/58] KVM: arm64: pkvm: Add IOMMU hypercalls
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

The unprivileged host IOMMU driver forwards some of the IOMMU API calls
to the hypervisor, which installs and populates the page tables.

Note that this is not a stable ABI. Those hypercalls change with the
kernel just like internal function calls.

One thing special about some of the IOMMU hypercalls, that they use
newly added hyp_reqs_smccc_encode() to encode memory requests in
the HVC return, leveraging X1, X2 and X3 registers as allowed SMCCC.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/include/asm/kvm_asm.h        |  7 ++
 arch/arm64/kvm/hyp/include/nvhe/iommu.h | 14 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 89 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 40 +++++++++++
 4 files changed, 150 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e4b391bdfdac..9ea155a04332 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -107,6 +107,13 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_alloc_mgt_refill,
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_alloc_mgt_reclaimable,
 	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_alloc_mgt_reclaim,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_alloc_domain,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_free_domain,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_attach_dev,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_detach_dev,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_map_pages,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_unmap_pages,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_iova_to_phys,
 
 	/*
 	 * Start of the dynamically registered hypercalls. Start a bit
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 1ac70cc28a9e..908863f07b0b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -4,6 +4,20 @@
 
 #include <asm/kvm_host.h>
 
+/* Hypercall handlers */
+int kvm_iommu_alloc_domain(pkvm_handle_t domain_id, int type);
+int kvm_iommu_free_domain(pkvm_handle_t domain_id);
+int kvm_iommu_attach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			 u32 endpoint_id, u32 pasid, u32 pasid_bits);
+int kvm_iommu_detach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			 u32 endpoint_id, u32 pasid);
+size_t kvm_iommu_map_pages(pkvm_handle_t domain_id,
+			   unsigned long iova, phys_addr_t paddr, size_t pgsize,
+			   size_t pgcount, int prot);
+size_t kvm_iommu_unmap_pages(pkvm_handle_t domain_id, unsigned long iova,
+			     size_t pgsize, size_t pgcount);
+phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t domain_id, unsigned long iova);
+
 struct kvm_iommu_ops {
 	int (*init)(void);
 };
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 08c0ff823a55..9b224842c487 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -19,6 +19,7 @@
 #include <nvhe/alloc.h>
 #include <nvhe/alloc_mgt.h>
 #include <nvhe/ffa.h>
+#include <nvhe/iommu.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/modules.h>
 #include <nvhe/mm.h>
@@ -1592,6 +1593,87 @@ static void handle___pkvm_hyp_alloc_mgt_reclaim(struct kvm_cpu_context *host_ctx
 	cpu_reg(host_ctxt, 2) = mc.nr_pages;
 }
 
+static void handle___pkvm_host_iommu_alloc_domain(struct kvm_cpu_context *host_ctxt)
+{
+	int ret;
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 1);
+	DECLARE_REG(int, type, host_ctxt, 2);
+
+	ret = kvm_iommu_alloc_domain(domain, type);
+	hyp_reqs_smccc_encode(ret, host_ctxt, this_cpu_ptr(&host_hyp_reqs));
+}
+
+static void handle___pkvm_host_iommu_free_domain(struct kvm_cpu_context *host_ctxt)
+{
+	int ret;
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 1);
+
+	ret = kvm_iommu_free_domain(domain);
+	hyp_reqs_smccc_encode(ret, host_ctxt, this_cpu_ptr(&host_hyp_reqs));
+}
+
+static void handle___pkvm_host_iommu_attach_dev(struct kvm_cpu_context *host_ctxt)
+{
+	int ret;
+	DECLARE_REG(pkvm_handle_t, iommu, host_ctxt, 1);
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 2);
+	DECLARE_REG(unsigned int, endpoint, host_ctxt, 3);
+	DECLARE_REG(unsigned int, pasid, host_ctxt, 4);
+	DECLARE_REG(unsigned int, pasid_bits, host_ctxt, 5);
+
+	ret = kvm_iommu_attach_dev(iommu, domain, endpoint,
+				   pasid, pasid_bits);
+	hyp_reqs_smccc_encode(ret, host_ctxt, this_cpu_ptr(&host_hyp_reqs));
+}
+
+static void handle___pkvm_host_iommu_detach_dev(struct kvm_cpu_context *host_ctxt)
+{
+	int ret;
+	DECLARE_REG(pkvm_handle_t, iommu, host_ctxt, 1);
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 2);
+	DECLARE_REG(unsigned int, endpoint, host_ctxt, 3);
+	DECLARE_REG(unsigned int, pasid, host_ctxt, 4);
+
+	ret = kvm_iommu_detach_dev(iommu, domain, endpoint, pasid);
+	hyp_reqs_smccc_encode(ret, host_ctxt, this_cpu_ptr(&host_hyp_reqs));
+}
+
+static void handle___pkvm_host_iommu_map_pages(struct kvm_cpu_context *host_ctxt)
+{
+	unsigned long ret;
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 1);
+	DECLARE_REG(unsigned long, iova, host_ctxt, 2);
+	DECLARE_REG(phys_addr_t, paddr, host_ctxt, 3);
+	DECLARE_REG(size_t, pgsize, host_ctxt, 4);
+	DECLARE_REG(size_t, pgcount, host_ctxt, 5);
+	DECLARE_REG(unsigned int, prot, host_ctxt, 6);
+
+	ret = kvm_iommu_map_pages(domain, iova, paddr,
+				  pgsize, pgcount, prot);
+	hyp_reqs_smccc_encode(ret, host_ctxt, this_cpu_ptr(&host_hyp_reqs));
+}
+
+static void handle___pkvm_host_iommu_unmap_pages(struct kvm_cpu_context *host_ctxt)
+{
+	unsigned long ret;
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 1);
+	DECLARE_REG(unsigned long, iova, host_ctxt, 2);
+	DECLARE_REG(size_t, pgsize, host_ctxt, 3);
+	DECLARE_REG(size_t, pgcount, host_ctxt, 4);
+
+	ret = kvm_iommu_unmap_pages(domain, iova,
+				    pgsize, pgcount);
+	hyp_reqs_smccc_encode(ret, host_ctxt, this_cpu_ptr(&host_hyp_reqs));
+}
+
+static void handle___pkvm_host_iommu_iova_to_phys(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 1);
+	DECLARE_REG(unsigned long, iova, host_ctxt, 2);
+
+	cpu_reg(host_ctxt, 1) = kvm_iommu_iova_to_phys(domain, iova);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -1649,6 +1731,13 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_hyp_alloc_mgt_refill),
 	HANDLE_FUNC(__pkvm_hyp_alloc_mgt_reclaimable),
 	HANDLE_FUNC(__pkvm_hyp_alloc_mgt_reclaim),
+	HANDLE_FUNC(__pkvm_host_iommu_alloc_domain),
+	HANDLE_FUNC(__pkvm_host_iommu_free_domain),
+	HANDLE_FUNC(__pkvm_host_iommu_attach_dev),
+	HANDLE_FUNC(__pkvm_host_iommu_detach_dev),
+	HANDLE_FUNC(__pkvm_host_iommu_map_pages),
+	HANDLE_FUNC(__pkvm_host_iommu_unmap_pages),
+	HANDLE_FUNC(__pkvm_host_iommu_iova_to_phys),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index 3bd87d2084e9..9022fd612a49 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -16,3 +16,43 @@ int kvm_iommu_init(void)
 
 	return kvm_iommu_ops->init();
 }
+
+int kvm_iommu_alloc_domain(pkvm_handle_t domain_id, int type)
+{
+	return -ENODEV;
+}
+
+int kvm_iommu_free_domain(pkvm_handle_t domain_id)
+{
+	return -ENODEV;
+}
+
+int kvm_iommu_attach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			 u32 endpoint_id, u32 pasid, u32 pasid_bits)
+{
+	return -ENODEV;
+}
+
+int kvm_iommu_detach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			 u32 endpoint_id, u32 pasid)
+{
+	return -ENODEV;
+}
+
+size_t kvm_iommu_map_pages(pkvm_handle_t domain_id,
+			   unsigned long iova, phys_addr_t paddr, size_t pgsize,
+			   size_t pgcount, int prot)
+{
+	return 0;
+}
+
+size_t kvm_iommu_unmap_pages(pkvm_handle_t domain_id, unsigned long iova,
+			     size_t pgsize, size_t pgcount)
+{
+	return 0;
+}
+
+phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t domain_id, unsigned long iova)
+{
+	return 0;
+}
-- 
2.47.0.338.g60cca15819-goog

