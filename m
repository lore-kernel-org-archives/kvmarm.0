Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC7763A7
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:34 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id q10so17233118wrm.4
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z3Yg+/pxswLQbPunG2DXR1JjAIQ1RbfjYcFDMPdwdzM=;
        b=p/nK7+wPjP1LcWDKxtBPABr2lvORJQGF5cwCSAMD9DwVZ1FAJ1dTpxTJnepxujM7dA
         7xQceH6A7so/6YM33Q33Mid751l1L4aK2IopzI9FvOZ3a9nkxXtSGU1H2/eYx/BUoYMQ
         UKO3pbv+TuYBp3+FIBmvd3sWSps62WaMrbgik6YBvQ6tfGN03HHekQv2+FHK0wZPY2ZT
         p2FyzuY7awvCU5Qa8sxG9yFr5i9HClCJY7Say468qpHde3oyJ5myuMq2RCBmdFkGpgT0
         HplkULNe7KeFKAnOw2uPphLzQUETd5b6CoDDJugCRT+WgAmzvgEfX12JL991faA7cPii
         Omgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z3Yg+/pxswLQbPunG2DXR1JjAIQ1RbfjYcFDMPdwdzM=;
        b=52LsKdgkjf/NQWnDRVhrSnnMqM4Go+KAlpKY+sn2TyLq6VYhwjdQOY++tWnm5w3ob7
         zTXrQfE0utVWcTT0jEFp2j65doLccgRqGKfRLntaITiFZjp7fG/mBZJEGeLkYlzgHmpV
         i5HgAyx8QiA/IijXVrd6BciDJAp++Dh0ollV5NXhu/X8L2UB1cS5Tay1HKBYHW0vV10U
         gyZBceFQOh4xJfLV5T+Iyp/cht/UnHgex4AzZzSYYsXUgo1RMLwqPMTQTdlwPfEceiWk
         0pRSaHXpkWeH2juUgNbfLm2zxNqdwkrrxP6LyT8h+jYOKXOygNxbBqU0Tdv0ltpxCvya
         LVgg==
X-Gm-Message-State: AO0yUKXwigvU5zUBGoXzB9Mw1gc4EdCxlpdJ/R+p3hLjharMCJYe6uxJ
	MX49iVpSa+8MM0Mson7ivDb3og==
X-Google-Smtp-Source: AK7set+yLNu0DSsphBd0SuP5yvH+awkiyKJcWCgw8Jnpd5g9PXARhY0JjXD6HP7p0G4o7WR+j5r/4Q==
X-Received: by 2002:adf:c713:0:b0:2bf:b8f0:f6c6 with SMTP id k19-20020adfc713000000b002bfb8f0f6c6mr2542639wrg.45.1675256374468;
        Wed, 01 Feb 2023 04:59:34 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:34 -0800 (PST)
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
Subject: [RFC PATCH 19/45] KVM: arm64: iommu: Add domains
Date: Wed,  1 Feb 2023 12:53:03 +0000
Message-Id: <20230201125328.2186498-20-jean-philippe@linaro.org>
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

The IOMMU domain abstraction allows to share the same page tables
between multiple devices. That may be necessary due to hardware
constraints, if multiple devices cannot be isolated by the IOMMU
(conventional PCI bus for example). It may also help with optimizing
resource or TLB use. For pKVM in particular, it may be useful to reduce
the amount of memory required for page tables. All devices owned by the
host kernel could be attached to the same domain (though that requires
host changes).

Each IOMMU device holds an array of domains, and the host allocates
domain IDs that index this array. The alloc() operation initializes the
domain and prepares the page tables. The attach() operation initializes
the device table that holds the PGD and its configuration.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/include/nvhe/iommu.h |  16 +++
 include/kvm/iommu.h                     |  55 ++++++++
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 161 ++++++++++++++++++++++++
 3 files changed, 232 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 4959c30977b8..76d3fa6ce331 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -2,8 +2,12 @@
 #ifndef __ARM64_KVM_NVHE_IOMMU_H__
 #define __ARM64_KVM_NVHE_IOMMU_H__
 
+#include <kvm/iommu.h>
+#include <linux/io-pgtable.h>
+
 #if IS_ENABLED(CONFIG_KVM_IOMMU)
 int kvm_iommu_init(void);
+int kvm_iommu_init_device(struct kvm_hyp_iommu *iommu);
 void *kvm_iommu_donate_page(void);
 void kvm_iommu_reclaim_page(void *p);
 
@@ -74,8 +78,20 @@ static inline phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t iommu_id,
 }
 #endif /* CONFIG_KVM_IOMMU */
 
