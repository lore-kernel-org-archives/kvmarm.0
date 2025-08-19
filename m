Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172D93570D5
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640359; cv=none; b=J0Ubop27iU0V/rP4ugztpqDDTuxQu39DFh1zNm14tQQ3j+yEfjqRluauo/bqGjPoViLKftR7lf9cBHg57xqCKWRnvmHtRFaoOCfBJIFmT+45cvzPXvhlvayITuFt4G1Uw8Un38dIIIiRsPxEdJi+5VClGAzmPLFyTKZ8WNW0MN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640359; c=relaxed/simple;
	bh=ZStA5L9CRyv7ZGIOd1ez63lJfoDR2LVWfDOZLq7FmHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nNggXswJ9WXPN8pqiiLbNPDT36OnI1LPZjy/sVVVSQispAqb4G+fd/23u4nfiUg0MHMheNYnlyPQIc1zUqPpQk0xRuUo92gOCNHSgqnhYWga/o0pwNp7Nh3+fooDlvuM3EYyyo8wn13DhdvHPakuR48CMZ4gx6+q7W5h4Ou59f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S8MRGSlF; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S8MRGSlF"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b9e4157303so4677814f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640355; x=1756245155; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gBsLyy3u3rOhplnfl3DMV6GQeOwFjCQ0fFDaMLqFvas=;
        b=S8MRGSlFmgag1PAFPEW8wQlCpde8CfYyp1HaiIOZ9Lmr1eP9H2X+VHhEeoEuyT0r6F
         aSWoJk7VljO+toXogJqEODnClROIUQr7T/IcTFqChx9JrIsly1UYAxCZP2p2o9uHEHIw
         0fwF4J4WUHk0VvFp+0tFc2nTIdiMAiuIX9tyleIqd+gWvS3eQsloedybU97CEKXAzahh
         Hcl4sAY6aLrtF2yotfVv7XmO3D/awRe6HcEObDp/epTtbZWPT/cU53v7uUOnwohXRH90
         Qw13Z8iTj8sqA5XnJD8eh1VE7Czqa9b1oiMGFY4mQ9/T48riPO+yHt2zy0rUscavxlDD
         9ZJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640355; x=1756245155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gBsLyy3u3rOhplnfl3DMV6GQeOwFjCQ0fFDaMLqFvas=;
        b=oIZd2berxovSET2OiZN+HCP5pEdw0/r9UdovE1wZ7E6AF6B9BojftYkuTUIVKdjq8h
         I2MT8XZ5mmNdh1pU+m0Fqsozncszz822j1nq+Qgp5Lo3vnITJeix6d7BvrIWfXv+kw3J
         pirt19+1HJu5Wu/XogWo77NAZvZhVdXl+pHbsXC0FJeHQUAx3I/NHJrWcpegfg1f6mIT
         TC2GNREA24yUNtr2B4XXh+qEr/nHx60jA6ZaOc30OuEcpqYYIe5hm+dr2tq2jk0PUnhf
         iNZW9lNHVV3xVRCRCmlOyisZ8gCpCTWtbti/IX+BUfasoPKbMX9C6KFad2Yd+bxdlH54
         +NPg==
X-Forwarded-Encrypted: i=1; AJvYcCUJ2durKTgVix1vm6weMXsUHYxasAWxKoMY3BHzLfd8NgTsSZLND9lLCY/8GlDD2Pj6InzByI8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhkdnusP8fKKCQ0aTkgmfe+7Qj24BWxoqiocEv+6Un1WQh3l4m
	geyk7Tr/HYzr/lVkuw7YwkDQ97lUF9Ivf2cwDjMkP8Fvby2pZ2lcXu6/cODfeRmhp8IkXg93Xcd
	zf2COu1gvZX0V+A==
X-Google-Smtp-Source: AGHT+IGi+MrTYS9vOAkhE2MwbT5in2zuzEYUdbygOz38UpjYqK2AvcuVjizybf9/jK1Tu7dGcGgyI44X4YgECw==
X-Received: from wmsr19.prod.google.com ([2002:a05:600c:8b13:b0:459:8c48:6c34])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:22c4:b0:3a4:eb92:39b6 with SMTP id ffacd0b85a97d-3c32eeb8077mr359066f8f.54.1755640355498;
 Tue, 19 Aug 2025 14:52:35 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:40 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-13-smostafa@google.com>
Subject: [PATCH v4 12/28] KVM: arm64: iommu: Support DABT for IOMMU
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

SMMUv3 driver need to trap and emulate access to the MMIO space as
part of the nested implementation.

Add a handler for DABTs for IOMMU drivers to be able to do so, in
case the host fault in page, check if it's part of IOMMU emulation
first.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/kvm_arm.h        |  2 ++
 arch/arm64/kvm/hyp/include/nvhe/iommu.h |  3 ++-
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 15 +++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   | 10 ++++++++++
 4 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1da290aeedce..8d63308ccd5c 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -331,6 +331,8 @@
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
+
+#define FAR_MASK GENMASK_ULL(11, 0)
 /*
  * We have
  *	PAR	[PA_Shift - 1	: 12] = PA	[PA_Shift - 1 : 12]
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 9f4906c6dcc9..10fe4fbf7424 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -8,6 +8,7 @@
 struct kvm_iommu_ops {
 	int (*init)(void);
 	void (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
+	bool (*dabt_handler)(struct user_pt_regs *regs, u64 esr, u64 addr);
 };
 
 int kvm_iommu_init(void *pool_base, size_t nr_pages);
@@ -16,5 +17,5 @@ void kvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
 				 enum kvm_pgtable_prot prot);
 void *kvm_iommu_donate_pages(u8 order);
 void kvm_iommu_reclaim_pages(void *ptr);
-
+bool kvm_iommu_host_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr);
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index 1673165c7330..376b30f557a2 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -4,6 +4,10 @@
  *
  * Copyright (C) 2022 Linaro Ltd.
  */
+#include <asm/kvm_hyp.h>
+
+#include <hyp/adjust_pc.h>
+
 #include <linux/iommu.h>
 
 #include <nvhe/iommu.h>
@@ -113,3 +117,14 @@ void kvm_iommu_reclaim_pages(void *ptr)
 {
 	hyp_put_page(&iommu_pages_pool, ptr);
 }
+
+bool kvm_iommu_host_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr)
+{
+	if (kvm_iommu_ops && kvm_iommu_ops->dabt_handler &&
+	    kvm_iommu_ops->dabt_handler(regs, esr, addr)) {
+		/* DABT handled by the driver, skip to next instruction. */
+		kvm_skip_host_instr();
+		return true;
+	}
+	return false;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index bce6690f29c0..7371b2183e1e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -595,6 +595,11 @@ static int host_stage2_idmap(u64 addr)
 	return ret;
 }
 
+static bool is_dabt(u64 esr)
+{
+	return ESR_ELx_EC(esr) == ESR_ELx_EC_DABT_LOW;
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
@@ -617,6 +622,11 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	 */
 	BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
 	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
+	addr |= fault.far_el2 & FAR_MASK;
+
+	if (is_dabt(esr) && !addr_is_memory(addr) &&
+	    kvm_iommu_host_dabt_handler(&host_ctxt->regs, esr, addr))
+		return;
 
 	ret = host_stage2_idmap(addr);
 	BUG_ON(ret && ret != -EAGAIN);
-- 
2.51.0.rc1.167.g924127e9c0-goog

