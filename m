From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [kvm-unit-tests PATCH 00/10] arm/arm64: add gic framework
Date: Wed, 18 May 2016 11:07:14 +0200
Message-ID: <20160518090714.GA3827@cbox>
References: <1463385444-12916-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FF5E411BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 05:03:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hYX9hCgrx1DV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2016 05:03:12 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EA70410B5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 05:03:12 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id a17so68750098wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 02:06:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1463385444-12916-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

Thanks for doing this.  I'm happy to see some tests for the GIC.

I've been pondering with how to write unit tests for all the MMIO
implementations.  If you have some thoughts on how that could be easily
fitted into this framework, that would probably be a good place to do it
;)

-Christoffer

On Mon, May 16, 2016 at 09:57:14AM +0200, Andrew Jones wrote:
> Import defines, and steal enough helper functions, from Linux to
> enable programming of the gic (v2 and v3). Then use the framework
> to add an initial test (an ipi test; self, target-list, broadcast).
> 
> It's my hope that this framework will be a suitable base on which
> more tests may be easily added, particularly because we have
> vgic-new and tcg gicv3 emulation getting close to merge.
> 
> To run it, along with other tests, just do
> 
>  ./configure [ --arch=[arm|arm64] --cross-prefix=$PREFIX ]
>  make
>  export QEMU=$PATH_TO_QEMU
>  ./run_tests.sh
> 
> To run it separately do, e.g.
> 
> $QEMU -machine virt,accel=tcg -cpu cortex-a57 \
>  -device virtio-serial-device \
>  -device virtconsole,chardev=ctd -chardev testdev,id=ctd \
>  -display none -serial stdio \
>  -kernel arm/gic.flat \
>  -smp 123 -machine gic-version=3 -append ipi
> 
>       ^^ note, we can go nuts with nr-cpus on TCG :-)
> 
> Or, a KVM example using a different "sender" cpu and irq (other than zero)
> 
> $QEMU -machine virt,accel=kvm -cpu host \
>  -device virtio-serial-device \
>  -device virtconsole,chardev=ctd -chardev testdev,id=ctd \
>  -display none -serial stdio \
>  -kernel arm/gic.flat \
>  -smp 48 -machine gic-version=3 -append 'ipi sender=42 irq=1'
> 
> 
> Patches:
> 01-05: fixes and functionality needed by the later gic patches
> 06-07: code theft from Linux (defines, helper functions)
> 08-10: arm/gic.flat (the base of the gic unit test), currently just IPI
> 
> Available here: https://github.com/rhdrjones/kvm-unit-tests/commits/arm/gic
> 
> 
> Andrew Jones (10):
>   lib: xstr: allow multiple args
>   arm64: fix get_"sysreg32" and make MPIDR 64bit
>   arm/arm64: smp: support more than 8 cpus
>   arm/arm64: add some delay routines
>   arm/arm64: irq enable/disable
>   arm/arm64: add initial gicv2 support
>   arm64: add initial gicv3 support
>   arm/arm64: gicv2: add an IPI test
>   arm/arm64: gicv3: add an IPI test
>   arm/arm64: gic: don't just use zero
> 
>  arm/Makefile.common        |   7 +-
>  arm/gic.c                  | 338 +++++++++++++++++++++++++++++++++++++++++++++
>  arm/run                    |  19 ++-
>  arm/selftest.c             |   5 +-
>  arm/unittests.cfg          |  13 ++
>  lib/arm/asm/arch_gicv3.h   | 184 ++++++++++++++++++++++++
>  lib/arm/asm/gic-v2.h       |  74 ++++++++++
>  lib/arm/asm/gic-v3.h       | 320 ++++++++++++++++++++++++++++++++++++++++++
>  lib/arm/asm/gic.h          |  21 +++
>  lib/arm/asm/processor.h    |  38 ++++-
>  lib/arm/asm/setup.h        |   4 +-
>  lib/arm/gic.c              | 127 +++++++++++++++++
>  lib/arm/processor.c        |  15 ++
>  lib/arm/setup.c            |  12 +-
>  lib/arm64/asm/arch_gicv3.h | 169 +++++++++++++++++++++++
>  lib/arm64/asm/gic-v2.h     |   1 +
>  lib/arm64/asm/gic-v3.h     |   1 +
>  lib/arm64/asm/gic.h        |   1 +
>  lib/arm64/asm/processor.h  |  53 +++++--
>  lib/arm64/asm/sysreg.h     |  44 ++++++
>  lib/arm64/processor.c      |  15 ++
>  lib/libcflat.h             |   4 +-
>  22 files changed, 1439 insertions(+), 26 deletions(-)
>  create mode 100644 arm/gic.c
>  create mode 100644 lib/arm/asm/arch_gicv3.h
>  create mode 100644 lib/arm/asm/gic-v2.h
>  create mode 100644 lib/arm/asm/gic-v3.h
>  create mode 100644 lib/arm/asm/gic.h
>  create mode 100644 lib/arm/gic.c
>  create mode 100644 lib/arm64/asm/arch_gicv3.h
>  create mode 100644 lib/arm64/asm/gic-v2.h
>  create mode 100644 lib/arm64/asm/gic-v3.h
>  create mode 100644 lib/arm64/asm/gic.h
>  create mode 100644 lib/arm64/asm/sysreg.h
> 
> -- 
> 2.4.11
> 
