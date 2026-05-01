Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B7739FCB4
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634423; cv=none; b=bv7rfrtEgw0thXysiDdwennP8Gv2ZAD0k//+Pm3Km2GbgT9tc9KYCQ1APxiSohES7maMVr+oYNkF79t7FSKseLPNTFBlHudnc8mYNCrPbgQiaY5RXNVaAJnROCbNLN6mdDzOYknQhA73uuwpxK+Kn3V1Dhu7+QODIYt6TqWgNlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634423; c=relaxed/simple;
	bh=o14JzmXYNahFrdFmiylYn3Zxk6zxXvzNvdkjVQ1daIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H545lCN56aV5VXCdNttN6Mi6LLCBVNSk2ybhIm6/FTAhYL/G6laos3Qj0zzZVRNpsw3GICYjeK9rteUmpnARJaBFF0aOIrQ9T1cvPs0h6ZHHC+VfZ6EvGDCRAmNBM5t7jKg9B5NG+kJyAJSF3s2z705NXFdq+QJJabvBZB9n2oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kQEbTOCT; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kQEbTOCT"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-670af4f9546so1690192a12.1
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634418; x=1778239218; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TWp0aeThUsgvfFBxJWuWRQdGQ3dxhvfuaZARmJjLR/k=;
        b=kQEbTOCTXEZVZumg4dB24QHIVfJDqsYmz6NiEoNgOnzwq7jv2TqRQjjBsc6mEFdG+d
         MOOkauTzr8Bu+EK0GSWDdaoZ9ZXdjnMMlvobjon9Q2HKMxIfv7mdW8RAQyBTEezOKoJG
         tvBUF4eTlenJh231LaJQgjT2zLn0ymnBeiVdC6glogP1Jkdlg7n3puz5eS3aFyhcBXaK
         //1p8XOCxw9I1B0U6EJUYEuzGtX2Z7qnuN8rh+sXkQygR7rWEaquDkodftZdFHlSKLHU
         6YpRMUAgolq9Oi5UawI1kpt7Ey3m49EmtwzMIIQ1AUL1c2dxQF4DqWkoGDxY2C6YfXeQ
         5LEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634418; x=1778239218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TWp0aeThUsgvfFBxJWuWRQdGQ3dxhvfuaZARmJjLR/k=;
        b=YrCQ38iPIp9tz2HU0N49j1ZXBY4f6XNIDtZczjpTPEuiFkgD3roJZFKRlbxzpOHdhc
         xUIhNhhGmrzKK21ST3WbMfJyDwWgjartP3+lR2DK7dp70Ft3orp/iN2KARwVJZiUeIkI
         R25Bn8Igv8NiDRKP/5+rrucH4MeU3lI8FpEHnqKeQjf47ROmXGZkmOeVXDNzvYnZYxxW
         FeEVWOOhG+mDQ16qdQEWi+0fwR+Xd8lRJIP3khNnewku7g6pvaulhQERURiQXUXDq4Za
         AFUFKhigAPtESVfVR4ZR4Xv6lLw5Fy6yEGFo47oH/hz05XSHBuqg7CadWJopbuqOOUrE
         Mhqw==
X-Forwarded-Encrypted: i=1; AFNElJ8GQEGQhxctrUPIJDwRJgXMZjDlHGgY/BupiVFJpGMwuplerKagu4AzNZChd6qkIC0jddt47bQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw15tliANcgPZLmFmT4dABjvaqgfqE+mE6P8yFXLj6jVljhWlWa
	t6gThIC1a0D/nynV9nDiYx5cKw2ARaH+jEeRZ6yJ/Pbti03Gk8jr/gjpA4Y1paRbeq2TKkobnGc
	jqcFmmcRQSIROCw==
X-Received: from ejcjs18.prod.google.com ([2002:a17:907:97d2:b0:b97:b7aa:b4])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:72d1:b0:ba5:2f0a:2f40 with SMTP id a640c23a62f3a-bbac4bd9fa1mr416440366b.4.1777634417769;
 Fri, 01 May 2026 04:20:17 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:16 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-15-smostafa@google.com>
Subject: [PATCH v6 14/25] iommu/arm-smmu-v3-kvm: Add MMIO emulation
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

