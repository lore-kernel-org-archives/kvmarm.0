From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v2 00/10] arm/arm64: add gic framework
Date: Tue, 07 Jun 2016 18:13:53 +0100
Message-ID: <87oa7chqge.fsf@linaro.org>
References: <87d1nweqsc.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <87d1nweqsc.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu


Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:

> Andrew Jones <drjones@redhat.com> writes:
>
>> v2:
>>  Rebased on on latest master + my "populate argv[0]" series (will
>>  send a REPOST for that shortly. Additionally a few patches got
>>  fixes/features;
>>  07/10 got same fix as kernel 7c9b973061 "irqchip/gic-v3: Configure
>>        all interrupts as non-secure Group-1" in order to continue
>>        working over TCG, as the gicv3 code for TCG removed a hack
>>        it had there to make Linux happy.
>>  08/10 added more output for when things fail (if they fail)
>>  09/10 switched gicv3 broadcast implementation to using IRM. This
>>        found a bug in a recent (but not tip) kernel, which I was
>>        about to fix, but then I saw MarcZ beat me to it.
>>  10/10 actually check that the input irq is the received irq
>
> Cool stuff. I'll get to reviewing this next week as my kvm-unit-tests
> queue is getting overly long I need to clean-up and re-submit.

OK I think I'm done for now. Sorry I've skipped the main bits of the GI=
C
test but I'm not up to speed on the GIC layout so I'll defer to people
who have a better understanding of it ;-)

>
>>
>>
>> Import defines, and steal enough helper functions, from Linux to
>> enable programming of the gic (v2 and v3). Then use the framework
>> to add an initial test (an ipi test; self, target-list, broadcast).
>>
>> It's my hope that this framework will be a suitable base on which
>> more tests may be easily added, particularly because we have
>> vgic-new and tcg gicv3 emulation getting close to merge.
>>
>> To run it, along with other tests, just do
>>
>>  ./configure [ --arch=3D[arm|arm64] --cross-prefix=3D$PREFIX ]
>>  make
>>  export QEMU=3D$PATH_TO_QEMU
>>  ./run_tests.sh
>>
>> To run it separately do, e.g.
>>
>> $QEMU -machine virt,accel=3Dtcg -cpu cortex-a57 \
>>  -device virtio-serial-device \
>>  -device virtconsole,chardev=3Dctd -chardev testdev,id=3Dctd \
>>  -display none -serial stdio \
>>  -kernel arm/gic.flat \
>>  -smp 123 -machine gic-version=3D3 -append ipi
>>
>>       ^^ note, we can go nuts with nr-cpus on TCG :-)
>>
>> Or, a KVM example using a different "sender" cpu and irq (other than=
 zero)
>>
>> $QEMU -machine virt,accel=3Dkvm -cpu host \
>>  -device virtio-serial-device \
>>  -device virtconsole,chardev=3Dctd -chardev testdev,id=3Dctd \
>>  -display none -serial stdio \
>>  -kernel arm/gic.flat \
>>  -smp 48 -machine gic-version=3D3 -append 'ipi sender=3D42 irq=3D1'
>>
>>
>> Patches:
>> 01-05: fixes and functionality needed by the later gic patches
>> 06-07: code theft from Linux (defines, helper functions)
>> 08-10: arm/gic.flat (the base of the gic unit test), currently just =
IPI
>>
>> Available here: https://github.com/rhdrjones/kvm-unit-tests/commits/=
arm/gic
>>
>>
>> Andrew Jones (10):
>>   lib: xstr: allow multiple args
>>   arm64: fix get_"sysreg32" and make MPIDR 64bit
>>   arm/arm64: smp: support more than 8 cpus
>>   arm/arm64: add some delay routines
>>   arm/arm64: irq enable/disable
>>   arm/arm64: add initial gicv2 support
>>   arm/arm64: add initial gicv3 support
>>   arm/arm64: gicv2: add an IPI test
>>   arm/arm64: gicv3: add an IPI test
>>   arm/arm64: gic: don't just use zero
>>
>>  arm/Makefile.common        |   7 +-
>>  arm/gic.c                  | 381 ++++++++++++++++++++++++++++++++++=
+++++++++++
>>  arm/run                    |  19 ++-
>>  arm/selftest.c             |   5 +-
>>  arm/unittests.cfg          |  13 ++
>>  lib/arm/asm/arch_gicv3.h   | 184 ++++++++++++++++++++++
>>  lib/arm/asm/gic-v2.h       |  74 +++++++++
>>  lib/arm/asm/gic-v3.h       | 321 ++++++++++++++++++++++++++++++++++=
++++
>>  lib/arm/asm/gic.h          |  21 +++
>>  lib/arm/asm/processor.h    |  38 ++++-
>>  lib/arm/asm/setup.h        |   4 +-
>>  lib/arm/gic.c              | 142 +++++++++++++++++
>>  lib/arm/processor.c        |  15 ++
>>  lib/arm/setup.c            |  12 +-
>>  lib/arm64/asm/arch_gicv3.h | 169 ++++++++++++++++++++
>>  lib/arm64/asm/gic-v2.h     |   1 +
>>  lib/arm64/asm/gic-v3.h     |   1 +
>>  lib/arm64/asm/gic.h        |   1 +
>>  lib/arm64/asm/processor.h  |  53 ++++++-
>>  lib/arm64/asm/sysreg.h     |  44 ++++++
>>  lib/arm64/processor.c      |  15 ++
>>  lib/libcflat.h             |   4 +-
>>  22 files changed, 1498 insertions(+), 26 deletions(-)
>>  create mode 100644 arm/gic.c
>>  create mode 100644 lib/arm/asm/arch_gicv3.h
>>  create mode 100644 lib/arm/asm/gic-v2.h
>>  create mode 100644 lib/arm/asm/gic-v3.h
>>  create mode 100644 lib/arm/asm/gic.h
>>  create mode 100644 lib/arm/gic.c
>>  create mode 100644 lib/arm64/asm/arch_gicv3.h
>>  create mode 100644 lib/arm64/asm/gic-v2.h
>>  create mode 100644 lib/arm64/asm/gic-v3.h
>>  create mode 100644 lib/arm64/asm/gic.h
>>  create mode 100644 lib/arm64/asm/sysreg.h


--
Alex Benn=C3=A9e
