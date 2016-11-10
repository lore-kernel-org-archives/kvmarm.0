From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v4 00/11] arm/arm64: add gic framework
Date: Thu, 10 Nov 2016 18:18:37 +0100
Message-ID: <20161110171837.c6f75le4twifrigp@hawk.localdomain>
References: <1478794084-5273-1-git-send-email-drjones@redhat.com>
 <77355b5b-9e26-16f9-4243-e11ef4d4c8ce@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31BE14042E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 12:18:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pKvI80giutN5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2016 12:18:20 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C7D3402A6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 12:18:20 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <77355b5b-9e26-16f9-4243-e11ef4d4c8ce@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 10, 2016 at 04:52:30PM +0000, Andre Przywara wrote:
> Hi,
> 
> so is this actually v4 just resent?
> Or is this is a new version with s/5/4/?
> I can't spot any of the key changes quickly ...

Argh... Forgot to edit my bash history after pulling it up to send.
OK, the real v5 is coming...

Thanks,
Your Friendly Spammer

> 
> Cheers,
> Andre.
> 
> On 10/11/16 16:07, Andrew Jones wrote:
> > v4:
> >  - Eric's r-b's
> >  - Andre's suggestion to only take defines we need
> >  - several other changes listed in individual patches
> > 
> > v3:
> >  - Rebased on latest master
> >  - Added Alex's r-b's
> > 
> > v2:
> >  Rebased on latest master + my "populate argv[0]" series (will
> >  send a REPOST for that shortly. Additionally a few patches got
> >  fixes/features;
> >  07/10 got same fix as kernel 7c9b973061 "irqchip/gic-v3: Configure
> >        all interrupts as non-secure Group-1" in order to continue
> >        working over TCG, as the gicv3 code for TCG removed a hack
> >        it had there to make Linux happy.
> >  08/10 added more output for when things fail (if they fail)
> >  09/10 switched gicv3 broadcast implementation to using IRM. This
> >        found a bug in a recent (but not tip) kernel, which I was
> >        about to fix, but then I saw MarcZ beat me to it.
> >  10/10 actually check that the input irq is the received irq
> > 
> > 
> > Import defines, and steal enough helper functions, from Linux to
> > enable programming of the gic (v2 and v3). Then use the framework
> > to add an initial test (an ipi test; self, target-list, broadcast).
> > 
> > It's my hope that this framework will be a suitable base on which
> > more tests may be easily added, particularly because we have
> > vgic-new and tcg gicv3 emulation getting close to merge. (v3 UPDATE:
> > vgic-new and tcg gicv3 are merged now)
> > 
> > To run it, along with other tests, just do
> > 
> >  ./configure [ --arch=[arm|arm64] --cross-prefix=$PREFIX ]
> >  make
> >  export QEMU=$PATH_TO_QEMU
> >  ./run_tests.sh
> > 
> > To run it separately do, e.g.
> > 
> > $QEMU -machine virt,accel=tcg -cpu cortex-a57 \
> >  -device virtio-serial-device \
> >  -device virtconsole,chardev=ctd -chardev testdev,id=ctd \
> >  -display none -serial stdio \
> >  -kernel arm/gic.flat \
> >  -smp 123 -machine gic-version=3 -append ipi
> >       ^^ note, we can go nuts with nr-cpus on TCG :-)
> > 
> > Or, a KVM example using a different "sender" cpu and irq (other than zero)
> > 
> > $QEMU -machine virt,accel=kvm -cpu host \
> >  -device virtio-serial-device \
> >  -device virtconsole,chardev=ctd -chardev testdev,id=ctd \
> >  -display none -serial stdio \
> >  -kernel arm/gic.flat \
> >  -smp 48 -machine gic-version=3 -append 'ipi sender=42 irq=1'
> > 
> > 
> > Patches:
> > 01-05: fixes and functionality needed by the later gic patches
> > 06-07: enable gicv2 and gicv2 IPI test
> > 08-10: enable gicv3 and gicv3 IPI test
> >    11: extend the IPI tests to take variable sender and irq
> > 
> > Available here: https://github.com/rhdrjones/kvm-unit-tests/commits/arm/gic-v4
> > 
> > 
> > Andrew Jones (10):
> >   lib: xstr: allow multiple args
> >   arm64: fix get_"sysreg32" and make MPIDR 64bit
> >   arm/arm64: smp: support more than 8 cpus
> >   arm/arm64: add some delay routines
> >   arm/arm64: irq enable/disable
> >   arm/arm64: add initial gicv2 support
> >   arm/arm64: gicv2: add an IPI test
> >   arm/arm64: add initial gicv3 support
> >   arm/arm64: gicv3: add an IPI test
> >   arm/arm64: gic: don't just use zero
> > 
> > Peter Xu (1):
> >   libcflat: add IS_ALIGNED() macro, and page sizes
> > 
> >  arm/Makefile.common        |   7 +-
> >  arm/gic.c                  | 417 +++++++++++++++++++++++++++++++++++++++++++++
> >  arm/run                    |  19 ++-
> >  arm/selftest.c             |   5 +-
> >  arm/unittests.cfg          |  13 ++
> >  lib/arm/asm/arch_gicv3.h   |  65 +++++++
> >  lib/arm/asm/gic-v2.h       |  28 +++
> >  lib/arm/asm/gic-v3.h       |  92 ++++++++++
> >  lib/arm/asm/gic.h          |  51 ++++++
> >  lib/arm/asm/processor.h    |  38 ++++-
> >  lib/arm/asm/setup.h        |   4 +-
> >  lib/arm/gic.c              | 131 ++++++++++++++
> >  lib/arm/processor.c        |  15 ++
> >  lib/arm/setup.c            |  12 +-
> >  lib/arm64/asm/arch_gicv3.h |  66 +++++++
> >  lib/arm64/asm/gic-v2.h     |   1 +
> >  lib/arm64/asm/gic-v3.h     |   1 +
> >  lib/arm64/asm/gic.h        |   1 +
> >  lib/arm64/asm/processor.h  |  53 +++++-
> >  lib/arm64/asm/sysreg.h     |  44 +++++
> >  lib/arm64/processor.c      |  15 ++
> >  lib/libcflat.h             |  10 +-
> >  22 files changed, 1062 insertions(+), 26 deletions(-)
> >  create mode 100644 arm/gic.c
> >  create mode 100644 lib/arm/asm/arch_gicv3.h
> >  create mode 100644 lib/arm/asm/gic-v2.h
> >  create mode 100644 lib/arm/asm/gic-v3.h
> >  create mode 100644 lib/arm/asm/gic.h
> >  create mode 100644 lib/arm/gic.c
> >  create mode 100644 lib/arm64/asm/arch_gicv3.h
> >  create mode 100644 lib/arm64/asm/gic-v2.h
> >  create mode 100644 lib/arm64/asm/gic-v3.h
> >  create mode 100644 lib/arm64/asm/gic.h
> >  create mode 100644 lib/arm64/asm/sysreg.h
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
