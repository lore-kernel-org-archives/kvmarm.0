From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v6 00/11] arm/arm64: add gic
 framework
Date: Wed, 23 Nov 2016 14:08:04 +0100
Message-ID: <20161123130804.vurlcbwfv35thdfa@kamzik.brq.redhat.com>
References: <1479157719-31021-1-git-send-email-drjones@redhat.com>
 <20161122184511.w5tlxxjphq5fo25b@kamzik.brq.redhat.com>
 <87shqio6c0.fsf@linaro.org>
 <cf9a0aab-90cd-c350-d078-9a6bc3ea9fd1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cf9a0aab-90cd-c350-d078-9a6bc3ea9fd1@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, peter.maydell@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 23, 2016 at 12:33:53PM +0100, Auger Eric wrote:
> Hi,
> On 23/11/2016 11:09, Alex Bennée wrote:
> > 
> > Andrew Jones <drjones@redhat.com> writes:
> > 
> >> Andre, Alex, Eric, anybody,
> >>
> >> Any more comments on this? If not, I'll send a pull request
> >> to Radim and Paolo to finally get this merged.
> > 
> > Looks good to me. I successfully re-based my TCG tests on top and they
> > work fine ;-)
> no blocking point for me either. That's already a huge work and when
> adding new tests we may end up rationalizing things in separate v2/v3
> lib files and ops.
> 
> Tested on Cavium ThunderX
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Tested-by: Eric Auger <eric.auger@redhat.com>

Thanks Eric!

I like your suggestions for "gicv3: add an IPI test", so I'll
spin a v7.

drew

