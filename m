Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C173F2C0291
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810051; cv=none; b=EeZpZjlixQbv65sPfh+hQkJhjlGg+NEUeuvdLPI4/kKwBV3X8P0tDdxAEHEI7NOs90NXh4hDQp/KCDY2LKBHvv3eAeTBq/tvYWOw9t1vWYK7dJnsVRqmlip8Dp/wYXBaZGHdNeD5WzzVPCipPwkmZYZPVp8yTkNMEc/xIHCdTG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810051; c=relaxed/simple;
	bh=cB2wU+VwA6nMuFS3kEdqkJ7/CjrceUGCWlda84QouGM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IPrT2ie2SW2MN/mE5e+D0Iyw5Ecrf6+LO4dQwFmvjBeVIlDSF/pUfMFdYYT5bLftV8qyKjFGa0JfSqlG88FpUb0gVkl2nbh6rSc5NuLuGswGB0iHJDH2+Uv9axYTbL4q3TvY+Fx4wqCYedUlEUKEMU9kAdlgc9tABXAo5B5IHTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s1KiZ3Yb; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s1KiZ3Yb"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e8ae86ab3so1599299b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810049; x=1756414849; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8p7YeBTxxS/VBPTvK9WSiN+wfsnNOjaE+88NekfQ6+E=;
        b=s1KiZ3YbKc8+Te7X7MWQXoiwTAX5riLXnnDGALbuT59uPSEXrBD/HQfUVK3ajDdOLL
         XsuO+JTuQllDU9AoBSafp7D3JDd/Rnmn/mZde5ELZp2ZbnPzsAuHwwcjhmxhFrcD8ttG
         y+mPyyAQpjFMoxeFMrMFmPPp+RmsVnBRb62pheRAUMdYpCwxLmfJBxS3dDrMq5MSy3b+
         n9U3clbLz3llV7Yh+8HCNNXHh5r3/P0Z2lxdjzltXGjsnJIrXUGJRZOJuNOdNsEoygwH
         zefp8gb1e8YRApMS5G8Ds3ZgFPIICXQxIN4scoLf5QwAk4w04B59ttLYjpYt48Wi5UKL
         NCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810049; x=1756414849;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8p7YeBTxxS/VBPTvK9WSiN+wfsnNOjaE+88NekfQ6+E=;
        b=IzTOvKidxHWzTvPFSAT92Jnl9M637yXBVLdOac92IcCpSxhz1jRs1kjOSoWsNsWCRz
         3K22PCDL7Oi0ZA2qlvkuT9g7i7wPvSgcM5OVVtymf/YOZMseS2Se8yLpzwOS8h1qxz8K
         NTOD3SVITo0Vp6uMIeL7/QQZKLcHGq8fx2tglhGTscUDtSkqjwtdpMckxcLmAc1ZDULj
         lUb4S5n4JbE2h369KznNaCNwPry4rSzCy2ZaV0MkUohXc9vJlv6t5ejFEhUBlrNDA61e
         nKi5KtGeJdCg4APkbyWF1NOXMqLB8wjKIWcunCJRlQPSf+yLxfYuwkJFY/cAPY9sV9Lk
         UFDA==
X-Forwarded-Encrypted: i=1; AJvYcCUR/y7tR5HUEHVDtuwJMfpfwsBadE9Rc4NY517DOup/8Go56x0vJoNfYBt1ZcXQk7Gu4vwZTGk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzwmblEOmO6eDfId3hlyQpaPnluKmzwEioE3ndqWOGHnSVcXNJe
	Z5b0kGETnS4OmmmsSR01Oi9PnCgmDpYUfWIIHOLrGC1iTksPSZNoFU33uhzW90sXkiiz9Bm6f1K
	dqqMXrw==
X-Google-Smtp-Source: AGHT+IGt2jvAqXlXksEez/FBRFt8Sle4R/dEKQftz/3BlDA59KSR9+VVS2FqW+adpYm0FOfYkSzrZkam6NE=
X-Received: from pfbbq19.prod.google.com ([2002:a05:6a00:e13:b0:76c:2dcd:fdde])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a8e:b0:76c:1eae:fd30
 with SMTP id d2e1a72fcca58-7702fa02d0fmr1050269b3a.12.1755810049097; Thu, 21
 Aug 2025 14:00:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:28 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-3-seanjc@google.com>
Subject: [RFC PATCH 02/16] KVM: arm64: Get iabt status on-demand
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Query if an abort was due to instruction execution only when necessary
in anticipation of factoring out the SRCU-protected portion of abort
handling to a separate helper.  The happy path doesn't need to check for
IAB, and eliminating the local variable will avoid having to pass a
large pile of booleans to the inner helper.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index dc3aa58e2ea5..1e3ac283c519 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1830,7 +1830,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
 	struct kvm_memory_slot *memslot;
 	unsigned long hva;
-	bool is_iabt, write_fault, writable;
+	bool write_fault, writable;
 	gfn_t gfn;
 	int ret, idx;
 
@@ -1856,8 +1856,6 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	if (KVM_BUG_ON(ipa == INVALID_GPA, vcpu->kvm))
 		return -EFAULT;
 
-	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
-
 	if (esr_fsc_is_translation_fault(esr)) {
 		/* Beyond sanitised PARange (which is the IPA limit) */
 		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
@@ -1869,7 +1867,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		if (fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
 			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
 
-			return kvm_inject_sea(vcpu, is_iabt, fault_ipa);
+			return kvm_inject_sea(vcpu, kvm_vcpu_trap_is_iabt(vcpu),
+					      fault_ipa);
 		}
 	}
 
@@ -1931,7 +1930,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		 * anything about this (there's no syndrome for a start), so
 		 * re-inject the abort back into the guest.
 		 */
-		if (is_iabt) {
+		if (kvm_vcpu_trap_is_iabt(vcpu)) {
 			ret = -ENOEXEC;
 			goto out;
 		}
-- 
2.51.0.261.g7ce5a0a67e-goog

