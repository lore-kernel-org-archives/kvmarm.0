Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD342CA4E
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727130; cv=none; b=AeCOEktLngBdbsttBjmGbloQM+iPm74/7Jl99zaqBX9noY774hJaLkLNZKnzA51sp3i333dsQhfFCufZHPPURCDHDXlHUHz7xLo5LkfRQUKK5lZgu31IZWF2N3gHUkTbo0XAgeu6H8lBIgXrO7NHy7Sy3r1qjPthqnLS+n9rRsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727130; c=relaxed/simple;
	bh=IGlHn80NNycrJBp1h8iQimbPVq54EMSfdblL7J6SlZE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MQka7kJvSd0wVIS1Fb2cUe9CGcsr9pq6vVi+pbPgVDPwsfmWyGfaSKU+xJNFFmxdJhYYKsUxxaLY5wBAIJkx7KBC2M88KG+QwZT/vTwfYUByGB9U+fp6vqOUeIhygDus/4UnQaI9YTshBvL+Oxh1plXlsAhtA3/rE4FdQlLHKj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oQIs+xbi; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oQIs+xbi"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ea86f1df79so29573067b3.1
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730727128; x=1731331928; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HxxA8qOKzLiUY9hT0OrM+BS/2F7uNJDid+1gg9MXvMQ=;
        b=oQIs+xbi3fvH5hV9N1Udo3xX10d2WsqyVmOs60hz5rmjMR0M1GSK6VxYae1suNWIC1
         Ln1Cam64V5WI4DljAAP41mkXvnhP86eRVNnDmCjMU4MbAd+tMDj1iiF09QcZGrmHmpu4
         uwMF+/FT/JL+l2dgQv1lMyoJ2El54ic5+AYo1yTKiNU/th5HQ42FsVZvYw0HOEBu2ze4
         aqhrzY6KJH8m/wStQX+q+2AueFwULkr5YKj4LVVF+UiPvlKPen4SU76QGPGv1g1V9IcD
         gi/Sm+2OJfharJA/6IIAgyzlrxvMMubwUPDoYv0bTdEzkpz6gAPGb60MWkO4LFulwqlV
         bTKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727128; x=1731331928;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HxxA8qOKzLiUY9hT0OrM+BS/2F7uNJDid+1gg9MXvMQ=;
        b=cS/omrftVlunLxPBBvapXhiTaN6M2CfTEZDDQ4xrf7sjXAvMTuq7U2jODd0NDtJu4u
         bqz1Psj7gEmxkHHquPhCDi4Vnp4J8uQDPApVXJJIfV+GgHIhCrmQwDaT7QUhWeB3R6SE
         2dxNQMEVC8h3zXR6lNNeihUX6wMT08toI0ajh8YE0dkQ52ei029/8H1ef6cXOLHxbrlx
         XXX/cc2ZnYesYlBe5Cp7kiVLifWDXHRJQJMWNN9NyPFUENR8+y7zz5D1hsLC1kFv+6as
         YXE1S1UjHkmzEoCJW2WVK7BfEvkBCmbh6q7K7YSaNNezcFxIeFfjFKmglhvJmq/Ah8Lp
         C6tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQmFx82NrvKiOjWZq6jdIYOm93z3N0YiXjUzw4eDi3autIZbcJlzRapt2aVt8GTQChODfSRrk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzb2PFKQUHlg/xJ/IABEdJ/2jCBDHZvjXj85hHdhAFo5jnKUoN6
	+X+zO6fuGaRKUpNT9CAaHKESZSy4qBD5lONc2L7m7FJyDeUIhYksVjj2Tj7PTmYdHvKVHTD+18i
	TLMC0wg==
X-Google-Smtp-Source: AGHT+IEVbGHAWJltvuCaJ/azx5l/1Epto/a62kcYMbtely3oTwYCl8xO82ZRv+bF0K6w89ccEMj5+aQu0mFT
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a81:a8c3:0:b0:6e3:d670:f603 with SMTP id
 00721157ae682-6e9d8aada53mr4236877b3.3.1730727127723; Mon, 04 Nov 2024
 05:32:07 -0800 (PST)
Date: Mon,  4 Nov 2024 13:31:46 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241104133204.85208-1-qperret@google.com>
Subject: [PATCH 00/18] KVM: arm64: Non-protected guest stage-2 support for pKVM
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

This series moves the stage-2 page-table management of non-protected
guests to EL2 when pKVM is enabled. This is only intended as an
incremental step towards a 'feature-complete' pKVM, there is however a
lot more that needs to come on top.

