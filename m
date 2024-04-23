Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BF513B7BD
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884747; cv=none; b=HIJTdQmWbnhkERvybjEhyKXhZA0Rrctj/7/Ino2xB8/SObTBKKNKHzJXQrXgqcyNTa8os25Hk+01nofx53uCuIpfTKiCrpc4j2NItP4ChPPrBGG5ouQjdcU4PsmDqSwb9G2d4jYs9LqYSrAhR6XBT6DIDnqhUlaDAZKyISeSUUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884747; c=relaxed/simple;
	bh=A4zJjTJZMdv/Bwa5Y7iVB+VJ3s2opTqOgeA+nH+Bgx0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=aJdCYuR5BL7McZpeb5SalfEVj12IewrAXzwcdL6C2v/u9X5XTEIwxB2Rij2z5n6il9cB9/EIFNBt6qACvCLlseRSaIlXqW70DgpvKrvO1rNhwOP/vKX+04u9N2dvtEMnXAreEOXaC1X7IrB3RaBLniN2gTLx2XPg91RwhvX9ltQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=emc7Phgx; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="emc7Phgx"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-343c7fa0dd5so3686256f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884741; x=1714489541; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jpVxpDzVPkd+ABoyHQLUke6orwAwqj6kvwbLcCeOspw=;
        b=emc7PhgxaekfYN0SFRCnUN8uAEzi++MhkmTF3t8CHX7RGGc2sr5QashttriaBLj+ds
         NzgLZb6q7jAppgbop3chakEC75CaXkZ7oIr+y0+L9l/YgSL7beBd0OV677cjXvLtZ26s
         VztJsSLCPDYA3adyIrgCnTdpui88BBxIVP7y+R69H9ZexpMK0yohkkek3rVxhfjVbOLb
         QciJG9i5c7K6pWhbMc/+LQwUEIiKqdr6DDANJ7Il463H8N2AVZ6pgd/8ruzo0IaqX41q
         LEV+ZEVXg7uU8xEU7pBeENQHmyBzxDwu7G5JqYPkyiG1a+S619jChwFbkKtjWng9MEjb
         jUug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884741; x=1714489541;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jpVxpDzVPkd+ABoyHQLUke6orwAwqj6kvwbLcCeOspw=;
        b=HyeJyiOsf1Yp5sy89DPTXg/lbbxYIRl7Ij8gAMO7QupoN70FTVWOHfTbFIPcCUVGta
         OCKX2Yla33EccCMA4idPenJ9xhqDX5iemrDeD4alYhubQf0J93zZ/1ISw9FMgVYyqhSU
         1miGkzxY2h7F3v59cJ4jD58OC6x4efyr6w6DEbyGjDIkFaQ6x23MRJ0wWttvFwlN2j47
         WfzIFeY3saLxCGE5ICkgMDOE4Yx1d7xtaWz649TrWZ5uYE79S1bNr4U0sFpoqjlsMql2
         6Lu0bE541SYBEVHKwk+EbpAuizQs9Y0B7GVm4LsJer3R1XB/p11x2BFlvsjmEZph18+N
         tREw==
X-Gm-Message-State: AOJu0YzVbp1WFjTaXrEeCN7rHmyfIEx8gpH9UGtQTw+XrH9QewVSPdFu
	omSOX7fkvf4v1oAyhC6ZLdA+JRc9t3TsoVrkV52aYCxZ5XXOJPZ+39FE1hg9QvXQJxIU8m1ctM6
	M1Ux3v4jKQYjuG5rAE0TNt/DzfuilOM8NoospP7e2gSea0Y3FfeLHT/VNOVUdXofmDQjk9l+ad9
	3qMIWargJyx2APbIhDZLMZ+VniXp8=
X-Google-Smtp-Source: AGHT+IEyaqU36nMf+qt7SkFXLh72jwd7qocyr1wUgbJ9nuaxNvU9yaGI4nctQCNZBdC6T5RsP2Srir2j8g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:e8c2:0:b0:349:7e66:99f with SMTP id
 k2-20020adfe8c2000000b003497e66099fmr32092wrn.13.1713884740724; Tue, 23 Apr
 2024 08:05:40 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-1-tabba@google.com>
Subject: [PATCH v4 00/30] KVM: arm64: Preamble for pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Changes from V3 [0]:
- Rebased on latest kvmarm/next (dcbf421a8c08)
- Dropped atomic and locking patches for now, while we rework them
- Misc fixes (Oliver)

We are getting closer to upstreaming the remaining part of pKVM
[1]. To make the process easier for us and for our dear
reviewers, we are sending out this patch series as a preamble to
the upcoming patches.

This series is based on Linux 6.9-rc3 -- kvmarm/next
(dcbf421a8c08). Most of the patches in this series are
self-standing, and can be applied directly. Patches 1 to 13 are
fixes.

This series is a bit of a bombay-mix of patches we've been
carrying. There's no one overarching theme, but they do improve
the code by fixing existing bugs in pKVM, refactoring code to
make it more readable and easier to re-use for pKVM, or adding
functionality to the existing pKVM code upstream.

For a technical deep dive into pKVM, please refer to Quentin
Perret's KVM Forum Presentation [2, 3]. The pKVM core series,
which we plan on sending for review next, the code is here [1].

Cheers,
Fuad, Quentin, Will, and Marc

[0] https://lore.kernel.org/all/20240419075941.4085061-1-tabba@google.com/

[1] https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstream/pkvm-core

[2] Protected KVM on arm64 (slides)
https://static.sched.com/hosted_files/kvmforum2022/88/KVM%20forum%202022%20-%20pKVM%20deep%20dive.pdf

[3] Protected KVM on arm64 (video)
https://www.youtube.com/watch?v=9npebeVFbFw

Fuad Tabba (18):
  KVM: arm64: Initialize the kvm host data's fpsimd_state pointer in
    pKVM
  KVM: arm64: Move guest_owns_fp_regs() to increase its scope
  KVM: arm64: Refactor checks for FP state ownership
  KVM: arm64: Do not re-initialize the KVM lock
  KVM: arm64: Rename __tlb_switch_to_{guest,host}() in VHE
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
  KVM: arm64: Refactor setting the return value in
    kvm_vm_ioctl_enable_cap()
  KVM: arm64: Restrict supported capabilities for protected VMs

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

Will Deacon (5):
  KVM: arm64: Avoid BBM when changing only s/w bits in Stage-2 PTE
  KVM: arm64: Support TLB invalidation in guest context
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
 arch/arm64/kvm/arm.c                          |  63 ++++--
 arch/arm64/kvm/fpsimd.c                       |  60 +++---
 arch/arm64/kvm/hyp/include/hyp/switch.h       |   8 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   6 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  24 +--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |   8 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  14 +-
 arch/arm64/kvm/hyp/nvhe/setup.c               |   1 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |  10 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 | 115 ++++++++---
 arch/arm64/kvm/hyp/pgtable.c                  |  21 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |  27 ++-
 arch/arm64/kvm/hyp/vhe/switch.c               |   4 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                  |  26 +--
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
 38 files changed, 597 insertions(+), 418 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/fw-pseudo-registers.rst


base-commit: dcbf421a8c082f52f3b8cc19cff736374df123d6
-- 
2.44.0.769.g3c40516874-goog

