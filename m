From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 15/21] KVM: arm64: Set an impdef ESR for Virtual-SError
 using VSESR_EL2.
Date: Mon, 30 Oct 2017 15:44:17 +0000
Message-ID: <59F748D1.4030507@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-16-james.morse@arm.com> <20171030075951.GT2166@lvm>
 <20171030105140.GU2166@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6167D49D4C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 11:44:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VL9mqfkIliIT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Oct 2017 11:44:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09A4740651
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 11:44:30 -0400 (EDT)
In-Reply-To: <20171030105140.GU2166@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 30/10/17 10:51, Christoffer Dall wrote:
> On Mon, Oct 30, 2017 at 08:59:51AM +0100, Christoffer Dall wrote:
>> On Thu, Oct 19, 2017 at 03:58:01PM +0100, James Morse wrote:
>>> Prior to v8.2's RAS Extensions, the HCR_EL2.VSE 'virtual SError' feature
>>> generated an SError with an implementation defined ESR_EL1.ISS, because we
>>> had no mechanism to specify the ESR value.
>>>
>>> On Juno this generates an all-zero ESR, the most significant bit 'ISV'
>>> is clear indicating the remainder of the ISS field is invalid.
>>>
>>> With the RAS Extensions we have a mechanism to specify this value, and the
>>> most significant bit has a new meaning: 'IDS - Implementation Defined
>>> Syndrome'. An all-zero SError ESR now means: 'RAS error: Uncategorized'
>>> instead of 'no valid ISS'.
>>>
>>> Add KVM support for the VSESR_EL2 register to specify an ESR value when
>>> HCR_EL2.VSE generates a virtual SError. Change kvm_inject_vabt() to
>>> specify an implementation-defined value.
>>>
>>> We only need to restore the VSESR_EL2 value when HCR_EL2.VSE is set, KVM
>>> save/restores this bit during __deactivate_traps() and hardware clears the
>>> bit once the guest has consumed the virtual-SError.
>>>
>>> Future patches may add an API (or KVM CAP) to pend a virtual SError with
>>> a specified ESR.


>>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>>> index 945e79c641c4..af37658223a0 100644
>>> --- a/arch/arm64/kvm/hyp/switch.c
>>> +++ b/arch/arm64/kvm/hyp/switch.c
>>> @@ -86,6 +86,10 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>>>  		isb();
>>>  	}
>>>  	write_sysreg(val, hcr_el2);
>>> +
>>> +	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN) && (val & HCR_VSE))
>>> +		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
>>> +

>> Just a heads up: If my optimization work gets merged, that will
>> eventually move stuff like this in to load/put hooks for system
>> registers, but I can deal with this easily, also adding a direct write
>> in pend_guest_serror when moving the logic around.

Sure. This would always be called when the vcpu is loaded, so yes it should end
up as a direct write to the system register.


>> However, if we start architecting something more complex, it would be
>> good to keep in mind how to maintain minimum work on the switching path
>> after we've optimized the hypervisor.

I think gengdongjiu's trick of only restoring VSESR if HCR_EL2.VSE is set is the
best we can do here. (Hence the Celebrate-Contribution tag).

For VDISR_EL2 we can probably only save/restore it if its non-zero. On most
systems it will never be touched so the cost is testing that whenever we exit
the guest/unload the vcpu.


> Actually, after thinking about this, if the guest can only see this via
> the ESR if we set the HCR_EL2.VSE, wouldn't it make sense to just set
> this value in pend_guest_serror, and if we're on a non-VHE system --
> assuming that's something we want to support with this 8.2 feature
> -- we jump to EL2 and back to set the value?

It thought this was the 'eventually ... direct write' above.
Once your load/put hooks are merged? Yes, just write it straight to the CPU
register and set the guests HCR_EL2.VSE.

Now? Wouldn't this get lost if we reschedule onto another cpu...


Thanks,

James
