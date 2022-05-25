Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D739C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 25 May 2022 11:23:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 633034B2E0;
	Wed, 25 May 2022 07:23:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yGrVbNiw6FCP; Wed, 25 May 2022 07:23:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCF874B2E7;
	Wed, 25 May 2022 07:23:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 848F64B2E0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 07:23:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KA5cRHsVjubF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 May 2022 07:23:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA09C4B2E3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 07:23:37 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 374001FB;
 Wed, 25 May 2022 04:23:37 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 68E093F70D;
 Wed, 25 May 2022 04:23:35 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, andre.przywara@arm.com
Subject: [PATCH v3 kvmtool 00/13] arm64: Allow the user to set RAM base address
Date: Wed, 25 May 2022 12:23:32 +0100
Message-Id: <20220525112345.121321-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.1
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
easy to accomplish, while still being very useful.

Because this series comes after almost three year of changes to kvmtool,
I've decided to drop all the Reviewed-by tags. Thanks to Andre and Suzuki
for reviewing the previous patches, it has been very much appreciated.

What this series does: for arm64, the user can now specify the base address
for RAM:

$ ./lkvm run -m1G@2G .. # Equivalent to ./lkvm run -m1024

The memory units are B (bytes), K (kilobytes), M (megabytes), G
(gigabytes), T (terrabytes), P (petabytes).

Want to put RAM at the top of the physical address range? Easy:

$ ./lkvm run -m2G@1022G .. # Assumes the maximum is 40 bits of IPA

There one limitation on the RAM base address: it must not overlap with the
MMIO range that kvmtool uses, which lives below 2GB.

Why this is useful, in my opinion:

1. Testing how a payload handles different memory layouts without the need
to hack kvmtool or find the hardware that implements the desired layout.

2. It can serve as a development tool for adding support for larger PA
ranges for Linux and KVM (currently capped at 48 bits for 4k/16k pages), or
other payloads.

Summary of the series
======================

* The series starts with refactoring how kvm->cfg.ram_size is validated
  and used, followed by several cleanups in the arm and arm64 code.

* Then patch #9 ("builtin_run: Allow standard size specifiers for memory")
  introduced the ability to specify the measurement unit for memory. I
  believe that typing the equivalent of 2TB in megabytes isn't appealing
  for anyone.

* More cleanups in the arm/arm64 code follow, which are needed for patch
  #13 ("arm64: Allow the user to specify the RAM base address"). This is
  where the ability to specify the RAM base address is introduced.

Testing
=======

I tried to do better at testing the series:

- Built each patch for all architectures (found a compilation error this
  way, patch incoming).

- Ran an x86 kernel with and without setting the amount of RAM using the
  memory specifiers; tested that setting the RAM address results in an
  error.

- Ran an arm64 kernel without setting the size, with setting the size and
  with setting the size and address; tried different addresses (2G, 3G,
  256G); also tested that going below 2G or above the maximum IPA correctly
  results in an error.

- Ran all arm64 kvm-unit-test tests with various combinations of memory
  size and address.

- Ran all arm kvm-unit-tests on an arm64 host with various combinations of
  memory size and address (found another bug, the patch will be sent
  shortly).

Changelog
=========

Since v2:

* Patch #2 ("sizes.h: Make all sizes 64bit") is new (reported by Andre).

* Casted nr_pages to u64 in host_ram_size() to avoid overflows when multiplied
  by page_size on 32-bit systems with more than 2GB of RAM (Andre).

* Initialize ram_addr before parsing the command line options because the
  default was at address 0, which is invalid for arm64 (Andre).

* Fix check for RAM top above 4GB for aarch32 guests.

Since v1:

* Rebased on top of current HEAD (commit 4639b72f61a3 ("arm64: Add
  --vcpu-affinity command line argument")).

* Removed the last 3 patches that touched the --firmware-address command line
  argument. They weren't necessary for this series, I'll resend them after this
  series gets merged.

* Moved patch #8 ("builtin_run: Allow standard size specifiers for memory")
  later in the series (was #6).

[1] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/arm-allow-the-user-to-define-ram-address-v3
[2] https://lkml.kernel.org/kvm/1569245722-23375-1-git-send-email-alexandru.elisei@arm.com/

Alexandru Elisei (10):
  Use MB for megabytes consistently
  sizes.h: Make all sizes 64bit
  builtin-run: Always use RAM size in bytes
  builtin-run: Rework RAM size validation
  builtin-run: Add arch hook to validate VM configuration
  arm/arm64: Fail if RAM size is too large for 32-bit guests
  arm/arm64: Kill the ARM_MAX_MEMORY() macro
  arm/arm64: Kill the ARM_HIMAP_MAX_MEMORY() macro
  Introduce kvm__arch_default_ram_address()
  arm64: Allow the user to specify the RAM base address

Julien Grall (2):
  kvm__arch_init: Remove hugetlbfs_path and ram_size as parameters
  arm/arm64: Consolidate RAM initialization in kvm__init_ram()

Suzuki K Poulose (1):
  builtin_run: Allow standard size specifiers for memory

 Documentation/kvmtool.1            |   4 +-
 Makefile                           |   1 +
 arm/aarch32/include/kvm/kvm-arch.h |   2 -
 arm/aarch32/kvm.c                  |  14 ++++
 arm/aarch64/include/kvm/kvm-arch.h |  18 +----
 arm/aarch64/kvm.c                  |  22 +++++-
 arm/include/arm-common/kvm-arch.h  |   1 -
 arm/kvm.c                          |  60 +++++++-------
 builtin-run.c                      | 122 +++++++++++++++++++++++++----
 include/kvm/kvm-config.h           |   8 +-
 include/kvm/kvm.h                  |  18 ++++-
 include/linux/sizes.h              |  66 ++++++++--------
 kvm.c                              |   2 +-
 mips/kvm.c                         |  16 +++-
 powerpc/kvm.c                      |  14 +++-
 riscv/kvm.c                        |  16 +++-
 x86/kvm.c                          |  13 ++-
 17 files changed, 285 insertions(+), 112 deletions(-)
 create mode 100644 arm/aarch32/kvm.c

-- 
2.35.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
