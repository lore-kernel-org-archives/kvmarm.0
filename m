Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCB039E6F5
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634415; cv=none; b=dfFpIQ5g8wktn0+Ff7jE9HDEs3mhOStgVCyb4dPJYHWo9SfMVZ1iSIbbKBwaGQCnGvLckCD3y3CVHziGjyddyQV5ftCjObXsGqgDW7RPHb+KzksUk0HBZamJLq/9bKyk4QuLNgGIAXhIbRkYW4FftF8NyWVLoVdl/qNp0WOoHFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634415; c=relaxed/simple;
	bh=La4+9+sPCS/4eXA8ja7XO9KK/olvOoUWDQbSdswhUu0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HayEdjgE3MynaNuXmCILHUGVLD9sb5JXlSeIyqZOoG5i+h0UnxOvAiJHkhjFG6cFr6HH1SCgQRNT2lWTIU1CFwYDyS0OggEYrjZ01wTmOqbgfD9xF3bGHaYDuB88ALrJwmWzyUcdvcAfDNfcJkWni5eaZ6Hqot/MFzmGp9wCd0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X1L8IXDc; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X1L8IXDc"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488d3eec9bcso11789255e9.3
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634412; x=1778239212; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9kXrhx388xhTRL3MvJdHy6WWnE8EmOsHEooLjon0268=;
        b=X1L8IXDcOyCnHqdvZtEQ5EfLaeRMw7CsfH3pMNZrj7BM97bMDeRggw8Tp/yXm5tGnI
         A8+mtfLQuBZQ9WMpauTdnCMqC5L/wX3XUjN1dwsYXcQWm7lvW79XTcFqnjSl7Vvx38Rw
         QgmcDKRlYC52G1qpgSQU1kYPUHs3pjmInYuYq7vqH5Am7qzIlPJo0zLhunPPICkSRbba
         cIiA20lvV7+0lKZZxpc787AnkbQtiQ+HqpTYwKDcgYrzdSjN/gKj0hbKDEOn9tfxP/Vi
         pRfzv1gzXWtGvQlQZkSN9t6TAK+Bcz6/PlU5rxVjZPLnNzwR9Pccwh6KFS9cFDCntpzB
         0l2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634412; x=1778239212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9kXrhx388xhTRL3MvJdHy6WWnE8EmOsHEooLjon0268=;
        b=dtGnPzbdrDd5gNugmsEFtoDbPGF3Jx+9A626s7e4VaSn8KmmODMROrWAvPWvhll34j
         14mHrWanhd9caPsZcOwhngbzA1Hy0tGf27LcGbr/bbzMTkjug3lbxVq4B0TE3/zhbRht
         cBrGcqE0om6Lm1BEcGXcyOytgtdIwMn29D93Tkgu9mCc/HWfTk0hWyW7kA/si6Ad/w9m
         NNBRNyRikC0/mqnNDBXayd6gn2of9GlQoMliQOY6HIPiG8epTLRaBJAGSDT42NeB3Oo2
         afyPNWPoThZXYY1sH6AqNh31VCcaxJ5M0Rz5IC3sLG9YwXBd2KhnusZzf3aY0VDHQhOQ
         B61Q==
X-Forwarded-Encrypted: i=1; AFNElJ8u6LYKVSDREFv4pxuPIFIoTDw0bXb6VDjVAx/sTd6sktapmWTYB3NE/46u865VlY6MAyqpmhA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQwHPB9OuVVGCTxPSVhN0cnbQS+/aU3fXd47XXvh7YAGLdIVHk
	VCOPPsRCksw4DoQT5nnlpeYFQCZQlnGprOCEiEyAfbaUt6QNc5pcQPeV/BE3s1ZX+8WwnKSKuuU
	8l0+fJ9V38H+UHw==
X-Received: from wmat2.prod.google.com ([2002:a05:600c:6d02:b0:485:33e8:92af])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c108:b0:485:40db:d40c with SMTP id 5b1f17b1804b1-48a8eb61ddfmr29338485e9.3.1777634412089;
 Fri, 01 May 2026 04:20:12 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:12 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-11-smostafa@google.com>
Subject: [PATCH v6 10/25] KVM: arm64: iommu: Support DABT for IOMMU
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

The pKVM SMMUv3 driver needs to trap and emulate access to the MMIO
space of the SMMUv3 to provide emulation for the kernel driver.

Add a handler for DABTs for IOMMU drivers to be able to do so.
In case the host causes a data abort, check if it's part of IOMMU
emulation first.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/iommu.h |  3 ++-
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 15 +++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   | 15 +++++++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index eba94b4f6050..e1b6f16391cc 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -8,6 +8,7 @@
 struct kvm_iommu_ops {
 	int (*init)(void);
 	int (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
+	bool (*dabt_handler)(struct user_pt_regs *regs, u64 esr, u64 addr);
 };
 
 int kvm_iommu_init(void *pool_base, unsigned int nr_pages);
@@ -18,5 +19,5 @@ int kvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
 /* Returns zeroed memory. */
 void *kvm_iommu_donate_pages(u8 order);
 void kvm_iommu_reclaim_pages(void *ptr);
-
+bool kvm_iommu_host_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr);
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index 53cb5e4b0aac..b1474db016e5 100644
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
@@ -139,3 +143,14 @@ void kvm_iommu_reclaim_pages(void *ptr)
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
index b54cb72ed88c..5c64007dba4d 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -788,6 +788,12 @@ static void host_inject_mem_abort(struct kvm_cpu_context *host_ctxt)
 	inject_host_exception(esr);
 }
 
+static bool is_mmio_dabt(u64 esr)
+{
+	return (ESR_ELx_EC(esr) == ESR_ELx_EC_DABT_LOW) &&
+		(esr & ESR_ELx_ISV);
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
@@ -810,6 +816,15 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
 	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
 
+	/*
+	 * Emulate data aborts for IOMMU drivers, other access will be denied
+	 * by host_stage2_adjust_range()
+	 */
+	if (is_mmio_dabt(esr) && !addr_is_memory(addr) &&
+	    kvm_iommu_host_dabt_handler(&host_ctxt->regs,
+					esr, addr | FAR_TO_FIPA_OFFSET(fault.far_el2)))
+		return;
+
 	switch (host_stage2_idmap(addr)) {
 	case -EPERM:
 		host_inject_mem_abort(host_ctxt);
-- 
2.54.0.545.g6539524ca2-goog

