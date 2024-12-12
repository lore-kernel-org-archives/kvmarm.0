Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E2E236F92
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026743; cv=none; b=MpfEOzk7TxyjfynS61zf0KGcW6tZa6Wyf1j0IWI6sIj/E3xYw1XZGlPu10DTD/HMHYYy14l1kOZWjsxntAFZy/WtVgd0oqkW/XCL4ckqcKbSERQUA7/NgMFyXN6qSjYpHrEA5NzL/iqeN4pZoFjAu3Iluk+h0nqsxsrvoscgWwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026743; c=relaxed/simple;
	bh=euL9B2UCG6k2HW5isDJ95uh1CP91/CqfM0fov3cwjUc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f0/eK09BrpFR9cSygNv8EHaBZ5HdadndH9GwZi0R8zlpOm4B/w+RyUu3dH++FM1CXiTc6TxLGls/XNVeYALg2sxQkqtdUuU+Yxoy14/lcAIhGh2HL7Q/fTX7oFy9DTFfQsFs6fQAyCeTZC7MviTwe1nJO+61leEAOAIqO6oBaOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3OWTB/yo; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3OWTB/yo"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-38634103b0dso511680f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026740; x=1734631540; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QW55e4r1FCJJZ+Mxmax2CNsYmQyYsh/1We9MYonnJlo=;
        b=3OWTB/yo9rlFA4jfw0TAIcSEJ705qQAns0Zntp3wwGohMw7pETt4fMAs9MhYBVEP8V
         TXwAWRVZx8PP9sCN03my2jIHepxnJx9tWWt/dNHATMJymQizYwh6aTCgAYLpBDkafce3
         dhQtMzAUycAzkvbIUscxPtKRgLmSm3Y6hpLuM2kXm+wx+qxY8e8gyLkL9CmrY+JVeYq9
         czRaBtUktugPEf73ikjrhochzbS6ILv+43H1XUL9+0AxEHeh0EP71Uq6pV56UmV1q7+k
         paX8nbixQ7vu/z+BFxm+OUt8m7OKlgzJyIdkyA14pBdoXYunCwEIielLRGvp/KQInZgd
         e2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026740; x=1734631540;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QW55e4r1FCJJZ+Mxmax2CNsYmQyYsh/1We9MYonnJlo=;
        b=wEfDW+0dHG8iKB+OdDTw5hYuiKi7xsIWwZKFrSRZjgQcIQ50wbcoj0zsTPv9Wnf30o
         52VL9HHoAK3A5bCumQ0RM7MXU3ADcVY62AMADSQsBDTXAijBTHmsZabM/6RKx9iS1OcH
         o0ouRExsZEKhrxybIYLsHOqB6NjVJ9AeP3s1X5Lyvrx7PqpcRduruSD2uRczJFy5Fb4s
         cHy8jBkbwoHznIw2tpQ6dvbnweOdfu9byEI8fKeBAY07uqB2qjzGCQ30Y0QhOkAQWoAH
         AA/Ffwn02k3lec00UlYqbNhOi77HhoC/a3ugp8r6UjoX5k3yjSzfMQ22ftTrCvQM5mTW
         9h8A==
X-Forwarded-Encrypted: i=1; AJvYcCUYpqeCmLvXcRYNnamBNfK4laJaNiZtR7JrVtv+uVb8LBV+xIRc00NYlJAzy25hEti8wo3eUFo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwM3ZnbAHQLH9PCSkSIh87USTpGiDJYKjU18BzMIsFy7BmtOEVj
	aPs5MaRyAoG8cx7I1QEmj3atRvqdIfFCmXFL298TnmZGMbJDS6w1aWxvUJMOBaA+hCSBeKF7nAU
	V73foQnVgcg==
X-Google-Smtp-Source: AGHT+IHB49GVFxhdt7ghgV1N9Jg4Guc+tgbfuRWfQoxnqpfh1xTzyJZXQcrGjuehIps7RcSM/ejov5lNnWr6nQ==
X-Received: from wmoy17.prod.google.com ([2002:a05:600c:17d1:b0:434:e665:11a3])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:186b:b0:385:ec8d:8ca9 with SMTP id ffacd0b85a97d-387877c98ffmr3854714f8f.42.1734026739887;
 Thu, 12 Dec 2024 10:05:39 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:51 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-28-smostafa@google.com>
Subject: [RFC PATCH v2 27/58] KVM: arm64: smmu-v3: Setup command queue
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

Map the command queue allocated by the host into the hypervisor address
space. When the host mappings are finalized, the queue is unmapped from
the host.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 165 ++++++++++++++++++++
 include/kvm/arm_smmu_v3.h                   |   4 +
 2 files changed, 169 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index f7e60c188cb0..e15356509424 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -41,6 +41,15 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
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
@@ -60,6 +69,123 @@ static void smmu_reclaim_pages(u64 phys, size_t size)
 	WARN_ON(__pkvm_hyp_donate_host(phys >> PAGE_SHIFT, size >> PAGE_SHIFT));
 }
 
