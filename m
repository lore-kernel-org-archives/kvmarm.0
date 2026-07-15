Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF11466B7C
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116769; cv=none; b=aphJIRvOMcStSa+kcGMRxAu1UG6kcCUpKVk6YkXt+h+zZbsFkoHPkJBTu2VTMDSYkzwCkSWQ1JXCf0E4UmcJdgLHHhAKeQAIWupyuWBy0eTSbQhLtLxdn4SYEqblpFslTgZI6fD1i09p17sYCSdE5/XGLCr4s1sWd9yyi8o/bB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116769; c=relaxed/simple;
	bh=rlfx3qfyVRl3021fgkWqxMtUcvwBDWvKZgNJzUwlcHU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bF7+aesL44u0AkW3HmfpHdeAAkLixqas5TlmPfyH5KeKVCIWSbL/FbBzZYv62LnBXP8QE78JTiDX3JRFNJezvrP+5vNAY2e8RbjlTySdJEKufXkmleu+K9vOEoI1QlfpJBXmNI5g10TYtJAtSNS9Q+CBGag86PAWvAINcvePIrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sNvtOe0v; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sNvtOe0v"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493b0fe95b6so34589435e9.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116764; x=1784721564; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nojqcuetD+/ikKOr3q9aYEmPsN9V6B5kzgOM/WeBKUw=;
        b=sNvtOe0vt0EB4ZJh1ShIxn/XVyyU754p9UImHJ0LHA8GfOHpG28RArG6RoYNSSIz9l
         24ynyq2pzIGpl/vTZ5+PMt1PUGx075j/KFPFkgOTn33B4g1Q+wF6t8K43DPzMy2Km843
         lh2T58M6ScvCkb4aHN70qDwuC4jtL8hYOoQgH9gjB+EvSNFs4s4yIDKfWQNZM12tHDCv
         YISXb+ztCLior6dpl0lPX0e+k31BTL6toOQyG5iSx44fUA5BlpRD6oegI+rBa2JXf/tM
         8yLE1xOCAFkwCPdRb6MwcMrwosujPyRyitC4CIp3SeraswitZ5tuT6kBuVppCwwq+2Bj
         bpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116764; x=1784721564;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nojqcuetD+/ikKOr3q9aYEmPsN9V6B5kzgOM/WeBKUw=;
        b=oeU/A2SuIZqTWFRsiB/aSIxSOQ6uF6KeFs5+MzA4tkB7c+H33Kpt3+E0IZNLG1CPE0
         Bnqb4bawYWgTQl82ALNCCOVWvqvZKCft2VbaMqfxphKwbTgvUVmSzpJ1qr/WZInDX8iQ
         uww/cf9dCPuo8BUKNtX3QxFG+FzhRBxVIXeTNQLxSQMsrKVSExFFCdcxJVarWka+mVjU
         YpmfW2IM+SD0iYerWAtKYDh/52npTDMGyb32D4M4bE4naF8KAXTk5jSW3cLN/90y5WV5
         17mziWDjrvVTgn1aGbtip1aXxa47gHW9YqxOk+SGcFjIHvN9CPF2QNuykEso520Exxpf
         7zlA==
X-Forwarded-Encrypted: i=1; AHgh+RrEKRvMFIxSzb/vDUJm7302zGsm6fcNlAHJPUwoJCGBbQNuXzCDFKPgF8XxiDI668o8Pd5p4fs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhKU/czKZ2tYLZn93WFLHdzDOcu3eEVG4qNN5LUJvQQHuQxOnX
	aMN9V6wr+dYnw1u6D6MB8rLHxlAgqui4iMNE4pO0gq/PknfynuBrFlpWzU8ebeVzNAIkRFiprWM
	euwEsmp+Wvciybw==
X-Received: from wmbdx5.prod.google.com ([2002:a05:600c:63c5:b0:493:f781:b52f])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5656:b0:493:c77c:108a with SMTP id 5b1f17b1804b1-4953c2897b9mr17716955e9.36.1784116763927;
 Wed, 15 Jul 2026 04:59:23 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:58:50 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-10-smostafa@google.com>
Subject: [PATCH v7 09/24] KVM: arm64: iommu: Support DABT for IOMMU
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

The pKVM SMMUv3 driver needs to trap and emulate access to the MMIO
space of the SMMUv3 to provide emulation for the kernel driver.

Add a handler for DABTs for IOMMU drivers to be able to do so.
In case the host causes a data abort, check if it's part of IOMMU
emulation first.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/iommu.h |  3 ++-
 arch/arm64/kvm/hyp/nvhe/iommu.c         | 15 +++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   | 15 +++++++++++++++
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 028e89a3448d..8b7521135792 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -8,6 +8,7 @@
 struct pkvm_iommu_ops {
 	int (*init)(void);
 	int (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
+	bool (*dabt_handler)(struct user_pt_regs *regs, u64 esr, u64 addr);
 };
 
 int pkvm_iommu_init(void *pool_base, unsigned int nr_pages);
@@ -19,5 +20,5 @@ int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
 void *pkvm_iommu_donate_pages(u8 order);
 /* Free pages from pkvm_iommu_donate_pages(). Must use same size */
 void pkvm_iommu_reclaim_pages(void *ptr);
-
+bool pkvm_iommu_host_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr);
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
index 8891cb7920c4..8ea9c8c23985 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
@@ -4,6 +4,10 @@
  *
  * Copyright (C) 2022 Linaro Ltd.
  */
+#include <asm/kvm_hyp.h>
+
+#include <hyp/adjust_pc.h>
+
 #include <linux/iommu.h>
 #include <asm/kvm_pkvm.h>
 
@@ -157,3 +161,14 @@ void pkvm_iommu_reclaim_pages(void *ptr)
 {
 	hyp_put_page(&iommu_pages_pool, ptr);
 }
+
+bool pkvm_iommu_host_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr)
+{
+	if (pkvm_iommu_ops && pkvm_iommu_ops->dabt_handler &&
+	    pkvm_iommu_ops->dabt_handler(regs, esr, addr)) {
+		/* DABT handled by the driver, skip to next instruction. */
+		kvm_skip_host_instr();
+		return true;
+	}
+	return false;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index ce610274bda0..b798a36e0ddb 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -751,6 +751,12 @@ static void host_inject_mem_abort(struct kvm_cpu_context *host_ctxt)
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
@@ -773,6 +779,15 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
 	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
 
+	/*
+	 * Emulate data aborts for IOMMU drivers, other access will be denied
+	 * by host_stage2_adjust_range()
+	 */
+	if (is_mmio_dabt(esr) && !addr_is_memory(addr) &&
+	    pkvm_iommu_host_dabt_handler(&host_ctxt->regs,
+					 esr, addr | FAR_TO_FIPA_OFFSET(fault.far_el2)))
+		return;
+
 	switch (host_stage2_idmap(addr)) {
 	case -EPERM:
 		host_inject_mem_abort(host_ctxt);
-- 
2.55.0.141.g00534a21ce-goog

