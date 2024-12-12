Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F73223E8C
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026697; cv=none; b=dSyicMLoHZAW+1py2NgXbsOk+eZ9tx07A8ZqOW1nyZoIO+e3vSA5wXuGSwd11HS3ELoqkHUYbOFiwR2p4tkK2pKytHuSthm+GNIZTEId76u773mNmMp/F7HaRjS2WEp9HK1xKX/oNFjB/mmcQg828mIYnGlYPChtOK32s89OhBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026697; c=relaxed/simple;
	bh=LVDsJOfjrtbwhwPIRsuuBZbqne4YI1gYPyuwnmxYwAE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bJcPCHOM5zu6K3ArZFsXuYEmYA0BWAS6m6ueM/NWuWsHBTUPPelbbsWt2n+lf7Xqi9OiDtaWdiqEG3vPlwV9kV5aJeahEnB0v/epVdv/DBSFgIziuE2UF08jo6zG02v0hwFDXln0LopPSnVOdVvfG2QqV34Sx83tEYFt8v89s/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XQvM8xQN; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XQvM8xQN"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-436219070b4so5741315e9.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026692; x=1734631492; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O8dEykcVB5T9ygrig36D5xqeElM72SNIhLY33SlZy5o=;
        b=XQvM8xQNFrZPlPWNRJb/79aeeVzGzklW9+/YkbOkpoadySGisEovVCcvY9UHJTGgDN
         9MsdrNYfDDmWQZoQgmwnEALL7oqp7VOV7lWKU/Ld1+Nrp0pFdeQllw7qg1oYgZJe73wP
         x+W72Ie3xDc2MuVIvc5C1T6VBD7oYNlK7l3+P9HURrEWSP4u+axqeX4H+GM4pBi3Ekbv
         m+TRg32mKGsmOC/iy4bX5zo/Ol3ZHuE29lRGlKA/9wbSFQD/nIiOfAeUOaYGVNcObYkq
         Mwqfuo7vjSw0P4RJ38eE/l0o6q2iu9pouzRjus951NjdW71MpndZyG11nnbNjdDh2DEg
         9dHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026692; x=1734631492;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O8dEykcVB5T9ygrig36D5xqeElM72SNIhLY33SlZy5o=;
        b=dcDl9EEMz+BKKHpeQyWy7mCxzM4arB7BgH5l+9Yt31MaJwAmj3BstpvVrZ3TFqNJpA
         3+v4n02Tp1G0feEG26WZsBinEoAOynLBvPpNIf/iqO2AglQPU/yM0GM4LLdU86GJ0th7
         /au0oJ2LevkcOdZRtLOz+6InbNdBkAW35qcmDjBZhTCMmShn0jXv7BDq/5bPsAmqzo/M
         duurzwmRE0iLXzduYdfnjvmTquqMF2q4dclthPbo2BIKmLYQ1v1YUzC5JqziFZiRLc91
         VbVQeToCola2GyEtC/vTSZEXJbLsa1q4zaCJBVtxV1HqqPVeQf4P33/jmL5N6527MN0n
         0V0A==
X-Forwarded-Encrypted: i=1; AJvYcCV8qskSgQe7mlAmim+6F3yesvzofcqbu8qGsdBHvIG3F++gnIN+Ftv80hYsjzhsZ0lkTSwlZG4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwiaWQXRFxwWVjNdwsTu2e9OFfHKG/r8+9rXHVA+pKBrEzK76cK
	WYF+U3ui7c3LzloyylUUKjGmcHIXC6Au4ww0geECrO435nqGUWsOHfq7IEF+q8RAPfiIrtauKWS
	nvo4nt84Qrg==
X-Google-Smtp-Source: AGHT+IGOxHT/qVynEpiDA1QXj6yVl3Iwd7eJKD0IdwMDSFLkzEgYk/lDv4hFby7sfUfW42vxIPOIRkNLJXEDVw==
X-Received: from wmok7.prod.google.com ([2002:a05:600c:4787:b0:434:fb78:6216])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b09:b0:436:1b7a:c0b4 with SMTP id 5b1f17b1804b1-4361c3454dbmr64160055e9.1.1734026692209;
 Thu, 12 Dec 2024 10:04:52 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:28 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-5-smostafa@google.com>
Subject: [RFC PATCH v2 04/58] iommu/arm-smmu-v3: Move some definitions to
 arm64 include/
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

So that the KVM SMMUv3 driver can re-use architectural definitions,
command structures and feature bits, move them to the arm64 include/

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/arm-smmu-v3-common.h | 547 ++++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 540 +------------------
 2 files changed, 549 insertions(+), 538 deletions(-)
 create mode 100644 arch/arm64/include/asm/arm-smmu-v3-common.h

