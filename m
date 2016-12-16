From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Fri, 16 Dec 2016 12:14:45 +0100
Message-ID: <3302470.IDcDrWa0u6@wuerfel>
References: <20161216105634.235457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C821F404BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 06:13:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9UnpHLuIJGdb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 06:13:40 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B336401F2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 06:13:40 -0500 (EST)
In-Reply-To: <20161216105634.235457-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arch@vger.kernel.org
Cc: kernel-build-reports@lists.linaro.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

[Fixed linux-arm-kernel mailing list address, sorry for the duplicate,
 I'm not reposting all the ugly patches though, unless someone really
 wants them, https://lkml.org/lkml/2016/12/16/174 has a copy]

On Friday, December 16, 2016 11:56:21 AM CET Arnd Bergmann wrote:
> I had some fun doing build testing with older gcc versions, building
> every release from 4.0 through 7.0 and running that on my randconfig
> setup to see what comes out.
> 
> First of all, gcc-4.9 and higher is basically warning-free everywhere,
> although gcc-7 introduces some interesting new warnings (I have started
> doing patches for those as well). gcc-4.8 is probably good, too, and
> gcc-4.6 and 4.7 at least don't produce build failures in general, though
> the level of false-positive warnings increases (we could decide to turn
> those off for older compilers for build test purposes).
> 
> In gcc-4.5 and below, dead code elimination is not as good as later,
> causing a couple of link errors, and some of them have no good workaround
> (see patch 1). It would be nice to declare that version too old, but
> several older distros that are still in wide use ship with compilers
> earlier than 4.6:
> 
>  RHEL6:		gcc-4.4
>  Debian 6:	gcc-4.4
>  Ubuntu 10.04:	gcc-4.4
>  SLES11:	gcc-4.3
> 
> With gcc-4.3, we need a couple of workaround patches beyond the problem
> mentioned above, more configuration options are unavailable and we get
> a significant number of false-positive warnings, but it's not much worse
> than gcc-4.5 otherwise.
> 
> These are the options I had to disable to get gcc-4.3 randconfig builds
> working:
> 
>  CONFIG_HAVE_GCC_PLUGINS
>  CONFIG_CC_STACKPROTECTOR_STRONG
>  CONFIG_ARM_SINGLE_ARMV7M
>  CONFIG_THUMB2_KERNEL
>  CONFIG_KERNEL_MODE_NEON
>  CONFIG_VDSO
>  CONFIG_FUNCTION_TRACER (with CONFIG_FRAME_POINTER=n)
> 
> I have not checked in detail which version is required for
> each of the above.
> 
> Specifically on ARM, going further makes things rather useless especially
> for build testing: with gcc-4.2, we lose support for ARMv7, EABI, and
> effectively ARMv6 (as it relies on EABI for building reliably). Also,
> the number of false-positive build warnings is so high that it is useless
> for finding actual bugs from the warnings.
> 
> See the replies to this mail for 13 patches I needed to work around
> issues for each of the releases before 4.6. I have also submitted
> some separate patches for issues that I considered actual bugs
> uncovered by the older compilers and that should be applied regardless.
> 
> The original gcc-4.3 release was in early 2008. If we decide to still
> support that, we probably want the first 10 quirks in this series,
> while gcc-4.6 (released in 2011) requires none of them.
> 
> 	Arnd
> 
> Arnd Bergmann (13):
>   [HACK] gcc-4.5: avoid  link errors for unused function pointers
>   KVM: arm: fix gcc-4.5 build
>   ARM: div64: fix building with gcc-4.5 and lower
>   vfio-pci: use 32-bit comparisons for register address for gcc-4.5
>   clk: pxa: fix gcc-4.4 build
>   ARM: atomic: fix gcc-4.4 build
>   watchdog: kempld: fix gcc-4.3 build
>   arm/arm64: xen: avoid gcc-4.4 warning
>   ARM: mark cmpxchg and xchg __always_inline for gcc-4.3
>   asm-generic: mark cmpxchg as __always_inline for gcc-4.3
>   fs: fix unsigned enum warning with gcc-4.2
>   KVM: arm: avoid binary number literals for gcc-4.2
>   ARM: avoid 'Q' asm constraint for gcc-4.1 and earlier
> 
>  arch/arm/include/asm/atomic.h        | 10 ++++++++--
>  arch/arm/include/asm/cmpxchg.h       | 12 ++++++------
>  arch/arm/include/asm/div64.h         | 17 +++--------------
>  arch/arm/include/asm/io.h            |  8 ++++++++
>  arch/arm/include/asm/kvm_mmu.h       |  2 +-
>  arch/arm/include/asm/percpu.h        |  5 ++++-
>  arch/arm/mach-imx/pm-imx5.c          | 20 ++++++++++++++++----
>  arch/arm/mach-sa1100/pm.c            |  2 ++
>  arch/arm/plat-samsung/pm.c           |  4 ++++
>  drivers/clk/pxa/clk-pxa.c            |  3 +--
>  drivers/dma/ti-dma-crossbar.c        |  4 ++++
>  drivers/firmware/psci_checker.c      |  3 +++
>  drivers/iio/adc/exynos_adc.c         |  3 +++
>  drivers/net/ethernet/via/via-rhine.c |  6 ++++++
>  drivers/vfio/pci/vfio_pci_rdwr.c     |  5 ++++-
>  drivers/watchdog/kempld_wdt.c        |  9 ++++++++-
>  include/asm-generic/cmpxchg-local.h  |  7 ++++---
>  include/linux/fs.h                   |  2 +-
>  include/xen/arm/page.h               |  1 +
>  virt/kvm/arm/vgic/vgic-its.c         |  4 ++--
>  virt/kvm/arm/vgic/vgic-mmio-v3.c     |  8 ++++----
>  virt/kvm/arm/vgic/vgic-mmio.c        | 16 ++++++++--------
>  virt/kvm/arm/vgic/vgic-mmio.h        | 12 ++++++------
>  23 files changed, 107 insertions(+), 56 deletions(-)
> 
> 
