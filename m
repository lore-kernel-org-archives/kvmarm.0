Return-Path: <SRS0=JhWI=QC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905C8C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:55:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0EA5461B73
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:55:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0EA5461B73
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 919E24B1A5;
	Mon, 15 Nov 2021 11:55:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1u6aWcuukOnH; Mon, 15 Nov 2021 11:55:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB24F4B1A2;
	Mon, 15 Nov 2021 11:55:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 948BC4B199
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:55:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rjoUk8OZfmEl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Nov 2021 11:55:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17EB74B195
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:55:26 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4532F1FB;
 Mon, 15 Nov 2021 08:55:25 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2F7C3F766;
 Mon, 15 Nov 2021 08:55:23 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com
Subject: [PATCH kvmtool 0/9] arm64: Improve PMU support on heterogeneous
 systems
Date: Mon, 15 Nov 2021 16:56:56 +0000
Message-Id: <20211115165705.195736-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
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

The series can be found at [1], and the Linux patches that this series is
based on at [2].

The series adds support for the KVM_ARM_VCPU_PMU_V3_SET_PMU PMU attribute,
which allows userspace to set a PMU for a VCPU. This PMU is used by KVM
when creating perf events to emulate the guest PMU.

Without settings this attribute, the PMU used when creating events is the
first one that successfully probed when booting, but this is unreliable as
the probe order can change (if the order of the PMUs is changed in the DTB
or if asynchronous driver probing is enabled at the host's command line),
and furthermore it requires the user to have intimate knowledge of how the
PMU was chosen in order to pin the VM on the correct physical CPUs.

With KVM_ARM_VCPU_PMU_V3_SET_PMU, the user is still expected to pin the VM
on a particular set of CPUs, but now it can be any CPUs as long as they
share the same PMU. The set does not depend anymore on the driver probe
order and all that is necessary for the user to know is which CPUs are the
little core and which are the big cores, in a big.little configuration,
which I believe is more reasonable.

Patches #1-#5 move the PMU code to aarch64, where it belongs, because the
PMU has never been supported on KVM for arm. This also paves the way for
pulling in the KVM_ARM_VCPU_PMU_V3_SET_PMU attribute, which was not defined
for KVM for arm (when KVM supported arm). This can be merged right now,
independently of the other patches.

Patches #6-#7 add the function cpulist_parse(), copied almost as-is from
Linux v5.15.

Patch #8 pulls all the necessary user API definitions, and finally patch #9
adds support for KVM_ARM_VCPU_PMU_V3_SET_PMU.

[1] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/pmu-big-little-fix-v1
[2] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/pmu-big-little-fix-v1

Alexandru Elisei (9):
  linux/err.h: Add missing stdbool.h include
  arm: Move arch specific VCPU features to the arch specific function
  arm: Get rid of the ARM_VCPU_FEATURE_FLAGS() macro
  arm: Make the PMUv3 emulation code arm64 specific
  arm64: Rework set_pmu_attr()
  util: Add basic cpumask functions
  util: Add cpulist_parse()
  update_headers.sh: Sync headers with Linux v5.16-rc1 + SET_PMU
    attribute
  arm64: Add support for KVM_ARM_VCPU_PMU_V3_SET_PMU

 Makefile                                      |   5 +-
 arm/aarch32/include/asm/kernel.h              |   8 +
 arm/aarch32/include/kvm/kvm-cpu-arch.h        |   4 -
 arm/aarch64/arm-cpu.c                         |   3 +-
 arm/aarch64/include/asm/kernel.h              |   8 +
 arm/aarch64/include/asm/kvm.h                 |  57 ++-
 .../arm-common => aarch64/include/asm}/pmu.h  |   0
 arm/aarch64/include/kvm/kvm-cpu-arch.h        |   6 -
 arm/aarch64/kvm-cpu.c                         |  12 +
 arm/aarch64/pmu.c                             | 201 ++++++++
 arm/kvm-cpu.c                                 |  14 +-
 arm/pmu.c                                     |  76 ---
 include/linux/bitmap.h                        |  45 ++
 include/linux/bitops.h                        |   2 +
 include/linux/cpumask.h                       |  38 ++
 include/linux/err.h                           |   2 +
 include/linux/kernel.h                        |   3 +
 include/linux/kvm.h                           | 441 +++++++++++++++++-
 mips/include/asm/kernel.h                     |   8 +
 powerpc/include/asm/kernel.h                  |   8 +
 powerpc/include/asm/kvm.h                     |  10 +
 util/bitmap.c                                 | 221 +++++++++
 x86/include/asm/kernel.h                      |   8 +
 x86/include/asm/kvm.h                         |  64 ++-
 24 files changed, 1132 insertions(+), 112 deletions(-)
 create mode 100644 arm/aarch32/include/asm/kernel.h
 create mode 100644 arm/aarch64/include/asm/kernel.h
 rename arm/{include/arm-common => aarch64/include/asm}/pmu.h (100%)
 create mode 100644 arm/aarch64/pmu.c
 delete mode 100644 arm/pmu.c
 create mode 100644 include/linux/bitmap.h
 create mode 100644 include/linux/cpumask.h
 create mode 100644 mips/include/asm/kernel.h
 create mode 100644 powerpc/include/asm/kernel.h
 create mode 100644 util/bitmap.c
 create mode 100644 x86/include/asm/kernel.h

-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
