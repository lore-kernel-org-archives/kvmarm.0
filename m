Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED73B44C660
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116775; cv=none; b=t3PP+0swOi2AE5bHmgu/N4s2JUKaTm8bmwLY78Epp9s0OmLeRrMAO1l2ufewtZpe91qZ3sfTXpIoQkcYAw8+r7cFfeoK+BIy8novKkQ/TgcuEPZFNszPjqNTD2gkQrknMooxeapy7olx8xYjlvjKP9HwsfFuJ2H7acTrIKS1i6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116775; c=relaxed/simple;
	bh=Vc51+tDXkTxNkQKt0ujm+ycuJbTsubABwtHPycKRIE0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dSq1Df2jBXt20KXj0nB2kyjh7Ext3kkHnAZbwbl9f4y5YnQhUD0x+8YQHxN/aG61q0fNflzSZWmW5BhPrqsHtkOVJFfX4XhFqyTYXFnD1jg8rzFSo5fCf956MAai7vhAkNYdbRXYkWTdaohv10tNpKlbBMdkXIn5wvWjKVYzO1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fHvLqUGF; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fHvLqUGF"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493b21b1fe8so18019365e9.0
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116769; x=1784721569; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wRJ18s+161s2edooAsExJtsANoe4PXbtE7ux+6Z/9CQ=;
        b=fHvLqUGFLqc6r7W3+fq6PwU998ekMNDBi0vkDL74pWj1ThJ/DeQjoNFlmdF/ljOX1E
         KbFvPU99jSJQ0xhCwaOVUILzCMKkN01kb/iKrp2khQybH9sQmhVlMcDyUf5UOxrTl7zG
         rBCGGNkOep65Zv2ZuPwMmvauOWozIsDTPK+zPWxZE5TWD5JCZUrHFfqvv5VZEPay76sD
         +bguhULVMIeHHu0gcb0RUOHXPZtp2X2oJ8N9LxTXSiGNhABzoBB7XApHJ5WEvKu8CrBu
         FNHcar041BTYx5FXxeOdCq88jJieaMQSZrPymnZirx94y/wRdyl3emmsOldQ2ThZ8r4S
         Uz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116769; x=1784721569;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wRJ18s+161s2edooAsExJtsANoe4PXbtE7ux+6Z/9CQ=;
        b=W2fFU4K1iQXQmvOADRXkgH2Q33SQt49wtncCKF6GiGb93AozLUtWCSB03XTqDCs9Ul
         8NyFOXh2Dxm8qq61Ahnqi3ku/XB3HrWN/wFtMtX9RFt00uHmI8Xs87subTbSnFnx4rWU
         6eiLvT3i3Klta4QaAWS6nRuVdbSIxVbC8F3q57E1ityoLmhml1cQgPR8ivTsgyBrcWui
         we1BQFXsHrSphobRoRXhf84v3I6mdvJ/bhZp6/KEMTdsLUjVAzUGl56xySjkalnJB19c
         GfB2ADf3PA2ZRp8fdFhh/4aofcUzqzUY/VMOjtRfO9oTGT8NF+RHcyzs4txROnyYaknT
         9JGw==
X-Forwarded-Encrypted: i=1; AHgh+RqIwpJ0h7wbEdSmHtkyMaMNwyDGdpuit/pqh41ZfJxU2wLb6kMGsC531y7zE91Icu4C9w5Z+ts=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8TxeaYiNpQJxvMLW6UdWnoh4mF9Z6hL/jw/t3/h8+weBJt3rt
	1rzFlBuQUUhrFR1p7+Ekq5ak6qL9q3QLyryXTrOD6J+TroxkShZoxu28Hgt5L9pYLcwpdQaIbLF
	JsbSZHGcUF7mDmw==
