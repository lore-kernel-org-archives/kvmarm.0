Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CDB47A0DD
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116781; cv=none; b=Y+kA/EOnBxb2MUxBfE6avrcAvwYfVlFPfkqYKZMh/SujbVZItTqtlL2cs4ppw6IzSrqeb+pXR08UvKDidNEdydd/WQRzk2MWABrgQr91z+P2CPiVEEj1UUCSDYt8UUq/oLFcJ9UbVk2grZ23dCNuyv3xgJcut5Y5w4uOjBgwlcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116781; c=relaxed/simple;
	bh=YQYjynOVyJgoO02um8UcNKToZLA1zwRwRv/O62BjZAU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PXMdvHG4OhU6I8cShyNwOzmKGULUN/IsfRb/a2TOVd/H/d0DOY8HRFxNKprssskX2ioRHTmgvtmQqz59mNI9XdGFM7kc2nWLe5PucxFGzBPdnoOBgB9/x+tnQ+SzyMqWNOzYOeZOYmIsdKNOTV+QCif63a0WOfyySUWt2i/i6TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PWltDGKI; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PWltDGKI"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-47f4bff865cso844768f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116777; x=1784721577; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cZv8wMHHgtVyVaoJdrUTfCe907vJcKIQX+U9Fwaj/aI=;
        b=PWltDGKI9W6xDL/b2m4cvUgvCcqlSHs3/u8iqU7klHb19AQVVeZeSiDGo3DGaJ2RfD
         i4Zx2YvzV6ih5rMoYxWPt180gcZc7JZzmbAb/ps9ybGXtuWagEYI7YtlTRxGXZWgxdCy
         The+d9bJmdZ9LvM1Wv9PQ70Uq5/ziaHpGYCb6b4I1hD4PcGVLokxbktKTc4I72ci94a5
         N+NR4iqv8dJ9BsICIrNcb1w7sA4m5XbiWwM1B0g5o6FUQMzXzd4Vkq3PsmCoFGO8ham5
         W/a0R6BVSMxU4SIPtQUQ3FsElI1s2f7Q21CX/Zcs5ouY7OE3aq07tcie9r5vUIBhOaay
         bTLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116777; x=1784721577;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cZv8wMHHgtVyVaoJdrUTfCe907vJcKIQX+U9Fwaj/aI=;
        b=k4H9X00BUJXgZkalpJTpmQGxNypZS6GaxXKO3iPC65wfcmcvIxjGVYRit3An9CBA0d
         2OgxSux+qKEJhMARxYusdRyuLwuQFB5ge7Q6sUXq4cndFj2DYSsWeer4WtjMzP4EfuU/
         adU/4x0+Bee0FBcrdykE8jcxW3cZuPbj579D9VF3GBVbCfDChQ9G14jaiZw70RWDQsBZ
         HjUbvp5ZcuvdsaDD+xr7jeppuL2dke2s9gz/ogrjK2RJ/0kDNsX/fYjAP/s1Okn23iJ9
         KiIguzv+5HpBY80fh13g1UJgnetJf0f329XTe+iKN/L6WAO16Vx9PqT1F2nx89N+cw8e
         2QXg==
X-Forwarded-Encrypted: i=1; AHgh+RqRNdrTsF0NWIK8t/d/rYkISb2p7g7cRzNkTEtK4Q5L0Q1RIlMTN/pGuN7tCb5b7ivJ0juTfoU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBFVnnCLaBQ/EU1iIZr9yP7EoQFo6StMi8waWhc+cGGMDN4XFe
	aNk1eOTnaWHTA0j0+X8DHGSauFlFsWDUuRp8e6C1ak91uyXL52YbvXXTY3kfTb6kwC3cftD0Vv0
	gW3wPU6ZM6B2TYQ==
X-Received: from wmpj23.prod.google.com ([2002:a05:600c:4897:b0:493:f522:9fbe])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:283:b0:490:688b:f9f8 with SMTP id 5b1f17b1804b1-49518306db9mr62910255e9.27.1784116777309;
 Wed, 15 Jul 2026 04:59:37 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:59:00 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-20-smostafa@google.com>
Subject: [PATCH v7 19/24] iommu/arm-smmu-v3-kvm: Share other queues
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

Other queues as PRIQ and EVTQ doesn't need to be shadowed. However, we
need to make sure they are in a state that disallow them to be donated
to the hypervisor or guests. So, keep track of those and share them when
they get enabled.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 78 +++++++++++++++++--
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |  8 ++
 2 files changed, 81 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index fba3b3e15780..11de73640a6f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -74,6 +74,16 @@ static bool is_smmu_enabled(struct hyp_arm_smmu_v3_device *smmu)
 	return FIELD_GET(CR0_SMMUEN, smmu->cr0);
 }
 
