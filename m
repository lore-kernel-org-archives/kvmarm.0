Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFA116FF30
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037992; cv=none; b=i/OqZE/eBxPV5eATa/Ni6lOFT4grF0xZ+L4BVY+JrWfQfbhFSFXv6wLPWGtgBh85wtIA45s6DvVQaHFY593XXhvlKl+5BsRJOGIQgYC5bQhD3ZC5URXDVwjV/40lfaB9JWI2Vlt2gv42DEZokZ9xd/2e8fhKoVXJpvtWaGGWWBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037992; c=relaxed/simple;
	bh=GBxVm1lLTLxZuoyRA7pl4xZkWOwLKKjnWJxtSQrLMuc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JA+aZkGESmac4L5bn/M3infZXYdlHTlyXiAycp7l1a423AtE2AEXjUNHbA5L7v+Wi97d6rQ/OvoysuyUWt0WddDIjMNjAnZ8CK6bR8ifHF7CoNwP8MeoFtrwRj6jae16XolSQwvB2Ajo0kZaydpxD3GdhUK1HCjMYTSGOIGE4bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CE2q+6xz; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CE2q+6xz"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6688c44060fso6467297b3.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037990; x=1722642790; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0OUoj11Bw7qJz7X/aUJltZsNV6l4pB1orjUswDi1Y5Y=;
        b=CE2q+6xzIHiui7UFqDRbnELfzB/kAB6qOe97gIkJdCNL4ySwJcUYLUrgM1MT26XhfD
         3o4cU60qYCH2XsizeybRJ3Uy88A6yqOvXPp+94oUz+meU0q9SerkiixO/sgIPVC3rAeK
         SWV9gL1QF/qw5vDDKZUe3ZaHeKxcWOmpH5E2i+Cp7++QrHLvlj1hOrtBOj5eBNUId2vf
         P+HjrHB7gKi/5Bj2oV7Ki+Jb+ETtbCn47udZLd1Wq+IYDyzhK1oPCzLgIR90AtcxYFcd
         8+ol3Aqjgg5rhZV1WYoSz/5+lYaby616TEY2JE5U2Wjo6qgKIlPnmLROcppEV+QGEyFV
         0cjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037990; x=1722642790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0OUoj11Bw7qJz7X/aUJltZsNV6l4pB1orjUswDi1Y5Y=;
        b=dJ0S2FM2FtJzljOPWKm1awZLYFWQ+rucmqz41QXKYcldppTxjdn/2o4Hlxbe2KmElC
         60MgzxJk4Onf2p9AZwHxnKKY42/aEkyc4qmkHzMi0scdWTpKIQmpQ3cqjXmYipNtkQAd
         7nFlpevtkXOhUlYzvRQ02vW/sn8bwSK1XHdzjyR2t/MY+vURgmEiCuu75K2MeEe0jIpx
         3lbHGZWoWoJM/7Sqy0PMYKel8YoHhp+5UyS/+t53lP8f+EFncKo9V/0bmUjnpHRSI/hE
         3OdoM9fGtZQGTIBSFffKqugmUcP/zpEizaVi75K2po6k892asdosUsC1E4QMu1znnzDs
         tEyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKczJTSgByzftPtrMoF0KVA19OhY1rhvR6HfmrQP/Y5EX2Q9IeOWEEpNDP2euDKYOV3A1kcllSsOEC2YFcxqHaPbXtnnsA
X-Gm-Message-State: AOJu0YxAYuSmvSEf7y+toA6ZQehroUwrMylGJx/LLqhp+rKOf0SORker
	VRqey7AY8c3s+fpxiXCThUE32dg8biUsCKswMc2U+6nB9hVObeBcGLN4NMWhPaZ+6pvbuYtPb+5
	brg==
X-Google-Smtp-Source: AGHT+IHWajt4q+2GEWgaIgDXJueM9mo/vIIpZUTkzUWbzeiF8EolzfURUXE0pwxlI4gUkbCX2sqdG3/b4FA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:86:b0:650:a16c:91ac with SMTP id
 00721157ae682-67a0a324dfdmr195847b3.8.1722037989755; Fri, 26 Jul 2024
 16:53:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:25 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-17-seanjc@google.com>
Subject: [PATCH v12 16/84] KVM: Drop unused "hva" pointer from __gfn_to_pfn_memslot()
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

Drop @hva from __gfn_to_pfn_memslot() now that all callers pass NULL.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c                   | 2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    | 2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 2 +-
 arch/x86/kvm/mmu/mmu.c                 | 6 ++----
 include/linux/kvm_host.h               | 2 +-
 virt/kvm/kvm_main.c                    | 9 +++------
 6 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 30dd62f56a11..22ee37360c4e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1563,7 +1563,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmap_read_unlock(current->mm);
 
 	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-				   write_fault, &writable, NULL);
+				   write_fault, &writable);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 8cd02ca4b1b8..2f1d58984b41 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -614,7 +614,7 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 	} else {
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, &write_ok, NULL);
+					   writing, &write_ok);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 26a969e935e3..8304b6f8fe45 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -853,7 +853,7 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 
 		/* Call KVM generic code to do the slow-path check */
 		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, upgrade_p, NULL);
+					   writing, upgrade_p);
 		if (is_error_noslot_pfn(pfn))
 			return -EFAULT;
 		page = NULL;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e0bfbf95646c..a201b56728ae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4331,8 +4331,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return kvm_faultin_pfn_private(vcpu, fault);
 
 	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, true,
-					  fault->write, &fault->map_writable,
-					  NULL);
+					  fault->write, &fault->map_writable);
 
 	/*
 	 * If resolving the page failed because I/O is needed to fault-in the
@@ -4360,8 +4359,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
 	 */
 	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, true, true,
-					  fault->write, &fault->map_writable,
-					  NULL);
+					  fault->write, &fault->map_writable);
 	return RET_PF_CONTINUE;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 92b2922e2216..f42e030f69a4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1220,7 +1220,7 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn);
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool interruptible, bool no_wait,
-			       bool write_fault, bool *writable, hva_t *hva);
+			       bool write_fault, bool *writable);
 
 void kvm_release_pfn_clean(kvm_pfn_t pfn);
 void kvm_release_pfn_dirty(kvm_pfn_t pfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c2efdfe26d5b..6e3bb202c1b3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2988,13 +2988,10 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool no_wait,
 
 kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 			       bool interruptible, bool no_wait,
-			       bool write_fault, bool *writable, hva_t *hva)
+			       bool write_fault, bool *writable)
 {
 	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
 
-	if (hva)
-		*hva = addr;
-
 	if (kvm_is_error_hva(addr)) {
 		if (writable)
 			*writable = false;
@@ -3017,13 +3014,13 @@ kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable)
 {
 	return __gfn_to_pfn_memslot(gfn_to_memslot(kvm, gfn), gfn, false, false,
-				    write_fault, writable, NULL);
+				    write_fault, writable);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);
 
 kvm_pfn_t gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	return __gfn_to_pfn_memslot(slot, gfn, false, false, true, NULL, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, false, false, true, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot);
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