+struct kvm_iommu_tlb_cookie {
+	struct kvm_hyp_iommu	*iommu;
+	pkvm_handle_t		domain_id;
+};
+
 struct kvm_iommu_ops {
 	int (*init)(void);
+	struct kvm_hyp_iommu *(*get_iommu_by_id)(pkvm_handle_t smmu_id);
+	int (*alloc_iopt)(struct io_pgtable *iopt, unsigned long pgd_hva);
+	int (*free_iopt)(struct io_pgtable *iopt);
+	int (*attach_dev)(struct kvm_hyp_iommu *iommu, pkvm_handle_t domain_id,
+			  struct kvm_hyp_iommu_domain *domain, u32 endpoint_id);
+	int (*detach_dev)(struct kvm_hyp_iommu *iommu, pkvm_handle_t domain_id,
+			  struct kvm_hyp_iommu_domain *domain, u32 endpoint_id);
 };
 
 extern struct kvm_iommu_ops kvm_iommu_ops;
diff --git a/include/kvm/iommu.h b/include/kvm/iommu.h
index 12b06a5df889..2bbe5f7bf726 100644
--- a/include/kvm/iommu.h
+++ b/include/kvm/iommu.h
@@ -3,6 +3,23 @@
 #define __KVM_IOMMU_H
 
 #include <asm/kvm_host.h>
