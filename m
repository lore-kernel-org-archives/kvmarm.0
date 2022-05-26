Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9A1C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 26 May 2022 15:30:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44FF849F01;
	Thu, 26 May 2022 11:30:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gSoVPAWSZaJm; Thu, 26 May 2022 11:30:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF04149F2C;
	Thu, 26 May 2022 11:30:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4415F49EF0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 11:30:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZerWemlZyE7I for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 May 2022 11:30:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FFF549EDF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 11:30:51 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2CE31688;
 Thu, 26 May 2022 08:30:50 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A1793F66F;
 Thu, 26 May 2022 08:30:49 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 andre.przywara@arm.com, suzuki.poulose@arm.com, james.morse@arm.com,
 vladimir.murzin@arm.com, anup@brainfault.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvmtool 0/2] Add libfdt library
Date: Thu, 26 May 2022 16:30:56 +0100
Message-Id: <20220526153058.123290-1-alexandru.elisei@arm.com>
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

I found it very difficult to cross-build kvmtool for all arches because for
some architectures I couldn't get libfdt to install: either dtc wasn't
compiling (x86 machine, Arch Linux, missing yaml.h include when building
for arm and powerpc), or libfdt was not being found by Makefile after
installing it (x86 machine, Debian 11, building for powerpc). It was
possible to compile only libfdt and teach Makefile where to look for it,
which is what I ended up doing, but in my opinion, that's not an ideal user
experience.

This is my attempt at making compilation easier by pulling in the libfdt
library and having kvmtool compile it when an architecture requires it. All
the user needs to do now is to find a suitable cross-compiler toolchain
with glibc included [1]*.

When making lkvm-static, the static version of libfdt is built (libfdt.a);
for all other make targets the shared library is built. This only happens
for those arches that require libfdt (arm, arm64, riscv, powerpc); libfdt
is not built for MIPS and x86.

I am pretty happy with how libfdt has been integrated with the kvmtool
build system. The only niggle is that the libfdt_clean target echoes the
commands to remove the build artifacts:

$ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- clean
Makefile:378: Skipping optional libraries: bfd zlib aio
  CLEAN (libfdt)
rm -f libfdt/*.o libfdt/libfdt.a libfdt/libfdt-1.6.1.so
rm -f libfdt/libfdt.so.1
  CLEAN

but I believe that's impossible to change without modifying the libfdt
Makefile, which I don't want to do to keep it as easy as possible to update
libfdt.

Made some quick measurement about how libfdt affects the build time when
building from a clean directory (incremental builds do not rebuild libfdt):

- On a rockpro64, on the little core (Cortex-A53), running

$ time taskset -c 0 make

with libfdt takes an average of 90.721s (averaged over 3 runs, standard
deviation 0.040s); without libfdt it takes 84.003s (averaged over 3 runs,
stddev of 0.105s). That's a 6.718s absolute increase, or a 7.997% relative
increase.

- On the same rockpro64, on the big core (Cortex-A72), running

$ time taskset -c 5 make

with libfdt takes an average of 45.078s (averaged over 3 runs, stddev of
0.060s); without libfdt it takes 41.836s (averaged over 3 runs, stddev of
0.065). That's a 3.242s absolute increase, or a 7.749% relative increase.

I believe that the ease of use more than justifies the increased
compilation time.

Testing
=======

On x86 host, compiled for x86, MIPS, arm, arm64, powerpc, riscv. Booted an
x86 VM.

On arm64 host, compiled for arm64 and arm. I tried to cross-compile for
other targets, but I couldn't find a cross-compiler toolchain for arm64
hosts that included a libc implementation. The arm cross-compiler was
downloaded from the developer.arm.com [2]. Ran kvm-unit-tests for arm64 and
arm (on the arm64 version of kvmtool), and also booted a kernel.

*only for x86 hosts.

[1] https://toolchains.bootlin.com/
[2] https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/downloads

Alexandru Elisei (2):
  Add libfdt library
  INSTALL: Remove all mentions of libfdt

 INSTALL                  |   27 +-
 Makefile                 |   53 +-
 libfdt/.gitignore        |    1 +
 libfdt/Makefile.libfdt   |   18 +
 libfdt/TODO              |    3 +
 libfdt/fdt.c             |  335 ++++++
 libfdt/fdt.h             |   66 ++
 libfdt/fdt_addresses.c   |  101 ++
 libfdt/fdt_check.c       |   93 ++
 libfdt/fdt_empty_tree.c  |   38 +
 libfdt/fdt_overlay.c     |  867 +++++++++++++++
 libfdt/fdt_ro.c          |  859 +++++++++++++++
 libfdt/fdt_rw.c          |  500 +++++++++
 libfdt/fdt_strerror.c    |   60 ++
 libfdt/fdt_sw.c          |  384 +++++++
 libfdt/fdt_wip.c         |   94 ++
 libfdt/libfdt.h          | 2147 ++++++++++++++++++++++++++++++++++++++
 libfdt/libfdt_env.h      |   96 ++
 libfdt/libfdt_internal.h |  192 ++++
 libfdt/meson.build       |   55 +
 libfdt/version.lds       |   83 ++
 21 files changed, 6033 insertions(+), 39 deletions(-)
 create mode 100644 libfdt/.gitignore
 create mode 100644 libfdt/Makefile.libfdt
 create mode 100644 libfdt/TODO
 create mode 100644 libfdt/fdt.c
 create mode 100644 libfdt/fdt.h
 create mode 100644 libfdt/fdt_addresses.c
 create mode 100644 libfdt/fdt_check.c
 create mode 100644 libfdt/fdt_empty_tree.c
 create mode 100644 libfdt/fdt_overlay.c
 create mode 100644 libfdt/fdt_ro.c
 create mode 100644 libfdt/fdt_rw.c
 create mode 100644 libfdt/fdt_strerror.c
 create mode 100644 libfdt/fdt_sw.c
 create mode 100644 libfdt/fdt_wip.c
 create mode 100644 libfdt/libfdt.h
 create mode 100644 libfdt/libfdt_env.h
 create mode 100644 libfdt/libfdt_internal.h
 create mode 100644 libfdt/meson.build
 create mode 100644 libfdt/version.lds

-- 
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
