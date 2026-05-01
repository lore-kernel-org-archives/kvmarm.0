Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08143A16B8
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634425; cv=none; b=tpTf9QYeVzonhFtXUKOZ/lZi8ehcVqi9eKMqfTV6qJCTtOE05+wIvWKhX14yRb3bNc8Hg4zZvazN4MUFsXSDJQpIpg3jiVKvJ+EoLpAhEX1zzJozRAeJzQkW5qwmmpjOCBp7G7g2oOXPB3RHtKm3/1Kvu4QPM+12j/AuDfN7t48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634425; c=relaxed/simple;
	bh=ht3+eoYVAH5LRRYEvRvfYwLs0rEwiSQ92hy2jk6fn44=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oc5OG7X7cab2BpDGsiz7LAe0gbMuS6tEtfJwPPala0XLQDPV8Rdets+zZ+V09N9DSwvWc81ZmgBvUkkj60QO/H7tdE6oK3OrGp3Tj6N7l1zrVdpciFZF/4oPLqHvNKw/4HDQF4kVZvhSE6wx1PUhNFs/sMMCBBw6Cr2jbK4ScsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cimAIXKg; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cimAIXKg"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-65a11b5f24dso3226506a12.1
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634422; x=1778239222; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DQ1p7g2Tvq/hKfuZPoTWdpsu5XMV18xbkA26lNofyBM=;
        b=cimAIXKgtCuvUVYCECDnPliJJ/z0hWALK4sz3EULgHWbwgODsqSKuyE5IZ31lLm3zc
         OoufCkOiPadmmY6FKc2+V+RBCf5lbqPPf6vZ3OOjrw+kK8y3HIbDipo27NMn0pmCE/cd
         qEo16xhdSCUvPqbkYg7uZRrgrZtLAED1U5BsqgZyOUDpERkgtA2hNJy1X+UJnmAOrMZa
         9RmypDHPrUMEDXMIoLpC0Eko0Z1PCslxMJAfSG0rMVcylywYJNSHXbb0TenOF6EYxZR7
         Ywg6ixoB+MdEPaCy46MLuY0M22J5d6D/uyYY5hNDt8RGGhNM8GViB0ULhif98n1Qz4ex
         DSlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634422; x=1778239222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DQ1p7g2Tvq/hKfuZPoTWdpsu5XMV18xbkA26lNofyBM=;
        b=r+5BSqi3Q9xZLxCuhkbbIuyiZmf1Q19nWdiFO2Wv4A8iD3A0yfseAHh8djEP3qTGLX
         tcbqr2aON0GMWxBLiffLJGAcxRgZplmzBZ2x8XB/3O+Gxs3FKcNWzEULHI5qxzYEc+Op
         qza9JhhI5/J7uRDpqGnBso7iefyGXKT1Tlf2GawCtxs6hAqwlFWE9iH441rNzlvi9g3o
         o64de8Xq7KUx8kpthZijahaWw4fXVJoLaLip++W4YqZFO5gTWnra6JWpBQjMlaV6zT3b
         vBesV8/Xy569mag/SdgOC9FXAk3hPXD4zU+C+uwEDfkq7v9FCtA31CorNHP8FFXplBKp
         8jnw==
X-Forwarded-Encrypted: i=1; AFNElJ+17NB7q7KD9cE6nSl/nXjbrlbFmeLdG1n0bsKrmxUcLrYdZNEJtdQ5rh31IQl26oWc9bFKmX8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6nQIPg/Z89OgSSTwBFcXm3LqPqBsD3ORzP2WMpKZHCG2YpUwU
	v7QZdQAmHbKJkMBNXqegS+xQo5Bsheo8FPMvN1ydCYnZemqnaHyBNSp4f1qIxVvoME0H0VyZmNY
	lmymOCchqXoU4Pg==
X-Received: from edj4.prod.google.com ([2002:a05:6402:3244:b0:672:bfdb:8b72])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:d94f:0:b0:67b:acf5:f39e with SMTP id 4fb4d7f45d1cf-67bacf5f78amr800846a12.10.1777634422049;
 Fri, 01 May 2026 04:20:22 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:18 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-17-smostafa@google.com>
Subject: [PATCH v6 16/25] iommu/arm-smmu-v3-kvm: Add CMDQ functions
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

Add functions to access the command queue, there are 2 main usage:
- Hypervisor's own commands, as TLB invalidation, would use functions
  as smmu_send_cmd(), which creates and sends a command.
- Add host commands to the shadow command queue, after being filtered,
  these will be added with smmu_add_cmd_raw.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  14 ++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 107 ++++++++++++++++++
 2 files changed, 115 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index f904f4d19609..3fc499608d76 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1156,19 +1156,21 @@ u32 smmu_idr5_to_oas(u32 reg);
 unsigned long smmu_idr5_to_pgsize(u32 reg);
 
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
index 3b77796dafc7..aac455599728 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -6,6 +6,7 @@
  */
 #include <asm/kvm_hyp.h>
 
+#include <nvhe/clock.h>
 #include <nvhe/iommu.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/trap_handler.h>
@@ -22,6 +23,31 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 
 #define cmdq_size(cmdq)	((1 << ((cmdq)->llq.max_n_shift)) * CMDQ_ENT_DWORDS * 8)
 
+/*
+ * Wait until @cond is true.
+ * Return 0 on success, or -ETIMEDOUT
+ */
+#define smmu_wait(use_wfe, _cond)					\
+({									\
+	int __ret = 0;							\
+	u64 delay = hyp_clock_ns() + ARM_SMMU_POLL_TIMEOUT_US * 1000;	\
+									\
+	while (!(_cond)) {						\
+		if (use_wfe) {						\
+			wfe();						\
+			if ((_cond))					\
+				break;					\
+		} else {						\
+			cpu_relax();					\
+		}							\
+		if (hyp_clock_ns() >= delay) {				\
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
@@ -74,6 +100,87 @@ static int smmu_unshare_pages(phys_addr_t addr, size_t size)
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
+	ret = smmu_wait(false, !smmu_cmdq_full(&smmu->cmdq));
+	if (ret)
+		return ret;
+
+	ret = arm_smmu_cmdq_build_cmd(cmd, ent);
+	if (ret)
+		return ret;
+
+	smmu_add_cmd_raw(smmu, cmd);
+	writel(smmu->cmdq.llq.prod, smmu->cmdq.prod_reg);
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
2.54.0.545.g6539524ca2-goog

