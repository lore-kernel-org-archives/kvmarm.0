Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153B544CF2C
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116762; cv=none; b=TF4qefdqeO9tbcNvnKekpQJboBCSSbOgoiOGwCxpMvt8OJtgjxo4DWJD8vh/7yZdscd+Kv/N9N6Py8Bc9SLIf3g1fkyNzxJR3N25yWiFQTYYsJlktfYxp+ZGKXELx4pT0owMTyh3JY3jz28I0ic9rUPVpu4lzy9/6GN62ad8/vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116762; c=relaxed/simple;
	bh=1nwreBOIoo8Nq3x/9cqsrE39IlPY4nM+9QYDUvVAOnY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LQQmTD60T1LjaX+YEGOr8NuDwmdFstXWJlHGRYfCi1Cwa83u+8Uhd5D+uLG5P95HJLbCwUGxm+YbB2UYjSrcWaCZFYm9lV86c4G1opgVHpaDgKIZNWjxH0Ub7SxV+m8GGT2sZQv4QDtCNqe6uW5kmIvlwBkVuyZAhtr/htzVUoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rJu9F3Ya; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rJu9F3Ya"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4744b72f90bso2892887f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116758; x=1784721558; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=116XGPIsH3uc1TP/YR0VtloeUIWM18cD/kEPtzKIUwA=;
        b=rJu9F3Ya26gcyKVjlvHNIRpfPPr0H6qBsQGWhzRsQt2MvnXIQKsmZLJFdU/sUVSFA0
         4NkLhIsl8aWI0oLC7ls0yscz6OBsLzofMTMmS5u8D7Yu8ctWtwQo2EL2eGzI6h3DUjnq
         QvNEt+VrcIi2wDF2P4q9c0b8Tw8O6y8pEi4eXyRChk/OIL5aZd1+9N8+dWCf65226b+l
         m7vjxfl4wwFjBl74X7oAztb7XVaF8fOa5wKxj1hXvYwgka4oSMRozvD4gyLX57KLrSo3
         Pf2d5arK+Xi4AsYQFlITG5zu2+hzsCiTeE0oNVdQzu9Oi1fAu3wrdGQ+lkG7d3citsSC
         MG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116758; x=1784721558;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=116XGPIsH3uc1TP/YR0VtloeUIWM18cD/kEPtzKIUwA=;
        b=Lh5f4WBfyS3o+nroSVklHDGMsWZbOcyU6w+hcXP7U1+Jag1JD80swl/ZYT9TEFeKy2
         Qr44Y8C28fATA8WT6szZfmynZKVGHZT6A3yZJSQ18E7Xsl6IHEvARkBego5WOCqNGRoq
         V8+eQJKjLZMuzjA+zx/DrrUXljy5zQfRp0ayIpWUukfS+uHTlfTEq0AbTcs+ZlNDGrFT
         rJ2MfgQvaw7EjZq9d9dP92eTJcgzvVVHTS/7Dwp2usckdndcoXV8hLA1193iDIkbQM4y
         0RhKTSBjrMU6WnhUolvI+J3fg8ds2PEpucv/NWnky7x0cOzfU5ZyO1Q3FDmlNTObPxyd
         vVqQ==
X-Forwarded-Encrypted: i=1; AHgh+RrKHfHZxfV46j/CtaTrCOwpX55QjAfRTguq0EyLPX0t1Eyiu9zH8X2MmG4soswmiC0J1v2H6pY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwmoCFgTSnwv+Uw0L2EAwdFZlJ9WSJG0iMGwjmiVzrNoSEXNLoA
	WnRgrzB6ODyrAbhRoxwXf1KvRFNbZ/bjkOgTUnKaoE3onjBtxEqzkQwTGsqPTNTFNei8I+GnNGH
	YDuAgDyi5AHiZHQ==
X-Received: from wmap7.prod.google.com ([2002:a7b:cc87:0:b0:487:3739:c5c4])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:108:20b0:495:401d:9f4f with SMTP id 5b1f17b1804b1-495401da1a5mr2255395e9.25.1784116757928;
 Wed, 15 Jul 2026 04:59:17 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:58:45 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-5-smostafa@google.com>
Subject: [PATCH v7 04/24] iommu/arm-smmu-v3: Move TLB range invalidation into
 common code
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Range TLB invalidation has a very specific algorithm. Instead of
re-writing it for the hypervisor, move it to a function that can
be re-used.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 79 +++---------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 89 +++++++++++++++++++++
 2 files changed, 102 insertions(+), 66 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2a2289d4a3f3..cd17a3255312 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2336,81 +2336,28 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_domain_inv(smmu_domain);
 }
 
