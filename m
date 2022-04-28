Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98351C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 15:56:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ECFC4B28D;
	Thu, 28 Apr 2022 11:56:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0TlvrZGfAfmc; Thu, 28 Apr 2022 11:56:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4B344B266;
	Thu, 28 Apr 2022 11:56:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 837914B25F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ppt1hb6OW+yA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 11:56:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E669149E44
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71D031474;
 Thu, 28 Apr 2022 08:56:06 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B2413F774;
 Thu, 28 Apr 2022 08:56:04 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: julien.thierry.kdev@gmail.com, will@kernel.org, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com
Subject: [PATCH kvmtool 00/15] arm64: Allow the user to set RAM base address
Date: Thu, 28 Apr 2022 16:55:47 +0100
Message-Id: <20220428155602.29445-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.0
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

The series can be found at [1]. It is loosely based on the patches that
allow the user to define the VM memory layout (RAM + MMIO) [2]. I've
cherry-picked a handful of patches from that series, the rest I wrote from
scratch since there have been several changes to the way guest memory is
handled. I've chosen to focus on specifying the RAM layout with only one
RAM bank and leave the rest for a later series because this was relatively
easy to accomplish, while still being very useful, at least in my opinion.

Because this series comes after almost three year of changes to kvmtool,
I've decided to drop all the Reviewed-by tags. Thanks to Andre and Suzuki
for reviewing the previous patches, it has been very much appreciated.

What this series does: for arm64, the user can now specify the base address
for RAM:

$ ./lkvm run -c2 -m1G@2G # Equivalent to ./lkvm run -c2 -m1024

The memory units are B (bytes), K (kilobytes), M (megabytes), G
(gigabytes), T (terrabytes), P (petabytes).

Want to put RAM at the top of the physical address range? Easy:

$ ./lkvm run -c2 -m2G@1022G # Assumes the maximum is 40 bits of IPA

There one limitation on the RAM base address: it must not overlap with the MMIO
range that kvmtool uses, which lives below 2GB.

Why this is useful, in my opinion:

1. Testing how a payload handles different memory layouts without the need
to hack kvmtool or find the hardware that implements the desired layout.

2. It can serve as a development tool for adding support for larger PA
ranges for Linux and KVM (currently capped at 48 bits), or any other
payloads.

Overview of the series:

* The series starts with refactoring how kvm->cfg.ram_size is validated
  and used.

* kvm__arch_validate_cfg() is introduced to allow validation of
  arch-specific command line options.

* Then patch #6 ("builtin_run: Allow standard size specifiers for memory")
  introduced the ability to specify the measurement unit for memory. I
  believe that typing the equivalent of 2TB in megabytes isn't appealing
  for anyone.

* After some more cleanups in the arm/arm64 code, patch #12 ("arm64: Allow
  the user to specify the RAM base address") introduces the ability to
  specify the RAM base address.

* This is followed by the command line argument --firmware-address also
  gaining the ability to use the memory size specifiers, and more kvmtool
  command line validation around the firmware argument.

[1] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/arm-allow-the-user-to-define-ram-address-v1
[2] https://lkml.kernel.org/kvm/1569245722-23375-1-git-send-email-alexandru.elisei@arm.com/

Alexandru Elisei (12):
  Use MB for megabytes consistently
  builtin-run: Always use RAM size in bytes
  builtin-run: Rework RAM size validation
  builtin-run: Add arch hook to validate VM configuration
  arm/arm64: Fail if RAM size is too large for 32-bit guests
  arm/arm64: Kill the ARM_MAX_MEMORY() macro
  arm/arm64: Kill the ARM_HIMAP_MAX_MEMORY() macro
  Introduce kvm__arch_default_ram_address()
  arm64: Allow the user to specify the RAM base address
  arm/arm64: Allow standard size specifiers for firmware address
  arm/arm64: Treat --firmware-address when no --firmware as an error
  arm/arm64: Validate firmware address in kvm__arch_validate_cfg()

Julien Grall (2):
  kvm__arch_init: Remove hugetlbfs_path and ram_size as parameters
  arm/arm64: Consolidate RAM initialization in kvm__init_ram()

Suzuki K Poulose (1):
  builtin_run: Allow standard size specifiers for memory

 Documentation/kvmtool.1                  |   4 +-
 Makefile                                 |   3 +-
 arm/aarch32/include/kvm/kvm-arch.h       |   2 -
 arm/aarch32/kvm.c                        |  14 +++
 arm/aarch64/include/kvm/kvm-arch.h       |  18 +---
 arm/aarch64/kvm.c                        |  19 +++-
 arm/include/arm-common/kvm-arch.h        |   4 +-
 arm/include/arm-common/kvm-config-arch.h |   7 +-
 arm/kvm.c                                | 113 ++++++++++++----------
 builtin-run.c                            | 115 ++++++++++++++++++++---
 include/kvm/kvm-config.h                 |   8 +-
 include/kvm/kvm.h                        |  19 +++-
 kvm.c                                    |   2 +-
 mips/kvm.c                               |  16 +++-
 powerpc/kvm.c                            |  14 ++-
 riscv/kvm.c                              |  16 +++-
 x86/kvm.c                                |  13 ++-
 17 files changed, 284 insertions(+), 103 deletions(-)
 create mode 100644 arm/aarch32/kvm.c

-- 
2.36.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
