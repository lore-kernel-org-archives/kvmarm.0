From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH 10/37] KVM: arm64: Slightly improve debug save/restore
 functions
Date: Wed, 6 Dec 2017 15:38:09 +0000
Message-ID: <f6bf597c-5b21-ce31-969c-c2bd0629db79@arm.com>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-11-christoffer.dall@linaro.org>
 <e9b8d6b8-6dfa-3e6d-6e8f-c16a1882651f@arm.com> <20171201151938.GA6615@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171201151938.GA6615@lvm>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 01/12/17 15:19, Christoffer Dall wrote:
> Hi Julien,
> 
> On Tue, Nov 14, 2017 at 04:42:13PM +0000, Julien Thierry wrote:
>> On 12/10/17 11:41, Christoffer Dall wrote:
>>> The debug save/restore functions can be improved by using the has_vhe()
>>> static key instead of the instruction alternative.  Using the static key
>>> uses the same paradigm as we're going to use elsewhere, it makes the
>>> code more readable, and it generates slightly better code (no
>>> stack setups and function calls unless necessary).
>>>
>>> We also use a static key on the restore path, because it will be
>>> marginally faster than loading a value from memory.
>>>
>>> Finally, we don't have to conditionally clear the debug dirty flag if
>>> it's set, we can just clear it.
>>>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> ---
>>>   arch/arm64/kvm/hyp/debug-sr.c | 22 +++++++++-------------
>>>   1 file changed, 9 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
>>> index 0fc0758..a2291b6 100644
>>> --- a/arch/arm64/kvm/hyp/debug-sr.c
>>> +++ b/arch/arm64/kvm/hyp/debug-sr.c
>>> @@ -75,11 +75,6 @@
>>>   #define psb_csync()		asm volatile("hint #17")
>>> -static void __hyp_text __debug_save_spe_vhe(u64 *pmscr_el1)
>>> -{
>>> -	/* The vcpu can run. but it can't hide. */
>>> -}
>>> -
>>>   static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
>>>   {
>>>   	u64 reg;
>>> @@ -109,10 +104,6 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
>>>   	dsb(nsh);
>>>   }
>>> -static hyp_alternate_select(__debug_save_spe,
>>> -			    __debug_save_spe_nvhe, __debug_save_spe_vhe,
>>> -			    ARM64_HAS_VIRT_HOST_EXTN);
>>> -
>>>   static void __hyp_text __debug_restore_spe(u64 pmscr_el1)
>>>   {
>>>   	if (!pmscr_el1)
>>> @@ -174,17 +165,22 @@ void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
>>>   {
>>>   	__debug_save_state(vcpu, &vcpu->arch.host_debug_state.regs,
>>>   			   kern_hyp_va(vcpu->arch.host_cpu_context));
>>> -	__debug_save_spe()(&vcpu->arch.host_debug_state.pmscr_el1);
>>> +
>>> +	/* Non-VHE: Disable and flush SPE data generation
>>> +	 * VHE: The vcpu can run. but it can't hide. */
>>> +	if (!has_vhe())
>>> +		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
>>>   }
>>>   void __hyp_text __debug_cond_restore_host_state(struct kvm_vcpu *vcpu)
>>>   {
>>> -	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
>>> +	if (!has_vhe())
>>> +		__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
>>
>> For consistency, would it be worth naming that function
>> '__debug_restore_spe_nvhe' ?
> 
> Yes.
> 
>>
>> Also, looking at __debug_save_spe_nvhe, I'm not sure how we guarantee that
>> we might not end up using stale data during the restore_spe (though, if this
>> is an issue, it existed before this change).
>> The save function might exit without setting a value to saved pmscr_el1.
>>
>> Basically I'm wondering if the following scenario (in non VHE) is possible
>> and/or whether it is problematic:
>>
>> - save spe
>> - restore spe
>> - host starts using spi -> !(PMBLIMITR_EL1 & PMBLIMITR_EL1_E)
> 
> spi ?

spe*

> 
>> - save spe -> returns early without setting pmscr_el1
>> - restore spe with old save instead of doing nothing
>>
> 
> I think I see what you mean.  Basically you're asking if we need this:
> 
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> index 4112160..8ab3510 100644
> --- a/arch/arm64/kvm/hyp/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -106,7 +106,7 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
>   
>   static void __hyp_text __debug_restore_spe_nvhe(u64 &pmscr_el1)
>   {
> -	if (!pmscr_el1)
> +	if (*pmscr_el1 != 0)
>   		return;
>   
>   	/* The host page table is installed, but not yet synchronised */
> @@ -114,6 +114,7 @@ static void __hyp_text __debug_restore_spe_nvhe(u64 &pmscr_el1)
>   
>   	/* Re-enable data generation */
>   	write_sysreg_s(pmscr_el1, PMSCR_EL1);
> +	*pmscr_el1 = 0;
>   }
>   
>   void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
> 
> I think we do, and I think this is a separate fix.  Would you like to
> write a patch and cc Will and Marc (original author and committer) to
> fix this?  Probably worth a cc stable as well.
> 

Yes, this is what I was referring to. I agree it is a separate fix. I'll 
make a patch for this.

Thanks,

-- 
Julien Thierry
