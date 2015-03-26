From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 00/11] KVM: arm/arm64: move VGIC MMIO to kvm_io_bus
Date: Thu, 26 Mar 2015 14:39:27 +0000
Message-ID: <1427380778-942-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9786149C2C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 10:32:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JQJ7n8tME+Ve for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 10:32:42 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FA8749C1D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 10:32:41 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This series converts the VGIC MMIO handling routines to the generic
kvm_io_bus framework. The framework is needed for the ioeventfd
functionality, some people on the list wanted to see the VGIC
converted over to use it, too.
Beside from now moving to a generic framework instead of relying on
an ARM specific one we also clean up quite some code and get rid of
some unnecessary copying.
On that way the MMIO abort handling for ARM has changed quite a bit,
so please have a closer look and test it on your setup if possible.

Compared to v2 I merged in a build fix for patch 1.
The old 06/12 is now gone, instead I changed the code to only call
kvm_io_bus_unregister_dev when rolling back a failed init and letting
the VM teardown take care of the io_bus destruction entirely.
This affects the old patches 08/12-10/12.
Also there is now a new patch (09/11), which optimises the GICv3
redistributor handling to only have one region for the register
frame. This save half of the kvm_io_bus devices in the next patch.
Also I merged in a fix when using QEMU with this series [2] and
merged the last two patches (enabling new framework and removing old
code), because it didn't build properly and fixing that up didn't
seem worthwile.

The series is loosely based on Nikolay's work[1], thanks especially
for the tedious first patch.
I totally reworked Nikolay's 3/5 to avoid adding another MMIO handling
layer on top of the already quite convoluted VGIC MMIO handling.
Also Nikolay's 2/5 get extended and changed significantly, that's why
I dropped his Signed-off-by.

Unfortunately kvm_io_bus lacks an opaque pointer to pass in some data,
so I worked around this by using container_of.
Now for every struct kvm_mmio_range array a KVM I/O device is
registered (one for VGICv2, nr_vcpus + 1 for VGICv3), using the
struct kvm_io_device variable as an anchor into the new
struct vgic_io_device. This one holds the base address, the
vgic_io_range pointer and (in case of the GICv3 redistributor) the
associated vCPU, so that we can access all instance-specific data
easily.

Patch 2 moves the iodev.h header file around, that solves a problem
when embedding a struct in arm_vgic.h later. That looks like a nice
cleanup anyway, so I added two patches to remove the compiler switch
to add virt/kvm as a include directory. This has been tested for
arm/arm64 and x86. As soon as I get around to compile-test the other
architectures, I can send out the respective patches for those, too.

Patches 5 and 6 tweak the existing code a bit to make it fit for the
conversion.
Patch 7 contains the framework for the new handling, while
patch 8 and 10 enable the GICv2 and GICv3 emulation, respectively.
Patch 9 optimises the GICv3 register handling to ease the GICv3
adaption to the new framework.
Patch 11 finally switches over to the new kvm_io_bus handling,
reworking the early ARM KVM MMIO handling quite a bit. This allows to
removes quite some now unneeded code.

The series goes on top of the kvmarm.git/next branch and was briefly
tested on an arm64 model with a GICv2 and a GICv3 guest and on Midway
(GICv2 guest).

Cheers,
Andre.

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2015-January/013379.html
[2] https://lists.cs.columbia.edu/pipermail/kvmarm/2015-March/014098.html

Changelog v2 .. v3:
- fix build in first patch
- fix NULL pointer dereference when using QEMU
- merge GICv3 RD_base and SGI_base MMIO register frames
- explicitly unregister kvm_io_bus devices on failing init
- remove vgic_unregister_kvm_io_dev (let kvm_io_bus framework handle this)
- remove marking of destroyed kvm_io_bus'es with NULL
- merge framework switch and code removal patch

Andre Przywara (10):
  KVM: move iodev.h from virt/kvm/ to include/kvm
  KVM: arm/arm64: remove now unneeded include directory from Makefile
  KVM: x86: remove now unneeded include directory from Makefile
  KVM: arm/arm64: rename struct kvm_mmio_range to vgic_io_range
  KVM: arm/arm64: simplify vgic_find_range() and callers
  KVM: arm/arm64: implement kvm_io_bus MMIO handling for the VGIC
  KVM: arm/arm64: prepare GICv2 emulation to be handled by kvm_io_bus
  KVM: arm/arm64: merge GICv3 RD_base and SGI_base register frames
  KVM: arm/arm64: prepare GICv3 emulation to use kvm_io_bus MMIO
    handling
  KVM: arm/arm64: rework MMIO abort handling to use KVM MMIO bus

Nikolay Nikolaev (1):
  KVM: Redesign kvm_io_bus_ API to pass VCPU structure to the
    callbacks.

 arch/arm/include/asm/kvm_mmio.h   |   22 ----
 arch/arm/kvm/Makefile             |    2 +-
 arch/arm/kvm/mmio.c               |   60 ++++++---
 arch/arm64/include/asm/kvm_mmio.h |   22 ----
 arch/arm64/kvm/Makefile           |    2 +-
 arch/powerpc/kvm/mpic.c           |   12 +-
 arch/powerpc/kvm/powerpc.c        |    4 +-
 arch/s390/kvm/diag.c              |    2 +-
 arch/x86/kvm/Makefile             |    2 +-
 arch/x86/kvm/i8254.c              |   14 ++-
 arch/x86/kvm/i8254.h              |    2 +-
 arch/x86/kvm/i8259.c              |   12 +-
 arch/x86/kvm/ioapic.c             |    8 +-
 arch/x86/kvm/ioapic.h             |    2 +-
 arch/x86/kvm/irq.h                |    2 +-
 arch/x86/kvm/lapic.c              |    4 +-
 arch/x86/kvm/lapic.h              |    2 +-
 arch/x86/kvm/vmx.c                |    2 +-
 arch/x86/kvm/x86.c                |   13 +-
 include/kvm/arm_vgic.h            |   17 ++-
 include/kvm/iodev.h               |   76 ++++++++++++
 include/linux/kvm_host.h          |   10 +-
 virt/kvm/arm/vgic-v2-emul.c       |   51 ++++----
 virt/kvm/arm/vgic-v3-emul.c       |  246 ++++++++++++++++++-------------------
 virt/kvm/arm/vgic.c               |  176 ++++++++++++++++----------
 virt/kvm/arm/vgic.h               |   29 +++--
 virt/kvm/coalesced_mmio.c         |    7 +-
 virt/kvm/eventfd.c                |    6 +-
 virt/kvm/iodev.h                  |   70 -----------
 virt/kvm/kvm_main.c               |   34 ++---
 30 files changed, 475 insertions(+), 436 deletions(-)
 create mode 100644 include/kvm/iodev.h
 delete mode 100644 virt/kvm/iodev.h

-- 
1.7.9.5
