Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFC523EA6B
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026773; cv=none; b=Tw3Dcv6HkPiKN9uag92ijvSQ29shc+EvmpKmusqg5/vy4eo7GW3wrl3kG7wj8gpWqGQH9Hyn+K8HluuOY+6QuEdbXCFC3XulXvkhBmtXAccnT96nIdVLN3URpyZvwbWRmzyIpNyT117fwBeKvU6rSGLkJz7RDApJKtOQgixXryM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026773; c=relaxed/simple;
	bh=83jtEu1bEidihroGtU2ASbvYlrug3jgXmpI7mOWQ/pY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PTXXeIFZh4rL69zPyRx6NCNUNu/u9N6i6cYtsppuZN1SmgGotO5YdvKYpp64IpPxMjAZ0moo9JOUcDqTxmqfpbmL3rDv0G6z4tq8akDYj8NGPfxbQqUcTC0GDu1F1x8/ivpngVZ27ajr+JL46Zi7eBsY+7v4XviuSE56fb7ekHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CBxE9nyx; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CBxE9nyx"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-434fb9646efso8353405e9.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026769; x=1734631569; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EpD1lhD14fjHF53MLiJhdNjSda5T/6inc9eTWlsnoLw=;
        b=CBxE9nyx8d7lluNAbIhmjmKcpfG27assjzBA1TB1EF+B2ZjAo9oW/sqONx/d+5kCSI
         6OmvSMvHnmLfPOghwSNKrCMRv9a1YzE2ZWJAMp1hPEwYM5kqODMFkGxT49cqydCLIMld
         bTxvzoJjYJtItdm0q1pXgsyzeHkgXAv96bipMwIPwr/9Nv6UYO8fC59q41lhC0pXVcMU
         mVyMKXtAnmgHHxHtoUHWQEH43+09geHkNTKHi7Plk1iGsUVtuEUVasFX1NUiHfiAXi1E
         ePSaYbypnucpgsXtrkIb2nHYcPGUuFXFhfCpGTeh5diMNB8cY9m9HKBSzfFldjn0/+yb
         0G+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026769; x=1734631569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EpD1lhD14fjHF53MLiJhdNjSda5T/6inc9eTWlsnoLw=;
        b=JXsW/PRa0mfPcbgr8Da1cnBQWWiiKeHGN3S0hIWocSvpD3OT2Loz4j5PtibwrvAYJr
         F3l2IRiMYkiX/s8f/tscVO3yZC+6VKJEitX/e2FoLmY14p4lHoUpAwvR3B3dw6r//f5N
         4r79yGP3OJYjoSvDWgn7Ii7y+4KASSWPjXDERY0m0GZ97DXOxjl0O/ubQrTf38f5IBzL
         sQtpzy3wnR3vUTC6gsK6Okk62SO5kFWWCQRRfFBu0033ADZnE3dG/nmzRD/WmM6Kg1jQ
         atZHSgC4CJexjdkqCOggikeLTaKw0tMGbHYuIyoZX9MdxjoUufyJ/HTl7H/TBfATX2Gj
         U/zg==
X-Forwarded-Encrypted: i=1; AJvYcCVBc/9thHYO4UF5PLSOjl8UstSFQhULe7dqqvuwvVvPvPMiDyHzBMKes/4yemtS33PS3M5yOeQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yybf/hZ5LoeJiFYRBQ+rh/8jBbuoRmCZ5B7ol3i6WD1YluXD1HD
	0NZvTsD+fBWxyZ67ReFXHv9jvTQpUL8QT8GW4TzWeCdmkhzApeiXqRzA0vb6kHDimdgU9P/HQBm
	PA6U8m5hKVQ==
X-Google-Smtp-Source: AGHT+IHoAtLMCXcx0pNbqpLg+273hrX6BxpTnA/fbV1HglY7lURxrvsoWLSyAcKravbhVxC4p30yvMPx2T2q2A==
X-Received: from wmbay15.prod.google.com ([2002:a05:600c:1e0f:b0:434:ff52:1c7])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5127:b0:434:fddf:5c0a with SMTP id 5b1f17b1804b1-4361c344c70mr73849075e9.3.1734026769635;
 Thu, 12 Dec 2024 10:06:09 -0800 (PST)
Date: Thu, 12 Dec 2024 18:04:05 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-42-smostafa@google.com>
Subject: [RFC PATCH v2 41/58] KVM: arm64: smmu-v3: Add DABT handler
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

Add a data abort handler for the SMMUv3, we allow access for
ETVQ and GERROR for debug purpose.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 58 +++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index 1821a3420a4d..2a99873d980f 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -13,6 +13,7 @@
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/pkvm.h>
+#include <nvhe/trap_handler.h>
 
 #define ARM_SMMU_POLL_TIMEOUT_US	100000 /* 100ms arbitrary timeout */
 
@@ -1269,6 +1270,62 @@ static phys_addr_t smmu_iova_to_phys(struct kvm_hyp_iommu_domain *domain,
 	return paddr;
 }
 
+static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
+			     struct kvm_cpu_context *host_ctxt,
+			     u64 esr, u32 off)
+{
+	bool is_write = esr & ESR_ELx_WNR;
+	unsigned int len = BIT((esr & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
+	int rd = (esr & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
+	const u32 no_access  = 0;
+	const u32 read_write = (u32)(-1);
+	const u32 read_only = is_write ? no_access : read_write;
+	u32 mask = no_access;
+
+	/*
+	 * Only handle MMIO access with u32 size and alignment.
+	 * We don't need to change 64-bit registers for now.
+	 */
+	if ((len != sizeof(u32)) || (off & (sizeof(u32) - 1)))
+		return false;
+
+	switch (off) {
+	case ARM_SMMU_EVTQ_PROD + SZ_64K:
+		mask = read_write;
+		break;
+	case ARM_SMMU_EVTQ_CONS + SZ_64K:
+		mask = read_write;
+		break;
+	case ARM_SMMU_GERROR:
+		mask = read_only;
+		break;
+	case ARM_SMMU_GERRORN:
+		mask = read_write;
+		break;
+	};
+
+	if (!mask)
+		return false;
+	if (is_write)
+		writel_relaxed(cpu_reg(host_ctxt, rd) & mask, smmu->base + off);
+	else
+		cpu_reg(host_ctxt, rd) = readl_relaxed(smmu->base + off);
+
+	return true;
+}
+
+static bool smmu_dabt_handler(struct kvm_cpu_context *host_ctxt, u64 esr, u64 addr)
+{
+	struct hyp_arm_smmu_v3_device *smmu;
+
+	for_each_smmu(smmu) {
+		if (addr < smmu->mmio_addr || addr >= smmu->mmio_addr + smmu->mmio_size)
+			continue;
+		return smmu_dabt_device(smmu, host_ctxt, esr, addr - smmu->mmio_addr);
+	}
+	return false;
+}
+
 /* Shared with the kernel driver in EL1 */
 struct kvm_iommu_ops smmu_ops = {
 	.init				= smmu_init,
@@ -1281,4 +1338,5 @@ struct kvm_iommu_ops smmu_ops = {
 	.map_pages			= smmu_map_pages,
 	.unmap_pages			= smmu_unmap_pages,
 	.iova_to_phys			= smmu_iova_to_phys,
+	.dabt_handler			= smmu_dabt_handler,
 };
-- 
2.47.0.338.g60cca15819-goog