+#include <linux/io-pgtable.h>
+
+/*
+ * Parameters from the trusted host:
+ * @pgtable_cfg:	page table configuration
+ * @domains:		root domain table
+ * @nr_domains:		max number of domains (exclusive)
+ *
+ * Other members are filled and used at runtime by the IOMMU driver.
+ */
+struct kvm_hyp_iommu {
+	struct io_pgtable_cfg		pgtable_cfg;
+	void				**domains;
+	size_t				nr_domains;
+
+	struct io_pgtable_params	*pgtable;
+};
 
 struct kvm_hyp_iommu_memcache {
 	struct kvm_hyp_memcache	pages;
@@ -12,4 +29,42 @@ struct kvm_hyp_iommu_memcache {
 extern struct kvm_hyp_iommu_memcache *kvm_nvhe_sym(kvm_hyp_iommu_memcaches);
 #define kvm_hyp_iommu_memcaches kvm_nvhe_sym(kvm_hyp_iommu_memcaches)
 
+struct kvm_hyp_iommu_domain {
+	void			*pgd;
+	u32			refs;
+};
+
+/*
+ * At the moment the number of domains is limited by the ASID and VMID size on
+ * Arm. With single-stage translation, that size is 2^8 or 2^16. On a lot of
+ * platforms the number of devices is actually the limiting factor and we'll
+ * only need a handful of domains, but with PASID or SR-IOV support that limit
+ * can be reached.
+ *
+ * In practice we're rarely going to need a lot of domains. To avoid allocating
+ * a large domain table, we use a two-level table, indexed by domain ID. With
+ * 4kB pages and 16-bytes domains, the leaf table contains 256 domains, and the
+ * root table 256 pointers. With 64kB pages, the leaf table contains 4096
+ * domains and the root table 16 pointers. In this case, or when using 8-bit
+ * VMIDs, it may be more advantageous to use a single level. But using two
+ * levels allows to easily extend the domain size.
+ */
+#define KVM_IOMMU_MAX_DOMAINS	(1 << 16)
+
+/* Number of entries in the level-2 domain table */
+#define KVM_IOMMU_DOMAINS_PER_PAGE \
+	(PAGE_SIZE / sizeof(struct kvm_hyp_iommu_domain))
+
+/* Number of entries in the root domain table */
+#define KVM_IOMMU_DOMAINS_ROOT_ENTRIES \
+	(KVM_IOMMU_MAX_DOMAINS / KVM_IOMMU_DOMAINS_PER_PAGE)
+
+#define KVM_IOMMU_DOMAINS_ROOT_SIZE \
+	(KVM_IOMMU_DOMAINS_ROOT_ENTRIES * sizeof(void *))
+
+/* Bits [16:split] index the root table, bits [split-1:0] index the leaf table */
+#define KVM_IOMMU_DOMAIN_ID_SPLIT	ilog2(KVM_IOMMU_DOMAINS_PER_PAGE)
+
+#define KVM_IOMMU_DOMAIN_ID_LEAF_MASK	((1 << KVM_IOMMU_DOMAIN_ID_SPLIT) - 1)
+
 #endif /* __KVM_IOMMU_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index 1a9184fbbd27..7404ea77ed9f 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -13,6 +13,22 @@
 
 struct kvm_hyp_iommu_memcache __ro_after_init *kvm_hyp_iommu_memcaches;
 
+/*
+ * Serialize access to domains and IOMMU driver internal structures (command
+ * queue, device tables)
+ */
+static hyp_spinlock_t iommu_lock;
+
+#define domain_to_iopt(_iommu, _domain, _domain_id)		\
+	(struct io_pgtable) {					\
+		.ops = &(_iommu)->pgtable->ops,			\
+		.pgd = (_domain)->pgd,				\
+		.cookie = &(struct kvm_iommu_tlb_cookie) {	\
+			.iommu		= (_iommu),		\
+			.domain_id	= (_domain_id),		\
+		},						\
+	}
+
 void *kvm_iommu_donate_page(void)
 {
 	void *p;
@@ -41,10 +57,155 @@ void kvm_iommu_reclaim_page(void *p)
 				     PAGE_SIZE);
 }
 
+static struct kvm_hyp_iommu_domain *
+handle_to_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+		 struct kvm_hyp_iommu **out_iommu)
+{
+	int idx;
+	struct kvm_hyp_iommu *iommu;
+	struct kvm_hyp_iommu_domain *domains;
+
+	iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
+	if (!iommu)
+		return NULL;
+
+	if (domain_id >= iommu->nr_domains)
+		return NULL;
+	domain_id = array_index_nospec(domain_id, iommu->nr_domains);
+
+	idx = domain_id >> KVM_IOMMU_DOMAIN_ID_SPLIT;
+	domains = iommu->domains[idx];
+	if (!domains) {
+		domains = kvm_iommu_donate_page();
+		if (!domains)
+			return NULL;
+		iommu->domains[idx] = domains;
+	}
+
+	*out_iommu = iommu;
+	return &domains[domain_id & KVM_IOMMU_DOMAIN_ID_LEAF_MASK];
+}
+
+int kvm_iommu_alloc_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			   unsigned long pgd_hva)
+{
+	int ret = -EINVAL;
+	struct io_pgtable iopt;
+	struct kvm_hyp_iommu *iommu;
+	struct kvm_hyp_iommu_domain *domain;
+
+	hyp_spin_lock(&iommu_lock);
+	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	if (!domain)
+		goto out_unlock;
+
+	if (domain->refs)
+		goto out_unlock;
+
+	iopt = domain_to_iopt(iommu, domain, domain_id);
+	ret = kvm_iommu_ops.alloc_iopt(&iopt, pgd_hva);
+	if (ret)
+		goto out_unlock;
+
+	domain->refs = 1;
+	domain->pgd = iopt.pgd;
+out_unlock:
+	hyp_spin_unlock(&iommu_lock);
+	return ret;
+}
+
+int kvm_iommu_free_domain(pkvm_handle_t iommu_id, pkvm_handle_t domain_id)
+{
+	int ret = -EINVAL;
+	struct io_pgtable iopt;
+	struct kvm_hyp_iommu *iommu;
+	struct kvm_hyp_iommu_domain *domain;
+
+	hyp_spin_lock(&iommu_lock);
+	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	if (!domain)
+		goto out_unlock;
+
+	if (domain->refs != 1)
+		goto out_unlock;
+
+	iopt = domain_to_iopt(iommu, domain, domain_id);
+	ret = kvm_iommu_ops.free_iopt(&iopt);
+
+	memset(domain, 0, sizeof(*domain));
+
+out_unlock:
+	hyp_spin_unlock(&iommu_lock);
+	return ret;
+}
+
+int kvm_iommu_attach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			 u32 endpoint_id)
+{
+	int ret = -EINVAL;
+	struct kvm_hyp_iommu *iommu;
+	struct kvm_hyp_iommu_domain *domain;
+
+	hyp_spin_lock(&iommu_lock);
+	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	if (!domain || !domain->refs || domain->refs == UINT_MAX)
+		goto out_unlock;
+
+	ret = kvm_iommu_ops.attach_dev(iommu, domain_id, domain, endpoint_id);
+	if (ret)
+		goto out_unlock;
+
+	domain->refs++;
+out_unlock:
+	hyp_spin_unlock(&iommu_lock);
+	return ret;
+}
+
+int kvm_iommu_detach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			 u32 endpoint_id)
+{
+	int ret = -EINVAL;
+	struct kvm_hyp_iommu *iommu;
+	struct kvm_hyp_iommu_domain *domain;
+
+	hyp_spin_lock(&iommu_lock);
+	domain = handle_to_domain(iommu_id, domain_id, &iommu);
+	if (!domain || domain->refs <= 1)
+		goto out_unlock;
+
+	ret = kvm_iommu_ops.detach_dev(iommu, domain_id, domain, endpoint_id);
+	if (ret)
+		goto out_unlock;
+
+	domain->refs--;
+out_unlock:
+	hyp_spin_unlock(&iommu_lock);
+	return ret;
+}
+
+int kvm_iommu_init_device(struct kvm_hyp_iommu *iommu)
+{
+	void *domains;
+
+	domains = iommu->domains;
+	iommu->domains = kern_hyp_va(domains);
+	return pkvm_create_mappings(iommu->domains, iommu->domains +
+				    KVM_IOMMU_DOMAINS_ROOT_ENTRIES, PAGE_HYP);
+}
+
 int kvm_iommu_init(void)
 {
 	enum kvm_pgtable_prot prot;
 
+	hyp_spin_lock_init(&iommu_lock);
+
+	if (WARN_ON(!kvm_iommu_ops.get_iommu_by_id ||
+		    !kvm_iommu_ops.alloc_iopt ||
+		    !kvm_iommu_ops.free_iopt ||
+		    !kvm_iommu_ops.attach_dev ||
+		    !kvm_iommu_ops.detach_dev))
+		return -ENODEV;
+
 	/* The memcache is shared with the host */
 	prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_SHARED_OWNED);
 	return pkvm_create_mappings(kvm_hyp_iommu_memcaches,
-- 
2.39.0

