Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2D1C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 25F7061209
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 25F7061209
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 850C34B128;
	Thu, 16 Sep 2021 14:15:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P4WagzYCw8vc; Thu, 16 Sep 2021 14:15:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A8954B11A;
	Thu, 16 Sep 2021 14:15:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D08D4B0B8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id loCGHl4Y8SIC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:15:23 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E64ED4B09C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:23 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 m15-20020a056e021c2f00b0022c598b86c3so14787465ilh.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=btDL3L/+bb3DbBRXEgGoHsE8Zt71CBQL97fPH4EXk/A=;
 b=pH3ZPSHyuyqIdw7sVb6pv1UZzHZwd5tpk6oKk5pjSrUAGZjaI6gPpcnwmDwWIogj5j
 zj/3RnzxsG3WAEUhnmKI2g0W+tsSXBeox49VmFI5O+cpKSsRpG/6GdcRVsEh7H69XLxb
 XOCV8gStUGRy/QembchUDT3ZrwTt9voEZqdtsOVVh1EdYKxtygL1sfUnFlqfSlCayr3t
 HbiYWAEvdfR74JBhPty46cWzByaiwZHagXS7CSXSfkcVw7Uj5nHRYsUlPFFfU0JkmTYg
 HtQtxiOVYuCMtNh4+rjvCaFJCVWe0PvSpdy9xi6x/3YSDDF8pGUZYGKCaMNPV/IUnAkq
 mkcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=btDL3L/+bb3DbBRXEgGoHsE8Zt71CBQL97fPH4EXk/A=;
 b=GasgFN5Rf6Nkvb4hHermDSzpe3BC2cHk06wOxZYsOpvc6yrblFkc7kgbX2PFHN93Cl
 Glq1M+ZV+4Hb+O5LBFKnxKVK1FFkRZGuAzviad8KF92HWy8d9f/ACaUbEEpdhjLRPNTc
 gFWvydVwzMBkkzz4j5iJ+sP1ykOOKkhQPYZbAXCMaqbdjQ+YykOaoVXk2fszGp/tEqPN
 dBDxjxf8mPHyhplY3aOKWGm5bW25UmuhYChh8kNVqqfZtWoGstwkkQ2o9J98cXPIP9Yo
 fB3ye6bWGb16ebFG8pdUHEVxNQQPuwXIJlW0C2Ri1hTCmchxT5E5RrJg6TDwwedoHzjr
 GeCw==
X-Gm-Message-State: AOAM532kcZ/fXw1y4Js771wbCgEDBKSrsCM1zagS3atTEn4GMO8JdHEg
 BkkxBUSYp+qjh7HiXX5+qfwPKIPunNw=
X-Google-Smtp-Source: ABdhPJxFWTKFCHnmW32IKSDzUpsnORPNcQrlWReCXvncQJer79Nhv+dt9vMYUea9GMm6JAvZIYiN8o71iQI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:90a:: with SMTP id
 y10mr5002860ilg.108.1631816123285; 
 Thu, 16 Sep 2021 11:15:23 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:02 +0000
Message-Id: <20210916181510.963449-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 0/8] KVM: arm64: Add idempotent controls to migrate guest
 counter
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

Patch 3 is a minor refactor, creating a helper function to get the
number of timer registers for a particular vCPU.

Patch 4 exposes a vCPU's virtual offset through the KVM_*_ONE_REG
ioctls. When NV support is added to KVM, CNTVOFF_EL2 will be considered
a guest system register. So, it is safe to expose it now through that
ioctl.

Patch 5 adds a cpufeature bit to detect 'full' ECV implementations,
providing EL2 with the ability to offset the physical counter-timer.

Patch 6 exposes a vCPU's physical offset as a vCPU device attribute.
This is deliberate, as the attribute is not architectural; KVM uses this
attribute to track the host<->guest offset.

Patch 7 is a prepatory change for the sake of physical offset emulation,
as counter-timer traps must be configured separately for each vCPU.

Patch 8 allows non-ECV hosts to support the physical offset vCPU device
attribute, by trapping and emulating the physical counter registers.

This series was tested on an Ampere Mt. Jade system (non-ECV, VHE and
nVHE). I did not test this on the FVP, as I need to really figure out
tooling for it on my workstation.

Applies cleanly to v5.15-rc1

v7: http://lore.kernel.org/r/20210816001217.3063400-1-oupton@google.com

v7 -> v8:
 - Only use ECV if !VHE
 - Only expose CNTVOFF_EL2 register to userspace with opt-in
 - Refer to the direct_ptimer explicitly

Oliver Upton (8):
  KVM: arm64: Refactor update_vtimer_cntvoff()
  KVM: arm64: Separate guest/host counter offset values
  KVM: arm64: Make a helper function to get nr of timer regs
  KVM: arm64: Allow userspace to configure a vCPU's virtual offset
  arm64: cpufeature: Enumerate support for FEAT_ECV >= 0x2
  KVM: arm64: Allow userspace to configure a guest's counter-timer
    offset
  KVM: arm64: Configure timer traps in vcpu_load() for VHE
  KVM: arm64: Emulate physical counter offsetting on non-ECV systems

 Documentation/arm64/booting.rst         |   7 +
 Documentation/virt/kvm/api.rst          |  23 +++
 Documentation/virt/kvm/devices/vcpu.rst |  28 ++++
 arch/arm64/include/asm/kvm_host.h       |   3 +
 arch/arm64/include/asm/sysreg.h         |   5 +
 arch/arm64/include/uapi/asm/kvm.h       |   2 +
 arch/arm64/kernel/cpufeature.c          |  10 ++
 arch/arm64/kvm/arch_timer.c             | 196 +++++++++++++++++++++---
 arch/arm64/kvm/arm.c                    |   9 +-
 arch/arm64/kvm/guest.c                  |  28 +++-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  32 ++++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c      |  11 +-
 arch/arm64/tools/cpucaps                |   1 +
 include/clocksource/arm_arch_timer.h    |   1 +
 include/kvm/arm_arch_timer.h            |  14 +-
 include/uapi/linux/kvm.h                |   1 +
 16 files changed, 337 insertions(+), 34 deletions(-)

-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
