Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2446F2590
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:23 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id bk16so17209706wrb.11
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eAC1lP6EVsxQ6cWZKQ+kd+wU7MPt1TmTk8/S67gp2M0=;
        b=w4vJzCvawMc999TOnrJV0tQeBCtOsQRWvV57bojsKb9lEtYGP8IGDHzH0S2aPhAj/I
         udFzlNkNn8lPVdxLZutwCEqnCwpLVXtl+K0pkZtHFmZGDdOKsUEg6VCCpkjitLIjrofB
         Y7AJ9gaJF6cOP3ry9E+TBd84XkGGHDpJsG/9RLCwoCQXDjzwAkviNizOIUZ51vQfyYDV
         SLJ0SPIXHHsjc++GMa5+6adQEbEISPWv4KYsYpRGyZePuV1tjsJQxgsUCIMd6vi+2/JK
         ATFtIXFy9NNxBpWc5cgRBp2efiJfSQc88/62AnpEayqWkwUdi2HboEjp0Fo+9MIt0zW6
         EhCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eAC1lP6EVsxQ6cWZKQ+kd+wU7MPt1TmTk8/S67gp2M0=;
        b=ovQNkqLC6OufWm5924dc9EG+87CBfqrvnlE9fD9d4GZgFYE6+UB95v5uqaSextoLXI
         Op5A6wpndbFEt+mOueAREmqf7N3o2fKKugMuLmXdF8bMVEpf8pg0Bync6Ot8kkPwnIrB
         4jtnSkBbEbIu4UatS6m9ZhGTkC9eqy4a/7SQHAI7X1FMdbqe082valJMoGlgIh5pQAqJ
         Le7+k11bICtGjOpB5nvkuafjEN4utE/12ffwAf8eS04X92BdRRaaILKsogPDjrWhjjx9
         +5e5eL1oLUaox4vI2KO3erAy2edpt0s59xRdQV3qwwfP4JIKP18uWEiB0vyy8VPvdKrz
         XNDQ==
X-Gm-Message-State: AO0yUKXbyzTEMHEND3j+TiFjMfV/hbe+hqtoD+DmFeSZdukTq6XGcfKX
	/cv9lvJBn8M+cTAsozI6/HdHWw==
X-Google-Smtp-Source: AK7set8lcZHDDrM2/NwAgTEvSykoOX8z0G7efK9YIQNKtEjePM8qYTEccwXQhcVFZQ/ZP3uvTMGjvw==
X-Received: by 2002:a05:6000:1449:b0:2bd:d34e:5355 with SMTP id v9-20020a056000144900b002bdd34e5355mr3116261wrx.20.1675256361465;
        Wed, 01 Feb 2023 04:59:21 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:21 -0800 (PST)
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
Subject: [RFC PATCH 04/45] iommu/io-pgtable: Add configure() operation
Date: Wed,  1 Feb 2023 12:52:48 +0000
Message-Id: <20230201125328.2186498-5-jean-philippe@linaro.org>
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

Allow IOMMU drivers to create the io-pgtable configuration without
allocating any tables. This will be used by the SMMUv3-KVM driver to
initialize a config and pass it to KVM.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/linux/io-pgtable.h     | 14 +++++++++++
 drivers/iommu/io-pgtable-arm.c | 46 ++++++++++++++++++++++++++--------
 drivers/iommu/io-pgtable.c     | 15 +++++++++++
 3 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index 1b0c26241a78..ee6484d7a5e0 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -191,6 +191,18 @@ struct io_pgtable_ops *alloc_io_pgtable_ops(struct io_pgtable_cfg *cfg,
  */
 void free_io_pgtable_ops(struct io_pgtable_ops *ops);
 
+/**
+ * io_pgtable_configure - Create page table config
+ *
+ * @cfg:	The page table configuration.
+ * @pgd_size:	On success, size of the top-level table in bytes.
+ *
+ * Initialize @cfg in the same way as alloc_io_pgtable_ops(), without allocating
+ * anything.
+ *
+ * Not all io_pgtable drivers implement this operation.
+ */
+int io_pgtable_configure(struct io_pgtable_cfg *cfg, size_t *pgd_size);
 
 /*
  * Internal structures for page table allocator implementations.
@@ -241,10 +253,12 @@ io_pgtable_tlb_add_page(struct io_pgtable *iop,
  *
  * @alloc: Allocate a set of page tables described by cfg.
  * @free:  Free the page tables associated with iop.
+ * @configure: Create the configuration without allocating anything. Optional.
  */
 struct io_pgtable_init_fns {
 	struct io_pgtable *(*alloc)(struct io_pgtable_cfg *cfg, void *cookie);
 	void (*free)(struct io_pgtable *iop);
+	int (*configure)(struct io_pgtable_cfg *cfg, size_t *pgd_size);
 };
 
 extern struct io_pgtable_init_fns io_pgtable_arm_32_lpae_s1_init_fns;
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index b76b903400de..c412500efadf 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -118,6 +118,18 @@ arm_64_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
 	return NULL;
 }
 
