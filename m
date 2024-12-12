Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E1120E6ED
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 09:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733995407; cv=none; b=HDhM1j6ehGuA6jnSa23gmtsZlSZRhDUU8qwt1xaZNDFLHAcbZG9d66FZsRc92LPZQ+tls8c/L+6WooLom+88DcQtGdVA1XkR40OtEg5nk87FVQwbzWDzcaqUAo87NyAHwCzaAVhjzDhiPqaqDYLRL/DKWwHOyp+0ERTd9UkV9dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733995407; c=relaxed/simple;
	bh=LpuCZ0zn9wOcs7NjXo1QHfxAcyOWNdCR9dbvUV4Dv1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AJ1q9NGZeo0VdfcWVnBCYc/BoFoE+4JvgY43asqbkvREuB3u09tTyP95vPXgMjt/dCT0MMba/OhBi9Sh/1FUAdBhYKQ8uNHx/yWCvyfLJDkX9/k5Slg5spNmt+1fD29YQ24SAHPXk9B2vITCRAGGz2vqOLhjfvJxpsjHrC3BaTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A0F1169E;
	Thu, 12 Dec 2024 01:23:52 -0800 (PST)
Received: from [10.57.92.2] (unknown [10.57.92.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50E893F5A1;
	Thu, 12 Dec 2024 01:23:22 -0800 (PST)
Message-ID: <5d4ccb2c-da45-4471-9bb1-90212b50dad7@arm.com>
Date: Thu, 12 Dec 2024 09:23:20 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND RFC PATCH v1 1/5] arm64: Add TLB Conflict Abort Exception
 handler to KVM
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, corbet@lwn.net,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20241211160218.41404-1-miko.lenczewski@arm.com>
 <20241211160218.41404-2-miko.lenczewski@arm.com>
 <86o71irucr.wl-maz@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <86o71irucr.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/12/2024 17:40, Marc Zyngier wrote:
> On Wed, 11 Dec 2024 16:01:37 +0000,
> Mikołaj Lenczewski <miko.lenczewski@arm.com> wrote:
>>
>> Currently, KVM does not handle the case of a stage 2 TLB conflict abort
>> exception. The Arm ARM specifies that the worst-case handling of such an
>> exception requires a `tlbi vmalls12e1`.
> 
> Not quite. It says (I_JCCRT):
> 
> <quote>
> * For the EL1&0 translation regime, when stage 2 translations are in
>   use, either VMALLS12E1 or ALLE1.
> </quote>
> 
>> Perform such an invalidation when this exception is encountered.
> 
> What you fail to describe is *why* this is needed. You know it, I know
> it, but not everybody does. A reference to the ARM ARM would
> definitely be helpful.
> 
>>
>> Signed-off-by: Mikołaj Lenczewski <miko.lenczewski@arm.com>
>> ---
>>  arch/arm64/include/asm/esr.h | 8 ++++++++
>>  arch/arm64/kvm/mmu.c         | 6 ++++++
>>  2 files changed, 14 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
>> index d1b1a33f9a8b..8a66f81ca291 100644
>> --- a/arch/arm64/include/asm/esr.h
>> +++ b/arch/arm64/include/asm/esr.h
>> @@ -121,6 +121,7 @@
>>  #define ESR_ELx_FSC_SEA_TTW(n)	(0x14 + (n))
>>  #define ESR_ELx_FSC_SECC	(0x18)
>>  #define ESR_ELx_FSC_SECC_TTW(n)	(0x1c + (n))
>> +#define ESR_ELx_FSC_TLBABT	(0x30)
>>  
>>  /* Status codes for individual page table levels */
>>  #define ESR_ELx_FSC_ACCESS_L(n)	(ESR_ELx_FSC_ACCESS + (n))
>> @@ -464,6 +465,13 @@ static inline bool esr_fsc_is_access_flag_fault(unsigned long esr)
>>  	       (esr == ESR_ELx_FSC_ACCESS_L(0));
>>  }
>>  
>> +static inline bool esr_fsc_is_tlb_conflict_abort(unsigned long esr)
>> +{
>> +	esr = esr & ESR_ELx_FSC;
>> +
>> +	return esr == ESR_ELx_FSC_TLBABT;
>> +}
>> +
>>  /* Indicate whether ESR.EC==0x1A is for an ERETAx instruction */
>>  static inline bool esr_iss_is_eretax(unsigned long esr)
>>  {
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index c9d46ad57e52..c8c6f5a97a1b 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1756,6 +1756,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>  	ipa = fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
>>  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>>  
>> +	if (esr_fsc_is_tlb_conflict_abort(esr)) {
>> +		// does a `tlbi vmalls12e1is`
> 
> nit: this isn't a very useful comment.
> 
>> +		__kvm_tlb_flush_vmid(&vcpu->kvm->arch.mmu);
>> +		return 1;
>> +	}
> 
> That's not enough, unfortunately. A nested VM has *many* VMIDs (the
> flattening of all translation contexts that the guest uses).
> 
> So you can either iterate over all the valid VMIDs owned by this
> guest, or more simply issue a TLBI ALLE1, which will do the trick in a
> much more efficient way.
> 
> The other thing is that you are using an IS invalidation, which is
> farther reaching than necessary. Why would you invalidate the TLBs for
> CPUs that are only innocent bystanders? A non-shareable invalidation
> seems preferable to me.
> 
>> +
>>  	if (esr_fsc_is_translation_fault(esr)) {
>>  		/* Beyond sanitised PARange (which is the IPA limit) */
>>  		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
> 
> But it also begs the question: why only KVM, and not the host? This
> handler will only take effect for a TLB Conflict abort delivered from
> an EL1 guest to EL2.

Hi Marc,

I believe the intent of this patch is to protect the host/KVM against a guest
that is using BBML2. The host/KVM always assumes BBML0 and therefore doesn't do
any operations that are allowed by the arch to cause a conflict abort. Therefore
the host doesn't need to handle it. But a guest could be taking advantage of
BBML2 and therefore it's architiecturally possible for a conflict abort to be
raised to EL2. I think today that would take down the host?

So really I think this could be considered a stand-alone KVM hardening improvement?

> 
> However, it doesn't seem to me that the host is equipped to deal with
> this sort of exception for itself. Shouldn't you start with that?

If the host isn't doing any BBML2 operations it doesn't need to handle it, I
don't think? Obviously that changes later in the series and Miko is adding the
required handling to the host.

Thanks,
Ryan

> 
> Thanks,
> 
> 	M.
> 

