Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88B4223C7C
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026693; cv=none; b=EKPaI4GWX/dRoznAh9lTp5hrZzCsCGDHgE7czW8AROsgcuQGxe57Bqj5qjClYN1ocxyMgl/0aKupGaua0hEExv1RgJ6o2w7HacUZQE5TCdTw7bpLVwGp27ApEEzcl/F6UlZd6fAmx4fI8nFdavZ5bVgsPPhFsDDMdlIhvUjLmOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026693; c=relaxed/simple;
	bh=gp+CHgCT6MfjzlV3G7e67wFLwUFxHaGVgOQC7Dq+A54=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ptug+UBk3iokSPTcqVaT3r0gq8PBLhTkhP0Q8iL8lef9sFtWgcsCqpwr1kK3dh6xJPLYVdeO+ctadRWNoGgqav3GR0ivxejEmveTxQl5tEggxhM67WnDf0SctkM2PC7rFDqAPnv6tRxZWS/+uRKkydH/QXSlz4AO+kbBCY6HJNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3M//j0aq; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3M//j0aq"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361efc9d1fso8309585e9.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026690; x=1734631490; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fZxQMQu4cbyziwIooPRheQAiraNBUGRcC5SFKfDzOkk=;
        b=3M//j0aqyNEzRY0nQpvNwGTCZUur3F9giWkaIozYT5cf2ZvByc4N9SAawPf/ocnoLU
         m0BqKuPzNb4PK2DBgiDmslgeEC8b0xRMFPTmcR46VgVSXh3qmkfvIL5fWmRAVE5EYlRX
         gs7CJqHj+KI/ciEwH/5X7GclIp07vkhmgnt051+9YiTZm2FYdWk992PQEEtD6FgxB0bF
         cmnqNvAdd0qWYUP1r0PlKdNYuzc3l1m4chJzDq0IZPr5JHwLJ6qommOSmX5P0ujM08W9
         89bd96L5tHbuWH4dOW1jSKBdoP0+JD0a3lhBOqHwXQ5kYD5tTVUTcTKXiCafjMCFf/g6
         c3Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026690; x=1734631490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fZxQMQu4cbyziwIooPRheQAiraNBUGRcC5SFKfDzOkk=;
        b=wPDx1k6PdNWD4g+bWLu0kmLfP084fCP9OwEfF+TJhU1e72Sc+j5yrr2zWRA3+a8jOR
         ot5ZF0QPGt3qYGi+u/QSgPJehwfgtjB6sw+pTaadQ/lwSgyp47c9O5AfzfsG6T7crbRh
         izw5E/x/2b8dgM7Rdiy6vcZVUQPRkskkOdcpt4NyaisDYVFabqD/VOOibCk5Hv9JRb3J
         xLZUa+9SXsjb0pFPPpMQhyLmWX0+7ipWmKV22DS8voDtpl8/nLEPbv8AEMyE08m+qvgL
         200mrriww5xAuJHX7uJEKR3qmGsZFMYmcwzvwTWDmbgwgwFS+MpmXyC3biLcno2/46qT
         51Dw==
X-Forwarded-Encrypted: i=1; AJvYcCXLQyhbt6+/Yh8I4BiJTPwe0kq6RP58FUwM7yfnwI4lLMQc90GB1awO6bWpip9bG8QQMLY1ePY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxIuOh2UbfEKaxIaP/i/HwJyTcmALBvD/N32miS78a+/WO5HFRB
	Dnm3JBA405YDLbG2ag1AZ0uhNAtOzQdb7w32tZton0z/aG2tNcrdtK1DAgs08FKtGCyVUa0wJzf
	VpYwawzc+Bg==
X-Google-Smtp-Source: AGHT+IFzpfMVwcRrV2/gqjEcPWIIertEvfaFJMhjw3EeYh/NSeVQCIM7XVIoTxUlYOdKn5XnKjOATZ6q1zompA==
X-Received: from wmbay15.prod.google.com ([2002:a05:600c:1e0f:b0:434:ff52:1c7])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a011:b0:434:f623:a004 with SMTP id 5b1f17b1804b1-4361c3a157cmr72244495e9.16.1734026690208;
 Thu, 12 Dec 2024 10:04:50 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:27 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-4-smostafa@google.com>
Subject: [RFC PATCH v2 03/58] iommu/io-pgtable: Add configure() operation
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

Allow IOMMU drivers to create the io-pgtable configuration without
allocating any tables. This will be used by the SMMUv3-KVM driver to
initialize a config and pass it to KVM.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/io-pgtable-arm.c | 16 ++++++++++++++++
 drivers/iommu/io-pgtable.c     | 15 +++++++++++++++
 include/linux/io-pgtable.h     | 15 +++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 8d435a5bcd9a..e85866c90290 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -148,6 +148,13 @@ arm_64_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
 	return NULL;
 }
 