diff --git a/arch/arm64/include/asm/arm-smmu-v3-common.h b/arch/arm64/include/asm/arm-smmu-v3-common.h
new file mode 100644
index 000000000000..e6e339248816
--- /dev/null
+++ b/arch/arm64/include/asm/arm-smmu-v3-common.h
@@ -0,0 +1,547 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ARM_SMMU_V3_COMMON_H
+#define _ARM_SMMU_V3_COMMON_H
+
+#include <linux/bitfield.h>
+
+/* MMIO registers */
+#define ARM_SMMU_IDR0			0x0
+#define IDR0_ST_LVL			GENMASK(28, 27)
+#define IDR0_ST_LVL_2LVL		1
+#define IDR0_STALL_MODEL		GENMASK(25, 24)
+#define IDR0_STALL_MODEL_STALL		0
+#define IDR0_STALL_MODEL_FORCE		2
+#define IDR0_TTENDIAN			GENMASK(22, 21)
+#define IDR0_TTENDIAN_MIXED		0
+#define IDR0_TTENDIAN_LE		2
+#define IDR0_TTENDIAN_BE		3
+#define IDR0_CD2L			(1 << 19)
+#define IDR0_VMID16			(1 << 18)
+#define IDR0_PRI			(1 << 16)
+#define IDR0_SEV			(1 << 14)
+#define IDR0_MSI			(1 << 13)
+#define IDR0_ASID16			(1 << 12)
+#define IDR0_ATS			(1 << 10)
+#define IDR0_HYP			(1 << 9)
+#define IDR0_HTTU			GENMASK(7, 6)
+#define IDR0_HTTU_ACCESS		1
+#define IDR0_HTTU_ACCESS_DIRTY		2
+#define IDR0_COHACC			(1 << 4)
+#define IDR0_TTF			GENMASK(3, 2)
+#define IDR0_TTF_AARCH64		2
+#define IDR0_TTF_AARCH32_64		3
+#define IDR0_S1P			(1 << 1)
+#define IDR0_S2P			(1 << 0)
+
+#define ARM_SMMU_IDR1			0x4
+#define IDR1_TABLES_PRESET		(1 << 30)
+#define IDR1_QUEUES_PRESET		(1 << 29)
+#define IDR1_REL			(1 << 28)
+#define IDR1_ATTR_TYPES_OVR		(1 << 27)
+#define IDR1_CMDQS			GENMASK(25, 21)
+#define IDR1_EVTQS			GENMASK(20, 16)
+#define IDR1_PRIQS			GENMASK(15, 11)
+#define IDR1_SSIDSIZE			GENMASK(10, 6)
+#define IDR1_SIDSIZE			GENMASK(5, 0)
+
+#define ARM_SMMU_IDR3			0xc
+#define IDR3_RIL			(1 << 10)
+
+#define ARM_SMMU_IDR5			0x14
+#define IDR5_STALL_MAX			GENMASK(31, 16)
+#define IDR5_GRAN64K			(1 << 6)
+#define IDR5_GRAN16K			(1 << 5)
+#define IDR5_GRAN4K			(1 << 4)
+#define IDR5_OAS			GENMASK(2, 0)
+#define IDR5_OAS_32_BIT			0
+#define IDR5_OAS_36_BIT			1
+#define IDR5_OAS_40_BIT			2
+#define IDR5_OAS_42_BIT			3
+#define IDR5_OAS_44_BIT			4
+#define IDR5_OAS_48_BIT			5
+#define IDR5_OAS_52_BIT			6
+#define IDR5_VAX			GENMASK(11, 10)
+#define IDR5_VAX_52_BIT			1
+
+#define ARM_SMMU_IIDR			0x18
+#define IIDR_PRODUCTID			GENMASK(31, 20)
+#define IIDR_VARIANT			GENMASK(19, 16)
+#define IIDR_REVISION			GENMASK(15, 12)
+#define IIDR_IMPLEMENTER		GENMASK(11, 0)
+
+#define ARM_SMMU_CR0			0x20
+#define CR0_ATSCHK			(1 << 4)
+#define CR0_CMDQEN			(1 << 3)
+#define CR0_EVTQEN			(1 << 2)
+#define CR0_PRIQEN			(1 << 1)
+#define CR0_SMMUEN			(1 << 0)
+
+#define ARM_SMMU_CR0ACK			0x24
+
+#define ARM_SMMU_CR1			0x28
+#define CR1_TABLE_SH			GENMASK(11, 10)
+#define CR1_TABLE_OC			GENMASK(9, 8)
+#define CR1_TABLE_IC			GENMASK(7, 6)
+#define CR1_QUEUE_SH			GENMASK(5, 4)
+#define CR1_QUEUE_OC			GENMASK(3, 2)
+#define CR1_QUEUE_IC			GENMASK(1, 0)
+/* CR1 cacheability fields don't quite follow the usual TCR-style encoding */
+#define CR1_CACHE_NC			0
+#define CR1_CACHE_WB			1
+#define CR1_CACHE_WT			2
+
+#define ARM_SMMU_CR2			0x2c
+#define CR2_PTM				(1 << 2)
+#define CR2_RECINVSID			(1 << 1)
+#define CR2_E2H				(1 << 0)
+
+#define ARM_SMMU_GBPA			0x44
+#define GBPA_UPDATE			(1 << 31)
+#define GBPA_ABORT			(1 << 20)
+
+#define ARM_SMMU_IRQ_CTRL		0x50
+#define IRQ_CTRL_EVTQ_IRQEN		(1 << 2)
+#define IRQ_CTRL_PRIQ_IRQEN		(1 << 1)
+#define IRQ_CTRL_GERROR_IRQEN		(1 << 0)
+
+#define ARM_SMMU_IRQ_CTRLACK		0x54
+
+#define ARM_SMMU_GERROR			0x60
+#define GERROR_SFM_ERR			(1 << 8)
+#define GERROR_MSI_GERROR_ABT_ERR	(1 << 7)
+#define GERROR_MSI_PRIQ_ABT_ERR		(1 << 6)
+#define GERROR_MSI_EVTQ_ABT_ERR		(1 << 5)
+#define GERROR_MSI_CMDQ_ABT_ERR		(1 << 4)
+#define GERROR_PRIQ_ABT_ERR		(1 << 3)
+#define GERROR_EVTQ_ABT_ERR		(1 << 2)
+#define GERROR_CMDQ_ERR			(1 << 0)
+#define GERROR_ERR_MASK			0x1fd
+
+#define ARM_SMMU_GERRORN		0x64
+
+#define ARM_SMMU_GERROR_IRQ_CFG0	0x68
+#define ARM_SMMU_GERROR_IRQ_CFG1	0x70
+#define ARM_SMMU_GERROR_IRQ_CFG2	0x74
+
+#define ARM_SMMU_STRTAB_BASE		0x80
+#define STRTAB_BASE_RA			(1UL << 62)
+#define STRTAB_BASE_ADDR_MASK		GENMASK_ULL(51, 6)
+
+#define ARM_SMMU_STRTAB_BASE_CFG	0x88
+#define STRTAB_BASE_CFG_FMT		GENMASK(17, 16)
+#define STRTAB_BASE_CFG_FMT_LINEAR	0
+#define STRTAB_BASE_CFG_FMT_2LVL	1
+#define STRTAB_BASE_CFG_SPLIT		GENMASK(10, 6)
+#define STRTAB_BASE_CFG_LOG2SIZE	GENMASK(5, 0)
+
+#define ARM_SMMU_CMDQ_BASE		0x90
+#define ARM_SMMU_CMDQ_PROD		0x98
+#define ARM_SMMU_CMDQ_CONS		0x9c
+
+#define ARM_SMMU_EVTQ_BASE		0xa0
+#define ARM_SMMU_EVTQ_PROD		0xa8
+#define ARM_SMMU_EVTQ_CONS		0xac
+#define ARM_SMMU_EVTQ_IRQ_CFG0		0xb0
+#define ARM_SMMU_EVTQ_IRQ_CFG1		0xb8
+#define ARM_SMMU_EVTQ_IRQ_CFG2		0xbc
+
+#define ARM_SMMU_PRIQ_BASE		0xc0
+#define ARM_SMMU_PRIQ_PROD		0xc8
+#define ARM_SMMU_PRIQ_CONS		0xcc
+#define ARM_SMMU_PRIQ_IRQ_CFG0		0xd0
+#define ARM_SMMU_PRIQ_IRQ_CFG1		0xd8
+#define ARM_SMMU_PRIQ_IRQ_CFG2		0xdc
+
+#define ARM_SMMU_REG_SZ			0xe00
+
+/* Common MSI config fields */
+#define MSI_CFG0_ADDR_MASK		GENMASK_ULL(51, 2)
+#define MSI_CFG2_SH			GENMASK(5, 4)
+#define MSI_CFG2_MEMATTR		GENMASK(3, 0)
+
+/* Common memory attribute values */
+#define ARM_SMMU_SH_NSH			0
+#define ARM_SMMU_SH_OSH			2
+#define ARM_SMMU_SH_ISH			3
+#define ARM_SMMU_MEMATTR_DEVICE_nGnRE	0x1
+#define ARM_SMMU_MEMATTR_OIWB		0xf
+
+#define Q_BASE_RWA			(1UL << 62)
+#define Q_BASE_ADDR_MASK		GENMASK_ULL(51, 5)
+#define Q_BASE_LOG2SIZE			GENMASK(4, 0)
+
+/*
+ * Stream table.
+ *
+ * Linear: Enough to cover 1 << IDR1.SIDSIZE entries
+ * 2lvl: 128k L1 entries,
+ *       256 lazy entries per table (each table covers a PCI bus)
+ */
+#define STRTAB_SPLIT			8
+
+#define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
+#define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
+
+#define STRTAB_STE_DWORDS		8
+
+struct arm_smmu_ste {
+	__le64 data[STRTAB_STE_DWORDS];
+};
+
+#define STRTAB_NUM_L2_STES		(1 << STRTAB_SPLIT)
+struct arm_smmu_strtab_l2 {
+	struct arm_smmu_ste stes[STRTAB_NUM_L2_STES];
+};
+
+struct arm_smmu_strtab_l1 {
+	__le64 l2ptr;
+};
+#define STRTAB_MAX_L1_ENTRIES		(1 << 17)
+
+static inline u32 arm_smmu_strtab_l1_idx(u32 sid)
+{
+	return sid / STRTAB_NUM_L2_STES;
+}
+
+static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
+{
+	return sid % STRTAB_NUM_L2_STES;
+}
+
+#define STRTAB_STE_0_V			(1UL << 0)
+#define STRTAB_STE_0_CFG		GENMASK_ULL(3, 1)
+#define STRTAB_STE_0_CFG_ABORT		0
+#define STRTAB_STE_0_CFG_BYPASS		4
+#define STRTAB_STE_0_CFG_S1_TRANS	5
+#define STRTAB_STE_0_CFG_S2_TRANS	6
+
+#define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
+#define STRTAB_STE_0_S1FMT_LINEAR	0
+#define STRTAB_STE_0_S1FMT_64K_L2	2
+#define STRTAB_STE_0_S1CTXPTR_MASK	GENMASK_ULL(51, 6)
+#define STRTAB_STE_0_S1CDMAX		GENMASK_ULL(63, 59)
+
+#define STRTAB_STE_1_S1DSS		GENMASK_ULL(1, 0)
+#define STRTAB_STE_1_S1DSS_TERMINATE	0x0
+#define STRTAB_STE_1_S1DSS_BYPASS	0x1
+#define STRTAB_STE_1_S1DSS_SSID0	0x2
+
+#define STRTAB_STE_1_S1C_CACHE_NC	0UL
+#define STRTAB_STE_1_S1C_CACHE_WBRA	1UL
+#define STRTAB_STE_1_S1C_CACHE_WT	2UL
+#define STRTAB_STE_1_S1C_CACHE_WB	3UL
+#define STRTAB_STE_1_S1CIR		GENMASK_ULL(3, 2)
+#define STRTAB_STE_1_S1COR		GENMASK_ULL(5, 4)
+#define STRTAB_STE_1_S1CSH		GENMASK_ULL(7, 6)
+
+#define STRTAB_STE_1_S1STALLD		(1UL << 27)
+
+#define STRTAB_STE_1_EATS		GENMASK_ULL(29, 28)
+#define STRTAB_STE_1_EATS_ABT		0UL
+#define STRTAB_STE_1_EATS_TRANS		1UL
+#define STRTAB_STE_1_EATS_S1CHK		2UL
+
+#define STRTAB_STE_1_STRW		GENMASK_ULL(31, 30)
+#define STRTAB_STE_1_STRW_NSEL1		0UL
+#define STRTAB_STE_1_STRW_EL2		2UL
+
+#define STRTAB_STE_1_SHCFG		GENMASK_ULL(45, 44)
+#define STRTAB_STE_1_SHCFG_INCOMING	1UL
+
+#define STRTAB_STE_2_S2VMID		GENMASK_ULL(15, 0)
+#define STRTAB_STE_2_VTCR		GENMASK_ULL(50, 32)
+#define STRTAB_STE_2_VTCR_S2T0SZ	GENMASK_ULL(5, 0)
+#define STRTAB_STE_2_VTCR_S2SL0		GENMASK_ULL(7, 6)
+#define STRTAB_STE_2_VTCR_S2IR0		GENMASK_ULL(9, 8)
+#define STRTAB_STE_2_VTCR_S2OR0		GENMASK_ULL(11, 10)
+#define STRTAB_STE_2_VTCR_S2SH0		GENMASK_ULL(13, 12)
+#define STRTAB_STE_2_VTCR_S2TG		GENMASK_ULL(15, 14)
+#define STRTAB_STE_2_VTCR_S2PS		GENMASK_ULL(18, 16)
+#define STRTAB_STE_2_S2AA64		(1UL << 51)
+#define STRTAB_STE_2_S2ENDI		(1UL << 52)
+#define STRTAB_STE_2_S2PTW		(1UL << 54)
+#define STRTAB_STE_2_S2S		(1UL << 57)
+#define STRTAB_STE_2_S2R		(1UL << 58)
+
+#define STRTAB_STE_3_S2TTB_MASK		GENMASK_ULL(51, 4)
+
+/*
+ * Context descriptors.
+ *
+ * Linear: when less than 1024 SSIDs are supported
+ * 2lvl: at most 1024 L1 entries,
+ *       1024 lazy entries per table.
+ */
+#define CTXDESC_L2_ENTRIES		1024
+
+#define CTXDESC_L1_DESC_V		(1UL << 0)
+#define CTXDESC_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 12)
+
+#define CTXDESC_CD_DWORDS		8
+
+struct arm_smmu_cd {
+	__le64 data[CTXDESC_CD_DWORDS];
+};
+
+struct arm_smmu_cdtab_l2 {
+	struct arm_smmu_cd cds[CTXDESC_L2_ENTRIES];
+};
+
+struct arm_smmu_cdtab_l1 {
+	__le64 l2ptr;
+};
+
+static inline unsigned int arm_smmu_cdtab_l1_idx(unsigned int ssid)
+{
+	return ssid / CTXDESC_L2_ENTRIES;
+}
+
+static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
+{
+	return ssid % CTXDESC_L2_ENTRIES;
+}
+
+#define CTXDESC_CD_0_TCR_T0SZ		GENMASK_ULL(5, 0)
+#define CTXDESC_CD_0_TCR_TG0		GENMASK_ULL(7, 6)
+#define CTXDESC_CD_0_TCR_IRGN0		GENMASK_ULL(9, 8)
+#define CTXDESC_CD_0_TCR_ORGN0		GENMASK_ULL(11, 10)
+#define CTXDESC_CD_0_TCR_SH0		GENMASK_ULL(13, 12)
+#define CTXDESC_CD_0_TCR_EPD0		(1ULL << 14)
+#define CTXDESC_CD_0_TCR_EPD1		(1ULL << 30)
+
+#define CTXDESC_CD_0_ENDI		(1UL << 15)
+#define CTXDESC_CD_0_V			(1UL << 31)
+
+#define CTXDESC_CD_0_TCR_IPS		GENMASK_ULL(34, 32)
+#define CTXDESC_CD_0_TCR_TBI0		(1ULL << 38)
+
+#define CTXDESC_CD_0_TCR_HA            (1UL << 43)
+#define CTXDESC_CD_0_TCR_HD            (1UL << 42)
+
+#define CTXDESC_CD_0_AA64		(1UL << 41)
+#define CTXDESC_CD_0_S			(1UL << 44)
+#define CTXDESC_CD_0_R			(1UL << 45)
+#define CTXDESC_CD_0_A			(1UL << 46)
+#define CTXDESC_CD_0_ASET		(1UL << 47)
+#define CTXDESC_CD_0_ASID		GENMASK_ULL(63, 48)
+
+#define CTXDESC_CD_1_TTB0_MASK		GENMASK_ULL(51, 4)
+
+/*
+ * When the SMMU only supports linear context descriptor tables, pick a
+ * reasonable size limit (64kB).
+ */
+#define CTXDESC_LINEAR_CDMAX		ilog2(SZ_64K / sizeof(struct arm_smmu_cd))
+
+/* Command queue */
+#define CMDQ_ENT_SZ_SHIFT		4
+#define CMDQ_ENT_DWORDS			((1 << CMDQ_ENT_SZ_SHIFT) >> 3)
+#define CMDQ_MAX_SZ_SHIFT		(Q_MAX_SZ_SHIFT - CMDQ_ENT_SZ_SHIFT)
+
+#define CMDQ_CONS_ERR			GENMASK(30, 24)
+#define CMDQ_ERR_CERROR_NONE_IDX	0
+#define CMDQ_ERR_CERROR_ILL_IDX		1
+#define CMDQ_ERR_CERROR_ABT_IDX		2
+#define CMDQ_ERR_CERROR_ATC_INV_IDX	3
+
+#define CMDQ_0_OP			GENMASK_ULL(7, 0)
+#define CMDQ_0_SSV			(1UL << 11)
+
+#define CMDQ_PREFETCH_0_SID		GENMASK_ULL(63, 32)
+#define CMDQ_PREFETCH_1_SIZE		GENMASK_ULL(4, 0)
+#define CMDQ_PREFETCH_1_ADDR_MASK	GENMASK_ULL(63, 12)
+
+#define CMDQ_CFGI_0_SSID		GENMASK_ULL(31, 12)
+#define CMDQ_CFGI_0_SID			GENMASK_ULL(63, 32)
+#define CMDQ_CFGI_1_LEAF		(1UL << 0)
+#define CMDQ_CFGI_1_RANGE		GENMASK_ULL(4, 0)
+
+#define CMDQ_TLBI_0_NUM			GENMASK_ULL(16, 12)
+#define CMDQ_TLBI_RANGE_NUM_MAX		31
+#define CMDQ_TLBI_0_SCALE		GENMASK_ULL(24, 20)
+#define CMDQ_TLBI_0_VMID		GENMASK_ULL(47, 32)
+#define CMDQ_TLBI_0_ASID		GENMASK_ULL(63, 48)
+#define CMDQ_TLBI_1_LEAF		(1UL << 0)
+#define CMDQ_TLBI_1_TTL			GENMASK_ULL(9, 8)
+#define CMDQ_TLBI_1_TG			GENMASK_ULL(11, 10)
+#define CMDQ_TLBI_1_VA_MASK		GENMASK_ULL(63, 12)
+#define CMDQ_TLBI_1_IPA_MASK		GENMASK_ULL(51, 12)
+
+#define CMDQ_ATC_0_SSID			GENMASK_ULL(31, 12)
+#define CMDQ_ATC_0_SID			GENMASK_ULL(63, 32)
+#define CMDQ_ATC_0_GLOBAL		(1UL << 9)
+#define CMDQ_ATC_1_SIZE			GENMASK_ULL(5, 0)
+#define CMDQ_ATC_1_ADDR_MASK		GENMASK_ULL(63, 12)
+
+#define CMDQ_PRI_0_SSID			GENMASK_ULL(31, 12)
+#define CMDQ_PRI_0_SID			GENMASK_ULL(63, 32)
+#define CMDQ_PRI_1_GRPID		GENMASK_ULL(8, 0)
+#define CMDQ_PRI_1_RESP			GENMASK_ULL(13, 12)
+
+#define CMDQ_RESUME_0_RESP_TERM		0UL
+#define CMDQ_RESUME_0_RESP_RETRY	1UL
+#define CMDQ_RESUME_0_RESP_ABORT	2UL
+#define CMDQ_RESUME_0_RESP		GENMASK_ULL(13, 12)
+#define CMDQ_RESUME_0_SID		GENMASK_ULL(63, 32)
+#define CMDQ_RESUME_1_STAG		GENMASK_ULL(15, 0)
+
+#define CMDQ_SYNC_0_CS			GENMASK_ULL(13, 12)
+#define CMDQ_SYNC_0_CS_NONE		0
+#define CMDQ_SYNC_0_CS_IRQ		1
+#define CMDQ_SYNC_0_CS_SEV		2
+#define CMDQ_SYNC_0_MSH			GENMASK_ULL(23, 22)
+#define CMDQ_SYNC_0_MSIATTR		GENMASK_ULL(27, 24)
+#define CMDQ_SYNC_0_MSIDATA		GENMASK_ULL(63, 32)
+#define CMDQ_SYNC_1_MSIADDR_MASK	GENMASK_ULL(51, 2)
+
+/* Event queue */
+#define EVTQ_ENT_SZ_SHIFT		5
+#define EVTQ_ENT_DWORDS			((1 << EVTQ_ENT_SZ_SHIFT) >> 3)
+#define EVTQ_MAX_SZ_SHIFT		(Q_MAX_SZ_SHIFT - EVTQ_ENT_SZ_SHIFT)
+
+#define EVTQ_0_ID			GENMASK_ULL(7, 0)
+
+#define EVT_ID_TRANSLATION_FAULT	0x10
+#define EVT_ID_ADDR_SIZE_FAULT		0x11
+#define EVT_ID_ACCESS_FAULT		0x12
+#define EVT_ID_PERMISSION_FAULT		0x13
+
+#define EVTQ_0_SSV			(1UL << 11)
+#define EVTQ_0_SSID			GENMASK_ULL(31, 12)
+#define EVTQ_0_SID			GENMASK_ULL(63, 32)
+#define EVTQ_1_STAG			GENMASK_ULL(15, 0)
+#define EVTQ_1_STALL			(1UL << 31)
+#define EVTQ_1_PnU			(1UL << 33)
+#define EVTQ_1_InD			(1UL << 34)
+#define EVTQ_1_RnW			(1UL << 35)
+#define EVTQ_1_S2			(1UL << 39)
+#define EVTQ_1_CLASS			GENMASK_ULL(41, 40)
+#define EVTQ_1_TT_READ			(1UL << 44)
+#define EVTQ_2_ADDR			GENMASK_ULL(63, 0)
+#define EVTQ_3_IPA			GENMASK_ULL(51, 12)
+
+/* PRI queue */
+#define PRIQ_ENT_SZ_SHIFT		4
+#define PRIQ_ENT_DWORDS			((1 << PRIQ_ENT_SZ_SHIFT) >> 3)
+#define PRIQ_MAX_SZ_SHIFT		(Q_MAX_SZ_SHIFT - PRIQ_ENT_SZ_SHIFT)
+
+#define PRIQ_0_SID			GENMASK_ULL(31, 0)
+#define PRIQ_0_SSID			GENMASK_ULL(51, 32)
+#define PRIQ_0_PERM_PRIV		(1UL << 58)
+#define PRIQ_0_PERM_EXEC		(1UL << 59)
+#define PRIQ_0_PERM_READ		(1UL << 60)
+#define PRIQ_0_PERM_WRITE		(1UL << 61)
+#define PRIQ_0_PRG_LAST			(1UL << 62)
+#define PRIQ_0_SSID_V			(1UL << 63)
+
+#define PRIQ_1_PRG_IDX			GENMASK_ULL(8, 0)
+#define PRIQ_1_ADDR_MASK		GENMASK_ULL(63, 12)
+
+/* Synthesized features */
+#define ARM_SMMU_FEAT_2_LVL_STRTAB	(1 << 0)
+#define ARM_SMMU_FEAT_2_LVL_CDTAB	(1 << 1)
+#define ARM_SMMU_FEAT_TT_LE		(1 << 2)
+#define ARM_SMMU_FEAT_TT_BE		(1 << 3)
+#define ARM_SMMU_FEAT_PRI		(1 << 4)
+#define ARM_SMMU_FEAT_ATS		(1 << 5)
+#define ARM_SMMU_FEAT_SEV		(1 << 6)
+#define ARM_SMMU_FEAT_MSI		(1 << 7)
+#define ARM_SMMU_FEAT_COHERENCY		(1 << 8)
+#define ARM_SMMU_FEAT_TRANS_S1		(1 << 9)
+#define ARM_SMMU_FEAT_TRANS_S2		(1 << 10)
+#define ARM_SMMU_FEAT_STALLS		(1 << 11)
+#define ARM_SMMU_FEAT_HYP		(1 << 12)
+#define ARM_SMMU_FEAT_STALL_FORCE	(1 << 13)
+#define ARM_SMMU_FEAT_VAX		(1 << 14)
+#define ARM_SMMU_FEAT_RANGE_INV		(1 << 15)
+#define ARM_SMMU_FEAT_BTM		(1 << 16)
+#define ARM_SMMU_FEAT_SVA		(1 << 17)
+#define ARM_SMMU_FEAT_E2H		(1 << 18)
+#define ARM_SMMU_FEAT_NESTING		(1 << 19)
+#define ARM_SMMU_FEAT_ATTR_TYPES_OVR	(1 << 20)
+#define ARM_SMMU_FEAT_HA		(1 << 21)
+#define ARM_SMMU_FEAT_HD		(1 << 22)
+
+enum pri_resp {
+	PRI_RESP_DENY = 0,
+	PRI_RESP_FAIL = 1,
+	PRI_RESP_SUCC = 2,
+};
+
+struct arm_smmu_cmdq_ent {
+	/* Common fields */
+	u8				opcode;
+	bool				substream_valid;
+
+	/* Command-specific fields */
+	union {
+		#define CMDQ_OP_PREFETCH_CFG	0x1
+		struct {
+			u32			sid;
+		} prefetch;
+
+		#define CMDQ_OP_CFGI_STE	0x3
+		#define CMDQ_OP_CFGI_ALL	0x4
+		#define CMDQ_OP_CFGI_CD		0x5
+		#define CMDQ_OP_CFGI_CD_ALL	0x6
+		struct {
+			u32			sid;
+			u32			ssid;
+			union {
+				bool		leaf;
+				u8		span;
+			};
+		} cfgi;
+
+		#define CMDQ_OP_TLBI_NH_ASID	0x11
+		#define CMDQ_OP_TLBI_NH_VA	0x12
+		#define CMDQ_OP_TLBI_EL2_ALL	0x20
+		#define CMDQ_OP_TLBI_EL2_ASID	0x21
+		#define CMDQ_OP_TLBI_EL2_VA	0x22
+		#define CMDQ_OP_TLBI_S12_VMALL	0x28
+		#define CMDQ_OP_TLBI_S2_IPA	0x2a
+		#define CMDQ_OP_TLBI_NSNH_ALL	0x30
+		struct {
+			u8			num;
+			u8			scale;
+			u16			asid;
+			u16			vmid;
+			bool			leaf;
+			u8			ttl;
+			u8			tg;
+			u64			addr;
+		} tlbi;
+
+		#define CMDQ_OP_ATC_INV		0x40
+		#define ATC_INV_SIZE_ALL	52
+		struct {
+			u32			sid;
+			u32			ssid;
+			u64			addr;
+			u8			size;
+			bool			global;
+		} atc;
+
+		#define CMDQ_OP_PRI_RESP	0x41
+		struct {
+			u32			sid;
+			u32			ssid;
+			u16			grpid;
+			enum pri_resp		resp;
+		} pri;
+
+		#define CMDQ_OP_RESUME		0x44
+		struct {
+			u32			sid;
+			u16			stag;
+			u8			resp;
+		} resume;
+
+		#define CMDQ_OP_CMD_SYNC	0x46
+		struct {
+			u64			msiaddr;
+		} sync;
+	};
+};
+
+#endif /* _ARM_SMMU_V3_COMMON_H */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1e9952ca989f..fc1b8c2af2a2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -8,7 +8,6 @@
 #ifndef _ARM_SMMU_V3_H
 #define _ARM_SMMU_V3_H
 
