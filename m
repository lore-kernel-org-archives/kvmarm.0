Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6360823A1A1
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026758; cv=none; b=qvcjW6sOBEn3LEzsCIMexgem4q5iaejekGCo3LDFJEq7qVUbuEpCdwTuHFYs9llsEsp44QZ0lwvpdvG/2JG9Cp6nWMx5YXkjmoFdNELjuvEw3S/qcQSnZgcaab4kcWE0GWxNbzuB54KhL2sLfaEjg2st5y9UZuvAJy4K9Kiar04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026758; c=relaxed/simple;
	bh=xoLHfhtpFrxTH540A3d41QMdNpP9ylrvZba0P+No9Hs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=saW3E7luYQ/uGEUo3Ws6r9WRK+y4PT0rxOvNg0bPmX4HC3azyVyOVOmKDT2ipbvIhsThvuK+2Tgeo3MInpLF9eq4SgtYVqsIBk69LS02BjWXnxJ9CAzz8JUO0y5DoARbX05yzBlFpyHOlkUTr4BvYdwhZQhuxx68DqAxtsG7da0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CflE8zKf; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CflE8zKf"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4361ac607b6so7285185e9.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026755; x=1734631555; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/jsol/FD7xLO/XnO3v0kMgo+OuMQmHauwbh0Fn9n2Qc=;
        b=CflE8zKfgYH7rqZ5CMLggGfZ1CfnrPRnvMP6Ny5GhbJA64pNhTWG6zsLskFRZdN7LH
         f2/um8EMjYr4iBGRq9Bhc1tAJrnYFhlDeVgWgLMSue1378BHucPcVJb9U8iSw8dLJD0f
         4h0AzO2/bZtdva4dK0DVv8D3K7iBVByq0jMXjVOJrvn5G9ceYcwqFHMQWotwfn32xWyy
         T2ypJb0pTw7pRMVK1q6gLuFhWWiXtvOkOszRlYaHS/xGTDfjLbzd1O/BT3FhgLATKknG
         W3UuS8XeS/5gvWpt/HxAn2EOAUuBXl7EI7bfziE4OYGYj4rvr8H+J7dPOE8aVcwavybB
         37UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026755; x=1734631555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/jsol/FD7xLO/XnO3v0kMgo+OuMQmHauwbh0Fn9n2Qc=;
        b=g8XL1fBvGdzVoHh1qS/EQn7vcZPZCkQMX3vAIv9VeDTaggL6NlLPYFOteX+ynVFSLW
         N+iKiLgmsbh8CmR+Ko42N8A/VZE9D352T/W+PS7WiyQVfjA6JaTykON0ivbB/xxFMAOy
         V22fdgT+43CSMIDtIRI7NoEYvGbdCn9DHinMocSs7iTpGuYS78O8Ma8LW1uSW9zJmlJ3
         qsAnZ+uXumGwG9WZbXtEsL7yC3ej23RYOF73oitaSaDkvr3v3US1ka5Gcq/OJzBNooZ4
         MTDO9zQNgPkTHNF7+UwuHt9XQShTChBcYqrNp6cJUeA7xpefgJ6Y+WYBVfd95BQXgIZJ
         5SNA==
X-Forwarded-Encrypted: i=1; AJvYcCUEq5HRTD1/7KrIYgUvlMsXBbfHW640GWTKGgPVUCZJLgbx+IVhgifTtq/cgYfLK/txQSBCs5g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPfiTEvluTu/bW5UizlybHi7FszZzzpOHGtuMPiKWKC0ESiK+b
	Wgox98Y0oU+2Tl38Vcf8ounJyjehHUgMkDarudquhrxEtXBM44ZcF9rGU+qd6KiMFwNXjylrYya
	kxapbRx2F1A==
X-Google-Smtp-Source: AGHT+IFPvic4v0yXTXsiiS55qmyvRxNfbGXACyTICF0QYMQMm//s6fh52UUXvcsaAQ5ADTdRambhNe92sr/RSw==
X-Received: from wmol7.prod.google.com ([2002:a05:600c:47c7:b0:434:a471:130f])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:35cb:b0:434:f9ad:7238 with SMTP id 5b1f17b1804b1-4362286391fmr34351085e9.22.1734026754968;
 Thu, 12 Dec 2024 10:05:54 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:58 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-35-smostafa@google.com>
Subject: [RFC PATCH v2 34/58] KVM: arm64: smmu-v3: Add context descriptor functions
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

Add functions to allocate and access context descriptors that would
be used in stage-1 attach.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 53 +++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index 5f00d5cdf5bc..d58424e45e1d 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -215,6 +215,19 @@ static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
 	return smmu_send_cmd(smmu, &cmd);
 }
 
+__maybe_unused
+static int smmu_sync_cd(struct hyp_arm_smmu_v3_device *smmu, u32 sid, u32 ssid)
+{
+	struct arm_smmu_cmdq_ent cmd = {
+		.opcode = CMDQ_OP_CFGI_CD,
+		.cfgi.sid	= sid,
+		.cfgi.ssid	= ssid,
+		.cfgi.leaf = true,
+	};
+
+	return smmu_send_cmd(smmu, &cmd);
+}
+
 static int smmu_alloc_l2_strtab(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
 {
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
@@ -291,6 +304,46 @@ smmu_get_alloc_ste_ptr(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
 	return smmu_get_ste_ptr(smmu, sid);
 }
 
+__maybe_unused
+static u64 *smmu_get_cd_ptr(u64 *cdtab, u32 ssid)
+{
+	/* Only linear supported for now. */
+	return cdtab + ssid * CTXDESC_CD_DWORDS;
+}
+
+__maybe_unused
+static u64 *smmu_alloc_cd(struct hyp_arm_smmu_v3_device *smmu, u32 pasid_bits)
+{
+	u64 *cd_table;
+	int flags = 0;
+	u32 requested_order = get_order((1 << pasid_bits) *
+					(CTXDESC_CD_DWORDS << 3));
+
+	/*
+	 * We support max of 64K linear tables only, this should be enough
+	 * for 128 pasids
+	 */
+	if (WARN_ON(requested_order > 4))
+		return NULL;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		flags |= IOMMU_PAGE_NOCACHE;
+
+	cd_table = kvm_iommu_donate_pages(requested_order, flags);
+	if (!cd_table)
+		return NULL;
+	return (u64 *)hyp_virt_to_phys(cd_table);
+}
+
+__maybe_unused
+static void smmu_free_cd(u64 *cd_table, u32 pasid_bits)
+{
+	u32 order = get_order((1 << pasid_bits) *
+			      (CTXDESC_CD_DWORDS << 3));
+
+	kvm_iommu_reclaim_pages(cd_table, order);
+}
+
 static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
 {
 	u64 val, old;
-- 
2.47.0.338.g60cca15819-goog

