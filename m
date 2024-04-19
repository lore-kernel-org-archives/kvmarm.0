Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277AF3A1A8
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 07:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513586; cv=none; b=bdT1fBejI0kgE7vVd2NvoWhxqxxV9Gprd05JHgOnWDJL5tjiDySCJgOJjXmkUJeiiyOQsPC4LogRAN1rb8/ir1E0zXc1ZcDOuzS89AvdU9lBXFe+FKB2TIZVRzxyEwZoHVsvlkPR6CsxPavnwABMUYVGPUVcDHhaLmXy84hqSCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513586; c=relaxed/simple;
	bh=RnxT4rY9380nW8wX0fMsuPojbc5+mQ/KA+5JJ1tkf74=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GTiEwZKspHgUlfxXfZF5h7o4tTMu+rxKJgcPNqI2LTdpzO+nFyxLzp+RCQlzg5OB3+KexbXtKGLBSW0YQKtOgMq6lqjADPd2fBJ4HI4YhXkxealo+pz0Zy5cikqkjK9F0U15vS4n07QL0LpMIwE3qxPQnzeuL3AJlnJIweEyMIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QhKPWruh; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QhKPWruh"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-41485831b2dso14454155e9.3
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 00:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513583; x=1714118383; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XhVlgz97x7EXcRAgwStBgqwbDzWPrijiXPciJ0WWtZE=;
        b=QhKPWruhERdEtUJ5tmPB2TQIsgGVoATXPhv/ItNQT+0PD5CPa2n8MbUTKThimZvkgz
         1z3Gv0ixUlP4EtbOcA+JtUkuqSXxxrtckfJy2nHAZ8aztXCxvm5neiHVoOX3kYEuljy2
         pPeEhU+nNUlmM1o1LsOiHBuQGa6ez0zdz65zRwUwF+jp/azy+aqY02LKwzQ5Ytd0FBCF
         wnPPMRh9G3rboew5Q4bpxdrj04E57xxnL7HMIi2RMO32/RPOnvTwzAAWXmg3v1agGBOH
         RN4mJ3iLhJfZyNvhI0kbfG27auqkAQk3fO4X/cmLIjBigo0DBNdmGDkVjR+YKlv4DjbC
         TOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513583; x=1714118383;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XhVlgz97x7EXcRAgwStBgqwbDzWPrijiXPciJ0WWtZE=;
        b=vfetEosPxw4bT2dcCcdQDkhXBWs42xw0dX8AalClCP+lwu+3wjtNXqvg509PDCIGbd
         l7PyZkhJFCHWYGGcbO5uhDsVjKe/jiya24B0BmIGlZNFmfGwUYJkt4gb96vnzAdq+pHk
         Fbb0oylEw9WFX6/6vcSF2lbTyWA2PRxR01rOnXBCXl5ZileLrC5GzqUzBg9y8xkxCYtr
         IYpOYNM7RPd3kkWw5Ye1+5MtolegIbpBB8yaLu/oM3/wQOp4Ub2akp9OwayuAGI09D7/
         jymb9Lp+/mZ9id3SoBBT2QEBGDrAQ9fmTJ2OfxUb3RaPmz+SQ15coGJSYwJkzf3QpyM9
         Oz/w==
X-Gm-Message-State: AOJu0Yx5OxMwEFEGxfWSTNAuqT7RPnedi97bzSQrOewjBxIOJO06myAU
	otay1gmrhCt+SrM53NcJIp3doU3IdI73zqlmTo+k9KHwMLE8M0ku40XcvBZQfWRIiY9NVT13uz1
	BedkqAPrzJw8hKtx1MIzn337LfKIkyAp+eNjSfHWtx86VvCAMpnb7ycE4+AzcCe6ie9d40sys4M
	IcyFHfGnmWdFUM0ID3/dt/fC4aMUw=
X-Google-Smtp-Source: AGHT+IEBwwUM9jUtS1Svnv2FRxe4/AUuseXY9ym8kWnQJscnQ2zG1A2qw0KAo2tIw2BcLrYCQDPwKPjziA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:35d5:b0:418:d3f4:681c with SMTP id
 r21-20020a05600c35d500b00418d3f4681cmr7685wmq.6.1713513583308; Fri, 19 Apr
 2024 00:59:43 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:10 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-1-tabba@google.com>
Subject: [PATCH v3 00/31] KVM: arm64: Preamble for pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Changes from V2 [0]:
- Dropped patches that are better suited for later on with pKVM [Marc]
- Squashed some patches together to make it easier for maintainers [Marc]
- Moved all fixes to the beginning of the series [patches 1 - 13]
- Misc fixes [Mark, Marc, Oliver]

We are getting closer to upstreaming the remaining part of pKVM
[1]. To make the process easier for us and for our dear
reviewers, we are sending out this patch series as a preamble to
the upcoming patches.

This series is based on Linux 6.9-rc3 -- kvmarm/next
(9ac5bab4deee). Most of the patches in this series are
self-standing, and can be applied directly.

This series is a bit of a bombay-mix of patches we've been
carrying. There's no one overarching theme, but they do improve
the code by fixing existing bugs in pKVM, refactoring code to
make it more readable and easier to re-use for pKVM, or adding
functionality to the existing pKVM code upstream.

None of the patches in this series intentionally affect the
functionality of non-protected modes. Patches 1 to 13 are fixes.

For a technical deep dive into pKVM, please refer to Quentin
Perret's KVM Forum Presentation [2, 3]. The pKVM core series,
which we plan on sending for review next, the code is here [1].

