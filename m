Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28523A4F50
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634431; cv=none; b=GPeY/tfIOJOtya1rUF26XgkKOggpnUck+2Hqpg3o5jfH2F3u0iYYtWu+JkHGTtn6x5N5DWidjAIrxaxHqNIo9t1Uuv9TSx7HTjoFWCK1LBEVOV4dhXwSr/3qR+dElSYAhL7wSuBwmiOEZhTDgVvFRpEmTLjMVVoanm6rh9lKUBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634431; c=relaxed/simple;
	bh=0JvbB+uG8UeC6ETWOsWx833yVnlDygSPCyX5gmo8vcA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GpBY7xf6+ntDykzWXJwsirJAGrJo/8aGACclPNRwp8COEAJRimhGDU+6022TMwMp6Qav8kCnyBdTMAnY+RsQgxWto6CE9KSMGL5IoIYjNl5WyRoHK4Y8zGeKY/cg+GtyiOP0JP69/+FByYhrNsmGAFXmAUaa5T0daSErEmhtVUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MiCCwcXq; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MiCCwcXq"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48a55d82e0eso17167835e9.1
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634428; x=1778239228; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LHCyI4M39cq38I/WoB1TwD8PIWXzXb414TVCe9luOcI=;
        b=MiCCwcXqJx4MjVwubxPecydUBhYi/FbSkDtuUUKVPXrlRCoevKPo8gN21xwDphWDfo
         eMGUDzAChKypwaZ/9JVoUP6hSBjORKlEcWSgwk3mw3OTI3r+tBJrGX5F1INVCP4ItWuu
         AxezHP05QWBEm66fJj1DhjX7BNT7LP3MrpuzT123KlGB9Sn9LOQoH5jYgd13uimI6NJz
         UGbjJiezsO8ddjrY88LQiczspReYOc3jmE5MlGMiOJQHtC3zU+3hhgodpjB3LBttBizx
         ORwSEXFSAJ8c1CfL0vsc+uaXeTSO7Z4jSoe6yyxnapCIuKz5KExk5HqpWizSF1BKNmO2
         VVJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634428; x=1778239228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LHCyI4M39cq38I/WoB1TwD8PIWXzXb414TVCe9luOcI=;
        b=fn5KAAgYVzlZgw0kLn0Ybj6cJbXrCuggZKgxbjVpOLaMfH3yEpeZ69Mnl934wiL7nN
         X2keT/qpa5HxMBqoLNa21OMWWqSRdSeFHby/93xMzuB+pqNQnXs3Z3vpQX7fme0tp0ih
         OdFstAl2M/ZLn5cBxBajn62D13RJZaqI2gjUdD21IIfXDXIHam4h85kysRN+zvPZokXE
         kGzfBLgC+YMSaWQZLsx/vPtjA4yzFjBC+0kOTkb0bSegwy7eC78qKjSUh7KE73l2qm4A
         r9Y8eSwItYB4t6P5ugY3kqphNjZf3h7DGS2kWgYUj2LZ2YHzx2exxwtVsBC7PzE5ugC3
         Kw2A==
X-Forwarded-Encrypted: i=1; AFNElJ/saf43Ed62+A842c6dHCZHSFfOgKqzVRZLPE7zqqSKwbZjUIXPscXNVoWvre1XxQ26dMnA7C8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjyFpSY1iOQKLtXZsylILJVl2Ck3/JF38qb2Z6njzOaBLcCZYj
	G82Lwj0iolisEhtcq9/LXbZKUruTUMculmSAjCBgJE5sRCVjE2wGlLoYmpTPlWlqYLv7mBqg/0p
	TjKQqsGqeBqKCUA==
X-Received: from wmxa17-n2.prod.google.com ([2002:a05:600d:6451:20b0:48a:5d27:4655])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e55:b0:48a:554d:b9a2 with SMTP id 5b1f17b1804b1-48a8eb616a7mr42752255e9.6.1777634427898;
 Fri, 01 May 2026 04:20:27 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:22 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-21-smostafa@google.com>
