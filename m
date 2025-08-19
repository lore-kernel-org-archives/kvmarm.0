Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4B2350820
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640354; cv=none; b=CdUgEUVcVJfx3FO34VuRohwIXRUr8ZKzJ8wRmZeKHaXSCKmJVIiQRL57foMOMINXzLTWNUjFhyQCaC63jx5JaIN1JEK3k++u7/xVYXxq3JQ3gyvSGZzBj3zPFMIHAgU1+fACR0vvnYFbogRB7TNvGv4HTy4On12eowaQcyV5UGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640354; c=relaxed/simple;
	bh=3TG4Z5+XXX9K3RELM+h/fWcPxGfI20T9a5XvTmfpW3Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ozjhRdi/Q9+MTMPlVEofmQ7/rIKHQw6NYs39LTr3uVuXfP/lSTheKEZ38HPqHa4sWlJX4vANUZ2S0VGxxpNG/WpA1COXCUHNZwvMRl4dEdjEYP9UFh0BCAIMEyVd9OIvZ1+Jqhy8FHZIiPESBC0gPIdB9uTZxNkq3x+ffefwyGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FUtLVo1E; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FUtLVo1E"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b9edf5b346so3938825f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640350; x=1756245150; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1QLGehsG9TWs7vYu5jUxb2yk8sP6DWLxxs21XC/HL6E=;
        b=FUtLVo1E2j6wil6QT8r64GtguQND/87VwCwPqB+8MhtqxKPj2xDDMhxmpxOYy1UsEa
         bJOzyiWsXu8cEibbrhjVTpEeWx+xkjRVNL2s99QXD5hr1SFFICF+5PxpRNeORPw1yZd0
         zSNSY0G/KXcTReW/y+Kpjkcnikgcdyxjhhg4+W6B6jkTgAUiV9Rv1uHo9/YtUS2subdL
         O/0lorywzfb8vFlBoV+y+S/o2oZjuHaVZdzrULET7hYT1zDQn0OI9cHQbOdZV4JzD3oo
         EbxynLuja87VpNHTcdsJkzEVX72qVaBzeWVfUqSgd84WtWFRjrSLy3qDMVEqmyM3eazB
         a81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640350; x=1756245150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1QLGehsG9TWs7vYu5jUxb2yk8sP6DWLxxs21XC/HL6E=;
        b=FeoZPyh0a/kAIZeY8KhcV8dbfYQP+x2IdPQuRDicIvCkLk3VcJFxavNFkKn8zHIDhk
         Zk8fl1WIJCm82iaFZXW2VHkIVQddEkZsrbJxZeOb0cBNy1XFYvVS0w4eNWQQZXvMN67f
         P4DEmd66/27xz8K611evVWufrWUDApzj7ngI4l/DZvhxjHxKI8szA2TJm+VoFFqahO9s
         QrsRQYhAeNG54DSRi+B6K8mN7GGgEIj3d/Icszy9tL/KN4bFG30znynoMOqlWXISYb/K
         VM/1nNH83vtD7EUC5B7PBlIs505E08Y6J8FVNc0m1gMUKxXykeEliOGWK4Fz3b6G7GfC
         CelQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSNPfI3fEZe+O+1iy93Mt48riOqswu0zkJPz+Eba+egT+xx5ojvG+3qAuzim0gc8cv/Cr8bQs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfcTgVeNos5H2vK13tLCSG1+UCmXlFM0JnE13v3lBpt7WasUKD
	NmOflwqDiGi6R1cW16LD9PQVIrLLlj7gLkM2il6EYLZ67IAl/6UaNS0R0Ock6zj05Q+WjsakwpN
	SCBeUzBLh0Mizag==
X-Google-Smtp-Source: AGHT+IEyv3kVrYIlmgHeAnLq3AxRjEMrVoo+46FdGKld4xfeBpJx0bEncQb2Yqr4jiUVqXM4bZQzPz6PEoFmag==
X-Received: from wrvb7.prod.google.com ([2002:a5d:5507:0:b0:3b9:c5f:d58b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f52:0:b0:3b7:994b:840f with SMTP id ffacd0b85a97d-3c32eccdad0mr317497f8f.57.1755640350354;
 Tue, 19 Aug 2025 14:52:30 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:35 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-8-smostafa@google.com>
Subject: [PATCH v4 07/28] iommu/arm-smmu-v3: Move TLB range invalidation into
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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 59 +------------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 64 +++++++++++++++++++++
 2 files changed, 67 insertions(+), 56 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 1f765b4e36fa..41820a9180f4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2126,68 +2126,15 @@ static void __arm_smmu_tlb_inv_range(struct arm_smmu_cmdq_ent *cmd,
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
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 2698438cd35c..a222fb7ef2ec 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1042,6 +1042,70 @@ static inline void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
 	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
 
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
+		cmd->tlbi.addr = _iova;						\
+		add_cmd(smmu, cmds, cmd);					\
+		_iova += inv_range;						\
+	}									\
+}										\
+
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
 void arm_smmu_sva_notifier_synchronize(void);
-- 
2.51.0.rc1.167.g924127e9c0-goog

