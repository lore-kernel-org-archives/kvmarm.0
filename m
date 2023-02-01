Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E543C63B4
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:39 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id m7so17222799wru.8
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6ny/GGJ/xSBkLuV4RcE+GC+n9HdkCFGxovAOHzkf4Y=;
        b=mXkKJ8GVi2o9hKXvO38ATeKbu/kQNts062SXg30ZfOt60zaBNySaqz9YhPtDU9dW6w
         AW1yaIveh1cDIXzFT25hr8nkVPVGEJmmUcziyjH8QnV1Ty9HQQpGZek4Wgq/YqwpEhbD
         eG7u9b+IfLjB3tlihWtJZMF5NBxRwCkUdrAFQF0NZd1cy/kLh0GceoWrOqtWiUNYgCmm
         uc1674z0i6LT9WQEBxR/UHtAzYZyAqYWjaF022HvtQuOg8HgJ/XwQ0P8xqPQa7NnEaGm
         OUhefUImf2fERRYo6Z/sVaX3gmmesQ+3UVBrGQjTmYoGKQt7YI3SpD3JTr/+XnxNRbe5
         /JNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j6ny/GGJ/xSBkLuV4RcE+GC+n9HdkCFGxovAOHzkf4Y=;
        b=V2jSSlKR1qoVbhiWSS7hK1EmTb26SDflBPZf/ya2MgUaXWcl3czVmfjLeu71li00zO
         JofJNG3Gj6Vr/qGqOWnsgHVIdUrExW6P4XqtqWzqvAKSWZ5a+vMy59XAajAw0QfVF8pV
         5qdankcCU8dtMZjSLcq4UmkR+8ZH+z8Y0XHgjBxB/ONQ39BLL5eUeuPHf+vHBAK3OvJj
         02PNh57HWBevcm2WkEGQFQ9QUbTHoZwK+AYZkiGuatowfz+xXKmKPEuQlwNJMDy4JEnM
         SyRFkTAZWINDACfBn64lcjckbByAOm1tllFuMwigmKsFNuVZ+5SUazYlfXgJ3h60y6qK
         AuxA==
X-Gm-Message-State: AO0yUKUv0xgv5KP9SXFn2SnbMIXbdfFHn9cjhx/974uHmkx4WT3nDFdk
	MfgsM97+xyZXA0OuOEPkkxLPXA==
X-Google-Smtp-Source: AK7set/uX5ReOHShIxYjKCrFXO8QhEm90M+SO3bJfnKAiOUk5aZz9Jj3/ob0BmcC5+s7c5TD4BjyEg==
X-Received: by 2002:a5d:6d8e:0:b0:2bf:da39:5628 with SMTP id l14-20020a5d6d8e000000b002bfda395628mr2693278wrs.41.1675256378313;
        Wed, 01 Feb 2023 04:59:38 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.37
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
Subject: [RFC PATCH 24/45] KVM: arm64: smmu-v3: Setup stream table
Date: Wed,  1 Feb 2023 12:53:08 +0000
Message-Id: <20230201125328.2186498-25-jean-philippe@linaro.org>
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

Map the stream table allocated by the host into the hypervisor address
space. When the host mappings are finalized, the table is unmapped from
the host. Depending on the host configuration, the stream table may have
one or two levels. Populate the level-2 stream table lazily.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/arm_smmu_v3.h                   |   4 +
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 133 +++++++++++++++++++-
 2 files changed, 136 insertions(+), 1 deletion(-)

diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
index da36737bc1e0..fc67a3bf5709 100644
--- a/include/kvm/arm_smmu_v3.h
+++ b/include/kvm/arm_smmu_v3.h
@@ -24,6 +24,10 @@ struct hyp_arm_smmu_v3_device {
 	u32			cmdq_prod;
 	u64			*cmdq_base;
 	size_t			cmdq_log2size;
+	u64			*strtab_base;
+	size_t			strtab_num_entries;
+	size_t			strtab_num_l1_entries;
+	u8			strtab_split;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index 36ee5724f36f..021bebebd40c 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -141,7 +141,6 @@ static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
 	return smmu_wait_event(smmu, smmu_cmdq_empty(smmu));
 }
 
-__maybe_unused
 static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 			 struct arm_smmu_cmdq_ent *cmd)
 {
@@ -153,6 +152,82 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 	return smmu_sync_cmd(smmu);
 }
 
