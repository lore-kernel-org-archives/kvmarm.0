Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A884A286408
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 22:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829756; cv=none; b=O7Lur3BZGm/6Opm0GAMqMN/kdbb6s362wjwX1B7VEjF9I3VQZAu/Gt6PFvdCUs1QtkUzZFW0Q2OEuxJC1yWpMmVezUDgUVRKyQaFM089krFJzQ2CwvgUu2AahzQdtNAqcPPbJHEuzCz9eJnuSlPAqgalWb7PChnQpzfNm5zkpn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829756; c=relaxed/simple;
	bh=kT4TPh6b6a+599yVr48tLtWPsbJrSQilKhWv9nX31KU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=skwQCqaxnZ4E2+cgf51omBrG0enjwGitl/i0ncKJxcZkA0yoStTybIiQgvyfCnm61tj+IKcziw1op076UA3Cnbtqv6gR7c8y9rgy7YCn5Feqn8Cgpr0gcJ2dXSO9WntBG6Aqt2Qvw4Wd8AnRCJfXlx7opHdZ4cak8lWIYrS7oms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V2wdpRMh; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V2wdpRMh"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b0e0c573531so4462238a12.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 15:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829754; x=1754434554; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ktkS4XskSt/ldoD432h3UVfIavH2avWaXTLdCBUmGII=;
        b=V2wdpRMhlcerb9JyHtukZ+ateiXQq0OH2k7KEAyqlXcwFvgSJXZhxNH/mhA1Gru6ti
         vHukb4gxxs06/yqyhaKyJXM6TUgGu2ziuzt/8EUBFcF/jt+Td0ClNZYp4xJQnLr9QRNz
         G6G3mLBRUZ4aqUgnvaSyIYcyDLiSwzvI10VdBEurVWTRQUmvTHs9bOFo29xzbGpjAJM2
         iHGHnfdaBinnqkIvuDoDGwqA3jSCEPAAUYcSP+KqkGc6kRzK3UPE/kROG+W+Ec0WU9EW
         mcjh7Kgj68t8VOjbSdO+ideyW86TfLAjXh32V5GWRa89o4dAO0p1Dgt40boQlc+zDEy2
         NuoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829754; x=1754434554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ktkS4XskSt/ldoD432h3UVfIavH2avWaXTLdCBUmGII=;
        b=LP7Cn7ybkk1cx/s6pGTCQ6QHpynfOcfihlZsBYXLttGZSKyqb0luPwF6NrMrpsH8Xc
         uca+690IJAd3y6mp/Q2W4Nq+vxNm7vbTbinCyzce0DZx3sCeuxMiBDWLPRAIW75/ia5Y
         Qba+sM6s1jHQNTxkvOyq+pwU2pr1MiXO/uRdeX8lOPuWiGCmieUu6uYTex1YOQnG7qjg
         cIv38hiEvKpus1jzt1WYmRv9SFsVHjU6sqRd2H7D/lPb+wPzHxMjVDGYDRogj1XljXz5
         3BxPpLP1BYB9NekhYwJdjZ1UqhPFcYUp01dROWKrfJjvrZmoefexPwpDyaCECtlB21qr
         pq4g==
X-Forwarded-Encrypted: i=1; AJvYcCUpHMfQxgxglXKuV5l58GNAbkyTWymgTVf8tL7envK4+CsHHurywv+2vvZoBJiktqPUO8xwi5g=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFWiGpIROgzbDTyKQqiTafcHzrEOM7qtwnwFJJivSUXrRKfrzq
	yA459VQy07i66sjLrOcwpqSNee0nPv1jtDjQyjisNs36tTIZOAPsaya223SjWniNUZheNlJyyAR
	VpzV18g==
X-Google-Smtp-Source: AGHT+IF1LeGDZhIWjFUGooq7VUSMoBrDEWnqlrxEZEjVnkOZOM3/aPj5utdyv/03YLi7nQKPITTKBEyZftA=
X-Received: from pgbdp2.prod.google.com ([2002:a05:6a02:f02:b0:b3f:2e87:230b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3c90:b0:232:93c2:8851
 with SMTP id adf61e73a8af0-23dc0d5e0b5mr1613137637.18.1753829753942; Tue, 29
 Jul 2025 15:55:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:44 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-14-seanjc@google.com>
Subject: [PATCH v17 13/24] KVM: x86/mmu: Hoist guest_memfd max level/order
 helpers "up" in mmu.c
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Move kvm_max_level_for_order() and kvm_max_private_mapping_level() up in
mmu.c so that they can be used by __kvm_mmu_max_mapping_level().

Opportunistically drop the "inline" from kvm_max_level_for_order().

No functional change intended.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
2.50.1.552.g942d659e1b-goog

