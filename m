Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6D0279DC0
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725227; cv=none; b=Xrv96uLn5gBp2K7hUWlel73ILZOMg1ZYlkmq2XRFX955Fe1laF/VKoOlma2QuOIS05yjgjdSnjileLSWTLgirXQdZxPGO7+38gtupMMQgQIzFDF+VSB4U4SQii1DvUXxtqSwvewvoSmOaLkgt+wpfC315SbXM0k/I0uRObL/XEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725227; c=relaxed/simple;
	bh=DrD+ZWwEDs+4UwwUfkGMP6kz9KBpszpo0hluoKvZc2s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gO2eqnAsW8Erl6ywXYV+V9Pjb9v7yy9e1zWxD36h8XiE0jKs9WfGzUDOnG48tncfgCb+n/7Lyd1EmyNWQWir3+3Gq/62iDndbOzTmkzUZijKPDjaVDwyqvtjZjD3g6EMkYYJWOi05AUSQixtJXR+MhWk1YRgirAxqucHzR7jgbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R35Y8VDA; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R35Y8VDA"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4588d178be2so750755e9.3
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725222; x=1754330022; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tt5m8i4QY0N1dfFhF7qHvvWc92n8Yu9ouTNwhUBFIh8=;
        b=R35Y8VDAnc7bV1V2bOwHDSHUV0jPEePZ8b8RnB0CmSPQfnp0n1JkwfmCqJBW+iZ2z9
         9lk0B9MYCmR15M3gVZ4Uvmbem7OJP/XMJJu63LE3xsC8dIsmUUfdPn4HIKmftgOHZ2qv
         FbX7xy5imwclrylypsc8DcAWy9NtM0k5td42j3ySS1PyG7ZGNMWBv/7LRmUYRxQM0q6f
         AyO21WjsV9rBG51MoeThVfAbr0KaIp0J0VRywq3wK0p5eodPHfQA9c2x4qfaI53mP7Qy
         SRIYEX9tqCHqRnTQssVuSulyLm52xt4E4jrtDpSD5fkarp1LxqyT+kVgPfCC36kLsH86
         i2sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725222; x=1754330022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tt5m8i4QY0N1dfFhF7qHvvWc92n8Yu9ouTNwhUBFIh8=;
        b=TRWSxsiv9khrMEKWAU6uR/5CydUIMu1hmImGakOYibJR5ZRTKfjSo3k5oUgc2ii9T5
         y0kOrOhSYfa9FS45a+hPkcIGGDOoNRieXDW7CZvRYj/4aSgCgd4B+gXshdDmOcbHri/B
         gsVnerY+XTSbc84TjVmdehypfp16dAbxc1i36IbkvBCA+n7wWvcZXMBrkiqzaW+d7mpY
         rV473YKQOWFyCMXGxf4e4AoqzW+sS84b7h87UNn1BUgSAgMhWIPx2W5ON/OLra8ltsBE
         DLbmTEpAt3vcp8I7qKcRRpE0boUeue+8zLos0dmJAm2VVaVaEsziugeEhgovvNv1jILF
         3cuA==
X-Forwarded-Encrypted: i=1; AJvYcCUJY3Yn75OUvOEOd293NPThb+EQm+zmezSnLF3MXbg2+TZvY6R4FkNkxzHzUxkTqnHnFdBcUjU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzt27VbouXMJONzplisgcUT46gJVGK8NxDIl+7nVQWn8m1P/QnL
	W78ljwOhvO+ll/2joauxS5qRRG2EwJJmEb0d7yn1li5dpfplFy78AMgjDIgOavieoRW/ubfg7Pa
	jk62UCstnzPhJRg==
