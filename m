Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA81F4E2
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560936; cv=none; b=iA2B61uRXYUkXVksFu6jQNRHMj9bmId7UeBA6BUZVQiXvZq6ciE4sQY+aKBA3atRY3t9PBFv8WACYbEGGlGjpo4yHAUuX3zb6F84enUEB3jICuAW0d8iWpgLFcA7nUGiKSObvmUKibVFkgIW9WGLqWpwYFDTkvmw1NKwFXGPetY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560936; c=relaxed/simple;
	bh=RqvP+1ytUvlJi71QDQ6Oa2+cQ8R7A1ENXhqZadHUirA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Cv+KpWxtL06sUbbjdQ/5m2YeOtos3ZuMqrdEsdXFkTST8hTPoAcd1AmFbScL6R/XJaVNVAwD1qVqj3qqxhLcBLcgt7RAbQjpwYXSxCa9jrZ/15fDKaaWLk4353RyXLCaNC/mBUpdcs+JCyE7WmQn4GN/lw6Whz9DWzs56MnbTOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mpa9jNBt; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mpa9jNBt"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dd933a044baso1476288276.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560933; x=1712165733; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jaxAqyxXAh8ID5UelUYUnCUjHQRLwsmfdq9rZEZ+7v0=;
        b=mpa9jNBt2HCn7Vruq4WAwi3R2UiBO/pHNJW/kAKz+V+SeZLGjfXyj4MefDz/mkYEy3
         aAX6EYM7NAEtlfTCTlybwAAgEx4PCQKPr/4KfbVYZ/Nm/FtN8veiuxN2MjmTb/kq98jT
         b5f72Pw/6TeWfw57LukAUf5VNSRdmXCQEg0ktkLjtODtqNJDPawXpuscNIGZMoVs9KKF
         r7r1/Mph5F7YaKDZS5SC1V3CYh05N5aS0aCArBK3Gu4SnZUn3DfxQgw9hX7mfqgbebFg
         fLfHmWqsH2zRbRcE64mb97RIM6Jpzd69wTBi/RpbnYLya0PvfjNAxfRtwq5ES+62uIVa
         WI+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560933; x=1712165733;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jaxAqyxXAh8ID5UelUYUnCUjHQRLwsmfdq9rZEZ+7v0=;
        b=mxq4/pcSzOTIpFfSsCLTGYPZ51w+UJiQLmr0V+Mskkr20ympPODsDM75/ZhDuJCMkn
         TAl4AOLrY5lKHb8NgDABxaMyNIMLz6h/N3UDQ1iCFQBhqCiY1eOatcUWw9CfqUrVcLgS
         Ts1g9Bhznx0eUTPeEmSjLb+rx2rQfvAbVGJlD7j+DhL2gAidGj8YuJMK1AAfuDegh+vr
         jqmJuWCq5vN1TV3eE9cjZ0lj9qXiWAPd4go9uMGX22ZCy46+VM5ChaWRWR1OYQNmOn1A
         XkaiFBTP6gBF6Evggk055/E1/GSTEVHc0C0GZTpeYC5hCF2bwv6hMdHFCiBhWBs+ykc8
         I+LA==
X-Gm-Message-State: AOJu0Yx7by8Jfxv94wqh/8cQ4Bu9iWw5czsNd68Dh5K0Bh/reMnP+bxO
	eA1LPtHsAkfooArcTg4/dg5G5qhqWfDG7TuJjHI3nmDMTqDTXBUZ3iR1M/dlqdw9lxRijnLlBva
	gPRz9Npy4RW1ByqA2JLz1nX56n/KUH8C/b2Etqf6rR/ObbnL2zSfY2sghVSCclpHzpD5ya5Z3jj
	XOOEtcx4XmErPMFSuY3hJQhZJpI8g=
X-Google-Smtp-Source: AGHT+IHKrJFu2CI+nwUoz8vBnsjNjZxdWiJP27LBXp7WAOha+Zhzjb9tWYC3QltjHJVnXd2/mO/D4YuJ2g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:f06:b0:dcc:2267:796e with SMTP id
 et6-20020a0569020f0600b00dcc2267796emr43108ybb.2.1711560933588; Wed, 27 Mar
 2024 10:35:33 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:34:47 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-1-tabba@google.com>
Subject: [PATCH v1 00/44] KVM: arm64: Preamble for pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

We are getting closer to upstreaming the remaining part of pKVM
[1]. To make the process easier for us and for our dear
reviewers, we are sending this patch series as a preamble to the
upcoming patches.

This series is based on Linux 6.9-rc1. Most of the patches in
this series are self-standing, without dependencies on other
patches within the same series, and can be applied directly to
Linux 6.9-rc1.

