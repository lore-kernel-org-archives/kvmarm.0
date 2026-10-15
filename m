Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D0C4A0158
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094966; cv=none; b=pqELYqdXLvFjQWoZ6rTcW+F6XZzX3QXAOlqxCKs1/PhM1eRYlfDiX0aj/eyd7t27IvdG0ecACuxd306DdERapq8PRhNszBz/2BnqN0avDXZGx6eaYLZlk9DMTUgqjGdAREZenk5reisyGnjv4q6xu5xnI+MC72Ce44XBW5/n3Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094966; c=relaxed/simple;
	bh=3vT4+pcdhJcVD4Z3oSn11IvY9+bAtQf3X3KAWQIbuE0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nb+Ub0WgZVih79JiksexF2/OrnRm3wN4KH2lT6Jo+QAWUp5ic0DXzjX/9PeZguoqhYB2WBReAjN69xRnbZwnI2CkWh4DOKiNGCub5tHG1Pi3DhmvsUfTZNr/6bYep0ptyzCwmVnTeD9yoQv7HRHPVenXnmXurrkGWRzqHiJDvK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t+n3tSiO; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t+n3tSiO"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a1bfd5516bso11944485e9.3
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094961; x=1792699761; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=laM6+wZiNuYMQDtQzAoP4s+131ogUMmRLEJwdwwKDsc=;
        b=t+n3tSiOUT8TjdTc3priaRr2fPQVKJNJyOLUV7PlpBAWbHggQXXsD0HDO08dB4XAkq
         LnT/cdyjkwyxhmSjJ1gjcFlRI/3knFjVUuSQ/um0pkN2pKWSPrAvu6x1PowhXsEOM6po
         SuO/xf9WiNXEP4vumF8wz7Laa3cpzrVipt3PVnvC+2OtTYlCEuyXmx/z3CAqermHXT1i
         uC9yujo/Qefp6c1tckgfaXX5vvD+y5zkwhv3i1JlOMRW8pprux+QliTyCoqhbuwGnU2V
         lyH9XVNRyl8RSmaKClh4uCKzeIvi4LrK53QOvKftF6l5Q045p2Eh2LFNdm0K2dWMl7Tq
         FeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094961; x=1792699761;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=laM6+wZiNuYMQDtQzAoP4s+131ogUMmRLEJwdwwKDsc=;
        b=o9M3RQ7o07zGw+zcUh0glbpex7k5vM+OsI3vKixJ2cxLv2WoTmMQQTAI4PFrWlsoKw
         mhwMAe1iEoyKhv6PG6hsRt2KtN9IVUxOtPS7+RkUQ3kYs/B8u3v684ke55sRMoFmsNRe
         dvAVkwEaLa2v00dYH2eq5y5eHnXaDm4T1zL5BNQD6YPRQsv1zAnkvzpzzZzxOnXsZT6x
         3Wx/VvxrNWlz0Kr1L1VZhv2DG1zsr2F9VxMFkXenZSaKl0PepqPQSn2lA+Et6h5wbzY3
         vxWtzQPU7DDh5kkcVLlkdoRPNsk2qgY3I4Tub00Mix5KhZpwX7+LlZpE0FCDkV6GIa8m
         kuhQ==
X-Forwarded-Encrypted: i=1; AKwUvBxXPJTsjCxStDj0loHOrH4sKL4HXGmebjBi7dmXJIQQaowtqZBzANJ+A4Dp0Fc2CLHwSSPv/E8=@lists.linux.dev
X-Gm-Message-State: AFq9FYLpk8+VBwVn3xMHqRVlTCDBv6B/K90GOxRBmKadLegT1JxY3iSd
	azzLT2uycADe33EsqdKU0gDQ2b1Yh/wHeaK1xuCO0TR8BWpbvWBlSO0JQKl0UXt2kHa7Q+Y3gf9
	lx9N5i3yAjUqZyQ==
