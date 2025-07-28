Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D47027AC54
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725227; cv=none; b=pGSJr6XessFly8STRJJ3K1Eehu26gk/1oSOMUUdLjdqbplE2p+X8FwfOe1Lf4Mbt/RTZp2lCNPk+qfoj4BjUd3NZcfKL9EhF4axPGGnN7B9a/uf8FGbhAldns63eAV28wfXKdHtQP1+N+EEXbC+nrnbgSDW65omy9khfKEOdlUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725227; c=relaxed/simple;
	bh=IWszQThaLRIClyIX4i0D/ufNTnIxoyf1Y2v1vsCiCxE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f6j18g3oQrlNLcw7VFZP2p6C+SCbEmxtvBSsGF7afkIl2cwASZjqTdWbIuXyMJ+g+VPgUkd6bEYo4VDKTm7JfKXyxdZQ370CCs3ftsev5+45YV0aCKspgVx/hRBb2KmzFx6OI+zrehqU7nYo8JRQG/2ElbtOnodKMGToZg44ovg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vgu4Nlc5; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vgu4Nlc5"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a6d1394b07so2811110f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725223; x=1754330023; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6e/2TheqBDOEi4HSiBuM8XyP32c0aQfj3qnc6fRtrsM=;
        b=Vgu4Nlc5T/PC7vsC8U7pcW1NoiVsF9ggop+cApNdVSh66sukgg7GXpmkI7hp92NbWG
         CGxl1WW0kEb19loUL8u1OjWrKUu+uOYkNY3dPaDmcEhUKt3Tfr6IbNe8p8xhMa15AhEr
         UNW3NvtYnxe6a8VdN3omPNGnj3ED8ngNky/xjYYJxEiJin3Y0C7xoPk5vmuWiuWw0C/P
         1OmqBBqghZeSltYt1uYYSsrokIfztk3Xo/4o2AjLWFRi/VeNe4zxheUQjh9BBO3hvjom
         sm9TlUeay5QxVXk16uG07REmQkjTopMbol2HYEagXUmuavweyMUAG3FYGZ9SjytaLQ9Z
         CVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725223; x=1754330023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6e/2TheqBDOEi4HSiBuM8XyP32c0aQfj3qnc6fRtrsM=;
        b=BxXhw7MSegY5vrinq2erVcPhlwfV0xGBM6FYZsBwLFIsmYJ0uRnjWW/s8UaiNryBOg
         sH7PIoxiRREH8fv1OTVvmpt9qLYBPuEagUkU5KPxBrn98hYFnnUVdO0glbH7nu2m8GSA
         X7s50sdQJeD/HFUFzPKPlC350/ZMQ1IbFFm869H8GyBfHZrbunS2faluaN1hrS7iIs2c
         SFM3lSG6nUp1vpxN4jJJDksMlPtTqkoRcuKGgBrvc9NWVFJf985KZwp4CRYJW8pphlTe
         cxWxnZrx9LxT9mL9eWLV8AG3QJhnN1WBwd/bSOgBey5jxlfew0H8I7V8JBpYt5oQeE6U
         VZRA==
X-Forwarded-Encrypted: i=1; AJvYcCWVThhSpMR1CR4jByGz/Bp6fFt44yELlgggez7LIhSjoF8yrZRUhfbQzOPqs2dcGcIuIp77FYg=@lists.linux.dev
X-Gm-Message-State: AOJu0YycqNmGcxG9epuX6T1zHmpwS+5VliEzFbCovsBqOR/Ne7odMun5
	/1DBVHJ4KFYmtDIJcVDafAY7TFLcDilc8sFXy3HA5eCx7ymvW4u5kS81/vpmcymjjfhtSHOBj3t
	VgjXRP93JAzWpvQ==
X-Google-Smtp-Source: AGHT+IEDIjSlCUVUxCpo1rhb6F+umTy0J4Onr6Gk0yVTZfYuvmOMhy6s8JdN8rpuLmzFtQt/COWBfeqeFpc2iQ==
X-Received: from wrbgv1.prod.google.com ([2002:a05:6000:4601:b0:3b7:8ac1:5f96])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4011:b0:3a5:243c:6042 with SMTP id ffacd0b85a97d-3b7765e58a1mr8332168f8f.2.1753725223461;
 Mon, 28 Jul 2025 10:53:43 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:53:00 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-14-smostafa@google.com>