+static int arm_64_lpae_configure_s1(struct io_pgtable_cfg *cfg)
+{
+	struct arm_lpae_io_pgtable data = {};
+
+	return arm_lpae_init_pgtable_s1(cfg, &data);
+}
+
 static struct io_pgtable *
 arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
 {
@@ -178,6 +185,13 @@ arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
 	return NULL;
 }
 
+static int arm_64_lpae_configure_s2(struct io_pgtable_cfg *cfg)
+{
+	struct arm_lpae_io_pgtable data = {};
+
+	return arm_lpae_init_pgtable_s2(cfg, &data);
+}
+
 static struct io_pgtable *
 arm_32_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
 {
@@ -264,12 +278,14 @@ struct io_pgtable_init_fns io_pgtable_arm_64_lpae_s1_init_fns = {
 	.caps	= IO_PGTABLE_CAP_CUSTOM_ALLOCATOR,
 	.alloc	= arm_64_lpae_alloc_pgtable_s1,
 	.free	= arm_lpae_free_pgtable,
+	.configure	= arm_64_lpae_configure_s1,
 };
 
 struct io_pgtable_init_fns io_pgtable_arm_64_lpae_s2_init_fns = {
 	.caps	= IO_PGTABLE_CAP_CUSTOM_ALLOCATOR,
 	.alloc	= arm_64_lpae_alloc_pgtable_s2,
 	.free	= arm_lpae_free_pgtable,
+	.configure	= arm_64_lpae_configure_s2,
 };
 
 struct io_pgtable_init_fns io_pgtable_arm_32_lpae_s1_init_fns = {
diff --git a/drivers/iommu/io-pgtable.c b/drivers/iommu/io-pgtable.c
index 8841c1487f00..be65f70ec2a6 100644
--- a/drivers/iommu/io-pgtable.c
+++ b/drivers/iommu/io-pgtable.c
@@ -99,3 +99,18 @@ void free_io_pgtable_ops(struct io_pgtable_ops *ops)
 	io_pgtable_init_table[iop->fmt]->free(iop);
 }
 EXPORT_SYMBOL_GPL(free_io_pgtable_ops);
+
+int io_pgtable_configure(struct io_pgtable_cfg *cfg)
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
+	return fns->configure(cfg);
+}
+EXPORT_SYMBOL_GPL(io_pgtable_configure);
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index d7bfbf351975..f789234c703b 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -49,6 +49,7 @@ struct iommu_flush_ops {
 /**
  * struct io_pgtable_cfg - Configuration data for a set of page tables.
  *
+ * @fmt:	       Format used for these page tables
  * @quirks:        A bitmap of hardware quirks that require some special
  *                 action by the low-level page table allocator.
  * @pgsize_bitmap: A bitmap of page sizes supported by this set of page
@@ -62,6 +63,7 @@ struct iommu_flush_ops {
  *                 page table walker.
  */
 struct io_pgtable_cfg {
+	enum io_pgtable_fmt		fmt;
 	/*
 	 * IO_PGTABLE_QUIRK_ARM_NS: (ARM formats) Set NS and NSTABLE bits in
 	 *	stage 1 PTEs, for hardware which insists on validating them
@@ -241,6 +243,17 @@ struct io_pgtable_ops *alloc_io_pgtable_ops(enum io_pgtable_fmt fmt,
  */
 void free_io_pgtable_ops(struct io_pgtable_ops *ops);
 
+/**
+ * io_pgtable_configure - Create page table config
+ *
+ * @cfg:	The page table configuration.
+ *
+ * Initialize @cfg in the same way as alloc_io_pgtable_ops(), without allocating
+ * anything.
+ *
+ * Not all io_pgtable drivers implement this operation.
+ */
+int io_pgtable_configure(struct io_pgtable_cfg *cfg);
 
 /*
  * Internal structures for page table allocator implementations.
@@ -301,11 +314,13 @@ enum io_pgtable_caps {
  *
  * @alloc: Allocate a set of page tables described by cfg.
  * @free:  Free the page tables associated with iop.
+ * @configure: Create the configuration without allocating anything. Optional.
  * @caps:  Combination of @io_pgtable_caps flags encoding the backend capabilities.
  */
 struct io_pgtable_init_fns {
 	struct io_pgtable *(*alloc)(struct io_pgtable_cfg *cfg, void *cookie);
 	void (*free)(struct io_pgtable *iop);
+	int (*configure)(struct io_pgtable_cfg *cfg);
 	u32 caps;
 };
 
-- 
2.47.0.338.g60cca15819-goog