With that series applied, pKVM provides near-parity with standard KVM
from a functional perspective all while Linux no longer touches the
stage-2 page-tables itself at EL1. The majority of mm-related KVM
features work out of the box, including MMU notifiers, dirty logging,
RO memslots and things of that nature. There are however two gotchas:

 - We don't support mapping devices into guests: this requires
   additional hypervisor support for tracking the 'state' of devices,
   which will come in a later series. No device assignment until then.

 - Stage-2 mappings are forced to page-granularity even when backed by a
   huge page for the sake of simplicity of this series. I'm only aiming
   at functional parity-ish (from userspace's PoV) for now, support for
   HP can be added on top later as a perf improvement.

Please note that the approach taken in this series is a departure from
the existing out-of-tree implementation in Android which relies on
long-term GUP pinning even for non-protected guests which I felt was a
non-starter for upstream. Android will obviously migrate to the
upstream implementation when that lands.

The last two patches are likely to be the most 'controversial' ones as
they do the integration into KVM (please see the notes in the commit
messages), but obviously feedback is more than welcome throughout. The
overall idea is to use the KVM/arm pgtable API as the 'contract' between
the standard KVM and pKVM backend implementations. With pKVM we use
wrappers at EL1 with the exact same prototype as the kvm_pgtable_stage2_*()
functions that end up simply doing hypercalls as that allows easy-ish
plumbing in kvm/mmu.c. The pKVM EL1 helpers use a simple RB-tree to
maintain the GFN->PFN mappings as we need to be able to walk those from
EL1. For the record, I have tried a few other data-structures. A maple
tree doesn't lend itself very well to the use-case as we need to
pre-allocate the node from outside the mmu_lock critical section. I also
considered using a 'dummy' s2 page-table at EL1 purely for tracking
purposes, and hook deep into pgtable.c to issue hypercalls to notify
pKVM directly from there. That has very nice properties, but gets
horrible as we try to elide the TLB invalidation / CMOs logic from the
dummy page-table.

The series is organized as follows:

 - Patches 01 to 04 move the host ownership state tracking from the
   host's stage-2 page-table to the hypervisor's vmemmap. This avoids
   fragmenting the host stage-2 for shared pages, which is only needed
   to store an annotation in the SW bits of the corresponding PTE. All
   pages mapped into non-protected guests are shared from pKVM's PoV,
   so the cost of stage-2 fragmentation will increase massively as we
   start tracking that at EL2. Note that these patches also help with
   the existing sharing for e.g. FF-A, so they could possibly be merged
   separately from the rest of the series.

 - Patches 05 to 07 implement a minor refactoring of the pgtable code to
   ease the integration of the pKVM MMU later on.

 - Patches 08 to 16 introduce all the infrastructure needed on the pKVM
   side for handling guest stage-2 page-tables at EL2.

 - Patches 17 and 18 plumb the newly introduced pKVM support into
   KVM/arm64.

Patches based on 6.12-rc5, tested on Pixel 6 and Qemu.

Thanks!
Quentin

Marc Zyngier (1):
  KVM: arm64: Introduce pkvm_vcpu_{load,put}()

Quentin Perret (17):
  KVM: arm64: Change the layout of enum pkvm_page_state
  KVM: arm64: Move enum pkvm_page_state to memory.h
  KVM: arm64: Make hyp_page::order a u8
  KVM: arm64: Move host page ownership tracking to the hyp vmemmap
  KVM: arm64: Pass walk flags to kvm_pgtable_stage2_mkyoung
  KVM: arm64: Pass walk flags to kvm_pgtable_stage2_relax_perms
  KVM: arm64: Make kvm_pgtable_stage2_init() a static inline function
  KVM: arm64: Introduce {get,put}_pkvm_hyp_vm() helpers
  KVM: arm64: Introduce __pkvm_host_share_guest()
  KVM: arm64: Introduce __pkvm_host_unshare_guest()
  KVM: arm64: Introduce __pkvm_host_relax_guest_perms()
  KVM: arm64: Introduce __pkvm_host_wrprotect_guest()
  KVM: arm64: Introduce __pkvm_host_test_clear_young_guest()
  KVM: arm64: Introduce __pkvm_host_mkyoung_guest()
  KVM: arm64: Introduce __pkvm_tlb_flush_vmid()
  KVM: arm64: Introduce the EL1 pKVM MMU
  KVM: arm64: Plumb the pKVM MMU in KVM

 arch/arm64/include/asm/kvm_asm.h              |   9 +
 arch/arm64/include/asm/kvm_host.h             |   4 +
 arch/arm64/include/asm/kvm_pgtable.h          |  42 ++-
 arch/arm64/include/asm/kvm_pkvm.h             |  28 ++
 arch/arm64/kvm/arm.c                          |  23 +-
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |   6 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  38 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  43 ++-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  15 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 210 ++++++++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 333 ++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  14 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  55 +++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   7 +-
 arch/arm64/kvm/hyp/pgtable.c                  |  13 +-
 arch/arm64/kvm/mmu.c                          | 110 ++++--
 arch/arm64/kvm/pkvm.c                         | 194 ++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c                 |   6 +-
 18 files changed, 1007 insertions(+), 143 deletions(-)

-- 
2.47.0.163.g1226f6d8fa-goog

