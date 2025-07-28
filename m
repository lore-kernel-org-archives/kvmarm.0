Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FB1280309
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725231; cv=none; b=d+EvpfqOe6r58JBCihcPzdVi1XWDI9wmCPKIQ7468+kyA++VmkgVzlDo2zELz4cfkT92GtiIlah3S2EHv/eX2LxmNaZfR7Ip1NLi/3YMt4mYiwLNgQC6LYOmodn2pvnTp1c1PmjEsV1yX8thjC++fYitn8TPdp7Nv/SL5YGRuwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725231; c=relaxed/simple;
	bh=5bIrIJsudAHYPzZIdB879cRw1jj4QXCSukrLsKf8QdA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PQVVnjDZCN44CdSu/x8ZMKudpvAG3dDZhqawlYjEFhJ+Fx5rsTXPe0es30xC6rnk+M7qb7A94LiJkGikXYoq9qc05VQ13rXzSuIvLE9GYFSrIQ8u/TL3HQ+lw1jqAhKsKhn7gJRXlayrxHFd8rxfYRGMpPksna6YD9eztElUGgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CNjP0dcW; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CNjP0dcW"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-60835716983so5418463a12.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725227; x=1754330027; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v5HIRn165MoldehQ9ZBRdjnNlH0EFnjbrSE/QAIh1uE=;
        b=CNjP0dcWkQAKlIXo/YKJVD3FyHhepIco4svL1xntFe2ndPBdyd1RcAEBsrkpQFxFgN
         bD0G1oaqMGdXSDoIr+I47S67R6EM5Dkv5gW+wQIqeDcxM9Wu3SzVpFKfJ8qIWvUlztwq
         nII52voyeD2vhtLTHR2fM+AZyzZAbFd85LGzEC/nRM5fIRjvmSp6TuYIwo5y0ZWYiUii
         D/fD+paz49AeLJW0PflM8Q9OF5f85iRNvVW+xHScdCpJCaq/iTsg+4fpS8gEDmRJZfUN
         8MmO+QHQgBgboDD160aXnJtem4kLzzfMdlTRePbZokh2pzsueD0dz4JjMFD3VDts9mSG
         Gkog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725227; x=1754330027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v5HIRn165MoldehQ9ZBRdjnNlH0EFnjbrSE/QAIh1uE=;
        b=mBsfZU8BeEPOKuLk57HZFCfwrSD1B/9/IDwXsaEwLSu+YgWtaWXXpOtDFCxrxMFKEU
         OwiJ/WeIkmEmk8o10QrvXWrOg+L+n/eDxWSCWtWGFzFmcYkvbNUBPxWnwYT9T7uOJX2E
         phgYD6yldxzCChKynv6Ut1rRBCP5GrJUH5bW0YHbG+emJFNklJJVBLwXOcXaB42xWw3m
         rrjpCrpJQRFtMQGWebxKezjfv+Nu7OYcNXJZKuWmwPsj/ShgVe6HibaToE9v477a/WeP
         jtWEsxRYpEzI899NwKo5q7qTbyVht3UFQmGUMX5hmNpr2CtrKLDOOVMAfdE0vXb7ez7d
         8RMA==
X-Forwarded-Encrypted: i=1; AJvYcCXjfxe2iwYF4JTbxXp7soNwtmUIaDw6Ucmmt6nLkkGGFesWQOLJF6vZ9H2kjqiCxYIviIzKMss=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDJj71n9ARHIYDIxmZEyqoTqHvSiUPGGA8dRQzX7hoRHVeHcSa
	QbKWzL9cf1YGueV9j11fD24yK2prXk0P8zC8H+b2KfOUR3HKCLB/4AQnhxiXjmPg7AlaNGrveMi
	xttHmXU2tsgM1vQ==
