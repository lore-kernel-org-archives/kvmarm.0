Return-Path: <SRS0=3yKf=QA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E37BC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:22:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B278610A1
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:22:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9B278610A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F191A4B2F6;
	Fri, 12 Nov 2021 20:22:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hqAn6Xg5rEGm; Fri, 12 Nov 2021 20:22:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D18E4B2AE;
	Fri, 12 Nov 2021 20:22:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 127844B297
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:22:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hgZmT9BbbUs8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 20:22:43 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9270A4B295
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:22:43 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 134-20020a62198c000000b0047bf0981003so6596657pfz.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 17:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=2Fl+E7cG54UAD1z/Snstpjzha6PMILzmNdpT7gA3XpY=;
 b=kObfQ+3XAG09c7i5PoZKbrnoG/eHfjcW3oAmPgKbxnoWhQ1/kFp0530IM35uyyMV87
 ZtPq8IdHd9jo79z0GPpm/nbTx7W3/AcKg7Ug4csla8MmTxjojlX2gokq5q5aW7aT2Vn5
 oOUaiDuzm+BehTbdFhfndQhsd2yGlbSJQUapGYrNHhQHDAlr8KgWym2QlL2QG+qLnWyz
 KDNqmtyGqHnBz3SgmyripUOBlvxDv3gSnI1Ix25nclPuqdUP01N9hznuc5ikuwehke/j
 H3F7DcenpZNgmQiirp9gedpzrXuh6HVYdIljr9d8llkvlGsvyu+22b/R0fJ2WBCpoI9M
 inFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=2Fl+E7cG54UAD1z/Snstpjzha6PMILzmNdpT7gA3XpY=;
 b=TTTtLqb/qknuEacfhRbdAGR1C9MIvN82BgcoBX9Ay5wmh1DKP4Y7hwkrnzFxA4ph4j
 WCRm/GEoWlxExWjUq88dgGfUP5Dyv9+8AcJ8eIjMmWT0EdwsR8JsdG5KYXWMp0KA2zxy
 ImI2QcZ3lJAu0QWsGBErb4DRGKnqiiqBg1XFC/19c6U5YDK42TP0M0t9f5dGAKt16mT0
 bOdPJ6DkYT3NwuFD7SUypJfEuwY+8YzOr96ZoWtKeQ01XNl7EwPofIL8e49K+uNKzRIK
 aL1FioEDyN9TakcFpjwsZtJObLX5nDK/eFiy3ivruhvKnP+V15pilH2otWlqIlXrYHAt
 II7w==
X-Gm-Message-State: AOAM531uFeK5gUL2yegxNdGFkC7m82j508RdS8iWXc+ucTh+nqrdDnee
 TasPXW5xAzYE2WTv3AH1XiR66EmqNzbF
X-Google-Smtp-Source: ABdhPJx/Kep9Vxyfgt6R4bTxREUyHFoIGgs6339f+KoFG+ERTel8M5+SwsteJA1j0NYJpHiZSWoYJmoEhV7V
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:b20b:b0:141:a92c:a958 with SMTP id
 t11-20020a170902b20b00b00141a92ca958mr13276516plr.24.1636766562577; Fri, 12
 Nov 2021 17:22:42 -0800 (PST)
Date: Sat, 13 Nov 2021 01:22:23 +0000
Message-Id: <20211113012234.1443009-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 00/11] KVM: arm64: Add support for hypercall services
 selection
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hello,

Continuing the discussion from [1], the series tries to add support
for the user-space to elect the hypercall services that it wishes
to expose to the guest, rather than the guest discovering them
unconditionally. The idea employed by the series was taken from
[1] as suggested by Marc Z.

In a broad sense, the idea is similar to the current implementation
of PSCI interface- create a 'firmware psuedo-register' to handle the
firmware revisions. The series extends this idea to all the other
hypercalls such as TRNG (True Random Number Generator), PV_TIME
(Paravirtualized Time), and PTP (Precision Time protocol).

For better categorization and future scaling, these firmware registers
are categorized based on the service call owners, but unlike the
existing firmware psuedo-registers, they hold the features supported
in the form of a bitmap. During VM (vCPU) initialization, the registers
shows an upper-limit of the features supported by the corresponding
registers. The VMM can simply use GET_ONE_REG to discover the features.
If it's unhappy with any of the features, it can simply write-back the
desired feature bitmap using SET_ONE_REG.

KVM allows these modification only until a VM has started. KVM also
assumes that the VMM is unaware of a register if a register remains
unaccessed (read/write), and would simply clear all the bits of the
registers such that the guest accidently doesn't get exposed to the
features. Finally, the set of bitmaps from all the registers are the
services that are exposed to the guest.

In order to provide backward compatibility with already existing VMMs,
a new capability, KVM_CAP_ARM_HVC_FW_REG_BMAP, is introduced. To enable
the bitmap firmware registers extension, the capability must be
explicitly enabled. If not, the behavior is similar to the previous
setup.

The patches are based off of mainline kernel 5.15, with the selftest
patches from [2] applied.

Patch-1 factors out the non-PSCI related interface from psci.c to
hypercalls.c, as the series would extend the list in the upcoming
patches.

