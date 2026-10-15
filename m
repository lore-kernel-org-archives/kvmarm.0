Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70CC58B6AE
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094973; cv=none; b=RhfL6YlGF6FTuyVZghT50s95c8E40mKR+LmuOqhB6GZFHMqy+evD/R8ZhiRi4ydPvXY4Vxqt+Khxwv3QUchX+BfZkjGpKYiWrgx5l9cvnpNkjwDWEl+mLLHRUfqxzdV0IJw1QqFT2w50SLIYkQ9OrOVE3e4ZrWIotEfoIjcoDPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094973; c=relaxed/simple;
	bh=NcIQJYvuGHWznbFTUVkvtGXTi7lEtb2z7ScpZwFVY3s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D7rCOXqC04o1I1FBEvEzP2FU4ekHh3UPa42BBccFhiKgBMxmT2r1i35KOC44HCic/6v+HP2wJSU/C+Q6aKMvfsP4y6AOtnRDiFFbIi1nPP9Crml/Z4dBgvVN2N6PmNZp3UhpgraRN5Jc6iQAAnVCDmVmC61YzvLZWqSHK4uBuIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F1bC0yOu; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F1bC0yOu"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a17b4c613fso29117865e9.2
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094969; x=1792699769; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TaAoLgM/CtoTiNdadIKWG+p+UJsFKFHvL5NWzPeT3Ac=;
        b=F1bC0yOu+Sy+a3uFQ/kHFC/Ha2m60gmrqh2A6tnmdAi5xRvTjMnYA9k3SGhtSus3rq
         ZkRMtnhA6ZJ7FQRaztQu3XfNOQ+KomTwN1IEneLI/UUch+LvtKsddQWYtB2fba7Qugb0
         FMQf0n6gq9bwCjXvNb1mdWYvggYksLbcpSv+C178vGIo92bI9R+Q7gbX1xSsk5rkBPHc
         loPo1pkVbscUDUyUrgM/NVShgC7DwWihKJpzVZCGEc+T2iTHqfhuy6D6YvwI7P+Fsrmx
         LoJmZW/IFvoB1lGJ2rNZ6abL9RqTMLZZ2dCo3DyKchzdlahOAoAEoF+psd8VJyJDGFVj
         vTXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094969; x=1792699769;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TaAoLgM/CtoTiNdadIKWG+p+UJsFKFHvL5NWzPeT3Ac=;
        b=Hu7Jnvx+kaqkk4sXP124qdgsFD9fFep4SOo7xekzDg5Cz0goECWKuPTaFwFiOs006T
         jUZpim43OG+nCoVdPvtdk0epdOWbAsLZt56A39Ikl5VPHTz+vRnX1HstUvaX794+oQfT
         +c00IhM4KQz4SQZSIGaS7FXU3KcjjvZr9ZnagM2vck+s40f8Nq9WLHeLzneSRTusJDgU
         Iqk02t3OeEMkhxDb/XJnUXOeZzcn92w4Zr8byHabJZrWbKlGpx4VweYZOR32G5R8X/el
         Asr7ZdbIy7f4YYEFLq8iZouSnDfJKmL8bppdwZRNaNeP/AYc0GTcunm4lElUWXisoanv
         Fdnw==
X-Forwarded-Encrypted: i=1; AKwUvBx0ThXI4XnfgbKuVXxeoTw1tLMt7OUpDGFYdgZJ+a3+MvSqifRoa7jYnIuAEK/n6mZ7zLW4F8o=@lists.linux.dev
X-Gm-Message-State: AFq9FYL60192Pj43jw0HVvmPXkCnLZjyct53xGeFsrdfgr8MHPN38PKb
	DbfGoDD3eoemCrb1na3afw3Oi7YSuDxcanIM/BZdouXBixDxSYnhyMa4v8L+ZmRiXZT3X4T/CXt
	2WFwYevQLgv4pwg==
X-Received: from wmqh18.prod.google.com ([2002:a05:600c:3512:b0:4a1:93c0:d3c2])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6215:b0:4a0:eae0:b30e with SMTP id 5b1f17b1804b1-4a18e4ca157mr369276785e9.22.1792094968875;
 Thu, 15 Oct 2026 13:09:28 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:46 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-16-smostafa@google.com>
