From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 03/11] KVM: arm64: Change hyp_panic()s dependency on
 tpidr_el2
Date: Fri, 22 Sep 2017 11:53:55 +0100
Message-ID: <59C4EBC3.3050103@arm.com>
References: <20170808164616.25949-1-james.morse@arm.com> <20170808164616.25949-4-james.morse@arm.com> <20170917144314.GA99021@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170917144314.GA99021@lvm>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 17/09/17 15:43, Christoffer Dall wrote:
> On Tue, Aug 08, 2017 at 05:46:08PM +0100, James Morse wrote:
>> Make tpidr_el2 a cpu-offset for per-cpu variables in the same way the
>> host uses tpidr_el1. This lets tpidr_el{1,2} have the same value, and
>> on VHE they can be the same register.
>>
>> KVM calls hyp_panic() when anything unexpected happens. This may occur
>> while a guest owns the EL1 registers. KVM stashes the vcpu pointer in
>> tpidr_el2, which it uses to find the host context in order to restore
>> the host EL1 registers before parachuting into the host's panic().
>>
>> The host context is a struct kvm_cpu_context allocated in the per-cpu
>> area, and mapped to hyp. Given the per-cpu offset for this CPU, this is
>> easy to find. Change hyp_panic() to take a pointer to the
>> struct kvm_cpu_context. Wrap these calls with an asm function that
>> retrieves the struct kvm_cpu_context from the host's per-cpu area.
>>
>> Copy the per-cpu offset from the hosts tpidr_el1 into tpidr_el2 during
>> kvm init. (Later patches will make this unnecessary for VHE hosts)
>>
>> We print out the vcpu pointer as part of the panic message. Add a back
>> reference to the 'running vcpu' in the host cpu context to preserve this.

>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> index 945e79c641c4..235d615cee30 100644
>> --- a/arch/arm64/kvm/hyp/switch.c
>> +++ b/arch/arm64/kvm/hyp/switch.c
>> @@ -286,9 +286,9 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>>  	u64 exit_code;
>>  
>>  	vcpu = kern_hyp_va(vcpu);
>> -	write_sysreg(vcpu, tpidr_el2);
>>  
>>  	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
>> +	host_ctxt->__hyp_running_vcpu = vcpu;
> 
> I'm fine with this for now, but eventually when we optimize KVM further
> we may want to avoid doing this in every world-switch.  One option is to
> just set this pointer in vcpu_get and vcpu_load, but would it also be
> possible to use the kvm_arm_running_vcpu per-cpu array directly?

Yes, that would have been better, I didn't know that existed...
After this point we can find per-cpu variables easily, they just need mapping to
HYP.

This pointer is just for the panic message, I'm not sure how useful it is.
For kdump the kvm_arm_running_vcpu array holds the same information, so is
printing this out just so we can spot if its totally-bogus?


As your fine with this for now, I'll put tidying it up on my todo list...


>>  	guest_ctxt = &vcpu->arch.ctxt;
>>  
>>  	__sysreg_save_host_state(host_ctxt);


> Reviewed-by: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Thanks!

James



--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