X-Google-Smtp-Source: AGHT+IF8+izyk+caZjCV5IYrASgS5LYsOHMnHxHerMTimZGTVouHs7VB05sQiTCg3vY7AuqkXvZazJs9ITyX6g==
X-Received: from wmbep11.prod.google.com ([2002:a05:600c:840b:b0:453:5e1:c32e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c90:b0:456:1dd9:943 with SMTP id 5b1f17b1804b1-4588b9b1154mr24802245e9.3.1753725222476;
 Mon, 28 Jul 2025 10:53:42 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:52:59 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-13-smostafa@google.com>
Subject: [PATCH v3 12/29] iommu/arm-smmu-v3: Split cmdq code with hyp
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

The KVM SMMUv3 driver would re-use some of the cmdq code inside
the hypervisor, move these functions to a new common c file that
is shared between the host kernel and the hypervisor.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +-
 .../arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c  | 114 ++++++++++++++++
 .../arm/arm-smmu-v3/arm-smmu-v3-common.h      |  69 ++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 128 ------------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  38 ------
 5 files changed, 184 insertions(+), 167 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c

diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 0bc0c116b851..16be1249000a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
 arm_smmu_v3-y := arm-smmu-v3.o
-arm_smmu_v3-y += arm-smmu-v3-common.o
+arm_smmu_v3-y += arm-smmu-v3-common.o arm-smmu-v3-common-hyp.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_IOMMUFD) += arm-smmu-v3-iommufd.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c
new file mode 100644
index 000000000000..da41c5024a1c
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2015 ARM Limited
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ * Arm SMMUv3 driver functions shared with hypervisor.
+ */
+
+#include "arm-smmu-v3-common.h"
+#include <asm-generic/errno-base.h>
+
+#include <linux/string.h>
+
+int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
+{
+	memset(cmd, 0, 1 << CMDQ_ENT_SZ_SHIFT);
+	cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);
+
+	switch (ent->opcode) {
+	case CMDQ_OP_TLBI_EL2_ALL:
+	case CMDQ_OP_TLBI_NSNH_ALL:
+		break;
+	case CMDQ_OP_PREFETCH_CFG:
+		cmd[0] |= FIELD_PREP(CMDQ_PREFETCH_0_SID, ent->prefetch.sid);
+		break;
+	case CMDQ_OP_CFGI_CD:
+		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SSID, ent->cfgi.ssid);
+		fallthrough;
+	case CMDQ_OP_CFGI_STE:
+		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
+		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
+		break;
+	case CMDQ_OP_CFGI_CD_ALL:
+		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
+		break;
+	case CMDQ_OP_CFGI_ALL:
+		/* Cover the entire SID range */
+		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
+		break;
+	case CMDQ_OP_TLBI_NH_VA:
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
+		fallthrough;
+	case CMDQ_OP_TLBI_EL2_VA:
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, ent->tlbi.num);
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_SCALE, ent->tlbi.scale);
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
+		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
+		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TTL, ent->tlbi.ttl);
+		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TG, ent->tlbi.tg);
+		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_VA_MASK;
+		break;
+	case CMDQ_OP_TLBI_S2_IPA:
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, ent->tlbi.num);
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_SCALE, ent->tlbi.scale);
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
+		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
+		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TTL, ent->tlbi.ttl);
+		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TG, ent->tlbi.tg);
+		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_IPA_MASK;
+		break;
+	case CMDQ_OP_TLBI_NH_ASID:
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
+		fallthrough;
+	case CMDQ_OP_TLBI_NH_ALL:
+	case CMDQ_OP_TLBI_S12_VMALL:
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
+		break;
+	case CMDQ_OP_TLBI_EL2_ASID:
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
+		break;
+	case CMDQ_OP_ATC_INV:
+		cmd[0] |= FIELD_PREP(CMDQ_0_SSV, ent->substream_valid);
+		cmd[0] |= FIELD_PREP(CMDQ_ATC_0_GLOBAL, ent->atc.global);
+		cmd[0] |= FIELD_PREP(CMDQ_ATC_0_SSID, ent->atc.ssid);
+		cmd[0] |= FIELD_PREP(CMDQ_ATC_0_SID, ent->atc.sid);
+		cmd[1] |= FIELD_PREP(CMDQ_ATC_1_SIZE, ent->atc.size);
+		cmd[1] |= ent->atc.addr & CMDQ_ATC_1_ADDR_MASK;
+		break;
+	case CMDQ_OP_PRI_RESP:
+		cmd[0] |= FIELD_PREP(CMDQ_0_SSV, ent->substream_valid);
+		cmd[0] |= FIELD_PREP(CMDQ_PRI_0_SSID, ent->pri.ssid);
+		cmd[0] |= FIELD_PREP(CMDQ_PRI_0_SID, ent->pri.sid);
+		cmd[1] |= FIELD_PREP(CMDQ_PRI_1_GRPID, ent->pri.grpid);
+		switch (ent->pri.resp) {
+		case PRI_RESP_DENY:
+		case PRI_RESP_FAIL:
+		case PRI_RESP_SUCC:
+			break;
+		default:
+			return -EINVAL;
+		}
+		cmd[1] |= FIELD_PREP(CMDQ_PRI_1_RESP, ent->pri.resp);
+		break;
+	case CMDQ_OP_RESUME:
+		cmd[0] |= FIELD_PREP(CMDQ_RESUME_0_SID, ent->resume.sid);
+		cmd[0] |= FIELD_PREP(CMDQ_RESUME_0_RESP, ent->resume.resp);
+		cmd[1] |= FIELD_PREP(CMDQ_RESUME_1_STAG, ent->resume.stag);
+		break;
+	case CMDQ_OP_CMD_SYNC:
+		if (ent->sync.msiaddr) {
+			cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_IRQ);
+			cmd[1] |= ent->sync.msiaddr & CMDQ_SYNC_1_MSIADDR_MASK;
+		} else {
+			cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_SEV);
+		}
+		cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_MSH, ARM_SMMU_SH_ISH);
+		cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_MSIATTR, ARM_SMMU_MEMATTR_OIWB);
+		break;
+	default:
+		return -ENOENT;
+	}
+
+	return 0;
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.h
index 3bcb5d94f21a..f115ff9a547f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.h
@@ -4,6 +4,7 @@
 
 #include <linux/bits.h>
 #include <linux/bitfield.h>