+static bool is_evtq_enabled(struct hyp_arm_smmu_v3_device *smmu)
+{
+	return FIELD_GET(CR0_EVTQEN, smmu->cr0);
+}
+
+static bool is_priq_enabled(struct hyp_arm_smmu_v3_device *smmu)
+{
+	return FIELD_GET(CR0_PRIQEN, smmu->cr0);
+}
+
 /*
  * CMDQ, STE host copies are accessed by the hypervisor, we share them to
  * - Prevent the host from passing protected VM memory.
@@ -647,6 +657,18 @@ static void smmu_emulate_cmdq_disable(struct hyp_arm_smmu_v3_device *smmu)
 				   cmdq_size(&smmu->cmdq_host)));
 }
 
+static void smmu_emulate_queue(struct hyp_arm_smmu_v3_device *smmu,
+			       unsigned long q_base, size_t ent_size_shift)
+{
+	/* Q_BASE_ADDR_MASK is not enough as the SMMU also ignores bits > OAS */
+	phys_addr_t base = q_base & Q_BASE_ADDR_MASK & ((1ULL << smmu->oas) - 1);
+	size_t size = 1UL << (FIELD_GET(Q_BASE_LOG2SIZE, q_base) + ent_size_shift);
+
+	/* Queues are aligned to the size also. */
+	base &= ~(size - 1);
+	WARN_ON(smmu_share_pages(base, size));
+}
+
 static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 			     struct user_pt_regs *regs,
 			     u64 esr, u32 off)
@@ -751,12 +773,34 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 		if (is_write) {
 			bool last_cmdq_en = is_cmdq_enabled(smmu);
 			bool last_smmu_en = is_smmu_enabled(smmu);
+			bool last_evtq_en = is_evtq_enabled(smmu);
+			bool last_priq_en = is_priq_enabled(smmu);
 
 			smmu->cr0 = val;
 			if (!last_cmdq_en && is_cmdq_enabled(smmu))
 				smmu_emulate_cmdq_enable(smmu);
 			else if (last_cmdq_en && !is_cmdq_enabled(smmu))
 				smmu_emulate_cmdq_disable(smmu);
+
+			/*
+			 * Share PRI and EVTQ to avoid the host using them to write to
+			 * protected memory. However, do not unshare the queues at disable
+			 * as that is more complicated, unsharing from here can lead to
+			 * use-after-unshare issues, and requires ordering with cr0ack.
+			 * The host can disable those queue during shutdown, but it nevers
+			 * changes the base address (even with RPM), so leave the queue
+			 * shared and assert that multiple host writes does not change it.
+			 */
+			if (!last_evtq_en && is_evtq_enabled(smmu) && !smmu->evtq_shared) {
+				smmu_emulate_queue(smmu, smmu->evtq_base, EVTQ_ENT_SZ_SHIFT);
+				smmu->evtq_shared = true;
+			}
+
+			if (!last_priq_en && is_priq_enabled(smmu) && !smmu->priq_shared) {
+				smmu_emulate_queue(smmu, smmu->priq_base, PRIQ_ENT_SZ_SHIFT);
+				smmu->priq_shared = true;
+			}
+
 			if (!last_smmu_en && is_smmu_enabled(smmu))
 				smmu_emulate_enable(smmu);
 			else if (last_smmu_en && !is_smmu_enabled(smmu))
@@ -780,6 +824,33 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 		mask = read_write;
 		break;
 	}
+	case ARM_SMMU_EVTQ_BASE:
+		if (len != sizeof(u64))
+			break;
+
+		if (is_write) {
+			/* See ARM_SMMU_CR0 */
+			if (is_evtq_enabled(smmu) ||
+			    (smmu->evtq_shared && (smmu->evtq_base != val)))
+				break;
+			smmu->evtq_base = val;
+		}
+		mask = read_write;
+		break;
+
+	case ARM_SMMU_PRIQ_BASE:
+		if (len != sizeof(u64))
+			break;
+
+		if (is_write) {
+			/* See ARM_SMMU_CR0 */
+			if (is_priq_enabled(smmu) ||
+			    (smmu->priq_shared && (smmu->priq_base != val)))
+				break;
+			smmu->priq_base = val;
+		}
+		mask = read_write;
+		break;
 
 	/* Allowed 32 bit registers. */
 	case ARM_SMMU_EVTQ_IRQ_CFG1:
@@ -810,15 +881,12 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 	case ARM_SMMU_EVTQ_IRQ_CFG0:
 	case ARM_SMMU_PRIQ_IRQ_CFG0:
 	case ARM_SMMU_GERROR_IRQ_CFG0:
+		if (len != sizeof(u64))
+			break;
 		/* These are RES0 as MSI support is hidden. */
 		val = 0;
 		if (!is_write)
 			goto out_update_regs;
-		fallthrough;
-	case ARM_SMMU_EVTQ_BASE:
-	case ARM_SMMU_PRIQ_BASE:
-		if (len != sizeof(u64))
-			break;
 		mask = read_write;
 		break;
 	/* Allowed RO 32 bit registers. */
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index 085aead009b6..d96801e433ef 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -32,6 +32,10 @@
  * @host_ste_cfg	Host stream table config
  * @host_ste_base	Host stream table base
  * @strtab_cfg		Stream table as seen by HW
+ * @evtq_base		Host evtq base reg
+ * @priq_base		Host priq base reg
+ * @evtq_shared		Whether the EVTQ was setup
+ * @priq_shared		Whether the PRIQ was setup
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
@@ -56,6 +60,10 @@ struct hyp_arm_smmu_v3_device {
 	u64			host_ste_cfg;
 	u64			host_ste_base;
 	struct arm_smmu_strtab_cfg strtab_cfg;
+	unsigned long		evtq_base;
+	unsigned long		priq_base;
+	bool				evtq_shared;
+	bool				priq_shared;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.55.0.141.g00534a21ce-goog

