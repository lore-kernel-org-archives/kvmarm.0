From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] ARM/ARM64: KVM: remove 'config KVM_ARM_MAX_VCPUS'
Date: Thu, 17 Sep 2015 09:15:08 +0100
Message-ID: <55FA768C.6050101@arm.com>
References: <1441175481-18348-1-git-send-email-ming.lei@canonical.com>	<20150902102555.GH10991@cbox>	<CACVXFVOfaqRtobQ6us8VdsU+DOgPzxKCbTGqmG7nyds9kqMn_g@mail.gmail.com>
 <CACVXFVMGLGsxmrPhmJVn0mNOrk+sQskrjTEiOBsUzR3jUmhpiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 061F8418D8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2015 04:14:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kA01LZVxAs9x for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2015 04:14:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60D7D412F3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2015 04:14:10 -0400 (EDT)
In-Reply-To: <CACVXFVMGLGsxmrPhmJVn0mNOrk+sQskrjTEiOBsUzR3jUmhpiA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ming Lei <ming.lei@canonical.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, KVM General <kvm@vger.kernel.org>, Dann Frazier <dann.frazier@canonical.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 17/09/15 07:08, Ming Lei wrote:
> On Wed, Sep 2, 2015 at 7:42 PM, Ming Lei <ming.lei@canonical.com> wrote:
>> On Wed, Sep 2, 2015 at 6:25 PM, Christoffer Dall
>> <christoffer.dall@linaro.org> wrote:
>>> On Wed, Sep 02, 2015 at 02:31:21PM +0800, Ming Lei wrote:
>>>> This patch removes config option of KVM_ARM_MAX_VCPUS,
>>>> and like other ARCHs, just choose the maximum allowed
>>>> value from hardware, and follows the reasons:
>>>>
>>>> 1) from distribution view, the option has to be
>>>> defined as the max allowed value because it need to
>>>> meet all kinds of virtulization applications and
>>>> need to support most of SoCs;
>>>>
>>>> 2) using a bigger value doesn't introduce extra memory
>>>> consumption, and the help text in Kconfig isn't accurate
>>>> because kvm_vpu structure isn't allocated until request
>>>> of creating VCPU is sent from QEMU;
>>>
>>> This used to be true because of the vgic bitmaps, but that is now
>>> dynamically allocated, so I believe you're correct in saying that the
>>> text is no longer accurate.
>>>
>>>>
>>>> 3) the main effect is that the field of vcpus[] in 'struct kvm'
>>>> becomes a bit bigger(sizeof(void *) per vcpu) and need more cache
>>>> lines to hold the structure, but 'struct kvm' is one generic struct,
>>>> and it has worked well on other ARCHs already in this way. Also,
>>>> the world switch frequecy is often low, for example, it is ~2000
>>>> when running kernel building load in VM from APM xgene KVM host,
>>>> so the effect is very small, and the difference can't be observed
>>>> in my test at all.
>>>
>>> While I'm not prinicipally opposed to removing this option, I have to
>>> point out that this analysis is far far over-simplified.  You have
>>> chosen a workload which excercised only CPU and memory virtualization,
>>> mostly solved by the hardware virtualization support, and therefore you
>>> don't see many exits.
>>>
>>> Try running an I/O bound workload, or something which involves a lot of
>>> virtual IPIs, and you'll see a higher number of exits.
>>
>> Yeah, the frequency of exits becomes higher(6600/sec) when I run a
>> totally I/O benchmark(fio: 4 jobs, bs 4k, libaio over virtio-blk) in a
>> quad-core VM, but it is still not high enough to cause any difference
>> on the test result.
>>
>>>
>>> However, I still doubt that the effects will be noticable in the grand
>>> scheme of things.
>>>>
>>>> Cc: Dann Frazier <dann.frazier@canonical.com>
>>>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>> Cc: kvmarm@lists.cs.columbia.edu
>>>> Cc: kvm@vger.kernel.org
>>>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>>>> ---
>>>>  arch/arm/include/asm/kvm_host.h   |  8 ++------
>>>>  arch/arm/kvm/Kconfig              | 11 -----------
>>>>  arch/arm64/include/asm/kvm_host.h |  8 ++------
>>>>  arch/arm64/kvm/Kconfig            | 11 -----------
>>>>  include/kvm/arm_vgic.h            |  6 +-----
>>>>  virt/kvm/arm/vgic-v3.c            |  2 +-
>>>>  6 files changed, 6 insertions(+), 40 deletions(-)
>>>>
>>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>>> index dcba0fa..c8c226a 100644
>>>> --- a/arch/arm/include/asm/kvm_host.h
>>>> +++ b/arch/arm/include/asm/kvm_host.h
>>>> @@ -29,12 +29,6 @@
>>>>
>>>>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>>>>
>>>> -#if defined(CONFIG_KVM_ARM_MAX_VCPUS)
>>>> -#define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
>>>> -#else
>>>> -#define KVM_MAX_VCPUS 0
>>>> -#endif
>>>> -
>>>>  #define KVM_USER_MEM_SLOTS 32
>>>>  #define KVM_PRIVATE_MEM_SLOTS 4
>>>>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
>>>> @@ -44,6 +38,8 @@
>>>>
>>>>  #include <kvm/arm_vgic.h>
>>>>
>>>> +#define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
>>>> +
>>>>  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
>>>>  int __attribute_const__ kvm_target_cpu(void);
>>>>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>>>> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
>>>> index bfb915d..210ecca 100644
>>>> --- a/arch/arm/kvm/Kconfig
>>>> +++ b/arch/arm/kvm/Kconfig
>>>> @@ -45,15 +45,4 @@ config KVM_ARM_HOST
>>>>       ---help---
>>>>         Provides host support for ARM processors.
>>>>
>>>> -config KVM_ARM_MAX_VCPUS
>>>> -     int "Number maximum supported virtual CPUs per VM"
>>>> -     depends on KVM_ARM_HOST
>>>> -     default 4
>>>> -     help
>>>> -       Static number of max supported virtual CPUs per VM.
>>>> -
>>>> -       If you choose a high number, the vcpu structures will be quite
>>>> -       large, so only choose a reasonable number that you expect to
>>>> -       actually use.
>>>> -
>>>>  endif # VIRTUALIZATION
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>> index 415938d..3fb58ea 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -30,12 +30,6 @@
>>>>
>>>>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>>>>
>>>> -#if defined(CONFIG_KVM_ARM_MAX_VCPUS)
>>>> -#define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
>>>> -#else
>>>> -#define KVM_MAX_VCPUS 0
>>>> -#endif
>>>> -
>>>>  #define KVM_USER_MEM_SLOTS 32
>>>>  #define KVM_PRIVATE_MEM_SLOTS 4
>>>>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
>>>> @@ -43,6 +37,8 @@
>>>>  #include <kvm/arm_vgic.h>
>>>>  #include <kvm/arm_arch_timer.h>
>>>>
>>>> +#define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>>>> +
>>>>  #define KVM_VCPU_MAX_FEATURES 3
>>>>
>>>>  int __attribute_const__ kvm_target_cpu(void);
>>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>>>> index bfffe8f..5c7e920 100644
>>>> --- a/arch/arm64/kvm/Kconfig
>>>> +++ b/arch/arm64/kvm/Kconfig
>>>> @@ -41,15 +41,4 @@ config KVM_ARM_HOST
>>>>       ---help---
>>>>         Provides host support for ARM processors.
>>>>
>>>> -config KVM_ARM_MAX_VCPUS
>>>> -     int "Number maximum supported virtual CPUs per VM"
>>>> -     depends on KVM_ARM_HOST
>>>> -     default 4
>>>> -     help
>>>> -       Static number of max supported virtual CPUs per VM.
>>>> -
>>>> -       If you choose a high number, the vcpu structures will be quite
>>>> -       large, so only choose a reasonable number that you expect to
>>>> -       actually use.
>>>> -
>>>>  endif # VIRTUALIZATION
>>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>>> index d901f1a..4e14dac 100644
>>>> --- a/include/kvm/arm_vgic.h
>>>> +++ b/include/kvm/arm_vgic.h
>>>> @@ -35,11 +35,7 @@
>>>>  #define VGIC_V3_MAX_LRS              16
>>>>  #define VGIC_MAX_IRQS                1024
>>>>  #define VGIC_V2_MAX_CPUS     8
>>>> -
>>>> -/* Sanity checks... */
>>>> -#if (KVM_MAX_VCPUS > 255)
>>>> -#error Too many KVM VCPUs, the VGIC only supports up to 255 VCPUs for now
>>>> -#endif
>>>> +#define VGIC_V3_MAX_CPUS     255
>>>>
>>>>  #if (VGIC_NR_IRQS_LEGACY & 31)
>>>>  #error "VGIC_NR_IRQS must be a multiple of 32"
>>>> diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
>>>> index afbf925..7dd5d62 100644
>>>> --- a/virt/kvm/arm/vgic-v3.c
>>>> +++ b/virt/kvm/arm/vgic-v3.c
>>>> @@ -288,7 +288,7 @@ int vgic_v3_probe(struct device_node *vgic_node,
>>>>
>>>>       vgic->vctrl_base = NULL;
>>>>       vgic->type = VGIC_V3;
>>>> -     vgic->max_gic_vcpus = KVM_MAX_VCPUS;
>>>> +     vgic->max_gic_vcpus = VGIC_V3_MAX_CPUS;
>>>>
>>>>       kvm_info("%s@%llx IRQ%d\n", vgic_node->name,
>>>>                vcpu_res.start, vgic->maint_irq);
>>>> --
>>>> 1.9.1
>>>
>>>
>>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Hi Guys,
> 
> Is there any chance to merge this patch?

Ah, I missed it, thanks for the heads up. I've just queued it.

	M.
-- 
Jazz is not dead. It just smells funny...
