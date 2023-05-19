Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B604E101FA
	for <kvmarm@lists.linux.dev>; Fri, 19 May 2023 15:33:19 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-3f5dbd8f677so55325e9.1
        for <kvmarm@lists.linux.dev>; Fri, 19 May 2023 08:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684510398; x=1687102398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z86CxvgDjR+XK0uf9yod5lX5QLSIaIX8FS/Ty9Oxyco=;
        b=X24fX+TqJfReB8Iq09t+a2WgYpxkcKcPyoTdANZwDXVObw3De/NVmgUnPwCujOcl46
         CABGTuR28Vs7n+trdr346X8iOUoiygSp1+QCzIt6c5ToZHrdiAPBl1wstzBJ6tPg41zl
         8ynHbqa4InnPx1D3esoawq+LR3FMusbAHK3kB52L1ewSV/Ixenat4oiri3OnWyhDWzri
         RhtPM366yNU50x1bbiWCatBsHqhH/QGe1s8qSugQsJY0kolfXlmg8/5ue4CCk3G1Eg68
         ylqEqmBzJN8sau4gf7gv5V+NnJI+nodRNzyKyNX2g4DWIXpSYq18ZLLYfrI4dfOLZIJZ
         9p1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684510398; x=1687102398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z86CxvgDjR+XK0uf9yod5lX5QLSIaIX8FS/Ty9Oxyco=;
        b=BkPoaum5ZvGdUff9YAfMKIyV1ELs3jeo0X5WZaRAxSTU22qwPfM9YRBRh9AXuAPyfe
         7WmN11doc6K46N+B1tDYL4KtEQIGrxwa9LYse0/8+s4cw1S5MLqV/8oWsiBSOs+9l0sb
         HUJbNICsq11IFtJECn35eU9QCRF6Eo1j96HePwl2yzptuUndLKWbXlA+Sx/yEBeoA2tT
         Uxb1ZHjEsqgbbwj3ROV/bXIOoUhoT8iaX7RKcU5FsQBu/WspCU3vUal4cYvTZnfEzs01
         7X6pScbhjka4iLzkBXTKT0jufFCnZ5Nox3IlMYLvjOyzXcWPe6Z6rd2Wyw4zYDlnisb0
         6QJA==
X-Gm-Message-State: AC+VfDzG4ld5AdAlfywDdxRGEfFpv0PwW9hBy/2RGW3ljTL5FUOsplJq
	NXALs2HwQUioWoC0ErvqVzhwGQ==
X-Google-Smtp-Source: ACHHUZ6qEKVEHmq9piPQVm6SKlYXBJCIKcsvG3FkugXOXvqVGo678gNN0J/WEnFpjTK4AcF0U0OV4A==
X-Received: by 2002:a05:600c:4f4f:b0:3f4:2594:118a with SMTP id m15-20020a05600c4f4f00b003f42594118amr216324wmq.2.1684510397778;
        Fri, 19 May 2023 08:33:17 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id z19-20020a7bc7d3000000b003f18b942338sm2735332wmk.3.2023.05.19.08.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 08:33:17 -0700 (PDT)
Date: Fri, 19 May 2023 15:33:13 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 19/45] KVM: arm64: iommu: Add domains
Message-ID: <ZGeWudESZP5BGjaA@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-20-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201125328.2186498-20-jean-philippe@linaro.org>

Hi Jean,

On Wed, Feb 01, 2023 at 12:53:03PM +0000, Jean-Philippe Brucker wrote:
> +/*
> + * Serialize access to domains and IOMMU driver internal structures (command
> + * queue, device tables)
> + */
> +static hyp_spinlock_t iommu_lock;
> +
I was looking more into this lock and I think we can make it per IOMMU instead
of having one big lock to avoid congestion, as I see it is only used to
protect per-IOMMU resources.
Some special handling needed as hyp_spinlock_t is not exposed to EL1.
Maybe something like this:

diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
index b257a3b4bfc5..96d30a37f9e6 100644
--- a/arch/arm64/kvm/hyp/hyp-constants.c
+++ b/arch/arm64/kvm/hyp/hyp-constants.c
@@ -3,11 +3,13 @@
 #include <linux/kbuild.h>
 #include <nvhe/memory.h>
 #include <nvhe/pkvm.h>
