Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CEE320B
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:34 +0000 (UTC)
Received: by mail-wr1-f53.google.com with SMTP id a3so10534083wrt.6
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zbZLsQb0xg2PPl0XoduEhMIm9PR89tvM6CYFFsggaVQ=;
        b=EJPFEmmztrvIgrDqJ3MkjHOSDg10LW20VhEO2fXjPBvc6j5UWEZd1MsrLv1vfwRpiT
         cc62+AK11q+MLrLeHagED0GqHtTtgNMbjWYdLu4JQS8/BN8YkB9FYd7h4PIS2zdC3+vu
         2iKKBnOpCcuwH0AbFAob7chGyqYiAxwVQoA8kDen4hca8LfZn6MGq5be+PVb9L4jZd3j
         tjp9gmImOJ77dnwKcjQL6qp+oB8pN7DPKOFoIDuuRYA4K2SsX9UQuEM4INZKmw/TnRgF
         b4/t3kcPLOY61LKoEA8twExnhgN2rtn+rPvfdcRIIP5T/5EdnDPr5LLk3KfRf/5YLi0y
         gqFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zbZLsQb0xg2PPl0XoduEhMIm9PR89tvM6CYFFsggaVQ=;
        b=sXSiNBG2DEZRL6oo0Zs9wLlxXRX2gVKY4y83ycKSlZ6GsVlEtPQT0D7cuxuXWU5SeZ
         YE05FjKCPrqoeidcIF/4lk1uHFIYSTc/XEb6nD/z9FIr1U36q9YeiqzNunWQ31E1UG6L
         eoR35od5bZRi/Fs4Ne3IInl1p5ftOWTQJpWyhZts6Ms1S5rryCSPPqZhJpjDYNCvofH7
         NZo/7zI2VjfBGJGLQfp4fC2ErtsySW7bfmU/kNtUEND6nUbj5v9xX20SV3UpXrYACu0B
         pzaRzNi/4MxTxQp+KIji9taN70dJ4KcoBqMpNloVbf/qqWSw2FxVnpoctwj/R4Zrv2j/
         DjSg==
X-Gm-Message-State: AO0yUKWGndconavR6GYfk3Pa5d8xr2S+cjf5YMEChBhj+S0nuSx7ZxYC
	Hs0IhfoEDfVCYip+UWMFWCZa8g==
X-Google-Smtp-Source: AK7set9gMQhL6pt9dp/2vtz2l2umJOa+pYslGi7ef3uzOBfAa+HuE2R6nT4pVnYJgiPfcb1UxI1NgA==
X-Received: by 2002:a5d:6b89:0:b0:2bf:b571:1f18 with SMTP id n9-20020a5d6b89000000b002bfb5711f18mr2573727wrx.61.1675256372895;
        Wed, 01 Feb 2023 04:59:32 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:32 -0800 (PST)
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
Subject: [RFC PATCH 17/45] KVM: arm64: pkvm: Add IOMMU hypercalls
Date: Wed,  1 Feb 2023 12:53:01 +0000
Message-Id: <20230201125328.2186498-18-jean-philippe@linaro.org>
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

The unprivileged host IOMMU driver forwards some of the IOMMU API calls
to the hypervisor, which installs and populates the page tables.

Note that this is not a stable ABI. Those hypercalls change with the
kernel just like internal function calls.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virt/kvm/Kconfig                        |  3 +
 arch/arm64/include/asm/kvm_asm.h        |  7 +++
 arch/arm64/kvm/hyp/include/nvhe/iommu.h | 68 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 77 +++++++++++++++++++++++++
 4 files changed, 155 insertions(+)

diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 9fb1ff6f19e5..99b0ddc50443 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -92,3 +92,6 @@ config KVM_XFER_TO_GUEST_WORK
 
 config HAVE_KVM_PM_NOTIFIER
        bool
+
+config KVM_IOMMU
+       bool
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 12aa0ccc3b3d..e2ced352b49c 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -81,6 +81,13 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_sync_state,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_alloc_domain,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_free_domain,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_attach_dev,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_detach_dev,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_map_pages,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_unmap_pages,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_iova_to_phys,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index c728c8e913da..26a95717b613 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -2,6 +2,74 @@
 #ifndef __ARM64_KVM_NVHE_IOMMU_H__
 #define __ARM64_KVM_NVHE_IOMMU_H__
 
