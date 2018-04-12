From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH v11 1/4] arm64: KVM: export the capability to set guest
 SError syndrome
Date: Thu, 12 Apr 2018 20:55:42 +0800
Message-ID: <CAMj-D2B3Sf_YmvJJtQjfy+qdvw3==sKyD=7Zd+2+BqHxBd2RRQ@mail.gmail.com>
References: <1523309796-36423-1-git-send-email-gengdongjiu@huawei.com>
 <1523309796-36423-2-git-send-email-gengdongjiu@huawei.com> <98360e36-5fb7-aea4-52c3-21595d09419f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <98360e36-5fb7-aea4-52c3-21595d09419f@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: Dongjiu Geng <gengdongjiu@huawei.com>, linux-doc@vger.kernel.org, kvm@vger.kernel.org, corbet@lwn.net, marc.zyngier@arm.com, catalin.marinas@arm.com, rjw@rjwysocki.net, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, zhengxiang9@huawei.com, bp@alien8.de, linux-arm-kernel@lists.infradead.org, huangshaoyu@huawei.com, devel@acpica.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, lenb@kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

HI James,
  Thanks for the review.


2018-04-10 22:15 GMT+08:00, James Morse <james.morse@arm.com>:
> Hi Dongjiu Geng,
>
> On 09/04/18 22:36, Dongjiu Geng wrote:
>> Before user space injects a SError, it needs to know whether it can
>> specify the guest Exception Syndrome, so KVM should tell user space
>> whether it has such capability.
>
> (you could improve the commit message by briefly explaining how/why
> user-space
> would want to do this. As this is patch 1, you don't have the context of
> the
> previous patch to say that some systems can provide an ESR with
> virtual-SError)
Exactly, thanks for the good comments.

>
>
>> diff --git a/Documentation/virtual/kvm/api.txt
>> b/Documentation/virtual/kvm/api.txt
>> index fc3ae95..8a3d708 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -4415,3 +4415,14 @@ Parameters: none
>>  This capability indicates if the flic device will be able to get/set the
>>  AIS states for migration via the KVM_DEV_FLIC_AISM_ALL attribute and
>> allows
>>  to discover this without having to create a flic device.
>> +
>> +8.14 KVM_CAP_ARM_SET_SERROR_ESR
>> +
>> +Architectures: arm, arm64
>> +
>> +This capability indicates that userspace can specify syndrome value
>> reported to
>
> (Nit: 'the syndrome value')
will fix it.

>
>> +guest OS when guest takes a virtual SError interrupt exception.
>
> (Nit: 'the guest')
will fix it.

>
>> +If KVM has this capability, userspace can only specify the ISS field for
>> the ESR
>> +syndrome, can not specify the EC field which is not under control by
>> KVM.
>
> (Nit: 'it can not specify...')
will fix it.

>
>> +If this virtual SError is taken to EL1 using AArch64, this value will be
>> reported
>> +into ISS filed of ESR_EL1.
>
> (Nit: 'in the ISS field')
will fix it.

>
>
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 3256b92..38c8a64 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -77,6 +77,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm,
>> long ext)
>>  	case KVM_CAP_ARM_PMU_V3:
>>  		r = kvm_arm_support_pmu_v3();
>>  		break;
>> +	case KVM_CAP_ARM_INJECT_SERROR_ESR:
>> +		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
>> +		break;
>>  	case KVM_CAP_SET_GUEST_DEBUG:
>>  	case KVM_CAP_VCPU_ATTRIBUTES:
>>  		r = 1;
>
> 'dev_ioctl' feels a bit weird, but we already have cpu_has_32bit_el1() in
> here.

Yes, although the name is "dev_ioctl", it does not have relationship
with the device.
here it mainly check vcpu capability, such as PMU, 32bit EL1 etc.

>
>
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 8fb90a0..3587b33 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -934,6 +934,7 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_S390_AIS_MIGRATION 150
>>  #define KVM_CAP_PPC_GET_CPU_CHAR 151
>>  #define KVM_CAP_S390_BPB 152
>> +#define KVM_CAP_ARM_INJECT_SERROR_ESR 153
>>
>>  #ifdef KVM_CAP_IRQ_ROUTING
>
> (patch 1&2 should probably be swapped around, as on its own this does
> thing).
ok, I will do it.

>
> Reviewed-by: James Morse <james.morse@arm.com>
thanks this Reviewed-by

>
>
> Thanks,
>
> James
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>
