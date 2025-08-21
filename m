Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEE328B7EF
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810048; cv=none; b=HpVpolZLAr1OUw4UUbeA+5mJAoxjpmvImUnZQVxZJRJ3nBW8bGlNITom6SjDW/lpU3uveNCGp5AyOiY9vORxRwx/QY6oQmGT0AR5BiI8bpKjjD2RPfAI27Un+Ucuq6gZSymTWzRFQJWSNEtPmgRGyXlT6cWRkpBrwm5yPpl6/9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810048; c=relaxed/simple;
	bh=pnhR4u7zzImF/Q9sjPpvcLTIm1nBKcxgPPtEJd8L7Pw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=t8iBK9F2C1GIcLTIspJspOvfaSCPKpgzVnOF7b+z6mEzXyWcguPGiTv/dN6UVrMoAG6keua4gOxYTrATVRsxvQV1phSFs/1sgSeRW1g4XAhqIBTT+OzlCverIPAqgRAbLAyIiVKvEguERyRIqF4rWxOWRYvuiFZNVPV1cPhlQJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XborZPIR; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XborZPIR"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24457f42254so31753915ad.0
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810046; x=1756414846; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QRu9EPlqPIRbrAwuhln90egPhix9C1W7TbuFz42eH5A=;
        b=XborZPIRcu3SIKCdCuup5CgcluwfbbgDRqlS9d3yLFveO6Eiu9+ni95qk7TmlO//us
         Lw21+HpJqwXra+UdjUOijN6Zo9X5z9EZGLdd5uLbN4DvYtgnFQqYmVnl+iXz/V+gmMK2
         lVDAmbid86iB3JxNF6M7aM9mVzb6URTYZedzYb6Y2ZkylLL0f0zEQsOntoKGcOgvKVzG
         fjzDChLtID2Sq7gnYRL4oEv9sfwvhqrY9FByP9I0antveu69Lav7kFRwSc3rn+cLnpRL
         EPves6hOIJArVpvuN4S6jjlA1e4J4TQZgoGEzj6YeXJ2a3qeSCgCkgymaaFL7E6sd6QJ
         pc1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810046; x=1756414846;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QRu9EPlqPIRbrAwuhln90egPhix9C1W7TbuFz42eH5A=;
        b=k+ZjPMMNzFtK01Ilj4fLMnVqhnM/Af1e7BYOlooHMzURU4ht+mEYKfZKMyxhYOCCrU
         V5vb4glq8WVYwYWZw3gIRgjAaCMQ6nZzViId+tOM5ZWoQgRy0tse3OFtMqMwpKqWMFPs
         cjEspxA3ueTNOAaJmITuULRStmTam4DzfJVcO06s925QmiPuvRo46wt42itCkxbF4oRc
         /hRNfyVKk92qJApbqXHqDognqL3Rr8+a/PmwBLt6cjzi/YWrztf23+4u1/7e5n1JNo84
         QjFoaPP31Y1WP/H5dFuCG4hws0bOMM98v+T10P7tZVMlXNYV2g3qvYCiMEV7e+S2dNSA
         vT4Q==
X-Forwarded-Encrypted: i=1; AJvYcCV0R5A1bEaf237YF83FOdWVkk8b2bS6fJatS4Y90p0l6VQPpPdXQnCrYL3MKBTVGaPCX1nJWzk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwN5p5zvLn6dMo8oZCPSs5v3zSfo62j3S9D0jMOTRgEgkJRUFYS
	0Mo4LWM4tW8RjQsVQMficvGTY6rAWSI8Uea9bOoY+z00sovbCzLopF2bY7XnSQfSTS4g7j19ejq
	GZlwveA==
X-Google-Smtp-Source: AGHT+IHZUS2rRBwXbx5vsu0uArLnBj6wHgoX5fZrabl/HszonPOiLFCujnncNL374CLOxHiZbqaT370jPEA=
X-Received: from pjm15.prod.google.com ([2002:a17:90b:2fcf:b0:31f:61fc:b283])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f552:b0:240:b075:577f
 with SMTP id d9443c01a7336-2462ef1d579mr9364185ad.37.1755810045874; Thu, 21
 Aug 2025 14:00:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:26 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-1-seanjc@google.com>
Subject: [RFC PATCH 00/16] KVM: arm64: Add "struct kvm_page_fault"
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Add an arm64 version of "struct kvm_page_fault" to (hopefully) tidy up
the abort path, and to pave the way for things like KVM Userfault[*] that
want to consume kvm_page_fault in arch-neutral code.

This is essentially one giant nop of code shuffling.

RFC as this is only compile-tested.  I didn't want to spend time testing
until I got feedback on whether or not y'all are amenable to the general idea.

[*] https://lore.kernel.org/all/20250618042424.330664-1-jthoughton@google.com

Sean Christopherson (16):
  KVM: arm64: Drop nested "esr" to eliminate variable shadowing
  KVM: arm64: Get iabt status on-demand
  KVM: arm64: Move SRCU-protected region of kvm_handle_guest_abort() to
    helper
  KVM: arm64: Use guard(srcu) in kvm_handle_guest_abort()
  KVM: arm64: Introduce "struct kvm_page_fault" for tracking abort state
  KVM: arm64: Pass kvm_page_fault pointer to
    transparent_hugepage_adjust()
  KVM: arm64: Pass @fault to fault_supports_stage2_huge_mapping()
  KVM: arm64: Add helper to get permission fault granule from ESR
  KVM: arm64: Track perm fault granule in "struct kvm_page_fault"
  KVM: arm64: Drop local vfio_allow_any_uc, use vm_flags snapshot
  KVM: arm64: Drop local mte_allowed, use vm_flags snapshot
  KVM: arm64: Move VMA-related information into "struct kvm_page_fault"
  KVM: arm64: Stash "mmu_seq" in "struct kvm_page_fault"
  KVM: arm64: Track "forced" information in "struct kvm_page_fault"
  KVM: arm64: Extract mmap_lock-protected code to helper for user mem
    aborts
  KVM: arm64: Don't bother nullifying "vma" in mem abort path

 arch/arm64/include/asm/esr.h         |   6 +
 arch/arm64/include/asm/kvm_emulate.h |   9 -
 arch/arm64/include/asm/kvm_host.h    |  32 ++
 arch/arm64/kvm/mmu.c                 | 514 +++++++++++++--------------
 4 files changed, 282 insertions(+), 279 deletions(-)


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.51.0.261.g7ce5a0a67e-goog

