From: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
Subject: Re: [PATCH v2 00/12] KVM: arm/arm64: move VGIC MMIO to kvm_io_bus
Date: Mon, 23 Mar 2015 23:50:49 +0200
Message-ID: <CADDJ2=NVaAwuE9LZj5Uhjo=JEHKsf_CYxs391Pk4+6SNJcH8+A@mail.gmail.com>
References: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 560AD4981E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2015 17:44:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VJFJUYf857Hn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2015 17:44:37 -0400 (EDT)
Received: from mail-qg0-f48.google.com (mail-qg0-f48.google.com
 [209.85.192.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 779FC4981D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2015 17:44:37 -0400 (EDT)
Received: by qgep97 with SMTP id p97so38286739qge.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2015 14:51:30 -0700 (PDT)
In-Reply-To: <1427126309-11223-1-git-send-email-andre.przywara@arm.com>
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
Cc: "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 23, 2015 at 5:58 PM, Andre Przywara <andre.przywara@arm.com> wrote:
> This series converts the VGIC MMIO handling routines to the generic
> kvm_io_bus framework. The framework is needed for the ioeventfd
> functionality, some people on the list wanted to see the VGIC
> converted over to use it, too.
> Beside from now moving to a generic framework instead of relying on
> an ARM specific one we also clean up quite some code and get rid of
> some unnecessary copying.
> On that way the MMIO abort handling for ARM has changed quite a bit,
> so please have a closer look and test it on your setup if possible.
>
> Based on the v1 review I addressed Christoffer's minor comments, but
> also heavily changed [11/12]: "KVM: ARM: on IO mem abort - route the
> call to KVM MMIO bus" to get rid of the now unnecessary copying and
> the usage of kvm_exit_mmio in that early stage. See the respective
> commit message for more details.
>
> The series is loosely based on Nikolay's work[1], thanks especially
> for the tedious first patch.
> I totally reworked Nikolay's 3/5 to avoid adding another MMIO handling
> layer on top of the already quite convoluted VGIC MMIO handling.
> Also Nikolay's 2/5 get extended and changed significantly, that's why
> I dropped his Signed-off-by.
>
> Unfortunately kvm_io_bus lacks an opaque pointer to pass in some data,
> so I worked around this by using container_of.
> Now for every struct kvm_mmio_range array a KVM I/O device is
> registered (one for VGICv2, 2*nr_vcpus + 1 for VGICv3), using the
> struct kvm_io_device variable as an anchor into the new
> struct vgic_io_device. This one holds the base address, the
> vgic_io_range pointer and (in case of the GICv3 redistributor) the
> associated vCPU, so that we can access all instance-specific data
> easily.
>
> Patch 2 moves the iodev.h header file around, that solves a problem
> when embedding a struct in arm_vgic.h later. That looks like a nice
> cleanup anyway, so I added two patches to remove the compiler switch
> to add virt/kvm as a include directory. This has been tested for
> arm/arm64 and x86. As soon as I get around to compile-test the other
> architectures, I can send out the respective patches for those, too.
>
> Patches 5-7 tweak the existing code a bit to make it fit for the
> conversion.
> Patch 8 contains the framework for the new handling, while
> patch 9 and 10 enable the GICv2 and GICv3 emulation, respectively.
> Patch 11 finally switches over to the new kvm_io_bus handling,
> reworking the early ARM KVM MMIO handling quite a bit. Patch 12
> removes the now unneeded code. I split this up to ease reviewing, I
> could merge patches as well if needed.

Shall we add here also the last 2 patches from my series that actually enable
the eventfd compilation and KVM_CAP_IOEVENTFD? Or should I send them separately?

regards,
Nikolay Nikolaev
>
> The series goes on top of the kvmarm.git/next branch and was briefly
> tested on an arm64 model with a GICv2 and a GICv3 guest and on Midway
> (GICv2 guest).
>
> Cheers,
> Andre.
>
> [1] https://lists.cs.columbia.edu/pipermail/kvmarm/2015-January/013379.html
>
> Andre Przywara (11):
>   KVM: move iodev.h from virt/kvm/ to include/kvm
>   KVM: arm/arm64: remove now unneeded include directory from Makefile
>   KVM: x86: remove now unneeded include directory from Makefile
>   KVM: arm/arm64: rename struct kvm_mmio_range to vgic_io_range
>   KVM: mark kvm->buses as empty once they were destroyed
>   KVM: arm/arm64: simplify vgic_find_range() and callers
>   KVM: arm/arm64: implement kvm_io_bus MMIO handling for the VGIC
>   KVM: arm/arm64: prepare GICv2 emulation to be handled by kvm_io_bus
>   KVM: arm/arm64: prepare GICv3 emulation to use kvm_io_bus MMIO
>     handling
>   KVM: arm/arm64: rework MMIO abort handling to use KVM MMIO bus
>   KVM: arm/arm64: remove now obsolete VGIC specific MMIO handling code
>
> Nikolay Nikolaev (1):
>   KVM: Redesign kvm_io_bus_ API to pass VCPU structure to the
>     callbacks.
>
>  arch/arm/include/asm/kvm_mmio.h   |   22 ----
>  arch/arm/kvm/Makefile             |    2 +-
>  arch/arm/kvm/mmio.c               |   60 ++++++++---
>  arch/arm64/include/asm/kvm_mmio.h |   22 ----
>  arch/arm64/kvm/Makefile           |    2 +-
>  arch/powerpc/kvm/mpic.c           |   12 ++-
>  arch/powerpc/kvm/powerpc.c        |    4 +-
>  arch/s390/kvm/diag.c              |    2 +-
>  arch/x86/kvm/Makefile             |    2 +-
>  arch/x86/kvm/i8254.c              |   14 ++-
>  arch/x86/kvm/i8254.h              |    2 +-
>  arch/x86/kvm/i8259.c              |   12 +--
>  arch/x86/kvm/ioapic.c             |    8 +-
>  arch/x86/kvm/ioapic.h             |    2 +-
>  arch/x86/kvm/irq.h                |    2 +-
>  arch/x86/kvm/lapic.c              |    4 +-
>  arch/x86/kvm/lapic.h              |    2 +-
>  arch/x86/kvm/vmx.c                |    2 +-
>  arch/x86/kvm/x86.c                |   13 +--
>  include/kvm/arm_vgic.h            |   16 ++-
>  include/kvm/iodev.h               |   76 +++++++++++++
>  include/linux/kvm_host.h          |   10 +-
>  virt/kvm/arm/vgic-v2-emul.c       |   40 +++----
>  virt/kvm/arm/vgic-v3-emul.c       |   79 +++++++-------
>  virt/kvm/arm/vgic.c               |  211 +++++++++++++++++++++++++------------
>  virt/kvm/arm/vgic.h               |   29 +++--
>  virt/kvm/coalesced_mmio.c         |    7 +-
>  virt/kvm/eventfd.c                |    6 +-
>  virt/kvm/iodev.h                  |   70 ------------
>  virt/kvm/kvm_main.c               |   38 +++----
>  30 files changed, 420 insertions(+), 351 deletions(-)
>  create mode 100644 include/kvm/iodev.h
>  delete mode 100644 virt/kvm/iodev.h
>
> --
> 1.7.9.5
>
