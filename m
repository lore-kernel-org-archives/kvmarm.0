Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACCA54EEDC
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082804; cv=none; b=SP9cKZlFK1+PWbqHx+AQZQ2GSkGQCl92qLAQL/MlbPNDP9vc+J5vko8ufbLFXqcvd7fW+5230ffY/7MtRPJPCTMK2kONSv07ExNDnLJlzdCSDRRcX70HPfOeHU+OMWCGLcdrGeazvhHvyQndVBN5Zmmh7LfifjgVogCFNmjurqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082804; c=relaxed/simple;
	bh=UUvNqmut7UEKlF4jh6JlVZDEBcMpAxt56G4w6FnCqKg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PTD2fquMXSPDZRDr8ZJhi9OmT307Xd+4XR4kdmWxLirXx8XAXFxba3tPKGg0EfwD1nvLLSy45hwfcEuECOhzvfGZcOXmQze9dlhy6nIDddis9Q862shKRYYug25RWDkZGxuaToczwFzPFQv+38BHYi5vpXw98CHucQIRQz/Hc+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oC+VdVpl; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oC+VdVpl"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e76a80fe5so57903125e9.2
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082799; x=1790687599; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kXio9q3HXbV99t7QvdKbUG1SAfPkxiR4UmV0lVPZQhU=;
        b=oC+VdVplkztDggIHpS/xpjKrLHxSNeSHHJErE1VyDAv0MqWucOszthrSVD/rTtzv/k
         6/9T6Rxy+wGzxZLR0JBeEi+5zzvsWLBhr5o44VmgiCAMJUO09Suf5HXTiekFYEQZ6kDs
         VlRWlKMsoDUdbG1ELoTxTonViOtQ61FcgkQOFPWxv6miGSeZ39dYwg3sYBdqjhCpvn+W
         E1/iZsRMQIohbW/BnYhWSKpCJmY2JMQ38xLv4NMISXdwiXzgMJvcrxgtg9qRd4vxwtRc
         ngyC8S9ctaV7tQXpJqSzbhgngVCdUT8k6lzUxTIEBgF497itgoINelz467wKCoK2bpEc
         /wOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082799; x=1790687599;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kXio9q3HXbV99t7QvdKbUG1SAfPkxiR4UmV0lVPZQhU=;
        b=u7qvTReteSuICFph8MFAXd4TffZksAsTGWIBbrXHPi42fT5UJXCOvd2si12DnfWrLT
         rKSixx8M2iD1J8ZdqOO7g7ucTJRYvtTqTlsRlGgk4Bq45TN83H7poCB9zafWmtQ+gCnL
         yopKyNNO/0RQhkKHE/Pa27ew8kME7FwwZn0z/OKo842tgfDucKX5EO8a49s1UaJXtLV2
         hcaphikoXePSw/w1kDYs6WiwPYepxc1jt97JWbvPqaPLe5mJoWeVUAmoMMqjnDN//ZYb
         522QPweUvPCYSsZVdVsGS5JMu0pz+5lrsZ8AqCBRdDUD08JfOpkinbSrbaxeYK1Cn+zr
         1aog==
X-Forwarded-Encrypted: i=1; AKwUvBz4pWFpe2dEopegcqijxVvQBO0ecOPm/UfVm3HZFFxtETK5W3l3lWvYey9E85E+fD8qIzlGo4A=@lists.linux.dev
X-Gm-Message-State: AFuF++nRMjf7DIKj0KUI/L/zSJ8wkV9kFIP+3HI74ztD2SVsnHzYLrb5
	vPJsiG3w/40bIdd2N8qkwg1Nc69Ctld6AGu7WxZr8svLuFExvZDEV+fAstb4lxiTP6MqqqoxNfH
	tyV6aQNspFlqSIg==
X-Received: from wmhf5.prod.google.com ([2002:a7b:cc05:0:b0:49d:e4a3:4a99])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1548:b0:49e:6ac4:b76e with SMTP id 5b1f17b1804b1-49fc574eed4mr206100225e9.30.1790082799463;
 Tue, 22 Sep 2026 06:13:19 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:47 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-15-smostafa@google.com>