-#include <linux/bitfield.h>
 #include <linux/iommu.h>
 #include <linux/kernel.h>
 #include <linux/mmzone.h>
@@ -16,167 +15,7 @@
 
 struct arm_smmu_device;
 
-/* MMIO registers */
-#define ARM_SMMU_IDR0			0x0
-#define IDR0_ST_LVL			GENMASK(28, 27)
-#define IDR0_ST_LVL_2LVL		1
-#define IDR0_STALL_MODEL		GENMASK(25, 24)
-#define IDR0_STALL_MODEL_STALL		0
-#define IDR0_STALL_MODEL_FORCE		2
-#define IDR0_TTENDIAN			GENMASK(22, 21)
-#define IDR0_TTENDIAN_MIXED		0
-#define IDR0_TTENDIAN_LE		2
-#define IDR0_TTENDIAN_BE		3
-#define IDR0_CD2L			(1 << 19)
-#define IDR0_VMID16			(1 << 18)
-#define IDR0_PRI			(1 << 16)
-#define IDR0_SEV			(1 << 14)
-#define IDR0_MSI			(1 << 13)
-#define IDR0_ASID16			(1 << 12)
-#define IDR0_ATS			(1 << 10)
-#define IDR0_HYP			(1 << 9)
-#define IDR0_HTTU			GENMASK(7, 6)
-#define IDR0_HTTU_ACCESS		1
-#define IDR0_HTTU_ACCESS_DIRTY		2
-#define IDR0_COHACC			(1 << 4)
-#define IDR0_TTF			GENMASK(3, 2)
-#define IDR0_TTF_AARCH64		2
-#define IDR0_TTF_AARCH32_64		3
-#define IDR0_S1P			(1 << 1)
-#define IDR0_S2P			(1 << 0)
-
-#define ARM_SMMU_IDR1			0x4
-#define IDR1_TABLES_PRESET		(1 << 30)
-#define IDR1_QUEUES_PRESET		(1 << 29)
-#define IDR1_REL			(1 << 28)
-#define IDR1_ATTR_TYPES_OVR		(1 << 27)
-#define IDR1_CMDQS			GENMASK(25, 21)
-#define IDR1_EVTQS			GENMASK(20, 16)
-#define IDR1_PRIQS			GENMASK(15, 11)
-#define IDR1_SSIDSIZE			GENMASK(10, 6)
-#define IDR1_SIDSIZE			GENMASK(5, 0)
-
-#define ARM_SMMU_IDR3			0xc
-#define IDR3_RIL			(1 << 10)
-
-#define ARM_SMMU_IDR5			0x14
-#define IDR5_STALL_MAX			GENMASK(31, 16)
-#define IDR5_GRAN64K			(1 << 6)
-#define IDR5_GRAN16K			(1 << 5)
-#define IDR5_GRAN4K			(1 << 4)
-#define IDR5_OAS			GENMASK(2, 0)
-#define IDR5_OAS_32_BIT			0
-#define IDR5_OAS_36_BIT			1
-#define IDR5_OAS_40_BIT			2
-#define IDR5_OAS_42_BIT			3
-#define IDR5_OAS_44_BIT			4
-#define IDR5_OAS_48_BIT			5
-#define IDR5_OAS_52_BIT			6
-#define IDR5_VAX			GENMASK(11, 10)
-#define IDR5_VAX_52_BIT			1
-
-#define ARM_SMMU_IIDR			0x18
-#define IIDR_PRODUCTID			GENMASK(31, 20)
-#define IIDR_VARIANT			GENMASK(19, 16)
-#define IIDR_REVISION			GENMASK(15, 12)
-#define IIDR_IMPLEMENTER		GENMASK(11, 0)
-
-#define ARM_SMMU_CR0			0x20
-#define CR0_ATSCHK			(1 << 4)
-#define CR0_CMDQEN			(1 << 3)
-#define CR0_EVTQEN			(1 << 2)
-#define CR0_PRIQEN			(1 << 1)
-#define CR0_SMMUEN			(1 << 0)
-
-#define ARM_SMMU_CR0ACK			0x24
-
-#define ARM_SMMU_CR1			0x28
-#define CR1_TABLE_SH			GENMASK(11, 10)
-#define CR1_TABLE_OC			GENMASK(9, 8)
-#define CR1_TABLE_IC			GENMASK(7, 6)
-#define CR1_QUEUE_SH			GENMASK(5, 4)
-#define CR1_QUEUE_OC			GENMASK(3, 2)
-#define CR1_QUEUE_IC			GENMASK(1, 0)
-/* CR1 cacheability fields don't quite follow the usual TCR-style encoding */
-#define CR1_CACHE_NC			0
-#define CR1_CACHE_WB			1
-#define CR1_CACHE_WT			2
-
-#define ARM_SMMU_CR2			0x2c
-#define CR2_PTM				(1 << 2)
-#define CR2_RECINVSID			(1 << 1)
-#define CR2_E2H				(1 << 0)
-
-#define ARM_SMMU_GBPA			0x44
-#define GBPA_UPDATE			(1 << 31)
-#define GBPA_ABORT			(1 << 20)
-
-#define ARM_SMMU_IRQ_CTRL		0x50
-#define IRQ_CTRL_EVTQ_IRQEN		(1 << 2)
-#define IRQ_CTRL_PRIQ_IRQEN		(1 << 1)
-#define IRQ_CTRL_GERROR_IRQEN		(1 << 0)
-
-#define ARM_SMMU_IRQ_CTRLACK		0x54
-
-#define ARM_SMMU_GERROR			0x60
-#define GERROR_SFM_ERR			(1 << 8)
-#define GERROR_MSI_GERROR_ABT_ERR	(1 << 7)
-#define GERROR_MSI_PRIQ_ABT_ERR		(1 << 6)
-#define GERROR_MSI_EVTQ_ABT_ERR		(1 << 5)
-#define GERROR_MSI_CMDQ_ABT_ERR		(1 << 4)
-#define GERROR_PRIQ_ABT_ERR		(1 << 3)
-#define GERROR_EVTQ_ABT_ERR		(1 << 2)
-#define GERROR_CMDQ_ERR			(1 << 0)
-#define GERROR_ERR_MASK			0x1fd
-
-#define ARM_SMMU_GERRORN		0x64
-
-#define ARM_SMMU_GERROR_IRQ_CFG0	0x68
-#define ARM_SMMU_GERROR_IRQ_CFG1	0x70
-#define ARM_SMMU_GERROR_IRQ_CFG2	0x74
-
-#define ARM_SMMU_STRTAB_BASE		0x80
-#define STRTAB_BASE_RA			(1UL << 62)
-#define STRTAB_BASE_ADDR_MASK		GENMASK_ULL(51, 6)
-
-#define ARM_SMMU_STRTAB_BASE_CFG	0x88
-#define STRTAB_BASE_CFG_FMT		GENMASK(17, 16)
-#define STRTAB_BASE_CFG_FMT_LINEAR	0
-#define STRTAB_BASE_CFG_FMT_2LVL	1
-#define STRTAB_BASE_CFG_SPLIT		GENMASK(10, 6)
-#define STRTAB_BASE_CFG_LOG2SIZE	GENMASK(5, 0)
-
-#define ARM_SMMU_CMDQ_BASE		0x90
-#define ARM_SMMU_CMDQ_PROD		0x98
-#define ARM_SMMU_CMDQ_CONS		0x9c
-
-#define ARM_SMMU_EVTQ_BASE		0xa0
-#define ARM_SMMU_EVTQ_PROD		0xa8
-#define ARM_SMMU_EVTQ_CONS		0xac
-#define ARM_SMMU_EVTQ_IRQ_CFG0		0xb0
-#define ARM_SMMU_EVTQ_IRQ_CFG1		0xb8
-#define ARM_SMMU_EVTQ_IRQ_CFG2		0xbc
-
-#define ARM_SMMU_PRIQ_BASE		0xc0
-#define ARM_SMMU_PRIQ_PROD		0xc8
-#define ARM_SMMU_PRIQ_CONS		0xcc
-#define ARM_SMMU_PRIQ_IRQ_CFG0		0xd0
-#define ARM_SMMU_PRIQ_IRQ_CFG1		0xd8
-#define ARM_SMMU_PRIQ_IRQ_CFG2		0xdc
-
-#define ARM_SMMU_REG_SZ			0xe00
-
-/* Common MSI config fields */
-#define MSI_CFG0_ADDR_MASK		GENMASK_ULL(51, 2)
-#define MSI_CFG2_SH			GENMASK(5, 4)
-#define MSI_CFG2_MEMATTR		GENMASK(3, 0)
-
-/* Common memory attribute values */
-#define ARM_SMMU_SH_NSH			0
-#define ARM_SMMU_SH_OSH			2
-#define ARM_SMMU_SH_ISH			3
-#define ARM_SMMU_MEMATTR_DEVICE_nGnRE	0x1
-#define ARM_SMMU_MEMATTR_OIWB		0xf
+#include <asm/arm-smmu-v3-common.h>
 
 #define Q_IDX(llq, p)			((p) & ((1 << (llq)->max_n_shift) - 1))
 #define Q_WRP(llq, p)			((p) & (1 << (llq)->max_n_shift))
