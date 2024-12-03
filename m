Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC4A1E32B4
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 10:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733222273; cv=none; b=KP0JGV9GRoSFwW9dahkW5BN2jhc0e00WRYUShAlT0PZz0S14lEDyX5lT9PZBh4TBVbDiRHl0nqV84YbxxJCGufemoARB5RhIk1aehAAM9YuBfzd+4bIku6QlO81utU3sGF0kSrKCcZ26r8KfuCq1Wu9KRVZFVvtS5O+e8B5CG2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733222273; c=relaxed/simple;
	bh=XksbjYbcE1NqtMF0vk/s2rTUbbEHjEBgtZwZqvpH3DE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FyaKop7/ZOctwLgTykUfw3c7jzXSaU5MOLSuiFlsq7PQYiHmeV7PNYa7F2brxapeCHRvTniX3UviYJEP60K2xuYxwFVABn+SPbu03hakLXI+hIhji9XgNi9NueJsFifyDOUaeiSMHQ+xhEdKg0MLKcWBhYW8vGjnnbUiQ8Ai7sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J/e+Ve9U; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J/e+Ve9U"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5d0cd8a0ec5so2256378a12.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Dec 2024 02:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733222270; x=1733827070; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8+RnTOcmNRxXwhtm+wQBKlKgN7Eb65VjOuEvF6hfgqY=;
        b=J/e+Ve9UBdCKMwZPLxzDE7jVwsUTO/cCof1yFwTT5W6HYiutnhiJ2ib7ycInznLG60
         EX3u6SsxgZQFFiATIIyE4Hs6U4atyFwcEinUlyeiiD3E6ISS6PEb2yyKL6WEsGZtd071
         K223M/e6FWYvnBmqWeB9/CsCf32c/VOYQVV7mtqrZeJxi6Em8v8TOVYKWZ7lFJIozyif
         bqBIJcpTjyrxtF9TWpMGNZhZYuU4PfVQnT21JYqwytsFlloo/e/4BgY/0ON99eNXzk+6
         PyAZYMhzWw1D3WVpySoyA431ii8IkJr3NO5jJ79mMVgwUA8C0bDJtAKF1LrQpHh3i5ja
         OsyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733222270; x=1733827070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8+RnTOcmNRxXwhtm+wQBKlKgN7Eb65VjOuEvF6hfgqY=;
        b=m2WKXCLKPOuI2no9Auc1j0NvhBwWtUfU+0bfp4grS6yinP7jd4CmX/Yg0Pt87p0HcB
         TRQdRQ1IkcglEQcPA2xZkpldThJxjkq+jHQ8P5lqwCwNWlqq82+zC2jXURAgCkuzq7qx
         wRosISmDj6yL4HSC6NPfeL8d3X8T0rT4WmdgWP67NY3q19IgA66yp59mtVr4awgqqxEj
         z40vaKF/qc8zkuhWNdDAnxnHY2Jm1DyuyBnReRPoTZH6kbbPJ7HmZxW2C9TZtsSgN10H
         L+mqHhXOd004gEzy9+i63cdRdKO/BrfDUil8e60qvWT9/fhw3wMaT5fiHzC2nd/i8TV6
         7GwA==
X-Forwarded-Encrypted: i=1; AJvYcCWVcW5xkOwqKrDASk3ZOquXj4idcnzOgHY5Yu7N4tjwLgGgEmfC98Fk0Zi1CKhqm8usPr/3o6M=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLRxCqxg2Su9VniXi4untESIZKzOKe0tT9loZGX/kXymrAfAsp
	H/8eYpEWODvA5oJyVULUKQJbX9SfaECQlFqKNDi8/HGmF51b0Xt15ARtXUnfS729t/vznlyA8hz
	X9/BHEg==
X-Google-Smtp-Source: AGHT+IEkCh4976H9zoeMRqzwAu1itMZtieMRxRM0H0hSSBC62K8xa96o6pizViFqZkrAm2FM/BgncFwuslk8
X-Received: from edrm26.prod.google.com ([2002:aa7:d35a:0:b0:5cd:564f:2e8c])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:b73:b0:5d1:11b6:2246
 with SMTP id 4fb4d7f45d1cf-5d111b624b2mr138127a12.32.1733222270207; Tue, 03
 Dec 2024 02:37:50 -0800 (PST)
Date: Tue,  3 Dec 2024 10:37:23 +0000
In-Reply-To: <20241203103735.2267589-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203103735.2267589-7-qperret@google.com>
Subject: [PATCH v2 06/18] KVM: arm64: Pass walk flags to kvm_pgtable_stage2_relax_perms
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_pgtable_stage2_relax_perms currently assumes that it is being called
from a 'shared' walker, which will not be true once called from pKVM. To
allow for the re-use of that function, make the walk flags one of its
parameters.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 +++-
 arch/arm64/kvm/hyp/pgtable.c         | 6 ++----
 arch/arm64/kvm/mmu.c                 | 7 +++----
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 38b7ec1c8614..c2f4149283ef 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -707,6 +707,7 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address to identify the page-table entry.
  * @prot:	Additional permissions to grant for the mapping.
+ * @flags:	Flags to control the page-table walk (ex. a shared walk)
  *
  * The offset of @addr within a page is ignored.
  *
@@ -719,7 +720,8 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
  * Return: 0 on success, negative error code on failure.
  */
 int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
-				   enum kvm_pgtable_prot prot);
+				   enum kvm_pgtable_prot prot,
+				   enum kvm_pgtable_walk_flags flags);
 
 /**
  * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0470aedb4bf4..b7a3b5363235 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1307,7 +1307,7 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
 }
 
 int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
-				   enum kvm_pgtable_prot prot)
+				   enum kvm_pgtable_prot prot, enum kvm_pgtable_walk_flags flags)
 {
 	int ret;
 	s8 level;
@@ -1325,9 +1325,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_X)
 		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
-	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level,
-				       KVM_PGTABLE_WALK_HANDLE_FAULT |
-				       KVM_PGTABLE_WALK_SHARED);
+	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level, flags);
 	if (!ret || ret == -EAGAIN)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
 	return ret;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a2339b76c826..641e4fec1659 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1452,6 +1452,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1695,13 +1696,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * PTE, which will be preserved.
 		 */
 		prot &= ~KVM_NV_GUEST_MAP_SZ;
-		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
+		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot, flags);
 	} else {
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
-					     memcache,
-					     KVM_PGTABLE_WALK_HANDLE_FAULT |
-					     KVM_PGTABLE_WALK_SHARED);
+					     memcache, flags);
 	}
 
 out_unlock:
-- 
2.47.0.338.g60cca15819-goog

