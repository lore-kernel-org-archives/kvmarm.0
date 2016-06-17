From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v6 00/15] KVM: arm64: GICv3 ITS emulation
Date: Fri, 17 Jun 2016 13:08:32 +0100
Message-ID: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

another heavily reworked version of the KVM ITS emulation support.
It allows those KVM guests that use an emulated GICv3 to use LPIs as
well, though in the moment this is limited to emulated PCI devices.
This is based on kvm-arm-for-v4.7-rc2 and only works with the new VGIC
implementation.

Compared to the last drop there have been significant changes to the
code:
References to multiple ITSes are now solely held in the kvm_io_bus
framework, which knows about the base addresses and the struct vgic_its
pointers anyway. This removes the its_list from the VGIC code.
Also there is now a list of mapped LPIs per guest, an ITTE only holds
a reference to the struct vgic_irq's. To avoid situations where an LPI
gets unmapped while the VGIC is still dealing with it, we introduce 
some reference counting to IRQs (new patch 05/15). This is not the
classical textbook reference counting with atomic accesses, because we
lock the IRQs anyway and just accessing the refcount inside the lock
simplifies the whole code. I am open to change requests here, though I
tried to atomic_t way and it looked more involved than the current
solution (since we do get/lock and unlock/put all of the time).
Other changes include many command handlers, namely INV, INVALL and
MOVALL. They should now match the architecture better.
I am not entirely sure having MOVALL right now, but I added some
safeguarding which matches a recommendation in the spec.
The PROPBASE and PENDBASER registers are now sanitised, also we now
implement the BASER registers in preparation for migration support.
At the moment we just allow (sanitised) writes and reads to them, though.

You can find all of this code (and the prerequisites) in the
its-emul/v6 branch of my repository [1].
This has been briefly tested on the model and on GICv3 hardware.
Since there are again quite some fundamental changes in this version,
I expect some issues in the code, so if you have GICv3 capable hardware,
please test it on your setup.
Also of course any review comments are very welcome!

Cheers,
Andre.

Changelog v5..v6:
- remove its_list from VGIC code
- add lpi_list and accessor functions
- introduce reference counting to struct vgic_irq
- replace its_lock spinlock with its_cmd and its_lock mutexes
- simplify guest memory accesses (due to the new mutexes)
- avoid unnecessary affinity updates
- refine base register address masking
- introduce sanity checks for PROPBASER and PENDBASER
- implement BASER<n> registers
- pass struct vgic_its directly into the MMIO handlers
- convert KVM_SIGNAL_MSI ioctl into an MMIO write
- add explicit INIT ioctl to the ITS KVM device
- adjusting comments and commit messages

Changelog v4..v5:
- adapting to final new VGIC (MMIO handlers, etc.)
- new KVM device to model an ITS, multiple instances allowed
- move redistributor data into struct vgic_cpu
- separate distributor and ITS(es)
- various bug fixes and amended comments after review comments

Changelog v3..v4:
- adapting to new VGIC (changes in IRQ injection mechanism)

Changelog v2..v3:
- adapt to 4.3-rc and Christoffer's timer rework
- adapt spin locks on handling PROPBASER/PENDBASER registers
- rework locking in ITS command handling (dropping dist where needed)
- only clear LPI pending bit if LPI could actually be queued
- simplify GICR_CTLR handling
- properly free ITTEs (including our pending bitmap)
- fix corner cases with unmapped collections
- keep retire_lr() around
- rename vgic_handle_base_register to vgic_reg64_access()
- use kcalloc instead of kmalloc
- minor fixes, renames and added comments

Changelog v1..v2
- fix issues when using non-ITS GICv3 emulation
- streamline frame address initialization (new patch 05/15)
- preallocate buffer memory for reading from guest's memory
- move locking into the actual command handlers
-   preallocate memory for new structures if needed
- use non-atomic __set_bit() and __clear_bit() when under the lock
- add INT command handler to allow LPI injection from the guest
- rewrite CWRITER handler to align with new locking scheme
- remove unneeded CONFIG_HAVE_KVM_MSI #ifdefs
- check memory table size against our LPI limit (65536 interrupts)
- observe initial gap of 1024 interrupts in pending table
- use term "configuration table" to be in line with the spec
- clarify and extend documentation on API extensions
- introduce new KVM_CAP_MSI_DEVID capability to advertise device ID requirement
- update, fix and add many comments
- minor style changes as requested by reviewers

---------------