@@ -186,10 +25,6 @@ struct arm_smmu_device;
 					 Q_IDX(&((q)->llq), p) *	\
 					 (q)->ent_dwords)
 
-#define Q_BASE_RWA			(1UL << 62)
-#define Q_BASE_ADDR_MASK		GENMASK_ULL(51, 5)
-#define Q_BASE_LOG2SIZE			GENMASK(4, 0)
-
 /* Ensure DMA allocations are naturally aligned */
 #ifdef CONFIG_CMA_ALIGNMENT
 #define Q_MAX_SZ_SHIFT			(PAGE_SHIFT + CONFIG_CMA_ALIGNMENT)
@@ -197,180 +32,6 @@ struct arm_smmu_device;
 #define Q_MAX_SZ_SHIFT			(PAGE_SHIFT + MAX_PAGE_ORDER)
 #endif
 
-/*
- * Stream table.
- *
- * Linear: Enough to cover 1 << IDR1.SIDSIZE entries
- * 2lvl: 128k L1 entries,
- *       256 lazy entries per table (each table covers a PCI bus)
- */
-#define STRTAB_SPLIT			8
-
-#define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
-#define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
-
-#define STRTAB_STE_DWORDS		8
-
-struct arm_smmu_ste {
-	__le64 data[STRTAB_STE_DWORDS];
-};
-
-#define STRTAB_NUM_L2_STES		(1 << STRTAB_SPLIT)
-struct arm_smmu_strtab_l2 {
-	struct arm_smmu_ste stes[STRTAB_NUM_L2_STES];
-};
-
-struct arm_smmu_strtab_l1 {
-	__le64 l2ptr;
-};
-#define STRTAB_MAX_L1_ENTRIES		(1 << 17)
-
-static inline u32 arm_smmu_strtab_l1_idx(u32 sid)
-{
-	return sid / STRTAB_NUM_L2_STES;
-}
-
-static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
-{
-	return sid % STRTAB_NUM_L2_STES;
-}
-
-#define STRTAB_STE_0_V			(1UL << 0)
-#define STRTAB_STE_0_CFG		GENMASK_ULL(3, 1)
-#define STRTAB_STE_0_CFG_ABORT		0
-#define STRTAB_STE_0_CFG_BYPASS		4
-#define STRTAB_STE_0_CFG_S1_TRANS	5
-#define STRTAB_STE_0_CFG_S2_TRANS	6
-
-#define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
-#define STRTAB_STE_0_S1FMT_LINEAR	0
-#define STRTAB_STE_0_S1FMT_64K_L2	2
-#define STRTAB_STE_0_S1CTXPTR_MASK	GENMASK_ULL(51, 6)
-#define STRTAB_STE_0_S1CDMAX		GENMASK_ULL(63, 59)
-
-#define STRTAB_STE_1_S1DSS		GENMASK_ULL(1, 0)
-#define STRTAB_STE_1_S1DSS_TERMINATE	0x0
-#define STRTAB_STE_1_S1DSS_BYPASS	0x1
-#define STRTAB_STE_1_S1DSS_SSID0	0x2
-
-#define STRTAB_STE_1_S1C_CACHE_NC	0UL
-#define STRTAB_STE_1_S1C_CACHE_WBRA	1UL
-#define STRTAB_STE_1_S1C_CACHE_WT	2UL
-#define STRTAB_STE_1_S1C_CACHE_WB	3UL
-#define STRTAB_STE_1_S1CIR		GENMASK_ULL(3, 2)
-#define STRTAB_STE_1_S1COR		GENMASK_ULL(5, 4)
-#define STRTAB_STE_1_S1CSH		GENMASK_ULL(7, 6)
-
-#define STRTAB_STE_1_S1STALLD		(1UL << 27)
-
-#define STRTAB_STE_1_EATS		GENMASK_ULL(29, 28)
-#define STRTAB_STE_1_EATS_ABT		0UL
-#define STRTAB_STE_1_EATS_TRANS		1UL
-#define STRTAB_STE_1_EATS_S1CHK		2UL
-
-#define STRTAB_STE_1_STRW		GENMASK_ULL(31, 30)
-#define STRTAB_STE_1_STRW_NSEL1		0UL
-#define STRTAB_STE_1_STRW_EL2		2UL
-
-#define STRTAB_STE_1_SHCFG		GENMASK_ULL(45, 44)
-#define STRTAB_STE_1_SHCFG_INCOMING	1UL
-
-#define STRTAB_STE_2_S2VMID		GENMASK_ULL(15, 0)
-#define STRTAB_STE_2_VTCR		GENMASK_ULL(50, 32)
-#define STRTAB_STE_2_VTCR_S2T0SZ	GENMASK_ULL(5, 0)
-#define STRTAB_STE_2_VTCR_S2SL0		GENMASK_ULL(7, 6)
-#define STRTAB_STE_2_VTCR_S2IR0		GENMASK_ULL(9, 8)
-#define STRTAB_STE_2_VTCR_S2OR0		GENMASK_ULL(11, 10)
-#define STRTAB_STE_2_VTCR_S2SH0		GENMASK_ULL(13, 12)
-#define STRTAB_STE_2_VTCR_S2TG		GENMASK_ULL(15, 14)
-#define STRTAB_STE_2_VTCR_S2PS		GENMASK_ULL(18, 16)
-#define STRTAB_STE_2_S2AA64		(1UL << 51)
-#define STRTAB_STE_2_S2ENDI		(1UL << 52)
-#define STRTAB_STE_2_S2PTW		(1UL << 54)
-#define STRTAB_STE_2_S2S		(1UL << 57)
-#define STRTAB_STE_2_S2R		(1UL << 58)
-
-#define STRTAB_STE_3_S2TTB_MASK		GENMASK_ULL(51, 4)
-
-/*
- * Context descriptors.
- *
- * Linear: when less than 1024 SSIDs are supported
- * 2lvl: at most 1024 L1 entries,
- *       1024 lazy entries per table.
- */
-#define CTXDESC_L2_ENTRIES		1024
-
-#define CTXDESC_L1_DESC_V		(1UL << 0)
-#define CTXDESC_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 12)
-
-#define CTXDESC_CD_DWORDS		8
-
-struct arm_smmu_cd {
-	__le64 data[CTXDESC_CD_DWORDS];
-};
-
-struct arm_smmu_cdtab_l2 {
-	struct arm_smmu_cd cds[CTXDESC_L2_ENTRIES];
-};
-
-struct arm_smmu_cdtab_l1 {
-	__le64 l2ptr;
-};
-
-static inline unsigned int arm_smmu_cdtab_l1_idx(unsigned int ssid)
-{
-	return ssid / CTXDESC_L2_ENTRIES;
-}
-
-static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
-{
-	return ssid % CTXDESC_L2_ENTRIES;
-}
-
-#define CTXDESC_CD_0_TCR_T0SZ		GENMASK_ULL(5, 0)
-#define CTXDESC_CD_0_TCR_TG0		GENMASK_ULL(7, 6)
-#define CTXDESC_CD_0_TCR_IRGN0		GENMASK_ULL(9, 8)
-#define CTXDESC_CD_0_TCR_ORGN0		GENMASK_ULL(11, 10)
-#define CTXDESC_CD_0_TCR_SH0		GENMASK_ULL(13, 12)
-#define CTXDESC_CD_0_TCR_EPD0		(1ULL << 14)
-#define CTXDESC_CD_0_TCR_EPD1		(1ULL << 30)
-
-#define CTXDESC_CD_0_ENDI		(1UL << 15)
-#define CTXDESC_CD_0_V			(1UL << 31)
-
-#define CTXDESC_CD_0_TCR_IPS		GENMASK_ULL(34, 32)
-#define CTXDESC_CD_0_TCR_TBI0		(1ULL << 38)
-
-#define CTXDESC_CD_0_TCR_HA            (1UL << 43)
-#define CTXDESC_CD_0_TCR_HD            (1UL << 42)
-
-#define CTXDESC_CD_0_AA64		(1UL << 41)
-#define CTXDESC_CD_0_S			(1UL << 44)
-#define CTXDESC_CD_0_R			(1UL << 45)
-#define CTXDESC_CD_0_A			(1UL << 46)
-#define CTXDESC_CD_0_ASET		(1UL << 47)
-#define CTXDESC_CD_0_ASID		GENMASK_ULL(63, 48)
-
-#define CTXDESC_CD_1_TTB0_MASK		GENMASK_ULL(51, 4)
-
-/*
- * When the SMMU only supports linear context descriptor tables, pick a
- * reasonable size limit (64kB).
- */
-#define CTXDESC_LINEAR_CDMAX		ilog2(SZ_64K / sizeof(struct arm_smmu_cd))
-
-/* Command queue */
-#define CMDQ_ENT_SZ_SHIFT		4
-#define CMDQ_ENT_DWORDS			((1 << CMDQ_ENT_SZ_SHIFT) >> 3)
-#define CMDQ_MAX_SZ_SHIFT		(Q_MAX_SZ_SHIFT - CMDQ_ENT_SZ_SHIFT)
-
-#define CMDQ_CONS_ERR			GENMASK(30, 24)
-#define CMDQ_ERR_CERROR_NONE_IDX	0
-#define CMDQ_ERR_CERROR_ILL_IDX		1
-#define CMDQ_ERR_CERROR_ABT_IDX		2
-#define CMDQ_ERR_CERROR_ATC_INV_IDX	3
-
 #define CMDQ_PROD_OWNED_FLAG		Q_OVERFLOW_FLAG
 
 /*
@@ -380,99 +41,6 @@ static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
  */
 #define CMDQ_BATCH_ENTRIES		BITS_PER_LONG
 
