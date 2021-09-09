Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06006C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 773FA61166
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:38:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 773FA61166
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D83204A534;
	Wed,  8 Sep 2021 21:38:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M4a53CynJs17; Wed,  8 Sep 2021 21:38:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 305374B0FC;
	Wed,  8 Sep 2021 21:38:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE19D4B0ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BmAaaifORIoV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 21:38:25 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 084AE4A534
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:25 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 a12-20020a1709027d8c00b0013a519b5ec8so6456plm.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 18:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=cXLOOprGnn6NAbtj7ptazkHdOujdqMUXzJSpTCEq0wg=;
 b=b/koDTnjmI5NyRxR6CCrqJRsysjybiUUIICs4pO1YGcWgQs4yrVD8BJ1KaWFnM78u9
 oWhDQh6DQTJqkzhRJVw3YnZhRLRv4HfnuQ9rvasLBSRxzWM/SP68DDkV4ZkOAOoBgrlT
 G/my2/pnGY/pkDurVNMw2soK8XX6rvc3k3l/kobcMP/DXr0600F2f8iTibKImcZTx8Ft
 OQThgqkgCBdDuDdCMKa5IlZ4q+xvoiUy+kydbHwzbDb0CzhFoi8F2/el7XQqZHVuHjLI
 qxcvkhOd78JLFd/DWe56hyelZxdaORhyyTD7tcEWAJj6TWSajpqtGb83x+pJ0m2vfBen
 v8ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=cXLOOprGnn6NAbtj7ptazkHdOujdqMUXzJSpTCEq0wg=;
 b=c8ukWurWW64tLSB+joUT0R0BGRErAJu+05jebAoa17gisRIAFx6zvxJZ3240QPb7EO
 PWsMjUoqO4LNKy8plkewQ/f/LKDk3qCx8mdp3circiFWFj6DHg+l4z7Y83ph3z6pn4fO
 vRN+pHPueGDycyP2u5DIo9ATZDheVA5Ccm1QrAO4xDHhMfBZM/Y67RpyeU2J08mi4nTB
 9ZT2FrEcsYIUEdsGPfG2b5bfv+eHQKn08vJsrHmka6b2ZlTAKNrlZxEMu9al9CAiHl2M
 uLojfOLxorGMak94Js07748tN2BF1bwame8pO7ANhYZXpWB0DHXCihsn9cRQlhunVUEC
 iXNA==
X-Gm-Message-State: AOAM532MjnEvRhdWSdLVmbm3VM8XLsTD5durWFncJzzWWHxlrAygSeOl
 2+bHDQKE8wvN2nIup5/lO6F0z4yFSZzD
X-Google-Smtp-Source: ABdhPJz3Vma/GVRvz0/PdyWoKaQNko6J30rOz3j9TqCDqHMK0cPx/2/2QS0PaZgI8ArsZgL4EZU3oSQTTVnm
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:7f04:: with SMTP id
 k4mr51417pjl.0.1631151503395; Wed, 08 Sep 2021 18:38:23 -0700 (PDT)
Date: Thu,  9 Sep 2021 01:38:00 +0000
Message-Id: <20210909013818.1191270-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 00/18] KVM: arm64: selftests: Introduce arch_timer selftest
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

The patch series adds a KVM selftest to validate the behavior of
ARM's generic timer (patch-15). The test programs the timer IRQs
periodically, and for each interrupt, it validates the behaviour
against the architecture specifications. The test further provides
a command-line interface to configure the number of vCPUs, the
period of the timer, and the number of iterations that the test
has to run for.