Patches-2,3 introduces core KVM functions, kvm_vcpu_has_run_once()
and kvm_vm_has_run_once() to be used in upcoming patches.

Patch-4 sets up the framework for the bitmap firmware psuedo-registers.
This includes introducing the capability, KVM_CAP_ARM_HVC_FW_REG_BMAP,
read/write helpers for the registers, helper to sanitize the regsiters
before VM start, and another helper to check if a particular hypercall
service is supported for the guest.
It also adds the register KVM_REG_ARM_STD_HYP_BMAP to support ARM's
standard secure services.

Patch-5 introduces the firmware register, KVM_REG_ARM_STD_HYP_BMAP,
which holds the standard hypervisor services (such as PV_TIME).

Patch-6 introduces the firmware register, KVM_REG_ARM_VENDOR_HYP_BMAP,
which holds the vendor specific hypercall services.

Patch-7,8 Add the necessary documentation for the newly added capability
and firmware registers.

Patch-9 imports the SMCCC definitions from linux/arm-smccc.h into tools/
for further use in selftests.

Patch-10 adds the selftest to test the guest (using 'hvc') and VMM
interfaces (SET/GET_ONE_REG).

Patch-11 adds these firmware registers into the get-reg-list selftest.

[1]: https://lore.kernel.org/kvmarm/874kbcpmlq.wl-maz@kernel.org/T/
[2]: https://lore.kernel.org/kvmarm/YUzgdbYk8BeCnHyW@google.com/

Regards,
Raghavendra

v1 -> v2

Addressed comments by Oliver (thanks!):

- Introduced kvm_vcpu_has_run_once() and kvm_vm_has_run_once() in the
  core kvm code, rather than relying on ARM specific vcpu->arch.has_run_once.
- Writing to KVM_REG_ARM_PSCI_VERSION is done in hypercalls.c itself,
  rather than separating out to psci.c.
- Introduced KVM_CAP_ARM_HVC_FW_REG_BMAP to enable the extension.
- Tracks the register accesses from VMM to decide whether to sanitize
  a register or not, as opposed to sanitizing upon the first 'write'
  in v1.
- kvm_hvc_call_supported() is implemented using a direct switch-case
  statement, instead of looping over all the registers to pick the
  register for the function-id.
- Replaced the register bit definitions with #defines, instead of enums.
- Removed the patch v1-06/08 that imports the firmware register
  definitions as it's not needed.
- Separated out the documentations in its own patch, and the renaming
  of hypercalls.rst to psci.rst into another patch.
- Add the new firmware registers to get-reg-list KVM selftest.

v1: https://lore.kernel.org/kvmarm/20211102002203.1046069-1-rananta@google.com/

Raghavendra Rao Ananta (11):
  KVM: arm64: Factor out firmware register handling from psci.c
  KVM: Introduce kvm_vcpu_has_run_once
  KVM: Introduce kvm_vm_has_run_once
  KVM: arm64: Setup a framework for hypercall bitmap firmware registers
  KVM: arm64: Add standard hypervisor firmware register
  KVM: arm64: Add vendor hypervisor firmware register
  Docs: KVM: Add doc for the bitmap firmware registers
  Docs: KVM: Rename psci.rst to hypercalls.rst
  tools: Import ARM SMCCC definitions
  selftests: KVM: aarch64: Introduce hypercall ABI test
  selftests: KVM: aarch64: Add the bitmap firmware registers to
    get-reg-list

 Documentation/virt/kvm/api.rst                |  23 +
 Documentation/virt/kvm/arm/hypercalls.rst     | 132 ++++++
 Documentation/virt/kvm/arm/psci.rst           |  77 ---
 arch/arm64/include/asm/kvm_host.h             |  21 +-
 arch/arm64/include/uapi/asm/kvm.h             |  12 +
 arch/arm64/kvm/arm.c                          |  31 +-
 arch/arm64/kvm/guest.c                        |   2 +-
 arch/arm64/kvm/hypercalls.c                   | 437 +++++++++++++++++-
 arch/arm64/kvm/psci.c                         | 166 -------
 arch/arm64/kvm/pvtime.c                       |   3 +
 arch/arm64/kvm/trng.c                         |   9 +-
 arch/arm64/kvm/vgic/vgic-init.c               |   2 +-
 arch/riscv/include/asm/kvm_host.h             |   3 -
 arch/riscv/kvm/vcpu.c                         |   7 +-
 include/kvm/arm_hypercalls.h                  |  20 +
 include/kvm/arm_psci.h                        |   7 -
 include/linux/kvm_host.h                      |   9 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/include/linux/arm-smccc.h               | 188 ++++++++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/get-reg-list.c      |  35 ++
 .../selftests/kvm/aarch64/hypercalls.c        | 367 +++++++++++++++
 virt/kvm/kvm_main.c                           |  18 +
 24 files changed, 1291 insertions(+), 281 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/hypercalls.rst
 delete mode 100644 Documentation/virt/kvm/arm/psci.rst
 create mode 100644 tools/include/linux/arm-smccc.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/hypercalls.c

-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