X-Received: from wmaq7.prod.google.com ([2002:a05:600c:6c87:b0:493:b328:830b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e19:b0:493:f28e:462a with SMTP id 5b1f17b1804b1-493f87e6ba2mr184102835e9.12.1784116769008;
 Wed, 15 Jul 2026 04:59:29 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:58:54 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-14-smostafa@google.com>
Subject: [PATCH v7 13/24] iommu/arm-smmu-v3-kvm: Add MMIO emulation
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

Add data abort handler for the SMMUs, at the moment most registers
are just passthrough.
In the next patches CMDQ/STE emulation will be added which inserts
logic to some register access.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 159 ++++++++++++++++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |  14 ++
 2 files changed, 173 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index be5922d80184..af06c832fc6f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -8,6 +8,7 @@
 
 #include <nvhe/iommu.h>
 #include <nvhe/mem_protect.h>
+#include <nvhe/trap_handler.h>
 
 #include "arm_smmu_v3.h"
 #include "../arm-smmu-v3.h"
@@ -82,6 +83,8 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (!PAGE_ALIGNED(smmu->mmio_addr | smmu->mmio_size))
 		return -EINVAL;
 
+	hyp_spin_lock_init(&smmu->lock);
+	hyp_spin_lock_init(&smmu->hw_lock);
 	ret = __pkvm_host_donate_hyp_mmio(smmu->mmio_addr, smmu->mmio_size, &haddr);
 	if (ret)
 		return ret;
@@ -120,6 +123,8 @@ static int smmu_init(void)
 			goto out_reclaim_smmu;
 	}
 
+	BUILD_BUG_ON(sizeof(hyp_spinlock_t) != sizeof(u32));
+
 	return 0;
 
 out_reclaim_smmu:
@@ -129,6 +134,159 @@ static int smmu_init(void)
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
+		/*
+		 * Clear stage-2 support, hide MSI to avoid write back to cmdq,
+		 * and hide ATS as it is not emulated or handled in TLB invalidation.
+		 */
+		mask = read_only & ~(IDR0_S2P | IDR0_VMID16 | IDR0_MSI | IDR0_HYP | IDR0_ATS);
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
+		if (len != sizeof(u32))
+			break;
+		/* Don't mess with shareability/cacheability.  */
+		if (is_write &&
+		    (val != (FIELD_PREP(CR1_TABLE_SH, ARM_SMMU_SH_ISH) |
+			     FIELD_PREP(CR1_TABLE_OC, CR1_CACHE_WB) |
+			     FIELD_PREP(CR1_TABLE_IC, CR1_CACHE_WB) |
+			     FIELD_PREP(CR1_QUEUE_SH, ARM_SMMU_SH_ISH) |
+			     FIELD_PREP(CR1_QUEUE_OC, CR1_CACHE_WB) |
+			     FIELD_PREP(CR1_QUEUE_IC, CR1_CACHE_WB))))
+			break;
+
+		mask = read_write;
+		break;
+	}
+
+	/* Allowed 32 bit registers. */
+	case ARM_SMMU_EVTQ_IRQ_CFG1:
+	case ARM_SMMU_EVTQ_IRQ_CFG2:
+	case ARM_SMMU_GERROR_IRQ_CFG1:
+	case ARM_SMMU_GERROR_IRQ_CFG2:
+	case ARM_SMMU_PRIQ_IRQ_CFG1:
+	case ARM_SMMU_PRIQ_IRQ_CFG2:
+		/* These are RES0 as MSI support is hidden. */
+		val = 0;
+		if (!is_write)
+			goto out_update_regs;
+		fallthrough;
+	case ARM_SMMU_EVTQ_PROD + SZ_64K:
+	case ARM_SMMU_EVTQ_CONS + SZ_64K:
+	case ARM_SMMU_PRIQ_PROD + SZ_64K:
+	case ARM_SMMU_PRIQ_CONS + SZ_64K:
+	case ARM_SMMU_GERRORN:
+	case ARM_SMMU_IRQ_CTRLACK:
+	case ARM_SMMU_IRQ_CTRL:
+	case ARM_SMMU_CR0ACK:
+	case ARM_SMMU_CR2:
+		if (len != sizeof(u32))
+			break;
+		mask = read_write;
+		break;
+	/* Allowed 64 bit registers. */
+	case ARM_SMMU_EVTQ_IRQ_CFG0:
+	case ARM_SMMU_PRIQ_IRQ_CFG0:
+	case ARM_SMMU_GERROR_IRQ_CFG0:
+		/* These are RES0 as MSI support is hidden. */
+		val = 0;
+		if (!is_write)
+			goto out_update_regs;
+		fallthrough;
+	case ARM_SMMU_EVTQ_BASE:
+	case ARM_SMMU_PRIQ_BASE:
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
+	hyp_spin_lock(&smmu->hw_lock);
+	if (is_write) {
+		if (len == sizeof(u64))
+			writeq_relaxed(val & mask, smmu->base + off);
+		else
+			writel_relaxed(val & mask, smmu->base + off);
+
+		hyp_spin_unlock(&smmu->hw_lock);
+		return true;
+	}
+
+	if (len == sizeof(u64))
+		val = readq_relaxed(smmu->base + off) & mask;
+	else
+		val = readl_relaxed(smmu->base + off) & mask;
+	hyp_spin_unlock(&smmu->hw_lock);
+out_update_regs:
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
@@ -138,4 +296,5 @@ static int smmu_host_stage2_idmap(phys_addr_t start, phys_addr_t end, int prot)
 struct pkvm_iommu_ops smmu_ops = {
 	.init				= smmu_init,
 	.host_stage2_idmap		= smmu_host_stage2_idmap,
+	.dabt_handler			= smmu_dabt_handler,
 };
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index 82b84673e85b..2bda6e03c96c 100644
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
@@ -15,6 +19,9 @@
  * @oas			PA size
  * @pgsize_bitmap	Supported page sizes
  * @sid_bits		Max number of SID bits supported
+ * @lock		Lock to protect SMMU emulation
+ * @hw_lock		Lock to protect SMMU HW (as CMDQ)
+			Order smmu.lock => host_mmu.lock => smmu.hw_lock
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
@@ -24,6 +31,13 @@ struct hyp_arm_smmu_v3_device {
 	unsigned long		oas;
 	unsigned long		pgsize_bitmap;
 	unsigned int		sid_bits;
+#ifdef __KVM_NVHE_HYPERVISOR__
+	hyp_spinlock_t		lock;
+	hyp_spinlock_t		hw_lock;
+#else
+	u32			lock;
+	u32			hw_lock;
+#endif
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.55.0.141.g00534a21ce-goog

