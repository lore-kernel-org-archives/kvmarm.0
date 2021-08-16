Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B55BC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:12:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3DEF46139F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:12:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3DEF46139F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E62CD4B0FC;
	Sun, 15 Aug 2021 20:12:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0WrzpB0vYumE; Sun, 15 Aug 2021 20:12:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F20C44B0DC;
	Sun, 15 Aug 2021 20:12:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ACFF4B0B3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bexh6P3C1NS6 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:12:21 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75A594079A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:21 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 s205-20020a252cd6000000b0059449776539so4415884ybs.22
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=5mrMQ5rgKSJDf7VPeRHLHNRCD8GR57cQzcrJ1T4+wG8=;
 b=lo6ullO6Kp1xDycruAhwYsKGgXPnqzWGDrHQLxnZckr1P61xPB1v7A1arHNGA4MA2f
 1/FETdWS8qyfarlClNbsf8207Ps+zEM71kE4Wvu8mHn+/RXW2PIGPYzE7HAlLHCkmZuX
 7BEbPqI0WNTpwuOxsjrIOB6oQaOpOPZtoRZvj7+X4FfK5TWmrM7Lxj9/LhvRAxyH9GOK
 C3QoxNvrgWXEN6Ql3hLHIUwcJrpB8LfE3es4CWc6TQtq8Yu+6PJnlYw7b3NNPF5vfb44
 yL84b0/IGjXt4hHj2Gf4J2AfbgiQG4D0L0uC2VdiUsMmGaP4HujAqaXzCmhcsmo3l+dC
 AlrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=5mrMQ5rgKSJDf7VPeRHLHNRCD8GR57cQzcrJ1T4+wG8=;
 b=C4nbMvvtg8LvlSThGwF04RnMw50tGqrzt6HQxtnH83srmVwPCQl8VK5qRsK9vTBNVH
 sQentvvgPeb6GdHHzqZi07zdfjrW36XOBL6xNTrkxD8VMz3UvOoi7eLrti6QRRJfcRk5
 sEIOTRFK5KQvYUa1QkhiT4Pt0J/4ZqMt2VTDVtCUM83/0ynfaSF67jM5+McpzQKT9/EV
 Mt8xAxfu1Fo+4cddUDrSzh7T03tQo7h84xKRtuLL8zciYwQkvpQIkFuQoNFgy1HOK/5y
 Rh/sjdqDagtYAnER3QgYLzjnRzjb4uVPTiijQNzqEAH20ZFxIXkwZ8N1Wt+uFgG5Tmqe
 9cmw==
X-Gm-Message-State: AOAM531hK8NCbYoWX/gZMSx4HgpjlVhOx1PL7yEXKbNfPQXXWUSCWL8g
 Q/yqjZHXv9xKdohTtOJ5Xsz2R2yFtnc=
X-Google-Smtp-Source: ABdhPJxVRmLt9tUt3gGzv0/4JgNLL1IiSIdGK/E6P34z9I+oWRL6HpOccF2RgtNs7bOl/yPJOoA44nyOzDw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:9241:: with SMTP id
 e1mr17406096ybo.38.1629072741082; 
 Sun, 15 Aug 2021 17:12:21 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:12:10 +0000
Message-Id: <20210816001217.3063400-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 0/7] KVM: arm64: Add idempotent controls to migrate guest
 counter
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Currently, on KVM/arm64, we only allow a VMM to migrate the guest's
virtual counter by-value. Saving and restoring the counter by value is
problematic in the fact that the recorded state is not idempotent.
Furthermore, we obfuscate from userspace the fact that the architecture
actually provides offset-based controls.

Another issue is that KVM/arm64 doesn't provide userspace with the
controls of the physical counter-timer. This series aims to address both
issues by adding offset-based controls for the virtual and physical
counters.

Patches 1-2 are refactor changes required to provide offset controls to
userspace and putting in some generic plumbing to use for both physical
and virtual offsets.

