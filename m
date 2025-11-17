Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CAF3321BC
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405316; cv=none; b=Fz0UHtQBxtsvWtETQlTqIaZ4WdbEJqHAS1AFghlFk/urnWj6EuUJUfijkTRdxlK5cHtHQOIGWkLDy4y7WdddN+F5xe8jh4tyX8KXTAO0fZnz5zL3e22y8T5oMa9yxZeQVcnmcwykVdqUpuYT3bJsUHK0aiR/127uTe7WME14/2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405316; c=relaxed/simple;
	bh=Vclyp15KhjSu44V08/F6eiOMM27jme7DCCOu/Buxcyw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VxvdBXz8T25NgTQVzW07G2/WyI6y3o9EsHB1hRQ0DtIgLwD5Ufx2I8BB8alBMOFtuV8z6K4/x1AisnMmi+SXrpZbB8rH8+E+oBqcSSMGH3XrnDSzAA/lmilbQJ4ezA76FxVVUrwb2yAQoywYVKUlEua8+0+4Xj1gnZeawYlA7uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jt1+QiM7; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jt1+QiM7"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477a11d9f89so1924065e9.3
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405312; x=1764010112; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fa/YvcJ5tNlhBRUyXop3BZTS83Exwp3fcbT0/9k9OOI=;
        b=jt1+QiM7D44D4v72kjyBshAx+UNiC+OUx3KXyhwzY1oObYSum/iijasBHTRM5zJ685
         6cWWAD2pNMQNSDORQ9CTSamJ1NMbj7kndHIBIkaQ+LcWm1pFguKUPVj7w3dmUGcvOHDq
         rutCLCd5E0NUSDhmPDOWFwDRAYJmWvPlm9Ais4xbcnfCCuTGylQmhLXxyjxSaNSDMzjl
         cldOnRwaP8MyY8FthTE/f25F/gP5plvovrtUQHuSKAZoIfyOOyIJGw1eYQDzCcRIxxm7
         TCcWIubk192ZAxoRRebNi9rpw65r+wF1oK3M20wbUQS8FxS0KCe3akGNw01WHrA6I17q
         aWDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405312; x=1764010112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fa/YvcJ5tNlhBRUyXop3BZTS83Exwp3fcbT0/9k9OOI=;
        b=ix0zaMJUwI9ulLNY3NrzGaIRuDl3oM7I3TnHRdXcWkqI9ACUfR92lAvmRZpsvdFUoL
         NsKsmSpH9xOR2JRBFOzme3qoqAMgzfca/RPzb4/4zNHFRl2y9bmVcBM909q4ddvAoGS3
         Jj3qb9zHZrAG1iPiTOKVp+YyK+Hkz/EQ+z5SyZRtGf3UWCIQCIcAtRKZ+1LnWpJYdjIq
         VsLH6aYQCl/snfenl0POSx5pOjGf1U9JAHbWNdL37UB1MyzQNDcGxjor++COwteuMO/+
         d2YhOrhO1I4WmcxpXMyk0bjI+cYLR3NViKumyme84+FLa9NKZvq5B/vaR8YodmUB8u+U
         TYCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWp6j0bD8HUQaPdkU3OJS3Fae9aWqvrnmOBoMqzbwVkHQQDea+MBYQNG3XVD1qNw2RlQScYAIM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyv0ICFe/CmSsxP7+KxzJcUNoPTyCh5DMxi7UjltuZaDlzeRuJC
	FeC5dPyu/PWcH+LM9x4ZWuvBzhLPeITMHWhT08mUlJRx4UEeNDo6DRp6+0nsaEZ7DXdEXylvOAy
	3e+N6RiRziryNwA==
X-Google-Smtp-Source: AGHT+IFGfjLxAYeewB8UtexvjesLcgKTw4qvbkwbmE1jIA9t3QqiMcAfRLlAcExJxKbgHrtdx0lO1xzwSnlrcA==
X-Received: from wmgf6.prod.google.com ([2002:a05:600c:1546:b0:477:9fba:50e4])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f87:b0:471:9da:524c with SMTP id 5b1f17b1804b1-4778fe69a76mr122513705e9.12.1763405312411;
 Mon, 17 Nov 2025 10:48:32 -0800 (PST)
Date: Mon, 17 Nov 2025 18:47:53 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-7-smostafa@google.com>
Subject: [PATCH v5 06/27] iommu/arm-smmu-v3: Move TLB range invalidation into
 common code
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Range TLB invalidation has a very specific algorithm, instead of
re-writing it for the hypervisor.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 69 ++++--------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 79 +++++++++++++++++++++
 2 files changed, 92 insertions(+), 56 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 1497ffcd4555..f6c3eeb4ecea 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2105,74 +2105,31 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
 }
 
+static void __arm_smmu_cmdq_batch_add(void *__opaque,
+				      struct arm_smmu_cmdq_batch *cmds,
+				      struct arm_smmu_cmdq_ent *cmd)
+{
+	struct arm_smmu_device *smmu = (struct arm_smmu_device *)__opaque;
+
+	arm_smmu_cmdq_batch_add(smmu, cmds, cmd);
+}
+
 static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
 				     unsigned long iova, size_t size,
 				     size_t granule,
 				     struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
-	unsigned long end = iova + size, num_pages = 0, tg = 0;
-	size_t inv_range = granule;
 	struct arm_smmu_cmdq_batch cmds;
 
 	if (!size)
 		return;
 
