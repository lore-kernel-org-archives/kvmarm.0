Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28188225416
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026736; cv=none; b=qcFRTc7uQPYw+XGCc7cXDCIsmxxTPZlj9EvFYX60hij5KFqCaaQEvSirYl06nLH9QnEg0die3ahulzHASbpljwr0lyhvHOxVvIGaNq5rlIjfGu7wgou0oHPk4Ef6RCm50fdLv3nUzu/i+BZjklQtCI8Qx1LyIWPfOkluVdNXVLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026736; c=relaxed/simple;
	bh=QIyUf9RC5tml3wUiGzlbTmMFJHl3q8rlahMnK3AQH94=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ANSx23+gmEp2A1c/aoYjsUuOitBcbR4JyWff767+wpELSE92gIgI7ZSeRxznYZ1WERMVtVJMzfuGnhXAsG75+xN33HfM6rlik7Pgal+X6iVkQj9NR+XINJL5bTjc/I/TaW1bmyPRNIq+Bty1TzyR1NrQbz/H53KcFC2lCVamEV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jOmJzIjA; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jOmJzIjA"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4361fc2b2d6so5534115e9.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026734; x=1734631534; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jZNgwB6X8v5j4gzxppU/t/fZqzqcDrO7o9YkYVnh2wA=;
        b=jOmJzIjAioUyAdipNuSj1h3lLTlNXql85APo94ae0pAOLoUspnKauR/+x7JcrOwHhb
         b3YQiUwbz1hvGqrc8QHtS5sMfWg7rhOu/Bd1WYwfZNlnhfiOBcY9wrVaqTDHlSs8RE+B
         IYPTbyRmETpUqXEQp8hytdfrvRa3I9LbbkLwjluuZkLJ/A34G59ZfjbrPlUztb9XQw9J
         RbFBxJUjq5AtDTiOPIhE0rfTgFiAOfCWJdJgTdOAusGRL+PxOfdoKuVgFusvbUoM8P7A
         6uoGNG63eDlPianbjHP2DkUR9ZstU0n6rXOB95TbNA1DAPAEKXo4qPm9bKRYPRb8FxQ8
         +i7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026734; x=1734631534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jZNgwB6X8v5j4gzxppU/t/fZqzqcDrO7o9YkYVnh2wA=;
        b=g0LMJOQvssvCKAMcpXgwuoZWa/AYTqJLgKnjMIr4SqblHagUe7jUKPt0BCAPdfaYw7
         cQNWPbqqHJkKLTyutIXreAUSlZVo8FSErkTcArIARbvSjS6sLovsAwvTvGZ5z49a8itV
         G3f5e1tvkuvSNBG4v+QJ8xLO2LSUWxBTksvfKNTxrwJGdEGZlY+Yt/LdybT5cdALTd+M
         jz/8IaHyMLhGf1cn3Nkro5ocgJ2AuMOfggsGF8/C0qWEiWTYMJLg1DRWHch/rpQ8W+TP
         tBoyHnEevRB4EdTHqmxWM3cSyGMhsDZRqfa4akQtwOKsapXUY3OY6VOWcK5NsTJzWn5c
         iGXg==
X-Forwarded-Encrypted: i=1; AJvYcCXTY5tcxS7W4fMdNChEIQEHkEYnxBvFyVosDs1ESTRP0mzn1vslv/iLn8sBjxdkDpmYExMHZXQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0Zg87wueqDjKKBHWf7FqUJW7P0prCGfsR4CHZO8CsdbK7pglg
	TmEml4ybKcvLtnayLtvzgponf3wnN3T+WTjbymUJPF4lXVBbA/RB45lsADSUmnDC6lluQUVohFH
	yVJojal5C2Q==
X-Google-Smtp-Source: AGHT+IFU5A2xYG/aIaT/yYE5/fNPeYIneyer4lpXo+usrcm3VGdKeb0NPMFh6orkypYDcbhz8IOsQoPR+yxjUA==
X-Received: from wmmu14.prod.google.com ([2002:a05:600c:ce:b0:434:f0a3:7876])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3593:b0:434:f297:8e85 with SMTP id 5b1f17b1804b1-4361c3aaeeemr77507485e9.10.1734026733780;
 Thu, 12 Dec 2024 10:05:33 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:48 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-25-smostafa@google.com>