Patch 3 exposes a vCPU's virtual offset through the KVM_*_ONE_REG
ioctls. When NV support is added to KVM, CNTVOFF_EL2 will be considered
a guest system register. So, it is safe to expose it now through that
ioctl.

Patch 4 adds a cpufeature bit to detect 'full' ECV implementations,
providing EL2 with the ability to offset the physical counter-timer.

Patch 5 exposes a vCPU's physical offset as a vCPU device attribute.
This is deliberate, as the attribute is not architectural; KVM uses this
attribute to track the host<->guest offset.

Patch 6 is a prepatory change for the sake of physical offset emulation,
as counter-timer traps must be configured separately for each vCPU.

Patch 7 allows non-ECV hosts to support the physical offset vCPU device
attribute, by trapping and emulating the physical counter registers.

This series was tested on an Ampere Mt. Jade system (non-ECV, VHE and
nVHE) as well as the ARM Base RevC FVP (ECV, VHE and nVHE). Patches
apply to kvmarm/next at the following commit:

ae280335cdb5 ("Merge branch kvm-arm64/mmu/el2-tracking into kvmarm-master/next")

Selftests for these changes are being mailed as a separate series, since
there exist dependencies betwen both x86 and arm64.

v6: https://lore.kernel.org/r/20210804085819.846610-1-oupton@google.com

v6 -> v7:
 - Fixed typo in documentation (Marc)
 - Clean up some unused variables (Drew)
 - Added trap configuration for ECV+nVHE (Marc)
 - Documented dependency on SCR_EL3.ECVEn (Marc)
 - wrap up ptimer_emulation_required() for use in hyp and kernel code
   (Drew)
 - check static branch condition first (Drew)
 - s/cpus_have_const_cap/cpus_have_final_cap/ (Marc)
 - s/ARM64_ECV/ARM64_HAS_ECV2/
 - Emulate CNTPCTSS_EL2 if ECV2 not present (Marc)
 - Reordered the introduction of some functions to ensure that we don't
   have unused functions in the middle of the series.
 - Cleaned up the read side of CNTVOFF_EL2 (from userspace). Don't
   open-code the answer based on the difference of hardware offsets,
   just use the guest system register value we stashed on the write
   side.

Oliver Upton (7):
  KVM: arm64: Refactor update_vtimer_cntvoff()
  KVM: arm64: Separate guest/host counter offset values
  KVM: arm64: Allow userspace to configure a vCPU's virtual offset
  arm64: cpufeature: Enumerate support for FEAT_ECV >= 0x2
  KVM: arm64: Allow userspace to configure a guest's counter-timer
    offset
  KVM: arm64: Configure timer traps in vcpu_load() for VHE
  KVM: arm64: Emulate physical counter offsetting on non-ECV systems

 Documentation/arm64/booting.rst         |   7 +
 Documentation/virt/kvm/api.rst          |  10 ++
 Documentation/virt/kvm/devices/vcpu.rst |  28 ++++
 arch/arm64/include/asm/kvm_asm.h        |   2 +
 arch/arm64/include/asm/sysreg.h         |   5 +
 arch/arm64/include/uapi/asm/kvm.h       |   2 +
 arch/arm64/kernel/cpufeature.c          |  10 ++
 arch/arm64/kvm/arch_timer.c             | 196 +++++++++++++++++++++---
 arch/arm64/kvm/arm.c                    |   4 +-
 arch/arm64/kvm/guest.c                  |   6 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  32 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |   6 +
 arch/arm64/kvm/hyp/nvhe/timer-sr.c      |  20 ++-
 arch/arm64/kvm/hyp/vhe/timer-sr.c       |   5 +
 arch/arm64/tools/cpucaps                |   1 +
 include/clocksource/arm_arch_timer.h    |   1 +
 include/kvm/arm_arch_timer.h            |   9 +-
 17 files changed, 315 insertions(+), 29 deletions(-)

-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
