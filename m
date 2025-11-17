Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A2033DEF2
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405330; cv=none; b=R0efOtZIYmQG8SXD8Q5Nrr1QTqTZ+G68/86KDELWTTy+ExK8SA4vsIpKKYU740GV/60enAlpjmqUlMyjDZGaHS5S/D9RG5fpvZ0nPqwn/ga48HZPIwIseplMKa5yanFLbrv/34BpCG0W6NTJMRwctzmBgkQthCSun3jRvOGJFuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405330; c=relaxed/simple;
	bh=qwh5bWqrvxWib+fkY1bKqGNWl7AdpDhlBehg1j6Y/Qc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DITJyB3ASluFF4+jbBnHxMdaPkrNqPV9rVeERYqVoShKfqFn5ZmZHeXHZBVVkCVE34B851uQxzWTL9wH/Lr5fLXB9wiHt8p8MD9nkJ3f7eI9Kl6f65GUG8DupMz4bxgmWOILTKaNh3sybIApX2l7naeOMulNJlzcqdVvDPrUWBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eH3qbfkP; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eH3qbfkP"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b5556d80bso3515934f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405324; x=1764010124; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p3xOR8x6QzbVlWlZrKYLBDo4QOwlksJXf7F4qOhAA+w=;
        b=eH3qbfkPXtlQtyh2/XLl57EJWVh+FKlLdSLU2PJcKJM6KwHuWWPNzNnfXgkfWgDWDy
         7HxgOIR74HoErj2GV8PrwW/3NhQOXulhUjliVANb9vv5fSUZrP/gEFg0HBkWXDK0LLO8
         K4bim8vZnK0GLfppY9Cmd39F0LkZmdyrc2rOlLF+76Au7OruZNfjEyzbVwIwrP7Os/sG
         ACvZhvge6sXmQY0j3vuWdy8UdRmH5TDM2SEC+eFZc638pwjKvF0dMBE9QViQzRr7d438
         7Wn4VIwB7lJnU0m707y1g+cISgLGSZFZwA0K8BgYqtZp+YnfMTHc0T3Zop5mlMmf1jwG
         BMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405324; x=1764010124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p3xOR8x6QzbVlWlZrKYLBDo4QOwlksJXf7F4qOhAA+w=;
        b=ioifUqB1o+HqjsZbZ2nEpYpGGxPcczCZlB3f2j0FyLz6lPG/r4sdpjsY51boCxK2+A
         XP4iuuFgYSHR+5Mbu27btwd+mG9PfiRFdXCPNSxRmWgYhJ/QQi5swTclLJGi6D6E1r7r
         F9apJhf6Bb1P6d/o8rjNYil3DsDFecxjGKpk9smqCx/XZSQ7Kb6TdlUZon7YdxOAjqBE
         Y4uHqkQET40pcxPoEtTI1RusIftwFSP3+uwBgSKtJxa66Ktv1VSU+Yg7svb92cJI+Kzl
         C8MmsZxyU/Eh+jV2yZr77wzpMsVxaKdM+F4H6WFUVwbT4gJhC33FXAwKvolLVXqnMsRo
         4EfA==
X-Forwarded-Encrypted: i=1; AJvYcCU87GxiFN9jtvVDrQY3Lu1P5mWBr4hnrhakXnBnP+Y5ZUXO0MISdYij/BzsX10h0V7YhLXusFQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNkc0T5IgIcmykNOBPUVjv9nnpzbnOlItEjbP/BoNlsG8R8K7p
	zfqw0rvR+C1pivm2qQwoSjO1GagyWe7AK7WrAdyPZQ7zW+SXn7hz/UAimU+OxRM2xeLbu0B6YCA
	p/2adLjBnEAAOXg==
X-Google-Smtp-Source: AGHT+IHCWbQlr8o940tPX5ysnGCiRUYmATJoia86/TFJSTwquzFFs3l4nOHlPBVKTiqXidY7DwnVkD6YGitCIA==
X-Received: from wrio1.prod.google.com ([2002:a5d:6481:0:b0:429:bf18:9f1])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:230d:b0:42b:2e94:5a8f with SMTP id ffacd0b85a97d-42b5939dc13mr12310824f8f.52.1763405324058;
 Mon, 17 Nov 2025 10:48:44 -0800 (PST)
Date: Mon, 17 Nov 2025 18:48:05 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-19-smostafa@google.com>
Subject: [PATCH v5 18/27] iommu/arm-smmu-v3-kvm: Add MMIO emulation
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

At the moment most registers are just passthrough, then in the next
patches CMDQ/STE emulation will be added which inserts logic to some
register access.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 126 ++++++++++++++++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |  10 ++
 2 files changed, 136 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index e45b4e50b1e4..f0dae94daf89 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -8,6 +8,7 @@
 
 #include <nvhe/iommu.h>
 #include <nvhe/mem_protect.h>
