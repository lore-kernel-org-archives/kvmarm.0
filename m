Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66883C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 20:49:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CACD0610FB
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 20:49:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CACD0610FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47E454B126;
	Mon, 13 Sep 2021 16:49:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dv8N7oPoxQhO; Mon, 13 Sep 2021 16:49:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDA1A4B13A;
	Mon, 13 Sep 2021 16:49:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 060374B126
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:49:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y02FBYAqY9qG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 16:49:40 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2F074B120
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:49:40 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 a15-20020a0ce34f000000b0037a944f655dso2722801qvm.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 13:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=j/4YFFEj93EYD5WXf9YhC7NiAQuOqnV1NemoThsXtqE=;
 b=IPeTbH6lQdFamt3b7Tb/2xRM1jLlcSwFvG4WsYT5hnT6EMqTUpeyNP9Q0EMEESnG+y
 mwn5pNuQC8QLoEeNL+SzNMdQtxLCtVRGINTbTU8aWlHMtwJcUx1P/OCJfUcpg8SZiR68
 MK/wGDciELJREoks3wbmCGmyRyJgHR7zJ+1/jVt53r9qTEpqlM0snS02rwSDKbExmJo9
 DUujW/UBLD9EsFPbNUQaHcSsz1rreCiceFEuaoBPtweFwlaSvIF+bWTuhpRJKLiXS5Rh
 nhBzsXOZbcUJwDup0UtvcprxwbYfyCJFE7OA+sB/aZF6QYRhxfCo+2vcgoeLCucVOcMz
 0yNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=j/4YFFEj93EYD5WXf9YhC7NiAQuOqnV1NemoThsXtqE=;
 b=3pO6COBp79BrMS7lJwaWqhPC8im55FuQy/a8suCbFgNjAoeqx4JhdTMVstIeFRT1M6
 +oJhB84M4/chmVtZMjABUc8R+ZtfMhnageyjuE6sDqdaBbqN7JCab36tfZ20sG6zq7cs
 kPEvV27cTgIzbyUhn6v5GvHrMYxn1ijjrs9RKQGkQSDX1tRPGWDQeUeoDcrlOBtpVSky
 ++nacv315oe205GNbeg88/y6daAMzlUILXljT344D/Cc0D5a3ivSFe3mJh1k3aJxHEB7
 vfXZQRsBw65wq/lCdtL6KaJCXuqWkp/PEGPqvRm0JCZVM4krxH8hreG36dOa4eL0KmH7
 xIeQ==
X-Gm-Message-State: AOAM533vtYhiI1ILtcg5vSLJpeiA5zHrQ5NDbWi38aYOPITWBKYk3Wkk
 xCzITvzybKVggyRnj5mGMXQvOErL7CpV
X-Google-Smtp-Source: ABdhPJyTVe0omAS5aJxAkvc8VJVrflvztp/o84xfhKX8w1tQ7xA5MKckSQrMC8KVXUOJe06IXs+h5Jz39cHR
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a0c:8064:: with SMTP id
 91mr1557900qva.66.1631566179948; Mon, 13 Sep 2021 13:49:39 -0700 (PDT)
Date: Mon, 13 Sep 2021 20:49:16 +0000
Message-Id: <20210913204930.130715-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v5 00/14] KVM: arm64: selftests: Introduce arch_timer selftest
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
ARM's generic timer (patch-13). The test programs the timer IRQs
periodically, and for each interrupt, it validates the behaviour
against the architecture specifications. The test further provides
a command-line interface to configure the number of vCPUs, the
period of the timer, and the number of iterations that the test
has to run for.

