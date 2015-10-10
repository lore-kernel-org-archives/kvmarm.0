From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Sat, 10 Oct 2015 17:37:44 +0200
Message-ID: <20151010153744.GH29128@cbox>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, eric.auger@linaro.org, p.fedin@samsung.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,


On Wed, Oct 07, 2015 at 03:55:10PM +0100, Andre Przywara wrote:
> Hi,
> 
> another respin and rebase of the ITS emulation series.
> Major changes compared to v2 (beside some minor things like added
> comments and function renames) are the rebasing and adaption to 4.3-rc
> and Christoffer's timer rework series. Also the locking has been
> reworked to cope with the dependencies of the its and the dist lock
> in connection with the PROPBASER/PENDBASER and the command handling.
> For a more detailed changelog see below or look at the respective
> commit messages.
> 
> This should address most of the comments I got on the list.
> Many thanks to the diligent reviewers!
> I didn't bother to fine-tune patch 01/16 too much, as I guess there
> will be more discussion around this based on Pavel's latest post.
> 
> These patches go on top of Christoffer's timer rework series [1],
> which itself is on top of 4.3-rc2.
> You can find all of this code in the its-emul/v3 branch of my
> repository [2].

Thanks for rebasing the series!

Just a heads up that I may not be able to review this series for the
next 1-2 weeks, so I'm afraid it's not going to make it in for v4.4,
sorry.

Please let me know if this breaks expectations from everyone.

Othersie, I will try review it with due dilligence so it makes it in for
v4.5.

Best,
-Christoffer

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
> - introduce new KVM_CAP_MSI_DEVID capability to advertise device ID requirement
> - update, fix and add many comments
> - minor style changes as requested by reviewers
> 
> ---------------
> 
> The GICv3 ITS (Interrupt Translation Service) is a part of the
> ARM GICv3 interrupt controller [4] used for implementing MSIs.
> It specifies a new kind of interrupts (LPIs), which are mapped to
> establish a connection between a device, its MSI payload value and
> the target processor the IRQ is eventually delivered to.
> In order to allow using MSIs in an ARM64 KVM guest, we emulate this
> ITS widget in the kernel.
> The ITS works by reading commands written by software (from the guest
> in our case) into a (guest allocated) memory region and establishing
> the mapping between a device, the MSI payload and the target CPU.
> We parse these commands and update our internal data structures to
> reflect those changes. On an MSI injection we iterate those
> structures to learn the LPI number we have to inject.
> For the time being we use simple lists to hold the data, this is
> good enough for the small number of entries each of the components
> currently have. Should this become a performance bottleneck in the
> future, those can be extended to arrays or trees if needed.
> 
> Most of the code lives in a separate source file (its-emul.c), though
> there are some changes necessary both in vgic.c and vgic-v3-emul.c.
> 
> Patch 01/16 gets rid of the internal tracking of the used LR for
> an injected IRQ, see the commit message for more details.
> Patch 03/16 extends the KVM MSI ioctl to hold a device ID.
> Patch 04-06 make small changes to the existing VGIC code which make
> adaptions to the ITS later easier.
> The rest of the patches implement the ITS functionality step by step.
> For more details see the respective commit messages.
> 
> For the time being this series gives us the ability to use emulated
> PCI devices that can use MSIs in the guest. Those have to be
> triggered by letting the userland device emulation simulate the MSI
> write with the KVM_SIGNAL_MSI ioctl. This will be translated into
> the proper LPI by the ITS emulation and injected into the guest in
> the usual way (just with a higher IRQ number).
> 
> This series is based on 4.3-rc2 and can be found at the its-emul/v3
> branch of this repository [2].
> For this to be used you need a GICv3 host machine (a fast model would
> do), though it does not rely on any host ITS bits (neither in hardware
> or software).
> 
> To test this you can use the kvmtool patches available in the "its"
> branch here [3].
> Start a guest with: "$ lkvm run --irqchip=gicv3-its --force-pci"
> and see the ITS being used for instance by the virtio devices.
> 
> [1]: https://git.linaro.org/people/christoffer.dall/linux-kvm-arm.git/shortlog/refs/heads/timer-rework-v3
> [2]: git://linux-arm.org/linux-ap.git
>      http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/its-emul/v3
> [3]: git://linux-arm.org/kvmtool.git
>      http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/its
> [4]: http://arminfo.emea.arm.com/help/topic/com.arm.doc.ihi0069a/IHI0069A_gic_architecture_specification.pdf
> 
> Andre Przywara (16):
>   KVM: arm/arm64: VGIC: don't track used LRs in the distributor
>   KVM: arm/arm64: remove now unused code after stay-in-LR rework
>   KVM: extend struct kvm_msi to hold a 32-bit device ID
>   KVM: arm/arm64: add emulation model specific destroy function
>   KVM: arm/arm64: extend arch CAP checks to allow per-VM capabilities
>   KVM: arm/arm64: make GIC frame address initialization model specific
>   KVM: arm64: Introduce new MMIO region for the ITS base address
>   KVM: arm64: handle ITS related GICv3 redistributor registers
>   KVM: arm64: introduce ITS emulation file with stub functions
>   KVM: arm64: implement basic ITS register handlers
>   KVM: arm64: add data structures to model ITS interrupt translation
>   KVM: arm64: handle pending bit for LPIs in ITS emulation
>   KVM: arm64: sync LPI configuration and pending tables
>   KVM: arm64: implement ITS command queue command handlers
>   KVM: arm64: implement MSI injection in ITS emulation
>   KVM: arm64: enable ITS emulation as a virtual MSI controller
> 
>  Documentation/virtual/kvm/api.txt              |   14 +-
>  Documentation/virtual/kvm/devices/arm-vgic.txt |    9 +
>  arch/arm/include/asm/kvm_host.h                |    2 +-
>  arch/arm/kvm/arm.c                             |    2 +-
>  arch/arm64/include/asm/kvm_host.h              |    2 +-
>  arch/arm64/include/uapi/asm/kvm.h              |    2 +
>  arch/arm64/kvm/Kconfig                         |    1 +
>  arch/arm64/kvm/Makefile                        |    1 +
>  arch/arm64/kvm/reset.c                         |    8 +-
>  include/kvm/arm_vgic.h                         |   43 +-
>  include/linux/irqchip/arm-gic-v3.h             |   14 +-
>  include/uapi/linux/kvm.h                       |    5 +-
>  virt/kvm/arm/its-emul.c                        | 1187 ++++++++++++++++++++++++
>  virt/kvm/arm/its-emul.h                        |   55 ++
>  virt/kvm/arm/vgic-v2-emul.c                    |    3 +
>  virt/kvm/arm/vgic-v2.c                         |    1 +
>  virt/kvm/arm/vgic-v3-emul.c                    |  101 +-
>  virt/kvm/arm/vgic-v3.c                         |    1 +
>  virt/kvm/arm/vgic.c                            |  292 +++---
>  virt/kvm/arm/vgic.h                            |    3 +
>  20 files changed, 1601 insertions(+), 145 deletions(-)
>  create mode 100644 virt/kvm/arm/its-emul.c
>  create mode 100644 virt/kvm/arm/its-emul.h
> 
> -- 
> 2.5.1
> 
