From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH 00/10] arm/arm64: add gic
 framework
Date: Mon, 23 May 2016 17:24:23 +0200
Message-ID: <20160523152423.2zc26na33jt2abdi@hawk.localdomain>
References: <1463385444-12916-1-git-send-email-drjones@redhat.com>
 <20160518090714.GA3827@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160518090714.GA3827@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: peter.maydell@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, alex.bennee@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 18, 2016 at 11:07:14AM +0200, Christoffer Dall wrote:
> Hi Drew,
> 
> Thanks for doing this.  I'm happy to see some tests for the GIC.
> 
> I've been pondering with how to write unit tests for all the MMIO
> implementations.  If you have some thoughts on how that could be easily
> fitted into this framework, that would probably be a good place to do it
> ;)

Hi Christoffer,

Sorry for my slow response, I've been on vacation. For MMIO
implementations, are you referring to the emulation done for
gicv2 accesses and for gicv3 legacy accesses? And, if so, is
your question how we might be able to use the same test
framework for both? And, if that's so, then I think this series
gets us pretty close already. If I'm completely off-base, then
please give me a quick high-level description of what you'd like
to be able to do.

Thanks,
drew

> -Christoffer
> 
> On Mon, May 16, 2016 at 09:57:14AM +0200, Andrew Jones wrote:
> > Import defines, and steal enough helper functions, from Linux to
> > enable programming of the gic (v2 and v3). Then use the framework
> > to add an initial test (an ipi test; self, target-list, broadcast).
> > 
> > It's my hope that this framework will be a suitable base on which
> > more tests may be easily added, particularly because we have
> > vgic-new and tcg gicv3 emulation getting close to merge.
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
> > 
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
> > 06-07: code theft from Linux (defines, helper functions)
> > 08-10: arm/gic.flat (the base of the gic unit test), currently just IPI
> > 
> > Available here: https://github.com/rhdrjones/kvm-unit-tests/commits/arm/gic
> > 
> > 
> > Andrew Jones (10):
> >   lib: xstr: allow multiple args
> >   arm64: fix get_"sysreg32" and make MPIDR 64bit
> >   arm/arm64: smp: support more than 8 cpus
> >   arm/arm64: add some delay routines
> >   arm/arm64: irq enable/disable
> >   arm/arm64: add initial gicv2 support
> >   arm64: add initial gicv3 support
> >   arm/arm64: gicv2: add an IPI test
> >   arm/arm64: gicv3: add an IPI test
> >   arm/arm64: gic: don't just use zero
> > 
> >  arm/Makefile.common        |   7 +-
> >  arm/gic.c                  | 338 +++++++++++++++++++++++++++++++++++++++++++++
> >  arm/run                    |  19 ++-
> >  arm/selftest.c             |   5 +-
> >  arm/unittests.cfg          |  13 ++
> >  lib/arm/asm/arch_gicv3.h   | 184 ++++++++++++++++++++++++
> >  lib/arm/asm/gic-v2.h       |  74 ++++++++++
> >  lib/arm/asm/gic-v3.h       | 320 ++++++++++++++++++++++++++++++++++++++++++
> >  lib/arm/asm/gic.h          |  21 +++
> >  lib/arm/asm/processor.h    |  38 ++++-
> >  lib/arm/asm/setup.h        |   4 +-
> >  lib/arm/gic.c              | 127 +++++++++++++++++
> >  lib/arm/processor.c        |  15 ++
> >  lib/arm/setup.c            |  12 +-
> >  lib/arm64/asm/arch_gicv3.h | 169 +++++++++++++++++++++++
> >  lib/arm64/asm/gic-v2.h     |   1 +
> >  lib/arm64/asm/gic-v3.h     |   1 +
> >  lib/arm64/asm/gic.h        |   1 +
> >  lib/arm64/asm/processor.h  |  53 +++++--
> >  lib/arm64/asm/sysreg.h     |  44 ++++++
> >  lib/arm64/processor.c      |  15 ++
> >  lib/libcflat.h             |   4 +-
> >  22 files changed, 1439 insertions(+), 26 deletions(-)
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
> > -- 
> > 2.4.11
> > 
> 
