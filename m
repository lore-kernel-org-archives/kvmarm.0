From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [PATCH v7 6/7] arm/arm64: vgic: Implement VGICv3 CPU interface
 access
Date: Wed, 28 Sep 2016 12:48:49 +0530
Message-ID: <CALicx6tuaNAaXoD8_dwwBkw1D8iHsufKSdM6ki4iq=5+RzevMg@mail.gmail.com>
References: <1474645482-28131-1-git-send-email-vijay.kilari@gmail.com>
 <1474645482-28131-7-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86FE54998D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Sep 2016 03:09:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nco+6j9CmdA3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Sep 2016 03:09:26 -0400 (EDT)
Received: from mail-ua0-f193.google.com (mail-ua0-f193.google.com
 [209.85.217.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5260F413E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Sep 2016 03:09:25 -0400 (EDT)
Received: by mail-ua0-f193.google.com with SMTP id i25so1172417uab.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Sep 2016 00:18:50 -0700 (PDT)
In-Reply-To: <1474645482-28131-7-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Peter Maydell <peter.maydell@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 23, 2016 at 9:14 PM,  <vijay.kilari@gmail.com> wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>
> VGICv3 CPU interface registers are accessed using
> KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
> as 64-bit. The cpu MPIDR value is passed along with register id.
> is used to identify the cpu for registers access.
>
> The version of VGIC v3 specification is define here
> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
>
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> ---
>  arch/arm64/include/uapi/asm/kvm.h   |   3 +
>  arch/arm64/kvm/Makefile             |   1 +
>  include/kvm/arm_vgic.h              |   9 +
>  virt/kvm/arm/vgic/vgic-kvm-device.c |  27 +++
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  19 +++
>  virt/kvm/arm/vgic/vgic-sys-reg-v3.c | 324 ++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c         |   8 +
>  virt/kvm/arm/vgic/vgic.h            |   4 +
>  8 files changed, 395 insertions(+)
>
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 56dc08d..91c7137 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -206,9 +206,12 @@ struct kvm_arch_memory_slot {
>                         (0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
>  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT        0
>  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK (0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
> +#define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
>  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS   3
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL      4
>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
> +#define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
> +
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT   0
>
>  /* Device Control API on vcpu fd */
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index d50a82a..1a14e29 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -32,5 +32,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-sys-reg-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 002f092..730a18a 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -71,6 +71,9 @@ struct vgic_global {
>
>         /* GIC system register CPU interface */
>         struct static_key_false gicv3_cpuif;
> +
> +       /* Cache ICH_VTR_EL2 reg value */
> +       u32                     ich_vtr_el2;
>  };
>
>  extern struct vgic_global kvm_vgic_global_state;
> @@ -269,6 +272,12 @@ struct vgic_cpu {
>         u64 pendbaser;
>
>         bool lpis_enabled;
> +
> +       /* Cache guest priority bits */
> +       u32 num_pri_bits;
> +
> +       /* Cache guest interrupt ID bits */
> +       u32 num_id_bits;
>  };
>
>  extern struct static_key_false vgic_v2_cpuif_trap;
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 6c7d30c..da532d1 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -504,6 +504,14 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>                 if (!is_write)
>                         *reg = tmp32;
>                 break;
> +       case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> +               u64 regid;
> +
> +               regid = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
> +               ret = vgic_v3_cpu_sysregs_uaccess(vcpu, is_write,
> +                                                 regid, reg);
> +               break;
> +       }
>         default:
>                 ret = -EINVAL;
>                 break;
> @@ -537,6 +545,15 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>                 reg = tmp32;
>                 return vgic_v3_attr_regs_access(dev, attr, &reg, true);
>         }
> +       case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> +               u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +               u64 reg;
> +
> +               if (get_user(reg, uaddr))
> +                       return -EFAULT;
> +
> +               return vgic_v3_attr_regs_access(dev, attr, &reg, true);
> +       }
>         }
>         return -ENXIO;
>  }
> @@ -563,6 +580,15 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
>                 tmp32 = reg;
>                 return put_user(tmp32, uaddr);
>         }
> +       case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> +               u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +               u64 reg;
> +
> +               ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
> +               if (ret)
> +                       return ret;
> +               return put_user(reg, uaddr);
> +       }
>         }
>
>         return -ENXIO;
> @@ -581,6 +607,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>                 break;
>         case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>         case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> +       case KVM_DEV_ARM_VGIC_CPU_SYSREGS:
>                 return vgic_v3_has_attr_regs(dev, attr);
>         case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>                 return 0;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index b35fb83..8f46e61 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -23,6 +23,7 @@
>
>  #include "vgic.h"
>  #include "vgic-mmio.h"
> +#include "sys_regs.h"
>
>  /* extract @num bytes at @offset bytes offset in data */
>  unsigned long extract_bytes(u64 data, unsigned int offset,
> @@ -639,6 +640,24 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>                 nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
>                 break;
>         }
> +       case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> +               u64 reg, id;
> +               unsigned long vgic_mpidr, mpidr_reg;
> +               struct kvm_vcpu *vcpu;
> +
> +               vgic_mpidr = (attr->attr & KVM_DEV_ARM_VGIC_V3_MPIDR_MASK) >>
> +                             KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT;
> +
> +               /* Convert plain mpidr value to MPIDR reg format */
> +               mpidr_reg = VGIC_TO_MPIDR(mpidr_reg);

My bad, Wrong parameter. I will fix it.