Add data abort handler for the SMMUs, at the moment most registers
are just passthrough.
In the next patches CMDQ/STE emulation will be added which inserts
logic to some register access.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 143 ++++++++++++++++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |  10 ++
 2 files changed, 153 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index d9945db9e102..cce5a51b4656 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -8,6 +8,7 @@
 
 #include <nvhe/iommu.h>
 #include <nvhe/mem_protect.h>
+#include <nvhe/trap_handler.h>
 
 #include "arm_smmu_v3.h"
 #include "../arm-smmu-v3.h"
@@ -106,6 +107,7 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (!PAGE_ALIGNED(smmu->mmio_addr | smmu->mmio_size))
 		return -EINVAL;
 
+	hyp_spin_lock_init(&smmu->lock);
 	ret = __pkvm_host_donate_hyp_mmio(smmu->mmio_addr, smmu->mmio_size, &haddr);
 	if (ret)
 		return ret;
@@ -144,6 +146,8 @@ static int smmu_init(void)
 			goto out_reclaim_smmu;
 	}
 
+	BUILD_BUG_ON(sizeof(hyp_spinlock_t) != sizeof(u32));
+
 	return 0;
 
 out_reclaim_smmu:
@@ -153,6 +157,144 @@ static int smmu_init(void)
 	return ret;
 }
 