Subject: [PATCH v8 14/25] iommu/arm-smmu-v3-kvm: Shadow the command queue
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

At boot, allocate a command queue per SMMU which is used as a shadow
by the hypervisor.

The command queue size is 64K which is more than enough, as the
hypervisor would consume all the entries per a command queue prod
write, which means it can handle up to 4096 at a time.

Then, the host command queue needs to be pinned in a shared state, so
it can't be donated to VMs, and avoid tricking the hypervisor into
accessing them. This is done each time the command queue is enabled,
and undone each time the command queue is disabled.
The hypervisor won't access the host command queue when it is disabled
from the host.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   |  25 ++++
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h    |  10 ++
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 124 ++++++++++++++++++
 3 files changed, 159 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 9947d3a44304..28f8b1fba8f7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -15,6 +15,8 @@
 #include "arm-smmu-v3.h"
 #include "pkvm/arm-smmu-v3-hyp.h"
 
+#define SMMU_KVM_CMDQ_ORDER		get_order(MAX(SZ_64K, PAGE_SIZE))
+
 extern struct pkvm_iommu_ops kvm_nvhe_sym(smmu_ops);
 
 static size_t				kvm_arm_smmu_count;
@@ -24,6 +26,15 @@ static size_t				kvm_arm_smmu_cur;
 static void kvm_arm_smmu_array_free(void)
 {
 	int order;
+	int i;
+
+	for (i = 0 ; i < kvm_arm_smmu_cur ; ++i) {
+		struct hyp_arm_smmu_v3_device *smmu = &kvm_arm_smmu_array[i];
+
+		if (smmu->cmdq.base_dma)
+			free_pages((unsigned long)phys_to_virt(smmu->cmdq.base_dma),
+				   SMMU_KVM_CMDQ_ORDER);
+	}
 
 	order = get_order(kvm_arm_smmu_count * sizeof(*kvm_arm_smmu_array));
 	free_pages((unsigned long)kvm_arm_smmu_array, order);
@@ -70,6 +81,7 @@ static int smmuv3_nesting_probe(struct platform_device *pdev)
 	struct hyp_arm_smmu_v3_device *smmu = &kvm_arm_smmu_array[kvm_arm_smmu_cur];
 	struct device *dev = &pdev->dev;
 	struct resource *res;
+	void *cmdq_base;
 
 	/* Only device tree, ACPI not supported. */
 	if (!dev->of_node)
@@ -92,6 +104,19 @@ static int smmuv3_nesting_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	/*
+	 * Allocate the shadow command queue, it doesn't have to be the same
+	 * size as the host.
+	 * Only populate base_dma and llq.max_n_shift, the hypervisor will init
+	 * the rest.
+	 */
+	cmdq_base = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, SMMU_KVM_CMDQ_ORDER);
+	if (!cmdq_base)
+		return -ENOMEM;
+
+	smmu->cmdq.base_dma = virt_to_phys(cmdq_base);
+	smmu->cmdq.llq.max_n_shift = SMMU_KVM_CMDQ_ORDER + PAGE_SHIFT - CMDQ_ENT_SZ_SHIFT;
+
 	if (of_dma_is_coherent(dev->of_node))
 		smmu->features |= ARM_SMMU_FEAT_COHERENCY;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
index 58fa14c239e3..39afdeffcd63 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
@@ -8,6 +8,8 @@
 #include <nvhe/spinlock.h>
 #endif
 
