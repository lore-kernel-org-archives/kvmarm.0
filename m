From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v6 1/6] arm64/kvm: preserve host HCR_EL2 value
Date: Thu, 28 Feb 2019 12:13:44 +0530
Message-ID: <f48272eb-2315-8bcc-b74b-8461d5bf9683@arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
 <1550568271-5319-2-git-send-email-amit.kachhap@arm.com>
 <20190221115034.GA33673@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190221115034.GA33673@lakrids.cambridge.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 2/21/19 5:20 PM, Mark Rutland wrote:
> Hi,
> 
> On Tue, Feb 19, 2019 at 02:54:26PM +0530, Amit Daniel Kachhap wrote:
>> From: Mark Rutland <mark.rutland@arm.com>
>>
>> When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
>> is a constant value. This works today, as the host HCR_EL2 value is
>> always the same, but this will get in the way of supporting extensions
>> that require HCR_EL2 bits to be set conditionally for the host.
>>
>> To allow such features to work without KVM having to explicitly handle
>> every possible host feature combination, this patch has KVM save/restore
>> for the host HCR when switching to/from a guest HCR. The saving of the
>> register is done once during cpu hypervisor initialization state and is
>> just restored after switch from guest.
>>
>> For fetching HCR_EL2 during kvm initialisation, a hyp call is made using
>> kvm_call_hyp and is helpful in NHVE case.
>>
>> For the hyp TLB maintenance code, __tlb_switch_to_host_vhe() is updated
>> to toggle the TGE bit with a RMW sequence, as we already do in
>> __tlb_switch_to_guest_vhe().
>>
>> The value of hcr_el2 is now stored in struct kvm_cpu_context as both host
>> and guest can now use this field in a common way.
>>
>> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>> [Added __cpu_copy_hyp_conf, hcr_el2 field in struct kvm_cpu_context]
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
> 
> [...]
> 
>> +/**
>> + * __cpu_copy_hyp_conf - copy the boot hyp configuration registers
>> + *
>> + * It is called once per-cpu during CPU hyp initialisation.
>> + */
>> +static inline void __cpu_copy_hyp_conf(void)
> 
> I think this would be better named as something like:
> 
>    cpu_init_host_ctxt()
> 
> ... as that makes it a bit clearer as to what is being initialized.
ok, Agreed with the name.
> 
> [...]
> 
>> +/**
>> + * __kvm_populate_host_regs - Stores host register values
>> + *
>> + * This function acts as a function handler parameter for kvm_call_hyp and
>> + * may be called from EL1 exception level to fetch the register value.
>> + */
>> +void __hyp_text __kvm_populate_host_regs(void)
>> +{
>> +	struct kvm_cpu_context *host_ctxt;
>> +
>> +	if (has_vhe())
>> +		host_ctxt = this_cpu_ptr(&kvm_host_cpu_state);
>> +	else
>> +		host_ctxt = __hyp_this_cpu_ptr(kvm_host_cpu_state);
> 
> Do we need the has_vhe() check here?
> 
> Can't we always do:
> 
> 	host_ctxt = __hyp_this_cpu_ptr(kvm_host_cpu_state);
> 
> ... regardless of VHE? Or is that broken for VHE somehow?
Yes it works fine for VHE. I missed this.

Thanks,
Amit
> 
> Thanks,
> Mark.
> 
