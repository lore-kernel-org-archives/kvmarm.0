Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1ED8330314
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405315; cv=none; b=Xm35kYjj2ZGQ4RGZHn5bw8trO87JvvXORg3nwjleoO66w5/szMMsp+0Zfa4iXofcSbxsW9vo22Si2eTfY2uQY5wPz8rTh2gH/erMzKPXEnwhUHboAi0LSblQbI2QNzrp7CXwaRpMZkJCN6bETQIetOuoMEzJLOp+LZec9etsEPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405315; c=relaxed/simple;
	bh=m0eyTKHGEnJ+4t3vyjA7YY2Y9ideYxvZxlB9Ql41BYc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n6ZjScEpGEfYjlMzR1zCBPFbzITEOXeMmcazTGi/ufYiiPdOFSWk7l5oV+BtbGw/QJnkrALBK7+0W+0l6V2CFUDayuwOFp9eCNYYUf6H6Gf2TyPGQ25P7tuSzvFwLiSu4r1/LHXpwEvUSZpkiYDZ2NOpt9rhzmb3ifVhxMvpTic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gUAZgTSL; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gUAZgTSL"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b736dc23d6eso296217166b.3
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405311; x=1764010111; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3riz6/OzFPZPFTsti7c+9X4sXSVC+UYKQKi4yNQptVI=;
        b=gUAZgTSLT5mL8RQ5XQw5KOUVYBhRqp6yQyHCiG7YejaqhgUN5XMLIL+5alm31fbAxk
         uZpuM8wH5M+3nerc86IzRbz6l1qUiEDzyqDWHnz+btxrTW3ab3Fki3aJU1BwXIw7IbRd
         svIEAGvdO1m36KvIxdPdI81ewzPn1fbN3RqBkI8PbEMhK9ik660GaTcv0IZS0vBMtMhY
         ojONEv0AM4HfJmoW83Zkb9vH30QQCAb+/2eBBVwoIdzESL5ESCUe/prws3yPhu/LKp6Q
         lEr8B46KHdZNM0RPRbxtfvMAHf73Sv4ibFRnc4I8Lmqf/oSCQcv1nGB7Os9ZhnmlGtNM
         /qpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405311; x=1764010111;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3riz6/OzFPZPFTsti7c+9X4sXSVC+UYKQKi4yNQptVI=;
        b=ovkoG9c0321f9LiPBE04Te0GJq1VaroMfcYtDYwnKFbZQM/os890SVLwsfuLo5wqZM
         hGBvItEjP9z2vBxu9m/dF4kY21Zikwh4npiH2gv+WfwN49snbOs7uz7771FeI1SX5E/l
         9wThBqx0WNDG/MI0ehy3IJoNGHn39c9SSSjETb6AoF16CMJnFqHcYSV/IAxuniEcPitD
         rvpSnZY2wteJRjv9Q7zse3q0HLTeAvdn/AEoL9z8+L30C6locMgnYj1aOy2NW2HPfN3e
         zFUrcUKM1IfndI8PgVxvwU+wgqGdjagQtfrEzOZlayID/S0uj9KTj7zvchaVjmoEyL6i
         4gZA==
X-Forwarded-Encrypted: i=1; AJvYcCUjGc+eBDd5pjnpWHOdKH+4C5dBB3WHgSpRF5a12wHuediVpbOnt1JW7YD3Z29ipoJI3ragRuM=@lists.linux.dev
X-Gm-Message-State: AOJu0YycZtQQIZwpNTQkCcZ7bh/zNUN4C0Z93TUbhbpsayMY6X92qnD9
	oRfgRdkRB/O4vZN4u/0kp4z4+BmMiE5xoLRIc2funDOwhkAWo57jHMvfwWNUqvrevKuc1fP3KUI
	AYtuR10cEO5cXzQ==
X-Google-Smtp-Source: AGHT+IHMHkpsTJge4qLXOrIez+lKfkrvSIzQtWv7dToHUpC0p8gFukjOOv6/08P6LsO19cn+GeMm7M+u5A4siw==
X-Received: from ejchw17.prod.google.com ([2002:a17:907:a0d1:b0:b73:7374:2f96])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:787:b0:b73:5f48:6159 with SMTP id a640c23a62f3a-b73678088e2mr1486327366b.5.1763405311192;
 Mon, 17 Nov 2025 10:48:31 -0800 (PST)
Date: Mon, 17 Nov 2025 18:47:52 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-6-smostafa@google.com>
Subject: [PATCH v5 05/27] iommu/arm-smmu-v3: Split code with hyp
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

The KVM SMMUv3 driver would re-use some of the cmdq code inside
the hypervisor, move these functions to a new common c file that
is shared between the host kernel and the hypervisor.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +-
 .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.c  | 114 +++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 161 ------------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  61 +++++++
 4 files changed, 176 insertions(+), 162 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c

diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 493a659cc66b..c9ce392e6d31 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
-arm_smmu_v3-y := arm-smmu-v3.o
+arm_smmu_v3-y := arm-smmu-v3.o arm-smmu-v3-common-lib.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_IOMMUFD) += arm-smmu-v3-iommufd.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
new file mode 100644
index 000000000000..62744c8548a8
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2015 ARM Limited
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ * Arm SMMUv3 driver functions shared with hypervisor.
+ */
+
+#include "arm-smmu-v3.h"
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
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a33fbd12a0dd..1497ffcd4555 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -123,33 +123,6 @@ static void parse_driver_options(struct arm_smmu_device *smmu)
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
@@ -168,12 +141,6 @@ static void queue_sync_cons_out(struct arm_smmu_queue *q)
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
@@ -205,12 +172,6 @@ static int queue_sync_prod_in(struct arm_smmu_queue *q)
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
@@ -238,14 +199,6 @@ static int queue_poll(struct arm_smmu_queue_poll *qp)
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
@@ -266,108 +219,6 @@ static int queue_remove_raw(struct arm_smmu_queue *q, u64 *ent)
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
@@ -1508,18 +1359,6 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
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
index ae23aacc3840..4aaf93945ee3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1010,6 +1010,67 @@ void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
 int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
 				struct arm_smmu_cmdq *cmdq, u64 *cmds, int n,
 				bool sync);
+int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent);
+
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
 
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
-- 
2.52.0.rc1.455.g30608eb744-goog

