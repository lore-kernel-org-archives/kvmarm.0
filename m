From: Pavel Fedin <p.fedin@samsung.com>
Subject: PING: [PATCH v4 0/7] KVM: arm64: Implement API for vGICv3 live
 migration
Date: Tue, 06 Oct 2015 11:41:08 +0300
Message-ID: <00ca01d10012$bfd629b0$3f827d10$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1CD9412E6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Oct 2015 04:39:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id unwFW+oHuVRb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Oct 2015 04:39:18 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D5B94412D0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Oct 2015 04:39:18 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVS00JYHISM1N40@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 06 Oct 2015 09:41:10 +0100 (BST)
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello! Sorry if you're terribly busy, but... small gentle PING...

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

> -----Original Message-----
> From: kvmarm-bounces@lists.cs.columbia.edu [mailto:kvmarm-bounces@lists.cs.columbia.edu] On
> Behalf Of Pavel Fedin
> Sent: Monday, September 28, 2015 6:27 PM
> To: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org
> Cc: Marc Zyngier; Andre Przywara
> Subject: [PATCH v4 0/7] KVM: arm64: Implement API for vGICv3 live migration
> 
> This patchset adds necessary userspace API in order to support vGICv3 live
> migration. GICv3 registers are accessed using device attribute ioctls,
> similar to GICv2.
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
> Pavel Fedin (7):
>   KVM: arm/arm64: Move endianness conversion out of
>     vgic_attr_regs_access()
>   KVM: arm/arm64: Refactor vGIC attributes handling code
>   KVM: arm/arm64: Fix the documentation
>   KVM: arm64: Implement vGICv3 distributor and redistributor access from
>     userspace
>   KVM: arm64: Refactor system register handlers
>   KVM: arm64: Introduce find_reg_by_id()
>   Implement vGICv3 CPU interface access
> 
>  Documentation/virtual/kvm/devices/arm-vgic.txt |  90 ++++++-
>  arch/arm64/include/uapi/asm/kvm.h              |  11 +-
>  arch/arm64/kvm/sys_regs.c                      |  83 +++---
>  arch/arm64/kvm/sys_regs.h                      |   8 +-
>  arch/arm64/kvm/sys_regs_generic_v8.c           |   2 +-
>  include/linux/irqchip/arm-gic-v3.h             |  18 +-
>  virt/kvm/arm/vgic-v2-emul.c                    | 122 ++-------
>  virt/kvm/arm/vgic-v3-emul.c                    | 338 ++++++++++++++++++++++++-
>  virt/kvm/arm/vgic.c                            |  65 +++++
>  virt/kvm/arm/vgic.h                            |   4 +
>  10 files changed, 571 insertions(+), 170 deletions(-)
> 
> --
> 2.4.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
