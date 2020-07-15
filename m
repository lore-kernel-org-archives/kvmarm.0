Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617F3C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DABA220672
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:44:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="vgFH5wD3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DABA220672
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 467444B318;
	Wed, 15 Jul 2020 14:44:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o-WSL1P1L3XX; Wed, 15 Jul 2020 14:44:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EE794B380;
	Wed, 15 Jul 2020 14:44:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D192B4B377
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:44:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xdrq3h60+-3Z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:44:49 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DEEA4B318
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:44:49 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id b14so1973475wrp.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=5VqfDX7EzUW2FTETo5TiLPtjJXy+DqI+hvzlQyamGBY=;
 b=vgFH5wD3BodQM6preGyxeqON9LhZX2dmabOBCrhEuaovnBFi+4UFmKqTImpyybA4Fz
 vkgU77EffbGpu0uThPONGgKF8yFuZHVtrYkm2kXhVRjt7xxR10O5Vhxa9BIRCzWwKpbp
 HaIwKWBc+7kebEmMKqfNAqfEDNGCY/rnFiY7h9Su7FwrX6GrRDFf9DquQauKfkApK7oN
 91QY/LZfu+RuntnwKklF+8UYvzWhrTFgJj2+v3Rb7JynCT1aQM8pgb9qTo0fnDx8Q1C4
 gpivz4liUxdP8m1/k/8jTf8j0pfPuPTYYTt0fewh3LcdGbca2Dng56tAHJ7WhxrWm8fj
 xgfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=5VqfDX7EzUW2FTETo5TiLPtjJXy+DqI+hvzlQyamGBY=;
 b=l4EFjLHEwlzraZLs8SPa21BVNyois8I0b/WkA4RDK2bFHdar0a0v0+brjcUBf6y1hN
 BO1xZ3uyCOHeUJVswNJSdw02nZHEQtIVJrkdH/SygYPFk0E2w6QhVmQP/MZZ+ezi83+9
 G7MQ9Vu0w3RXNH3HGkrZZX20Delr3b01mmn34RVzOZKSo7HKP3VcVw/rYJoJlZ234S0s
 yNWT9vlMDjoQm0sCxL/CJJgdy43Km6TrRB+cA7l+HEW96AIVddrUicyytxSB0HDh7evM
 xEcHc5KOK4Xr79ilJmnJCL/0/ZscMCrJH3j1Dx0Agd7H29ZwXfj1P4uKvu5BydiqWPDZ
 7T2A==
X-Gm-Message-State: AOAM532nPqqAT+S1TU2y470KPBYdYP/VrStPXpKi7qFX8z44KwKXiNw+
 KJBIyYJ4qP36xSmpcrvsFRVb0w2bt30H/iHPfDEInzpn1zO4ZUK9D8yfz2kmY3Y0tDGcJFuq7sY
 F040dTVNSfMylJLGuB35u8ycmc40qRnJtM46ti/+pik1Frpy6V/51fC9uPOqBLLNdPSCPdw==
X-Google-Smtp-Source: ABdhPJyJQjTV6Qjoj7ynOjlFA5lrBh8Y7rLe3kkhVIBON5zACbPtDKAA2zGphBMLRnR9tCtNHn1n9kDSdN0=
X-Received: by 2002:a1c:cc09:: with SMTP id h9mr1314603wmb.1.1594838687796;
 Wed, 15 Jul 2020 11:44:47 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:01 +0100
Message-Id: <20200715184438.1390996-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 00/37] Transform the host into a vCPU
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

As part of the effort to isolate hyp from the host on nVHE, this series
provides hyp with its very own context and views the host as a vcpu from
the point of view of context switching.

The journey begins by preparing for hyp-init to instantiate a run loop
in hyp that `__guest_enter`s back into the host. The interfaces then
migrate to SMCCC rather than the raw function pointer intrface of today.

Next, the host state is fully migrated into its vcpu leaving a distinct
context for hyp and host. Finally, the save and restore paths of guests
and the host are unified such that __kvm_vcpu_run can switch to and run
any vcpu it is given.

It's a long series, but that seems to be the way Marc likes things
around here, hehe. I've tried to keep the patches simple where possible
but let me know if there's ever too much in one go and I'll try and help
you out.

This has been lightly tested on qemu with both VHE and nVHE booting VMs.
More rigorous testing will be needed.

The first patch is already in arm64/for-next/misc 7af928851508
The second patch can also be seen in <20200713210505.2959828-2-ascull@google.com>

