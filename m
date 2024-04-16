Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50FE8613E
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261403; cv=none; b=raZKJrjqhBu4N2UwYXehHUjCE5axUwXKjTD6w2icZePcaN71EvtcAVBk0Owy6LlZ7eTIxqPOYTc1HOQaKezWBWZDCcxZdlPcsZlWAKLLU7mSba0u0JOUcXkbyfKV4EibyHduRSoxrLCL73iEaVeL1yNTb98/6hlZqS/744FaO14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261403; c=relaxed/simple;
	bh=eFXfq3ZDrs2R5WnHo65K8U+yRfKeDS/wI5EmfUbm+Ho=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GhT+Ik/5v72Cuy2TJ+NkNJ8//va0qRCY/6wTIH2u4GSfZEvi5Dp6jZ275xL/GWFvADIyOdF58iSQPcjIVkfNJnx+XH3mFOrpwRYfwmC/EmMnNvH3+M3/pBnln9EdtwGnCHG0UIaBLJ+v1O24SoHG0DUDLf+VmR9bzxKmqKT6JmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B6f/hes6; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B6f/hes6"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-619151db81cso33331147b3.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261401; x=1713866201; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aVxp8EGgDzLEqF671AGQ9H4UGhsd34TPhxWrWVt5Rgk=;
        b=B6f/hes6g0tgAEGW6xmtJnxzrbK8xAsTXpvGCPJZNfRH+P6KqXeq+/T/1o/4v4Dww6
         3elC9czF2y4vzlprByeJFd4ZFEcHsbyhawlMrXM+Ko2alViHCCa2MKBC+O2BTbQiJe2L
         VFgpHe8Jj0T2xl0Ign2qPMxwmOznoS6qNF1GW4dGGu1X38mKgyjqedILPuVZ4LOi3ytD
         qCbjDosjvdZXC0Qcyr2S+1ZcuH8wkMG+Q6g0SDa9O0TaBPV6LOwXVFx77Yp6GDEwWGzo
         UBzm1MGoXqQuXeBg4CMcwaPGkaSauSQAEDA/jZdTwB3+LmdCP39L7RYxb7tZx1/d/FmA
         kX+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261401; x=1713866201;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aVxp8EGgDzLEqF671AGQ9H4UGhsd34TPhxWrWVt5Rgk=;
        b=IVo0TgoLNYI/QlIw3rjZQ0UJmg4o/qjWOVcjl09rFJ3pP7uMQzvLUjByBAwBVfjPr3
         Y3iJzUJXEi0VJP8f3ssdtA8GvE1agyEEFaeUc2U6nO9KXd7pZyUkY4ch1+N1U8qmtcQy
         MZ1EN+gNJ5Ci9aj7QzUyZrE3vXz0ef7ASFm7nFv1ij1SdcMO3L9pPJ+bxCFAeHesFFMM
         8+NQmTqMUr8Bx/puAWKtN43i49JvPRDgOcKaLkYCFlbLmeCzAXfmGbeKeNVt1Qo1WqkV
         o72UbTcGqz9Wab+HepiW1CwrW/xSPJEYQZGNvoa0abtJgEOhBdGbK2jfAWMYT0Rys5vz
         9Blg==
X-Gm-Message-State: AOJu0YwraE3RGONpvFfhtM7m/qcrkuXu0KfM19k/l3q4g4NyDAF8Fve6
	cXAO+agaiaH/LTOEI1aMSDT2yHECUFnsBhpXBys961yHaVub6EA14dppJ2BQgAkAqvvcvz6M/7G
	eYt1ud2CeL901gTCp3cs4YQZzgG3UzeqOu1U56u8PXFhNn5bPZFCCi1kYnz7+PjIvSE4cL5nrtB
	CBx7Wgix1X/9Ixcn7BBtQrgGOL308=
X-Google-Smtp-Source: AGHT+IG7q6Ht7Bw9TMkWZr/4Eh9AkZhZ2BJsb+d88XpaBLV4wv7JcvZwZmMBBftpUz2hEez1PJXzhNkx/g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:100d:b0:dbd:ee44:8908 with SMTP id
 w13-20020a056902100d00b00dbdee448908mr743945ybt.0.1713261400742; Tue, 16 Apr
 2024 02:56:40 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:55:51 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-1-tabba@google.com>
