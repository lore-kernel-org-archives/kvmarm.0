Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82AE550DC2
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082807; cv=none; b=e3uJBd4BBhiyBG/iqKibB7nTEkY3T46+LbuC1k9tzDEhZANfVu3FrWIncMaKWaMCoP1Rxq7Yvra+8hxO5pqRDbbGN28UYJ3M2FJPz4k33m06pODk9ghJWZWT+vIKBDPCZSLRfSKCxGGOeM+kqa4sd5W+2e47v5gv5jZ3qtqqKsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082807; c=relaxed/simple;
	bh=b4qgCD0M5NqNiOQdMSJ9wlwyJb3hshysvAXrlo6i0fU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BPWKw0yzaWoBTaProVS1U78jvtVNRpFYpQTKZw3aahxkqoFsmndjUE+f2Z6wj+ajI7GH0M5gqE+Ee7jBcDiH4q0QB64P35ejgKCbi3XfavyDZTJrpQWN9E3v2nAVw27Aa/33IbWZQaiAACmDTJ5OIBnljUE3vQ4yQjeV8hQowXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ooqd+8bp; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ooqd+8bp"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49e76a80fe5so57903325e9.2
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082801; x=1790687601; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KT9gAbFn8X/5jhTdpDUZBIE1ybk66ZHea/tOTsT2sbI=;
        b=ooqd+8bpmtGbCFLagObG37ZPqF/wbGY3aU5JwggtzFWbGpflRZAbBBmNeMtROZTiIv
         Mn0HB1hg1Q6nPKtlBauqz3DYkaCFAA+47Z7SAQUmJI9I05rVrnocgsCm5ip1eoABVZS4
         0eCKLrG3pM4nZl50JDHvknhGBBvkLWwZ4wYHtHfVJD8NB7bmM/uERyH1lkCScDbWfrpI
         PUdcoC/wbM/TcB78PWRx7f/tnLEiza/SV2SgW3kj+lGkkLiG7aqKeXHlS7Xmc9CGtsq4
         I2Ius5Ig+xK3O3vjXAfxgEyXqz9QCwqxkK8uympimz5bLnhXOChK5qoWRaE7u8EJv3sN
         eEuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082801; x=1790687601;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KT9gAbFn8X/5jhTdpDUZBIE1ybk66ZHea/tOTsT2sbI=;
        b=fgWNgB1SmybhaI0TFjfEBeBbGeo29vct3HEHdVRrVU4BTvqeb2DyovwRxp9PFNx39j
         Qm7u51iHgBFsGiB+QV4N8AlKj31HSbTR9oV0KP9Ryy9uXB2bQjvgTxzJKl5QKAwXF8/6
         lvU3W1/PTHHwvh1SnkxgBtpQmbF0dY/SB/8F4Lm6JKX/X4E8FfqE4MSttOuQ9m/BchQV
         V7Wg0LEd/TwrVps3pYfdjE0cAa/PXWh/dXfmLQSqdGvqoF1Glen/JL5sWHs6J8nekRST
         533mnTbwcnUhlyC3B8CRgw5k3KJ2QO4OYkb3ZSJKpe0nG7erZ2Des3rSaT1/xPjXnVk8
         ql9g==
X-Forwarded-Encrypted: i=1; AKwUvBxYz74ocISyB/uVTYCz1PufhJAeUYFBn86nA2KgDYAqo3IvTIAv2NiOycvbSZlMRO7bww2z0WE=@lists.linux.dev
X-Gm-Message-State: AFuF++lMk2U05BnLo8hwYvDeRMwNMbiYgAPnWv/4t/Ipx4f//GGjVYT+
	H9XnpN1iCQU8GIA1/lmenr8uhacLIBmn0JbXYkMHj77qymjbMZKR89Ya0wilElQ61IZZHm/2ZCs
	gipohwE7QZncgoA==
X-Received: from wmaw22.prod.google.com ([2002:a05:600c:6d56:b0:49e:6021:e264])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e05:b0:49c:fc6e:8cb1 with SMTP id 5b1f17b1804b1-49fc5737ad0mr200645595e9.21.1790082800777;
 Tue, 22 Sep 2026 06:13:20 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:48 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-16-smostafa@google.com>
Subject: [PATCH v8 15/25] iommu/arm-smmu-v3-kvm: Add CMDQ functions
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
  these will be added with smmu_add_cmd_raw().

queue_space() is split out of queue_has_space() as it is going to
check the host shadow of the queue.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  14 ++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 118 ++++++++++++++++++
 2 files changed, 126 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 28efa733e796..d48bd9f272e1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1225,19 +1225,21 @@ int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
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
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index b26c21b595b4..38b8ecc5cc10 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -24,6 +24,41 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 
 #define cmdq_size(cmdq)	((1 << ((cmdq)->llq.max_n_shift)) * CMDQ_ENT_DWORDS * 8)
 
+static u32 timer_freq;
+
+static inline u64 hyp_clock_ns(void)
+{
+	return mul_u64_u32_div(__arch_counter_get_cntvct(), NSEC_PER_SEC, timer_freq);
+}
+
+#define ARM_SMMU_EL2_POLL_TIMEOUT_US	1000
+/*
+ * Wait until @cond is true, can use WFE, if polling on an SMMU and
+ * event that supports it.
+ * Return 0 on success, or -ETIMEDOUT
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
@@ -76,6 +111,85 @@ static int smmu_unshare_pages(phys_addr_t addr, size_t size)
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
@@ -197,6 +311,10 @@ static int smmu_init(void)
 	u64 pfn, nr_pages;
 	int ret;
 
+	timer_freq = read_sysreg(cntfrq_el0);
+	if (!timer_freq || timer_freq > NSEC_PER_SEC)
+		return -EINVAL;
+
 	kvm_hyp_arm_smmu_v3_smmus = kern_hyp_va(kvm_hyp_arm_smmu_v3_smmus);
 	pfn = hyp_virt_to_pfn(kvm_hyp_arm_smmu_v3_smmus);
 	nr_pages = smmu_arr_size >> PAGE_SHIFT;
-- 
2.55.0.1082.g2b9226bbc0-goog

