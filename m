From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 00/10] arm/arm64: add gic framework
Date: Mon, 16 May 2016 09:57:14 +0200
Message-ID: <1463385444-12916-1-git-send-email-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Import defines, and steal enough helper functions, from Linux to
enable programming of the gic (v2 and v3). Then use the framework
to add an initial test (an ipi test; self, target-list, broadcast).

It's my hope that this framework will be a suitable base on which
more tests may be easily added, particularly because we have
vgic-new and tcg gicv3 emulation getting close to merge.

To run it, along with other tests, just do

 ./configure [ --arch=[arm|arm64] --cross-prefix=$PREFIX ]
 make
 export QEMU=$PATH_TO_QEMU
 ./run_tests.sh

To run it separately do, e.g.

$QEMU -machine virt,accel=tcg -cpu cortex-a57 \
 -device virtio-serial-device \
 -device virtconsole,chardev=ctd -chardev testdev,id=ctd \
 -display none -serial stdio \
 -kernel arm/gic.flat \
 -smp 123 -machine gic-version=3 -append ipi

      ^^ note, we can go nuts with nr-cpus on TCG :-)

Or, a KVM example using a different "sender" cpu and irq (other than zero)

$QEMU -machine virt,accel=kvm -cpu host \
 -device virtio-serial-device \
 -device virtconsole,chardev=ctd -chardev testdev,id=ctd \
 -display none -serial stdio \
 -kernel arm/gic.flat \
 -smp 48 -machine gic-version=3 -append 'ipi sender=42 irq=1'


Patches:
01-05: fixes and functionality needed by the later gic patches
06-07: code theft from Linux (defines, helper functions)
08-10: arm/gic.flat (the base of the gic unit test), currently just IPI

Available here: https://github.com/rhdrjones/kvm-unit-tests/commits/arm/gic


Andrew Jones (10):
  lib: xstr: allow multiple args
  arm64: fix get_"sysreg32" and make MPIDR 64bit
  arm/arm64: smp: support more than 8 cpus
  arm/arm64: add some delay routines
  arm/arm64: irq enable/disable
  arm/arm64: add initial gicv2 support
  arm64: add initial gicv3 support
  arm/arm64: gicv2: add an IPI test
  arm/arm64: gicv3: add an IPI test
  arm/arm64: gic: don't just use zero

 arm/Makefile.common        |   7 +-
 arm/gic.c                  | 338 +++++++++++++++++++++++++++++++++++++++++++++
 arm/run                    |  19 ++-
 arm/selftest.c             |   5 +-
 arm/unittests.cfg          |  13 ++
 lib/arm/asm/arch_gicv3.h   | 184 ++++++++++++++++++++++++
 lib/arm/asm/gic-v2.h       |  74 ++++++++++
 lib/arm/asm/gic-v3.h       | 320 ++++++++++++++++++++++++++++++++++++++++++
 lib/arm/asm/gic.h          |  21 +++
 lib/arm/asm/processor.h    |  38 ++++-
 lib/arm/asm/setup.h        |   4 +-
 lib/arm/gic.c              | 127 +++++++++++++++++
 lib/arm/processor.c        |  15 ++
 lib/arm/setup.c            |  12 +-
 lib/arm64/asm/arch_gicv3.h | 169 +++++++++++++++++++++++
 lib/arm64/asm/gic-v2.h     |   1 +
 lib/arm64/asm/gic-v3.h     |   1 +
 lib/arm64/asm/gic.h        |   1 +
 lib/arm64/asm/processor.h  |  53 +++++--
 lib/arm64/asm/sysreg.h     |  44 ++++++
 lib/arm64/processor.c      |  15 ++
 lib/libcflat.h             |   4 +-
 22 files changed, 1439 insertions(+), 26 deletions(-)
 create mode 100644 arm/gic.c
 create mode 100644 lib/arm/asm/arch_gicv3.h
 create mode 100644 lib/arm/asm/gic-v2.h
 create mode 100644 lib/arm/asm/gic-v3.h
 create mode 100644 lib/arm/asm/gic.h
 create mode 100644 lib/arm/gic.c
 create mode 100644 lib/arm64/asm/arch_gicv3.h
 create mode 100644 lib/arm64/asm/gic-v2.h
 create mode 100644 lib/arm64/asm/gic-v3.h
 create mode 100644 lib/arm64/asm/gic.h
 create mode 100644 lib/arm64/asm/sysreg.h

-- 
2.4.11