Subject: [PATCH v2 00/47] KVM: arm64: Preamble for pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Changes from V1:
- Rebased on Linux 6.9-rc3 -- kvmarm/next (9ac5bab4deee) [Marc]
- Fixed comments and tidied up [Marc, Mark]
- Moved fixes to beginning of series (patches 1-5) [Marc]
- Added a patch (patch 1) that allocates memory for fpsimd state
in protected mode, needed after the host state changes
- Added patches that refactor code for checking fpsimd state
ownership [Marc]
- Dropped patches that don't fit in this series [Marc, Mark]
- Fix build issue in "KVM: arm64: Add atomics-based checking
refcount implementation at EL2" (Mostafa)

We are getting closer to upstreaming the remaining part of pKVM
code [1]. To make the process easier for us and for our dear
reviewers, we are sending out this patch series as a preamble to
the upcoming patches.

This series is based on Linux 6.9-rc3 -- kvmarm/next
(9ac5bab4deee). Most of the patches in this series are
self-standing, without dependencies on other patches within the
same series, and can be applied directly.

This series is a bit of a bombay-mix of patches we've been
carrying. There's no one overarching theme, but they do improve
the code by fixing existing bugs in pKVM, refactoring code to
make it more readable and easier to re-use for pKVM, or adding
functionality to the existing pKVM code upstream.

None of the patches in this series intentionally affect the
functionality of non-protected modes. Patches 1 to 5 are bug and
comment fixes.

For a technical deep dive into pKVM, please refer to Quentin
Perret's KVM Forum Presentation [2, 3]. The pKVM core series,
which we plan on sending for review next, the code is here [1].

Cheers,
Fuad, Quentin, Will, and Marc

[1] https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstream/pkvm-core

[2] Protected KVM on arm64 (slides)
https://static.sched.com/hosted_files/kvmforum2022/88/KVM%20forum%202022%20-%20pKVM%20deep%20dive.pdf

[3] Protected KVM on arm64 (video)
https://www.youtube.com/watch?v=9npebeVFbFw

Fuad Tabba (26):
  KVM: arm64: Allocate per-cpu memory for the host fpsimd state in pKVM
  KVM: arm64: Do not re-initialize the KVM lock
  KVM: arm64: Fix comment for __pkvm_vcpu_init_traps()
  KVM: arm64: Change kvm_handle_mmio_return() return polarity
  KVM: arm64: Move setting the page as dirty out of the critical section
  KVM: arm64: Split up nvhe/fixed_config.h
  KVM: arm64: Move pstate reset value definitions to kvm_arm.h
  KVM: arm64: Clarify rationale for ZCR_EL1 value restored on guest exit
  KVM: arm64: Refactor calculating SVE state size to use helpers
  KVM: arm64: Do not map the host fpsimd state to hyp in pKVM
  KVM: arm64: Move some kvm_psci functions to a shared header
  KVM: arm64: Refactor reset_mpidr() to extract its computation
  KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for hyp use
  KVM: arm64: Introduce gfn_to_memslot_prot()
  KVM: arm64: Do not use the hva in kvm_handle_guest_abort()
  KVM: arm64: Do not set the virtual timer offset for protected vCPUs
  KVM: arm64: Check directly whether a vcpu is protected
  KVM: arm64: Trap debug break and watch from guest
  KVM: arm64: Restrict protected VM capabilities
  KVM: arm64: Do not support MTE for protected VMs
  KVM: arm64: Move pkvm_vcpu_init_traps() to hyp vcpu init
  KVM: arm64: Fix initializing traps in protected mode
  KVM: arm64: Remove unused vcpu parameter from guest_owns_fp_regs()
  KVM: arm64: Move guest_owns_fp_regs() to enable use in KVM code
  KVM: arm64: Add host_owns_fp_regs()
  KVM: arm64: Refactor checks for FP state ownership

Marc Zyngier (6):
  KVM: arm64: Check for PTE validity when checking for
    executable/cacheable
  KVM: arm64: Simplify vgic-v3 hypercalls
  KVM: arm64: Introduce predicates to check for protected state
  KVM: arm64: Add PC_UPDATE_REQ flags covering all PC updates
  KVM: arm64: Add vcpu flag copy primitive
  KVM: arm64: Force injection of a data abort on NISV MMIO exit

