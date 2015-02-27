From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 00/18] arm/arm64: add smp support
Date: Thu, 26 Feb 2015 21:46:56 -0300
Message-ID: <20150227004656.GA12325@amt.cnet>
References: <1422815686-24591-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1422815686-24591-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Feb 01, 2015 at 07:34:28PM +0100, Andrew Jones wrote:
> This series extends the kvm-unit-tests/arm[64] framework to support smp.
> A break down of the patches is as follows
> 
> 01-02: prepare general framework for smp use
> 03-06: arm/arm64 fixups not 100% related to this series,
>        but need to post some time...
> 07-09: add thread_info (for per-thread data) and suck some global
>        data into it
> 10-11: add cpumask support (for per-cpu data) and suck some more
>        global data in
>    12: add arm64 simple spinlock implementation
> 13-14: add some PSCI support
> 15-16: further prep for smp_boot_secondary
>    17: finally add smp_boot_secondary
>    18: as usual, add a selftest to make sure it all works
> 
> These patches are also available here:
> https://github.com/rhdrjones/kvm-unit-tests/tree/arm/smp
> 
> Thanks in advance for reviews!
> 
> 
> Andrew Jones (18):
>   x86: expose spin_lock/unlock to lib code
>   lib/report: guard access to counters
>   arm: fixups: add barriers, actually set MAIR
>   arm64: fixup: use id_aa64mmfr0_el1 to set tcr
>   arm/arm64: processor.[ch] cleanups
>   arm/arm64: get rid of get_sp()
>   arm/arm64: introduce thread_info
>   arm/arm64: add per thread user_mode flag
>   arm/arm64: maintain per thread exception handlers
>   arm/arm64: add simple cpumask API
>   arm/arm64: make mmu_on per cpu
>   arm64: implement spinlocks
>   arm/arm64: import include/uapi/linux/psci.h
>   arm/arm64: add some PSCI API
>   arm/arm64: add cpu_relax() and friends
>   arm: clarify comment about exception stack use
>   arm/arm64: add smp_boot_secondary
>   arm/arm64: Add smp selftest
> 
>  arm/cstart.S                 |  47 +++++++++++++----
>  arm/cstart64.S               |  48 +++++++++++-------
>  arm/flat.lds                 |   6 +++
>  arm/selftest.c               |  70 +++++++++++++++++++++++--
>  arm/unittests.cfg            |  11 +++-
>  config/config-arm-common.mak |   3 ++
>  config/config-arm64.mak      |   1 +
>  lib/arm/asm-offsets.c        |   3 ++
>  lib/arm/asm/barrier.h        |   5 ++
>  lib/arm/asm/bitops.h         |  53 +++++++++++++++++++
>  lib/arm/asm/cpumask.h        | 118 +++++++++++++++++++++++++++++++++++++++++++
>  lib/arm/asm/mmu-api.h        |   1 +
>  lib/arm/asm/processor.h      |  12 ++++-
>  lib/arm/asm/psci.h           |  15 ++++++
>  lib/arm/asm/smp.h            |  56 ++++++++++++++++++++
>  lib/arm/asm/thread_info.h    |  60 ++++++++++++++++++++++
>  lib/arm/asm/uapi-psci.h      |  73 ++++++++++++++++++++++++++
>  lib/arm/bitops.c             |  81 +++++++++++++++++++++++++++++
>  lib/arm/mmu.c                |  15 ++++--
>  lib/arm/processor.c          |  44 +++++++++++-----
>  lib/arm/psci.c               |  49 ++++++++++++++++++
>  lib/arm/setup.c              |  11 +++-
>  lib/arm/smp.c                |  57 +++++++++++++++++++++
>  lib/arm64/asm-offsets.c      |   2 +
>  lib/arm64/asm/barrier.h      |   5 ++
>  lib/arm64/asm/bitops.h       |  51 +++++++++++++++++++
>  lib/arm64/asm/cpumask.h      |   1 +
>  lib/arm64/asm/processor.h    |  18 ++++++-
>  lib/arm64/asm/psci.h         |  15 ++++++
>  lib/arm64/asm/smp.h          |   1 +
>  lib/arm64/asm/spinlock.h     |   8 +--
>  lib/arm64/asm/thread_info.h  |   1 +
>  lib/arm64/asm/uapi-psci.h    |   1 +
>  lib/arm64/processor.c        |  81 +++++++++++++++++++----------
>  lib/arm64/spinlock.c         |  43 ++++++++++++++++
>  lib/report.c                 |  16 ++++++
>  lib/x86/asm/spinlock.h       |  11 ++++
>  lib/x86/smp.h                |   7 +--
>  38 files changed, 1008 insertions(+), 92 deletions(-)
>  create mode 100644 lib/arm/asm/bitops.h
>  create mode 100644 lib/arm/asm/cpumask.h
>  create mode 100644 lib/arm/asm/psci.h
>  create mode 100644 lib/arm/asm/smp.h
>  create mode 100644 lib/arm/asm/thread_info.h
>  create mode 100644 lib/arm/asm/uapi-psci.h
>  create mode 100644 lib/arm/bitops.c
>  create mode 100644 lib/arm/psci.c
>  create mode 100644 lib/arm/smp.c
>  create mode 100644 lib/arm64/asm/bitops.h
>  create mode 100644 lib/arm64/asm/cpumask.h
>  create mode 100644 lib/arm64/asm/psci.h
>  create mode 100644 lib/arm64/asm/smp.h
>  create mode 100644 lib/arm64/asm/thread_info.h
>  create mode 100644 lib/arm64/asm/uapi-psci.h
>  create mode 100644 lib/arm64/spinlock.c
>  create mode 100644 lib/x86/asm/spinlock.h
> 
> -- 
> 1.9.3

Applied, thanks.