Andrew Scull (37):
  smccc: Make constants available to assembly
  KVM: arm64: Move clearing of vcpu debug dirty bit
  KVM: arm64: Track running vCPU outside of the CPU context
  KVM: arm64: nVHE: Pass pointers consistently to hyp-init
  KVM: arm64: nVHE: Break out of the hyp-init idmap
  KVM: arm64: Only check pending interrupts if it would trap
  KVM: arm64: Separate SError detection from VAXorcism
  KVM: arm64: nVHE: Introduce a hyp run loop for the host
  smccc: Cast arguments to unsigned long
  KVM: arm64: nVHE: Migrate hyp interface to SMCCC
  KVM: arm64: nVHE: Migrate hyp-init to SMCCC
  KVM: arm64: nVHE: Fix pointers during SMCCC convertion
  KVM: arm64: Rename workaround 2 helpers
  KVM: arm64: nVHE: Use __kvm_vcpu_run for the host vcpu
  KVM: arm64: Share some context save and restore macros
  KVM: arm64: nVHE: Handle stub HVCs in the host loop
  KVM: arm64: nVHE: Store host sysregs in host vcpu
  KVM: arm64: nVHE: Access pmu_events directly in kvm_host_data
  KVM: arm64: nVHE: Drop host_ctxt argument for context switching
  KVM: arm64: nVHE: Use host vcpu context for host debug state
  KVM: arm64: Move host debug state from vcpu to percpu
  KVM: arm64: nVHE: Store host's mdcr_el2 and hcr_el2 in its vcpu
  KVM: arm64: Skip __hyp_panic and go direct to hyp_panic
  KVM: arm64: Break apart kvm_host_data
  KVM: arm64: nVHE: Unify sysreg state saving paths
  KVM: arm64: nVHE: Unify 32-bit sysreg saving paths
  KVM: arm64: nVHE: Unify vgic save and restore
  KVM: arm64: nVHE: Unify fpexc32 saving paths
  KVM: arm64: nVHE: Separate the save and restore of debug state
  KVM: arm64: nVHE: Remove MMU assumption in speculative AT workaround
  KVM: arm64: Move speculative AT ISBs into context
  KVM: arm64: nVHE: Unify sysreg state restoration paths
  KVM: arm64: Remove __activate_vm wrapper
  KVM: arm64: nVHE: Unify timer restore paths
  KVM: arm64: nVHE: Unify PMU event restoration paths
  KVM: arm64: nVHE: Unify GIC PMR restoration paths
  KVM: arm64: Separate save and restore of vcpu trap state

 arch/arm64/include/asm/kvm_asm.h           |  73 +++++-
 arch/arm64/include/asm/kvm_host.h          |  57 ++---
 arch/arm64/include/asm/kvm_hyp.h           |  33 ++-
 arch/arm64/include/asm/kvm_mmu.h           |   7 -
 arch/arm64/kernel/asm-offsets.c            |   2 -
 arch/arm64/kernel/image-vars.h             |   6 +-
 arch/arm64/kvm/Makefile                    |   2 +-
 arch/arm64/kvm/arm.c                       |  75 +++++-
 arch/arm64/kvm/debug.c                     |   2 +
 arch/arm64/kvm/hyp.S                       |  34 ---
 arch/arm64/kvm/hyp/entry.S                 |  92 +++----
 arch/arm64/kvm/hyp/hyp-entry.S             |  81 +-----
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |  49 +---
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  30 ++-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  46 ++--
 arch/arm64/kvm/hyp/nvhe/Makefile           |   3 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c         |  28 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S         |  86 ++++---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         | 218 ++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-start.S        |  49 ++++
 arch/arm64/kvm/hyp/nvhe/switch.c           | 282 +++++++++++----------
 arch/arm64/kvm/hyp/nvhe/timer-sr.c         |  35 +--
 arch/arm64/kvm/hyp/nvhe/tlb.c              |  19 +-
 arch/arm64/kvm/hyp/vhe/debug-sr.c          |  34 ++-
 arch/arm64/kvm/hyp/vhe/switch.c            |  30 +--
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         |   4 +-
 arch/arm64/kvm/hyp/vhe/tlb.c               |   4 +-
 arch/arm64/kvm/pmu.c                       |  28 +-
 arch/arm64/kvm/vgic/vgic-v3.c              |   4 +-
 include/linux/arm-smccc.h                  |  64 ++---
 30 files changed, 873 insertions(+), 604 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp.S
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp-main.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp-start.S

-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
