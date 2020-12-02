Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674F7C64E7C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 15:19:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38B9B21741
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 15:19:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38B9B21741
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E5704B3A8;
	Wed,  2 Dec 2020 10:19:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7xEcJAr3MG1w; Wed,  2 Dec 2020 10:19:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC20E4B3AA;
	Wed,  2 Dec 2020 10:19:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57ACE4B3A7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 10:19:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yVju2GGLZ7lW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 10:19:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C04154B3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 10:19:33 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 547551042;
 Wed,  2 Dec 2020 07:19:33 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7FF4A3F718;
 Wed,  2 Dec 2020 07:19:32 -0800 (PST)
Subject: Re: [RFC PATCH v3 08/16] KVM: arm64: Add a new VCPU device control
 group for SPE
To: Haibo Xu <haibo.xu@linaro.org>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
 <20201027172705.15181-9-alexandru.elisei@arm.com>
 <CAJc+Z1EOOiTr2XuGoFhPaKzS6_QDm-U+R9DoESGrAtVoq=r0rA@mail.gmail.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3c6c0b25-b6ef-1811-3c67-b45230284429@arm.com>
Date: Wed, 2 Dec 2020 15:20:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <CAJc+Z1EOOiTr2XuGoFhPaKzS6_QDm-U+R9DoESGrAtVoq=r0rA@mail.gmail.com>
Content-Language: en-US
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Sudeep Holla <sudeep.holla@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Haibu,

Thanks for having a look at the patches!

