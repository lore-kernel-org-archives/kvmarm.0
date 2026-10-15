Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD7058E2CD
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094980; cv=none; b=ImQbWDL4A0KnGA8hypR5/Z6qwZ0tckZNr0KKiC2lj2TcBtb2lUBRhnNtxJ4IOfQKqI5/99wp1zzOe4NXbZtw5rfV1bG3EU6DmigEoy+U1g39ogSCtDE4ly3mXpBs3PLWoIhHrKN0e9U1q/muB3TuS5KmTs8tTyB6ooAl1b7l8ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094980; c=relaxed/simple;
	bh=hu8Ca3NAu0Ymk1meYbnbfYAPWUvoT1ANrBH1t0G+/hU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OAyhCsOI62qwfh3G/WlDNyvu9Ompjmzf74QADIg2tIUTrJvf5lVVBedKOxni6dab6c0HdlobCq+7LTxFrhiPCcvrymUOmxcAx6tgjt4vxYC2GAt1BQDeEMOVRQa8DsZW5R09uOMXTUdAMuEE/7jv8ZcYCUMrZbrxywYv93U9Ync=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iZbB39ul; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iZbB39ul"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a01b112fa2so35379815e9.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094975; x=1792699775; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OrEOEPSGJdrT+r8ut9ZMnt1QbUsQgQecPDrsSjFG450=;
        b=iZbB39ulNrSosZvYkBC2hQfUryDUoBYxkFFfriF2SvG2jyKrXLpjKxJwsAQpTJYBZV
         LYFqt+4Ja1x1qWdD0yuPWAf5kQs5RcLcF4eSTmMn2/0wbkf8RpQzs9M9P4betlDd42Fy
         btU1ag2EEL3DgGKLLj9eRX3ZkYtjcpvy/igG+XeaPkAerE29XGO+6c/t68HaLT6y9AOd
         QRYSfsYUHDmH+lXXDHt9ipbTnKNvrZhLzaq6IEQZwKjF8I9qFpI7YrAtzWrPLkICgWtl
         oY3IA+L1bnt/FNsxqahZbujZJ+MNsiZVknG8Pt21wHQdcOpmJEvGBCnLEEShvzJd2C4b
         v9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094975; x=1792699775;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OrEOEPSGJdrT+r8ut9ZMnt1QbUsQgQecPDrsSjFG450=;
        b=ei6ZdHzN6MRhVL8zS78cQpYlUzxzi6EGlE0kNZ4TZgS4x4m1jeDIOygESKhfYnp8k4
         n92G22QT6a8CTJh1ObWG5ucUIv73lpC9eIjThbqmK5XkcUTuj18SG8e92ihpPVwUTHg6
         yVfJnjy6k0V1C5/noPpvTyyaVSvs7Rqeaxj8ha7n/AIQ7jsczO6v7MrIgKO4MV7WOA0s
         N64E6tfvC5ucLH7JX9KoxV59SqAdZYYo641dEfGj0oTOqzgE1IOAggV+O0h1SLcHh4aD
         GQeSg2TFzE07W2BDgm4Nd2uAY9PnKYP5y4WwPrSAgOIccp0w5816DmPUgL4YEuV+hG02
         xiyg==
X-Forwarded-Encrypted: i=1; AKwUvBzfdgMjr3ItDxgX4e1xODN9NDI90IKnk//yYsfr7RzMUejxR/MMakvcbmy0jMHJowKZwpjI8ac=@lists.linux.dev
X-Gm-Message-State: AFq9FYKxDHsEZ1AMSz9RXK4XoQaa58Zem5zG31H/clov37GteJ1KGXS1
	49KIkQD9RCp20XkmILh7G89nuBHGTnauYJi2Ma2gb14F8QC+23GeSdFDWbld89vqCVLgmiyOhYM
	w0UQwAo5nUte0AA==
X-Received: from wmbf10.prod.google.com ([2002:a05:600c:594a:b0:4a1:b4c7:1ef2])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e07:b0:4a1:8627:aec7 with SMTP id 5b1f17b1804b1-4a18e4987abmr362157685e9.5.1792094974491;
 Thu, 15 Oct 2026 13:09:34 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:50 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-20-smostafa@google.com>
Subject: [PATCH v9 19/25] iommu/arm-smmu-v3-kvm: Share other queues
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

The event and PRI queues are written by the SMMU, not read by the
hypervisor, so they are not shadowed. They still must not be pointed at
protected memory: when the host enables a queue, share and pin its
memory, which fails unless the host owns it and keeps the host from
donating it afterwards.

The queues stay shared once enabled, as the SMMU may keep writing until
CR0ACK reflects the disable, and the base may not change once shared.
The kernel driver programs each base once and never changes it.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c    | 81 +++++++++++++++++--
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h    |  8 ++
 2 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