+#include <nvhe/spinlock.h>

 int main(void)
 {
 	DEFINE(STRUCT_HYP_PAGE_SIZE,	sizeof(struct hyp_page));
 	DEFINE(PKVM_HYP_VM_SIZE,	sizeof(struct pkvm_hyp_vm));
 	DEFINE(PKVM_HYP_VCPU_SIZE,	sizeof(struct pkvm_hyp_vcpu));
+	DEFINE(HYP_SPINLOCK_SIZE,	sizeof(hyp_spinlock_t));
 	return 0;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index a90b97d8bae3..cf9195e24a08 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -6,6 +6,7 @@ arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
 
 obj-$(CONFIG_ARM_SMMU_V3_PKVM) += arm_smmu_v3_kvm.o
+ccflags-$(CONFIG_ARM_SMMU_V3_PKVM) += -Iarch/arm64/kvm/
 arm_smmu_v3_kvm-objs-y += arm-smmu-v3-kvm.o
 arm_smmu_v3_kvm-objs-y += arm-smmu-v3-common.o
 arm_smmu_v3_kvm-objs := $(arm_smmu_v3_kvm-objs-y)
diff --git a/include/kvm/iommu.h b/include/kvm/iommu.h
index ab888da731bc..82827b99b1ed 100644
--- a/include/kvm/iommu.h
+++ b/include/kvm/iommu.h
@@ -5,6 +5,12 @@
 #include <asm/kvm_host.h>
 #include <kvm/power_domain.h>
 #include <linux/io-pgtable.h>
+#ifdef __KVM_NVHE_HYPERVISOR__
+#include <nvhe/spinlock.h>
+#else
+#include "hyp_constants.h"
+#endif
 
 /*
  * Parameters from the trusted host:
@@ -23,6 +29,11 @@ struct kvm_hyp_iommu {
 
 	struct io_pgtable_params	*pgtable;
 	bool				power_is_off;
+#ifdef __KVM_NVHE_HYPERVISOR__
+	hyp_spinlock_t			iommu_lock;
+#else
+	u8 unused[HYP_SPINLOCK_SIZE];
+#endif
 };
 
 struct kvm_hyp_iommu_memcache {
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index 1f4d5fcc1386..afaf173e65ed 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -14,12 +14,6 @@
 
 struct kvm_hyp_iommu_memcache __ro_after_init *kvm_hyp_iommu_memcaches;
 
-/*
- * Serialize access to domains and IOMMU driver internal structures (command
- * queue, device tables)
- */
-static hyp_spinlock_t iommu_lock;
-
 #define domain_to_iopt(_iommu, _domain, _domain_id)		\
 	(struct io_pgtable) {					\
 		.ops = &(_iommu)->pgtable->ops,			\
@@ -93,10 +87,10 @@ int kvm_iommu_alloc_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 {
 	int ret = -EINVAL;
 	struct io_pgtable iopt;
-	struct kvm_hyp_iommu *iommu;
+	struct kvm_hyp_iommu *iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
 	struct kvm_hyp_iommu_domain *domain;
 
-	hyp_spin_lock(&iommu_lock);
+	hyp_spin_lock(&iommu->iommu_lock);
 	domain = handle_to_domain(iommu_id, domain_id, &iommu);
 	if (!domain)
 		goto out_unlock;
@@ -112,7 +106,7 @@ int kvm_iommu_alloc_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 	domain->refs = 1;
 	domain->pgd = iopt.pgd;
 out_unlock:
-	hyp_spin_unlock(&iommu_lock);
+	hyp_spin_unlock(&iommu->iommu_lock);
 	return ret;
 }
 
@@ -120,10 +114,10 @@ int kvm_iommu_free_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id)
 {
 	int ret = -EINVAL;
 	struct io_pgtable iopt;
-	struct kvm_hyp_iommu *iommu;
+	struct kvm_hyp_iommu *iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
 	struct kvm_hyp_iommu_domain *domain;
 
-	hyp_spin_lock(&iommu_lock);
+	hyp_spin_lock(&iommu->iommu_lock);
 	domain = handle_to_domain(iommu_id, domain_id, &iommu);
 	if (!domain)
 		goto out_unlock;
@@ -137,7 +131,7 @@ int kvm_iommu_free_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id)
 	memset(domain, 0, sizeof(*domain));
 
 out_unlock:
-	hyp_spin_unlock(&iommu_lock);
+	hyp_spin_unlock(&iommu->iommu_lock);
 	return ret;
 }
-- 

(I didn't include full patch as it is too long, but mainly the
rest is s/&iommu_lock/&iommu->iommu_lock)

Please let me know what do you think?

Thanks,
Mostafa

