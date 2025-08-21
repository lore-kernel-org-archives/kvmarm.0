Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584232EBDF9
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810067; cv=none; b=iIavIIUguHzMwxnM4yZiyMBkS9VPEdfKNXRoGiccAngDJlbY/vyTG/15zDuqFO97jaSHvqaHRsXvdTSbbbHUUgJDcg91gW3IBgbSw4uPW/JRNXPeTeS+CURCah/+VIfcVS8hSkYIaPXMabcaXJcjxnYX+Y+gV7BuzTR9PvZNXk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810067; c=relaxed/simple;
	bh=6TQp1XTfTlSOYUWOIWGmda/8IL4quEzAyAn5KTiu3gY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W6AMA/qOHx5BIYA6orFEegzky/04sWze35Xbs/lgxitiDK+6P9z4YtN3LiKCChkLrj84STzdrdNNBPYKkdzdl0r03ZciTDmzbvTDbOPe0o/P4sFd3YU+SsLmaXxEeUzGc2NtLyVic7x/FSQ9dNuh7Vf552lU6IYpcqDrem4PVMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mGkI38Ai; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mGkI38Ai"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-324f81677d7so943525a91.0
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810065; x=1756414865; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l3aBAqBLvvziXAff3l7qHBrH3ii9s2uHCbYHv1XlpUE=;
        b=mGkI38Ai2KP3I/zMX3BCoL2luqSF4NOCcxNkmRFfL0NWoTERINRdfNUYW7n7mQ854G
         TCCceBCUFueKC8E4LUNerzjSXGiDWyyl7UiUsiR3hIjdpCE7xodz1tgWOm8Dz+GkYJJR
         vBieSIsE6n41PaIyO6VJ2e9Yb/aG+QFQlxbKH4N4SpOLF7zUw6h3ShwBLtkV5ptXq6wM
         8SbbuVgFt1VbZ+D6HfvqYZSILEIIlK06/JMvNZKfQ2uimGeh8bJNhJ5uxfmmnIKxccrD
         hVJqOr3bbPPz7ufL/4+dBHXr0kDTHRFy8tSNIyPhM2GfKh/Ds04AAar3bEr8qJt/tdrE
         pFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810065; x=1756414865;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l3aBAqBLvvziXAff3l7qHBrH3ii9s2uHCbYHv1XlpUE=;
        b=Omh45rIazrryDvnM+9007HBkWv8DItCyPjuZ3NpnAroY8BGYYmavaJ+cbWuTJOYYn0
         lyoKUAYmFpmmrSdVatCctsEfeUAdbs7OreMGnrx0vSeq4BYAERDYKg1EVHmDMekeZ4xM
         U41+c2dbFFSwyrDejx6PxJLVtRsParvYMM0gdJILTvoPh7tO5KNKYsFzk/3pdfcaZ9wO
         bsw/Y+NpJmJWfgqawRUQDAA/EQO55EBiGim7fKGWPXW57916NvdnM8/ykh2alTgcFyHa
         TozQukL20BF8jzMwGs2pVqISLUCOoY7EwyXN04pqTtrzbOJxdeiXLhuXgYt9l9eCyL4f
         9vWg==
X-Forwarded-Encrypted: i=1; AJvYcCWer+HoByv6rYTj3fI7RqSYauPSm1HnS3I9c2VDK0ilrevq+NWpxlMaftVLFq6RLJZ5FvEx5qw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+I+Okn+Aquw13G30NN2vatjeKugbZp2tMlDUs5OjcYZyzOidw
	eGVdZCuqeVJB5RiBqa0AiVbTme7NNu3uyr5gwxgzl7Yc4M1pWfV6JeZSNHSdXfHALjY11ku/w7w
	Elv9/Bw==
X-Google-Smtp-Source: AGHT+IHyv2vSy5H3gPx/CMXMIii4nN/TDg0JEF0C1pJibiyBy90Nx8cGqdPBlytbuWHgL7DJUzJnyJ3Kweo=
X-Received: from pjbee11.prod.google.com ([2002:a17:90a:fc4b:b0:312:187d:382d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c87:b0:324:ec53:1385
 with SMTP id 98e67ed59e1d1-32515e36b2emr1212430a91.10.1755810064638; Thu, 21
 Aug 2025 14:01:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:37 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-12-seanjc@google.com>
Subject: [RFC PATCH 11/16] KVM: arm64: Drop local mte_allowed, use vm_flags snapshot
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop user_mem_abort()'s local mte_allowed and instead use the vm_flags
snapshot.  The redundant variables aren't problematic per se, but will be
quite awkward when a future change moves the vm_flags snapshot into
"struct kvm_page_fault".

Opportunistically drop kvm_vma_mte_allowed() and open code the vm_flags
check in the memslot preparation code, as there's little value in hiding
VM_MTE_ALLOWED (arguably negative "value), and the fault path can't use
the VMA-based helper (because looking at the VMA outside of mmap_lock is
unsafe).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e1375296940b..b85968019dd4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1454,11 +1454,6 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 	}
 }
 
-static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
-{
-	return vma->vm_flags & VM_MTE_ALLOWED;
-}
-
 static bool kvm_vma_is_cacheable(struct vm_area_struct *vma)
 {
 	switch (FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(vma->vm_page_prot))) {
@@ -1475,7 +1470,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	int ret = 0;
 	bool writable, force_pte = false;
-	bool mte_allowed, is_vma_cacheable;
+	bool is_vma_cacheable;
 	bool s2_force_noncacheable = false;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
@@ -1606,7 +1601,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	}
 
 	fault->gfn = fault->ipa >> PAGE_SHIFT;
-	mte_allowed = kvm_vma_mte_allowed(vma);
 
 	vm_flags = vma->vm_flags;
 
@@ -1724,7 +1718,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	if (!fault->is_perm && !s2_force_noncacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
-		if (mte_allowed) {
+		if (vm_flags & VM_MTE_ALLOWED) {
 			sanitise_mte_tags(kvm, fault->pfn, vma_pagesize);
 		} else {
 			ret = -EFAULT;
@@ -2215,7 +2209,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if (!vma)
 			break;
 
-		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
+		if (kvm_has_mte(kvm) && !(vma->vm_flags & VM_MTE_ALLOWED)) {
 			ret = -EINVAL;
 			break;
 		}
-- 
2.51.0.261.g7ce5a0a67e-goog

