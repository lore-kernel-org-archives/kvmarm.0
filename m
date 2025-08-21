Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A1C2EB5C2
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810060; cv=none; b=MnJX9IFgPBPvpK6hzNAeyZ8HkHkIPfQ1gNpnubm0KCMvH8wY+TkNLRAiVHAhaARlS1oawH+W5OchvB5aWh9ab+jIHDv5hrbVNysoAcO2sYmmdCeGOqsp/DMK5g4tLISsvQ4zuJuEBxEX65fMZNB3z8RjwgW5vtWq3+vX9Jwqx94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810060; c=relaxed/simple;
	bh=n2xHKJwW4GBGQxPu8+45mca9yh0HIcvMkQScT1xXiwY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iPlbsdkaHJ1RqBsYQTH1zL8MD4Y61uloFmzH4waSnueVZL6R1IocUUxWHmFb+2yvIa0qOuzGMEVUOtmmLBLygL1LMkVGXhav1RN5K99Kfc/PONAs2+jZfaG0EJOuLumctgJDonOhz3fOI7Yn7Nb1tj2JpDQCuvwg1Uc5ZACJCcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=otuR9nPj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="otuR9nPj"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32326e46a20so2466690a91.3
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810058; x=1756414858; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rIYjUyPKKDdCEejXmfDWcQPbYLUJJKvCpdBRdQ8wgkk=;
        b=otuR9nPjy61wgvd9Jpd3ktun+BYSKlOzqGwGRW9w4kv3R/Kg0awS96f6MZXjTxZwuU
         2Xs3GHi6EzLfvPRE3KWYp52H+Uj7tftXSBqsQ+Qh56y0fewskRLSnV3sn1RIdFfzz26h
         nKt7jOzfLXxHL5vkEDtk+DfzGpayuq7iYcLXTpzSbeS4ozgORaMFD5yXvzqAq0/Vbqun
         FsWJjOG4UAn0i2zumg9mmXdGtJhaSik09ZEU+mnFlq/PnmQLoDa82CS1MrDQGxzkDt8j
         /DjJNh+rO1Dz34eZN40Q86xNFF2foRxJLgrskV08SXvyw1MM2uBMwaMxE0eRIXnfrYjZ
         KHJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810058; x=1756414858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rIYjUyPKKDdCEejXmfDWcQPbYLUJJKvCpdBRdQ8wgkk=;
        b=A5BNjU+jFxqj2H3NQgeIlnFtvMWLPW9pxuxe5U4E6hqWMu1lscim3WVLfb6l8gvPB+
         5Q6lLiUugwEMP8oTASZhomJpfvg9F5LB2NbTzbSYGadky/3bXxEIePJfgAToljo3O8CP
         58UPfAYvh6yp+7dB8Wz04NRXRCGzbJeJWvW/anUwT7qE8d9oPabtZz/T/EFOMlWNCWwM
         0KJFW7k401elzg1gWXzB5tpmTXBn08YRx8kVyXWwZ8nlaXG+/cT8VrQj7sKnQeDtFbTF
         r+qDRijGoGI2k4wU3FaIQs0W+PNMerYb+dpd2vnYmMAgUoZXwkh5rnDjaAX68Slvym6u
         BdmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUs6CHwcKyXNM+IUsoVUyWKMwR2Ehanzx29DLAuenQ9sbWOoEkZlcyy5SHF4efAvTloLGR/42Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxt3vF6iFcXy+3VNj9p0W5ntfAg3t78lyMVIU++NSgSxcTM+Ta/
	MNVJyehEUsSjggL5SCLcAm5Ozdx67hepxqbpEcDFMeyoVHp1LsJANYol4xJ+g9bC2Z+xR4O40Tc
	oegCMXA==
X-Google-Smtp-Source: AGHT+IGevG4sJg+U1oYZiyIkXuxzC5L9OjooNDxBFWaxTZvDjCA0pb211437o2pCDdf6DI+kKvb4PRBSGWk=
X-Received: from pjbrr6.prod.google.com ([2002:a17:90b:2b46:b0:323:247f:7f59])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d610:b0:31f:762c:bc40
 with SMTP id 98e67ed59e1d1-32515e54409mr1117649a91.16.1755810058080; Thu, 21
 Aug 2025 14:00:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:33 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-8-seanjc@google.com>
Subject: [RFC PATCH 07/16] KVM: arm64: Pass @fault to fault_supports_stage2_huge_mapping()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Pass the full kvm_page_fault object when querying if a fault supports a
hugepage mapping instead of passing the separate slot+address pair.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 047aba00388c..c6aadd8baa18 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1287,10 +1287,10 @@ static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
 }
 
-static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
-					       unsigned long hva,
+static bool fault_supports_stage2_huge_mapping(struct kvm_page_fault *fault,
 					       unsigned long map_size)
 {
+	struct kvm_memory_slot *memslot = fault->slot;
 	gpa_t gpa_start;
 	hva_t uaddr_start, uaddr_end;
 	size_t size;
@@ -1348,8 +1348,8 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 	 * userspace_addr or the base_gfn, as both are equally aligned (per
 	 * the check above) and equally sized.
 	 */
-	return (hva & ~(map_size - 1)) >= uaddr_start &&
-	       (hva & ~(map_size - 1)) + map_size <= uaddr_end;
+	return (fault->hva & ~(map_size - 1)) >= uaddr_start &&
+	       (fault->hva & ~(map_size - 1)) + map_size <= uaddr_end;
 }
 
 /*
@@ -1368,7 +1368,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_page_fault *fault)
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (fault_supports_stage2_huge_mapping(fault->slot, fault->hva, PMD_SIZE)) {
+	if (fault_supports_stage2_huge_mapping(fault, PMD_SIZE)) {
 		int sz = get_user_mapping_size(kvm, fault->hva);
 
 		if (sz < 0)
@@ -1547,7 +1547,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(fault->slot, fault->hva, PUD_SIZE))
+		if (fault_supports_stage2_huge_mapping(fault, PUD_SIZE))
 			break;
 		fallthrough;
 #endif
@@ -1555,7 +1555,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		vma_shift = PMD_SHIFT;
 		fallthrough;
 	case PMD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(fault->slot, fault->hva, PMD_SIZE))
+		if (fault_supports_stage2_huge_mapping(fault, PMD_SIZE))
 			break;
 		fallthrough;
 	case CONT_PTE_SHIFT:
-- 
2.51.0.261.g7ce5a0a67e-goog