+#include <nvhe/trap_handler.h>
 
 #include "arm_smmu_v3.h"
 #include "../arm-smmu-v3.h"
@@ -115,6 +116,7 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	ret = smmu_probe(smmu);
 	if (ret)
 		goto out_ret;
+	hyp_spin_lock_init(&smmu->lock);
 	return 0;
 out_ret:
 	smmu_deinit_device(smmu);
@@ -140,6 +142,8 @@ static int smmu_init(void)
 			goto out_reclaim_smmu;
 	}
 
+	BUILD_BUG_ON(sizeof(hyp_spinlock_t) != sizeof(u32));
+
 	return 0;
 
 out_reclaim_smmu:
@@ -150,6 +154,127 @@ static int smmu_init(void)
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
+	u64 val = regs->regs[rd];
+
+	switch (off) {
+	case ARM_SMMU_IDR0:
+		/* Clear stage-2 support, hide MSI to avoid write back to cmdq */
+		mask = read_only & ~(IDR0_S2P | IDR0_VMID16 | IDR0_MSI | IDR0_HYP);
+		WARN_ON(len != sizeof(u32));
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
+		mask = read_write;
+		WARN_ON(len != sizeof(u32));
+		break;
+	case ARM_SMMU_CR1: {
+		/* Based on Linux implementation */
+		u64 cr2_template = FIELD_PREP(CR1_TABLE_SH, ARM_SMMU_SH_ISH) |
+				FIELD_PREP(CR1_TABLE_OC, CR1_CACHE_WB) |
+				FIELD_PREP(CR1_TABLE_IC, CR1_CACHE_WB) |
+				FIELD_PREP(CR1_QUEUE_SH, ARM_SMMU_SH_ISH) |
+				FIELD_PREP(CR1_QUEUE_OC, CR1_CACHE_WB) |
+				FIELD_PREP(CR1_QUEUE_IC, CR1_CACHE_WB);
+		/* Don't mess with shareability/cacheability. */
+		if (is_write)
+			WARN_ON(val != cr2_template);
+		mask = read_write;
+		WARN_ON(len != sizeof(u32));
+		break;
+	}
+	/*
+	 * These should be safe, just enforce RO or RW and size according to architecture.
+	 * There are some other registers that are not used by Linux as IDR2, IDR4
+	 * that won't be allowed.
+	 */
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
+		/* These are 32 bit registers. */
+		WARN_ON(len != sizeof(u32));
+		fallthrough;
+	case ARM_SMMU_EVTQ_BASE:
+	case ARM_SMMU_EVTQ_IRQ_CFG0:
+	case ARM_SMMU_PRIQ_BASE:
+	case ARM_SMMU_PRIQ_IRQ_CFG0:
+	case ARM_SMMU_GERROR_IRQ_CFG0:
+		mask = read_write;
+		break;
+	case ARM_SMMU_IIDR:
+	case ARM_SMMU_IDR5:
+	case ARM_SMMU_IDR3:
+	case ARM_SMMU_IDR1:
+	case ARM_SMMU_GERROR:
+		WARN_ON(len != sizeof(u32));
+		mask = read_only;
+	};
+
+	if (WARN_ON(!mask))
+		goto out_ret;
+
+	if (is_write) {
+		if (len == sizeof(u64))
+			writeq_relaxed(regs->regs[rd] & mask, smmu->base + off);
+		else
+			writel_relaxed(regs->regs[rd] & mask, smmu->base + off);
+	} else {
+		if (len == sizeof(u64))
+			regs->regs[rd] = readq_relaxed(smmu->base + off) & mask;
+		else
+			regs->regs[rd] = readl_relaxed(smmu->base + off) & mask;
+	}
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
 static void smmu_host_stage2_idmap(phys_addr_t start, phys_addr_t end, int prot)
 {
 }
@@ -158,4 +283,5 @@ static void smmu_host_stage2_idmap(phys_addr_t start, phys_addr_t end, int prot)
 struct kvm_iommu_ops smmu_ops = {
 	.init				= smmu_init,
 	.host_stage2_idmap		= smmu_host_stage2_idmap,
+	.dabt_handler			= smmu_dabt_handler,
 };
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index 3550fa695539..dfeaed728982 100644
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
@@ -16,6 +20,7 @@
  * @oas			PA size
  * @pgsize_bitmap	Supported page sizes
  * @sid_bits		Max number of SID bits supported
+ * @lock		Lock to protect SMMU
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
@@ -26,6 +31,11 @@ struct hyp_arm_smmu_v3_device {
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
2.52.0.rc1.455.g30608eb744-goog