Cheers,
Fuad, Quentin, Will, and Marc

[0] https://lore.kernel.org/all/20240416095638.3620345-1-tabba@google.com/

[1] https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstream/pkvm-core

[2] Protected KVM on arm64 (slides)
https://static.sched.com/hosted_files/kvmforum2022/88/KVM%20forum%202022%20-%20pKVM%20deep%20dive.pdf

[3] Protected KVM on arm64 (video)
https://www.youtube.com/watch?v=9npebeVFbFw

Fuad Tabba (15):
  KVM: arm64: Initialize the kvm host data's fpsimd_state pointer in
    pKVM
  KVM: arm64: Move guest_owns_fp_regs() to increase its scope
  KVM: arm64: Refactor checks for FP state ownership
  KVM: arm64: Do not re-initialize the KVM lock
  KVM: arm64: Do not map the host fpsimd state to hyp in pKVM
  KVM: arm64: Fix comment for __pkvm_vcpu_init_traps()
  KVM: arm64: Change kvm_handle_mmio_return() return polarity
  KVM: arm64: Move setting the page as dirty out of the critical section
  KVM: arm64: Introduce and use predicates that check for protected VMs
  KVM: arm64: Move pstate reset value definitions to kvm_arm.h
  KVM: arm64: Clarify rationale for ZCR_EL1 value restored on guest exit
  KVM: arm64: Refactor calculating SVE state size to use helpers
  KVM: arm64: Move some kvm_psci functions to a shared header
  KVM: arm64: Refactor reset_mpidr() to extract its computation
  KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for hyp use

Marc Zyngier (3):
  KVM: arm64: Check for PTE validity when checking for
    executable/cacheable
  KVM: arm64: Simplify vgic-v3 hypercalls
  KVM: arm64: Force injection of a data abort on NISV MMIO exit

Quentin Perret (4):
  KVM: arm64: Issue CMOs when tearing down guest s2 pages
  KVM: arm64: Avoid BUG-ing from the host abort path
  KVM: arm64: Prevent kmemleak from accessing .hyp.data
  KVM: arm64: Add is_pkvm_initialized() helper

Will Deacon (9):
  KVM: arm64: Avoid BBM when changing only s/w bits in Stage-2 PTE
  KVM: arm64: Support TLB invalidation in guest context
  KVM: arm64: Remove locking from EL2 allocation fast-paths
  KVM: arm64: Introduce hyp_rwlock_t
  KVM: arm64: Add atomics-based checking refcount implementation at EL2
  KVM: arm64: Use atomic refcount helpers for 'struct
    hyp_page::refcount'
  KVM: arm64: Reformat/beautify PTP hypercall documentation
  KVM: arm64: Rename firmware pseudo-register documentation file
  KVM: arm64: Document the KVM/arm64-specific calls in hypercalls.rst

 Documentation/virt/kvm/api.rst                |   7 +
 .../virt/kvm/arm/fw-pseudo-registers.rst      | 138 ++++++++++++++
 Documentation/virt/kvm/arm/hypercalls.rst     | 180 +++++-------------
 Documentation/virt/kvm/arm/index.rst          |   1 +
 Documentation/virt/kvm/arm/ptp_kvm.rst        |  38 ++--
 arch/arm64/include/asm/kvm_arm.h              |  12 ++
 arch/arm64/include/asm/kvm_asm.h              |   8 +-
 arch/arm64/include/asm/kvm_emulate.h          |  11 +-
 arch/arm64/include/asm/kvm_host.h             |  39 ++--
 arch/arm64/include/asm/kvm_hyp.h              |   4 +-
 arch/arm64/include/asm/virt.h                 |  12 +-
 arch/arm64/kvm/arm.c                          |  21 +-
 arch/arm64/kvm/fpsimd.c                       |  60 +++---
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   8 +-
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |   6 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  18 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   6 +
 arch/arm64/kvm/hyp/include/nvhe/refcount.h    |  76 ++++++++
 arch/arm64/kvm/hyp/include/nvhe/rwlock.h      | 129 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  24 +--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  10 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  21 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  14 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |   1 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |  10 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 | 115 ++++++++---
 arch/arm64/kvm/hyp/pgtable.c                  |  21 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |  27 ++-
 arch/arm64/kvm/hyp/vhe/switch.c               |   4 +-
 arch/arm64/kvm/mmio.c                         |  12 +-
 arch/arm64/kvm/mmu.c                          |   8 +-
 arch/arm64/kvm/pkvm.c                         |   2 +-
 arch/arm64/kvm/psci.c                         |  28 ---
 arch/arm64/kvm/reset.c                        |  20 +-
 arch/arm64/kvm/sys_regs.c                     |  14 +-
 arch/arm64/kvm/sys_regs.h                     |  19 ++
 arch/arm64/kvm/vgic/vgic-v2.c                 |   9 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |  23 +--
 arch/arm64/kvm/vgic/vgic.c                    |  11 --
 arch/arm64/kvm/vgic/vgic.h                    |   2 -
 include/kvm/arm_psci.h                        |  29 +++
 include/kvm/arm_vgic.h                        |   1 -
 42 files changed, 775 insertions(+), 424 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/fw-pseudo-registers.rst
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/refcount.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/rwlock.h


base-commit: 9ac5bab4deeeeb99f36695250b99c2f9bfae2379
-- 
2.44.0.769.g3c40516874-goog

