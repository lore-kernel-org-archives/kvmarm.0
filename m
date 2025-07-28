Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6B1284B4E
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725234; cv=none; b=keVuFnE35qAv/1vCH0Gt7BVRKKXvOAVw/RqfRj/t219bGjJysMCz2SnxbCoqFdH2B52v2lOy32ngWeKY9QzY4RuhciVjuC1L5glPfpNDkKoI8lWXo0ZH0gjr+GqRt7LbXnnlPh76IoeI363HaFbZgHn+CYqfOYEOAnU895ujYwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725234; c=relaxed/simple;
	bh=6EFSM3MDGo4OM8NAGgtSWKnL4dD2aOc8PRvzxwpNhxs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fsRTB5eIfKGnKyZEgtpTLWHLUcyD1dX1JtX1/e6hgp3XEGKmIZJEq4i+DicmOCkL12rSxKX0dklMqx0DfzVagdW6nx/6jbdPyi0SLGDjxc3ErSjeF7kBsa9kMsEc1UAxs5FT0gNbsuB0DpQd4306V6i4pDhKaF8Z8QM2Ljw3NZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HLh6bmNA; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HLh6bmNA"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45600d19a2aso36159975e9.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725230; x=1754330030; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nmaCz/hZ0Y09KM1Z6dU4zeUMZqIx6D4vddfShUP8jOw=;
        b=HLh6bmNArJ0P/KzAAa0xLoqYqAoBKobLZr+GmwZ/3gL6x7E6qTR/S3J2Vp5aVKwSEz
         ZrX16Bji/scf6PnfIhAFvMSkUzuG3J5TyFe08LjMZLYtvHZXtOMWx+3SmIiMye4Jn6y0
         HBDMoNUz7MOjW8Vxu7Hc72S4L5H1FKRXmSbLsqS+1sA77VxtXP44fRoFr4cAAgFSPqdc
         HCHinm4I8ON5qUu3kbkMFMsWk+Ra3lvfyeFoVKOZOU7cDwzEC8hC7FcygBJLv+/Gemq2
         jFHuIfgAGtScLOAd+YhQLMC2Vp3p+c1Oc482n164/eVZlsAQJgWR/Uas2VJEc14yqxM2
         Wv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725230; x=1754330030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nmaCz/hZ0Y09KM1Z6dU4zeUMZqIx6D4vddfShUP8jOw=;
        b=rgTAM9k7wMTQro8IilBR6OzYyCI58X04kZ/Lw0x3Kx2hftFqA2muQtIaX//7AKsqGl
         TpCs6YM1wmK7bX0w0imCeRwYV24w4PtLz8CD2Ogb4FqYwdt5+1hO6RQfhAlrKNZY3TW8
         I6iR0aaDK6bWw4xL+4N/9mH6kDnjckKoDfQImmx30QW8LR7KOAsxj+/0Czxw+kXPDPm6
         nPBVu7FwJtcID1vhUlN7n7k2jKS+1FIjtNtRU+itqzyThSrXJbB8cLwzzgVGA0JoFWcT
         nDXOAegBt/bO++5Ur0Fd/OWZPUSF++ahupYBLbXUPkMPVZX+nNri8xtQ5yF/CdmI9XmV
         58Ww==
X-Forwarded-Encrypted: i=1; AJvYcCViuGp5yLcjhp2O0T615Lx8ZotJrZ0dnebzbfLZ1hAO0Mthi+eHDtqrc+pI3i6A8hHJZIj6R7Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yys45oHYG50BDu8+IRlZkSD4QueBfCpE0HgL75+FTce0BQTxTrl
	vpOO3h9MkdIb7qSVXRQSBpWiAoBSc9WIhJfhzJDvRjq7Oo6hS+xMjzYKqAIFRM6jawK9IYDP/5r
	jSJ462nZ1lII8UA==
X-Google-Smtp-Source: AGHT+IGR+nDxQJC/TBVqY+VnaXcYcs4NqE/3pTQmZ3LkxhlmaQpfACsdvZZWOYaCQDE09t36WXjxu0J7xih9pA==
X-Received: from wmbdw9.prod.google.com ([2002:a05:600c:6389:b0:451:4d6b:5b7e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6088:b0:456:e39:ec1a with SMTP id 5b1f17b1804b1-45883089729mr58139855e9.14.1753725229980;
 Mon, 28 Jul 2025 10:53:49 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:53:07 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-21-smostafa@google.com>
Subject: [PATCH v3 20/29] iommu/arm-smmu-v3-kvm: Setup command queue
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Map the command queue allocated by the host into the hypervisor address
space. When the host mappings are finalized, the queue is unmapped from
the host.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 104 ++++++++++++++++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |   4 +
 2 files changed, 108 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index e9bc35e019b6..c3d67c603619 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -39,6 +39,15 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 	__ret;							\
 })
 
