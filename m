From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 00/12] KVM: arm/arm64: move VGIC MMIO to kvm_io_bus
Date: Fri, 13 Mar 2015 16:10:00 +0000
Message-ID: <1426263012-22935-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7FB048C3F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 12:03:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kFkkTKGXhprx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Mar 2015 12:03:49 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 564F348C33
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 12:03:48 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This series converts the VGIC MMIO handling routines to the generic
kvm_io_bus framework. The framework is needed for the ioeventfd
functionality, some people on the list wanted to see the VGIC
converted over to use it, too.
Looking at the diffstat it doesn't look too useful after all, but
it cleans up the code a bit and gets rid of an ugly ping-pong
between vgic.c and vgic-v[23]-emul.c.

It's based on Nikolay's work[1], thanks especially for the tedious
first patch.
I totally reworked Nikolay's 3/5. I don't see much point in adding
another MMIO handling layer on top of the already quite convoluted
VGIC MMIO handling.
Instead I let the kvm_io_bus call into the final MMIO dispatcher of
the VGIC directly, which redirects the access to the actual register
handlers. We would loose quite some checking and some neatness of the
current functionality if that would be skipped, so I kept this in.

Unfortunately kvm_io_bus lacks an opaque pointer to pass in some data,
so I worked around this by using container_of.
Now for every struct kvm_mmio_range array a KVM I/O device is
registered (one for VGICv2, 2*nr_vcpus + 1 for VGICv3), using the
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

Patches 5-7 tweak the existing code a bit to make it fit for the
conversion.
Patch 8 contains the framework for the new handling, while
patch 9 and 10 enable the GICv2 and GICv3 emulation, respectively.
Patch 11 finally switches over to the new kvm_io_bus handling (this
is basically Nikolay's 2/5 with some additions), patch 12 removes the
now unneeded code. I split this up to ease reviewing, I could merge
patches as well if needed.

The series goes on top of the kvmarm.git/next branch and was briefly
tested on an arm64 model with a GICv2 and a GICv3 guest and on Midway
(GICv2 guest).

Cheers,
Andre.

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2015-January/013379.html

Andre Przywara (10):
  KVM: move iodev.h from virt/kvm/ to include/kvm
  KVM: arm/arm64: remove now unneeded include directory from Makefile
  KVM: x86: remove now unneeded include directory from Makefile
  KVM: arm/arm64: rename struct kvm_mmio_range to vgic_io_range
  KVM: mark kvm->buses as empty once they were destroyed
  KVM: arm/arm64: simplify vgic_find_range() and callers
  KVM: arm/arm64: implement kvm_io_bus MMIO handling for the VGIC
  KVM: arm/arm64: prepare GICv2 emulation to be handled by kvm_io_bus
  KVM: arm/arm64: prepare GICv3 emulation to use kvm_io_bus MMIO
    handling
  KVM: arm/arm64: remove now obsolete VGIC specific MMIO handling code

Nikolay Nikolaev (2):
  KVM: Redesign kvm_io_bus_ API to pass VCPU structure to the
    callbacks.
  KVM: ARM: on IO mem abort - route the call to KVM MMIO bus

 arch/arm/kvm/Makefile       |    2 +-
 arch/arm/kvm/mmio.c         |   32 +++++++-
 arch/arm64/kvm/Makefile     |    2 +-
 arch/powerpc/kvm/mpic.c     |   12 +--
 arch/powerpc/kvm/powerpc.c  |    4 +-
 arch/s390/kvm/diag.c        |    2 +-
 arch/x86/kvm/Makefile       |    2 +-
 arch/x86/kvm/i8254.c        |   14 ++--
 arch/x86/kvm/i8254.h        |    2 +-
 arch/x86/kvm/i8259.c        |   12 +--
 arch/x86/kvm/ioapic.c       |    8 +-
 arch/x86/kvm/ioapic.h       |    2 +-
 arch/x86/kvm/irq.h          |    2 +-
 arch/x86/kvm/lapic.c        |    4 +-
 arch/x86/kvm/lapic.h        |    2 +-
 arch/x86/kvm/vmx.c          |    2 +-
 arch/x86/kvm/x86.c          |   13 +--
 include/kvm/arm_vgic.h      |   15 +++-
 include/kvm/iodev.h         |   76 ++++++++++++++++++
 include/linux/kvm_host.h    |   10 +--
 virt/kvm/arm/vgic-v2-emul.c |   40 +++-------
 virt/kvm/arm/vgic-v3-emul.c |   77 ++++++++----------
 virt/kvm/arm/vgic.c         |  186 +++++++++++++++++++++++++++++--------------
 virt/kvm/arm/vgic.h         |   21 ++---
 virt/kvm/coalesced_mmio.c   |    7 +-
 virt/kvm/eventfd.c          |    6 +-
 virt/kvm/iodev.h            |   70 ----------------
 virt/kvm/kvm_main.c         |   38 ++++-----
 28 files changed, 379 insertions(+), 284 deletions(-)
 create mode 100644 include/kvm/iodev.h
 delete mode 100644 virt/kvm/iodev.h

-- 
1.7.9.5