+#if IS_ENABLED(CONFIG_KVM_IOMMU)
+/* Hypercall handlers */
+int kvm_iommu_alloc_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			   unsigned long pgd_hva);
+int kvm_iommu_free_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id);
+int kvm_iommu_attach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			 u32 endpoint_id);
+int kvm_iommu_detach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			 u32 endpoint_id);
+int kvm_iommu_map_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			unsigned long iova, phys_addr_t paddr, size_t pgsize,
+			size_t pgcount, int prot);
+int kvm_iommu_unmap_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			  unsigned long iova, size_t pgsize, size_t pgcount);
+phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t iommu_id,
+				   pkvm_handle_t domain_id, unsigned long iova);
+#else /* !CONFIG_KVM_IOMMU */
+static inline int kvm_iommu_alloc_domain(pkvm_handle_t iommu_id,
+					 pkvm_handle_t domain_id,
+					 unsigned long pgd_hva)
+{
+	return -ENODEV;
+}
+
+static inline int kvm_iommu_free_domain(pkvm_handle_t iommu_id,
+					pkvm_handle_t domain_id)
+{
+	return -ENODEV;
+}
+
+static inline int kvm_iommu_attach_dev(pkvm_handle_t iommu_id,
+				       pkvm_handle_t domain_id,
+				       u32 endpoint_id)
+{
+	return -ENODEV;
+}
+
+static inline int kvm_iommu_detach_dev(pkvm_handle_t iommu_id,
+				       pkvm_handle_t domain_id,
+				       u32 endpoint_id)
+{
+	return -ENODEV;
+}
+
+static inline int kvm_iommu_map_pages(pkvm_handle_t iommu_id,
+				      pkvm_handle_t domain_id,
+				      unsigned long iova, phys_addr_t paddr,
+				      size_t pgsize, size_t pgcount, int prot)
+{
+	return -ENODEV;
+}
+
+static inline int kvm_iommu_unmap_pages(pkvm_handle_t iommu_id,
+					pkvm_handle_t domain_id,
+					unsigned long iova, size_t pgsize,
+					size_t pgcount)
+{
+	return 0;
+}
+
+static inline phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t iommu_id,
+						 pkvm_handle_t domain_id,
+						 unsigned long iova)
+{
+	return 0;
+}
+#endif /* CONFIG_KVM_IOMMU */
+
 struct kvm_iommu_ops {
 	int (*init)(void);
 };
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 37e308337fec..34ec46b890f0 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1059,6 +1059,76 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_teardown_vm(handle);
 }
 
+static void handle___pkvm_host_iommu_alloc_domain(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, iommu, host_ctxt, 1);
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 2);
+	DECLARE_REG(unsigned long, pgd_hva, host_ctxt, 3);
+
+	cpu_reg(host_ctxt, 1) = kvm_iommu_alloc_domain(iommu, domain, pgd_hva);
+}
+
+static void handle___pkvm_host_iommu_free_domain(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, iommu, host_ctxt, 1);
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 2);
+
+	cpu_reg(host_ctxt, 1) = kvm_iommu_free_domain(iommu, domain);
+}
+
+static void handle___pkvm_host_iommu_attach_dev(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, iommu, host_ctxt, 1);
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 2);
+	DECLARE_REG(unsigned int, endpoint, host_ctxt, 3);
+
+	cpu_reg(host_ctxt, 1) = kvm_iommu_attach_dev(iommu, domain, endpoint);
+}
+
+static void handle___pkvm_host_iommu_detach_dev(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, iommu, host_ctxt, 1);
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 2);
+	DECLARE_REG(unsigned int, endpoint, host_ctxt, 3);
+
+	cpu_reg(host_ctxt, 1) = kvm_iommu_detach_dev(iommu, domain, endpoint);
+}
+
+static void handle___pkvm_host_iommu_map_pages(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, iommu, host_ctxt, 1);
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 2);
+	DECLARE_REG(unsigned long, iova, host_ctxt, 3);
+	DECLARE_REG(phys_addr_t, paddr, host_ctxt, 4);
+	DECLARE_REG(size_t, pgsize, host_ctxt, 5);
+	DECLARE_REG(size_t, pgcount, host_ctxt, 6);
+	DECLARE_REG(unsigned int, prot, host_ctxt, 7);
+
+	cpu_reg(host_ctxt, 1) = kvm_iommu_map_pages(iommu, domain, iova, paddr,
+						    pgsize, pgcount, prot);
+}
+
+static void handle___pkvm_host_iommu_unmap_pages(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, iommu, host_ctxt, 1);
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 2);
+	DECLARE_REG(unsigned long, iova, host_ctxt, 3);
+	DECLARE_REG(size_t, pgsize, host_ctxt, 4);
+	DECLARE_REG(size_t, pgcount, host_ctxt, 5);
+
+	cpu_reg(host_ctxt, 1) = kvm_iommu_unmap_pages(iommu, domain, iova,
+						      pgsize, pgcount);
+}
+
+static void handle___pkvm_host_iommu_iova_to_phys(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, iommu, host_ctxt, 1);
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 2);
+	DECLARE_REG(unsigned long, iova, host_ctxt, 3);
+
+	cpu_reg(host_ctxt, 1) = kvm_iommu_iova_to_phys(iommu, domain, iova);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -1093,6 +1163,13 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_vcpu_sync_state),
+	HANDLE_FUNC(__pkvm_host_iommu_alloc_domain),
+	HANDLE_FUNC(__pkvm_host_iommu_free_domain),
+	HANDLE_FUNC(__pkvm_host_iommu_attach_dev),
+	HANDLE_FUNC(__pkvm_host_iommu_detach_dev),
+	HANDLE_FUNC(__pkvm_host_iommu_map_pages),
+	HANDLE_FUNC(__pkvm_host_iommu_unmap_pages),
+	HANDLE_FUNC(__pkvm_host_iommu_iova_to_phys),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
-- 
2.39.0