+static int arm_64_lpae_configure_s1(struct io_pgtable_cfg *cfg, size_t *pgd_size)
+{
+	int ret;
+	struct arm_lpae_io_pgtable data = {};
+
+	ret = arm_lpae_init_pgtable_s1(cfg, &data);
+	if (ret)
+		return ret;
+	*pgd_size = sizeof(arm_lpae_iopte) << data.pgd_bits;
+	return 0;
+}
+
 static struct io_pgtable *
 arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
 {
@@ -148,6 +160,18 @@ arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
 	return NULL;
 }
 
+static int arm_64_lpae_configure_s2(struct io_pgtable_cfg *cfg, size_t *pgd_size)
+{
+	int ret;
+	struct arm_lpae_io_pgtable data = {};
+
+	ret = arm_lpae_init_pgtable_s2(cfg, &data);
+	if (ret)
+		return ret;
+	*pgd_size = sizeof(arm_lpae_iopte) << data.pgd_bits;
+	return 0;
+}
+
 static struct io_pgtable *
 arm_32_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
 {
@@ -231,28 +255,30 @@ arm_mali_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 }
 
 struct io_pgtable_init_fns io_pgtable_arm_64_lpae_s1_init_fns = {
-	.alloc	= arm_64_lpae_alloc_pgtable_s1,
-	.free	= arm_lpae_free_pgtable,
+	.alloc		= arm_64_lpae_alloc_pgtable_s1,
+	.free		= arm_lpae_free_pgtable,
+	.configure	= arm_64_lpae_configure_s1,
 };
 
 struct io_pgtable_init_fns io_pgtable_arm_64_lpae_s2_init_fns = {
-	.alloc	= arm_64_lpae_alloc_pgtable_s2,
-	.free	= arm_lpae_free_pgtable,
+	.alloc		= arm_64_lpae_alloc_pgtable_s2,
+	.free		= arm_lpae_free_pgtable,
+	.configure	= arm_64_lpae_configure_s2,
 };
 
 struct io_pgtable_init_fns io_pgtable_arm_32_lpae_s1_init_fns = {
-	.alloc	= arm_32_lpae_alloc_pgtable_s1,
-	.free	= arm_lpae_free_pgtable,
+	.alloc		= arm_32_lpae_alloc_pgtable_s1,
+	.free		= arm_lpae_free_pgtable,
 };
 
 struct io_pgtable_init_fns io_pgtable_arm_32_lpae_s2_init_fns = {
-	.alloc	= arm_32_lpae_alloc_pgtable_s2,
-	.free	= arm_lpae_free_pgtable,
+	.alloc		= arm_32_lpae_alloc_pgtable_s2,
+	.free		= arm_lpae_free_pgtable,
 };
 
 struct io_pgtable_init_fns io_pgtable_arm_mali_lpae_init_fns = {
-	.alloc	= arm_mali_lpae_alloc_pgtable,
-	.free	= arm_lpae_free_pgtable,
+	.alloc		= arm_mali_lpae_alloc_pgtable,
+	.free		= arm_lpae_free_pgtable,
 };
 
 #ifdef CONFIG_IOMMU_IO_PGTABLE_LPAE_SELFTEST
diff --git a/drivers/iommu/io-pgtable.c b/drivers/iommu/io-pgtable.c
index 79e459f95012..2aba691db1da 100644
--- a/drivers/iommu/io-pgtable.c
+++ b/drivers/iommu/io-pgtable.c
@@ -74,3 +74,18 @@ void free_io_pgtable_ops(struct io_pgtable_ops *ops)
 	io_pgtable_init_table[iop->cfg.fmt]->free(iop);
 }
 EXPORT_SYMBOL_GPL(free_io_pgtable_ops);
+
+int io_pgtable_configure(struct io_pgtable_cfg *cfg, size_t *pgd_size)
+{
+	const struct io_pgtable_init_fns *fns;
+
+	if (cfg->fmt >= IO_PGTABLE_NUM_FMTS)
+		return -EINVAL;
+
+	fns = io_pgtable_init_table[cfg->fmt];
+	if (!fns || !fns->configure)
+		return -EOPNOTSUPP;
+
+	return fns->configure(cfg, pgd_size);
+}
+EXPORT_SYMBOL_GPL(io_pgtable_configure);
-- 
2.39.0

