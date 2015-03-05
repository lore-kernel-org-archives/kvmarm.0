From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v9 5/5] KVM: arm/arm64: add irqfd support
Date: Thu, 05 Mar 2015 14:34:21 +0000
Message-ID: <54F8696D.9010600@arm.com>
References: <1425464076-20558-1-git-send-email-eric.auger@linaro.org>
 <1425464076-20558-6-git-send-email-eric.auger@linaro.org>
 <54F8359A.4020405@arm.com> <54F86259.20704@linaro.org>
 <54F86623.5070605@arm.com> <54F8677F.8050906@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 859BC47DAC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 09:28:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ntKfTr07x00t for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2015 09:28:20 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55C8847D74
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 09:28:19 -0500 (EST)
In-Reply-To: <54F8677F.8050906@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "gleb@kernel.org" <gleb@kernel.org>, Andre Przywara <Andre.Przywara@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/03/15 14:26, Eric Auger wrote:
> On 03/05/2015 03:20 PM, Marc Zyngier wrote:
>> On 05/03/15 14:04, Eric Auger wrote:
>>> Hi Marc,
>>> On 03/05/2015 11:53 AM, Marc Zyngier wrote:
>>>> On 04/03/15 10:14, Eric Auger wrote:
>>>>> This patch enables irqfd on arm/arm64.
>>>>>
>>>>> Both irqfd and resamplefd are supported. Injection is implemented
>>>>> in vgic.c without routing.
>>>>>
>>>>> This patch enables CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQFD.
>>>>>
>>>>> KVM_CAP_IRQFD is now advertised. KVM_CAP_IRQFD_RESAMPLE capability
>>>>> automatically is advertised as soon as CONFIG_HAVE_KVM_IRQFD is set.
>>>>>
>>>>> Irqfd injection is restricted to SPI. The rationale behind not
>>>>> supporting PPI irqfd injection is that any device using a PPI would
>>>>> be a private-to-the-CPU device (timer for instance), so its state
>>>>> would have to be context-switched along with the VCPU and would
>>>>> require in-kernel wiring anyhow. It is not a relevant use case for
>>>>> irqfds.
>>>>>
>>>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>>>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>>>>>
>>>>> ---
>>>>> v8 -> v9:
>>>>> - replace kvm_debug by trace_kvm_set_irq and add
>>>>>   BUG_ON(!vgic_initialized(kvm));
>>>>>
>>>>> v7 -> v8:
>>>>> - remove kvm_irq_has_notifier call
>>>>> - part of dist locking changes now are part of previous patch file
>>>>> - remove gic_initialized() check in kvm_set_irq
>>>>> - remove Christoffer's Reviewed-by after this change
>>>>>
>>>>> v5 -> v6:
>>>>> - KVM_CAP_IRQFD support depends on vgic_present
>>>>> - add Christoffer's Reviewed-by
>>>>>
>>>>> v4 -> v5:
>>>>> - squash [PATCH v4 3/3] KVM: arm64: add irqfd support into this patch
>>>>> - some rewording in Documentation/virtual/kvm/api.txt and in vgic
>>>>>   vgic_process_maintenance unlock comment.
>>>>> - move explanation of why not supporting PPI into commit message
>>>>> - in case of injection before gic readiness, -ENODEV is returned. It is
>>>>>   up to the user space to avoid this situation.
>>>>>
>>>>> v3 -> v4:
>>>>> - reword commit message
>>>>> - explain why we unlock the distributor before calling kvm_notify_acked_irq
>>>>> - rename is_assigned_irq into has_notifier
>>>>> - change EOI and injection kvm_debug format string
>>>>> - remove error local variable in kvm_set_irq
>>>>> - Move HAVE_KVM_IRQCHIP unset in a separate patch
>>>>> - handle case were the irqfd injection is attempted before the vgic is ready.
>>>>>   in such a case the notifier, if any, is called immediatly
>>>>> - use nr_irqs to test spi is within correct range
>>>>>
>>>>> v2 -> v3:
>>>>> - removal of irq.h from eventfd.c put in a separate patch to increase
>>>>>   visibility
>>>>> - properly expose KVM_CAP_IRQFD capability in arm.c
>>>>> - remove CONFIG_HAVE_KVM_IRQCHIP meaningfull only if irq_comm.c is used
>>>>>
>>>>> v1 -> v2:
>>>>> - rebase on 3.17rc1
>>>>> - move of the dist unlock in process_maintenance
>>>>> - remove of dist lock in __kvm_vgic_sync_hwstate
>>>>> - rewording of the commit message (add resamplefd reference)
>>>>> - remove irq.h
>>>>>
>>>>> Conflicts:
>>>>>      arch/arm64/kvm/Kconfig
>>>>> ---
>>>>>  Documentation/virtual/kvm/api.txt |  6 ++++-
>>>>>  arch/arm/include/uapi/asm/kvm.h   |  3 +++
>>>>>  arch/arm/kvm/Kconfig              |  2 ++
>>>>>  arch/arm/kvm/Makefile             |  2 +-
>>>>>  arch/arm/kvm/arm.c                |  5 ++++
>>>>>  arch/arm64/include/uapi/asm/kvm.h |  3 +++
>>>>>  arch/arm64/kvm/Kconfig            |  2 ++
>>>>>  arch/arm64/kvm/Makefile           |  2 +-
>>>>>  virt/kvm/arm/vgic.c               | 48 +++++++++++++++++++++++++++++++++++++++
>>>>>  9 files changed, 70 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>>>>> index b112efc..b265d8e 100644
>>>>> --- a/Documentation/virtual/kvm/api.txt
>>>>> +++ b/Documentation/virtual/kvm/api.txt
>>>>> @@ -2234,7 +2234,7 @@ into the hash PTE second double word).
>>>>>  4.75 KVM_IRQFD
>>>>>
>>>>>  Capability: KVM_CAP_IRQFD
>>>>> -Architectures: x86 s390
>>>>> +Architectures: x86 s390 arm arm64
>>>>>  Type: vm ioctl
>>>>>  Parameters: struct kvm_irqfd (in)
>>>>>  Returns: 0 on success, -1 on error
>>>>> @@ -2260,6 +2260,10 @@ Note that closing the resamplefd is not sufficient to disable the
>>>>>  irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
>>>>>  and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
>>>>>
>>>>> +On ARM/ARM64, the gsi field in the kvm_irqfd struct specifies the Shared
>>>>> +Peripheral Interrupt (SPI) index, such that the GIC interrupt ID is
>>>>> +given by gsi + 32.
>>>>> +
>>>>>  4.76 KVM_PPC_ALLOCATE_HTAB
>>>>>
>>>>>  Capability: KVM_CAP_PPC_ALLOC_HTAB
>>>>> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
>>>>> index 0db25bc..2499867 100644
>>>>> --- a/arch/arm/include/uapi/asm/kvm.h
>>>>> +++ b/arch/arm/include/uapi/asm/kvm.h
>>>>> @@ -198,6 +198,9 @@ struct kvm_arch_memory_slot {
>>>>>  /* Highest supported SPI, from VGIC_NR_IRQS */
>>>>>  #define KVM_ARM_IRQ_GIC_MAX         127
>>>>>
>>>>> +/* One single KVM irqchip, ie. the VGIC */
>>>>> +#define KVM_NR_IRQCHIPS          1
>>>>> +
>>>>>  /* PSCI interface */
>>>>>  #define KVM_PSCI_FN_BASE            0x95c1ba5e
>>>>>  #define KVM_PSCI_FN(n)                      (KVM_PSCI_FN_BASE + (n))
>>>>> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
>>>>> index aae5242..d735a3e 100644
>>>>> --- a/arch/arm/kvm/Kconfig
>>>>> +++ b/arch/arm/kvm/Kconfig
>>>>> @@ -27,6 +27,7 @@ config KVM
>>>>>      select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>>>>>      select SRCU
>>>>>      depends on ARM_VIRT_EXT && ARM_LPAE
>>>>> +    select HAVE_KVM_EVENTFD
>>>>>      ---help---
>>>>>        Support hosting virtualized guest machines. You will also
>>>>>        need to select one or more of the processor modules below.
>>>>> @@ -58,6 +59,7 @@ config KVM_ARM_MAX_VCPUS
>>>>>  config KVM_ARM_VGIC
>>>>>      bool "KVM support for Virtual GIC"
>>>>>      depends on KVM_ARM_HOST && OF
>>>>> +    select HAVE_KVM_IRQFD
>>>>>      default y
>>>>>      ---help---
>>>>>        Adds support for a hardware assisted, in-kernel GIC emulation.
>>>>> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
>>>>> index 443b8be..539c1a5 100644
>>>>> --- a/arch/arm/kvm/Makefile
>>>>> +++ b/arch/arm/kvm/Makefile
>>>>> @@ -15,7 +15,7 @@ AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
>>>>>  AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
>>>>>
>>>>>  KVM := ../../../virt/kvm
>>>>> -kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
>>>>> +kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
>>>>>
>>>>>  obj-y += kvm-arm.o init.o interrupts.o
>>>>>  obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
>>>>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>>>>> index 5300d5a..4313776 100644
>>>>> --- a/arch/arm/kvm/arm.c
>>>>> +++ b/arch/arm/kvm/arm.c
>>>>> @@ -175,6 +175,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>>>      case KVM_CAP_IRQCHIP:
>>>>>              r = vgic_present;
>>>>>              break;
>>>>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>>>>> +    case KVM_CAP_IRQFD:
>>>>> +            r = vgic_present;
>>>>> +            break;
>>>>> +#endif
>>>>
>>>> Nitpick: we have "select HAVE_KVM_IRQFD", so we can lose the #ifdef-ery.
>>> right. Also I think the vgic_present can be removed since
>>> CONFIG_HAVE_KVM_IRQFD always is set when CONFIG_KVM_ARM_VGIC is set.
>>> So overall this indeed can simply be replaced by Paolo's patch.
>>>>
>>>>>      case KVM_CAP_DEVICE_CTRL:
>>>>>      case KVM_CAP_USER_MEMORY:
>>>>>      case KVM_CAP_SYNC_MMU:
>>>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>>>>> index 3ef77a4..c154c0b 100644
>>>>> --- a/arch/arm64/include/uapi/asm/kvm.h
>>>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>>>>> @@ -191,6 +191,9 @@ struct kvm_arch_memory_slot {
>>>>>  /* Highest supported SPI, from VGIC_NR_IRQS */
>>>>>  #define KVM_ARM_IRQ_GIC_MAX         127
>>>>>
>>>>> +/* One single KVM irqchip, ie. the VGIC */
>>>>> +#define KVM_NR_IRQCHIPS          1
>>>>> +
>>>>>  /* PSCI interface */
>>>>>  #define KVM_PSCI_FN_BASE            0x95c1ba5e
>>>>>  #define KVM_PSCI_FN(n)                      (KVM_PSCI_FN_BASE + (n))
>>>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>>>>> index 039d8cf..143c9fd 100644
>>>>> --- a/arch/arm64/kvm/Kconfig
>>>>> +++ b/arch/arm64/kvm/Kconfig
>>>>> @@ -29,6 +29,7 @@ config KVM
>>>>>      select KVM_ARM_TIMER
>>>>>      select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>>>>>      select SRCU
>>>>> +    select HAVE_KVM_EVENTFD
>>>>>      ---help---
>>>>>        Support hosting virtualized guest machines.
>>>>>
>>>>> @@ -53,6 +54,7 @@ config KVM_ARM_MAX_VCPUS
>>>>>  config KVM_ARM_VGIC
>>>>>      bool
>>>>>      depends on KVM_ARM_HOST && OF
>>>>> +    select HAVE_KVM_IRQFD
>>>>
>>>> Hmmm. There is way too many selects here. Can't we just select it with
>>>> CONFIG_KVM_ARM_VGIC, and be done with it?
>>>
>>> I did that way since CONFIG_KVM_ARM_VGIC is not selected in the config
>>> KVM section on 32b. Currently the IRQFD select location is same for arm
>>> and arm64.
>>>
>>> do you prefer I select HAVE_KVM_IRQFD in the config KVM section, ie. at
>>> the same place we select CONFIG_KVM_ARM_VGIC?
>>
>> We cannot have irqfd without vgic, can we? Or am I misunderstanding the
>> dependency chain entirely?
> 
> No we can't have irqfd without vgic.

Blah. Ignore me. The additional select is for eventfd, not irqfd. Your
patch is just fine...

Sorry about the noise.

	M.
-- 
Jazz is not dead. It just smells funny...