Subject: [RFC PATCH v2 24/58] KVM: arm64: iommu: Support DABT for IOMMU
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

Soon, SMMUv3 driver would be added and it would need to emulate
access to some of its MMIO space.

Add a handler for DABTs for IOMMU drivers to be able to do so.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/iommu.h |  2 ++
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 17 +++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   | 19 +++++++++++++++++--
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 06d12b35fa3e..cff75d67d807 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -21,6 +21,7 @@ size_t kvm_iommu_map_pages(pkvm_handle_t domain_id,
 size_t kvm_iommu_unmap_pages(pkvm_handle_t domain_id, unsigned long iova,
 			     size_t pgsize, size_t pgcount);
 phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t domain_id, unsigned long iova);
+bool kvm_iommu_host_dabt_handler(struct kvm_cpu_context *host_ctxt, u64 esr, u64 addr);
 
 /* Flags for memory allocation for IOMMU drivers */
 #define IOMMU_PAGE_NOCACHE				BIT(0)
@@ -49,6 +50,7 @@ struct kvm_iommu_ops {
 	phys_addr_t (*iova_to_phys)(struct kvm_hyp_iommu_domain *domain, unsigned long iova);
 	void (*iotlb_sync)(struct kvm_hyp_iommu_domain *domain,
 			   struct iommu_iotlb_gather *gather);
+	bool (*dabt_handler)(struct kvm_cpu_context *host_ctxt, u64 esr, u64 addr);
 };
 
 int kvm_iommu_init(void);
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index fbab335d3490..e45dadd0c4aa 100644
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
 #include <kvm/iommu.h>
 
 #include <nvhe/iommu.h>
@@ -375,6 +379,19 @@ phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t domain_id, unsigned long iova)
 	return phys;
 }
 
+bool kvm_iommu_host_dabt_handler(struct kvm_cpu_context *host_ctxt, u64 esr, u64 addr)
+{
+	bool ret = false;
+
+	if (kvm_iommu_ops && kvm_iommu_ops->dabt_handler)
+		ret = kvm_iommu_ops->dabt_handler(host_ctxt, esr, addr);
+
+	if (ret)
+		kvm_skip_host_instr();
+
+	return ret;
+}
+
 static int iommu_power_on(struct kvm_power_domain *pd)
 {
 	struct kvm_hyp_iommu *iommu = container_of(pd, struct kvm_hyp_iommu,
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index a428ad9ca871..0fae651107db 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -16,6 +16,7 @@
 #include <hyp/fault.h>
 
 #include <nvhe/gfp.h>
+#include <nvhe/iommu.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -799,11 +800,16 @@ static int handle_host_perm_fault(struct kvm_cpu_context *host_ctxt, u64 esr, u6
 	return handled ? 0 : -EPERM;
 }
 
+static bool is_dabt(u64 esr)
+{
+	return ESR_ELx_EC(esr) == ESR_ELx_EC_DABT_LOW;
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
 	u64 esr, addr;
-	int ret = 0;
+	int ret = -EPERM;
 
 	esr = read_sysreg_el2(SYS_ESR);
 	if (!__get_fault_info(esr, &fault)) {
@@ -817,7 +823,15 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	}
 
 	addr = (fault.hpfar_el2 & HPFAR_MASK) << 8;
-	ret = host_stage2_idmap(addr);
+	addr |= fault.far_el2 & FAR_MASK;
+
+	if (is_dabt(esr) && !addr_is_memory(addr) &&
+	    kvm_iommu_host_dabt_handler(host_ctxt, esr, addr))
+		goto return_to_host;
+
+	/* If not handled, attempt to map the page. */
+	if (ret == -EPERM)
+		ret = host_stage2_idmap(addr);
 
 	if ((esr & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_PERM)
 		ret = handle_host_perm_fault(host_ctxt, esr, addr);
@@ -827,6 +841,7 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	else
 		BUG_ON(ret && ret != -EAGAIN);
 
+return_to_host:
 	trace_host_mem_abort(esr, addr);
 }
 
-- 
2.47.0.338.g60cca15819-goog

