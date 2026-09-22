Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E79754854A
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082789; cv=none; b=Bgxi2kX2p+U2ulgGwMon2Jq9C3uz66iiMQSXd5e19Cy6p8VoR7VMgHMoAp/1iP8CayWdZEJy7NefIe0a9cRNmCAfzJHl3tzfHzWxmHHh2axsgkm1GWD1K8yzNOXGPitbYbiSxYPFph33+2uNY3qenIq3dvM6a9dQXwXEsPr76kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082789; c=relaxed/simple;
	bh=ImvaN7ih0RgGhTcm6daKytkcWnpHm/4P/PAftljCqNI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Asg+y/ZeLe1NLujb0qNK7Q9U8dsygB4QVEYyiqIPG3bKH3dVHQCVEh5CrznzYAEaDqT2bkUWUpP/TlItwzWpCRivnmXwhz6QZg8E4qMIetIUKqZeQiplTZd2IFu5EdJi+O6GGBoiD+clqnzKtXF1AsG0ZenNk98h9rrLEXWKrSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d23kolWs; arc=none smtp.client-ip=209.85.218.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d23kolWs"
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c293bac1764so544746266b.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082785; x=1790687585; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bexUNSxBam2korKAft1V0IwAYD5mV084XIuY+GXhU+I=;
        b=d23kolWsu2Z2HygyQ6eya/XKfcZDfZtxuHc1Ir3IKCxt0r8F2kXr7Z7izvtrbE2YBl
         ZP7y+qUsDSlsX5P46eaUsnT8WG+kxECxyK42GAbLSf/bcIyHGb58sWt9MzsMy/F2mcW3
         j0R0P14KR6z0NJTk5X5cSMQWmmjiWCNXvC83BakLkqyS8nxGgO2O8jDujGUEA33M40FN
         W3In1ffrszwo26YjyJXayGxYoEW0qYJhzys726r496QvBGAeEs88msXxg5sBda9DgeHN
         0jwh/ARXtq49ZPoiMto6p6ebOoKAfXsGTMiQMS16lsRTsgyBxcCBxzy2ZEX9M+q+W5lx
         iUCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082785; x=1790687585;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bexUNSxBam2korKAft1V0IwAYD5mV084XIuY+GXhU+I=;
        b=0AXJmO2eVNVKpY1G8kF4g4VrN59teQnYxvdhWE9dbJnzSKJooQkGqyClEXrHCUQOS8
         szjbzvlKWqeTBpy06duAbf9CvqcbuviBZdLLxsgTa90cW8No+086Xlkq7WGBMAXzR0TR
         pXHJtlTgHVChhGi3lbM4Ejh1RkTMhpV9G0fRfOZsH54YyHg/I6Pza0Y5JtcdiqOQgZXR
         nd/b58fqL1/7kuO4xs1Gibo/NXk7ibnbsxlKed1nsYGNxrVb8LOdZ6EGvJpVJjQUOFBH
         ejRG9CdSpbIkt3Xj3TplKZodZ/uvANdTZp7WPZ3llJz9xHAzrU4innJ/ydaJm+2JZu7V
         Z8kQ==
X-Forwarded-Encrypted: i=1; AKwUvByVhIi4z8O7EblHvwgOv45vnqIaaWboV5lyUrJqi0avssdd9q8y/qWKsm+7t0wJSz6ay+gqb48=@lists.linux.dev
X-Gm-Message-State: AFuF++m25IZKTwNFwKGx2hbxD+hz5BAyqtWi9HVlXBMUiEJdnRVmNH3E
	v6+4/W+icnM1KTWulNimqth4gmJDEM5n9mD9CQbbX8Wa2nNuP/5xSDDJ3Oi3bn+gSE1jsKEqVnh
	aq8dcQZBiZK+4EA==
X-Received: from ejckb18.prod.google.com ([2002:a17:907:f92:b0:c2a:38b5:a9b1])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3e9f:b0:c29:f5d8:9c6f with SMTP id a640c23a62f3a-c2a15802e80mr1246416266b.30.1790082784771;
 Tue, 22 Sep 2026 06:13:04 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:35 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-3-smostafa@google.com>
Subject: [PATCH v8 02/25] iommu/arm-smmu-v3: Move Queue and STE functions to header
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

The KVM SMMUv3 driver would re-use some of the CMDQ and STE code
inside the hypervisor. Move those functions to the header file that
would be shared between the host kernel and the hypervisor.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 59 --------------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 62 +++++++++++++++++++++
 2 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5732f3ba0122..df1924969212 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -134,33 +134,6 @@ static void parse_driver_options(struct arm_smmu_device *smmu)
 }
 
 /* Low-level queue manipulation functions */
