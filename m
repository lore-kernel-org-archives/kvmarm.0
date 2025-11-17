Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C92328601
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405321; cv=none; b=kg9x7PdNr33GrqV/+ZyLxVvv3Y6PvJbUraEEHuu1EoY6fRju9D10mz3nDzpbgti2x2L+6sQB2Du9cGcJkdPKNzAXIub26ZRQBsrUpjEzSz6buDoHPCTOJ78yYuw712PKFOBlB+pEKkpRmyYqEGOm5jNYviNntCHmF2Jv6XykqdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405321; c=relaxed/simple;
	bh=6nFSpBu3ZwObAoKoHCayRp3PVnE6EITEZuEZzaiIGGQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HzhDNZdPLCjs0McIThIzdpNaMbwBlDiZcPWZQtWysA4D94YQCKKqN3Uoc0rxd0AhjL45+COg303eullyIdI1XPC8rdr6SdBlsH2Y8wbcM024vUnpgsgWgqAhzpDPwndr7Re3Zxrt0VCuXx1Kgl3+7UAdftUh73G2FYuv+VM5+qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ecX0ft1A; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ecX0ft1A"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47788165c97so2428395e9.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405317; x=1764010117; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UGnO/Bwz/Bdpjz8RxXVYUEJKHIK5XJgWwQocmBNRacI=;
        b=ecX0ft1An7K6vTi+QRv6WAWzzwpf1gtptlqf8YLOM4lYvWfdF81FVnvQqyLxWM11R9
         sBPnwvvYX8EazGAwjx3k0z0DjNJM6aRMetIRV3vKD6ZgWkwPSMSDgQ62I0Bt1T63y8Ly
         zGJ1ZG7uZBgqK0DpC7Kj/IE2IUoJHEkekz0ooHX6Rul7eIlI/by/qDufGjME4EnBzPeY
         l7uy9JJEeRX5d6ASYQfuyxENj/DpzORJMVu14zgxQFGa75bvJkdGyK5OUWo66B+imWj2
         UbyXLOXu1fbseiBb9zuegzQ1dmCBi2Tuvdp87rzjDvRgeCnY5HcIwepRY/PR6t/mBWFA
         ekAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405317; x=1764010117;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UGnO/Bwz/Bdpjz8RxXVYUEJKHIK5XJgWwQocmBNRacI=;
        b=YemNPd5MDPSV/vlyO7y84H84xt7LO4yvfu+SX8V/7jBJjFQDi0xdfEkhMUBSQQbRVx
         QZfmf8YFmvOUFQ8uOrJPzLwfDgbHxzjPgoO/eIHQB2oMWheq9qz83RdJRtsWwASPYpA6
         EfvRv8ZyPkApVevSefHIAOwB7CmYPGzrKNtns7cxtEQLjc+Y1h8wMGS4FXqNC3CRpo7y
         /SZgvOqw6Ajc3uE7oy1S0ljPqou2NP2/gy6YZwmiSVdZAT4zbFD9bF1vIsA04FXeQpoJ
         9UEND95jkiBIg8zHxo80huWBu4/qW2kmOsxL22ZvXhM0a3CFg1/ZytazX70IDFIqJ+EG
         kSuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmzC07GPVd+9vnZQzPlbmRr6+HRSCJhi/jECIXh8cJYgxZilup+w8quUjqsg2V1y0uVvhw36M=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrmZk5TouCo5LNiad88tuk1OLyLUhL2BgePhI5QGVh6Qtytt5U
	dhLW1RvESW4FlMLpouKaXpkcUg1a2tkWebOZBmVKFAxePJQaVgRBtbxmTxE721DnADhNLZbXy0o
	uCQK5N1jxZfHhCA==
X-Google-Smtp-Source: AGHT+IFrvnE51rjqhZgZikSAId4eBRwM0rBdtcUofGQG56OV6eJr8JyqvovBQ6X7CtmMQHN+xu1fxfhfh3qxIg==
X-Received: from wmbgz10.prod.google.com ([2002:a05:600c:888a:b0:477:afa:d217])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b23:b0:477:7bd2:693f with SMTP id 5b1f17b1804b1-4778fe60615mr126251305e9.6.1763405317263;
 Mon, 17 Nov 2025 10:48:37 -0800 (PST)
Date: Mon, 17 Nov 2025 18:47:58 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-12-smostafa@google.com>
Subject: [PATCH v5 11/27] KVM: arm64: iommu: Support DABT for IOMMU
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

SMMUv3 driver need to trap and emulate access to the MMIO space
to provide emulation for the kernel.

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
index a0df34ecf6b0..c9f2103a25fe 100644
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
index f60acfb868d0..4c47df895579 100644
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
2.52.0.rc1.455.g30608eb744-goog