Quentin Perret (5):
  KVM: arm64: Issue CMOs when tearing down guest s2 pages
  KVM: arm64: Avoid BUG-ing from the host abort path
  KVM: arm64: Add is_pkvm_initialized() helper
  KVM: arm64: Refactor enter_exception64()
  KVM: arm64: Prevent kmemleak from accessing .hyp.data

Will Deacon (10):
  KVM: arm64: Avoid BBM when changing only s/w bits in Stage-2 PTE
  KVM: arm64: Support TLB invalidation in guest context
  KVM: arm64: Introduce hyp_rwlock_t
  KVM: arm64: Add atomics-based checking refcount implementation at EL2
  KVM: arm64: Use atomic refcount helpers for 'struct
    hyp_page::refcount'
  KVM: arm64: Remove locking from EL2 allocation fast-paths
  KVM: arm64: Reformat/beautify PTP hypercall documentation
  KVM: arm64: Rename firmware pseudo-register documentation file
  KVM: arm64: Document the KVM/arm64-specific calls in hypercalls.rst
  KVM: arm64: Advertise GICv3 sysreg interface to protected guests

 Documentation/virt/kvm/api.rst                |   7 +
 .../virt/kvm/arm/fw-pseudo-registers.rst      | 138 +++++++++++
 Documentation/virt/kvm/arm/hypercalls.rst     | 180 ++++----------
 Documentation/virt/kvm/arm/index.rst          |   1 +
 Documentation/virt/kvm/arm/ptp_kvm.rst        |  38 +--
 arch/arm64/include/asm/kvm_arm.h              |  12 +
 arch/arm64/include/asm/kvm_asm.h              |   9 +-
 arch/arm64/include/asm/kvm_emulate.h          |  28 ++-
 arch/arm64/include/asm/kvm_host.h             |  42 +++-
 arch/arm64/include/asm/kvm_hyp.h              |   4 +-
 arch/arm64/include/asm/kvm_pkvm.h             | 234 ++++++++++++++++++
 arch/arm64/include/asm/virt.h                 |  12 +-
 arch/arm64/kvm/arch_timer.c                   |  20 +-
 arch/arm64/kvm/arm.c                          | 102 ++++++--
 arch/arm64/kvm/fpsimd.c                       |  59 +++--
 arch/arm64/kvm/hyp/exception.c                | 100 ++++----
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   8 +-
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 223 -----------------
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |   6 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  18 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  19 ++
 arch/arm64/kvm/hyp/include/nvhe/refcount.h    |  76 ++++++
 arch/arm64/kvm/hyp/include/nvhe/rwlock.h      | 129 ++++++++++
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  32 +--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  10 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  21 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  72 ++++--
 arch/arm64/kvm/hyp/nvhe/setup.c               |   2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              |  12 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  13 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 | 115 +++++++--
 arch/arm64/kvm/hyp/pgtable.c                  |  21 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |  27 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |   4 +-
 arch/arm64/kvm/mmio.c                         |  13 +-
 arch/arm64/kvm/mmu.c                          |  25 +-
 arch/arm64/kvm/pkvm.c                         |   2 +-
 arch/arm64/kvm/psci.c                         |  28 ---
 arch/arm64/kvm/reset.c                        |  20 +-
 arch/arm64/kvm/sys_regs.c                     |  14 +-
 arch/arm64/kvm/sys_regs.h                     |  19 ++
 arch/arm64/kvm/vgic/vgic-v2.c                 |   9 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |  23 +-
 arch/arm64/kvm/vgic/vgic.c                    |  11 -
 arch/arm64/kvm/vgic/vgic.h                    |   2 -
 include/kvm/arm_psci.h                        |  29 +++
 include/kvm/arm_vgic.h                        |   1 -
 include/linux/kvm_host.h                      |   1 +
 virt/kvm/kvm_main.c                           |  22 ++
 50 files changed, 1271 insertions(+), 744 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/fw-pseudo-registers.rst
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/refcount.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/rwlock.h


base-commit: 9ac5bab4deeeeb99f36695250b99c2f9bfae2379
-- 
2.44.0.683.g7961c838ac-goog