-static bool queue_has_space(struct arm_smmu_ll_queue *q, u32 n)
-{
-	u32 space, prod, cons;
-
-	prod = Q_IDX(q, q->prod);
-	cons = Q_IDX(q, q->cons);
-
-	if (Q_WRP(q, q->prod) == Q_WRP(q, q->cons))
-		space = (1 << q->max_n_shift) - (prod - cons);
-	else
-		space = cons - prod;
-
-	return space >= n;
-}
-
-static bool queue_full(struct arm_smmu_ll_queue *q)
-{
-	return Q_IDX(q, q->prod) == Q_IDX(q, q->cons) &&
-	       Q_WRP(q, q->prod) != Q_WRP(q, q->cons);
-}
-
-static bool queue_empty(struct arm_smmu_ll_queue *q)
-{
-	return Q_IDX(q, q->prod) == Q_IDX(q, q->cons) &&
-	       Q_WRP(q, q->prod) == Q_WRP(q, q->cons);
-}
-
 static bool queue_consumed(struct arm_smmu_ll_queue *q, u32 prod)
 {
 	return ((Q_WRP(q, q->cons) == Q_WRP(q, prod)) &&
@@ -179,12 +152,6 @@ static void queue_sync_cons_out(struct arm_smmu_queue *q)
 	writel_relaxed(q->llq.cons, q->cons_reg);
 }
 
-static void queue_inc_cons(struct arm_smmu_ll_queue *q)
-{
-	u32 cons = (Q_WRP(q, q->cons) | Q_IDX(q, q->cons)) + 1;
-	q->cons = Q_OVF(q->cons) | Q_WRP(q, cons) | Q_IDX(q, cons);
-}
-
 static void queue_sync_cons_ovf(struct arm_smmu_queue *q)
 {
 	struct arm_smmu_ll_queue *llq = &q->llq;
@@ -216,12 +183,6 @@ static int queue_sync_prod_in(struct arm_smmu_queue *q)
 	return ret;
 }
 
-static u32 queue_inc_prod_n(struct arm_smmu_ll_queue *q, int n)
-{
-	u32 prod = (Q_WRP(q, q->prod) | Q_IDX(q, q->prod)) + n;
-	return Q_OVF(q->prod) | Q_WRP(q, prod) | Q_IDX(q, prod);
-}
-
 static void queue_poll_init(struct arm_smmu_device *smmu,
 			    struct arm_smmu_queue_poll *qp)
 {
@@ -249,14 +210,6 @@ static int queue_poll(struct arm_smmu_queue_poll *qp)
 	return 0;
 }
 
-static void queue_write(__le64 *dst, u64 *src, size_t n_dwords)
-{
-	int i;
-
-	for (i = 0; i < n_dwords; ++i)
-		*dst++ = cpu_to_le64(*src++);
-}
-
 static void queue_read(u64 *dst, __le64 *src, size_t n_dwords)
 {
 	int i;
@@ -1796,18 +1749,6 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 }
 
 /* Stream table manipulation functions */
-static void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
-					  dma_addr_t l2ptr_dma)
-{
-	u64 val = 0;
-
-	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, STRTAB_SPLIT + 1);
-	val |= l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
-
-	/* The HW has 64 bit atomicity with stores to the L2 STE table */
-	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
-}
-
 struct arm_smmu_ste_writer {
 	struct arm_smmu_entry_writer writer;
 	u32 sid;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index dd2fee2f560e..5b23f6ee78d4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1223,6 +1223,68 @@ int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
 				bool sync);
 bool arm_smmu_erratum_repeat_tlbi_cfgi(void);
 
+/* Queue and STE functions shared between kernel and hyp. */
+static inline bool queue_has_space(struct arm_smmu_ll_queue *q, u32 n)
+{
+	u32 space, prod, cons;
+
+	prod = Q_IDX(q, q->prod);
+	cons = Q_IDX(q, q->cons);
+
+	if (Q_WRP(q, q->prod) == Q_WRP(q, q->cons))
+		space = (1 << q->max_n_shift) - (prod - cons);
+	else
+		space = cons - prod;
+
+	return space >= n;
+}
+
+static inline bool queue_full(struct arm_smmu_ll_queue *q)
+{
+	return Q_IDX(q, q->prod) == Q_IDX(q, q->cons) &&
+	       Q_WRP(q, q->prod) != Q_WRP(q, q->cons);
+}
+
+static inline bool queue_empty(struct arm_smmu_ll_queue *q)
+{
+	return Q_IDX(q, q->prod) == Q_IDX(q, q->cons) &&
+	       Q_WRP(q, q->prod) == Q_WRP(q, q->cons);
+}
+
+static inline u32 queue_inc_prod_n(struct arm_smmu_ll_queue *q, int n)
+{
+	u32 prod = (Q_WRP(q, q->prod) | Q_IDX(q, q->prod)) + n;
+
+	return Q_OVF(q->prod) | Q_WRP(q, prod) | Q_IDX(q, prod);
+}
+
+static inline void queue_inc_cons(struct arm_smmu_ll_queue *q)
+{
+	u32 cons = (Q_WRP(q, q->cons) | Q_IDX(q, q->cons)) + 1;
+
+	q->cons = Q_OVF(q->cons) | Q_WRP(q, cons) | Q_IDX(q, cons);
+}
+
+static inline void queue_write(__le64 *dst, u64 *src, size_t n_dwords)
+{
+	int i;
+
+	for (i = 0; i < n_dwords; ++i)
+		*dst++ = cpu_to_le64(*src++);
+}
+
+static inline void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
+						 dma_addr_t l2ptr_dma)
+{
+	u64 val = 0;
+
+	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, STRTAB_SPLIT + 1);
+	val |= l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
+
+	/* The HW has 64 bit atomicity with stores to the L2 STE table */
+	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
+}
+
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
 void arm_smmu_sva_notifier_synchronize(void);
-- 
2.55.0.1082.g2b9226bbc0-goog

