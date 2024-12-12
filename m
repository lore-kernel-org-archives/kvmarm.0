Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5903E23F9F3
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026783; cv=none; b=gEiNho4yMaSL7dB+chfOsV3EW61ZQQywiK78xmTtNjCSpuEH0HEuhlQqtzg3LM9L2+AKDtmQmkO+tNeLL5pVMp4SLojezaPLTa0S7fnCFIEQiO4aQbZBgcDIVSC1pXqy/ieIjW2dFJm2+VwySL6xNOamEoEF/Q5eqJQu00/enGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026783; c=relaxed/simple;
	bh=EjhIv/oYPDXLgKafBR10ANdAhLD+MmwuWT2lvorilf8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dpGwdEJ1ieKSTRXyW9emFZpI5qv6SAIpEF3BiXKCf2vIVGG8atoi+7oWyIoApj5pRQ4wvXV/FreGTnaPlWF39RJjfgCaHHi9N7r8r65EAoRA0M93SxWPgKO89WZc2+V9uSaVkg9+yjKB7NdIoW1sDdqb43EdOJYtHRznmS0YV50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AmLr8ubp; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AmLr8ubp"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-434fb9646efso8354745e9.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026780; x=1734631580; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=031HktvOH2BGPB/61CKgeoO+FWayRh3FpkimFP0IrdM=;
        b=AmLr8ubph2VzUXd6h+Qrea0gQ5xYxMS+kaao2jBfIsDW/NF6vAIusIbqJkHCkjFlWa
         eInI0Lxpi8mngsrIQKPdRTNVvrcIzk2d3KTl3uAbETMrUoYSdIScpdiAKhLzZL+ghkDG
         SyN+lEeouF/j0t8OFaHGN0eZ+MCPcwhxKShkorDzQbYO+SckjfgXIB/xkuKCVOKXwDxJ
         10GXLOSJ5M6N5+teRwurirXP/vD1HeTgTRbkosSVvQ1ymQIm/Eab4CGsBaOJm4hi82Gz
         azgyfCfD01+gGwRUuiFW5JgBAx6RPmoWHCqoUNWj4hsDpC8kQqWfP5jgx0EVVZ+Hd/bS
         87eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026780; x=1734631580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=031HktvOH2BGPB/61CKgeoO+FWayRh3FpkimFP0IrdM=;
        b=Rs43oIHNIAhhdu/bdD69HxakWetfhnLDinYf2Yw/g5iyimnQepqg/ZaS4EAAdO8mIW
         otrk7+7ZYb24O+EE1vbBC5L+wBJR+L2QQeRYEcd1SYNx7v3QJb7CfHYBm3kod1sP4UKt
         0+9siReUUyz8aVpf9IkAZ/MfY5AbipP16A9KZ4MxVsmOrxCzUCsmAdVQQbDq74sE1UMR
         eBTG04fQGp73gkYPfHFUdak786XEYithAmfvOJUAIksGvzkIfZDPnlaeUSGLPHhPoty1
         SDmGlXrq5LMV5wQEixkNLTt5F1HVZ3hheWiIF7fkeS4uI+bVNAX5n+zH7b9mpdTOUes2
         FRgA==
X-Forwarded-Encrypted: i=1; AJvYcCWD0d5PqVjPxQxmjgbnWyM+Wg/qUoT1MaL5wRipqfl3f9i2zMs7NG3YvW0eoNl2EmLQu972MlI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzz6cquQn2aPwyVrB4q7FLQAN0w7IHEDlUQvD/RUb92PKVz3L3I
	m/DzuGAb9dPe83ACoynCNAQKqJ7SRuDdmb3fjZPikwufhXzxKsAWGgCoJ5qCHJNN0/C1w+l/t5Q
	kfZnrCKWD8Q==
X-Google-Smtp-Source: AGHT+IHfy5GSFaMJOYpvz35FVWeSJ2xaUjg6ph5uDhYTSNl0fSLoTlqEzHaAu45qIKjF2hF1Km0UhuK02XOy2w==
X-Received: from wmmr4.prod.google.com ([2002:a05:600c:4244:b0:436:1796:9989])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:83cf:b0:434:f7e3:bfa0 with SMTP id 5b1f17b1804b1-4361c3e351fmr61389525e9.21.1734026780064;
 Thu, 12 Dec 2024 10:06:20 -0800 (PST)
