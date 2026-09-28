Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418234718CD;
	Mon, 28 Sep 2026 20:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790628316; cv=none; b=cCo5bYRD+bcf4gZhwy6w+3l9hyXRqweEQZdQ1kXftdTI5ccCW3ClibEIXJLMNZczPWTKYK9lzjI50lZ/7NqsMW/bNz5yZXVFQOmbe8OUVVRwHkCiz0mQ8CfRRDNtqQsRttaiAeUh0JHF3of7Dt3JWNEcLB6ZPW0rXwDhG4LbTgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790628316; c=relaxed/simple;
	bh=q3ymddfKsVAKQWNUPXauWVOAcmdD5YRNNwwxgzCd4vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GNghdcSZL1wrsjLx4LJq8WuiymI8+Sw16jYopOs0foC1Wtlx3QbnY3Ts/q32QtmzqohqHD4CYtNoPjOOQ9ROfCjJLCLwzWKHn1mM1zIOnXxnIw/pI9F2MJ55HLSQ0/wuubPSL4i4N/RgeI2Bi2goCRs06fQrZVcFtkqiQrwkzAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rPsWJTdH; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rPsWJTdH"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E50561655;
	Mon, 28 Sep 2026 13:45:08 -0700 (PDT)
Received: from [10.57.12.116] (unknown [10.57.12.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 163EE3F85F;
	Mon, 28 Sep 2026 13:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790628312; bh=q3ymddfKsVAKQWNUPXauWVOAcmdD5YRNNwwxgzCd4vs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rPsWJTdHtfeoSv63FKbVWp6r/f6MdBhvi6ZFbp/p2Hc3/eOOqY8YEphTKGLHDVetq
	 5dhvX0KNDtvzOcGdeSE3M+QKTvkTFsO4sxlyggHDGR78MGWVtd1waFCXwbHJN4zUsq
	 XhDoPna624LOFusYX3QvVQE3gR8KYNY4u+FIBD2g=
Message-ID: <f4210a04-d1d1-4ce0-9ca0-7c662e10665b@arm.com>
Date: Mon, 28 Sep 2026 21:45:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 4/7] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
 Gareth Stockwell <Gareth.Stockwell@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-5-suzuki.poulose@arm.com> <arozNIQ-fQ0XQViI@arm.com>
 <4fabad44-280f-40e6-95bb-49011cd2f185@arm.com> <arqjteW-Y5u2XX2r@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <arqjteW-Y5u2XX2r@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28/09/2026 18:28, Catalin Marinas wrote:
> On Mon, Sep 28, 2026 at 11:13:39AM +0100, Suzuki K Poulose wrote:
>> On 28/09/2026 10:28, Catalin Marinas wrote:
>>> On Thu, Sep 24, 2026 at 02:51:58PM +0100, Suzuki K Poulose wrote:
>>>> +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
>>>> +{
>>>> +	struct arm_smccc_1_2_regs *regs = &sro->regs;
>>>> +	bool cancelled = false;
>>>> +	unsigned long sro_handle;
>>>> +
>>>> +	rmi_smccc_invoke(regs);
>>>> +
>>>> +	sro_handle = regs->a1;
>>>> +	while (RMI_RESULT_STATUS(regs->a0) == RMI_INCOMPLETE) {
>>>> +		bool can_cancel = RMI_RESULT_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
>>>> +		int ret = 0;
>>>> +
>>>> +		switch (RMI_RESULT_MEMREQ(regs->a0)) {
>>>> +		case RMI_OP_MEM_REQ_NONE:
>>>> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
>>>> +					regs);
>>>> +			break;
>>>> +		case RMI_OP_MEM_REQ_DONATE:
>>>> +			ret = rmi_sro_donate(sro, sro_handle, regs->a2, regs,
>>>> +					     gfp);
>>>> +			break;
>>>> +		case RMI_OP_MEM_REQ_RECLAIM:
>>>> +			ret = rmi_sro_reclaim(sro, sro_handle, regs);
>>>> +			break;
>>>> +		default:
>>>> +			WARN_ON_ONCE(1);
>>>> +			ret = -ENXIO;
>>>> +			break;
>>>> +		}
>>>
>>> Another thing I came across while looking whether we can defer the
>>> activation. It seems that the spec (I_JVYCH) lists some SROs as
>>> PE-bound. Nothing here or in rmi_sro_execute() disables migration and
>>> the memory allocation paths can even sleep with GFP_KERNEL.
>>
>> No, this is not required. I agree this is confusing. I will get it
>> clarified.
>>
>> So, there are two different sources for the SRO contexts. One is a global
>> pool and the other an Object.
>>
>> e.g., For an RMI operation on an Object, SRO context can be the object
>> itself (e.g., REC_CREATE, REALM_ACTIVATE etc.)
>>
>> However, when there is no reliable object for the command (e.g.,
>> RMI_GRANULE_RANGE_DELEGATE), the RMM must allocate a context from
>> the global pool. Now, the "PE" in there comes from a recommendation
>> to the RMM implementations, that the global pool size must depend on
>> the number of PEs on the system. This doesn't mean that the SRO
>> handles are only bound to those PEs. I will get this clarified
>> in the RMM spec.
> 
> This part of the spec needs rewriting, not clarifying. No matter how
> hard you try, there's no way you can read it as a "global pool". For
> example:
> 
> D_GZLMRA	SRO context is bound to one of the following:
> 		  - A PE
> 		  - An RMM object
> 
> And take a random command:
> 
> B4.5.2 RMI_DPT_L0_CREATE command
> 	Create a Level 0 DPT.
> 	The RMI_DPT_L0_CREATE command may initiate a Stateful RMI
> 	Operation whose context is bound to the current PE.
> 
> "bound to the current PE" pretty clearly shows the intention was to
> disable preemption. It also doesn't say what happens when this pool is
> exhausted (presumably it returns RMI_BLOCKED).

Agree. If there are not contexts available for the RMM to use, it
results in RMI_BLOCKED.
> 
> TBH, that's a pretty significant change for a bet3/4 release, though
> arguably it can be seen as a relaxation. Code that relies on disabling
> preemption should still work (somewhat, assuming the global pool is at
> least the number of PEs and the host plays nicely to complete or cancel
> all SROs).

The only case where the RMM mandates the execution continues on a "CPU"
(virtual PE rather) is Realm Attestation ABI exposed to the Realm 
(RSI_ATTEST_TOKEN_*).

Btw, SRO contexts are nothing but a "scratch" memory that the RMM uses
to hold the progress made in the SRO. e.g., the donated granules and
what is the next operation expected etc.


> 
> That said, such pool is a limited resource and we need some way to probe
> its size if we want to do something smarter in the kernel, like a
> semaphore to ensure we don't randomly fail because of an RMM limitation.
> I don't really see how the number of PEs is relevant to this global
> pool sizing, it's not that we limit the realms we can start to the
> online CPUs.

The number of PEs is only a factor which can tell the RMM, how many
parallel requests it could get. That said, due to pre-emption there
could be multiple outstanding SRO operations on a single PE. But
also remember that not all SROs require a context from global pool.

Agreed that it would good to probe the number of contexts available.
Or may be even dynamically extend the pool for SRO contexts at
runtime. Will feed this back to the RMM spec, and hopefully we can
address this in the future versions without breaking the existing
ABI.

Thanks
Suzuki