Subject: [PATCH v6 20/25] iommu/arm-smmu-v3-kvm: Share other queues
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	mark.rutland@arm.com, qperret@google.com, tabba@google.com, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Other queues as PRIQ and EVTQ doesn't need to be shadowed. However, we
need to make sure they are in a state that disallow them to be donated
to the hypervisor or guests. So, keep track of those and share them when
they get enabled.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 62 ++++++++++++++++++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |  4 ++
 2 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index d92811ef2af5..e258690384f4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -69,6 +69,16 @@ static bool is_smmu_enabled(struct hyp_arm_smmu_v3_device *smmu)
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
@@ -647,6 +657,14 @@ static void smmu_emulate_cmdq_disable(struct hyp_arm_smmu_v3_device *smmu)
 				   cmdq_size(&smmu->cmdq_host)));
 }
 
+static void smmu_emulate_queue(unsigned long q_base, size_t ent_size_shift)
+{
+	phys_addr_t base = q_base & Q_BASE_ADDR_MASK;
+	size_t size = 1UL << (FIELD_GET(Q_BASE_LOG2SIZE, q_base) + ent_size_shift);
+
+	WARN_ON(smmu_share_pages(base ,size));
+}
+
 static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 			     struct user_pt_regs *regs,
 			     u64 esr, u32 off)
@@ -748,12 +766,31 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
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
+			 * protected memory. However, panic on disable for those queues
+			 * as that is more complicated, unsharing from here can lead to
+			 * use-after-unshare issues, and requires ordering with cr0ack.
+			 * As the host never disable those queues, don't support that.
+			 */
+			if (!last_evtq_en && is_evtq_enabled(smmu))
+				smmu_emulate_queue(smmu->evtq_base, EVTQ_ENT_SZ_SHIFT);
+			else if (last_evtq_en && !is_evtq_enabled(smmu))
+				WARN_ON(1);
+			if (!last_priq_en && is_priq_enabled(smmu))
+				smmu_emulate_queue(smmu->priq_base, PRIQ_ENT_SZ_SHIFT);
+			else if (last_priq_en && !is_priq_enabled(smmu))
+				WARN_ON(1);
+
 			if (!last_smmu_en && is_smmu_enabled(smmu))
 				smmu_emulate_enable(smmu);
 			else if (last_smmu_en && !is_smmu_enabled(smmu))
@@ -779,6 +816,29 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 		mask = read_write;
 		break;
 	}
+	case ARM_SMMU_EVTQ_BASE:
+		if (len != sizeof(u64))
+			break;
+
+		if (is_write) {
+			if (is_evtq_enabled(smmu))
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
+			if (is_priq_enabled(smmu))
+				break;
+			smmu->priq_base = val;
+		}
+		mask = read_write;
+		break;
 
 	/* Allowed 32 bit registers. */
 	case ARM_SMMU_EVTQ_PROD + SZ_64K:
@@ -801,9 +861,7 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 		mask = read_write;
 		break;
 	/* Allowed 64 bit registers. */
-	case ARM_SMMU_EVTQ_BASE:
 	case ARM_SMMU_EVTQ_IRQ_CFG0:
-	case ARM_SMMU_PRIQ_BASE:
 	case ARM_SMMU_PRIQ_IRQ_CFG0:
 	case ARM_SMMU_GERROR_IRQ_CFG0:
 		if (len != sizeof(u64))
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index 6a73cf6b8873..e811d51bdfaa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -30,6 +30,8 @@
  * @host_ste_cfg	Host stream table config
  * @host_ste_base	Host stream table base
  * @strtab_cfg		Stream table as seen by HW
+ * @evtq_base		Host evtq base reg
+ * @priq_base		Host priq base reg
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
@@ -52,6 +54,8 @@ struct hyp_arm_smmu_v3_device {
 	u64			host_ste_cfg;
 	u64			host_ste_base;
 	struct arm_smmu_strtab_cfg strtab_cfg;
+	unsigned long		evtq_base;
+	unsigned long		priq_base;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.54.0.545.g6539524ca2-goog

