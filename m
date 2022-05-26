Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27CDC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 26 May 2022 16:45:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 252204B268;
	Thu, 26 May 2022 12:45:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ps2PyeUYCEa1; Thu, 26 May 2022 12:45:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59A7B4B2C0;
	Thu, 26 May 2022 12:45:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9B4649B0A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 12:45:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pknMF70jl7pt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 May 2022 12:45:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDB9149B07
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 12:45:09 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56ED0150C;
 Thu, 26 May 2022 09:45:09 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85F563F70D;
 Thu, 26 May 2022 09:45:07 -0700 (PDT)
Date: Thu, 26 May 2022 17:45:18 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 0/2] Add libfdt library
Message-ID: <Yo+unlKaEqycwCC1@monolith.localdoman>
References: <20220526153058.123290-1-alexandru.elisei@arm.com>
 <20220526165907.0e34c075@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220526165907.0e34c075@donnerap.cambridge.arm.com>
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

Hi,

On Thu, May 26, 2022 at 04:59:07PM +0100, Andre Przywara wrote:
> On Thu, 26 May 2022 16:30:56 +0100
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> 
> Hi Alex,
> 
> > I found it very difficult to cross-build kvmtool for all arches because for
> > some architectures I couldn't get libfdt to install: either dtc wasn't
> > compiling (x86 machine, Arch Linux, missing yaml.h include when building
> > for arm and powerpc), or libfdt was not being found by Makefile after
> > installing it (x86 machine, Debian 11, building for powerpc). It was
> > possible to compile only libfdt and teach Makefile where to look for it,
> > which is what I ended up doing, but in my opinion, that's not an ideal user
> > experience.
> 
> Meh. Nobody said that userland cross compilation would be a walk in the
> park, and this approach (cross-compiling and putting in SYSROOT) is the
> canonical approach. When using a multiarch capable distro, this is easy
> enough.

Except when it doesn't work. On debian 11 I was not able to make it work for
powerpc by following the instructions, while I was able to make it work for
aarch64 following the same instructions. That's the kind of thing that I would
like to avoid.

> But I see that this is some major pain point for an otherwise rather "low
> maintenance" tool, and libfdt is designed to be embedded, so I guess this
> is fine, with the caveat mentioned below.
> 
> > This is my attempt at making compilation easier by pulling in the libfdt
> > library and having kvmtool compile it when an architecture requires it. All
> > the user needs to do now is to find a suitable cross-compiler toolchain
> > with glibc included [1]*.
> > 
> > When making lkvm-static, the static version of libfdt is built (libfdt.a);
> > for all other make targets the shared library is built.
> 
> So does that mean that the .so gets shipped with kvmtool? And it should be

Err.. I screwed up badly here, I just checked with ldd and lkvm was still
using the system proved libfdt.so, that's why it was still working.
Uninstalling the libfdt package broke lkvm.

> installed as part of "make install"? I think that might bring up more
> questions and problems, so do we want to leave the user some choice?
> - The user brings their own libfdt. This should be the case for any clean
> userland cross compilation, where you install target libraries in SYSROOT,
> just for compilation, and have the .so file also on the actual target
> system. This would also be best for native compilation. Current situation.
> - The user decides to use the built-in libfdt, in which case that gets
> always statically linked into the lkvm binary (which might still be
> dynamically linked against libc), to avoid any conflict between the just
> built version (.so), and the installed library on the target system.
> 
> Some projects choose this approach, where it gets decided at build time
> which version to use ("system library" vs. built-in version). This is
> either done automatically, because a system library is not found, or using
> some user provided flag for configure/make.
> 
> If that sounds too involved, we could just always link in our libfdt copy
> statically. And later revisit this when people complain.

I would prefer this approach, as it keeps things the Makefile simple and it
makes the build reproducible.

> Can you check by how much an otherwise dynamically linked kvmtool binary
> grows when we link against libfdt.a?

I wrote a patch to always link against libfdt.a, here are the results of
running make on a rockpro64 (I renamed the executables to tell which is
which).

Built from current master:

$ /usr/bin/ls -l lkvm-libfdt-dynamically-linked
-rwxr-xr-x 1 alex users 2127112 May 26 16:31 lkvm-libfdt-dynamically-linked
$ ldd lkvm-libfdt-dynamically-linked
	linux-vdso.so.1 (0x0000ffffb52ae000)
	libz.so.1 => /usr/lib/libz.so.1 (0x0000ffffb5140000)
	libaio.so.1 => /usr/lib/libaio.so.1 (0x0000ffffb5120000)
	libfdt.so.1 => /usr/lib/libfdt.so.1 (0x0000ffffb5100000)
	libc.so.6 => /usr/lib/libc.so.6 (0x0000ffffb4f50000)
	/lib/ld-linux-aarch64.so.1 => /usr/lib/ld-linux-aarch64.so.1 (0x0000ffffb5275000)

Built with Makefile modified to link against the static version:

$ /usr/bin/ls -l lkvm-libfdt-statically-linked
-rwxr-xr-x 1 alex users 2238920 May 26 16:32 lkvm-libfdt-statically-linked
$ ldd lkvm-libfdt-statically-linked
	linux-vdso.so.1 (0x0000ffff99a6d000)
	libz.so.1 => /usr/lib/libz.so.1 (0x0000ffff99900000)
	libaio.so.1 => /usr/lib/libaio.so.1 (0x0000ffff998e0000)
	libc.so.6 => /usr/lib/libc.so.6 (0x0000ffff99730000)
	/lib/ld-linux-aarch64.so.1 => /usr/lib/ld-linux-aarch64.so.1 (0x0000ffff99a34000)