The GICv3 ITS (Interrupt Translation Service) is a part of the
ARM GICv3 interrupt controller [3] used for implementing MSIs.
It specifies a new kind of interrupts (LPIs), which are mapped to
establish a connection between a device, its MSI payload value and
the target processor the IRQ is eventually delivered to.
In order to allow using MSIs in an ARM64 KVM guest, we emulate this
ITS widget in the kernel.
The ITS works by reading commands written by software (from the guest
in our case) into a (guest allocated) memory region and establishing
the mapping between a device, the MSI payload and the target CPU.
We parse these commands and update our internal data structures to
reflect those changes. On an MSI injection we iterate those
structures to learn the LPI number we have to inject.
For the time being we use simple lists to hold the data, this is
good enough for the small number of entries each of the components
currently have. Should this become a performance bottleneck in the
future, those can be extended to arrays or trees if needed.

Most of the code lives in a separate source file (vgic-its.c), though
there are some changes necessary in the existing VGIC files.

For the time being this series gives us the ability to use emulated
PCI devices that can use MSIs in the guest. Those have to be
triggered by letting the userland device emulation simulate the MSI
write with the KVM_SIGNAL_MSI ioctl. This will be translated into
the proper LPI by the ITS emulation and injected into the guest in
the usual way (just with a higher IRQ number).

This series is based on kvm-arm-for-v4.7-rc2 and can be found at the
its-emul/v6 branch of this repository [1].
For this to be used you need a GICv3 host machine (a fast model would
do), though it does not rely on any host ITS bits (neither in hardware
or software).

To test this you can use the kvmtool patches available in the "its-v6"
branch here [2].
Start a guest with: "$ lkvm run --irqchip=gicv3-its --force-pci"
and see the ITS being used for instance by the virtio devices.

[1]: git://linux-arm.org/linux-ap.git
     http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/its-emul/v6
[2]: git://linux-arm.org/kvmtool.git
     http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its-v6
[3]: http://arminfo.emea.arm.com/help/topic/com.arm.doc.ihi0069a/IHI0069A_gic_architecture_specification.pdf

Andre Przywara (15):
  KVM: arm/arm64: move redistributor kvm_io_devices
  KVM: arm/arm64: check return value for kvm_register_vgic_device
  KVM: extend struct kvm_msi to hold a 32-bit device ID
  KVM: arm/arm64: extend arch CAP checks to allow per-VM capabilities
  KVM: arm/arm64: VGIC: add refcounting for IRQs
  KVM: arm64: handle ITS related GICv3 redistributor registers
  KVM: arm64: introduce ITS emulation file with MMIO framework
  KVM: arm64: introduce new KVM ITS device
  KVM: arm64: implement basic ITS register handlers
  KVM: arm64: connect LPIs to the VGIC emulation
  KVM: arm64: read initial LPI pending table
  KVM: arm64: allow updates of LPI configuration table
  KVM: arm64: implement ITS command queue command handlers
  KVM: arm64: implement MSI injection in ITS emulation
  KVM: arm64: enable ITS emulation as a virtual MSI controller

 Documentation/virtual/kvm/api.txt              |   14 +-
 Documentation/virtual/kvm/devices/arm-vgic.txt |   25 +-
 arch/arm/include/asm/kvm_host.h                |    2 +-
 arch/arm/kvm/arm.c                             |    3 +-
 arch/arm64/include/asm/kvm_host.h              |    2 +-
 arch/arm64/include/uapi/asm/kvm.h              |    2 +
 arch/arm64/kvm/Kconfig                         |    1 +
 arch/arm64/kvm/Makefile                        |    1 +
 arch/arm64/kvm/reset.c                         |   12 +-
 include/kvm/vgic/vgic.h                        |   61 +-
 include/linux/irqchip/arm-gic-v3.h             |   32 +-
 include/uapi/linux/kvm.h                       |    7 +-
 virt/kvm/arm/vgic.c                            |    5 +
 virt/kvm/arm/vgic/vgic-init.c                  |    9 +-
 virt/kvm/arm/vgic/vgic-its.c                   | 1393 ++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-kvm-device.c            |   22 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c               |   21 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c               |  213 +++-
 virt/kvm/arm/vgic/vgic-mmio.c                  |   80 +-
 virt/kvm/arm/vgic/vgic-mmio.h                  |   14 +
 virt/kvm/arm/vgic/vgic-v2.c                    |   11 +-
 virt/kvm/arm/vgic/vgic-v3.c                    |   21 +-
 virt/kvm/arm/vgic/vgic.c                       |   98 +-
 virt/kvm/arm/vgic/vgic.h                       |   42 +-
 24 files changed, 1947 insertions(+), 144 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-its.c

-- 
2.8.2

