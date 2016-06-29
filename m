From: Bharat Bhushan <bharat.bhushan@nxp.com>
Subject: RE: [PATCH v7 00/17] KVM: arm64: GICv3 ITS emulation
Date: Wed, 29 Jun 2016 04:43:23 +0000
Message-ID: <DB5PR04MB0997B9A41C3C79F45CAC6C989A230@DB5PR04MB0997.eurprd04.prod.outlook.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45A9549B45
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 00:38:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k6RRBKyJzpGv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jun 2016 00:38:15 -0400 (EDT)
Received: from emea01-am1-obe.outbound.protection.outlook.com
 (mail-am1on0086.outbound.protection.outlook.com [157.56.112.86])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDF2249B2F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 00:38:14 -0400 (EDT)
In-Reply-To: <20160628123230.26255-1-andre.przywara@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric
 Auger <eric.auger@redhat.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu



> -----Original Message-----
> From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-
> bounces@lists.cs.columbia.edu] On Behalf Of Andre Przywara
> Sent: Tuesday, June 28, 2016 6:02 PM
> To: Marc Zyngier <marc.zyngier@arm.com>; Christoffer Dall
> <christoffer.dall@linaro.org>; Eric Auger <eric.auger@redhat.com>
> Cc: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org
> Subject: [PATCH v7 00/17] KVM: arm64: GICv3 ITS emulation
> 
> Hi,
> 
> another try on the KVM ITS emulation support.
> It allows those KVM guests that use an emulated GICv3 to use LPIs as well,
> though in the moment this is limited to emulated PCI devices.
> This is based on kvm-arm-for-v4.7-rc2 and relies on the new VGIC
> implementation.
> 
> Compared to the last drop there have been some changes to the code:
> The reference counting has been rewritten to use the kref infrastructure.
> This has some implications on the rest of the code, for instance the locking
> for the LPI list got changed. There is no RCU usage anymore, instead the LPI
> list is now protected by a spinlock. To overcome the problem where we need
> to access guest memory while holding the lock, we create a snapshot of the
> LPI list, so we can iterate over LPIs with the lock dropped.
> Also the base register sanitisation has been reworked completely, which
> includes some changes to the arm-gic-v3.h header file (as a separate patch
> 07/17). I hope I covered all the subtleties of those bits.
> Also the MMIO framework saw some changes, we now tag the different GIC
> regions explicitly and are able to call the different handlers explicitly.
> Also Patch 05/17 extends the kvm-io-bus framework with a small function to
> get the kvm_io_device structure for a given MMIO address. This allows us to
> keep the knowledge of all the ITSes in this framework, but still get the
> respective ITS pointer easily without reverting to "fake" MMIO accesses.
> Also all the smaller review comments have been addressed.
> 
> You can find all of this code (and the prerequisites) in the
> its-emul/v7 branch of my repository [1].
> This has been briefly tested on the model and on GICv3 hardware.
> If you have GICv3 capable hardware, please test it on your setup.

We have GICv3 capable hardware and we can test these on that.
How you are testing these changes? QEMU side changes are also required, can you share those changes?

Thanks
-Bharat

