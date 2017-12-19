From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 8/9] KVM: arm/arm64: Avoid work when userspace iqchips
 are not used
Date: Tue, 19 Dec 2017 13:55:25 +0000
Message-ID: <5e24dec5-613f-c10f-4577-df3787ad9d64@arm.com>
References: <20171213104602.16383-1-christoffer.dall@linaro.org>
 <20171213104602.16383-9-christoffer.dall@linaro.org>
 <86fu8ewfzm.wl-marc.zyngier@arm.com> <20171219133452.GA5380@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171219133452.GA5380@cbox>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 19/12/17 13:34, Christoffer Dall wrote:
> On Wed, Dec 13, 2017 at 08:05:33PM +0000, Marc Zyngier wrote:
>> On Wed, 13 Dec 2017 10:46:01 +0000,
>> Christoffer Dall wrote:
>>>
>>> We currently check if the VM has a userspace irqchip on every exit from
>>> the VCPU, and if so, we do some work to ensure correct timer behavior.
>>> This is unfortunate, as we could avoid doing any work entirely, if we
>>> didn't have to support irqchip in userspace.
>>>
>>> Realizing the userspace irqchip on ARM is mostly a developer or hobby
>>> feature, and is unlikely to be used in servers or other scenarios where
>>> performance is a priority, we can use a refcounted static key to only
>>> check the irqchip configuration when we have at least one VM that uses
>>> an irqchip in userspace.
>>>
>>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>
>> On its own, this doesn't seem to be that useful. As far as I can see,
>> it saves us a load from the kvm structure before giving up.
> 
> A load and a conditional.  But what I really wanted to also avoid was
> the function call from the main run loop, which I neglected as well.  I
> think I can achieve that with a static inline wrapper in the arch timer
> header file which first evaluates the static key and then calls into the
> arch timer code.
> 
> 
>> I think it
>> is more the cumulative effect of this load that could have an impact,
>> but you're only dealing with it at a single location.
>>
>> How about making this a first class helper and redefine
>> irqchip_in_kernel as such:
>>
>> static inline bool irqchip_in_kernel(struct kvm *kvm)
>> {
>> 	if (static_branch_unlikely(&userspace_irqchip_in_use) &&
>> 	    unlikely(!irqchip_in_kernel(kvm)))
>> 		return true;
>>
>> 	return false;
>> }
>>
>> and move that static key to a more central location?
>>
> 
> That's a neat idea.  The only problem is that creating a new VM would
> then flip the static key, and then we'd have to flip it back when a vgic
> is created on that VM, and I don't particularly like the idea of doing
> this too often.

Fair enough.

> 
> What I'd suggest then is to have two versions of the function:
> irqchip_in_kernel() which is what it is today, and then
> __irqchip_in_kernel() which can only be called from within the critical
> path of the run loop, so that we can increment the static key on
> kvm_vcpu_first_run_init() when we don't have a VGIC.
> 
> How does that sound?

OK, you only patch once per non-VGIC VM instead of twice per VGIC VM.
But you now create a distinction between what can be used at runtime and
what can be used at config time. The distinction is a bit annoying.

Also, does this actually show up on the radar?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
