From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v6 02/21] KVM: ARM64: Define PMU data structure for each
 vcpu
Date: Tue, 08 Dec 2015 22:14:29 +0800
Message-ID: <5666E5C5.5040504@linaro.org>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
 <1449578860-15808-3-git-send-email-zhaoshenglong@huawei.com>
 <5666DD0A.5060004@arm.com> <20151208135335.GK19612@arm.com>
 <5666E4E0.8050504@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 524A7412A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 09:12:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9gOnp+G24h-u for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2015 09:12:51 -0500 (EST)
Received: from mail-pf0-f180.google.com (mail-pf0-f180.google.com
 [209.85.192.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3103740B40
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 09:12:50 -0500 (EST)
Received: by pfnn128 with SMTP id n128so12826284pfn.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2015 06:14:41 -0800 (PST)
In-Reply-To: <5666E4E0.8050504@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/8 22:10, Marc Zyngier wrote:
> On 08/12/15 13:53, Will Deacon wrote:
>> On Tue, Dec 08, 2015 at 01:37:14PM +0000, Marc Zyngier wrote:
>>> On 08/12/15 12:47, Shannon Zhao wrote:
>>>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>>>
>>>> Here we plan to support virtual PMU for guest by full software
>>>> emulation, so define some basic structs and functions preparing for
>>>> futher steps. Define struct kvm_pmc for performance monitor counter and
>>>> struct kvm_pmu for performance monitor unit for each vcpu. According to
>>>> ARMv8 spec, the PMU contains at most 32(ARMV8_MAX_COUNTERS) counters.
>>>>
>>>> Since this only supports ARM64 (or PMUv3), add a separate config symbol
>>>> for it.
>>>>
>>>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>>>> ---
>>>>   arch/arm64/include/asm/kvm_host.h |  2 ++
>>>>   arch/arm64/kvm/Kconfig            |  8 ++++++++
>>>>   include/kvm/arm_pmu.h             | 40 +++++++++++++++++++++++++++++++++++++++
>>>>   3 files changed, 50 insertions(+)
>>>>   create mode 100644 include/kvm/arm_pmu.h
>>
>> [...]
>>
>>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>>>> index a5272c0..66da9a2 100644
>>>> --- a/arch/arm64/kvm/Kconfig
>>>> +++ b/arch/arm64/kvm/Kconfig
>>>> @@ -36,6 +36,7 @@ config KVM
>>>>   	select HAVE_KVM_EVENTFD
>>>>   	select HAVE_KVM_IRQFD
>>>>   	select KVM_ARM_VGIC_V3
>>>> +	select KVM_ARM_PMU
>>>
>>> What if HW_PERF_EVENTS is not selected? Also, selecting HW_PERF_EVENTS
>>> is not enough, and you probably need PERF_EVENTS as well, So this should
>>> probably read:
>>>
>>> 	select KVM_ARM_PMU if (HW_PERF_EVENTS && PERF_EVENTS)
>>
>> HW_PERF_EVENTS depends on ARM_PMU which in turn depends on PERF_EVENTS.
>
Yeah, this is the reason why I choose HW_PERF_EVENTS.

> in which case, let's make it:
>
> 	select KVM_ARM_PMU if HW_PERF_EVENTS
>
Sure, will do.

> which should give us the minimal chain. I hate the kernel config
> language! ;-)
>
> 	M.
>

-- 
Shannon