-#define CMDQ_0_OP			GENMASK_ULL(7, 0)
-#define CMDQ_0_SSV			(1UL << 11)
-
-#define CMDQ_PREFETCH_0_SID		GENMASK_ULL(63, 32)
-#define CMDQ_PREFETCH_1_SIZE		GENMASK_ULL(4, 0)
-#define CMDQ_PREFETCH_1_ADDR_MASK	GENMASK_ULL(63, 12)
-
-#define CMDQ_CFGI_0_SSID		GENMASK_ULL(31, 12)
-#define CMDQ_CFGI_0_SID			GENMASK_ULL(63, 32)
-#define CMDQ_CFGI_1_LEAF		(1UL << 0)
-#define CMDQ_CFGI_1_RANGE		GENMASK_ULL(4, 0)
-
-#define CMDQ_TLBI_0_NUM			GENMASK_ULL(16, 12)
-#define CMDQ_TLBI_RANGE_NUM_MAX		31
-#define CMDQ_TLBI_0_SCALE		GENMASK_ULL(24, 20)
-#define CMDQ_TLBI_0_VMID		GENMASK_ULL(47, 32)
-#define CMDQ_TLBI_0_ASID		GENMASK_ULL(63, 48)
-#define CMDQ_TLBI_1_LEAF		(1UL << 0)
-#define CMDQ_TLBI_1_TTL			GENMASK_ULL(9, 8)
-#define CMDQ_TLBI_1_TG			GENMASK_ULL(11, 10)
-#define CMDQ_TLBI_1_VA_MASK		GENMASK_ULL(63, 12)
-#define CMDQ_TLBI_1_IPA_MASK		GENMASK_ULL(51, 12)
-
-#define CMDQ_ATC_0_SSID			GENMASK_ULL(31, 12)
-#define CMDQ_ATC_0_SID			GENMASK_ULL(63, 32)
-#define CMDQ_ATC_0_GLOBAL		(1UL << 9)
-#define CMDQ_ATC_1_SIZE			GENMASK_ULL(5, 0)
-#define CMDQ_ATC_1_ADDR_MASK		GENMASK_ULL(63, 12)
-
-#define CMDQ_PRI_0_SSID			GENMASK_ULL(31, 12)
-#define CMDQ_PRI_0_SID			GENMASK_ULL(63, 32)
-#define CMDQ_PRI_1_GRPID		GENMASK_ULL(8, 0)
-#define CMDQ_PRI_1_RESP			GENMASK_ULL(13, 12)
-
-#define CMDQ_RESUME_0_RESP_TERM		0UL
-#define CMDQ_RESUME_0_RESP_RETRY	1UL
-#define CMDQ_RESUME_0_RESP_ABORT	2UL
-#define CMDQ_RESUME_0_RESP		GENMASK_ULL(13, 12)
-#define CMDQ_RESUME_0_SID		GENMASK_ULL(63, 32)
-#define CMDQ_RESUME_1_STAG		GENMASK_ULL(15, 0)
-
-#define CMDQ_SYNC_0_CS			GENMASK_ULL(13, 12)
-#define CMDQ_SYNC_0_CS_NONE		0
-#define CMDQ_SYNC_0_CS_IRQ		1
-#define CMDQ_SYNC_0_CS_SEV		2
-#define CMDQ_SYNC_0_MSH			GENMASK_ULL(23, 22)
-#define CMDQ_SYNC_0_MSIATTR		GENMASK_ULL(27, 24)
-#define CMDQ_SYNC_0_MSIDATA		GENMASK_ULL(63, 32)
-#define CMDQ_SYNC_1_MSIADDR_MASK	GENMASK_ULL(51, 2)
-
-/* Event queue */
-#define EVTQ_ENT_SZ_SHIFT		5
-#define EVTQ_ENT_DWORDS			((1 << EVTQ_ENT_SZ_SHIFT) >> 3)
-#define EVTQ_MAX_SZ_SHIFT		(Q_MAX_SZ_SHIFT - EVTQ_ENT_SZ_SHIFT)
-
-#define EVTQ_0_ID			GENMASK_ULL(7, 0)
-
-#define EVT_ID_TRANSLATION_FAULT	0x10
-#define EVT_ID_ADDR_SIZE_FAULT		0x11
-#define EVT_ID_ACCESS_FAULT		0x12
-#define EVT_ID_PERMISSION_FAULT		0x13
-
-#define EVTQ_0_SSV			(1UL << 11)
-#define EVTQ_0_SSID			GENMASK_ULL(31, 12)
-#define EVTQ_0_SID			GENMASK_ULL(63, 32)
-#define EVTQ_1_STAG			GENMASK_ULL(15, 0)
-#define EVTQ_1_STALL			(1UL << 31)
-#define EVTQ_1_PnU			(1UL << 33)
-#define EVTQ_1_InD			(1UL << 34)
-#define EVTQ_1_RnW			(1UL << 35)
-#define EVTQ_1_S2			(1UL << 39)
-#define EVTQ_1_CLASS			GENMASK_ULL(41, 40)
-#define EVTQ_1_TT_READ			(1UL << 44)
-#define EVTQ_2_ADDR			GENMASK_ULL(63, 0)
-#define EVTQ_3_IPA			GENMASK_ULL(51, 12)
-
-/* PRI queue */
-#define PRIQ_ENT_SZ_SHIFT		4
-#define PRIQ_ENT_DWORDS			((1 << PRIQ_ENT_SZ_SHIFT) >> 3)
-#define PRIQ_MAX_SZ_SHIFT		(Q_MAX_SZ_SHIFT - PRIQ_ENT_SZ_SHIFT)
-
-#define PRIQ_0_SID			GENMASK_ULL(31, 0)
-#define PRIQ_0_SSID			GENMASK_ULL(51, 32)
-#define PRIQ_0_PERM_PRIV		(1UL << 58)
-#define PRIQ_0_PERM_EXEC		(1UL << 59)
-#define PRIQ_0_PERM_READ		(1UL << 60)
-#define PRIQ_0_PERM_WRITE		(1UL << 61)
-#define PRIQ_0_PRG_LAST			(1UL << 62)
-#define PRIQ_0_SSID_V			(1UL << 63)
-
-#define PRIQ_1_PRG_IDX			GENMASK_ULL(8, 0)
-#define PRIQ_1_ADDR_MASK		GENMASK_ULL(63, 12)
-
 /* High-level queue structures */
 #define ARM_SMMU_POLL_TIMEOUT_US	1000000 /* 1s! */
 #define ARM_SMMU_POLL_SPIN_COUNT	10