+__maybe_unused
+static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
+{
+	struct arm_smmu_cmdq_ent cmd = {
+		.opcode = CMDQ_OP_CFGI_STE,
+		.cfgi.sid = sid,
+		.cfgi.leaf = true,
+	};
+
+	return smmu_send_cmd(smmu, &cmd);
+}
+
+static int smmu_alloc_l2_strtab(struct hyp_arm_smmu_v3_device *smmu, u32 idx)
+{
+	void *table;
+	u64 l2ptr, span;
+
+	/* Leaf tables must be page-sized */
+	if (smmu->strtab_split + ilog2(STRTAB_STE_DWORDS) + 3 != PAGE_SHIFT)
+		return -EINVAL;
+
+	span = smmu->strtab_split + 1;
+	if (WARN_ON(span < 1 || span > 11))
+		return -EINVAL;
+
+	table = kvm_iommu_donate_page();
+	if (!table)
+		return -ENOMEM;
+
+	l2ptr = hyp_virt_to_phys(table);
+	if (l2ptr & (~STRTAB_L1_DESC_L2PTR_MASK | ~PAGE_MASK))
+		return -EINVAL;
+
+	/* Ensure the empty stream table is visible before the descriptor write */
+	wmb();
+
+	if ((cmpxchg64_relaxed(&smmu->strtab_base[idx], 0, l2ptr | span) != 0))
+		kvm_iommu_reclaim_page(table);
+
+	return 0;
+}
+
+__maybe_unused
+static u64 *smmu_get_ste_ptr(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
+{
+	u32 idx;
+	int ret;
+	u64 l1std, span, *base;
+
+	if (sid >= smmu->strtab_num_entries)
+		return NULL;
+	sid = array_index_nospec(sid, smmu->strtab_num_entries);
+
+	if (!smmu->strtab_split)
+		return smmu->strtab_base + sid * STRTAB_STE_DWORDS;
+
+	idx = sid >> smmu->strtab_split;
+	l1std = smmu->strtab_base[idx];
+	if (!l1std) {
+		ret = smmu_alloc_l2_strtab(smmu, idx);
+		if (ret)
+			return NULL;
+		l1std = smmu->strtab_base[idx];
+		if (WARN_ON(!l1std))
+			return NULL;
+	}
+
+	span = l1std & STRTAB_L1_DESC_SPAN;
+	idx = sid & ((1 << smmu->strtab_split) - 1);
+	if (!span || idx >= (1 << (span - 1)))
+		return NULL;
+
+	base = hyp_phys_to_virt(l1std & STRTAB_L1_DESC_L2PTR_MASK);
+	return base + idx * STRTAB_STE_DWORDS;
+}
+
 static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
 {
 	u64 val, old;
@@ -221,6 +296,58 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u64 strtab_base;
+	size_t strtab_size;
+	u32 strtab_cfg, fmt;
+	int split, log2size;
+
+	strtab_base = readq_relaxed(smmu->base + ARM_SMMU_STRTAB_BASE);
+	if (strtab_base & ~(STRTAB_BASE_ADDR_MASK | STRTAB_BASE_RA))
+		return -EINVAL;
+
+	strtab_cfg = readl_relaxed(smmu->base + ARM_SMMU_STRTAB_BASE_CFG);
+	if (strtab_cfg & ~(STRTAB_BASE_CFG_FMT | STRTAB_BASE_CFG_SPLIT |
+			   STRTAB_BASE_CFG_LOG2SIZE))
+		return -EINVAL;
+
+	fmt = FIELD_GET(STRTAB_BASE_CFG_FMT, strtab_cfg);
+	split = FIELD_GET(STRTAB_BASE_CFG_SPLIT, strtab_cfg);
+	log2size = FIELD_GET(STRTAB_BASE_CFG_LOG2SIZE, strtab_cfg);
+
+	smmu->strtab_split = split;
+	smmu->strtab_num_entries = 1 << log2size;
+
+	switch (fmt) {
+	case STRTAB_BASE_CFG_FMT_LINEAR:
+		if (split)
+			return -EINVAL;
+		smmu->strtab_num_l1_entries = smmu->strtab_num_entries;
+		strtab_size = smmu->strtab_num_l1_entries *
+			      STRTAB_STE_DWORDS * 8;
+		break;
+	case STRTAB_BASE_CFG_FMT_2LVL:
+		if (split != 6 && split != 8 && split != 10)
+			return -EINVAL;
+		smmu->strtab_num_l1_entries = 1 << max(0, log2size - split);
+		strtab_size = smmu->strtab_num_l1_entries *
+			      STRTAB_L1_DESC_DWORDS * 8;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	strtab_base &= STRTAB_BASE_ADDR_MASK;
+	smmu->strtab_base = smmu_take_pages(strtab_base, strtab_size);
+	if (!smmu->strtab_base)
+		return -EINVAL;
+
+	/* Disable all STEs */
+	memset(smmu->strtab_base, 0, strtab_size);
+	return 0;
+}
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	int ret;
@@ -241,6 +368,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		return ret;
 
+	ret = smmu_init_strtab(smmu);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.39.0

