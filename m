From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v5 22/26] KVM: arm64/sve: Add pseudo-register for the
 guest's vector lengths
Date: Fri, 1 Mar 2019 13:28:19 +0000
Message-ID: <a8082d89-84bd-06fa-5781-96e11376bb66@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-23-git-send-email-Dave.Martin@arm.com>
 <34b7691f-7acb-c9aa-6e53-2857e429f148@arm.com>
 <20190226121347.GT3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F8B54A3B6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Mar 2019 08:28:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J+AK--0KdEx7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Mar 2019 08:28:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4488C4A380
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Mar 2019 08:28:30 -0500 (EST)
In-Reply-To: <20190226121347.GT3567@e103592.cambridge.arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 26/02/2019 12:13, Dave Martin wrote:
> On Thu, Feb 21, 2019 at 05:48:59PM +0000, Julien Thierry wrote:
>> Hi Dave,
>>
>> On 18/02/2019 19:52, Dave Martin wrote:
>>> This patch adds a new pseudo-register KVM_REG_ARM64_SVE_VLS to
>>> allow userspace to set and query the set of vector lengths visible
>>> to the guest, along with corresponding storage in struct
>>> kvm_vcpu_arch.
>>>
>>> In the future, multiple register slices per SVE register may be
>>> visible through the ioctl interface.  Once the set of slices has
>>> been determined we would not be able to allow the vector length set
>>> to be changed any more, in order to avoid userspace seeing
>>> inconsistent sets of registers.  For this reason, this patch adds
>>> support to track vcpu finalization explicitly, and enforce proper
>>> sequencing of ioctls.
>>>
>>> The new pseudo-register is not exposed yet.  Subsequent patches
>>> will allow SVE to be turned on for guest vcpus, making it visible.
>>>
>>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>>>
>>> ---
>>>
>>> Changes since v4:
>>>
>>>  * Add a UAPI header comment indicating the pseudo-register status of
>>>    KVM_REG_ARM64_SVE_VLS.
>>>
>>>  * Get rid of the sve_vqs[] array from struct kvm_vcpu_arch.  This
>>>    array is pointless, because its contents must match the host's
>>>    internal sve_vq_map anyway, up to vcpu->arch.sve_max_vl.
>>>
>>>    The ioctl register accessors are slow-path code, so we can decode
>>>    or reconstruct sve_vqs[] on demand instead, for exchange with
>>>    userspace.
>>>
>>>  * For compatibility with potential future architecture extensions,
>>>    enabling vector lengths above 256 bytes for the guest is explicitly
>>>    disallowed now (because the code for exposing additional bits
>>>    through ioctl is currently missing).  This can be addressed later
>>>    if/when needed.
>>>
>>> Note:
>>>
>>>  * I defensively pass an array by pointer here, to help avoid
>>>    accidentally breaking assumptions during future maintenance.
>>>
>>>    Due to (over?)zealous constification, this causes the following
>>>    sparse warning.  I think this is sparse getting confused: I am not
>>>    relying on any kernel-specific semantics here, and GCC generates no
>>>    warning.
>>>
>>> +arch/arm64/kvm/guest.c:33: warning: incorrect type in argument 1 (different modifiers)
>>> +arch/arm64/kvm/guest.c:33:    expected unsigned long long const [usertype] ( *const vqs )[8]
>>> +arch/arm64/kvm/guest.c:33:    got unsigned long long [usertype] ( * )[8]
>>>
>>> ---
> 
> [...]
> 
>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> 
> [...]
> 
>>> +static int get_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>> +{
>>> +	unsigned int max_vq, vq;
>>> +	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
>>> +
>>> +	if (WARN_ON(!sve_vl_valid(vcpu->arch.sve_max_vl)))
>>> +		return -EINVAL;
>>> +
>>> +	memset(vqs, 0, sizeof(vqs));
>>> +
>>> +	max_vq = sve_vq_from_vl(vcpu->arch.sve_max_vl);
>>> +	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
>>> +		if (sve_vq_available(vq))
>>> +			vqs[vq_word(vq)] |= vq_mask(vq);
>>> +
>>> +	BUILD_BUG_ON(sizeof(vqs) != KVM_REG_SIZE(reg->id));
>>
>> reg->id is not know at build time. From my understanding of
>> BUILD_BUG_ON(), things actually ends up evaluated at runtime but I'm not
>> sure what happens when doing sizeof(char[1- 2*0]) at runtime.
>>
>> Anyway, I don't think this is intended.
> 
> There's no runtime check: BUILD_BUG_ON() will cause compilation to fail
> if the required condition doesn't fall out from optimisation.
> 
> Because of the way this function is called, reg->id is always
> KVM_REG_ARM64_SVE_VLS, so inlining and constant propagation will make
> this check pass (and compile to nothing).
> 
> We can assume a certain amount of inlining: the kernel officially can't
> be built without optimisation.  But the precise build configuration can
> sometimes have an effect here -- so it may not be better to rely on this
> working for this slow-path code.
> 
> I'll convert these to if (WARN_ON()) return -EIO or something, or drop
> them if I can get rid of them in other refactoring.
> 
> The fact that struct kvm_one_reg lacks any "size" field is rather
> unfortunate, since it provides no explicit way for userspace to tell us
> the size of its buffer.
> 
>>> +	if (copy_to_user((void __user *)reg->addr, vqs, sizeof(vqs)))
>>> +		return -EFAULT;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>> +{
>>> +	unsigned int max_vq, vq;
>>> +	u64 vqs[DIV_ROUND_UP(SVE_VQ_MAX - SVE_VQ_MIN + 1, 64)];
>>> +
>>> +	if (kvm_arm_vcpu_finalized(vcpu))
>>> +		return -EPERM; /* too late! */
>>> +
>>> +	if (WARN_ON(vcpu->arch.sve_state))
>>> +		return -EINVAL;
>>> +
>>> +	BUILD_BUG_ON(sizeof(vqs) != KVM_REG_SIZE(reg->id));
>>
>> Same as above.
>>
>>> +	if (copy_from_user(vqs, (const void __user *)reg->addr, sizeof(vqs)))
>>> +		return -EFAULT;
>>> +
>>> +	max_vq = 0;
>>> +	for (vq = SVE_VQ_MIN; vq <= SVE_VQ_MAX; ++vq)
>>> +		if (vq_present(&vqs, vq))
>>> +			max_vq = vq;
>>> +
>>> +	/*
>>> +	 * The get_sve_reg()/set_sve_reg() ioctl interface will need
>>> +	 * to be extended with multiple register slice support in
>>> +	 * order to support vector lengths greater than
>>> +	 * SVE_VL_ARCH_MAX:
>>> +	 */
>>> +	if (WARN_ONCE(sve_vl_from_vq(max_vq) > SVE_VL_ARCH_MAX,
>>> +		      "KVM: Requested vector length not supported yet\n"))
>>> +		return -EINVAL;
>>> +
>>> +	for (vq = SVE_VQ_MIN; vq <= max_vq; ++vq)
>>> +		if (vq_present(&vqs, vq) != sve_vq_available(vq))
>>> +			return -EINVAL;
>>> +
>>> +	/* Can't run with no vector lengths at all: */
>>> +	if (max_vq < SVE_VQ_MIN)
>>> +		return -EINVAL;
>>> +
>>> +	vcpu->arch.sve_max_vl = sve_vl_from_vq(max_vq);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  #define SVE_REG_SLICE_SHIFT	0
>>>  #define SVE_REG_SLICE_BITS	5
>>>  #define SVE_REG_ID_SHIFT	(SVE_REG_SLICE_SHIFT + SVE_REG_SLICE_BITS)
>>> @@ -297,9 +372,21 @@ static int sve_reg_region(struct sve_state_region *region,
>>>  static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>>  {
>>>  	struct sve_state_region region;
>>> +	int ret;
>>>  	char __user *uptr = (char __user *)reg->addr;
>>>  
>>> -	if (!vcpu_has_sve(vcpu) || sve_reg_region(&region, vcpu, reg))
>>> +	if (!vcpu_has_sve(vcpu))
>>> +		return -ENOENT;
>>> +
>>> +	if (reg->id == KVM_REG_ARM64_SVE_VLS)
>>> +		return get_sve_vls(vcpu, reg);
>>> +
>>> +	/* Finalize the number of slices per SVE register: */
>>> +	ret = kvm_arm_vcpu_finalize(vcpu);
>>
>> Having this here feels a bit random...
> 
> I'll have another think about this.
> 
> KVM_REG_ARM64_SVE_VLS certainly has nothing to do with anything except
> SVE, and putting it in the SVE coproc space allows us to demux SVE-
> related stuff from everything else neatly.
> 
> The whole "coprocessor" concept is nonsense for arm64 anyway except
> for the sysregs (where the reg ID encodings map directly onto the
> architecture and also align with AArch32).  So, the copro number is
> pretty meaningless except as a demux key for related groups of
> registers, which is how I use it here.
> 
> There's also no well-defined distinction between real and fake
> registers, and no natural home for miscellaneous fakes -- all existing
> blocks are for specific purposes such as recording the state of emulated
> firmware APIs etc.  The SVE registers as exposed here already have no
> direct equivalent in the architecture either, due to the padding up to
> 2048 bits, and the presentation of FFR as addressable P-register etc.
> 
>> I'd suggest considering the pseudo-register outside of the SVE co-proc,
>> as part of a set of registers that do not finalize a vcpu when accessed.
> 
> (Also, the dependency is not one-way:  _SVE_VLS is not independent
> of finalization: quite the reverse -- it can only be written _before_
> finalization.)
> 
>> All other registers (even non-sve ones) would finalize the vcpu when
>> accessed from userland.
> 
> So, we could consider register to be in two classes as you suggest:
> 
>  * early registers
>  * regular registers (i.e., everything else)
> 
> where early registers can only be written until the first access to a
> regular register, or the first KVM_GET_REG_LIST or KVM_RUN.
> 

That would be my personal preference, yes.

> This is a stricter rule than I have today: i.e., _SVE_VLS would really
> need to be written before touching anything else.  But that may be a
> good thing for avoiding future ABI drift.
> 

I did notice this would be more restrictive, but I don't believe this
should introduce shortcoming in ways to set up a VCPU. I might have
missed some case of course.

> This may be premature factoring though.  It's not clear whether many new
> registers like KVM_REG_ARM64_SVE_VLS will exist, or that they would have
> compatible sequencing requirements.
> 
> Thoughts?
> 

It might be premature, but I really don't like seeing this
"vcpu_finalize" in the middle of SVE code. I think it is very easy to
miss that touching some "sve" register suddenly finalizes the vcpu.

I fear that some other feature/extention might need early vcpu
finalization and that it might somehow conflict with sve depending on
which triggers finalization first.

> 
> Independently of this, I'll have a look at whether there's
> a straightforward way to simplify the code flow.
> 

I might be over-thinking it, but if there is a way to move that
finalization call I'd prefer that.

Thanks,

-- 
Julien Thierry