+#define smmu_wait_event(_smmu, _cond)				\
+({								\
+	if ((_smmu)->features & ARM_SMMU_FEAT_SEV) {		\
+		while (!(_cond))				\
+			wfe();					\
+	}							\
+	smmu_wait(_cond);					\
+})
+
 static int smmu_write_cr0(struct hyp_arm_smmu_v3_device *smmu, u32 val)
 {
 	writel_relaxed(val, smmu->base + ARM_SMMU_CR0);
@@ -58,6 +67,70 @@ static void smmu_reclaim_pages(u64 phys, size_t size)
 	WARN_ON(__pkvm_hyp_donate_host(phys >> PAGE_SHIFT, size >> PAGE_SHIFT));
 }
 
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
+static int smmu_add_cmd(struct hyp_arm_smmu_v3_device *smmu,
+			struct arm_smmu_cmdq_ent *ent)
+{
+	int ret;
+	u64 cmd[CMDQ_ENT_DWORDS];
+	struct arm_smmu_queue *q = &smmu->cmdq;
+	struct arm_smmu_ll_queue *llq = &q->llq;
+
+	ret = smmu_wait_event(smmu, !smmu_cmdq_full(&smmu->cmdq));
+	if (ret)
+		return ret;
+
+	ret = arm_smmu_cmdq_build_cmd(cmd, ent);
+	if (ret)
+		return ret;
+
+	queue_write(Q_ENT(q, llq->prod), cmd,  CMDQ_ENT_DWORDS);
+	llq->prod = queue_inc_prod_n(llq, 1);
+	writel_relaxed(llq->prod, q->prod_reg);
+	return 0;
+}
+
+static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int ret;
+	struct arm_smmu_cmdq_ent cmd = {
+		.opcode = CMDQ_OP_CMD_SYNC,
+	};
+
+	ret = smmu_add_cmd(smmu, &cmd);
+	if (ret)
+		return ret;
+
+	return smmu_wait_event(smmu, smmu_cmdq_empty(&smmu->cmdq));
+}
+
+__maybe_unused
+static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
+			 struct arm_smmu_cmdq_ent *cmd)
+{
+	int ret = smmu_add_cmd(smmu, cmd);
+
+	if (ret)
+		return ret;
+
+	return smmu_sync_cmd(smmu);
+}
+
 static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
 {
 	u64 val, old;
@@ -105,6 +178,33 @@ static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 	}
 }
 
+static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
+{
+	size_t cmdq_size;
+	int ret;
+	enum kvm_pgtable_prot prot = PAGE_HYP;
+
+	cmdq_size = (1 << (smmu->cmdq.llq.max_n_shift)) *
+		     CMDQ_ENT_DWORDS * 8;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		prot |= KVM_PGTABLE_PROT_NORMAL_NC;
+
+	ret = ___pkvm_host_donate_hyp(smmu->cmdq.base_dma >> PAGE_SHIFT,
+				      PAGE_ALIGN(cmdq_size) >> PAGE_SHIFT, prot);
+	if (ret)
+		return ret;
+
+	smmu->cmdq.base = hyp_phys_to_virt(smmu->cmdq.base_dma);
+	smmu->cmdq.prod_reg = smmu->base + ARM_SMMU_CMDQ_PROD;
+	smmu->cmdq.cons_reg = smmu->base + ARM_SMMU_CMDQ_CONS;
+	memset(smmu->cmdq.base, 0, cmdq_size);
+	writel_relaxed(0, smmu->cmdq.prod_reg);
+	writel_relaxed(0, smmu->cmdq.cons_reg);
+
+	return 0;
+}
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	int i;
@@ -129,6 +229,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	ret = smmu_init_registers(smmu);
 	if (ret)
 		goto out_err;
+	ret = smmu_init_cmdq(smmu);
+	if (ret)
+		goto out_err;
+
 	return ret;
 
 out_err:
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index 9b1d021ada63..f639312cf295 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -11,12 +11,16 @@
  * @mmio_addr		base address of the SMMU registers
  * @mmio_size		size of the registers resource
  * @base		Virtual address of SMMU registers
+ * @features		SMMUv3 features as defined in arm-smmu-v3-common.h
+ * @cmdq		CMDQ queue struct
  * Other members are filled and used at runtime by the SMMU driver.
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
 	size_t			mmio_size;
 	void __iomem		*base;
+	unsigned long		features;
+	struct arm_smmu_queue	cmdq;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.50.1.552.g942d659e1b-goog