index 132f3a9ba308..1972df1d2a8d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
@@ -82,6 +82,16 @@ static bool is_smmu_enabled(struct hyp_arm_smmu_v3_device *smmu)
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
  * Host structures the hypervisor reads (CMDQ, STE) are shared and pinned:
  * - Prevent the host from donating this memory.
@@ -663,6 +673,20 @@ static void smmu_emulate_cmdq_disable(struct hyp_arm_smmu_v3_device *smmu)
 				   cmdq_size(&smmu->cmdq_host)));
 }
 
+static void smmu_share_queue(struct hyp_arm_smmu_v3_device *smmu,
+			     unsigned long q_base, size_t ent_size_shift)
+{
+	/* Q_BASE_ADDR_MASK is not enough as the SMMU also ignores bits > OAS */
+	phys_addr_t base = q_base & Q_BASE_ADDR_MASK & ((1ULL << smmu->oas) - 1);
+	size_t size = 1UL << (FIELD_GET(Q_BASE_LOG2SIZE, q_base) + ent_size_shift);
+
+	/* The host must program the base first and it must be aligned to size. */
+	if (WARN_ON(!q_base || (base & (size - 1))))
+		return;
+
+	WARN_ON(smmu_share_pages(base, size));
+}
+
 static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 			     struct user_pt_regs *regs,
 			     u64 esr, u32 off)
@@ -768,6 +792,8 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 		if (is_write) {
 			bool last_cmdq_en = is_cmdq_enabled(smmu);
 			bool last_smmu_en = is_smmu_enabled(smmu);
+			bool last_evtq_en = is_evtq_enabled(smmu);
+			bool last_priq_en = is_priq_enabled(smmu);
 
 			/* Enforce ATS checks. */
 			if (smmu->features & ARM_SMMU_FEAT_ATS)
@@ -777,6 +803,26 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 				smmu_emulate_cmdq_enable(smmu);
 			else if (last_cmdq_en && !is_cmdq_enabled(smmu))
 				smmu_emulate_cmdq_disable(smmu);
+
+			/*
+			 * Share PRI and EVTQ to avoid the host using them to write to
+			 * protected memory. However, do not unshare the queues at disable
+			 * as that is more complicated, unsharing from here can lead to
+			 * use-after-unshare issues, and requires ordering with cr0ack.
+			 * The host can disable those queues during shutdown, but it never
+			 * changes the base address (even with RPM), so leave the queue
+			 * shared and assert that multiple host writes do not change it.
+			 */
+			if (!last_evtq_en && is_evtq_enabled(smmu) && !smmu->evtq_shared) {
+				smmu_share_queue(smmu, smmu->evtq_base, EVTQ_ENT_SZ_SHIFT);
+				smmu->evtq_shared = true;
+			}
+
+			if (!last_priq_en && is_priq_enabled(smmu) && !smmu->priq_shared) {
+				smmu_share_queue(smmu, smmu->priq_base, PRIQ_ENT_SZ_SHIFT);
+				smmu->priq_shared = true;
+			}
+
 			if (!last_smmu_en && is_smmu_enabled(smmu))
 				smmu_emulate_enable(smmu);
 			else if (last_smmu_en && !is_smmu_enabled(smmu))
@@ -806,6 +852,34 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 
 		mask = read_write;
 		break;
+	case ARM_SMMU_EVTQ_BASE:
+		if (len != sizeof(u64))
+			break;
+
+		if (is_write) {
+			/* See ARM_SMMU_CR0 */
+			if (is_evtq_enabled(smmu) ||
+			    (smmu->evtq_shared && smmu->evtq_base != val))
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
+			    (smmu->priq_shared && smmu->priq_base != val))
+				break;
+			smmu->priq_base = val;
+		}
+		mask = read_write;
+		break;
+
 	/* Allowed 32 bit registers. */
 	case ARM_SMMU_EVTQ_IRQ_CFG1:
 	case ARM_SMMU_EVTQ_IRQ_CFG2:
@@ -833,15 +907,12 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
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
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
index 31ab7a0335a8..2fb478e9233a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
@@ -32,6 +32,10 @@
  * @strtab_cfg:		Stream table config as seen by HW
  * @strtab_dma:		Physical address of the shadow stream table
  * @strtab_size:	Size of the shadow stream table
+ * @evtq_base:		Host EVTQ_BASE value
+ * @priq_base:		Host PRIQ_BASE value
+ * @evtq_shared:	Whether the EVTQ was shared
+ * @priq_shared:	Whether the PRIQ was shared
  *
  * @mmio_addr, @mmio_size and ARM_SMMU_FEAT_COHERENCY are filled by the host
  * before de-privilege, the rest by the hypervisor driver.
@@ -61,6 +65,10 @@ struct hyp_arm_smmu_v3_device {
 	u64			host_ste_cfg;
 	u64			host_ste_base;
 	struct arm_smmu_strtab_cfg strtab_cfg;
+	u64			evtq_base;
+	u64			priq_base;
+	bool			evtq_shared;
+	bool			priq_shared;
 };
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-- 
2.56.0.176.g3575e65682-goog