> Also of course any review comments are very welcome!
> 
> Cheers,
> Andre.
> 
> Changelog v6..v7:
> - use kref reference counting
> - remove RCU usage from lpi_list, use spinlock instead
> - copy list of LPIs before accessing guest memory
> - introduce kvm_io_bus_get_dev()
> - refactor parts of arm-gic-v3.h header file
> - provide proper initial values for redistributor and ITS base registers
> - rework sanitisation of base registers
> - rework VGIC MMIO dispatching to differentiate between VGIC parts
> - smaller fixes, also comments and commit messages amended
> 
> Changelog v5..v6:
> - remove its_list from VGIC code
> - add lpi_list and accessor functions
> - introduce reference counting to struct vgic_irq
> - replace its_lock spinlock with its_cmd and its_lock mutexes
> - simplify guest memory accesses (due to the new mutexes)
> - avoid unnecessary affinity updates
> - refine base register address masking
> - introduce sanity checks for PROPBASER and PENDBASER
> - implement BASER<n> registers
> - pass struct vgic_its directly into the MMIO handlers
> - convert KVM_SIGNAL_MSI ioctl into an MMIO write
> - add explicit INIT ioctl to the ITS KVM device
> - adjusting comments and commit messages
> 
> Changelog v4..v5:
> - adapting to final new VGIC (MMIO handlers, etc.)
> - new KVM device to model an ITS, multiple instances allowed
> - move redistributor data into struct vgic_cpu
> - separate distributor and ITS(es)
> - various bug fixes and amended comments after review comments
> 
> Changelog v3..v4:
> - adapting to new VGIC (changes in IRQ injection mechanism)
> 
> Changelog v2..v3:
> - adapt to 4.3-rc and Christoffer's timer rework
> - adapt spin locks on handling PROPBASER/PENDBASER registers
> - rework locking in ITS command handling (dropping dist where needed)
> - only clear LPI pending bit if LPI could actually be queued
> - simplify GICR_CTLR handling
> - properly free ITTEs (including our pending bitmap)
> - fix corner cases with unmapped collections
> - keep retire_lr() around
> - rename vgic_handle_base_register to vgic_reg64_access()
> - use kcalloc instead of kmalloc
> - minor fixes, renames and added comments
> 
> Changelog v1..v2
> - fix issues when using non-ITS GICv3 emulation
> - streamline frame address initialization (new patch 05/15)
> - preallocate buffer memory for reading from guest's memory
> - move locking into the actual command handlers
> -   preallocate memory for new structures if needed
> - use non-atomic __set_bit() and __clear_bit() when under the lock
> - add INT command handler to allow LPI injection from the guest
> - rewrite CWRITER handler to align with new locking scheme
> - remove unneeded CONFIG_HAVE_KVM_MSI #ifdefs
> - check memory table size against our LPI limit (65536 interrupts)
> - observe initial gap of 1024 interrupts in pending table
> - use term "configuration table" to be in line with the spec
> - clarify and extend documentation on API extensions
> - introduce new KVM_CAP_MSI_DEVID capability to advertise device ID
> requirement
> - update, fix and add many comments
> - minor style changes as requested by reviewers
> 
> ---------------
> 
> The GICv3 ITS (Interrupt Translation Service) is a part of the ARM GICv3
> interrupt controller [3] used for implementing MSIs.
> It specifies a new kind of interrupts (LPIs), which are mapped to establish a
> connection between a device, its MSI payload value and the target processor
> the IRQ is eventually delivered to.
> In order to allow using MSIs in an ARM64 KVM guest, we emulate this ITS
> widget in the kernel.
> The ITS works by reading commands written by software (from the guest in
> our case) into a (guest allocated) memory region and establishing the
> mapping between a device, the MSI payload and the target CPU.
> We parse these commands and update our internal data structures to reflect
> those changes. On an MSI injection we iterate those structures to learn the
> LPI number we have to inject.
> For the time being we use simple lists to hold the data, this is good enough
> for the small number of entries each of the components currently have.
> Should this become a performance bottleneck in the future, those can be
> extended to arrays or trees if needed.
> 
> Most of the code lives in a separate source file (vgic-its.c), though there are
> some changes necessary in the existing VGIC files.
> 
> For the time being this series gives us the ability to use emulated PCI devices
> that can use MSIs in the guest. Those have to be triggered by letting the
> userland device emulation simulate the MSI write with the
> KVM_SIGNAL_MSI ioctl. This will be translated into the proper LPI by the ITS
> emulation and injected into the guest in the usual way (just with a higher IRQ
> number).
> 
> This series is based on kvm-arm-for-v4.7-rc2 and can be found at the
> its-emul/v7 branch of this repository [1].
> For this to be used you need a GICv3 host machine (a fast model would do),
> though it does not rely on any host ITS bits (neither in hardware or software).
> 
> To test this you can use the kvmtool patches available in the "its-v6"
> branch here [2].
> Start a guest with: "$ lkvm run --irqchip=gicv3-its --force-pci"
> and see the ITS being used for instance by the virtio devices.
> 
> [1]: git://linux-arm.org/linux-ap.git
>      http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/its-
> emul/v7
> [2]: git://linux-arm.org/kvmtool.git
>      http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its-v6
> [3]:
> http://arminfo.emea.arm.com/help/topic/com.arm.doc.ihi0069a/IHI0069A_g
> ic_architecture_specification.pdf
> 
> Andre Przywara (17):
>   KVM: arm/arm64: move redistributor kvm_io_devices
>   KVM: arm/arm64: check return value for kvm_register_vgic_device
>   KVM: extend struct kvm_msi to hold a 32-bit device ID
>   KVM: arm/arm64: extend arch CAP checks to allow per-VM capabilities
>   KVM: kvm_io_bus: add kvm_io_bus_get_dev() call
>   KVM: arm/arm64: VGIC: add refcounting for IRQs
>   irqchip: refactor and add GICv3 definitions
>   KVM: arm64: handle ITS related GICv3 redistributor registers
>   KVM: arm64: introduce ITS emulation file with MMIO framework
>   KVM: arm64: introduce new KVM ITS device
>   KVM: arm64: implement basic ITS register handlers
>   KVM: arm64: connect LPIs to the VGIC emulation
>   KVM: arm64: read initial LPI pending table
>   KVM: arm64: allow updates of LPI configuration table
>   KVM: arm64: implement ITS command queue command handlers
>   KVM: arm64: implement MSI injection in ITS emulation
>   KVM: arm64: enable ITS emulation as a virtual MSI controller
> 
>  Documentation/virtual/kvm/api.txt              |   14 +-
>  Documentation/virtual/kvm/devices/arm-vgic.txt |   25 +-
>  arch/arm/include/asm/kvm_host.h                |    2 +-
>  arch/arm/kvm/arm.c                             |    3 +-
>  arch/arm64/include/asm/kvm_host.h              |    2 +-
>  arch/arm64/include/uapi/asm/kvm.h              |    2 +
>  arch/arm64/kvm/Kconfig                         |    1 +
>  arch/arm64/kvm/Makefile                        |    1 +
>  arch/arm64/kvm/reset.c                         |   12 +-
>  include/kvm/vgic/vgic.h                        |   64 +-
>  include/linux/irqchip/arm-gic-v3.h             |  165 ++-
>  include/linux/kvm_host.h                       |    2 +
>  include/uapi/linux/kvm.h                       |    7 +-
>  virt/kvm/arm/vgic-v3.c                         |   11 +-
>  virt/kvm/arm/vgic.c                            |    5 +
>  virt/kvm/arm/vgic/vgic-init.c                  |    9 +-
>  virt/kvm/arm/vgic/vgic-its.c                   | 1408 ++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-kvm-device.c            |   22 +-
>  virt/kvm/arm/vgic/vgic-mmio-v2.c               |   48 +-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c               |  291 ++++-
>  virt/kvm/arm/vgic/vgic-mmio.c                  |   58 +-
>  virt/kvm/arm/vgic/vgic-mmio.h                  |   45 +-
>  virt/kvm/arm/vgic/vgic-v2.c                    |    8 +-
>  virt/kvm/arm/vgic/vgic-v3.c                    |   18 +-
>  virt/kvm/arm/vgic/vgic.c                       |  101 +-
>  virt/kvm/arm/vgic/vgic.h                       |   37 +-
>  virt/kvm/kvm_main.c                            |   24 +
>  27 files changed, 2192 insertions(+), 193 deletions(-)  create mode 100644
> virt/kvm/arm/vgic/vgic-its.c
> 
> --
> 2.9.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