Date: Thu, 12 Dec 2024 18:04:10 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-47-smostafa@google.com>
Subject: [RFC PATCH v2 46/58] KVM: arm64: Add function to topup generic allocator
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

Soon, IOMMU driver might need to topup the IOMMU pool from map_pages
IOMMU operation, which has a gfp flag is it might be called from
atomic context, add a function to topup an allocator with an ID
that also accepts gfp flags.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  4 ++++
 arch/arm64/kvm/mmu.c              | 20 ++++++++++++++++++++
 arch/arm64/kvm/pkvm.c             | 20 ++++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a3b5d8dd8995..59a23828bd0e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -155,6 +155,8 @@ static inline void __free_hyp_memcache(struct kvm_hyp_memcache *mc,
 
 void free_hyp_memcache(struct kvm_hyp_memcache *mc);
 int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages, unsigned long order);
+int topup_hyp_memcache_gfp(struct kvm_hyp_memcache *mc, unsigned long min_pages,
+			   unsigned long order, gfp_t gfp);
 
 static inline void init_hyp_memcache(struct kvm_hyp_memcache *mc)
 {
@@ -1628,6 +1630,8 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define HYP_ALLOC_MGT_IOMMU_ID		1
 
 unsigned long __pkvm_reclaim_hyp_alloc_mgt(unsigned long nr_pages);
+int __pkvm_topup_hyp_alloc_mgt_gfp(unsigned long id, unsigned long nr_pages,
+				   unsigned long sz_alloc, gfp_t gfp);
 
 struct kvm_iommu_driver {
 	int (*init_driver)(void);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ef7e8c156afb..229338877c59 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1225,6 +1225,11 @@ static void *hyp_mc_alloc_fn(void *flags, unsigned long order)
 	return addr;
 }
 
+static void *hyp_mc_alloc_gfp_fn(void *flags, unsigned long order)
+{
+	return (void *)__get_free_pages(*(gfp_t *)flags, order);
+}
+
 void free_hyp_memcache(struct kvm_hyp_memcache *mc)
 {
 	unsigned long flags = mc->flags;
@@ -1249,6 +1254,21 @@ int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
 				    kvm_host_pa, (void *)flags, order);
 }
 
+int topup_hyp_memcache_gfp(struct kvm_hyp_memcache *mc, unsigned long min_pages,
+			   unsigned long order, gfp_t gfp)
+{
+	void *flags = &gfp;
+
+	if (!is_protected_kvm_enabled())
+		return 0;
+
+	if (order > PAGE_SHIFT)
+		return -E2BIG;
+
+	return __topup_hyp_memcache(mc, min_pages, hyp_mc_alloc_gfp_fn,
+				    kvm_host_pa, flags, order);
+}
+
 /**
  * kvm_phys_addr_ioremap - map a device range to guest IPA
  *
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index e6df35aae840..0c45acbbff6e 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -1114,3 +1114,23 @@ unsigned long __pkvm_reclaim_hyp_alloc_mgt(unsigned long nr_pages)
 
 	return reclaimed;
 }
+
+int __pkvm_topup_hyp_alloc_mgt_gfp(unsigned long id, unsigned long nr_pages,
+				   unsigned long sz_alloc, gfp_t gfp)
+{
+	struct kvm_hyp_memcache mc;
+	int ret;
+
+	init_hyp_memcache(&mc);
+
+	ret = topup_hyp_memcache_gfp(&mc, nr_pages, get_order(sz_alloc), gfp);
+	if (ret)
+		return ret;
+
+	ret = kvm_call_hyp_nvhe(__pkvm_hyp_alloc_mgt_refill, id,
+				mc.head, mc.nr_pages);
+	if (ret)
+		free_hyp_memcache(&mc);
+
+	return ret;
+}
-- 
2.47.0.338.g60cca15819-goog

