Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0192F33C0
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:37 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id r2so17218897wrv.7
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogoJYdqMJ4g5GUWJrI0QukkMIBQ9PcYbe+mf6Y203jA=;
        b=D5Y/xRm4xLA6C0D9t+4DIpvSu1El8jqjtQ4txLIlVoel4aG/C2FPWYKJ7R8d08UjtX
         XOC8EB6SV0W1viHG80fDjiOjStvG8Yxow3hwjDvgD/2JeEij0P/CLnR9YDv2yqKHutCK
         bgXcq2MpsrQnaKWTzh6oFWhrTcANQh4mNOnDZweaOrzWAb+hj3N2d20B4l/gb7M0KUkr
         83cNaZlHF1nMGQ+AzinbTz3b2d8daA6FttBUsvZIVzVatjcW8BHhB+0WpWZEVvHrJJPL
         pUNpERCH+ruK5JN0Bswao3T/5TukWTNvyXkuGk3gpzuklf/q9Lso2qYTM127FWpREWMA
         x7zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogoJYdqMJ4g5GUWJrI0QukkMIBQ9PcYbe+mf6Y203jA=;
        b=6P0XohtvW6Ly7MJ9NVBohT/szX4z+6v5hP7jnM7jzFvkcfyGOdI5GDXmwcjQDnCgmh
         +NVCHmjy9MkI01ozPfa9CU2C6NPP0MTmYGCAmkjN8vLeILxwXqss/wCbxK6o+dFC69RN
         VzpG/iNCJs5ZamnMIbQRVnKub5PW3GI7k1CuS3c8vFF1rk7C0xrMzlhYkRWXdKP6rwvS
         49xB5cbVn+y4WumsgijoDWw0zSZB52qs6G9Xp9/xdFg5gJHTqeJj2XckkE7rJsIBrVm2
         Xs3CUWpiWTSIr1BbYDpXlEtNJ0YhfmIgGHOb7xnQAjWKMEEQy3gAt9oX/lqtklxdz/5a
         vplw==
X-Gm-Message-State: AO0yUKWMfTckfALlUjCWXZ20XgCIzMGdJn5shQHaKhqA7qO31ShO4LaW
	FmLZvsoyTID145d2b83wO9N0KA==
X-Google-Smtp-Source: AK7set9ecmI8fH1x8/IP0jocMgu8/miP1/FCyu/fweWwbQ2tLfit21+GY6n1mksbXY6L6TxQl9v3gg==
X-Received: by 2002:a5d:4211:0:b0:2bf:ae1e:5280 with SMTP id n17-20020a5d4211000000b002bfae1e5280mr2124506wrq.59.1675256377529;
        Wed, 01 Feb 2023 04:59:37 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:37 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 23/45] KVM: arm64: smmu-v3: Setup command queue
Date: Wed,  1 Feb 2023 12:53:07 +0000
Message-Id: <20230201125328.2186498-24-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Map the command queue allocated by the host into the hypervisor address
space. When the host mappings are finalized, the queue is unmapped from
the host.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/arm_smmu_v3.h                   |   4 +
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 148 ++++++++++++++++++++
 2 files changed, 152 insertions(+)

diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
index d4b1e487b7d7..da36737bc1e0 100644
--- a/include/kvm/arm_smmu_v3.h
+++ b/include/kvm/arm_smmu_v3.h
@@ -18,8 +18,12 @@ struct hyp_arm_smmu_v3_device {
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
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index 75a6aa01b057..36ee5724f36f 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -40,12 +40,119 @@ struct hyp_arm_smmu_v3_device __ro_after_init *kvm_hyp_arm_smmu_v3_smmus;
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
 	return smmu_wait(readl_relaxed(smmu->base + ARM_SMMU_CR0ACK) == val);
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
+	case CMDQ_OP_CFGI_STE:
+		cmd[0] |= FIELD_PREP(CMDQ_CFGI_0_SID, ent->cfgi.sid);
+		cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_LEAF, ent->cfgi.leaf);
+		break;
+	case CMDQ_OP_TLBI_NSNH_ALL:
+		break;
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
@@ -77,6 +184,43 @@ static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+/* Transfer ownership of structures from host to hyp */
+static void *smmu_take_pages(u64 base, size_t size)
+{
+	void *hyp_ptr;
+
+	hyp_ptr = hyp_phys_to_virt(base);
+	if (pkvm_create_mappings(hyp_ptr, hyp_ptr + size, PAGE_HYP))
+		return NULL;
+
+	return hyp_ptr;
+}
+
+static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u64 cmdq_base;
+	size_t cmdq_nr_entries, cmdq_size;
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
+	smmu->cmdq_base = smmu_take_pages(cmdq_base, cmdq_size);
+	if (!smmu->cmdq_base)
+		return -EINVAL;
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
@@ -93,6 +237,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		return ret;
 
+	ret = smmu_init_cmdq(smmu);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.39.0

