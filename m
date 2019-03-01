From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v6 2/6] arm64/kvm: preserve host MDCR_EL2 value
Date: Fri, 1 Mar 2019 11:40:25 +0530
Message-ID: <4f97aeda-492b-acd2-8a41-340e8bb47240@arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
 <1550568271-5319-3-git-send-email-amit.kachhap@arm.com>
 <20190221155101.GV3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A34F84A414
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Mar 2019 01:10:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EwYAStCbX+Yd for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Mar 2019 01:10:31 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B40B4A3BE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Mar 2019 01:10:31 -0500 (EST)
In-Reply-To: <20190221155101.GV3567@e103592.cambridge.arm.com>
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
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 2/21/19 9:21 PM, Dave Martin wrote:
> On Tue, Feb 19, 2019 at 02:54:27PM +0530, Amit Daniel Kachhap wrote:
>> Save host MDCR_EL2 value during kvm HYP initialisation and restore
>> after every switch from host to guest. There should not be any
>> change in functionality due to this.
>>
>> The value of mdcr_el2 is now stored in struct kvm_cpu_context as
>> both host and guest can now use this field in a common way.
> 
> Is MDCR_EL2 somehow relevant to pointer auth?
> 
> It's not entirely clear why this patch is here.
> 
> If this is a cleanup to align the handling of this register with
> how HCR_EL2 is handled, it would be good to explain that in the commit
> message.
Agreed I will more information in commit message.
> 
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> ---
>>   arch/arm/include/asm/kvm_host.h   |  1 -
>>   arch/arm64/include/asm/kvm_host.h |  6 ++----
>>   arch/arm64/kvm/debug.c            | 28 ++++++----------------------
>>   arch/arm64/kvm/hyp/switch.c       | 17 ++++-------------
>>   arch/arm64/kvm/hyp/sysreg-sr.c    |  6 ++++++
>>   virt/kvm/arm/arm.c                |  1 -
>>   6 files changed, 18 insertions(+), 41 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 05706b4..704667e 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -294,7 +294,6 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>>   static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>>   
>> -static inline void kvm_arm_init_debug(void) {}
>>   static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 1b2e05b..2f1bb86 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -205,6 +205,8 @@ struct kvm_cpu_context {
>>   
>>   	/* HYP host/guest configuration */
>>   	u64 hcr_el2;
>> +	u32 mdcr_el2;
>> +
> 
> ARMv8-A says MDCR_EL2 is a 64-bit register.
> 
> Bits [63:20] are currently RES0, so this is probably not a big deal.
> But it would be better to make this 64-bit to prevent future accidents.
> It may be better to make that change in a separate patch.
Yes this a potential issue. I will fix it in a separate patch.

Thanks,
Amit D
> 
> This is probably non-urgent, since this is clearly not causing problems
> for anyone today.
> 
> [...]
> 
> Cheers
> ---Dave
> 
