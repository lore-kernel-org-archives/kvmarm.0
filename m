From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v8 00/17] KVM: arm64: GICv3 ITS emulation
Date: Tue,  5 Jul 2016 12:22:52 +0100
Message-ID: <20160705112309.28877-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

this series allows those KVM guests that use an emulated GICv3 to use LPIs
as well, though in the moment this is limited to emulated PCI devices.
This is based on kvmarm/queue, which now only features the new VGIC
implementation.

This time only smaller corrections for the KVM ITS emulation support:
I addressed the review comments, which pointed out some vgic_put_irq()
omissions. Also the GICv2 init sequence has changed, so that we can now
bail out a KVM_DEVICE init without leaking a HYP mapping.
Also a bug in the MAPC emulation was fixed, which allowed multiple
mappings of the same collection ID.
The KVM_DEVICE init sequence has now some checks to ensure the right
order. The requirements are a bit stricter than for the GICv2/GICv3
devices: we need to setup the mapping address before calling the
INIT ioctl. This apparently has some implications on QEMU, I just need
to be convinced that we should follow QEMU's approach. It seems to look
a bit ugly to stash the ITS init into the existing GICv3 code, especially
since the ITS is a separate, optional device.

You can find all of this code (and the prerequisites) in the
its-emul/v8 branch of my repository [1].
This has been briefly tested on the model and on GICv3 hardware.
If you have GICv3 capable hardware, please test it on your setup.
Also of course any review comments are very welcome!

Cheers,
Andre.

Changelog v7..v8:
- rebase on old-VGIC removal patch
- add missing vgic_put_irq()s
- check and ensure proper ITS initialisation sequence
- avoid double collection mapping
- renaming vits_ function prefixes to vgic_its_
- properly setup PENDBASER (for new VGIC now)
- change vgic_v2_probe init order to allow clean exit

Changelog v6..v7:
- use kref reference counting
- remove RCU usage from lpi_list, use spinlock instead
- copy list of LPIs before accessing guest memory
- introduce kvm_io_bus_get_dev()
- refactor parts of arm-gic-v3.h header file
- provide proper initial values for redistributor and ITS base registers
- rework sanitisation of base registers
- rework VGIC MMIO dispatching to differentiate between VGIC parts
- smaller fixes, also comments and commit messages amended

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

This series is based on kvmarm/queue and can be found at the
its-emul/v8 branch of this repository [1].
For this to be used you need a GICv3 host machine (a fast model would
do), though it does not rely on any host ITS bits (neither in hardware
or software).

To test this you can use the kvmtool patches available in the "its-v6"
branch here [2].
Start a guest with: "$ lkvm run --irqchip=gicv3-its --force-pci"
and see the ITS being used for instance by the virtio devices.

[1]: git://linux-arm.org/linux-ap.git
     http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/its-emul/v8
[2]: git://linux-arm.org/kvmtool.git
     http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its-v6
[3]: http://arminfo.emea.arm.com/help/topic/com.arm.doc.ihi0069a/IHI0069A_gic_architecture_specification.pdf

Andre Przywara (17):
  KVM: arm/arm64: move redistributor kvm_io_devices
  KVM: arm/arm64: check return value for kvm_register_vgic_device
  KVM: extend struct kvm_msi to hold a 32-bit device ID
  KVM: arm/arm64: extend arch CAP checks to allow per-VM capabilities
  KVM: kvm_io_bus: add kvm_io_bus_get_dev() call
  KVM: arm/arm64: VGIC: add refcounting for IRQs
  irqchip: refactor and add GICv3 definitions
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
 arch/arm64/kvm/reset.c                         |    8 +-
 include/kvm/arm_vgic.h                         |   66 +-
 include/linux/irqchip/arm-gic-v3.h             |  165 ++-
 include/linux/kvm_host.h                       |    2 +
 include/uapi/linux/kvm.h                       |    7 +-
 virt/kvm/arm/vgic/vgic-init.c                  |    9 +-
 virt/kvm/arm/vgic/vgic-its.c                   | 1425 ++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-kvm-device.c            |   22 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c               |   48 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c               |  301 ++++-
 virt/kvm/arm/vgic/vgic-mmio.c                  |   61 +-
 virt/kvm/arm/vgic/vgic-mmio.h                  |   45 +-
 virt/kvm/arm/vgic/vgic-v2.c                    |   12 +-
 virt/kvm/arm/vgic/vgic-v3.c                    |   29 +-
 virt/kvm/arm/vgic/vgic.c                       |  108 +-
 virt/kvm/arm/vgic/vgic.h                       |   37 +-
 virt/kvm/kvm_main.c                            |   24 +
 25 files changed, 2216 insertions(+), 203 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-its.c

-- 
2.9.0

