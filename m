Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F96E4779B1
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116778; cv=none; b=iMbM0PBtvaT4caFsrcivjTb9C+Yvm/l8r8P9Hm/BC159RET9YvgutMIXjj5nkRVEaD9NrsGup4lEhrxBRNzcSUTI9RwlgoZFk5JepfparSREcX10RuehcWh6EI34bsokdtkRnz3yfAyodXyKKPTt+Yb97ES4IlGwr4SbX2fmjh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116778; c=relaxed/simple;
	bh=TTW+FNhgm8rDj6yxtOrw2Lhsb+fDiJsDpk/4fctaI6g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uGb0xwhS88u9K08kw4EBHykE18fo8mu/LiSNA2z4wkCvW7WDxv6BKDBDMHIxWpNsdLc6G5zqF4odkUwSYGmYZdRVkyDrTXZ08PN/Oiz0yUAPENwdUKh29vXL7lGIyxLTik1BA5DFottbRunbdtfK8v/LQZxY8GvRmbqV03Rql3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KPDmXIXl; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KPDmXIXl"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493e0042895so12477605e9.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116772; x=1784721572; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=75EB2f6MAXW5J4vafHy4b5awBXMBAYUr8yFrAesJgTk=;
        b=KPDmXIXlwo271DuJk2j0PAGk8An+VZ5yjk3/fh4n0krUD2NBk+76gTfKq+tPXlv5tt
         fv22f8y4LewuK/RmTeR0BKjBIoyVv2xHhmM7dy0tmiZAP58VclemZ4DSxkHU2nEkV1YW
         h11KaD7D2DGrXjMwAkZNapFbuSWB3rleBZNAEYS+hA9Vc/30TejV6wbSIDV1vHf7mLMN
         3oU4wOrr1PBmAHSCLdNsMT+4otXTCtMQxz7emdcqz14k7U+Rs+rU3eOjw6HpkSaeWazr
         YWo4HfEgObm6+tsS8+jCV4Q496RYuxODrdvbdQ8lIHXLyf/OC4G7KcLa53czpmYv1ybq
         21aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116772; x=1784721572;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=75EB2f6MAXW5J4vafHy4b5awBXMBAYUr8yFrAesJgTk=;
        b=PpPApQJtC5u96vKJ7LdGSie/FRS4B0e9t8PGqxP7gq1BSlraZ2gO5vNFyg2JlXK3JQ
         5C9pZy0DEbKmbx2/X6DypaKnCvLWsADoOCI0NHzpIiWJ254znNnNKRNL7rmb1BNhi0rq
         X/+ms00l+vz0WAFZjjGzl2/3MGKsq8zB/8qcq330qKQPJRd/lh04YjQ6lYsGbEN2b4Ck
         knotJWqNcr98/jh5mS8xJCKz/LNBJeDrbqH+xO+J24Jz9a+Plbpyj757OV7afY0+HPaT
         EL+9nsuoXFu1NxeUl+YAvLL4P+WXvDTCUuo9VOswkzkkjpjiMrrY70Ppd7mRSAQorRuf
         +9og==
X-Forwarded-Encrypted: i=1; AHgh+RoP7BAdlibmegw/IJHtJT+bF+IjiLqXTn+t4VqAGLIhksP0AuqLQ/RoB6a7BMRMhCzUeoLrGi4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxxf5zXKz4UJJVDa8fYmJGApQigd7i2reSoQuTMVVnlqtoTt63c
	3jrNSU8Md3qBpkTHfBvchIRK5VkbhXJjFrdPHqo9zx1LaU2ZbETwcnmC8EZ+eLnSGjtTDJTbiF1
	qxdiAHjTcwXAfFA==
X-Received: from wmiv11.prod.google.com ([2002:a05:600c:e40b:b0:493:ab17:3e61])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8444:10b0:493:bd2a:93bb with SMTP id 5b1f17b1804b1-493f87d7eefmr140336125e9.3.1784116772290;
 Wed, 15 Jul 2026 04:59:32 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:58:56 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-16-smostafa@google.com>
Subject: [PATCH v7 15/24] iommu/arm-smmu-v3-kvm: Add CMDQ functions
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

Add functions to access the command queue, there are 2 main usage:
- Hypervisor's own commands, as TLB invalidation, would use functions
  as smmu_send_cmd(), which creates and sends a command.
- Add host commands to the shadow command queue, after being filtered,
  these will be added with smmu_add_cmd_raw.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  14 ++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 109 ++++++++++++++++++
 2 files changed, 117 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 842d0c9b883c..cbc4589e89a8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1226,19 +1226,21 @@ unsigned long smmu_iidr_features(u32 reg, unsigned long features);
 unsigned long smmu_iidr_options(u32 reg, unsigned long options);
 
 /* Queue functions shared between kernel and hyp. */
-static inline bool queue_has_space(struct arm_smmu_ll_queue *q, u32 n)
+static inline u32 queue_space(struct arm_smmu_ll_queue *q)
 {
-	u32 space, prod, cons;
+	u32 prod, cons;
 
 	prod = Q_IDX(q, q->prod);
 	cons = Q_IDX(q, q->cons);
 
 	if (Q_WRP(q, q->prod) == Q_WRP(q, q->cons))
-		space = (1 << q->max_n_shift) - (prod - cons);
-	else
-		space = cons - prod;
+		return (1 << q->max_n_shift) - (prod - cons);
+	return cons - prod;
+}
 
