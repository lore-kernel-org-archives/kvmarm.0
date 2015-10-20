From: Pavel Fedin <p.fedin@samsung.com>
Subject: PING: [PATCH v5 0/7] KVM: arm64: Implement API for vGICv3 live
 migration
Date: Tue, 20 Oct 2015 12:30:41 +0300
Message-ID: <022801d10b19$fdaf5830$f90e0890$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: 'Christoffer Dall' <christoffer.dall@linaro.org>, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello! How are things going? There was lots of activity, discussions, and then - silence...

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Pavel Fedin
> Sent: Monday, October 12, 2015 11:30 AM
> To: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org
> Cc: Christoffer Dall; Marc Zyngier; Andre Przywara
> Subject: [PATCH v5 0/7] KVM: arm64: Implement API for vGICv3 live migration
> 
> This patchset adds necessary userspace API in order to support vGICv3 live
> migration. GICv3 registers are accessed using device attribute ioctls,
> similar to GICv2.
> 
> Whoever wants to test it, please note that this version is not
> binary-compatible with previous one, the API has been seriously changed.
> qemu patchess will be posted in some time.
> 
> v4 => v5:
> - Adapted to new API by Peter Maydell, Marc Zyngier and Christoffer Dall.
>   Acked-by's on the documentation were dropped, just in case, because i
>   slightly adjusted it. Additionally, i merged all doc updates into one
>   patch.
> 
> v3 => v4:
> - Split pure refactoring from anything else
> - Documentation brought up to date
> - Cleaned up 'mmio' structure usage in vgic_attr_regs_access(),
>   use call_range_handler() for 64-bit access handling
> - Rebased on new linux-next
> 
> v2 => v3:
> - KVM_DEV_ARM_VGIC_CPUID_MASK enlarged to 20 bits, allowing more than 256
>   CPUs.
> - Bug fix: Correctly set mmio->private, necessary for redistributor access.
> - Added accessors for ICC_AP0R and ICC_AP1R registers
> - Rebased on new linux-next
> 
> v1 => v2:
> - Do not use generic register get/set API for CPU interface, use only
>   device attributes.
> - Introduce size specifier for distributor and redistributor register
>   accesses, do not assume size any more.
> - Lots of refactor and reusable code extraction.
> - Added forgotten documentation
> 
> Christoffer Dall (1):
>   KVM: arm/arm64: Update API documentation
> 
> Pavel Fedin (6):
>   KVM: arm/arm64: Move endianess conversion out of
>     vgic_attr_regs_access()
>   KVM: arm/arm64: Refactor vGIC attributes handling code
>   KVM: arm64: Implement vGICv3 distributor and redistributor access from
>     userspace
>   KVM: arm64: Refactor system register handlers
>   KVM: arm64: Introduce find_reg_by_id()
>   KVM: arm64: Implement vGICv3 CPU interface access
> 
>  Documentation/virtual/kvm/devices/arm-vgic-v3.txt | 117 ++++++++
>  Documentation/virtual/kvm/devices/arm-vgic.txt    |  41 +--
>  arch/arm64/include/uapi/asm/kvm.h                 |  17 +-
>  arch/arm64/kvm/sys_regs.c                         |  83 +++---
>  arch/arm64/kvm/sys_regs.h                         |   8 +-
>  arch/arm64/kvm/sys_regs_generic_v8.c              |   2 +-
>  include/linux/irqchip/arm-gic-v3.h                |  19 +-
>  virt/kvm/arm/vgic-v2-emul.c                       | 124 ++------
>  virt/kvm/arm/vgic-v3-emul.c                       | 343 +++++++++++++++++++++-
>  virt/kvm/arm/vgic.c                               |  57 ++++
>  virt/kvm/arm/vgic.h                               |   3 +
>  11 files changed, 630 insertions(+), 184 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> 
> --
> 2.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