Patch-16 adds an option to randomly migrate the vCPUs to different
physical CPUs across the system. The bug for the fix provided by
Marc with commit 3134cc8beb69d0d ("KVM: arm64: vgic: Resample HW
pending state on deactivation") was discovered using arch_timer
test with vCPU migrations.

Since the test heavily depends on interrupts, patch-14 adds a host
library to setup ARM Generic Interrupt Controller v3 (GICv3). This
includes creating a vGIC device, setting up distributor and
redistributor attributes, and mapping the guest physical addresses.
Symmetrical to this, patch-11 adds a guest library to talk to the vGIC,
which includes initializing the controller, enabling/disabling the
interrupts, and so on.

The following patches are utility patches that the above ones make use
of:
Patch-1 adds readl/writel support for guests to access MMIO space.

Patch-2 imports arch/arm64/include/asm/sysreg.h into selftests to make
use of the register encodings and read/write definitions.

Patch-3 is not directly related to the test, but makes
aarch64/debug-exceptions.c use the read/write definitions from the
imported sysreg.h and remove the existing definitions of read_sysreg()
and write_sysreg().

Patch-4 introduces ARM64_SYS_KVM_REG, that helps convert the SYS_*
register encodings in sysreg.h to be acceptable by get_reg() and set_reg().

Patch-5 adds the support for cpu_relax().

Patch-6 adds basic arch_timer framework.

Patch-7 adds udelay() support for the guests to utilize.

Patch-8 adds local_irq_enable() and local_irq_disable() for the guests
to enable/disable interrupts.

Patch-9 adds the support to get the vcpuid for the guests. This allows
them to access any cpu-centric private data in the upcoming patches.

Patch-10 adds a light-weight support for spinlocks for the guests to
use.

Patch-12 and 13 adds helper routines to get the number of vCPUs and the
mode of the VM, respectively. These are further used by the vGIC host
routine (patch-14).

Patch-17 is unrelated to the test case, but it make a cleanup
for aarch64/vgic_init.c to use REDIST_REGION_ATTR_ADDR from vgic.h.

Patch-18 is also unrelated, where it replaces ARM64_SYS_REG with
ARM64_SYS_KVM_REG throughout the selftests. The definitions for the
system register encodings are further deleted in processor.h.

The patch series, specifically the library support, is derived from the
kvm-unit-tests and the kernel itself.

Regards,
Raghavendra

v3 -> v4:

Addressed the comments by Andrew, Oliver, and Ricardo (Thank you):
- Reimplemented get_vcpuid() by exporting a map of vcpuid:mpidr to the
  guest.
- Import sysreg.h from arch/arm64/include/asm/sysreg.h to get the system
  register encodings and its read/write support. As a result, delete the
  existing definitions in processor.h.
- Introduce ARM64_SYS_KVM_REG that converts SYS_* register definitions
  from sysreg.h into the encodings accepted by get_reg() and set_reg().
- Hence, remove the existing encodings of system registers (CPACR_EL1,
  TCR_EL1, and friends) and replace all the its consumers throughout
  the selftests with ARM64_SYS_KVM_REG.
- Keep track of number of vCPUs in 'struct kvm_vm'.
- Add a helper method to get the KVM VM's mode.
- Modify the vGIC host function vgic_v3_setup to make use of the above
  two helper methods, which prevents it from accepting nr_vcpus as
  an argument.
- Move the definition of REDIST_REGION_ATTR_ADDR from lib/aarch64/vgic.c
  to include/aarch64/vgic.h.
- Make the selftest, vgic_init.c, use the definition of REDIST_REGION_ATTR_ADDR
  from include/aarch64/vgic.h.
- Turn ON vCPU migration by default (-m 2).
- Add pr_debug() to log vCPU migrations. Helpful for diagnosis.
- Change TEST_ASSERT(false,...) to TEST_FAIL() in the base arch_timer
  test.
- Include linux/types.h for __force definitions.
- Change the type of 'val' to 'int' in spin_lock() to match the lock
  value type.
- Fix typos in code files and comments.

v2 -> v3:

- Addressed the comments from Ricardo regarding moving the vGIC host
  support for selftests to its own library.
- Added an option (-m) to migrate the guest vCPUs to physical CPUs
  in the system.

v1 -> v2:

Addressed comments from Zenghui in include/aarch64/arch_timer.h:
- Correct the header description
- Remove unnecessary inclusion of linux/sizes.h
- Re-arrange CTL_ defines in ascending order
- Remove inappropriate 'return' from timer_set_* functions, which
  returns 'void'.

v1: https://lore.kernel.org/kvmarm/20210813211211.2983293-1-rananta@google.com/
v2: https://lore.kernel.org/kvmarm/20210818184311.517295-1-rananta@google.com/
v3: https://lore.kernel.org/kvmarm/20210901211412.4171835-1-rananta@google.com/

Raghavendra Rao Ananta (18):
  KVM: arm64: selftests: Add MMIO readl/writel support
  KVM: arm64: selftests: Add sysreg.h
  KVM: arm64: selftests: Use read/write definitions from sysreg.h
  KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
  KVM: arm64: selftests: Add support for cpu_relax
  KVM: arm64: selftests: Add basic support for arch_timers
  KVM: arm64: selftests: Add basic support to generate delays
  KVM: arm64: selftests: Add support to disable and enable local IRQs
  KVM: arm64: selftests: Add guest support to get the vcpuid
  KVM: arm64: selftests: Add light-weight spinlock support
  KVM: arm64: selftests: Add basic GICv3 support
  KVM: selftests: Keep track of the number of vCPUs for a VM
  KVM: selftests: Add support to get the VM's mode
  KVM: arm64: selftests: Add host support for vGIC
  KVM: arm64: selftests: Add arch_timer test
  KVM: arm64: selftests: arch_timer: Support vCPU migration
  KVM: arm64: selftests: Replace ARM64_SYS_REG with ARM64_SYS_KVM_REG
  KVM: selftests: vgic_init: Pull REDIST_REGION_ATTR_ADDR from vgic.h

 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    3 +-
 .../selftests/kvm/aarch64/arch_timer.c        |  462 ++++++
 .../selftests/kvm/aarch64/debug-exceptions.c  |   30 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  |    3 +-
 .../testing/selftests/kvm/aarch64/vgic_init.c |    3 +-
 .../kvm/include/aarch64/arch_timer.h          |  142 ++
 .../selftests/kvm/include/aarch64/delay.h     |   25 +
 .../selftests/kvm/include/aarch64/gic.h       |   21 +
 .../selftests/kvm/include/aarch64/processor.h |   93 +-
 .../selftests/kvm/include/aarch64/spinlock.h  |   13 +
 .../selftests/kvm/include/aarch64/sysreg.h    | 1278 +++++++++++++++++
 .../selftests/kvm/include/aarch64/vgic.h      |   20 +
 .../testing/selftests/kvm/include/kvm_util.h  |    2 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c |   93 ++
 .../selftests/kvm/lib/aarch64/gic_private.h   |   21 +
 .../selftests/kvm/lib/aarch64/gic_v3.c        |  240 ++++
 .../selftests/kvm/lib/aarch64/gic_v3.h        |   70 +
 .../selftests/kvm/lib/aarch64/processor.c     |   62 +-
 .../selftests/kvm/lib/aarch64/spinlock.c      |   27 +
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |   60 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   12 +
 .../selftests/kvm/lib/kvm_util_internal.h     |    1 +
 23 files changed, 2636 insertions(+), 46 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/sysreg.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c

-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