X-Received: from wmbd8.prod.google.com ([2002:a05:600c:58c8:b0:4a1:8444:ff6d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e4a:b0:4a1:ac66:6ac8 with SMTP id 5b1f17b1804b1-4a1c7fa065fmr12093425e9.4.1792094961525;
 Thu, 15 Oct 2026 13:09:21 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:40 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-10-smostafa@google.com>
Subject: [PATCH v9 09/25] KVM: arm64: iommu: Support DABT for IOMMU
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

The pKVM SMMUv3 driver emulates the SMMU registers for the host: the
MMIO is donated to the hypervisor so that host accesses trap, and the
hypervisor performs or rejects each access on the host's behalf.

Add a dabt_handler op and call it from the host data abort path for
aborts with a valid instruction syndrome on non-memory addresses. If
the driver emulates the access, skip the faulting instruction,
otherwise take the normal path, where hyp-owned MMIO is denied.

Only aborts with a valid instruction syndrome can be emulated, so the
host must access emulated registers with single-register loads and
stores (readl/writel and friends).

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/iommu.h |  9 +++++++++
 arch/arm64/kvm/hyp/nvhe/iommu.c         |  6 ++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   | 17 +++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index acd5058ef3ed..bd6604f194b5 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -13,6 +13,13 @@ struct pkvm_iommu_ops {
 	 * with the same @prot, which must succeed.
 	 */
 	int (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
+	/*
+	 * Emulate a host data abort on MMIO @addr
+	 * @esr has a valid instruction syndrome and @regs holds the host x0-x30,
+	 * SRT 31 is the zero register. Return true if the access was emulated,
+	 * which would skip the instruction.
+	 */
+	bool (*dabt_handler)(struct user_pt_regs *regs, u64 esr, u64 addr);
 };
 
 int pkvm_iommu_init(void *pool_base, unsigned int nr_pages);
@@ -25,4 +32,6 @@ void *pkvm_iommu_alloc_pages(u8 order);
 /* Free pages from pkvm_iommu_alloc_pages(). */
 void pkvm_iommu_free_pages(void *ptr);
 
+bool pkvm_iommu_host_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr);
+
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
index 36432bd46c78..cdf6e87bb68e 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
@@ -149,3 +149,9 @@ void pkvm_iommu_free_pages(void *ptr)
 {
 	hyp_put_page(&iommu_pages_pool, ptr);
 }
+
+bool pkvm_iommu_host_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr)
+{
+	return pkvm_iommu_ops && pkvm_iommu_ops->dabt_handler &&
+	       pkvm_iommu_ops->dabt_handler(regs, esr, addr);
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index c14af6a4877c..523bb6bd793b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -13,6 +13,7 @@
 #include <asm/kvm_pkvm.h>
 #include <asm/stage2_pgtable.h>
 
+#include <hyp/adjust_pc.h>
 #include <hyp/fault.h>
 
 #include <nvhe/arm-smccc.h>
@@ -778,6 +779,12 @@ static void host_inject_mem_abort(struct kvm_cpu_context *host_ctxt)
 	inject_host_exception(esr);
 }
 
+static bool is_dabt_with_isv(u64 esr)
+{
+	return (ESR_ELx_EC(esr) == ESR_ELx_EC_DABT_LOW) &&
+		(esr & ESR_ELx_ISV);
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
@@ -800,6 +807,16 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
 	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
 
+	/*
+	 * Let the IOMMU driver emulate accesses to its MMIO.
+	 */
+	if (is_dabt_with_isv(esr) && !addr_is_memory(addr) &&
+	    pkvm_iommu_host_dabt_handler(&host_ctxt->regs, esr,
+					 addr | FAR_TO_FIPA_OFFSET(fault.far_el2))) {
+		kvm_skip_host_instr();
+		return;
+	}
+
 	switch (host_stage2_idmap(addr)) {
 	case -EPERM:
 		host_inject_mem_abort(host_ctxt);
-- 
2.56.0.176.g3575e65682-goog

