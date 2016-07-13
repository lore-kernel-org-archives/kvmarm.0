From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v9 00/17] KVM: arm64: GICv3 ITS emulation
Date: Wed, 13 Jul 2016 02:58:52 +0100
Message-ID: <20160713015909.28793-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3323F41390
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2016 21:53:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xhWZFUwb1U5U for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2016 21:53:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AAE949B2C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2016 21:53:02 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

this series allows those KVM guests that use an emulated GICv3 to use LPIs
as well, though in the moment this is limited to emulated PCI devices.
This is based on kvmarm/queue, which now only features the new VGIC
implementation.

Another round of changes after another round of review: some bugs fixed,
some reworks in various places. The register sanitisation has been changed
to be more readable and to add some missing masking.
The MMIO dispatching has been simplified (region type no longer in each
register description). Also the its_lock is now taken already in the
command dispatching function instead of each command handler, which
removes quite some "goto out_unlock;" and return value variables.
Also it turned out we can get rid of the special vgic_put_irq_locked()
variant. The changelog below holds a more detailed list.

You can find all of this code (and the prerequisites) in the
its-emul/v9 branch of my repository [1].
This has been briefly tested on the model and on GICv3 hardware, with
lockdep debugging enabled. If you have GICv3 capable hardware, please
test it on your setup.
Also of course any review comments are very welcome!

Cheers,
Andre.

Changelog v8..v9:
- MMIO dispatching now no longer holds iodev type in each register
- indirect bit is now cleared for collections
- sanitisation functions reworked (no extra masking, taking
  register specific masks)
- make PROPBASER/PENDBASER updates atomic
- move vgic_its_get_lpi to vgic.c
- fix potential race in vgic_add_lpi
- add comments on puts and gets if not obviously symmetric
- simplify copy_lpi_list (no get/put anymore)
- remove vgic_put_irq_locked()
- remove update_lpi_config_filtered() wrapper
- take its_lock in vgic_its_handle_command() already
- move PENDBASER/PROPBASER RES0 masking into sanitise functions
- properly mask *BASER registers to only support 48 bits
- cache last read byte in its_sync_lpi_pending_table()
- fix memory leak with LPI list copying

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
     http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/its-emul/v9
[2]: git://linux-arm.org/kvmtool.git
     http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its-v6
[3]: http://infocenter.arm.com/help/topic/com.arm.doc.ihi0069b/index.html

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
 include/kvm/arm_vgic.h                         |   74 +-
 include/linux/irqchip/arm-gic-v3.h             |  174 ++-
 include/linux/kvm_host.h                       |    2 +
 include/uapi/linux/kvm.h                       |    7 +-
 virt/kvm/arm/vgic/vgic-init.c                  |    9 +-
 virt/kvm/arm/vgic/vgic-its.c                   | 1423 ++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-kvm-device.c            |   22 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c               |    8 +
 virt/kvm/arm/vgic/vgic-mmio-v3.c               |  247 +++-
 virt/kvm/arm/vgic/vgic-mmio.c                  |   62 +-
 virt/kvm/arm/vgic/vgic-mmio.h                  |   31 +-
 virt/kvm/arm/vgic/vgic-v2.c                    |   12 +-
 virt/kvm/arm/vgic/vgic-v3.c                    |   29 +-
 virt/kvm/arm/vgic/vgic.c                       |  132 ++-
 virt/kvm/arm/vgic/vgic.h                       |   30 +-
 virt/kvm/kvm_main.c                            |   24 +
 25 files changed, 2196 insertions(+), 148 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-its.c

-- 
2.9.0