Subject: [PATCH v9 15/25] iommu/arm-smmu-v3-kvm: Add CMDQ functions
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Add the command queue accessors. The hypervisor's own commands, such as
TLB invalidations, go through smmu_send_cmd(), which queues the command
followed by a CMD_SYNC and waits for completion. Filtered host commands
are copied into the shadow queue with smmu_add_cmd_raw().

Polling is bounded by a 1 ms timeout measured with the architected
counter, and sleeps in WFE when the SMMU supports SEV.

Split queue_space() out of queue_has_space(), as the emulation will
check the space in the host's queue.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  14 ++-
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c    | 119 ++++++++++++++++++
 2 files changed, 127 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index d07fca3d1cf5..bc2e7e10200a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1287,19 +1287,21 @@ int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
 bool arm_smmu_erratum_repeat_tlbi_cfgi(void);
 
 /* Queue and STE functions shared between kernel and hyp. */
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
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
index 02e7c6175832..c9fc21e405e7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
@@ -25,6 +25,42 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 
 #define cmdq_size(cmdq)	((1UL << ((cmdq)->llq.max_n_shift)) * CMDQ_ENT_DWORDS * 8)
 
+static u32 timer_freq;
+
+static inline u64 hyp_clock_ns(void)
+{
+	return mul_u64_u32_div(__arch_counter_get_cntvct(), NSEC_PER_SEC, timer_freq);
+}
+
+#define ARM_SMMU_EL2_POLL_TIMEOUT_US	1000
+/*
+ * Wait until @__cond is true. With @__use_wfe, sleep in WFE between polls:
+ * interrupts are masked at EL2, so only the SMMU's SEV or the timer event
+ * stream wakes the CPU, and the timeout is only checked once awake.
+ * Return 0 on success, or -ETIMEDOUT.
+ */
+#define smmu_wait(__use_wfe, __cond)					\
+({									\
+	int __ret = 0;							\
+	u64 __start = hyp_clock_ns();					\
+	u64 __timeout = ARM_SMMU_EL2_POLL_TIMEOUT_US * NSEC_PER_USEC;	\
+									\
+	while (!(__cond)) {						\
+		if (__use_wfe) {					\
+			wfe();						\
+		} else {						\
+			cpu_relax();					\
+		}							\
+		if ((hyp_clock_ns() - __start) >= __timeout) {		\
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
@@ -77,6 +113,85 @@ static int smmu_unshare_pages(phys_addr_t addr, size_t size)
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
+	queue_write(Q_ENT(q, llq->prod), cmd, CMDQ_ENT_DWORDS);
+	llq->prod = queue_inc_prod_n(llq, 1);
+}
+
+static int smmu_add_cmd(struct hyp_arm_smmu_v3_device *smmu,
+			struct arm_smmu_cmd *cmd)
+{
+	int ret;
+
+	hyp_assert_lock_held(&smmu->hw_lock);
+	ret = smmu_wait(smmu->features & ARM_SMMU_FEAT_SEV,
+			!smmu_cmdq_full(&smmu->cmdq));
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
+	return smmu_wait(false, smmu_cmdq_empty(&smmu->cmdq));
+}
+
+__maybe_unused
+static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
+			 struct arm_smmu_cmd *cmd)
+{
+	int ret;
+
+	hyp_assert_lock_held(&smmu->hw_lock);
+	ret = smmu_add_cmd(smmu, cmd);
+	if (ret)
+		return ret;
+
+	return smmu_sync_cmd(smmu);
+}
+
 /* Put the device in a state that can be probed by the host driver. */
 static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 {
@@ -202,6 +317,10 @@ static int smmu_init(void)
 	if (!PAGE_ALIGNED(kvm_hyp_arm_smmu_v3_smmus))
 		return -EINVAL;
 
+	timer_freq = read_sysreg(cntfrq_el0);
+	if (!timer_freq || timer_freq > NSEC_PER_SEC)
+		return -EINVAL;
+
 	kvm_hyp_arm_smmu_v3_smmus = kern_hyp_va(kvm_hyp_arm_smmu_v3_smmus);
 	pfn = hyp_virt_to_pfn(kvm_hyp_arm_smmu_v3_smmus);
 	nr_pages = smmu_arr_size >> PAGE_SHIFT;
-- 
2.56.0.176.g3575e65682-goog