On 11/5/20 9:58 AM, Haibo Xu wrote:
> On Wed, 28 Oct 2020 at 01:26, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> From: Sudeep Holla <sudeep.holla@arm.com>
>>
>> To configure the virtual SPE buffer management interrupt number, we use a
>> VCPU kvm_device ioctl, encapsulating the KVM_ARM_VCPU_SPE_IRQ attribute
>> within the KVM_ARM_VCPU_SPE_CTRL group.
>>
>> After configuring the SPE, userspace is required to call the VCPU ioctl
>> with the attribute KVM_ARM_VCPU_SPE_INIT to initialize SPE on the VCPU.
>>
>> [Alexandru E: Fixed compilation errors, don't allow userspace to set the
>>         VCPU feature, removed unused functions, fixed mismatched
>>         descriptions, comments and error codes, reworked logic, rebased on
>>         top of v5.10-rc1]
>>
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  Documentation/virt/kvm/devices/vcpu.rst |  40 ++++++++
>>  arch/arm64/include/uapi/asm/kvm.h       |   3 +
>>  arch/arm64/kvm/Makefile                 |   1 +
>>  arch/arm64/kvm/guest.c                  |   9 ++
>>  arch/arm64/kvm/reset.c                  |  23 +++++
>>  arch/arm64/kvm/spe.c                    | 129 ++++++++++++++++++++++++
>>  include/kvm/arm_spe.h                   |  27 +++++
>>  include/uapi/linux/kvm.h                |   1 +
>>  8 files changed, 233 insertions(+)
>>  create mode 100644 arch/arm64/kvm/spe.c
>>
>> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
>> index 2acec3b9ef65..6135b9827fbe 100644
>> --- a/Documentation/virt/kvm/devices/vcpu.rst
>> +++ b/Documentation/virt/kvm/devices/vcpu.rst
>> @@ -161,3 +161,43 @@ Specifies the base address of the stolen time structure for this VCPU. The
>>  base address must be 64 byte aligned and exist within a valid guest memory
>>  region. See Documentation/virt/kvm/arm/pvtime.rst for more information
>>  including the layout of the stolen time structure.
>> +
>> +4. GROUP: KVM_ARM_VCPU_SPE_CTRL
>> +===============================
>> +
>> +:Architectures: ARM64
>> +
>> +4.1 ATTRIBUTE: KVM_ARM_VCPU_SPE_IRQ
>> +-----------------------------------
>> +
>> +:Parameters: in kvm_device_attr.addr the address for the SPE buffer management
>> +             interrupt is a pointer to an int
>> +
>> +Returns:
>> +
>> +        =======  ========================================================
>> +        -EBUSY   The SPE buffer management interrupt is already set
>> +        -EINVAL  Invalid SPE overflow interrupt number
>> +        -EFAULT  Could not read the buffer management interrupt number
>> +        -ENXIO   SPE not supported or not properly configured
>> +        =======  ========================================================
>> +
>> +A value describing the SPE (Statistical Profiling Extension) overflow interrupt
>> +number for this vcpu. This interrupt should be a PPI and the interrupt type and
>> +number must be same for each vcpu.
>> +
>> +4.2 ATTRIBUTE: KVM_ARM_VCPU_SPE_INIT
>> +------------------------------------
>> +
>> +:Parameters: no additional parameter in kvm_device_attr.addr
>> +
>> +Returns:
>> +
>> +        =======  ======================================================
>> +        -EBUSY   SPE already initialized
>> +        -ENODEV  GIC not initialized
>> +        -ENXIO   SPE not supported or not properly configured
>> +        =======  ======================================================
>> +
>> +Request the initialization of the SPE. Must be done after initializing the
>> +in-kernel irqchip and after setting the interrupt number for the VCPU.
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> index 489e12304dbb..ca57dfb7abf0 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -360,6 +360,9 @@ struct kvm_vcpu_events {
>>  #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER                1
>>  #define KVM_ARM_VCPU_PVTIME_CTRL       2
>>  #define   KVM_ARM_VCPU_PVTIME_IPA      0
>> +#define KVM_ARM_VCPU_SPE_CTRL          3
>> +#define   KVM_ARM_VCPU_SPE_IRQ         0
>> +#define   KVM_ARM_VCPU_SPE_INIT                1
>>
>>  /* KVM_IRQ_LINE irq field index values */
>>  #define KVM_ARM_IRQ_VCPU2_SHIFT                28
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 1504c81fbf5d..f6e76f64ffbe 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -25,3 +25,4 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
>>          vgic/vgic-its.o vgic/vgic-debug.o
>>
>>  kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
>> +kvm-$(CONFIG_KVM_ARM_SPE)  += spe.o
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index dfb5218137ca..2ba790eeb782 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -926,6 +926,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>>         case KVM_ARM_VCPU_PVTIME_CTRL:
>>                 ret = kvm_arm_pvtime_set_attr(vcpu, attr);
>>                 break;
>> +       case KVM_ARM_VCPU_SPE_CTRL:
>> +               ret = kvm_arm_spe_set_attr(vcpu, attr);
>> +               break;
>>         default:
>>                 ret = -ENXIO;
>>                 break;
>> @@ -949,6 +952,9 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
>>         case KVM_ARM_VCPU_PVTIME_CTRL:
>>                 ret = kvm_arm_pvtime_get_attr(vcpu, attr);
>>                 break;
>> +       case KVM_ARM_VCPU_SPE_CTRL:
>> +               ret = kvm_arm_spe_get_attr(vcpu, attr);
>> +               break;
>>         default:
>>                 ret = -ENXIO;
>>                 break;
>> @@ -972,6 +978,9 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>>         case KVM_ARM_VCPU_PVTIME_CTRL:
>>                 ret = kvm_arm_pvtime_has_attr(vcpu, attr);
>>                 break;
>> +       case KVM_ARM_VCPU_SPE_CTRL:
>> +               ret = kvm_arm_spe_has_attr(vcpu, attr);
>> +               break;
>>         default:
>>                 ret = -ENXIO;
>>                 break;
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index f32490229a4c..4dc205fa4be1 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -87,6 +87,9 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>         case KVM_CAP_ARM_PTRAUTH_GENERIC:
>>                 r = system_has_full_ptr_auth();
>>                 break;
>> +       case KVM_CAP_ARM_SPE:
>> +               r = kvm_arm_supports_spe();
>> +               break;
>>         default:
>>                 r = 0;
>>         }
>> @@ -223,6 +226,19 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
>>         return 0;
>>  }
>>
>> +static int kvm_vcpu_enable_spe(struct kvm_vcpu *vcpu)
>> +{
>> +       if (!kvm_arm_supports_spe())
>> +               return -EINVAL;
>> +
>> +       /* SPE is disabled if the PE is in AArch32 state */
>> +       if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
>> +               return -EINVAL;
>> +
>> +       vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_SPE;
>> +       return 0;
>> +}
>> +
>>  /**
>>   * kvm_reset_vcpu - sets core registers and sys_regs to reset value
>>   * @vcpu: The VCPU pointer
>> @@ -274,6 +290,13 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>                 }
>>         }
>>
>> +       if (test_bit(KVM_ARM_VCPU_SPE, vcpu->arch.features)) {
>> +               if (kvm_vcpu_enable_spe(vcpu)) {
>> +                       ret = -EINVAL;
>> +                       goto out;
>> +               }
>> +       }
>> +
>>         switch (vcpu->arch.target) {
>>         default:
>>                 if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
>> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
>> new file mode 100644
>> index 000000000000..f91a52cd7cd3
>> --- /dev/null
>> +++ b/arch/arm64/kvm/spe.c
>> @@ -0,0 +1,129 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2019 ARM Ltd.
>> + */
>> +
>> +#include <linux/kvm.h>
>> +#include <linux/kvm_host.h>
>> +#include <linux/uaccess.h>
>> +
>> +#include <kvm/arm_spe.h>
>> +#include <kvm/arm_vgic.h>
>> +
>> +static bool kvm_arm_vcpu_supports_spe(struct kvm_vcpu *vcpu)
>> +{
>> +       if (!vcpu_has_spe(vcpu))
>> +               return false;
>> +
>> +       if (!irqchip_in_kernel(vcpu->kvm))
>> +               return false;
>> +
> nit: should we move the irqchip_in_kernel() check to the caller?

Yes, definitely, I can move the irqchip_in_kernel() check to the callers because
it's a VM, not VCPU property, and use vcpu_has_spe() directly.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
