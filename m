Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A2B311975
	for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 09:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761731352; cv=none; b=JmQXzCP3ROJMLQj0oSy+ACMsKmgbdaQeQYOKpW10odbsMic9PbzHLZ+pEyY8CPqWysaYEah3vqckXA7Q4EO2fiv0RHuz1wrTc024WNAVwTgBJgRa+OjM5HEtiK2MsJ0+IMSRKWhDAj9AqvkiEdkTJIDuuJdEH7l/rf8LWTBhGY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761731352; c=relaxed/simple;
	bh=Rx6T/2ZiVqtM8p1WOZ5s4RFLxTBoy7M4bJuEZ03wm2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DbEh4EIuObhs2lNSjkwHmd4euNHc9Ykpm2ihNjW8fvpqpcu5XdJRmwjEj64IJk/PQUu+9VKKfwOpt1TNaioAs9wonz/rjq+m9KNPNmEgE4xvsCg5E5Eu1KaCmYign7/NCisp0JrM5EBBZuBEbuHKI7nX74rFoQRIEih8BtQbGcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20F561AC1;
	Wed, 29 Oct 2025 02:49:00 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E22E53F673;
	Wed, 29 Oct 2025 02:49:05 -0700 (PDT)
Message-ID: <61e923d6-388b-4cc6-8c26-5581a1e1cc10@arm.com>
Date: Wed, 29 Oct 2025 09:49:04 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: arm64: support optional calls of FF-A v1.2
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, perlarsen@google.com, ayrton@google.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20251027191729.1704744-1-yeoreum.yun@arm.com>
 <20251027191729.1704744-3-yeoreum.yun@arm.com>
 <f5aa3c19-fdea-4f62-9541-530e59b20a87@arm.com>
 <aQEwVe8+okm/Nmso@e129823.arm.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <aQEwVe8+okm/Nmso@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Levi,

On 10/28/25 21:06, Yeoreum Yun wrote:
> Hi Ben,
> 
>>> To use TPM drvier which uses CRB over FF-A with FFA_DIRECT_REQ2,
>>> support the FF-A v1.2's optinal calls by querying whether
>>> SPMC supports those.
>>>
>>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>>> ---
>>>  arch/arm64/kvm/hyp/nvhe/ffa.c | 19 ++++++++++++++++++-
>>>  1 file changed, 18 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
>>> index 0ae87ff61758..9ded1c6369b9 100644
>>> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
>>> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
>>> @@ -646,6 +646,22 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
>>>  		ffa_to_smccc_res(res, ret);
>>>  }
>>>
>>> +static bool ffa_1_2_optional_calls_supported(u64 func_id)
>>> +{
>>> +	struct arm_smccc_1_2_regs res;
>>> +
>>> +	if (!smp_load_acquire(&has_version_negotiated) ||
>>> +		(FFA_MINOR_VERSION(FFA_VERSION_1_2) < 2))
>>> +		return false;
>>> +
>>> +	arm_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
>>> +		.a0 = FFA_FEATURES,
>>> +		.a1 = func_id,
>>> +	}, &res);
>>> +
>>> +	return res.a0 == FFA_SUCCESS;
>>> +}
>>> +
>>>  /*
>>>   * Is a given FFA function supported, either by forwarding on directly
>>>   * or by handling at EL2?
>>> @@ -678,12 +694,13 @@ static bool ffa_call_supported(u64 func_id)
>>>  	case FFA_NOTIFICATION_SET:
>>>  	case FFA_NOTIFICATION_GET:
>>>  	case FFA_NOTIFICATION_INFO_GET:
>>> +		return false;
>>>  	/* Optional interfaces added in FF-A 1.2 */
>>>  	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
>>>  	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
>>>  	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
>>
>> Looking at table 13.54 in the FF-A 1.2 spec FFA_CONSOLE_LOG is only supported in secure FF-A
>> instances and not from the normal world.
> 
> Thanks. in that case, we can return false for FFA_CONSOLE_LOG
> unconditionally.
> 
>>
>>>  	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
>>> -		return false;
>>> +		return ffa_1_2_optional_calls_supported(func_id);
>>>  	}
>>
>> I don't think that an smc call here is the right thing to do. This changes this from a light
>> weight deny list to an extra smc call for each ffa_msg_send_direct_req2 from the driver.
>>
>> Instead, I would expect this patch just to remove FFA_MSG_SEND_DIRECT_REQ2 from the deny list
>> and rely on the TPM driver to use FFA_FEATURES to check whether it's supported.
>>
>> So, just this change:
>>
>> @@ -679,7 +679,6 @@ static bool ffa_call_supported(u64 func_id)
>>         case FFA_NOTIFICATION_GET:
>>         case FFA_NOTIFICATION_INFO_GET:
>>         /* Optional interfaces added in FF-A 1.2 */
>> -       case FFA_MSG_SEND_DIRECT_REQ2:          /* Optional per 7.5.1 */
>>         case FFA_MSG_SEND_DIRECT_RESP2:         /* Optional per 7.5.1 */
>>         case FFA_CONSOLE_LOG:                   /* Optional per 13.1: not in Table 13.1 */
>>         case FFA_PARTITION_INFO_GET_REGS:       /* Optional for virtual instances per 13.1 */
>>
>> Am I missing something?
> 
> Nope. I think you don't think you miss anything and
> I also think about it.
> 
> But, I'm not sure about "support" means in the pkvm about FF-A.
> Anyway unless the SPMC doesn't support the specific FF-A ABI,
> I don't know that's meaningful to return "TRUE" in here.
> IOW, suppose pkvm returns supports of  FFA_MSG_SEND_DIRECT_REQ2
> but user receive when it calls FFA_MSG_SEND_DIRECT_REQ2 with NOT SUPPORTED.

As I understand it, the ffa_call_supported() is used in two places:
1. To return NOT SUPPORTED to an FFA_FEATURE call for ffa calls that are
on the deny list.
2. To block ffa calls if they are on the deny list.

For both your patch and just removing FFA_MSG_SEND_DIRECT_REQ2 from the
denylist I think the behaviour is the same.

If FFA_MSG_SEND_DIRECT_REQ2 is not supported at the spmc then:
a) an FFA_FEATURE call will return not supported
b) an FFA_MSG_SEND_DIRECT_REQ2 will return not supported

> 
> I'm not sure this inconsistency is allowed or not so as a defensive
> perspective.
> 
> If that allows, I don't have a any special comment for this.
> 
> Thanks!
> 
> --
> Sincerely,
> Yeoreum Yun

-- 
Thanks,

Ben