+static void __arm_smmu_cmdq_batch_add(void *__opaque,
+				      struct arm_smmu_cmdq_batch *cmds,
+				      struct arm_smmu_cmd *cmd)
+{
+	struct arm_smmu_device *smmu = (struct arm_smmu_device *)__opaque;
+
+	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
+}
+
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd, bool leaf,
 					  unsigned long iova, size_t size,
 					  size_t granule, size_t pgsize)
 {
-	unsigned long end = iova + size, num_pages = 0, tg = pgsize;
-	u64 orig_data0 = cmd->data[0];
-	size_t inv_range = granule;
-	u8 ttl = 0, tg_enc = 0;
-
 	if (WARN_ON_ONCE(!size))
 		return;
 
-	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		num_pages = size >> tg;
-
-		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
-		tg_enc = (tg - 10) / 2;
-
-		/*
-		 * Determine what level the granule is at. For non-leaf, both
-		 * io-pgtable and SVA pass a nominal last-level granule because
-		 * they don't know what level(s) actually apply, so ignore that
-		 * and leave TTL=0. However for various errata reasons we still
-		 * want to use a range command, so avoid the SVA corner case
-		 * where both scale and num could be 0 as well.
-		 */
-		if (leaf)
-			ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
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
-
-			/* Determine how many chunks of 2^scale size we have */
-			num = (num_pages >> scale) & CMDQ_TLBI_RANGE_NUM_MAX;
-
-			cmd->data[0] = orig_data0 |
-				FIELD_PREP(CMDQ_TLBI_0_NUM, num - 1) |
-				FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
-
-			/* range is num * 2^scale * pgsize */
-			inv_range = num << (scale + tg);
-
-			/* Clear out the lower order bits for the next iteration */
-			num_pages -= num << scale;
-		}
-
-		/*
-		 * IPA has fewer bits than VA, but they are reserved in the
-		 * command and something would be very broken if iova had them
-		 * set.
-		 */
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
-			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
-			       (iova & ~GENMASK_U64(11, 0));
-
-		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-		iova += inv_range;
-	}
+	arm_smmu_tlb_inv_build(cmd, iova, size, granule, pgsize,
+			       smmu->features & ARM_SMMU_FEAT_RANGE_INV,
+			       smmu, leaf, __arm_smmu_cmdq_batch_add,
+			       cmds);
 }
 
 static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e93489841ec7..494e55a2dc34 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1272,6 +1272,95 @@ static inline void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
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
+ * @leaf: Is leaf invalidation
+ * @add_cmd: Function to send/batch the invalidation command
+ * @cmds: Incase of batching, it includes the pointer to the batch
+ */
+static inline void arm_smmu_tlb_inv_build(struct arm_smmu_cmd *cmd,
+					  unsigned long iova, size_t size,
+					  size_t granule, unsigned long pgsize,
+					  bool is_range, void *opaque, bool leaf,
+					  void (*add_cmd)(void *_opaque,
+							  struct arm_smmu_cmdq_batch *cmds,
+							  struct arm_smmu_cmd *cmd),
+					  struct arm_smmu_cmdq_batch *cmds)
+{
+	unsigned long end = iova + size, num_pages = 0, tg = pgsize;
+	u64 orig_data0 = cmd->data[0];
+	size_t inv_range = granule;
+	u8 ttl = 0, tg_enc = 0;
+
+	if (is_range) {
+		num_pages = size >> tg;
+
+		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
+		tg_enc = (tg - 10) / 2;
+
+		/*
+		 * Determine what level the granule is at. For non-leaf, both
+		 * io-pgtable and SVA pass a nominal last-level granule because
+		 * they don't know what level(s) actually apply, so ignore that
+		 * and leave TTL=0. However for various errata reasons we still
+		 * want to use a range command, so avoid the SVA corner case
+		 * where both scale and num could be 0 as well.
+		 */
+		if (leaf)
+			ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
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
+
+			/* Determine how many chunks of 2^scale size we have */
+			num = (num_pages >> scale) & CMDQ_TLBI_RANGE_NUM_MAX;
+
+			cmd->data[0] = orig_data0 |
+				FIELD_PREP(CMDQ_TLBI_0_NUM, num - 1) |
+				FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
+
+			/* range is num * 2^scale * pgsize */
+			inv_range = num << (scale + tg);
+
+			/* Clear out the lower order bits for the next iteration */
+			num_pages -= num << scale;
+		}
+		/*
+		 * IPA has fewer bits than VA, but they are reserved in the
+		 * command and something would be very broken if iova had them
+		 * set.
+		 */
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
+			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
+			       (iova & ~GENMASK_U64(11, 0));
+
+		add_cmd(opaque, cmds, cmd);
+		iova += inv_range;
+	}
+}
+
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
 void arm_smmu_sva_notifier_synchronize(void);
-- 
2.55.0.141.g00534a21ce-goog