-	return space >= n;
+static inline bool queue_has_space(struct arm_smmu_ll_queue *q, u32 n)
+{
+	return queue_space(q) >= n;
 }
 
 static inline bool queue_full(struct arm_smmu_ll_queue *q)
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 9f76f4e82341..8e798fd8fdaa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -6,6 +6,7 @@
  */
 #include <asm/kvm_hyp.h>
 
+#include <nvhe/clock.h>
 #include <nvhe/iommu.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/trap_handler.h>
@@ -22,6 +23,36 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 
 #define cmdq_size(cmdq)	((1 << ((cmdq)->llq.max_n_shift)) * CMDQ_ENT_DWORDS * 8)
 
+#define ARM_SMMU_EL2_POLL_TIMEOUT_US	1000
+/*
+ * Wait until @cond is true, can use WFE, if polling on an SMMU and
+ * event that supports it.
+ * Return 0 on success, or -ETIMEDOUT
+ */
+#define smmu_wait(__use_wfe, __cond)					\
+({									\
+	int __ret = 0;							\
+	u64 start = hyp_clock_ns();					\
+	u64 timeout = ARM_SMMU_EL2_POLL_TIMEOUT_US * 1000;		\
+									\
+	while (!(__cond)) {						\
+		if (__use_wfe) {					\
+			wfe();						\
+			if (__cond)					\
+				break;					\
+		} else {						\
+			cpu_relax();					\
+		}							\
+		if ((hyp_clock_ns() - start) >= timeout) {		\
+			if (__cond)					\
+				break;					\
+			__ret = -ETIMEDOUT;				\
+			break;						\
+		}							\
+	}								\
+	__ret;								\
+})
+
 static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
 {
 	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
@@ -74,6 +105,84 @@ static int smmu_unshare_pages(phys_addr_t addr, size_t size)
 	return 0;
 }
 
+__maybe_unused
+static bool smmu_cmdq_has_space(struct arm_smmu_queue *cmdq, u32 n)
+{
+	struct arm_smmu_ll_queue *llq = &cmdq->llq;
+
+	WRITE_ONCE(llq->cons, readl_relaxed(cmdq->cons_reg));
+	return queue_has_space(llq, n);
+}
+
+static bool smmu_cmdq_full(struct arm_smmu_queue *cmdq)
+{
+	struct arm_smmu_ll_queue *llq = &cmdq->llq;
+
+	WRITE_ONCE(llq->cons, readl_relaxed(cmdq->cons_reg));
+	return queue_full(llq);
+}
+
+static bool smmu_cmdq_empty(struct arm_smmu_queue *cmdq)
+{
+	struct arm_smmu_ll_queue *llq = &cmdq->llq;
+
+	WRITE_ONCE(llq->cons, readl_relaxed(cmdq->cons_reg));
+	return queue_empty(llq);
+}
+
+static void smmu_add_cmd_raw(struct hyp_arm_smmu_v3_device *smmu,
+			     u64 *cmd)
+{
+	struct arm_smmu_queue *q = &smmu->cmdq;
+	struct arm_smmu_ll_queue *llq = &q->llq;
+
+	queue_write(Q_ENT(q, llq->prod), cmd,  CMDQ_ENT_DWORDS);
+	llq->prod = queue_inc_prod_n(llq, 1);
+}
+
+static int smmu_add_cmd(struct hyp_arm_smmu_v3_device *smmu,
+			struct arm_smmu_cmd *cmd)
+{
+	int ret;
+
+	hyp_assert_lock_held(&smmu->hw_lock);
+	ret = smmu_wait(false, !smmu_cmdq_full(&smmu->cmdq));
+	if (ret)
+		return ret;
+
+	smmu_add_cmd_raw(smmu, cmd->data);
+	writel(smmu->cmdq.llq.prod, smmu->cmdq.prod_reg);
+	return 0;
+}
+
+static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int ret;
+	struct arm_smmu_cmd cmd;
+
+	hyp_assert_lock_held(&smmu->hw_lock);
+	cmd = arm_smmu_make_cmd_sync(CMDQ_SYNC_0_CS_SEV, 0);
+	ret = smmu_add_cmd(smmu, &cmd);
+	if (ret)
+		return ret;
+
+	return smmu_wait(smmu->features & ARM_SMMU_FEAT_SEV,
+			 smmu_cmdq_empty(&smmu->cmdq));
+}
+
+__maybe_unused
+static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
+			 struct arm_smmu_cmd *cmd)
+{
+	int ret = smmu_add_cmd(smmu, cmd);
+
+	hyp_assert_lock_held(&smmu->hw_lock);
+	if (ret)
+		return ret;
+
+	return smmu_sync_cmd(smmu);
+}
+
 /* Put the device in a state that can be probed by the host driver. */
 static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 {
-- 
2.55.0.141.g00534a21ce-goog

