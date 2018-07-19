From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v8 1/4] arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS
Date: Thu, 19 Jul 2018 15:39:59 +0800
Message-ID: <49bb119c-ec31-34ee-f4e5-9f3e90d7c181@huawei.com>
References: <20180713154751.18131-1-james.morse@arm.com>
 <20180713154751.18131-2-james.morse@arm.com>
 <CAFEAcA-t8U-GmkCtAcAN8tj4UAaynCZhgTi1Cg1RhaarGUOJfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB35449EA2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 03:27:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kKPIhYKGgpTv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 03:27:25 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E536D40192
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 03:27:24 -0400 (EDT)
In-Reply-To: <CAFEAcA-t8U-GmkCtAcAN8tj4UAaynCZhgTi1Cg1RhaarGUOJfg@mail.gmail.com>
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

On 2018/7/18 0:33, Peter Maydell wrote:
> On 13 July 2018 at 16:47, James Morse <james.morse@arm.com> wrote:
>> From: Dongjiu Geng <gengdongjiu@huawei.com>
>>
>> For the migrating VMs, user space may need to know the exception
>> state. For example, in the machine A, KVM make an SError pending,
>> when migrate to B, KVM also needs to pend an SError.
>>
>> This new IOCTL exports user-invisible states related to SError.
>> Together with appropriate user space changes, user space can get/set
>> the SError exception state to do migrate/snapshot/suspend.
>>
>> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
>> Reviewed-by: James Morse <james.morse@arm.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> ---
>>  Documentation/virtual/kvm/api.txt    | 33 +++++++++++++++++---
>>  arch/arm64/include/asm/kvm_emulate.h |  5 +++
>>  arch/arm64/include/asm/kvm_host.h    |  7 +++++
>>  arch/arm64/include/uapi/asm/kvm.h    | 13 ++++++++
>>  arch/arm64/kvm/guest.c               | 46 ++++++++++++++++++++++++++++
>>  arch/arm64/kvm/inject_fault.c        |  6 ++--
>>  arch/arm64/kvm/reset.c               |  1 +
>>  virt/kvm/arm/arm.c                   | 21 +++++++++++++
>>  8 files changed, 125 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index d10944e619d3..e3940f8715a5 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -835,11 +835,13 @@ struct kvm_clock_data {
>>
>>  Capability: KVM_CAP_VCPU_EVENTS
>>  Extended by: KVM_CAP_INTR_SHADOW
>> -Architectures: x86
>> -Type: vm ioctl
>> +Architectures: x86, arm64
>> +Type: vcpu ioctl
>>  Parameters: struct kvm_vcpu_event (out)
>>  Returns: 0 on success, -1 on error
>>
>> +X86:
>> +
>>  Gets currently pending exceptions, interrupts, and NMIs as well as related
>>  states of the vcpu.
>>
>> @@ -881,15 +883,32 @@ Only two fields are defined in the flags field:
>>  - KVM_VCPUEVENT_VALID_SMM may be set in the flags field to signal that
>>    smi contains a valid state.
>>
>> +ARM64:
>> +
>> +Gets currently pending SError exceptions as well as related states of the vcpu.
> 
> Any chance of expanding this to explain what this state actually is?
> (ie something you could use to implement or review the userspace
> code which has to manipulate it)
sure, can expand it.

serror_pending means whether KVM is pending Serror for guest.
serror_has_esr means whether KVM or user space can set the SError syndrome for guest.
serror_esr means the value of SError syndrome.

Anyway, I will expand this to explain it.

> 
>> +
>> +struct kvm_vcpu_events {
>> +       struct {
>> +               __u8 serror_pending;
>> +               __u8 serror_has_esr;
>> +               /* Align it to 8 bytes */
>> +               __u8 pad[6];
>> +               __u64 serror_esr;
>> +       } exception;
>> +       __u32 reserved[12];
>> +};
>> +
>>  4.32 KVM_SET_VCPU_EVENTS
> 
> thanks
> -- PMM
> 
> .
> 
