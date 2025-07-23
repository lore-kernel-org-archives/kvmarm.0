Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E2828F942
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267652; cv=none; b=CsfShaFmFLZLp3QEwfVyKmmfOuq5gB9++n7Lgrop3TcXHRBnSCL7OsJcG+AWrNTtXJVP/8cgQB5p/UakQMed2GqIFu1kmEtxFgvvwRnGrqM6go01bIWD6W2sn1VzhUvE5JOZcI6pXHPjDu0FwI8GrUBpqmonw60S9oz8LIhEOzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267652; c=relaxed/simple;
	bh=vWGb/tkcV81zBUADrzxzfuQ/Gkz9tsdMTYCoMZexBv4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EYRv4rTEgcNUhFJh9g4vcY+VfRC9NIoszit1RBnAMSKdEbeeabM0cs68TaeCT2prl71X5diTlECBkBJKKRFKyHSA+X5i2lWmyAWnwNvtUdQgOOedWM0tWXEnCl6PfCvcxZnoIRmFxJELeby5IWmxGnLEKyV+3+ux1bqL7VnuO1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G+KuueiU; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G+KuueiU"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ae6d551ef64so573449866b.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267649; x=1753872449; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lQQDV4zydkRfplEEJZqHClNg8epmyuBAYmjUZ8gGwtc=;
        b=G+KuueiU6FRzssz3q4DZazaX1slKHPk+Xf1a1DquI/J8PawRjvmpSXp5Z7sRDU/Ao7
         fFrwsteSDHO5UXkyd2WbJ4NcE5f8qxWLpfD5DEKKDcoZ6LFt+GJumwtizf6obEZftLJj
         V0nYcndl13WirjgZo3rWNHHBSaEnf12kGAYxYD7I2HPpn39hNLaidI2n/LZX4qePmwCP
         2UZ2/s0rac2LmE5zTLZW7eyOtquMkzB8Cpb/GZtcDnwl3qx1t2PgCSArOCuHaoDOzUk5
         dMYUGhm7paT58HxaUrrEQllHKLxXBcbkbBMjS+r/fzCZy2wUFwTzchFvXPZA/m6waC2Z
         anMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267649; x=1753872449;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lQQDV4zydkRfplEEJZqHClNg8epmyuBAYmjUZ8gGwtc=;
        b=BcZoqGGW9KWyoUB2COPSMG0lPb9fOBk8carL2OLU3JBgqKRZotyHqUVZRA1jr5TRpP
         x++mPsrDHAT0WUquyHdpDn9tSnTIETs1daSUJ/hk0yLXASY5H2dxEzGChd+aBKmLy8LY
         fUBCkYHlcG9g9S/tBAuXXOK8JmO+bPNDkz3ZvLfQvIHHPmAg3D7HTTlkA6J9htQk9l9R
         U8b3axKG8aAJHw58OUvPs2qUKer1MJhFdIUA9XMSghEOKv4vLx73fR+wSvSY7zS9mTeU
         38XugViI7t3mo8z4Gx92DpbECqtuq5QrkeBNbw9IpMc3yUxGJhSH2LfQ9zTpwFk37sXy
         uuJw==
X-Forwarded-Encrypted: i=1; AJvYcCWLdulN5kwZTmk/C917VwaZcI+xcgOiEFKAeehKo/8VZkG+Pu+9d56ahcyB/35AEQFr5kWF8Zs=@lists.linux.dev
X-Gm-Message-State: AOJu0YznRQW34tYC4THlSTVOoc1lkh0ADvHDuLdKSqSkp8wnygp1arHG
	AypmJyCQ/LbgT7Gd6bEf//DsUdP+ByL95UxcEFZbBdHA3/w6XDHg/1ci8X15+vDu+tNAkXQ8k/G
	3uw==
X-Google-Smtp-Source: AGHT+IHUARfg6/5ZFJQc2SIXy/3Rb3LhLodoPi1Lw4aDiFctD3VlOj53YvljiGL2HPFj4hs52zuLJqVWPg==
X-Received: from ejczi1.prod.google.com ([2002:a17:907:e981:b0:ae3:c5c3:8b1f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:934e:b0:af1:1dfd:30f4
 with SMTP id a640c23a62f3a-af2f8d4b141mr169166366b.47.1753267648787; Wed, 23
 Jul 2025 03:47:28 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:05 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-14-tabba@google.com>
Subject: [PATCH v16 13/22] KVM: x86/mmu: Hoist guest_memfd max level/order
 helpers "up" in mmu.c
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Move kvm_max_level_for_order() and kvm_max_private_mapping_level() up in
mmu.c so that they can be used by __kvm_mmu_max_mapping_level().

Opportunistically drop the "inline" from kvm_max_level_for_order().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 72 +++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b735611e8fcd..20dd9f64156e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3285,6 +3285,42 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	return level;
 }
 
+static u8 kvm_max_level_for_order(int order)
+{
+	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
+
+	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
+			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
+			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
+
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
+		return PG_LEVEL_1G;
+
+	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
+		return PG_LEVEL_2M;
+
+	return PG_LEVEL_4K;
+}
+
+static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
+					u8 max_level, int gmem_order)
+{
+	u8 req_max_level;
+
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
+	if (max_level == PG_LEVEL_4K)
+		return PG_LEVEL_4K;
+
+	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
+	if (req_max_level)
+		max_level = min(max_level, req_max_level);
+
+	return max_level;
+}
+
 static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot,
 				       gfn_t gfn, int max_level, bool is_private)
@@ -4503,42 +4539,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		vcpu->stat.pf_fixed++;
 }
 
-static inline u8 kvm_max_level_for_order(int order)
-{
-	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
-
-	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
-			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
-			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
-
-	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
-		return PG_LEVEL_1G;
-
-	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
-		return PG_LEVEL_2M;
-
-	return PG_LEVEL_4K;
-}
-
-static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
-					u8 max_level, int gmem_order)
-{
-	u8 req_max_level;
-
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
-	if (max_level == PG_LEVEL_4K)
-		return PG_LEVEL_4K;
-
-	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
-	if (req_max_level)
-		max_level = min(max_level, req_max_level);
-
-	return max_level;
-}
-
 static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 				      struct kvm_page_fault *fault, int r)
 {
-- 
2.50.1.470.g6ba607880d-goog