> 
> Thanks
> 
> Eric
> 
> 
> > 
> > Tested-by: Alex Bennée <alex.bennee@linaro.org>
> > 
> >>
> >> Thanks,
> >> drew
> >>
> >>
> >> On Mon, Nov 14, 2016 at 10:08:28PM +0100, Andrew Jones wrote:
> >>> v6:
> >>>  - rebased to latest master
> >>>  - several other changes thanks to Andre and Alex, changes in
> >>>    individual patch change logs
> >>>  - some code cleanups
> >>>
> >>> v5:
> >>>  - fix arm32/gicv3 compile [drew]
> >>>  - use modern register names [Andre]
> >>>  - one Andre r-b
> >>>
> >>> v4:
> >>>  - Eric's r-b's
> >>>  - Andre's suggestion to only take defines we need
> >>>  - several other changes listed in individual patches
> >>>
> >>> v3:
> >>>  - Rebased on latest master
> >>>  - Added Alex's r-b's
> >>>
> >>> v2:
> >>>  Rebased on latest master + my "populate argv[0]" series (will
> >>>  send a REPOST for that shortly. Additionally a few patches got
> >>>  fixes/features;
> >>>  07/10 got same fix as kernel 7c9b973061 "irqchip/gic-v3: Configure
> >>>        all interrupts as non-secure Group-1" in order to continue
> >>>        working over TCG, as the gicv3 code for TCG removed a hack
> >>>        it had there to make Linux happy.
> >>>  08/10 added more output for when things fail (if they fail)
> >>>  09/10 switched gicv3 broadcast implementation to using IRM. This
> >>>        found a bug in a recent (but not tip) kernel, which I was
> >>>        about to fix, but then I saw MarcZ beat me to it.
> >>>  10/10 actually check that the input irq is the received irq
> >>>
> >>>
> >>> Import defines, and steal enough helper functions, from Linux to
> >>> enable programming of the gic (v2 and v3). Then use the framework
> >>> to add an initial test (an ipi test; self, target-list, broadcast).
> >>>
> >>> It's my hope that this framework will be a suitable base on which
> >>> more tests may be easily added, particularly because we have
> >>> vgic-new and tcg gicv3 emulation getting close to merge. (v3 UPDATE:
> >>> vgic-new and tcg gicv3 are merged now)
> >>>
> >>> To run it, along with other tests, just do
> >>>
> >>>  ./configure [ --arch=[arm|arm64] --cross-prefix=$PREFIX ]
> >>>  make
> >>>  export QEMU=$PATH_TO_QEMU
> >>>  ./run_tests.sh
> >>>
> >>> To run it separately do, e.g.
> >>>
> >>> $QEMU -machine virt,accel=tcg -cpu cortex-a57 \
> >>>  -device virtio-serial-device \
> >>>  -device virtconsole,chardev=ctd -chardev testdev,id=ctd \
> >>>  -display none -serial stdio \
> >>>  -kernel arm/gic.flat \
> >>>  -smp 123 -machine gic-version=3 -append ipi
> >>>       ^^ note, we can go nuts with nr-cpus on TCG :-)
> >>>
> >>> Or, a KVM example using a different "sender" cpu and irq (other than zero)
> >>>
> >>> $QEMU -machine virt,accel=kvm -cpu host \
> >>>  -device virtio-serial-device \
> >>>  -device virtconsole,chardev=ctd -chardev testdev,id=ctd \
> >>>  -display none -serial stdio \
> >>>  -kernel arm/gic.flat \
> >>>  -smp 48 -machine gic-version=3 -append 'ipi sender=42 irq=1'
> >>>
> >>>
> >>> Patches:
> >>> 01-05: fixes and functionality needed by the later gic patches
> >>> 06-07: enable gicv2 and gicv2 IPI test
> >>> 08-10: enable gicv3 and gicv3 IPI test
> >>>    11: extend the IPI tests to take variable sender and irq
> >>>
> >>> Available here: https://github.com/rhdrjones/kvm-unit-tests/commits/arm/gic-v6
> >>>
> >>>
> >>> Andrew Jones (10):
> >>>   lib: xstr: allow multiple args
> >>>   arm64: fix get_"sysreg32" and make MPIDR 64bit
> >>>   arm/arm64: smp: support more than 8 cpus
> >>>   arm/arm64: add some delay routines
> >>>   arm/arm64: irq enable/disable
> >>>   arm/arm64: add initial gicv2 support
> >>>   arm/arm64: gicv2: add an IPI test
> >>>   arm/arm64: add initial gicv3 support
> >>>   arm/arm64: gicv3: add an IPI test
> >>>   arm/arm64: gic: don't just use zero
> >>>
> >>> Peter Xu (1):
> >>>   libcflat: add IS_ALIGNED() macro, and page sizes
> >>>
> >>>  arm/Makefile.common        |   9 +-
> >>>  arm/gic.c                  | 340 +++++++++++++++++++++++++++++++++++++++++++++
> >>>  arm/run                    |  19 ++-
> >>>  arm/selftest.c             |   5 +-
> >>>  arm/unittests.cfg          |  14 ++
> >>>  lib/arm/asm/arch_gicv3.h   |  70 ++++++++++
> >>>  lib/arm/asm/gic-v2.h       |  36 +++++
> >>>  lib/arm/asm/gic-v3.h       | 112 +++++++++++++++
> >>>  lib/arm/asm/gic.h          | 106 ++++++++++++++
> >>>  lib/arm/asm/processor.h    |  42 +++++-
> >>>  lib/arm/asm/setup.h        |   4 +-
> >>>  lib/arm/gic.c              | 267 +++++++++++++++++++++++++++++++++++
> >>>  lib/arm/processor.c        |  15 ++
> >>>  lib/arm/setup.c            |  10 ++
> >>>  lib/arm64/asm/arch_gicv3.h |  66 +++++++++
> >>>  lib/arm64/asm/gic-v2.h     |   1 +
> >>>  lib/arm64/asm/gic-v3.h     |   1 +
> >>>  lib/arm64/asm/gic.h        |   1 +
> >>>  lib/arm64/asm/processor.h  |  53 +++++--
> >>>  lib/arm64/asm/sysreg.h     |  44 ++++++
> >>>  lib/arm64/processor.c      |  15 ++
> >>>  lib/libcflat.h             |  10 +-
> >>>  22 files changed, 1212 insertions(+), 28 deletions(-)
> >>>  create mode 100644 arm/gic.c
> >>>  create mode 100644 lib/arm/asm/arch_gicv3.h
> >>>  create mode 100644 lib/arm/asm/gic-v2.h
> >>>  create mode 100644 lib/arm/asm/gic-v3.h
> >>>  create mode 100644 lib/arm/asm/gic.h
> >>>  create mode 100644 lib/arm/gic.c
> >>>  create mode 100644 lib/arm64/asm/arch_gicv3.h
> >>>  create mode 100644 lib/arm64/asm/gic-v2.h
> >>>  create mode 100644 lib/arm64/asm/gic-v3.h
> >>>  create mode 100644 lib/arm64/asm/gic.h
> >>>  create mode 100644 lib/arm64/asm/sysreg.h
> >>>
> >>> --
> >>> 2.7.4
> >>>
> >>>
> > 
> > 
> > --
> > Alex Bennée
> > --
> > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