X-Google-Smtp-Source: AGHT+IGGnwZ54cHjudi9OgEir3052Ieofd0m3S19aQWQ1olBQ/FDeg6VwFY9xtf9BbfXUJAwUrST3D+tRGzU/A==
X-Received: from edxw15.prod.google.com ([2002:a05:6402:70f:b0:615:226c:afb4])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:354f:b0:612:a77e:1816 with SMTP id 4fb4d7f45d1cf-614f0b348ebmr11424984a12.0.1753725227149;
 Mon, 28 Jul 2025 10:53:47 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:53:04 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-18-smostafa@google.com>
Subject: [PATCH v3 17/29] KVM: arm64: iommu: Add enable/disable hypercalls
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Add hypercalls to enable/disable devices, this is needed as
IOMMUs as SMMUv3 can have massive ID space, and it would be
inefficient to enable translation for all of them, as most of them
are not used.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/kvm_asm.h        |  2 ++
 arch/arm64/kvm/hyp/include/nvhe/iommu.h |  5 ++++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 19 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 14 ++++++++++++++
 4 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index bec227f9500a..51cedc405e77 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -87,6 +87,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___pkvm_iommu_enable_dev,
+	__KVM_HOST_SMCCC_FUNC___pkvm_iommu_disable_dev,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 9f4906c6dcc9..82e00cb37f82 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -8,6 +8,8 @@
 struct kvm_iommu_ops {
 	int (*init)(void);
 	void (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
+	int (*enable_dev)(pkvm_handle_t iommu, pkvm_handle_t dev);
+	int (*disable_dev)(pkvm_handle_t iommu, pkvm_handle_t dev);
 };
 
 int kvm_iommu_init(void *pool_base, size_t nr_pages);
@@ -16,5 +18,6 @@ void kvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
 				 enum kvm_pgtable_prot prot);
 void *kvm_iommu_donate_pages(u8 order);
 void kvm_iommu_reclaim_pages(void *ptr);
-
+int kvm_iommu_enable_dev(pkvm_handle_t iommu, pkvm_handle_t dev);
+int kvm_iommu_disable_dev(pkvm_handle_t iommu, pkvm_handle_t dev);
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 3206b2c07f82..8739895ee22b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -15,6 +15,7 @@
 #include <asm/kvm_mmu.h>
 
 #include <nvhe/ffa.h>
+#include <nvhe/iommu.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/pkvm.h>
@@ -573,6 +574,22 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_teardown_vm(handle);
 }
 
+static void handle___pkvm_iommu_enable_dev(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, iommu, host_ctxt, 1);
+	DECLARE_REG(pkvm_handle_t, dev, host_ctxt, 2);
+
+	cpu_reg(host_ctxt, 1) = kvm_iommu_enable_dev(iommu, dev);
+}
+
+static void handle___pkvm_iommu_disable_dev(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, iommu, host_ctxt, 1);
+	DECLARE_REG(pkvm_handle_t, dev, host_ctxt, 2);
+
+	cpu_reg(host_ctxt, 1) = kvm_iommu_disable_dev(iommu, dev);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -612,6 +629,8 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
+	HANDLE_FUNC(__pkvm_iommu_enable_dev),
+	HANDLE_FUNC(__pkvm_iommu_disable_dev),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index 1673165c7330..c1ba7e042a7a 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -113,3 +113,17 @@ void kvm_iommu_reclaim_pages(void *ptr)
 {
 	hyp_put_page(&iommu_pages_pool, ptr);
 }
+
+int kvm_iommu_enable_dev(pkvm_handle_t iommu, pkvm_handle_t dev)
+{
+	if (kvm_iommu_ops && kvm_iommu_ops->enable_dev)
+		return kvm_iommu_ops->enable_dev(iommu, dev);
+	return -ENODEV;
+}
+
+int kvm_iommu_disable_dev(pkvm_handle_t iommu, pkvm_handle_t dev)
+{
+	if (kvm_iommu_ops && kvm_iommu_ops->disable_dev)
+		return kvm_iommu_ops->disable_dev(iommu, dev);
+	return -ENODEV;
+}
-- 
2.50.1.552.g942d659e1b-goog

