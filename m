From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [RFC PATCH 00/45] KVM: arm/arm64: Rework virtual GIC emulation
Date: Sat, 26 Mar 2016 02:11:26 +0000
Message-ID: <56F5EFCE.1040307@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Diana Madalina Craciun <diana.craciun@nxp.com>, lkp@intel.com
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 25/03/16 02:04, Andre Przywara wrote:
> This series is a joint effort to re-implement KVM's GIC emulation.

Forgot to mention:
This series is based on an older version of kvmarm.git/next, which is
roughly the pull request that got merged into 4.6-rc0. It applies to the
current master, so I suggest people use 4.6-rc1 as a base once this is
released.

A git tree containing this series and the prerequisites can be found on
linux-arm.org:

git://linux-arm.org/linux-ap.git
http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/vgic-new/rfc

Cheers,
Andre.

> 
> While the current implementation is centered around providing
> efficient MMIO emulation, the hot path for most guests is actually
> the guest entry and exit, which currently is rather costly.
> Also the existing emulation has a global distributor lock, which
> quickly becomes a bottleneck once the number of VCPUs increases.
> Additionally the emulation was originally designed for GICv2, adding
> GICv3 ITS emulation support to this proved to be rather painful.
> Last, but not least the existing code became less and less
> maintainable, with many special cases handled explicitly.
> 
> The new implementation is build around a struct vgic_irq data data
> structure, which holds all information about a virtual interrupt.
> Interruts which should be injected are hold in a per-VCPU list, this
> make the entry/exit path much more efficient. Also the new structure
> allows to have more fine grained locking - per IRQ and per VCPU -
> getting rid of the global distributor lock.
> As a result of the new design ITS emulation fits in more nicely, the
> respective code will be provided as a follow-up series.
> 
> This series implements the same feature set as the existing emulation,
> as a goodie we now implement priorities correctly.
> To allow an easy transition with good test coverage, but still maintain
> stability, both implementations live side by side, selectable via a
> Kconfig option. The default is the new implementation.
> If this code proves to be reliable, we will later remove the current
> implementation with an extra patch set.
> 
> Please have a look at the series, review it and give the code some
> serious testing (and possibly debugging). All feedback is appreciated.
> 
> Cheers,
> Andre.
> 
> Andre Przywara (26):
>   KVM: arm/arm64: add missing MMIO data write-back
>   KVM: arm/arm64: pmu: abstract access to number of SPIs
>   KVM: arm/arm64: arch_timer: rework VGIC <-> timer interface
>   KVM: arm/arm64: vgic-new: Add MMIO handling framework
>   KVM: arm/arm64: vgic-new: Export register access interface
>   KVM: arm/arm64: vgic-new: Add CTLR, TYPER and IIDR handlers
>   KVM: arm/arm64: vgic-new: Add ENABLE registers handlers
>   KVM: arm/arm64: vgic-new: Add PENDING registers handlers
>   KVM: arm/arm64: vgic-new: Add PRIORITY registers handlers
>   KVM: arm/arm64: vgic-new: Add ACTIVE registers handlers
>   KVM: arm/arm64: vgic-new: Add CONFIG registers handlers
>   KVM: arm/arm64: vgic-new: Add TARGET registers handlers
>   KVM: arm/arm64: vgic-new: Add SGIR register handler
>   KVM: arm/arm64: vgic-new: Add SGIPENDR register handlers
>   KVM: arm/arm64: vgic-new: Add GICv3 emulation framework
>   KVM: arm/arm64: vgic-new: Add GICv3 CTLR, IIDR, TYPER handlers
>   KVM: arm/arm64: vgic-new: Add GICv3 redistributor TYPER handler
>   KVM: arm/arm64: vgic-new: Add GICv3 IDREGS register handler
>   KVM: arm/arm64: vgic-new: Add GICv3 IROUTER register handlers
>   KVM: arm/arm64: vgic-new: Add GICv3 SGI system register trap handler
>   KVM: arm/arm64: vgic-new: Add userland access to VGIC dist registers
>   KVM: arm/arm64: vgic-new: Add GICH_VMCR accessors
>   KVM: arm/arm64: vgic-new: Add userland GIC CPU interface access
>   KVM: arm/arm64: vgic-new: implement mapped IRQ handling
>   KVM: arm/arm64: vgic-new: Add dummy MSI implementation
>   KVM: arm/arm64: vgic-new: enable build
> 
> Christoffer Dall (5):
>   KVM: arm/arm64: vgic-new: Add data structure definitions
>   KVM: arm/arm64: vgic-new: Add acccessor to new struct vgic_irq
>     instance
>   KVM: arm/arm64: vgic-new: Implement virtual IRQ injection
>   KVM: arm/arm64: vgic-new: Add vgic GICv2 change_affinity
>   KVM: arm/arm64: vgic-new: Add IRQ sorting
> 
> Eric Auger (12):
>   KVM: arm/arm64: vgic-new: Implement kvm_vgic_vcpu_pending_irq
>   KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM device ops registration
>   KVM: arm/arm64: vgic-new: vgic_kvm_device:
>     KVM_DEV_ARM_VGIC_GRP_NR_IRQS
>   KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM_DEV_ARM_VGIC_GRP_CTRL
>   KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM_DEV_ARM_VGIC_GRP_ADDR
>   KVM: arm/arm64: vgic-new: vgic_kvm_device: access to VGIC registers
>   KVM: arm/arm64: vgic-new: vgic_kvm_device: implement kvm_vgic_addr
>   KVM: arm/arm64: vgic-new: vgic_init: implement kvm_vgic_hyp_init
>   KVM: arm/arm64: vgic-new: vgic_init: implement vgic_create
>   KVM: arm/arm64: vgic-new: vgic_init: implement vgic_init
>   KVM: arm/arm64: vgic-new: vgic_init: implement map_resources
>   KVM: arm/arm64: vgic-new: Add vgic_v2/v3_enable
> 
> Marc Zyngier (2):
>   KVM: arm/arm64: vgic-new: Add GICv2 IRQ sync/flush
>   KVM: arm/arm64: vgic-new: Add GICv3 world switch backend
> 
>  arch/arm/kvm/Kconfig                |    7 +
>  arch/arm/kvm/Makefile               |   10 +
>  arch/arm/kvm/mmio.c                 |    2 +-
>  arch/arm64/kvm/Kconfig              |    7 +
>  arch/arm64/kvm/Makefile             |   10 +
>  include/kvm/arm_vgic.h              |   14 +-
>  include/kvm/vgic/vgic.h             |  256 +++++++
>  virt/kvm/arm/arch_timer.c           |   11 +-
>  virt/kvm/arm/pmu.c                  |    2 +-
>  virt/kvm/arm/vgic.c                 |   18 +-
>  virt/kvm/arm/vgic/vgic-v2.c         |  381 +++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c         |  357 ++++++++++
>  virt/kvm/arm/vgic/vgic.c            |  614 +++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h            |  136 ++++
>  virt/kvm/arm/vgic/vgic_init.c       |  447 ++++++++++++
>  virt/kvm/arm/vgic/vgic_irqfd.c      |   51 ++
>  virt/kvm/arm/vgic/vgic_kvm_device.c |  522 ++++++++++++++
>  virt/kvm/arm/vgic/vgic_mmio.c       | 1277 +++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic_mmio.h       |   47 ++
>  19 files changed, 4149 insertions(+), 20 deletions(-)
>  create mode 100644 include/kvm/vgic/vgic.h
>  create mode 100644 virt/kvm/arm/vgic/vgic-v2.c
>  create mode 100644 virt/kvm/arm/vgic/vgic-v3.c
>  create mode 100644 virt/kvm/arm/vgic/vgic.c
>  create mode 100644 virt/kvm/arm/vgic/vgic.h
>  create mode 100644 virt/kvm/arm/vgic/vgic_init.c
>  create mode 100644 virt/kvm/arm/vgic/vgic_irqfd.c
>  create mode 100644 virt/kvm/arm/vgic/vgic_kvm_device.c
>  create mode 100644 virt/kvm/arm/vgic/vgic_mmio.c
>  create mode 100644 virt/kvm/arm/vgic/vgic_mmio.h
> 