@@ -480,88 +48,6 @@ static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
 #define MSI_IOVA_BASE			0x8000000
 #define MSI_IOVA_LENGTH			0x100000
 
-enum pri_resp {
-	PRI_RESP_DENY = 0,
-	PRI_RESP_FAIL = 1,
-	PRI_RESP_SUCC = 2,
-};
-
-struct arm_smmu_cmdq_ent {
-	/* Common fields */
-	u8				opcode;
-	bool				substream_valid;
-
-	/* Command-specific fields */
-	union {
-		#define CMDQ_OP_PREFETCH_CFG	0x1
-		struct {
-			u32			sid;
-		} prefetch;
-
-		#define CMDQ_OP_CFGI_STE	0x3
-		#define CMDQ_OP_CFGI_ALL	0x4
-		#define CMDQ_OP_CFGI_CD		0x5
-		#define CMDQ_OP_CFGI_CD_ALL	0x6
-		struct {
-			u32			sid;
-			u32			ssid;
-			union {
-				bool		leaf;
-				u8		span;
-			};
-		} cfgi;
-
-		#define CMDQ_OP_TLBI_NH_ASID	0x11
-		#define CMDQ_OP_TLBI_NH_VA	0x12
-		#define CMDQ_OP_TLBI_EL2_ALL	0x20
-		#define CMDQ_OP_TLBI_EL2_ASID	0x21
-		#define CMDQ_OP_TLBI_EL2_VA	0x22
-		#define CMDQ_OP_TLBI_S12_VMALL	0x28
-		#define CMDQ_OP_TLBI_S2_IPA	0x2a
-		#define CMDQ_OP_TLBI_NSNH_ALL	0x30
-		struct {
-			u8			num;
-			u8			scale;
-			u16			asid;
-			u16			vmid;
-			bool			leaf;
-			u8			ttl;
-			u8			tg;
-			u64			addr;
-		} tlbi;
-
-		#define CMDQ_OP_ATC_INV		0x40
-		#define ATC_INV_SIZE_ALL	52
-		struct {
-			u32			sid;
-			u32			ssid;
-			u64			addr;
-			u8			size;
-			bool			global;
-		} atc;
-
-		#define CMDQ_OP_PRI_RESP	0x41
-		struct {
-			u32			sid;
-			u32			ssid;
-			u16			grpid;
-			enum pri_resp		resp;
-		} pri;
-
-		#define CMDQ_OP_RESUME		0x44
-		struct {
-			u32			sid;
-			u16			stag;
-			u8			resp;
-		} resume;
-
-		#define CMDQ_OP_CMD_SYNC	0x46
-		struct {
-			u64			msiaddr;
-		} sync;
-	};
-};
-
 struct arm_smmu_ll_queue {
 	union {
 		u64			val;
@@ -703,29 +189,7 @@ struct arm_smmu_device {
 	void __iomem			*base;
 	void __iomem			*page1;
 
-#define ARM_SMMU_FEAT_2_LVL_STRTAB	(1 << 0)
-#define ARM_SMMU_FEAT_2_LVL_CDTAB	(1 << 1)
-#define ARM_SMMU_FEAT_TT_LE		(1 << 2)
-#define ARM_SMMU_FEAT_TT_BE		(1 << 3)
-#define ARM_SMMU_FEAT_PRI		(1 << 4)
-#define ARM_SMMU_FEAT_ATS		(1 << 5)
-#define ARM_SMMU_FEAT_SEV		(1 << 6)
-#define ARM_SMMU_FEAT_MSI		(1 << 7)
-#define ARM_SMMU_FEAT_COHERENCY		(1 << 8)
-#define ARM_SMMU_FEAT_TRANS_S1		(1 << 9)
-#define ARM_SMMU_FEAT_TRANS_S2		(1 << 10)
-#define ARM_SMMU_FEAT_STALLS		(1 << 11)
-#define ARM_SMMU_FEAT_HYP		(1 << 12)
-#define ARM_SMMU_FEAT_STALL_FORCE	(1 << 13)
-#define ARM_SMMU_FEAT_VAX		(1 << 14)
-#define ARM_SMMU_FEAT_RANGE_INV		(1 << 15)
-#define ARM_SMMU_FEAT_BTM		(1 << 16)
-#define ARM_SMMU_FEAT_SVA		(1 << 17)
-#define ARM_SMMU_FEAT_E2H		(1 << 18)
-#define ARM_SMMU_FEAT_NESTING		(1 << 19)
-#define ARM_SMMU_FEAT_ATTR_TYPES_OVR	(1 << 20)
-#define ARM_SMMU_FEAT_HA		(1 << 21)
-#define ARM_SMMU_FEAT_HD		(1 << 22)
+	/* See arm-smmu-v3-common.h*/
 	u32				features;
 
 #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)
-- 
2.47.0.338.g60cca15819-goog