+#define Q_WRAP(smmu, reg)	((reg) & (1 << (smmu)->cmdq_log2size))
+#define Q_IDX(smmu, reg)	((reg) & ((1 << (smmu)->cmdq_log2size) - 1))
+
+static bool smmu_cmdq_full(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u64 cons = readl_relaxed(smmu->base + ARM_SMMU_CMDQ_CONS);
+
+	return Q_IDX(smmu, smmu->cmdq_prod) == Q_IDX(smmu, cons) &&
+	       Q_WRAP(smmu, smmu->cmdq_prod) != Q_WRAP(smmu, cons);
+}
+
+static bool smmu_cmdq_empty(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u64 cons = readl_relaxed(smmu->base + ARM_SMMU_CMDQ_CONS);
+
+	return Q_IDX(smmu, smmu->cmdq_prod) == Q_IDX(smmu, cons) &&
+	       Q_WRAP(smmu, smmu->cmdq_prod) == Q_WRAP(smmu, cons);
+}
+
+static int smmu_add_cmd(struct hyp_arm_smmu_v3_device *smmu,
+			struct arm_smmu_cmdq_ent *ent)
+{
+	int i;
+	int ret;
+	u64 cmd[CMDQ_ENT_DWORDS] = {};
+	int idx = Q_IDX(smmu, smmu->cmdq_prod);
+	u64 *slot = smmu->cmdq_base + idx * CMDQ_ENT_DWORDS;
+
+	if (smmu->iommu.power_is_off)
+		return -EPIPE;
+
+	ret = smmu_wait_event(smmu, !smmu_cmdq_full(smmu));
+	if (ret)
+		return ret;
+
+	cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);
+
+	switch (ent->opcode) {
+	case CMDQ_OP_CFGI_ALL:
+		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
+		break;
+	case CMDQ_OP_CFGI_CD:
+		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SSID, ent->cfgi.ssid);
+		fallthrough;
+	case CMDQ_OP_CFGI_STE:
+		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
+		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
+		break;
+	case CMDQ_OP_TLBI_NH_VA:
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, ent->tlbi.num);
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_SCALE, ent->tlbi.scale);
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
+		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_LEAF, ent->tlbi.leaf);
+		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TTL, ent->tlbi.ttl);
+		cmd[1] |= FIELD_PREP(CMDQ_TLBI_1_TG, ent->tlbi.tg);
+		cmd[1] |= ent->tlbi.addr & CMDQ_TLBI_1_VA_MASK;
+		break;
+	case CMDQ_OP_TLBI_NSNH_ALL:
+		break;
+	case CMDQ_OP_TLBI_NH_ASID:
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
+		fallthrough;
+	case CMDQ_OP_TLBI_S12_VMALL:
+		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, ent->tlbi.vmid);
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
+	case CMDQ_OP_CMD_SYNC:
+		cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_SEV);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	for (i = 0; i < CMDQ_ENT_DWORDS; i++)
+		slot[i] = cpu_to_le64(cmd[i]);
+
+	smmu->cmdq_prod++;
+	writel(Q_IDX(smmu, smmu->cmdq_prod) | Q_WRAP(smmu, smmu->cmdq_prod),
+	       smmu->base + ARM_SMMU_CMDQ_PROD);
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
+	return smmu_wait_event(smmu, smmu_cmdq_empty(smmu));
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
@@ -94,6 +220,41 @@ static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u64 cmdq_base;
+	size_t cmdq_nr_entries, cmdq_size;
+	int ret;
+	enum kvm_pgtable_prot prot = PAGE_HYP;
+
+	cmdq_base = readq_relaxed(smmu->base + ARM_SMMU_CMDQ_BASE);
+	if (cmdq_base & ~(Q_BASE_RWA | Q_BASE_ADDR_MASK | Q_BASE_LOG2SIZE))
+		return -EINVAL;
+
+	smmu->cmdq_log2size = cmdq_base & Q_BASE_LOG2SIZE;
+	cmdq_nr_entries = 1 << smmu->cmdq_log2size;
+	cmdq_size = cmdq_nr_entries * CMDQ_ENT_DWORDS * 8;
+
+	cmdq_base &= Q_BASE_ADDR_MASK;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		prot |= KVM_PGTABLE_PROT_NORMAL_NC;
+
+	ret = ___pkvm_host_donate_hyp_prot(cmdq_base >> PAGE_SHIFT,
+					   PAGE_ALIGN(cmdq_size) >> PAGE_SHIFT,
+					   false, prot);
+	if (ret)
+		return ret;
+
+	smmu->cmdq_base = hyp_phys_to_virt(cmdq_base);
+
+	memset(smmu->cmdq_base, 0, cmdq_size);
+	writel_relaxed(0, smmu->base + ARM_SMMU_CMDQ_PROD);
+	writel_relaxed(0, smmu->base + ARM_SMMU_CMDQ_CONS);
+
+	return 0;
+}
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	int ret;
@@ -113,6 +274,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		return ret;
 
+	ret = smmu_init_cmdq(smmu);
+	if (ret)
+		return ret;
+
 	return kvm_iommu_init_device(&smmu->iommu);
 }
 
diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
index fb24bcef1624..393a1a04edba 100644
--- a/include/kvm/arm_smmu_v3.h
+++ b/include/kvm/arm_smmu_v3.h
@@ -16,8 +16,12 @@ struct hyp_arm_smmu_v3_device {
 	struct kvm_hyp_iommu	iommu;
 	phys_addr_t		mmio_addr;
 	size_t			mmio_size;
+	unsigned long		features;
 
 	void __iomem		*base;
+	u32			cmdq_prod;
+	u64			*cmdq_base;
+	size_t			cmdq_log2size;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.47.0.338.g60cca15819-goog

