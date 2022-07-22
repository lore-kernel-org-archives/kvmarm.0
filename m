Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB2AC43334
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 14:14:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16AD44CCA8;
	Fri, 22 Jul 2022 10:14:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xfb1zXBd+TJw; Fri, 22 Jul 2022 10:14:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56C974CCCB;
	Fri, 22 Jul 2022 10:14:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F7594CCA0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 10:14:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SUaaIM9q3VAi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2022 10:14:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89B394CC83
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 10:14:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BD6D1063;
 Fri, 22 Jul 2022 07:14:18 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15AFF3F70D;
 Fri, 22 Jul 2022 07:14:15 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 andre.przywara@arm.com, suzuki.poulose@arm.com, james.morse@arm.com,
 vladimir.murzin@arm.com, anup@brainfault.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvmtool 0/1] Introduce LIBFDT_DIR
Date: Fri, 22 Jul 2022 15:14:47 +0100
Message-Id: <20220722141448.168252-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.0
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

This is based on the series that added the libfdt source files to the
kvmtool tree [1]. I've reconsidered the feedback I got from Andre and Will,
and so I came up with a different approach: the user can opt to compile
libdt without installing it system-wide and use LIBFDT_DIR to point kvmtool
to the static version of the library.

For example, to cross-compile for arm64:

$ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LIBFDT_DIR=libfdt-arm64

For riscv:

$ make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- LIBFDT_DIR=libfdt-riscv

where libfdt-arm64 and libfdt-riscv are the patch to libfdt compiled for
the arm64 and, respectively, the riscv architectures.

This approach is complementary to using the system libraries, it does not
replace them entirely like the previous approach.

Why is introducing LIBFDT_DIR a good idea? One might rightly argue that
installing the library requires only three extra instructions. The obvious
answer is that the user doesn't have the necessary permissions to install
the library.

And then is the fact that on my x86 machine I tried to install the shared
library for powerpc with two different compilers and I failed. When using
the bootlin stable compiler [2] (gcc-10.3.0) I got this error after
following the instructions in INSTALL:

         [..]
	 LD fdtget
/usr/bin/ld: libfdt/libfdt-1.6.1.so: error adding symbols: file in wrong format
collect2: error: ld returned 1 exit status
make: *** [Makefile:346: fdtget] Error 1

When using the powerpc64 crosscompiled from kernel.org [3], I wasn't even
able to compile libfdt because the cross-compiler is missing libc:

         [..]
	 CC libfdt/fdt.o
In file included from libfdt/libfdt_env.h:12,
                 from libfdt/fdt.c:6:
/home/alex/data/cross-compilers/x86-host/powerpc64-gcc-12.1.0-nolibc/powerpc64-linux/lib/gcc/powerpc64-linux/12.1.0/include/stdint.h:9:16: fatal error: stdint.h: No such file or directory
    9 | # include_next <stdint.h>
      |                ^~~~~~~~~~
compilation terminated.
make: *** [Makefile:350: libfdt/fdt.o] Error 1

[1] https://lore.kernel.org/linux-arm-kernel/20220526171955.145563-1-alexandru.elisei@arm.com/
[2] https://toolchains.bootlin.com/
[3] https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/12.1.0/

Alexandru Elisei (1):
  Makefile: Introduce LIBFDT_DIR to specify libfdt location

 INSTALL  | 12 +++++++++++-
 Makefile | 29 ++++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 8 deletions(-)

-- 
2.37.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
