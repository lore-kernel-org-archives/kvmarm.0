From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 1/6] arm64/kvm: preserve host HCR_EL2 value
Date: Tue, 26 Feb 2019 10:06:10 +0000
Message-ID: <65651349-e505-bc58-85b0-e6d2b2a2a533@arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
 <1550568271-5319-2-git-send-email-amit.kachhap@arm.com>
 <ba023672-92f5-41dd-1194-4ab4f647b204@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ba023672-92f5-41dd-1194-4ab4f647b204@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 25/02/2019 17:39, James Morse wrote:
> On 19/02/2019 09:24, Amit Daniel Kachhap wrote:
>> From: Mark Rutland <mark.rutland@arm.com>
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

>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 9e350fd3..8e18f7f 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -1328,6 +1328,7 @@ static void cpu_hyp_reinit(void)
>>  		cpu_init_hyp_mode(NULL);
>>  
>>  	kvm_arm_init_debug();
>> +	__cpu_copy_hyp_conf();
> 
> Your commit message says:
> | The saving of the register is done once during cpu hypervisor initialization state
> 
> But cpu_hyp_reinit() is called each time secondary CPUs come online. Its also called as
> part of the cpu-idle mechanism via hyp_init_cpu_pm_notifier(). cpu-idle can ask the
> firmware to power-off the CPU until an interrupt becomes pending for it. KVM's EL2 state
> disappears when this happens, these calls take care of setting it back up again. On Juno,
> this can happen tens of times a second, and this adds an extra call to EL2.

The bit I missed was the MDCR_EL2 copy is behind kvm_arm_init_debug(), so we already have
an unnecessary EL2 call here, so its nothing new.

Assuming the deactivate_traps_vhe_put() vcpu isn't needed, and with Mark's comments addressed:
Reviewed-by: James Morse <james.morse@arm.com>


If we can avoid repeated calls to EL2 once we've got HCR_EL2+MDCR_EL2, even better!


Thanks,

James