This series is a bit of a bombay-mix of patches we've been
carrying. There's no one overarching theme, but they do improve
the code by fixing existing bugs in pKVM, refactoring code to
make it more readable and easier to re-use for pKVM, or adding
functionality to the existing pKVM code upstream.

For a technical deep dive into pKVM, please refer to Quentin
Perret's KVM Forum Presentation [2, 3]. For the pKVM core series,
which we plan on sending for review next, the code is here [1].

Cheers,
Fuad, Quentin, Will, and Marc

[1] https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstream/pkvm-core

[2] Protected KVM on arm64 (slides)
https://static.sched.com/hosted_files/kvmforum2022/88/KVM%20forum%202022%20-%20pKVM%20deep%20dive.pdf

[3] Protected KVM on arm64 (video)
https://www.youtube.com/watch?v=9npebeVFbFw

Fuad Tabba (23):
  KVM: arm64: Change kvm_handle_mmio_return() return polarity
  KVM: arm64: Use enum instead of helper for checking FP-state
  KVM: arm64: Move setting the page as dirty out of the critical section
  KVM: arm64: Split up nvhe/fixed_config.h
  KVM: arm64: Move pstate reset value definitions to kvm_arm.h
  KVM: arm64: Clarify rationale for ZCR_EL1 value restored on guest exit
  KVM: arm64: Refactor calculating SVE state size to use helpers
  KVM: arm64: Use active guest SVE vector length on guest restore
  KVM: arm64: Do not map the host fpsimd state to hyp in pKVM
  KVM: arm64: Move some kvm_psci functions to a shared header
  KVM: arm64: Refactor reset_mpidr() to extract its computation
  KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for hyp use
  KVM: arm64: Introduce gfn_to_memslot_prot()
  KVM: arm64: Do not use the hva in kvm_handle_guest_abort()
  KVM: arm64: Do not set the virtual timer offset for protected vCPUs
  KVM: arm64: Fix comment for __pkvm_vcpu_init_traps()
  KVM: arm64: Do not re-initialize the KVM lock
  KVM: arm64: Check directly whether a vcpu is protected
  KVM: arm64: Trap debug break and watch from guest
  KVM: arm64: Restrict protected VM capabilities
  KVM: arm64: Do not support MTE for protected VMs
  KVM: arm64: Move pkvm_vcpu_init_traps() to hyp vcpu init
  KVM: arm64: Fix initializing traps in protected mode

Marc Zyngier (6):
  KVM: arm64: Check for PTE validity when checking for
    executable/cacheable
  KVM: arm64: Simplify vgic-v3 hypercalls
  KVM: arm64: Introduce predicates to check for protected state
  KVM: arm64: Add PC_UPDATE_REQ flags covering all PC updates
  KVM: arm64: Add vcpu flag copy primitive
  KVM: arm64: Force injection of a data abort on NISV MMIO exit

Quentin Perret (5):
  KVM: arm64: Avoid BUG-ing from the host abort path
  KVM: arm64: Add is_pkvm_initialized() helper
  KVM: arm64: Refactor enter_exception64()
  KVM: arm64: Prevent kmemleak from accessing .hyp.data
  KVM: arm64: Issue CMOs when tearing down guest s2 pages

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
 arch/arm64/include/asm/kvm_emulate.h          |  10 +
 arch/arm64/include/asm/kvm_host.h             |  42 +++-
 arch/arm64/include/asm/kvm_hyp.h              |   4 +-
 arch/arm64/include/asm/kvm_pkvm.h             | 234 ++++++++++++++++++
 arch/arm64/include/asm/virt.h                 |  12 +-
 arch/arm64/kvm/arch_timer.c                   |  20 +-
 arch/arm64/kvm/arm.c                          | 102 ++++++--
 arch/arm64/kvm/fpsimd.c                       |  44 ++--
 arch/arm64/kvm/hyp/exception.c                | 100 ++++----
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  14 +-
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 223 -----------------
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |   6 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  18 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  18 ++
 arch/arm64/kvm/hyp/include/nvhe/refcount.h    |  72 ++++++
 arch/arm64/kvm/hyp/include/nvhe/rwlock.h      | 129 ++++++++++
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  32 +--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  12 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  21 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  54 ++--
 arch/arm64/kvm/hyp/nvhe/setup.c               |   1 -
 arch/arm64/kvm/hyp/nvhe/switch.c              |  10 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  13 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 | 114 +++++++--
 arch/arm64/kvm/hyp/pgtable.c                  |  21 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |  27 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |   2 +-
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
 50 files changed, 1225 insertions(+), 736 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/fw-pseudo-registers.rst
 delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/refcount.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/rwlock.h

-- 
2.44.0.478.gd926399ef9-goog

