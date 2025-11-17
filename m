Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86CF32C95E
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405331; cv=none; b=JXuq5nqTUoLwNXD8xSdeDenQjEzkGa6D4rgYliFanFzYn9by5Bp/OzYbC7Q2UTTwOJDKrZB3M69ioSFOshyysZMCS/67CYTIDBxufr9VkQXzKA1bjZpJSSWhUGtZ1X314gtE5A1XFhNbTLKe++F5+j8iMIoc9QborxFylHDpvM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405331; c=relaxed/simple;
	bh=e3EIrVNRd9t3QHVp59OzFLDa7p4DxlL7+5kVQLVXEbQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e3X3ot+OQs1HvRhrsWaHdiozLsX9odH9jIjJUiSD13EGlElhirAhUlI55N8adE3STyoPdJ35hkG5S+jg+zQZvq+iEVuTVBFtG4BehK1tTFNIb8tZOP0o5wn+xm4I1p25YH+6k9HIYuY/aNBJxCK4kuRubPv71ZnriKl1b+5NzT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1CBanYZ0; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1CBanYZ0"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b73599315adso315645566b.2
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405326; x=1764010126; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gthqCq5o6yeE89UPMEuJgIME9dtn3tyMj4iiO/+WnDw=;
        b=1CBanYZ0TRtRZ7C9OY90/Dzsnq/i6/JmdtBFvlimNriX58BqbwVT49du4y7E1RpxJ0
         wDMz3zRFJTlFr4zuCnruEGSSaGGki0l3F9GfLsaquUDIQY+v4ozZiLkQnQWhHra3dwiB
         HtFVGIBpzgVc/Jr8vBJ5UGqz/DOkgsCkLN5a59anfCYeFsXjjkSFmAXayQ/IprAhZ9mC
         yxrBte6teiKon/4dxk0bzxF6zZ3c7y++B76Jh4wxSK+dbXghD0QNh5qIe8uUEq+7dh2x
         wsWPZnJfKlEFd45Zp+uq/S6omLaXI+Z/76zPoufwqpg7P+pv/yGQ3B49PUglPwUk2WiY
         CPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405326; x=1764010126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gthqCq5o6yeE89UPMEuJgIME9dtn3tyMj4iiO/+WnDw=;
        b=vZQsNDZPA0tRTPm0I8KB2FWKPkC2cn2GsZbmB3ULetjsGRdm2Dj0YKYv3wRt6/QiyU
         waUA3G2UAhyImBPwxRu54cEQR7WeYorYK2mnhmLMsCuhtxnko9j5QTn79xMQq8LdQ3Xu
         w8uCe/t9iL0sWKkxFUgNiLzRVQgY9gIjOJcVtQQzvcHXzeIw/wDTl/P51kejvrYYz4qj
         7sMP45U1yQJz95UZ5yz1gTHRKj/BtjiHwDNDeJkvPew/dNHhn5Y7pHUdxY7YJDWbEgrS
         LaEm1xlulHr4RojpF623y0CAa3T080+bxJb6aLJvp9U3M6dpU7x2j44zQ1AwBJmFwXIL
         Zd9w==
X-Forwarded-Encrypted: i=1; AJvYcCVAPe6Si3Vg/i/qi6g9/Zx3MLU6B+joduBA7uD5GRDGzK3M6S6JhbIMw9z5MingeBxfW6dJTGw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNYLaXlM58XTV1q+2euEoXVfRI6h448Q3leFx9kpU9mOZ0sq7L
	WZlvSBkF0PSooK1CRqEchxxvqwIRBQKlRmBD4G5oM6yN1HaKJUttgqcfzyjOxCxB2xStsONrazM
	qaWGBF6OZ/sfrcA==
X-Google-Smtp-Source: AGHT+IE5KRl2mOZHi8gtVKjABXvz8EzQH63tM2/gsVZz7+LwCgoA43ubS78h95GU7o7UGQNIlpHqH+cFHQPaLQ==
X-Received: from ejcqo4.prod.google.com ([2002:a17:907:8744:b0:b73:7130:3892])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:849:b0:b72:598:2f32 with SMTP id a640c23a62f3a-b73678ed1d0mr1476075666b.42.1763405325882;
 Mon, 17 Nov 2025 10:48:45 -0800 (PST)
Date: Mon, 17 Nov 2025 18:48:07 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-21-smostafa@google.com>
Subject: [PATCH v5 20/27] iommu/arm-smmu-v3-kvm: Add CMDQ functions
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Add functions to access the command queue, there are 2 main usage:
- Hypervisor's own commands, as TLB invalidation, would use functions
  as smmu_send_cmd(), which creates and sends a command.
- Add host commands to the shadow command queue, after being filtered,
  these will be added with smmu_add_cmd_raw.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  14 +--
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 102 ++++++++++++++++++
 2 files changed, 110 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1d552efdc4ae..d909014baad3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1015,19 +1015,21 @@ int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
 int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent);
 
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
index bcb3f99fdcd2..a970b43e6a7e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -22,6 +22,26 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 
 #define cmdq_size(cmdq)	((1 << ((cmdq)->llq.max_n_shift)) * CMDQ_ENT_DWORDS * 8)
 
+/*
+ * Wait until @cond is true.
+ * Return 0 on success, or -ETIMEDOUT
+ */
+#define smmu_wait(use_wfe, _cond)					\
+({								\
+	int __ret = 0;						\
+	u64 delay = pkvm_time_get() + ARM_SMMU_POLL_TIMEOUT_US;	\
+								\
+	while (!(_cond)) {					\
+		if (use_wfe)					\
+			wfe();					\
+		if (pkvm_time_get() >= delay) {			\
+			__ret = -ETIMEDOUT;			\
+			break;					\
+		}						\
+	}							\
+	__ret;							\
+})
+
 static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
 {
 	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
@@ -69,6 +89,88 @@ static int smmu_unshare_pages(phys_addr_t addr, size_t size)
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
+			struct arm_smmu_cmdq_ent *ent)
+{
+	int ret;
+	u64 cmd[CMDQ_ENT_DWORDS];
+
+	ret = smmu_wait(smmu->features & ARM_SMMU_FEAT_SEV,
+			!smmu_cmdq_full(&smmu->cmdq));
+	if (ret)
+		return ret;
+
+	ret = arm_smmu_cmdq_build_cmd(cmd, ent);
+	if (ret)
+		return ret;
+
+	smmu_add_cmd_raw(smmu, cmd);
+	writel_relaxed(smmu->cmdq.llq.prod, smmu->cmdq.prod_reg);
+	return 0;
+}
+
+static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int ret;
+	struct arm_smmu_cmdq_ent cmd = {
+		.opcode = CMDQ_OP_CMD_SYNC,
+	};
+
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
+			 struct arm_smmu_cmdq_ent *cmd)
+{
+	int ret = smmu_add_cmd(smmu, cmd);
+
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
2.52.0.rc1.455.g30608eb744-goog