-	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		/* Get the leaf page size */
-		tg = __ffs(smmu_domain->domain.pgsize_bitmap);
-
-		num_pages = size >> tg;
-
-		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
-		cmd->tlbi.tg = (tg - 10) / 2;
-
-		/*
-		 * Determine what level the granule is at. For non-leaf, both
-		 * io-pgtable and SVA pass a nominal last-level granule because
-		 * they don't know what level(s) actually apply, so ignore that
-		 * and leave TTL=0. However for various errata reasons we still
-		 * want to use a range command, so avoid the SVA corner case
-		 * where both scale and num could be 0 as well.
-		 */
-		if (cmd->tlbi.leaf)
-			cmd->tlbi.ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
-		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
-			num_pages++;
-	}
-
 	arm_smmu_cmdq_batch_init(smmu, &cmds, cmd);
-
-	while (iova < end) {
-		if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-			/*
-			 * On each iteration of the loop, the range is 5 bits
-			 * worth of the aligned size remaining.
-			 * The range in pages is:
-			 *
-			 * range = (num_pages & (0x1f << __ffs(num_pages)))
-			 */
-			unsigned long scale, num;
-
-			/* Determine the power of 2 multiple number of pages */
-			scale = __ffs(num_pages);
-			cmd->tlbi.scale = scale;
-
-			/* Determine how many chunks of 2^scale size we have */
-			num = (num_pages >> scale) & CMDQ_TLBI_RANGE_NUM_MAX;
-			cmd->tlbi.num = num - 1;
-
-			/* range is num * 2^scale * pgsize */
-			inv_range = num << (scale + tg);
-
-			/* Clear out the lower order bits for the next iteration */
-			num_pages -= num << scale;
-		}
-
-		cmd->tlbi.addr = iova;
-		arm_smmu_cmdq_batch_add(smmu, &cmds, cmd);
-		iova += inv_range;
-	}
+	arm_smmu_tlb_inv_build(cmd, iova, size, granule,
+			       smmu_domain->domain.pgsize_bitmap,
+			       smmu->features & ARM_SMMU_FEAT_RANGE_INV,
+			       smmu, __arm_smmu_cmdq_batch_add, &cmds);
 	arm_smmu_cmdq_batch_submit(smmu, &cmds);
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4aaf93945ee3..4a59b4d39c4f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1072,6 +1072,85 @@ static inline void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
 	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
 
+/**
+ * arm_smmu_tlb_inv_build - Create a range invalidation command
+ * @cmd: Base command initialized with OPCODE (S1, S2..), vmid and asid.
+ * @iova: Start IOVA to invalidate
+ * @size: Size of range
+ * @granule: Granule of invalidation
+ * @pgsize_bitmap: Page size bit map of the page table.
+ * @is_range: Use range invalidation commands.
+ * @opaque: Pointer to pass to add_cmd
+ * @add_cmd: Function to send/batch the invalidation command
+ * @cmds: Incase of batching, it includes the pointer to the batch
+ */
+static inline void arm_smmu_tlb_inv_build(struct arm_smmu_cmdq_ent *cmd,
+					  unsigned long iova, size_t size,
+					  size_t granule, unsigned long pgsize_bitmap,
+					  bool is_range, void *opaque,
+					  void (*add_cmd)(void *_opaque,
+							  struct arm_smmu_cmdq_batch *cmds,
+							  struct arm_smmu_cmdq_ent *cmd),
+					  struct arm_smmu_cmdq_batch *cmds)
+{
+	unsigned long end = iova + size, num_pages = 0, tg = 0;
+	size_t inv_range = granule;
+
+	if (is_range) {
+		/* Get the leaf page size */
+		tg = __ffs(pgsize_bitmap);
+
+		num_pages = size >> tg;
+
+		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
+		cmd->tlbi.tg = (tg - 10) / 2;
+
+		/*
+		 * Determine what level the granule is at. For non-leaf, both
+		 * io-pgtable and SVA pass a nominal last-level granule because
+		 * they don't know what level(s) actually apply, so ignore that
+		 * and leave TTL=0. However for various errata reasons we still
+		 * want to use a range command, so avoid the SVA corner case
+		 * where both scale and num could be 0 as well.
+		 */
+		if (cmd->tlbi.leaf)
+			cmd->tlbi.ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
+		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
+			num_pages++;
+	}
+
+	while (iova < end) {
+		if (is_range) {
+			/*
+			 * On each iteration of the loop, the range is 5 bits
+			 * worth of the aligned size remaining.
+			 * The range in pages is:
+			 *
+			 * range = (num_pages & (0x1f << __ffs(num_pages)))
+			 */
+			unsigned long scale, num;
+
+			/* Determine the power of 2 multiple number of pages */
+			scale = __ffs(num_pages);
+			cmd->tlbi.scale = scale;
+
+			/* Determine how many chunks of 2^scale size we have */
+			num = (num_pages >> scale) & CMDQ_TLBI_RANGE_NUM_MAX;
+			cmd->tlbi.num = num - 1;
+
+			/* range is num * 2^scale * pgsize */
+			inv_range = num << (scale + tg);
+
+			/* Clear out the lower order bits for the next iteration */
+			num_pages -= num << scale;
+		}
+
+		cmd->tlbi.addr = iova;
+		add_cmd(opaque, cmds, cmd);
+		iova += inv_range;
+	}
+}
+
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
 void arm_smmu_sva_notifier_synchronize(void);
-- 
2.52.0.rc1.455.g30608eb744-goog

