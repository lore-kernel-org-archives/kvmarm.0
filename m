Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEBF15AAC1
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038130; cv=none; b=KpI63XW6/MplG0ih1CQQagpcZoXwT62jYGweGJgAJju1r8vDbbzr3J6NNh1+bPb4uafO4OIAvqOiSSownwr6IbDt/ragCoy3K+nN22DUuMth0R+N2VvMxVbdOPIgv+2VwVwRUSTW8qISFa/Vfqyng0U9s5JinPV6sjTxPoBiccU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038130; c=relaxed/simple;
	bh=emk7Z8a7fhL7Xn+sv3OLuYrPeVkEgytK3q87Mr+MFTs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jrlJYBEsnPMbvXG1IvFgjbcUsr9OR8lfwcPxWrtyGSf0mVLB27SvT7vQEaWzb61pJrTxVsI0Zl2wG+OIqQQYG/Ue4HXeDzK5lWvX2FMQAKS0+6VHikCpYAwZaktKHrAuEe0Sz8xiA5gLRG4tFpG8R2SvxeIq/yGerYEraDIYNnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GeaewKdm; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GeaewKdm"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d392d311cso1417697b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038128; x=1722642928; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Truk8wLwk4Y9wyHD0oQlYUKlIPfs2FyGYSCSiM9XszU=;
        b=GeaewKdmjBewFaG8W35S1e/28PAtk2BHg2ySHqNBw6HTdIH7zrZRtfNB06ELig9t/3
         +Xoabd3Fi7MsRrkkc5idCt7AISQ+OmPvoIEto7hUs7CSM+TOMtE7pz2FSwAcS0jfYYgF
         Q/tj+dbVBjVaL1V3RaW79DGtMe90nBW9wh8BbZm4GRVdewg4IcNAZeuFfmMD10Es2oN+
         HfytpVB45qywQcodoreRBO46BfvVQFbs34XC1ZsCbxm47y2ICVR6pO4jKWG/a82s8JrI
         f+09sf0fVTWmOphEgIO5txhblZjxlgIm1K8Yv0HxSbFXZqENKnS7CUYAWB9QjPPVyFcy
         GLHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038128; x=1722642928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Truk8wLwk4Y9wyHD0oQlYUKlIPfs2FyGYSCSiM9XszU=;
        b=b+M4XaZ2KuXzg4HMkRpfd1vS/Eq6Jt5KTEtLUL3jEazNOA7cenl/ZwAY9I0F+DfKGY
         5fp8je+D/MCaIQplNzbcRHhMnGSQjMrr+4wOvfniDztAdsq4KjY9r9Go0T7uBXeafDvK
         h/t2fTwDx+4fii/rci6x8Hx14v6G3B0AfEEYNnYotndowro91a/WYRsiq4X48yaxWK7s
         YIdAS8L1EmaeTeM8OZa2rFlku428mz8Eu4ftuaOTNrLdH7rO4Da4i4b3VJQwijmAukzO
         pxEn40JiqX/ALIoFn4cJ1UoxCIbdlleM3QmveLy+s66OY0+ya7YtQDYKZxlADbL/rlGk
         sbdw==
X-Forwarded-Encrypted: i=1; AJvYcCWEDWLbzmHOSZg7UI/LTRVrDJHsibuBoFASQi6T0PJ7WljU5jRucMlG7PjX0fYK9kKW0eCSlYlx/NRDCVExZDORv09nPJfJ
X-Gm-Message-State: AOJu0Ywws06kVUNgk1VxE3EvTZvFm5syu88k3Ql2P6gxtWV6ysGoVVKh
	6Y9YkswxZICvFIzqCOGlJpCOQdG5yUhPaUlQBtNWEbu50WuE/bllN6qDKau9elK/QxqeWV4txuf
	eYw==
X-Google-Smtp-Source: AGHT+IESez/zxTWutjtLJAUJhIiTiAtRpWSvjJWmuvSpH774la09rZR91czqzlEpBwGUZ+0osFi4L0/wScE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8591:b0:704:3140:5a94 with SMTP id
 d2e1a72fcca58-70ecea0e7ffmr15968b3a.2.1722038127870; Fri, 26 Jul 2024
 16:55:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:31 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-83-seanjc@google.com>
Subject: [PATCH v12 82/84] KVM: arm64: Don't mark "struct page" accessed when
 making SPTE young
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Don't mark pages/folios as accessed in the primary MMU when making a SPTE
young in KVM's secondary MMU, as doing so relies on
kvm_pfn_to_refcounted_page(), and generally speaking is unnecessary and
wasteful.  KVM participates in page aging via mmu_notifiers, so there's no
need to push "accessed" updates to the primary MMU.

Dropping use of kvm_set_pfn_accessed() also paves the way for removing
kvm_pfn_to_refcounted_page() and all its users.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 +---
 arch/arm64/kvm/hyp/pgtable.c         | 7 ++-----
 arch/arm64/kvm/mmu.c                 | 6 +-----
 3 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 19278dfe7978..676d80723c38 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -632,10 +632,8 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
  *
  * If there is a valid, leaf page-table entry used to translate @addr, then
  * set the access flag in that entry.
- *
- * Return: The old page-table entry prior to setting the flag, 0 on failure.
  */
-kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
+void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
 
 /**
  * kvm_pgtable_stage2_test_clear_young() - Test and optionally clear the access
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9e2bbee77491..6679e02a02c4 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1287,19 +1287,16 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 					NULL, NULL, 0);
 }
 
-kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
+void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 {
-	kvm_pte_t pte = 0;
 	int ret;
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
-				       &pte, NULL,
+				       NULL, NULL,
 				       KVM_PGTABLE_WALK_HANDLE_FAULT |
 				       KVM_PGTABLE_WALK_SHARED);
 	if (!ret)
 		dsb(ishst);
-
-	return pte;
 }
 
 struct stage2_age_data {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 756fc856ab44..8fd8ea5b5795 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1699,18 +1699,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 /* Resolve the access fault by making the page young again. */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
-	kvm_pte_t pte;
 	struct kvm_s2_mmu *mmu;
 
 	trace_kvm_access_fault(fault_ipa);
 
 	read_lock(&vcpu->kvm->mmu_lock);
 	mmu = vcpu->arch.hw_mmu;
-	pte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
+	kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
 	read_unlock(&vcpu->kvm->mmu_lock);
-
-	if (kvm_pte_valid(pte))
-		kvm_set_pfn_accessed(kvm_pte_to_pfn(pte));
 }
 
 /**
-- 
2.46.0.rc1.232.g9752f9e123-goog

