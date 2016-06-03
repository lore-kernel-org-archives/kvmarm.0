From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 00/13] KVM: arm64: GICv3 ITS emulation
Date: Fri,  3 Jun 2016 15:02:39 +0100
Message-ID: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E180412DD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 09:58:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2GTMTts5sVp4 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jun 2016 09:58:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16D45412D0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jun 2016 09:58:26 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

please welcome a reworked version of the ITS emulation support.
It allows those KVM guests that use an emulated GICv3 to use LPIs as well,
though in the moment this is limited to emulated PCI devices.
This is based on v4.7-rc1 and only works with the new VGIC implementation.
There have been some modifications due to changes in the underlying
VGIC code (changed MMIO handlers, etc.).
Some other changes relate to the fact that any redistributor related
variables are now held in the vgic_cpu structure, so they are naturally
per VCPU.
Also this series supports multiple ITSes and makes them independent from
the distributor. There is a new KVM device, which can be created multiple
times.

You can find all of this code (and the prerequisites) in the
its-emul/v5 branch of my repository [1].
This has been briefly tested on the model and on GICv3 hardware.
Since there are quite some fundamental changes in this version, I expect
some issues in the code, so if you have GICv3 capable hardware, please
test it on your setup.
Also of course any review comments are very welcome!

Cheers,
Andre.

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

This series is based on 4.7-rc1 and can be found at the its-emul/v5 branch
of this repository [1].
For this to be used you need a GICv3 host machine (a fast model would
do), though it does not rely on any host ITS bits (neither in hardware
or software).

To test this you can use the kvmtool patches available in the "its-v5"
branch here [2].
Start a guest with: "$ lkvm run --irqchip=gicv3-its --force-pci"
and see the ITS being used for instance by the virtio devices.

[1]: git://linux-arm.org/linux-ap.git
     http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/its-emul/v5
[2]: git://linux-arm.org/kvmtool.git
     http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its-v5
[3]: http://arminfo.emea.arm.com/help/topic/com.arm.doc.ihi0069a/IHI0069A_gic_architecture_specification.pdf

Andre Przywara (13):
  KVM: arm/arm64: move redistributor kvm_io_devices
  KVM: arm/arm64: check return value for kvm_register_vgic_device
  KVM: extend struct kvm_msi to hold a 32-bit device ID
  KVM: arm/arm64: extend arch CAP checks to allow per-VM capabilities
  KVM: arm64: handle ITS related GICv3 redistributor registers
  KVM: arm64: introduce ITS emulation file with stub functions
  KVM: arm64: introduce new KVM ITS device
  KVM: arm64: implement basic ITS register handlers
  KVM: arm64: connect LPIs to the VGIC emulation
  KVM: arm64: sync LPI configuration and pending tables
  KVM: arm64: implement ITS command queue command handlers
  KVM: arm64: implement MSI injection in ITS emulation
  KVM: arm64: enable ITS emulation as a virtual MSI controller

 Documentation/virtual/kvm/api.txt              |   14 +-
 Documentation/virtual/kvm/devices/arm-vgic.txt |   23 +-
 arch/arm/include/asm/kvm_host.h                |    5 +-
 arch/arm/kvm/arm.c                             |    5 +-
 arch/arm64/include/asm/kvm_host.h              |    4 +-
 arch/arm64/include/uapi/asm/kvm.h              |    2 +
 arch/arm64/kvm/Kconfig                         |    1 +
 arch/arm64/kvm/Makefile                        |    1 +
 arch/arm64/kvm/reset.c                         |   12 +-
 include/kvm/vgic/vgic.h                        |   45 +-
 include/linux/irqchip/arm-gic-v3.h             |   30 +-
 include/uapi/linux/kvm.h                       |    7 +-
 virt/kvm/arm/vgic.c                            |    5 +
 virt/kvm/arm/vgic/vgic-init.c                  |   17 +-
 virt/kvm/arm/vgic/vgic-its.c                   | 1275 ++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-kvm-device.c            |   22 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c               |  130 ++-
 virt/kvm/arm/vgic/vgic-mmio.h                  |    6 +
 virt/kvm/arm/vgic/vgic-v2.c                    |    7 +-
 virt/kvm/arm/vgic/vgic-v3.c                    |   15 +-
 virt/kvm/arm/vgic/vgic.c                       |   10 +-
 virt/kvm/arm/vgic/vgic.h                       |   46 +-
 22 files changed, 1634 insertions(+), 48 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-its.c

-- 
2.8.2
