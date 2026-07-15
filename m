Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8635E44C670
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116760; cv=none; b=IKgent+0PaL6Q0RRC2fQrMaERf1eleOIVDI+uu+1HVD51YW6QZuM6sXCUljUOQzQBwMqUl4L65a6g0JSaNDwc2f7QUuylWP+qrF6jcP8KQ8UubD3nN+8DjUP5JHRaiLmJ7DLvEDD14rL4YeRzLFmNtPPHuEPADoX5NRGxMlkDo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116760; c=relaxed/simple;
	bh=6CKFHoNklLN4PCvtNpy9VDBy22n6jqUSWu7UMjm+Lpo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Aqj/rgoomkriq6SpJSSY34ywMbhU52K44QLKNnpfMH/ZazpbNfhnpQUWPQYOkhud1D/gOXEMAEWD/Hn1gAHcheeZqPMSkciVDYl3MGweIwKz9P4Fbt7Ggziv5pQiizUycmPc6vGUPDAMK++N+zFTy7tHxPjd6VQ0a24ykEJF2u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ey1u3qyr; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ey1u3qyr"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493bdf90adaso19755685e9.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116757; x=1784721557; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KxyxCQ/BZUglxoL2L1s1Xxp7lH/IsK4WtW57NYwUHLs=;
        b=ey1u3qyrlYAOi00B8q6DSRNqDgTnNceTJlPmzYNYfTB0QfIwGEjElMpc+9YpOVISLk
         ic1FYWB1oYkSAOGA6wBW70AX+JhAQqaXKxMiPIdLzhTjzBKgi0NGCkXlICIFJknJnjbS
         vWrryQnsmkP8++adWFfx4jFwDMS5YTYMnmFaTcDMVSSGx40YGq8lCy1C8EvlmoNmZ1VV
         vHtreCNXLKq+obBUT/d+QQI5jZ0LrYRIeEtZGbvgSwfNL/ezGw0f9ZWEycXh0IqDGDrA
         cIlR8LSsr5x6NKFM/z3ez4i4CDrHNcJGvdBpHMT2HXT6rkbAcOG7qcsZ8d0raYtzBW/2
         bIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116757; x=1784721557;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KxyxCQ/BZUglxoL2L1s1Xxp7lH/IsK4WtW57NYwUHLs=;
        b=I3k2cJWWvBiiVZ1NuqMolEYRss9GEwgKz+ARShMRuHrDIqaZOG6LaumnNjr32vU1mp
         qtMQkQ9bBzKdoLKT1+AsjoFDLlWbXqdRmXB2nfb1oX2jjDRUL7JG4KPZa2pSASNRH8su
         9k/luQ/tA4pSue2bO6vGt4YVp5JTItzHc77HwEXkCK7wVYprS1ri2uOelnETtb33GJAS
         pHRmdlah+QUeOjaS2tQDptGa1c9xdxhUzMieB3eZfatgXnlJCQwWdDpKLX43v8I8FGG8
         KcmqKRhLpCyNUAZa3SEGd8/6+kQIgAg6cKDv3Mhz2mqh2rq6aLKiObbjtr6imJ2wz4nq
         aA6w==
X-Forwarded-Encrypted: i=1; AHgh+RproxOO1TsdMHuwg+vAjxCV9ZEJ0LjuLsSKUmgpuy9APlwGo1sReEhLt3rThf4LP06kyTFD4DI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyw8RTAfk7FvzJkTY/2NF4Gsl31zPSjmjIjh0ijtmqcOAA4EafB
	DiqT97mzUBGCVSytorBy5oRFGb1rKtrtp14Ks+0OkooklkDahOCDKShU+UrhZvgFoKTaFTp53hp
	Q7Fqyk91SEkCvvQ==
X-Received: from wmbez3.prod.google.com ([2002:a05:600c:83c3:b0:493:c274:1b7b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8496:10b0:492:5bb6:6d4b with SMTP id 5b1f17b1804b1-493f8833b6bmr131609825e9.34.1784116756444;
 Wed, 15 Jul 2026 04:59:16 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:58:44 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-4-smostafa@google.com>
Subject: [PATCH v7 03/24] iommu/arm-smmu-v3: Split code with hyp
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

The KVM SMMUv3 driver would re-use some of the cmdq and ste code
inside the hypervisor, move these functions to the header file that
is shared between the host kernel and the hypervisor.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 59 --------------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 60 +++++++++++++++++++++
 2 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a10affb483a4..2a2289d4a3f3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -125,33 +125,6 @@ static void parse_driver_options(struct arm_smmu_device *smmu)
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
@@ -170,12 +143,6 @@ static void queue_sync_cons_out(struct arm_smmu_queue *q)
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
@@ -207,12 +174,6 @@ static int queue_sync_prod_in(struct arm_smmu_queue *q)
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
@@ -240,14 +201,6 @@ static int queue_poll(struct arm_smmu_queue_poll *qp)
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
@@ -1731,18 +1684,6 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
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
index c909c9a88538..e93489841ec7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1212,6 +1212,66 @@ int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
 				struct arm_smmu_cmd *cmds, int n,
 				bool sync);
 
+/* Queue functions shared between kernel and hyp. */
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
+	return Q_OVF(q->prod) | Q_WRP(q, prod) | Q_IDX(q, prod);
+}
+
+static inline void queue_inc_cons(struct arm_smmu_ll_queue *q)
+{
+	u32 cons = (Q_WRP(q, q->cons) | Q_IDX(q, q->cons)) + 1;
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
2.55.0.141.g00534a21ce-goog

