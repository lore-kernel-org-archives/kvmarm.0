From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v8 2/4] arm64: KVM: export the capability to set guest
 SError syndrome
Date: Thu, 19 Jul 2018 16:54:18 +0800
Message-ID: <86da7b47-5026-5ec7-96dc-4d3a14caa2f8@huawei.com>
References: <20180713154751.18131-1-james.morse@arm.com>
 <20180713154751.18131-3-james.morse@arm.com>
 <CAFEAcA9pK7W=gSZXTOTxFEFDmc6kJ8GDYO4a6r_P1FHp+KuT9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1E4C4065F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 04:41:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qrskTXk2pVWh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 04:41:25 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 775BF40196
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 04:41:25 -0400 (EDT)
In-Reply-To: <CAFEAcA9pK7W=gSZXTOTxFEFDmc6kJ8GDYO4a6r_P1FHp+KuT9A@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>, James Morse <james.morse@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, kvm-devel <kvm@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi peter,
  Thanks for the review.

On 2018/7/18 0:36, Peter Maydell wrote:
> On 13 July 2018 at 16:47, James Morse <james.morse@arm.com> wrote:
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
>> Signed-off-by: James Morse <james.morse@arm.com>
>> ---
>>  Documentation/virtual/kvm/api.txt | 11 +++++++++++
>>  arch/arm64/kvm/reset.c            |  3 +++
>>  include/uapi/linux/kvm.h          |  1 +
>>  3 files changed, 15 insertions(+)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index e3940f8715a5..480fa64eb52a 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -4643,3 +4643,14 @@ This capability indicates that KVM supports paravirtualized Hyper-V TLB Flush
>>  hypercalls:
>>  HvFlushVirtualAddressSpace, HvFlushVirtualAddressSpaceEx,
>>  HvFlushVirtualAddressList, HvFlushVirtualAddressListEx.
>> +
>> +8.19 KVM_CAP_ARM_SET_SERROR_ESR
>> +
>> +Architectures: arm, arm64
>> +
>> +This capability indicates that userspace can specify the syndrome value reported
>> +to the guest OS when guest takes a virtual SError interrupt exception.
> 
> "the guest"
  got it, thanks

> 
>> +If KVM has this capability, userspace can only specify the ISS field for the ESR
>> +syndrome, it can not specify the EC field which is not under control by KVM.
> 
> Full stop or semicolon, not comma.
> Not sure what the "which is not under control by KVM" part means.
> 
>> +If this virtual SError is taken to EL1 using AArch64, this value will be reported
>> +in ISS filed of ESR_EL1.
> 
> "the ISS field".
  got it, thanks

> 
> How does this capability interact with the KVM_CAP_VCPU_EVENTS
> API in patch 1? Is it saying "you can specify the ESR via
> that API", or talking about something else?

The user space will firstly check the  KVM_CAP_VCPU_EVENTS through kvm_has_vcpu_events() to know whether KVM can support get/set vcpu events,
If KVM supports get/set vcpu events, it will check KVM_CAP_ARM_SET_SERROR_ESR to know whether can set guest SError ESR, as shown the user space code in [1].

[1]:
+static int kvm_put_vcpu_events(ARMCPU *cpu)
+{
+    CPUARMState *env = &cpu->env;
+    struct kvm_vcpu_events events = {};
+
+    if (!kvm_has_vcpu_events()) {
+        return 0;
+    }
+
+    memset(&events, 0, sizeof(events));
+    events.exception.serror_pending = env->serror.pending;
+
+    if (arm_feature(env, ARM_FEATURE_RAS)) {
+        events.exception.serror_has_esr = env->serror.has_esr;
+        events.exception.serror_esr = env->serror.esr;
+    }
+
+    return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_VCPU_EVENTS, &events);
+}

> 
> What happens if userspace does try to specify the EC field value ?
> Is this an error, or is it ignored ?
if userspace try to specify the EC field value, KVM will return error to userspace, do not be ignored,


> 
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index a3db01a28062..067c6ba969bd 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -77,6 +77,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>>         case KVM_CAP_ARM_PMU_V3:
>>                 r = kvm_arm_support_pmu_v3();
>>                 break;
>> +       case KVM_CAP_ARM_INJECT_SERROR_ESR:
>> +               r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
>> +               break;
>>         case KVM_CAP_SET_GUEST_DEBUG:
>>         case KVM_CAP_VCPU_ATTRIBUTES:
>>         case KVM_CAP_VCPU_EVENTS:
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
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
> thanks
> -- PMM
> 
> .
> 
