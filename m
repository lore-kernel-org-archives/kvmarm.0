Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A457639E19A
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634405; cv=none; b=hkk7p7nFuO0wM4D7ABCjyReINabE3EbaPbu1n5EcxgxOspoLnvR0DptvnnFfWmeMY4FncmjAjIIhqrqp7FKReh63IuS48IE3axYclDcMq3cWve7TJumraMVcMYhh3+Dedu5AoXAI2u4Rh9oiI1PUPZa9OU7kEDwRIdsocoI/K3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634405; c=relaxed/simple;
	bh=15+QeiFyLvHiPcCIubc5fSnh88MpTHwIauK/sgpB9Kk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B2+B6mN+n/sNEghQI1d1gooMx4hjJxz5BmvVr7gUMhBZONsraNVeniR1gfwCzizb7jgcRXP37YuteePRlJOP5oUOhT2fm1UI7K+zyIA2SHG24P2Kgygr/5dWh8+1bPI+fAvRvGnvJBbByCBs5X6Uauj5OdSr1vrdB/+LQiHorag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jGlA7yGv; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jGlA7yGv"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48a589c7879so21429645e9.1
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634402; x=1778239202; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cn3lch7CcipEUf/hsRSFMjJhdn+CahR9BLaY3vu1ZIo=;
        b=jGlA7yGv6hBAxKCT8vcGdx7HSZE/B/JuR78oav/zkZdFO+KfxIL4Zou8XU6+adKSBy
         +lRSoro2P5BGhADZ/lOuDXh4X/Ol9B7VUH5waPbOPJc3HIiNwpLP6du4zhpxVNSP0pwf
         WJyKOqPBvRN8dzQrF9Hs+WjE89oP84m5LBb8ZOrUHlOlhYkA3en31r9EcuqmNGmLZ6Yo
         X4Sg5ymUErjs0JZZ+2HCdzX7LziIdGSYOPiSGAm3Ug0de9WIxYSh1q2D6JCIAZGnBAb7
         bg0/BhISKDiOJoqflL67o7it7b2esUoVpMq7tCC91FChvcE3a8MFFrTno+NLyJvYB9tI
         iKuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634402; x=1778239202;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cn3lch7CcipEUf/hsRSFMjJhdn+CahR9BLaY3vu1ZIo=;
        b=ZPskG/GlSh2YKZx9rUy5H3DeLOSvsrTmf85W3IhBOxcML9EVnC0rB7YEJ6msyUBNaP
         lfr3JyxJ7HblQc7HuKbXl9z/zY0/WTuzJgBEgmpBb0ciZ29F9gvcVF/XC/HM3bpf32WA
         IYGJdebVN+TSWzlo+gma+h/djwiSJXM00so9mAE/fdntY97o7srn1r48T2EOBmU3qvvR
         YsDTjW1NUHMmBlaV+N2ly55S9bQ48ULN41KJ7Wgi4865tvtB4faSV5XOISLnbs/nne+8
         1YB2FcWlQpYNfN/0qyRqib9oKdQnDdTyXkULnwyGPJfkETXdRYNlcMeKP0fwu03gWi9F
         GrRA==
X-Forwarded-Encrypted: i=1; AFNElJ8nr2jwGxD+NfH2K1R5AbqlM2iFpR8U31oOw9p1fhLBdE1lGs8Pja1viUsxLGYPNZIVt3Kg7lI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFOI+jeR7eclqueoBwBbjm2XwV3Dw5mzUQlZMXbazerwri0IQi
	GMY5xZTtWuuizyIAbBpet1pAY2/SEDtdOXrt69vsL/zRhKKj5nXekbMwcnskiN1FgOzs6ZCuica
	3WZq1kT/5VNAWZA==
X-Received: from wrna11.prod.google.com ([2002:adf:e5cb:0:b0:449:2f8e:2b32])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:310e:b0:48a:5821:6006 with SMTP id 5b1f17b1804b1-48a93e9bb92mr17243045e9.4.1777634401907;
 Fri, 01 May 2026 04:20:01 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:06 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-5-smostafa@google.com>
Subject: [PATCH v6 04/25] iommu/arm-smmu-v3: Move TLB range invalidation into
 common code
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	mark.rutland@arm.com, qperret@google.com, tabba@google.com, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Range TLB invalidation has a very specific algorithm. Instead of
re-writing it for the hypervisor, move it to a function that can
be re-used.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 65 ++++--------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 76 +++++++++++++++++++++
 2 files changed, 88 insertions(+), 53 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index cb64f88989f0..c22832d26495 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2362,68 +2362,27 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_domain_inv(smmu_domain);
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
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmdq_ent *cmd,
 					  unsigned long iova, size_t size,
 					  size_t granule, size_t pgsize)
 {
-	unsigned long end = iova + size, num_pages = 0, tg = pgsize;
-	size_t inv_range = granule;
-
 	if (WARN_ON_ONCE(!size))
 		return;
 
-	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
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
-		arm_smmu_cmdq_batch_add(smmu, cmds, cmd);
-		iova += inv_range;
-	}
+	arm_smmu_tlb_inv_build(cmd, iova, size, granule,
+			       pgsize, smmu->features & ARM_SMMU_FEAT_RANGE_INV,
+			       smmu, __arm_smmu_cmdq_batch_add, cmds);
 }
 
 static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 9b8c5fb7282b..7be41dbe5aaa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1204,6 +1204,82 @@ static inline void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
 	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
 
+/**
+ * arm_smmu_tlb_inv_build - Create a range invalidation command
+ * @cmd: Base command initialized with OPCODE (S1, S2..), vmid and asid
+ * @iova: Start IOVA to invalidate
+ * @size: Size of range
+ * @granule: Granule of invalidation
+ * @pgsize: Page size of the invalidation
+ * @is_range: Use range invalidation commands
+ * @opaque: Pointer to pass to add_cmd
+ * @add_cmd: Function to send/batch the invalidation command
+ * @cmds: Incase of batching, it includes the pointer to the batch
+ */
+static inline void arm_smmu_tlb_inv_build(struct arm_smmu_cmdq_ent *cmd,
+					  unsigned long iova, size_t size,
+					  size_t granule, unsigned long pgsize,
+					  bool is_range, void *opaque,
+					  void (*add_cmd)(void *_opaque,
+							  struct arm_smmu_cmdq_batch *cmds,
+							  struct arm_smmu_cmdq_ent *cmd),
+					  struct arm_smmu_cmdq_batch *cmds)
+{
+	unsigned long end = iova + size, num_pages = 0, tg = pgsize;
+	size_t inv_range = granule;
+
+	if (is_range) {
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
2.54.0.545.g6539524ca2-goog

