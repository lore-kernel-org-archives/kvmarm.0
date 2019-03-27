From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v6 19/27] KVM: arm64: Enumerate SVE register indices for
 KVM_GET_REG_LIST
Date: Wed, 27 Mar 2019 15:21:02 +0000
Message-ID: <71c30b21-9a4b-42d5-02a8-25bc18044c1f@arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
 <1553017938-710-20-git-send-email-Dave.Martin@arm.com>
 <612e5089-fc43-eee4-1856-cdca89ce3b50@arm.com>
 <20190327103319.GT3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 073BC4A32E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Mar 2019 11:21:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nMYCwFcRcHPl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Mar 2019 11:21:14 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 747484A319
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Mar 2019 11:21:14 -0400 (EDT)
In-Reply-To: <20190327103319.GT3567@e103592.cambridge.arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 27/03/2019 10:33, Dave Martin wrote:
> On Wed, Mar 27, 2019 at 09:47:42AM +0000, Julien Thierry wrote:
>> Hi Dave,
>>
>> On 19/03/2019 17:52, Dave Martin wrote:
>>> This patch includes the SVE register IDs in the list returned by
>>> KVM_GET_REG_LIST, as appropriate.
>>>
>>> On a non-SVE-enabled vcpu, no new IDs are added.
>>>
>>> On an SVE-enabled vcpu, IDs for the FPSIMD V-registers are removed
>>> from the list, since userspace is required to access the Z-
>>> registers instead in order to access the V-register content.  For
>>> the variably-sized SVE registers, the appropriate set of slice IDs
>>> are enumerated, depending on the maximum vector length for the
>>> vcpu.
>>>
>>> As it currently stands, the SVE architecture never requires more
>>> than one slice to exist per register, so this patch adds no
>>> explicit support for enumerating multiple slices.  The code can be
>>> extended straightforwardly to support this in the future, if
>>> needed.
>>>
>>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>>>
>>
>> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> 
> Thanks, although...
> 
>>> ---
>>>
>>> Changes since v5:
>>>
>>> (Dropped Julien Thierry's Reviewed-by due to non-trivial rebasing)
>>>
>>>  * Move mis-split reword to prevent put_user()s being accidentally the
>>>    correct size from KVM: arm64/sve: Add pseudo-register for the guest's
>>>    vector lengths.
>>> ---
>>>  arch/arm64/kvm/guest.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 56 insertions(+)
>>>
>>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>>> index 736d8cb..585c31e5 100644
>>> --- a/arch/arm64/kvm/guest.c
>>> +++ b/arch/arm64/kvm/guest.c
>>> @@ -411,6 +411,56 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>>  	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)) ? -EFAULT : 0;
>>>  }
>>>  
>>> +static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
>>> +{
>>> +	/* Only the first slice ever exists, for now */
>>> +	const unsigned int slices = 1;
>>
>> Nit: Might be worth introducing a macro/inline function for the number
>> of slices supported. This way, the day we need to change that, we only
>> need to look for that identifier.
> 
> ... Reasonable point, but I wanted to avoid inventing anything
> prematurely, partly because sve_reg_to_region() will need work in order
> to support multiple slices (though it's not rocket science).
> 
> I could introduce something like the following:
> 
> static unsigned int sve_num_slices(const struct kvm_vcpu *vcpu)
> {
> 	unsigned int slice_size = KVM_REG_SIZE(KVM_REG_ARM64_SVE_ZREG(0, 0));
> 	unsigned int slices = DIV_ROUND_UP(vcpu->arch.sve_max_vl, slice_size);
> 
> 	/*
> 	 * For now, the SVE register ioctl access code won't work
> 	 * properly with multiple register slices.  KVM should prevent
> 	 * configuration of a vcpu with a maximum vector length large
> 	 * enough to trigger this:
> 	 */
> 	if (WARN_ON_ONCE(slices > 1))
> 		return 1;
> 
> 	return slices;
> }
> 
> This may be clearer, but felt a bit like overkill...
> 
> Thoughts?

Seems a bit overkill yes... I was more thinking of a define and the
person in charge of adding the slice support would just need to look for
references to that define to know (some of) the places that would need
rework/review.

So, unless someone else thinks it's good to introduce it right now you
can ignore that.

Thanks,

-- 
Julien Thierry