A difference of 109KB (111808 bytes to be more exact).

I'll send the changes to the Makefile in case people want to play with it.

Thanks,
Alex

> 
> Cheers,
> Andre
> 
> > This only happens
> > for those arches that require libfdt (arm, arm64, riscv, powerpc); libfdt
> > is not built for MIPS and x86.
> > 
> > I am pretty happy with how libfdt has been integrated with the kvmtool
> > build system. The only niggle is that the libfdt_clean target echoes the
> > commands to remove the build artifacts:
> > 
> > $ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- clean
> > Makefile:378: Skipping optional libraries: bfd zlib aio
> >   CLEAN (libfdt)
> > rm -f libfdt/*.o libfdt/libfdt.a libfdt/libfdt-1.6.1.so
> > rm -f libfdt/libfdt.so.1
> >   CLEAN
> > 
> > but I believe that's impossible to change without modifying the libfdt
> > Makefile, which I don't want to do to keep it as easy as possible to update
> > libfdt.
> > 
> > Made some quick measurement about how libfdt affects the build time when
> > building from a clean directory (incremental builds do not rebuild libfdt):
> > 
> > - On a rockpro64, on the little core (Cortex-A53), running
> > 
> > $ time taskset -c 0 make
> > 
> > with libfdt takes an average of 90.721s (averaged over 3 runs, standard
> > deviation 0.040s); without libfdt it takes 84.003s (averaged over 3 runs,
> > stddev of 0.105s). That's a 6.718s absolute increase, or a 7.997% relative
> > increase.
> > 
> > - On the same rockpro64, on the big core (Cortex-A72), running
> > 
> > $ time taskset -c 5 make
> > 
> > with libfdt takes an average of 45.078s (averaged over 3 runs, stddev of
> > 0.060s); without libfdt it takes 41.836s (averaged over 3 runs, stddev of
> > 0.065). That's a 3.242s absolute increase, or a 7.749% relative increase.
> > 
> > I believe that the ease of use more than justifies the increased
> > compilation time.
> > 
> > Testing
> > =======
> > 
> > On x86 host, compiled for x86, MIPS, arm, arm64, powerpc, riscv. Booted an
> > x86 VM.
> > 
> > On arm64 host, compiled for arm64 and arm. I tried to cross-compile for
> > other targets, but I couldn't find a cross-compiler toolchain for arm64
> > hosts that included a libc implementation. The arm cross-compiler was
> > downloaded from the developer.arm.com [2]. Ran kvm-unit-tests for arm64 and
> > arm (on the arm64 version of kvmtool), and also booted a kernel.
> > 
> > *only for x86 hosts.
> > 
> > [1] https://toolchains.bootlin.com/
> > [2] https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/downloads
> > 
> > Alexandru Elisei (2):
> >   Add libfdt library
> >   INSTALL: Remove all mentions of libfdt
> > 
> >  INSTALL                  |   27 +-
> >  Makefile                 |   53 +-
> >  libfdt/.gitignore        |    1 +
> >  libfdt/Makefile.libfdt   |   18 +
> >  libfdt/TODO              |    3 +
> >  libfdt/fdt.c             |  335 ++++++
> >  libfdt/fdt.h             |   66 ++
> >  libfdt/fdt_addresses.c   |  101 ++
> >  libfdt/fdt_check.c       |   93 ++
> >  libfdt/fdt_empty_tree.c  |   38 +
> >  libfdt/fdt_overlay.c     |  867 +++++++++++++++
> >  libfdt/fdt_ro.c          |  859 +++++++++++++++
> >  libfdt/fdt_rw.c          |  500 +++++++++
> >  libfdt/fdt_strerror.c    |   60 ++
> >  libfdt/fdt_sw.c          |  384 +++++++
> >  libfdt/fdt_wip.c         |   94 ++
> >  libfdt/libfdt.h          | 2147 ++++++++++++++++++++++++++++++++++++++
> >  libfdt/libfdt_env.h      |   96 ++
> >  libfdt/libfdt_internal.h |  192 ++++
> >  libfdt/meson.build       |   55 +
> >  libfdt/version.lds       |   83 ++
> >  21 files changed, 6033 insertions(+), 39 deletions(-)
> >  create mode 100644 libfdt/.gitignore
> >  create mode 100644 libfdt/Makefile.libfdt
> >  create mode 100644 libfdt/TODO
> >  create mode 100644 libfdt/fdt.c
> >  create mode 100644 libfdt/fdt.h
> >  create mode 100644 libfdt/fdt_addresses.c
> >  create mode 100644 libfdt/fdt_check.c
> >  create mode 100644 libfdt/fdt_empty_tree.c
> >  create mode 100644 libfdt/fdt_overlay.c
> >  create mode 100644 libfdt/fdt_ro.c
> >  create mode 100644 libfdt/fdt_rw.c
> >  create mode 100644 libfdt/fdt_strerror.c
> >  create mode 100644 libfdt/fdt_sw.c
> >  create mode 100644 libfdt/fdt_wip.c
> >  create mode 100644 libfdt/libfdt.h
> >  create mode 100644 libfdt/libfdt_env.h
> >  create mode 100644 libfdt/libfdt_internal.h
> >  create mode 100644 libfdt/meson.build
> >  create mode 100644 libfdt/version.lds
> > 
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
