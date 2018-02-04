From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 08/18] arm/arm64: KVM: Add PSCI version selection API
Date: Sun, 4 Feb 2018 13:38:30 +0100
Message-ID: <20180204123830.GL21802@cbox>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-9-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180201114657.7323-9-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Jones <drjones@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

[ I know we're discussing the overall approach in parallel, but here are
  some comments on the specifics of this patch, should it end up being
  used in some capacity ]

On Thu, Feb 01, 2018 at 11:46:47AM +0000, Marc Zyngier wrote:
> Although we've implemented PSCI 1.0 and 1.1, nothing can select them
> Since all the new PSCI versions are backward compatible, we decide to
> default to the latest version of the PSCI implementation. This is no
> different from doing a firmware upgrade on KVM.
>
> But in order to give a chance to hypothetical badly implemented guests
> that would have a fit by discovering something other than PSCI 0.2,
> let's provide a new API that allows userspace to pick one particular
> version of the API.
>
> This is implemented as a new class of "firmware" registers, where
> we expose the PSCI version. This allows the PSCI version to be
> save/restored as part of a guest migration, and also set to
> any supported version if the guest requires it.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  Documentation/virtual/kvm/api.txt      |  3 +-
>  Documentation/virtual/kvm/arm/psci.txt | 30 +++++++++++++++
>  arch/arm/include/asm/kvm_host.h        |  3 ++
>  arch/arm/include/uapi/asm/kvm.h        |  6 +++
>  arch/arm/kvm/guest.c                   | 13 +++++++
>  arch/arm64/include/asm/kvm_host.h      |  3 ++
>  arch/arm64/include/uapi/asm/kvm.h      |  6 +++
>  arch/arm64/kvm/guest.c                 | 14 ++++++-
>  include/kvm/arm_psci.h                 |  9 +++++
>  virt/kvm/arm/psci.c                    | 68 +++++++++++++++++++++++++++++++++-
>  10 files changed, 151 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/arm/psci.txt
>
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 57d3ee9e4bde..334905202141 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2493,7 +2493,8 @@ Possible features:
>    and execute guest code when KVM_RUN is called.
>   - KVM_ARM_VCPU_EL1_32BIT: Starts the CPU in a 32bit mode.
>    Depends on KVM_CAP_ARM_EL1_32BIT (arm64 only).
> - - KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 for the CPU.
> + - KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 (or a future revision
> +          backward compatible with v0.2) for the CPU.
>    Depends on KVM_CAP_ARM_PSCI_0_2.
>   - KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
>    Depends on KVM_CAP_ARM_PMU_V3.

Can we add this to api.txt as well ?:

--------8><----------

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index fc3ae951bc07..c88aa04bcbe8 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1959,6 +1959,8 @@ arm64 CCSIDR registers are demultiplexed by CSSELR value:
 arm64 system registers have the following id bit patterns:
   0x6030 0000 0013 <op0:2> <op1:3> <crn:4> <crm:4> <op2:3>
 
+ARM/arm64 firmware pseudo-registers have the following bit pattern:
+  0x4030 0000 0014 <regno:16>
 
 MIPS registers are mapped using the lower 32 bits.  The upper 16 of that is
 the register group type:

--------8><----------

> diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
> new file mode 100644
> index 000000000000..aafdab887b04
> --- /dev/null
> +++ b/Documentation/virtual/kvm/arm/psci.txt
> @@ -0,0 +1,30 @@
> +KVM implements the PSCI (Power State Coordination Interface)
> +specification in order to provide services such as CPU on/off, reset
> +and power-off to the guest.
> +
> +The PSCI specification is regularly updated to provide new features,
> +and KVM implements these updates if they make sense from a virtualization
> +point of view.
> +
> +This means that a guest booted on two different versions of KVM can
> +observe two different "firmware" revisions. This could cause issues if
> +a given guest is tied to a particular PSCI revision (unlikely), or if
> +a migration causes a different PSCI version to be exposed out of the
> +blue to an unsuspecting guest.
> +
> +In order to remedy this situation, KVM exposes a set of "firmware
> +pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
> +interface. These registers can be saved/restored by userspace, and set
> +to a convenient value if required.
> +
> +The following register is defined:
> +
> +* KVM_REG_ARM_PSCI_VERSION:
> +
> +  - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
> +    (and thus has already been initialized)
> +  - Returns the current PSCI version on GET_ONE_REG (defaulting to the
> +    highest PSCI version implemented by KVM and compatible with v0.2)
> +  - Allows any PSCI version implemented by KVM and compatible with
> +    v0.2 to be set with SET_ONE_REG
> +  - Affects the whole VM (even if the register view is per-vcpu)
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index acbf9ec7b396..e9d57060d88c 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -75,6 +75,9 @@ struct kvm_arch {
>   /* Interrupt controller */
>   struct vgic_dist vgic;
>   int max_vcpus;
> +
> + /* Mandated version of PSCI */
> + u32 psci_version;
>  };
>  
>  #define KVM_NR_MEM_OBJS     40
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 6edd177bb1c7..47dfc99f5cd0 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -186,6 +186,12 @@ struct kvm_arch_memory_slot {
>  #define KVM_REG_ARM_VFP_FPINST 0x1009
>  #define KVM_REG_ARM_VFP_FPINST2 0x100A
>  
> +/* KVM-as-firmware specific pseudo-registers */
> +#define KVM_REG_ARM_FW (0x0014 << KVM_REG_ARM_COPROC_SHIFT)
> +#define KVM_REG_ARM_FW_REG(r) (KVM_REG_ARM | KVM_REG_SIZE_U64 | \
> + KVM_REG_ARM_FW | ((r) & 0xffff))
> +#define KVM_REG_ARM_PSCI_VERSION KVM_REG_ARM_FW_REG(0)
> +
>  /* Device Control API: ARM VGIC */
>  #define KVM_DEV_ARM_VGIC_GRP_ADDR 0
>  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS 1
> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
> index 1e0784ebbfd6..a18f33edc471 100644
> --- a/arch/arm/kvm/guest.c
> +++ b/arch/arm/kvm/guest.c
> @@ -22,6 +22,7 @@
>  #include <linux/module.h>
>  #include <linux/vmalloc.h>
>  #include <linux/fs.h>
> +#include <kvm/arm_psci.h>
>  #include <asm/cputype.h>
>  #include <linux/uaccess.h>
>  #include <asm/kvm.h>
> @@ -176,6 +177,7 @@ static unsigned long num_core_regs(void)
>  unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
>  {
>   return num_core_regs() + kvm_arm_num_coproc_regs(vcpu)
> + + kvm_arm_get_fw_num_regs(vcpu)
>   + NUM_TIMER_REGS;
>  }
>  
> @@ -196,6 +198,11 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>   uindices++;
>   }
>  
> + ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
> + if (ret)
> + return ret;
> + uindices += kvm_arm_get_fw_num_regs(vcpu);
> +
>   ret = copy_timer_indices(vcpu, uindices);
>   if (ret)
>   return ret;
> @@ -214,6 +221,9 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE)
>   return get_core_reg(vcpu, reg);
>  
> + if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_FW)
> + return kvm_arm_get_fw_reg(vcpu, reg);
> +
>   if (is_timer_reg(reg->id))
>   return get_timer_reg(vcpu, reg);
>  
> @@ -230,6 +240,9 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE)
>   return set_core_reg(vcpu, reg);
>  
> + if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_FW)
> + return kvm_arm_set_fw_reg(vcpu, reg);
> +
>   if (is_timer_reg(reg->id))
>   return set_timer_reg(vcpu, reg);
>  
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4485ae8e98de..10af386642c6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -73,6 +73,9 @@ struct kvm_arch {
>  
>   /* Interrupt controller */
>   struct vgic_dist vgic;
> +
> + /* Mandated version of PSCI */
> + u32 psci_version;
>  };
>  
>  #define KVM_NR_MEM_OBJS     40
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 9abbf3044654..04b3256f8e6d 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -206,6 +206,12 @@ struct kvm_arch_memory_slot {
>  #define KVM_REG_ARM_TIMER_CNT ARM64_SYS_REG(3, 3, 14, 3, 2)
>  #define KVM_REG_ARM_TIMER_CVAL ARM64_SYS_REG(3, 3, 14, 0, 2)
>  
> +/* KVM-as-firmware specific pseudo-registers */
> +#define KVM_REG_ARM_FW (0x0014 << KVM_REG_ARM_COPROC_SHIFT)
> +#define KVM_REG_ARM_FW_REG(r) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
> + KVM_REG_ARM_FW | ((r) & 0xffff))
> +#define KVM_REG_ARM_PSCI_VERSION KVM_REG_ARM_FW_REG(0)
> +
>  /* Device Control API: ARM VGIC */
>  #define KVM_DEV_ARM_VGIC_GRP_ADDR 0
>  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS 1
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 5c7f657dd207..811f04c5760e 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -25,6 +25,7 @@
>  #include <linux/module.h>
>  #include <linux/vmalloc.h>
>  #include <linux/fs.h>
> +#include <kvm/arm_psci.h>
>  #include <asm/cputype.h>
>  #include <linux/uaccess.h>
>  #include <asm/kvm.h>
> @@ -205,7 +206,7 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
>  {
>   return num_core_regs() + kvm_arm_num_sys_reg_descs(vcpu)
> -                + NUM_TIMER_REGS;
> + + kvm_arm_get_fw_num_regs(vcpu) + NUM_TIMER_REGS;
>  }
>  
>  /**
> @@ -225,6 +226,11 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>   uindices++;
>   }
>  
> + ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
> + if (ret)
> + return ret;
> + uindices += kvm_arm_get_fw_num_regs(vcpu);
> +
>   ret = copy_timer_indices(vcpu, uindices);
>   if (ret)
>   return ret;
> @@ -243,6 +249,9 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE)
>   return get_core_reg(vcpu, reg);
>  
> + if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_FW)
> + return kvm_arm_get_fw_reg(vcpu, reg);
> +
>   if (is_timer_reg(reg->id))
>   return get_timer_reg(vcpu, reg);
>  
> @@ -259,6 +268,9 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE)
>   return set_core_reg(vcpu, reg);
>  
> + if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_FW)
> + return kvm_arm_set_fw_reg(vcpu, reg);
> +
>   if (is_timer_reg(reg->id))
>   return set_timer_reg(vcpu, reg);
>  
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index 5446435457c2..4ee098c39e01 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -24,7 +24,16 @@
>  #define KVM_ARM_PSCI_0_2 PSCI_VERSION(0, 2)
>  #define KVM_ARM_PSCI_1_0 PSCI_VERSION(1, 0)
>  
> +#define KVM_ARM_PSCI_LATEST KVM_ARM_PSCI_1_0
> +
>  int kvm_psci_version(struct kvm_vcpu *vcpu);
>  int kvm_psci_call(struct kvm_vcpu *vcpu);
>  
> +struct kvm_one_reg;
> +
> +int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
> +int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
> +int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> +int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> +
>  #endif /* __KVM_ARM_PSCI_H__ */
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index 291874cff85e..5c8366b71639 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -17,6 +17,7 @@
>  
>  #include <linux/preempt.h>
>  #include <linux/kvm_host.h>
> +#include <linux/uaccess.h>
>  #include <linux/wait.h>
>  
>  #include <asm/cputype.h>
> @@ -233,8 +234,19 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
>  
>  int kvm_psci_version(struct kvm_vcpu *vcpu)
>  {
> - if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features))
> - return KVM_ARM_PSCI_0_2;
> + /*
> + * Our PSCI implementation stays the same across versions from
> + * v0.2 onward, only adding the few mandatory functions (such
> + * as FEATURES with 1.0) that are required by newer
> + * revisions. It is thus safe to return the latest, unless
> + * userspace has instructed us otherwise.
> + */
> + if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features)) {
> + if (vcpu->kvm->arch.psci_version)
> + return vcpu->kvm->arch.psci_version;
> +
> + return KVM_ARM_PSCI_LATEST;
> + }
>  
>   return KVM_ARM_PSCI_0_1;
>  }
> @@ -406,3 +418,55 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
>   return -EINVAL;
>   };
>  }
> +
> +int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> +{
> + return 1; /* PSCI version */
> +}
> +
> +int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> +{
> + if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices))
> + return -EFAULT;
> +
> + return 0;
> +}
> +
> +int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> +{
> + if (reg->id == KVM_REG_ARM_PSCI_VERSION) {
> + void __user *uaddr = (void __user *)(long)reg->addr;
> + u64 val;
> +
> + val = kvm_psci_version(vcpu);
> + if (val == KVM_ARM_PSCI_0_1)
> + return -EINVAL;

Doesn't this potentially break userspace that doesn't set
KVM_ARM_VCPU_PSCI_0_2 which does KVM_GET_REG_LIST followed by
KVM_GET_ONE_REG ?

What is the rationale for not simply allowing PSCI v0.1 (terribly
outdated as it may be) be exposed via this firmware reg?

> + if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
> + return -EFAULT;
> +
> + return 0;
> + }
> +
> + return -EINVAL;
> +}
> +
> +int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> +{
> + if (reg->id == KVM_REG_ARM_PSCI_VERSION &&
> +    test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features)) {
> + void __user *uaddr = (void __user *)(long)reg->addr;
> + u64 val;
> +
> + if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
> + return -EFAULT;
> +
> + switch (val) {
> + case KVM_ARM_PSCI_0_2:
> + case KVM_ARM_PSCI_1_0:
> + vcpu->kvm->arch.psci_version = val;
> + return 0;
> + }

Then here we could change the check so that setting KVM_ARM_PSCI_0_1
when also having set KVM_ARM_VCPU_PSCI_0_2 returns an error, and
similarly trying to set KVM_ARM_PSCI_0_2+ without having set the feature
bit, returns an error.

> + }
> +
> + return -EINVAL;
> +}
> --
> 2.14.2
>

Thanks,
-Christoffer