Subject: [PATCH v3 13/29] iommu/arm-smmu-v3: Move TLB range invalidation into
 a macro
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Range TLB invalidation has a very specific algorithm, instead of
re-writing it for the hypervisor, put it in a macro so it can be
re-used.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-common.h      | 65 +++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 59 +----------------
 2 files changed, 68 insertions(+), 56 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.h
index f115ff9a547f..ab6db8b4b9f2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.h
@@ -540,4 +540,69 @@ static inline void queue_write(__le64 *dst, u64 *src, size_t n_dwords)
 	for (i = 0; i < n_dwords; ++i)
 		*dst++ = cpu_to_le64(*src++);
 }
+
+/**
+ * arm_smmu_tlb_inv_build - Create a range invalidation command
+ * @cmd: Base command initialized with OPCODE (S1, S2..), vmid and asid.
+ * @iova: Start IOVA to invalidate
+ * @size: Size of range
+ * @granule: Granule of invalidation
+ * @pgsize_bitmap: Page size bit map of the page table.
+ * @smmu: Struct for the smmu, must have ::features
+ * @add_cmd: Function to send/batch the invalidation command
+ * @cmds: Incase of batching, it includes the pointer to the batch
+ */
+#define arm_smmu_tlb_inv_build(cmd, iova, size, granule, pgsize_bitmap, smmu, add_cmd, cmds) \
+{ \
+	unsigned long _iova = (iova);						\
+	size_t _size = (size);							\
+	size_t _granule = (granule);						\
+	unsigned long end = _iova + _size, num_pages = 0, tg = 0;		\
+	size_t inv_range = _granule;						\
+	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {				\
+		/* Get the leaf page size */					\
+		tg = __ffs(pgsize_bitmap);					\
+		num_pages = _size >> tg;					\
+		/* Convert page size of 12,14,16 (log2) to 1,2,3 */		\
+		cmd->tlbi.tg = (tg - 10) / 2;					\
+		/*
+		 * Determine what level the granule is at. For non-leaf, both
+		 * io-pgtable and SVA pass a nominal last-level granule because
+		 * they don't know what level(s) actually apply, so ignore that
+		 * and leave TTL=0. However for various errata reasons we still
+		 * want to use a range command, so avoid the SVA corner case
+		 * where both scale and num could be 0 as well.
+		 */								\
+		if (cmd->tlbi.leaf)						\
+			cmd->tlbi.ttl = 4 - ((ilog2(_granule) - 3) / (tg - 3));	\
+		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)		\
+			num_pages++;						\
+	}									\
+	while (_iova < end) {							\
+		if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {			\
+			/*
+			 * On each iteration of the loop, the range is 5 bits
+			 * worth of the aligned size remaining.
+			 * The range in pages is:
+			 *
+			 * range = (num_pages & (0x1f << __ffs(num_pages)))
+			 */							\
+			unsigned long scale, num;				\
+			/* Determine the power of 2 multiple number of pages */	\
+			scale = __ffs(num_pages);				\
+			cmd->tlbi.scale = scale;				\
+			/* Determine how many chunks of 2^scale size we have */	\
+			num = (num_pages >> scale) & CMDQ_TLBI_RANGE_NUM_MAX;	\
+			cmd->tlbi.num = num - 1;				\
+			/* range is num * 2^scale * pgsize */			\
+			inv_range = num << (scale + tg);			\
+			/* Clear out the lower order bits for the next iteration */ \
+			num_pages -= num << scale;				\
+		}								\
+		cmd->tlbi.addr = iova;						\
+		add_cmd(smmu, cmds, cmd);					\
+		_iova += inv_range;						\
+	}									\
+}										\
+
 #endif /* _ARM_SMMU_V3_COMMON_H */
\ No newline at end of file
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 066d9d9e8088..245b39ddef66 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2075,68 +2075,15 @@ static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
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
+			       smmu, arm_smmu_cmdq_batch_add, &cmds);
 	arm_smmu_cmdq_batch_submit(smmu, &cmds);
 }
 
-- 
2.50.1.552.g942d659e1b-goog

