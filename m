From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 23/37] arm64: KVM: export the capability to set guest
 SError syndrome
Date: Wed, 15 Aug 2018 13:24:13 +0100
Message-ID: <9ce56d90-dfb4-5df2-6934-df7262eee93b@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
 <20180813145755.16566-24-marc.zyngier@arm.com>
 <20180815121320.hf57g2akl7fnp3ob@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D51C74A1E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Aug 2018 08:24:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kdSgKHz6QN2z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Aug 2018 08:24:22 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A0294A0C8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Aug 2018 08:24:22 -0400 (EDT)
In-Reply-To: <20180815121320.hf57g2akl7fnp3ob@kamzik.brq.redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/08/18 13:13, Andrew Jones wrote:
> On Mon, Aug 13, 2018 at 03:57:41PM +0100, Marc Zyngier wrote:
>> From: Dongjiu Geng <gengdongjiu@huawei.com>
>>
>> For the arm64 RAS Extension, user space can inject a virtual-SError
>> with specified ESR. So user space needs to know whether KVM support
>> to inject such SError, this interface adds this query for this capability.
>>
>> KVM will check whether system support RAS Extension, if supported, KVM
>> returns true to user space, otherwise returns false.
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Reviewed-by: James Morse <james.morse@arm.com>
>> [expanded documentation wording]
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  Documentation/virtual/kvm/api.txt | 26 ++++++++++++++++++++++++++
>>  arch/arm64/kvm/reset.c            |  3 +++
>>  include/uapi/linux/kvm.h          |  1 +
>>  3 files changed, 30 insertions(+)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index 284d36e72f28..dbbb95d5798a 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -907,6 +907,18 @@ SError is pending, the architecture's 'Multiple SError interrupts' rules should
>>  be followed. (2.5.3 of DDI0587.a "ARM Reliability, Availability, and
>>  Serviceability (RAS) Specification").
>>  
>> +SError exceptions always have an ESR value. Some CPUs have the ability to
>> +specify what the virtual SError's ESR value should be. These systems will
>> +advertise KVM_CAP_ARM_SET_SERROR_ESR. In this case exception.has_esr will
>> +always have a non-zero value when read, and the agent making an SError pending
>> +should specify the ISS field in the lower 24 bits of exception.serror_esr. If
>> +the system supports KVM_CAP_ARM_SET_SERROR_ESR, but user-space sets the events
>> +with exception.has_esr as zero, KVM will choose an ESR.
>> +
>> +Specifying exception.has_esr on a system that does not support it will return
>> +-EINVAL. Setting anything other than the lower 24bits of exception.serror_esr
>> +will return -EINVAL.
>> +
>>  struct kvm_vcpu_events {
>>  	struct {
>>  		__u8 serror_pending;
>> @@ -4664,3 +4676,17 @@ This capability indicates that KVM supports paravirtualized Hyper-V TLB Flush
>>  hypercalls:
>>  HvFlushVirtualAddressSpace, HvFlushVirtualAddressSpaceEx,
>>  HvFlushVirtualAddressList, HvFlushVirtualAddressListEx.
>> +
>> +8.19 KVM_CAP_ARM_SET_SERROR_ESR
>> +
>> +Architectures: arm, arm64
>> +
>> +This capability indicates that userspace can specify (via the
>> +KVM_SET_VCPU_EVENTS ioctl) the syndrome value reported to the guest when it
>> +takes a virtual SError interrupt exception.
>> +If KVM advertises this capability, userspace can only specify the ISS field for
>> +the ESR syndrome. Other parts of the ESR, such as the EC are generated by the
>> +CPU when the exception is taken. If this virtual SError is taken to EL1 using
>> +AArch64, this value will be reported in the ISS field of ESR_ELx.
>> +
>> +See KVM_CAP_VCPU_EVENTS for more details.
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index a3db01a28062..067c6ba969bd 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -77,6 +77,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_ARM_PMU_V3:
>>  		r = kvm_arm_support_pmu_v3();
>>  		break;
>> +	case KVM_CAP_ARM_INJECT_SERROR_ESR:
>> +		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
>> +		break;
>>  	case KVM_CAP_SET_GUEST_DEBUG:
>>  	case KVM_CAP_VCPU_ATTRIBUTES:
>>  	case KVM_CAP_VCPU_EVENTS:
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index b6270a3b38e9..a7d9bc4e4068 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -949,6 +949,7 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_GET_MSR_FEATURES 153
>>  #define KVM_CAP_HYPERV_EVENTFD 154
>>  #define KVM_CAP_HYPERV_TLBFLUSH 155
>> +#define KVM_CAP_ARM_INJECT_SERROR_ESR 156
>>  
>>  #ifdef KVM_CAP_IRQ_ROUTING
>>  
>> -- 
>> 2.18.0
>>
> 
> Hi All,
> 
> I was just skimming over this patch and see that the documentation refers
> to KVM_CAP_ARM_SET_SERROR_ESR, but the code implements
> KVM_CAP_ARM_INJECT_SERROR_ESR. One or other needs a change. I suppose at
> this point the documentation would be easiest.

Oops. Don't know how we missed that. I'll queue another patch on top and
send another pull request after -rc1 (I have another nit patch already
on my plate).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