+#include <linux/cache.h>
 
 /* MMIO registers */
 #define ARM_SMMU_IDR0			0x0
@@ -460,6 +461,44 @@ struct arm_smmu_cmdq_ent {
 #define ARM_SMMU_FEAT_HD		(1 << 22)
 #define ARM_SMMU_FEAT_S2FWB		(1 << 23)
 
+struct arm_smmu_ll_queue {
+	union {
+		u64			val;
+		struct {
+			u32		prod;
+			u32		cons;
+		};
+		struct {
+			atomic_t	prod;
+			atomic_t	cons;
+		} atomic;
+		u8			__pad[SMP_CACHE_BYTES];
+	} ____cacheline_aligned_in_smp;
+	u32				max_n_shift;
+};
+
+struct arm_smmu_queue {
+	struct arm_smmu_ll_queue	llq;
+	int				irq; /* Wired interrupt */
+
+	__le64				*base;
+	dma_addr_t			base_dma;
+	u64				q_base;
+
+	size_t				ent_dwords;
+
+	u32 __iomem			*prod_reg;
+	u32 __iomem			*cons_reg;
+};
+
+#define Q_IDX(llq, p)			((p) & ((1 << (llq)->max_n_shift) - 1))
+#define Q_WRP(llq, p)			((p) & (1 << (llq)->max_n_shift))
+#define Q_OVERFLOW_FLAG			(1U << 31)
+#define Q_OVF(p)			((p) & Q_OVERFLOW_FLAG)
+#define Q_ENT(q, p)			((q)->base +			\
+					 Q_IDX(&((q)->llq), p) *	\
+					 (q)->ent_dwords)
+
 static inline void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
 						 dma_addr_t l2ptr_dma)
 {
@@ -471,4 +510,34 @@ static inline void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
 	/* The HW has 64 bit atomicity with stores to the L2 STE table */
 	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
+
+int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent);
+
+
+/* Queue functions shared between kernel and hyp. */
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
+static inline void queue_write(__le64 *dst, u64 *src, size_t n_dwords)
+{
+	int i;
+
+	for (i = 0; i < n_dwords; ++i)
+		*dst++ = cpu_to_le64(*src++);
+}
 #endif /* _ARM_SMMU_V3_COMMON_H */