Patch-14 adds an option to randomly migrate the vCPUs to different
physical CPUs across the system. The bug for the fix provided by
Marc with commit 3134cc8beb69d0d ("KVM: arm64: vgic: Resample HW
pending state on deactivation") was discovered using arch_timer
test with vCPU migrations.

Since the test heavily depends on interrupts, patch-12 adds a host
library to setup ARM Generic Interrupt Controller v3 (GICv3). This
includes creating a vGIC device, setting up distributor and
redistributor attributes, and mapping the guest physical addresses.
Symmetrical to this, patch-11 adds a guest library to talk to the vGIC,
which includes initializing the controller, enabling/disabling the
interrupts, and so on.

The following patches are utility patches that the above ones make use
of:
Patch-1 adds readl/writel support for guests to access MMIO space.

Patch-2 imports arch/arm64/include/asm/sysreg.h into
tools/arch/arm64/include/asm/ to make use of the register encodings
and read/write definitions.

Patch-3 is not directly related to the test, but makes
aarch64/debug-exceptions.c use the read/write definitions from the
imported sysreg.h and remove the existing definitions of read_sysreg()
and write_sysreg().

Patch-4 introduces ARM64_SYS_KVM_REG, that helps convert the SYS_*
register encodings in sysreg.h to be acceptable by get_reg() and set_reg().
It further replaces the users of ARM64_SYS_REG to use the new macro.

Patch-5 adds the support for cpu_relax().

Patch-6 adds basic arch_timer framework.

Patch-7 adds udelay() support for the guests to utilize.

Patch-8 adds local_irq_enable() and local_irq_disable() for the guests
to enable/disable interrupts.

Patch-9 adds the support to get the vcpuid for the guests. This allows
them to access any cpu-centric private data in the upcoming patches.

Patch-10 adds a light-weight support for spinlocks for the guests to
use.

The patch series, specifically the library support, is derived from the
kvm-unit-tests and the kernel itself.

Regards,
Raghavendra

v4 -> v5:

Addressed the comments by Andrew, Oliver, and Reiji (Thanks, again):
- Squashed patches 17/18 and 18/18 into 3/18 and 14/18, respectively.
- Dropped patches to keep track kvm_utils of nr_vcpus (12/18) and
  vm_get_mode() (13/18) as they were no longer needed.
- Instead of creating the a map, exporting the vcpuid to the guest
  is done by using the TPIDR_EL1 register.
- Just to be on the safer side, gic.c's gic_dist_init() explicitly
  checks if gic_ops is NULL.
- Move sysreg.h from within selftests to tool/arch/arm64/include/asm/.
- Rename ARM64_SYS_KVM_REG to KVM_ARM64_SYS_REG to improve readability.
- Use the GIC regions' sizes from asm/kvm.h instead of re-defining it
  in the vgic host support.
- Get the timer IRQ numbers via timer's device attributes
  (KVM_ARM_VCPU_TIMER_IRQ_PTIMER, KVM_ARM_VCPU_TIMER_IRQ_VTIMER) instead
  of depending on default numbers to be safe.
- Add check to see if the vCPU migrations are in fact enabled, before
  looking for at least two online physical CPUs for the test.
- Add missing blank lines in the arch_timer test.

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
v4: https://lore.kernel.org/kvmarm/20210909013818.1191270-1-rananta@google.com/

Raghavendra Rao Ananta (14):
  KVM: arm64: selftests: Add MMIO readl/writel support
  tools: arm64: Import sysreg.h
  KVM: arm64: selftests: Use read/write definitions from sysreg.h
  KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
  KVM: arm64: selftests: Add support for cpu_relax
  KVM: arm64: selftests: Add basic support for arch_timers
  KVM: arm64: selftests: Add basic support to generate delays
  KVM: arm64: selftests: Add support to disable and enable local IRQs
  KVM: arm64: selftests: Add guest support to get the vcpuid
  KVM: arm64: selftests: Add light-weight spinlock support
  KVM: arm64: selftests: Add basic GICv3 support
  KVM: arm64: selftests: Add host support for vGIC
  KVM: arm64: selftests: Add arch_timer test
  KVM: arm64: selftests: arch_timer: Support vCPU migration

 tools/arch/arm64/include/asm/sysreg.h         | 1278 +++++++++++++++++
 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    3 +-
 .../selftests/kvm/aarch64/arch_timer.c        |  479 ++++++
 .../selftests/kvm/aarch64/debug-exceptions.c  |   30 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  |    2 +-
 .../testing/selftests/kvm/aarch64/vgic_init.c |    3 +-
 .../kvm/include/aarch64/arch_timer.h          |  142 ++
 .../selftests/kvm/include/aarch64/delay.h     |   25 +
 .../selftests/kvm/include/aarch64/gic.h       |   21 +
 .../selftests/kvm/include/aarch64/processor.h |   88 +-
 .../selftests/kvm/include/aarch64/spinlock.h  |   13 +
 .../selftests/kvm/include/aarch64/vgic.h      |   20 +
 .../testing/selftests/kvm/include/kvm_util.h  |    2 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c |   95 ++
 .../selftests/kvm/lib/aarch64/gic_private.h   |   21 +
 .../selftests/kvm/lib/aarch64/gic_v3.c        |  240 ++++
 .../selftests/kvm/lib/aarch64/gic_v3.h        |   70 +
 .../selftests/kvm/lib/aarch64/processor.c     |   22 +-
 .../selftests/kvm/lib/aarch64/spinlock.c      |   27 +
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |   70 +
 21 files changed, 2606 insertions(+), 46 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/sysreg.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c

-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