+#include "../arm-smmu-v3.h"
+
 /*
  * Parameters from the trusted host:
  * @mmio_addr		base address of the SMMU registers
@@ -21,6 +23,10 @@
  * @lock		Lock to protect SMMU emulation
  * @hw_lock		Lock to protect SMMU HW (as CMDQ)
  *			Order smmu.lock => host_mmu.lock => smmu.hw_lock
+ * @cmdq		CMDQ as observed by HW
+ * @cmdq_host		Host view of the CMDQ, only q_base and llq used.
+ * @cmdq_max_shift	Max shift for the CMDQ probed from HW.
+ * @cr0			Last value of CR0
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
@@ -38,6 +44,10 @@ struct hyp_arm_smmu_v3_device {
 	u32			lock;
 	u32			hw_lock;
 #endif
+	struct arm_smmu_queue	cmdq;
+	struct arm_smmu_queue	cmdq_host;
+	u32			cmdq_max_shift;
+	u32			cr0;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 7a51cb70205f..b26c21b595b4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -22,11 +22,68 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 	     (smmu) != &kvm_hyp_arm_smmu_v3_smmus[kvm_hyp_arm_smmu_v3_count]; \
 	     (smmu)++)
 
+#define cmdq_size(cmdq)	((1 << ((cmdq)->llq.max_n_shift)) * CMDQ_ENT_DWORDS * 8)
+
+static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
+{
+	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
+}
+
+/*
+ * CMDQ, STE host copies are accessed by the hypervisor, we share them to
+ * - Prevent the host from passing protected VM memory.
+ * - Having them mapped in the hyp page table.
+ */
+static int smmu_share_pages(phys_addr_t addr, size_t size)
+{
+	size_t nr_pages = PAGE_ALIGN(size + (addr & ~PAGE_MASK)) >> PAGE_SHIFT;
+	phys_addr_t base = addr & PAGE_MASK;
+	int i, ret;
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (__pkvm_host_share_hyp((base + i * PAGE_SIZE) >> PAGE_SHIFT)) {
+			while (i--)
+				__pkvm_host_unshare_hyp((base + i * PAGE_SIZE) >> PAGE_SHIFT);
+			return -EPERM;
+		}
+	}
+
+	ret = hyp_pin_shared_mem(hyp_phys_to_virt(base),
+				 hyp_phys_to_virt(base + nr_pages * PAGE_SIZE));
+	if (ret) {
+		for (i = 0; i < nr_pages; ++i)
+			__pkvm_host_unshare_hyp((base + i * PAGE_SIZE) >> PAGE_SHIFT);
+	}
+
+	return ret;
+}
+
+static int smmu_unshare_pages(phys_addr_t addr, size_t size)
+{
+	size_t nr_pages = PAGE_ALIGN(size + (addr & ~PAGE_MASK)) >> PAGE_SHIFT;
+	phys_addr_t base = addr & PAGE_MASK;
+	int i, ret;
+
+	hyp_unpin_shared_mem(hyp_phys_to_virt(base),
+			     hyp_phys_to_virt(base + nr_pages * PAGE_SIZE));
+
+	for (i = 0; i < nr_pages; ++i) {
+		ret = __pkvm_host_unshare_hyp((base + i * PAGE_SIZE) >> PAGE_SHIFT);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /* Put the device in a state that can be probed by the host driver. */
 static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	WARN_ON(__pkvm_hyp_donate_host_mmio(hyp_phys_to_pfn(smmu->mmio_addr),
 					    smmu->mmio_size >> PAGE_SHIFT));
+	if (smmu->cmdq.base)
+		WARN_ON(__pkvm_hyp_donate_host(smmu->cmdq.base_dma >> PAGE_SHIFT,
+					       PAGE_ALIGN(cmdq_size(&smmu->cmdq)) >> PAGE_SHIFT));
 	smmu->base = NULL;
 }
 
@@ -53,6 +110,7 @@ static int smmu_probe(struct hyp_arm_smmu_v3_device *smmu)
 		return -EINVAL;
 
 	smmu->sid_bits = FIELD_GET(IDR1_SIDSIZE, reg);
+	smmu->cmdq_max_shift = FIELD_GET(IDR1_CMDQS, reg);
 	/* Follows the kernel logic */
 	if (smmu->sid_bits <= STRTAB_SPLIT)
 		smmu->features &= ~ARM_SMMU_FEAT_2_LVL_STRTAB;
@@ -71,6 +129,33 @@ static int smmu_probe(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+/*
+ * The kernel part of the driver will allocate the shadow cmdq,
+ * and zero it. This function only donates it.
+ */
+static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
+{
+	size_t cmdq_nr_pages;
+	int ret;
+
+	smmu->cmdq.llq.max_n_shift = min(smmu->cmdq.llq.max_n_shift, smmu->cmdq_max_shift);
+	cmdq_nr_pages = PAGE_ALIGN(cmdq_size(&smmu->cmdq)) >> PAGE_SHIFT;
+	ret = __pkvm_host_donate_hyp(smmu->cmdq.base_dma >> PAGE_SHIFT, cmdq_nr_pages);
+	if (ret)
+		return ret;
+
+	smmu->cmdq.base = hyp_phys_to_virt(smmu->cmdq.base_dma);
+	smmu->cmdq.prod_reg = smmu->base + ARM_SMMU_CMDQ_PROD;
+	smmu->cmdq.cons_reg = smmu->base + ARM_SMMU_CMDQ_CONS;
+	smmu->cmdq.q_base = smmu->cmdq.base_dma |
+			    FIELD_PREP(Q_BASE_LOG2SIZE, smmu->cmdq.llq.max_n_shift);
+	smmu->cmdq.ent_dwords = CMDQ_ENT_DWORDS;
+	writel_relaxed(0, smmu->cmdq.prod_reg);
+	writel_relaxed(0, smmu->cmdq.cons_reg);
+	writeq_relaxed(smmu->cmdq.q_base, smmu->base + ARM_SMMU_CMDQ_BASE);
+	return 0;
+}
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	unsigned long haddr;
@@ -92,7 +177,12 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		goto out_ret;
 
+	ret = smmu_init_cmdq(smmu);
+	if (ret)
+		goto out_ret;
+
 	return 0;
+
 out_ret:
 	smmu_deinit_device(smmu);
 	return ret;
@@ -132,6 +222,23 @@ static int smmu_init(void)
 	return ret;
 }
 
+static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u32 shift = smmu->cmdq_host.q_base & Q_BASE_LOG2SIZE;
+
+	smmu->cmdq_host.llq.max_n_shift = min(shift, smmu->cmdq_max_shift);
+	smmu->cmdq_host.base_dma = smmu->cmdq_host.q_base & Q_BASE_ADDR_MASK;
+	smmu->cmdq_host.base_dma &= ~(cmdq_size(&smmu->cmdq_host) - 1);
+	WARN_ON(smmu_share_pages(smmu->cmdq_host.base_dma,
+				 cmdq_size(&smmu->cmdq_host)));
+}
+
+static void smmu_emulate_cmdq_disable(struct hyp_arm_smmu_v3_device *smmu)
+{
+	WARN_ON(smmu_unshare_pages(smmu->cmdq_host.base_dma,
+				   cmdq_size(&smmu->cmdq_host)));
+}
+
 static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 			     struct user_pt_regs *regs,
 			     u64 esr, u32 off)
@@ -158,6 +265,14 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 		break;
 	/* Passthrough the register access for bisectability, handled later */
 	case ARM_SMMU_CMDQ_BASE:
+		if (is_write) {
+			/* Not allowed by the architecture */
+			if (is_cmdq_enabled(smmu))
+				break;
+			smmu->cmdq_host.q_base = val;
+		}
+		mask = read_write;
+		break;
 	case ARM_SMMU_CMDQ_PROD:
 	case ARM_SMMU_CMDQ_CONS:
 	case ARM_SMMU_STRTAB_BASE:
@@ -168,6 +283,15 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 	case ARM_SMMU_CR0:
 		if (len != sizeof(u32))
 			break;
+		if (is_write) {
+			bool last_cmdq_en = is_cmdq_enabled(smmu);
+
+			smmu->cr0 = val;
+			if (!last_cmdq_en && is_cmdq_enabled(smmu))
+				smmu_emulate_cmdq_enable(smmu);
+			else if (last_cmdq_en && !is_cmdq_enabled(smmu))
+				smmu_emulate_cmdq_disable(smmu);
+		}
 		mask = read_write;
 		break;
 	case ARM_SMMU_CR1:
-- 
2.55.0.1082.g2b9226bbc0-goog