\ No newline at end of file
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8fbc7dd2a2db..066d9d9e8088 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -105,18 +105,6 @@ static bool queue_has_space(struct arm_smmu_ll_queue *q, u32 n)
 	return space >= n;
 }
 
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
@@ -172,12 +160,6 @@ static int queue_sync_prod_in(struct arm_smmu_queue *q)
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
@@ -205,14 +187,6 @@ static int queue_poll(struct arm_smmu_queue_poll *qp)
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
@@ -233,108 +207,6 @@ static int queue_remove_raw(struct arm_smmu_queue *q, u64 *ent)
 }
 
 /* High-level queue accessors */
-static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
-{
-	memset(cmd, 0, 1 << CMDQ_ENT_SZ_SHIFT);
-	cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);
-
-	switch (ent->opcode) {
-	case CMDQ_OP_TLBI_EL2_ALL:
-	case CMDQ_OP_TLBI_NSNH_ALL:
-		break;
-	case CMDQ_OP_PREFETCH_CFG:
-		cmd[0] |= FIELD_PREP(CMDQ_PREFETCH_0_SID, ent->prefetch.sid);
-		break;
-	case CMDQ_OP_CFGI_CD:
-		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SSID, ent->cfgi.ssid);
-		fallthrough;
-	case CMDQ_OP_CFGI_STE:
-		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
-		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
-		break;
-	case CMDQ_OP_CFGI_CD_ALL:
-		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
-		break;
-	case CMDQ_OP_CFGI_ALL:
-		/* Cover the entire SID range */
-		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
-		break;
-	case CMDQ_OP_TLBI_NH_VA:
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
-		fallthrough;
-	case CMDQ_OP_TLBI_EL2_VA:
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, ent->tlbi.num);
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_SCALE, ent->tlbi.scale);
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
-		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
-		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TTL, ent->tlbi.ttl);
-		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TG, ent->tlbi.tg);
-		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_VA_MASK;
-		break;
-	case CMDQ_OP_TLBI_S2_IPA:
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, ent->tlbi.num);
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_SCALE, ent->tlbi.scale);
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
-		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
-		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TTL, ent->tlbi.ttl);
-		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TG, ent->tlbi.tg);
-		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_IPA_MASK;
-		break;
-	case CMDQ_OP_TLBI_NH_ASID:
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
-		fallthrough;
-	case CMDQ_OP_TLBI_NH_ALL:
-	case CMDQ_OP_TLBI_S12_VMALL:
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
-		break;
-	case CMDQ_OP_TLBI_EL2_ASID:
-		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
-		break;
-	case CMDQ_OP_ATC_INV:
-		cmd[0] |= FIELD_PREP(CMDQ_0_SSV, ent->substream_valid);
-		cmd[0] |= FIELD_PREP(CMDQ_ATC_0_GLOBAL, ent->atc.global);
-		cmd[0] |= FIELD_PREP(CMDQ_ATC_0_SSID, ent->atc.ssid);
-		cmd[0] |= FIELD_PREP(CMDQ_ATC_0_SID, ent->atc.sid);
-		cmd[1] |= FIELD_PREP(CMDQ_ATC_1_SIZE, ent->atc.size);
-		cmd[1] |= ent->atc.addr & CMDQ_ATC_1_ADDR_MASK;
-		break;
-	case CMDQ_OP_PRI_RESP:
-		cmd[0] |= FIELD_PREP(CMDQ_0_SSV, ent->substream_valid);
-		cmd[0] |= FIELD_PREP(CMDQ_PRI_0_SSID, ent->pri.ssid);
-		cmd[0] |= FIELD_PREP(CMDQ_PRI_0_SID, ent->pri.sid);
-		cmd[1] |= FIELD_PREP(CMDQ_PRI_1_GRPID, ent->pri.grpid);
-		switch (ent->pri.resp) {
-		case PRI_RESP_DENY:
-		case PRI_RESP_FAIL:
-		case PRI_RESP_SUCC:
-			break;
-		default:
-			return -EINVAL;
-		}
-		cmd[1] |= FIELD_PREP(CMDQ_PRI_1_RESP, ent->pri.resp);
-		break;
-	case CMDQ_OP_RESUME:
-		cmd[0] |= FIELD_PREP(CMDQ_RESUME_0_SID, ent->resume.sid);
-		cmd[0] |= FIELD_PREP(CMDQ_RESUME_0_RESP, ent->resume.resp);
-		cmd[1] |= FIELD_PREP(CMDQ_RESUME_1_STAG, ent->resume.stag);
-		break;
-	case CMDQ_OP_CMD_SYNC:
-		if (ent->sync.msiaddr) {
-			cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_IRQ);
-			cmd[1] |= ent->sync.msiaddr & CMDQ_SYNC_1_MSIADDR_MASK;
-		} else {
-			cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_SEV);
-		}
-		cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_MSH, ARM_SMMU_SH_ISH);
-		cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_MSIATTR, ARM_SMMU_MEMATTR_OIWB);
-		break;
-	default:
-		return -ENOENT;
-	}
-
-	return 0;
-}
-
 static struct arm_smmu_cmdq *arm_smmu_get_cmdq(struct arm_smmu_device *smmu,
 					       struct arm_smmu_cmdq_ent *ent)
 {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e3c46b3344db..f9a496e0bd94 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -19,14 +19,6 @@ struct arm_smmu_device;
 
 #include "arm-smmu-v3-common.h"
 
-#define Q_IDX(llq, p)			((p) & ((1 << (llq)->max_n_shift) - 1))
-#define Q_WRP(llq, p)			((p) & (1 << (llq)->max_n_shift))
-#define Q_OVERFLOW_FLAG			(1U << 31)
-#define Q_OVF(p)			((p) & Q_OVERFLOW_FLAG)
-#define Q_ENT(q, p)			((q)->base +			\
-					 Q_IDX(&((q)->llq), p) *	\
-					 (q)->ent_dwords)
-
 /* Ensure DMA allocations are naturally aligned */
 #ifdef CONFIG_CMA_ALIGNMENT
 #define Q_MAX_SZ_SHIFT			(PAGE_SHIFT + CONFIG_CMA_ALIGNMENT)
@@ -162,36 +154,6 @@ static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
 #define MSI_IOVA_BASE			0x8000000
 #define MSI_IOVA_LENGTH			0x100000
 
-struct arm_smmu_ll_queue {
-	union {
-		u64			val;
-		struct {
-			u32		prod;
-			u32		cons;
-		};
-		struct {
-			atomic_t	prod;
-			atomic_t	cons;
-		} atomic;
-		u8			__pad[SMP_CACHE_BYTES];
-	} ____cacheline_aligned_in_smp;
-	u32				max_n_shift;
-};
-
-struct arm_smmu_queue {
-	struct arm_smmu_ll_queue	llq;
-	int				irq; /* Wired interrupt */
-
-	__le64				*base;
-	dma_addr_t			base_dma;
-	u64				q_base;
-
-	size_t				ent_dwords;
-
-	u32 __iomem			*prod_reg;
-	u32 __iomem			*cons_reg;
-};
-
 struct arm_smmu_queue_poll {
 	ktime_t				timeout;
 	unsigned int			delay;
-- 
2.50.1.552.g942d659e1b-goog