+static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
+			     struct user_pt_regs *regs,
+			     u64 esr, u32 off)
+{
+	bool is_write = esr & ESR_ELx_WNR;
+	unsigned int len = BIT((esr & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
+	int rd = (esr & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
+	const u64 read_write = -1ULL;
+	const u64 no_access = 0;
+	u64 mask = no_access;
+	const u64 read_only = is_write ? no_access : read_write;
+	bool is_xzr = (rd == 31);
+	u64 val = is_xzr ? 0 : regs->regs[rd];
+
+	switch (off) {
+	case ARM_SMMU_IDR0:
+		if (len != sizeof(u32))
+			break;
+		/* Clear stage-2 support, hide MSI to avoid write back to cmdq */
+		mask = read_only & ~(IDR0_S2P | IDR0_VMID16 | IDR0_MSI | IDR0_HYP);
+		break;
+	/* Passthrough the register access for bisectiblity, handled later */
+	case ARM_SMMU_CMDQ_BASE:
+	case ARM_SMMU_CMDQ_PROD:
+	case ARM_SMMU_CMDQ_CONS:
+	case ARM_SMMU_STRTAB_BASE:
+	case ARM_SMMU_STRTAB_BASE_CFG:
+	case ARM_SMMU_GBPA:
+		mask = read_write;
+		break;
+	case ARM_SMMU_CR0:
+		if (len != sizeof(u32))
+			break;
+		mask = read_write;
+		break;
+	case ARM_SMMU_CR1: {
+		/* Based on Linux implementation */
+		u64 cr1_template = FIELD_PREP(CR1_TABLE_SH, ARM_SMMU_SH_ISH) |
+				FIELD_PREP(CR1_TABLE_OC, CR1_CACHE_WB) |
+				FIELD_PREP(CR1_TABLE_IC, CR1_CACHE_WB) |
+				FIELD_PREP(CR1_QUEUE_SH, ARM_SMMU_SH_ISH) |
+				FIELD_PREP(CR1_QUEUE_OC, CR1_CACHE_WB) |
+				FIELD_PREP(CR1_QUEUE_IC, CR1_CACHE_WB);
+		if (len != sizeof(u32))
+			break;
+		/* Don't mess with shareability/cacheability. */
+		if (is_write) {
+			WARN_ON(val != cr1_template);
+			val = cr1_template;
+		}
+		mask = read_write;
+		break;
+	}
+
+	/* Allowed 32 bit registers. */
+	case ARM_SMMU_EVTQ_PROD + SZ_64K:
+	case ARM_SMMU_EVTQ_CONS + SZ_64K:
+	case ARM_SMMU_EVTQ_IRQ_CFG1:
+	case ARM_SMMU_EVTQ_IRQ_CFG2:
+	case ARM_SMMU_PRIQ_PROD + SZ_64K:
+	case ARM_SMMU_PRIQ_CONS + SZ_64K:
+	case ARM_SMMU_PRIQ_IRQ_CFG1:
+	case ARM_SMMU_PRIQ_IRQ_CFG2:
+	case ARM_SMMU_GERRORN:
+	case ARM_SMMU_GERROR_IRQ_CFG1:
+	case ARM_SMMU_GERROR_IRQ_CFG2:
+	case ARM_SMMU_IRQ_CTRLACK:
+	case ARM_SMMU_IRQ_CTRL:
+	case ARM_SMMU_CR0ACK:
+	case ARM_SMMU_CR2:
+		if (len != sizeof(u32))
+			break;
+		mask = read_write;
+		break;
+	/* Allowed 64 bit registers. */
+	case ARM_SMMU_EVTQ_BASE:
+	case ARM_SMMU_EVTQ_IRQ_CFG0:
+	case ARM_SMMU_PRIQ_BASE:
+	case ARM_SMMU_PRIQ_IRQ_CFG0:
+	case ARM_SMMU_GERROR_IRQ_CFG0:
+		if (len != sizeof(u64))
+			break;
+		mask = read_write;
+		break;
+	/* Allowed RO 32 bit registers. */
+	case ARM_SMMU_IIDR:
+	case ARM_SMMU_IDR5:
+	case ARM_SMMU_IDR3:
+	case ARM_SMMU_IDR1:
+	case ARM_SMMU_GERROR:
+		if (len != sizeof(u32))
+			break;
+		mask = read_only;
+	};
+
+	if (WARN_ON(!mask))
+		goto out_ret;
+
+	if (is_write) {
+		if (len == sizeof(u64))
+			writeq_relaxed(val & mask, smmu->base + off);
+		else
+			writel_relaxed(val & mask, smmu->base + off);
+
+		return true;
+	}
+
+	if (len == sizeof(u64))
+		val = readq_relaxed(smmu->base + off) & mask;
+	else
+		val = readl_relaxed(smmu->base + off) & mask;
+	/*
+	 * Device might be read senstive, so do it but ignore writing
+	 * back for xzr.
+	 */
+	if (!is_xzr)
+		regs->regs[rd] = val;
+
+out_ret:
+	return true;
+}
+
+static bool smmu_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr)
+{
+	struct hyp_arm_smmu_v3_device *smmu;
+	bool ret;
+
+	for_each_smmu(smmu) {
+		if (addr < smmu->mmio_addr || addr >= smmu->mmio_addr + smmu->mmio_size)
+			continue;
+		hyp_spin_lock(&smmu->lock);
+		ret = smmu_dabt_device(smmu, regs, esr, addr - smmu->mmio_addr);
+		hyp_spin_unlock(&smmu->lock);
+		return ret;
+	}
+	return false;
+}
+
 static int smmu_host_stage2_idmap(phys_addr_t start, phys_addr_t end, int prot)
 {
 	return 0;
@@ -162,4 +304,5 @@ static int smmu_host_stage2_idmap(phys_addr_t start, phys_addr_t end, int prot)
 struct kvm_iommu_ops smmu_ops = {
 	.init				= smmu_init,
 	.host_stage2_idmap		= smmu_host_stage2_idmap,
+	.dabt_handler			= smmu_dabt_handler,
 };
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index 82b84673e85b..263b0fef262d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -4,6 +4,10 @@
 
 #include <asm/kvm_asm.h>
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+#include <nvhe/spinlock.h>
+#endif
+
 /*
  * Parameters from the trusted host:
  * @mmio_addr		base address of the SMMU registers
@@ -15,6 +19,7 @@
  * @oas			PA size
  * @pgsize_bitmap	Supported page sizes
  * @sid_bits		Max number of SID bits supported
+ * @lock		Lock to protect SMMU
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
@@ -24,6 +29,11 @@ struct hyp_arm_smmu_v3_device {
 	unsigned long		oas;
 	unsigned long		pgsize_bitmap;
 	unsigned int		sid_bits;
+#ifdef __KVM_NVHE_HYPERVISOR__
+	hyp_spinlock_t		lock;
+#else
+	u32			lock;
+#endif
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.54.0.545.g6539524ca2-goog

