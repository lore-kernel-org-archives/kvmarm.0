From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v7 5/10] KVM: arm/arm64: preserve host MDCR_EL2 value
Date: Tue, 26 Mar 2019 09:25:36 +0530
Message-ID: <bce98120-b844-f4a2-cd44-a0e8418dfd13@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
 <1552984243-7689-6-git-send-email-amit.kachhap@arm.com>
 <19c2bdb3-6917-286e-3f2a-35fd71f69f51@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <19c2bdb3-6917-286e-3f2a-35fd71f69f51@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 3/26/19 1:34 AM, Kristina Martsenko wrote:
> On 19/03/2019 08:30, Amit Daniel Kachhap wrote:
>> Save host MDCR_EL2 value during kvm HYP initialisation and restore
>> after every switch from host to guest. There should not be any
>> change in functionality due to this.
>>
>> The value of mdcr_el2 is now stored in struct kvm_cpu_context as
>> both host and guest can now use this field in a common way.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> Acked-by: Mark Rutland <mark.rutland@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
> 
> [...]
> 
>>   /**
>> - * kvm_arm_init_debug - grab what we need for debug
>> - *
>> - * Currently the sole task of this function is to retrieve the initial
>> - * value of mdcr_el2 so we can preserve MDCR_EL2.HPMN which has
>> - * presumably been set-up by some knowledgeable bootcode.
>> - *
>> - * It is called once per-cpu during CPU hyp initialisation.
>> - */
>> -
>> -void kvm_arm_init_debug(void)
>> -{
>> -	__this_cpu_write(mdcr_el2, kvm_call_hyp_ret(__kvm_get_mdcr_el2));
>> -}
> 
> The __kvm_get_mdcr_el2 function is no longer used anywhere, so can also
> be removed.
Nice catch. Will do.

Thanks,
Amit D
> 
> Thanks,
> Kristina
> 
