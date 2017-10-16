From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v3 16/28] arm64/sve: Probe SVE capabilities and usable
 vector lengths
Date: Mon, 16 Oct 2017 17:47:16 +0100
Message-ID: <7854a2cc-d3b1-ac76-8d12-2aa5e1be7aca@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-17-git-send-email-Dave.Martin@arm.com>
 <a39354fb-9f21-47ff-2ad9-b5bcb04e9990@arm.com>
 <20171016154557.GR19485@e103592.cambridge.arm.com>
 <812b6d11-2458-6d5d-c490-3421f7d3afb3@arm.com>
 <20171016164407.GS19485@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 598CB41185
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 12:46:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eWNC50qM14E6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 12:46:26 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B69240EA6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 12:46:26 -0400 (EDT)
In-Reply-To: <20171016164407.GS19485@e103592.cambridge.arm.com>
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
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/10/17 17:44, Dave Martin wrote:
> On Mon, Oct 16, 2017 at 05:27:59PM +0100, Suzuki K Poulose wrote:
>> On 16/10/17 16:46, Dave Martin wrote:
>>> On Thu, Oct 12, 2017 at 01:56:51PM +0100, Suzuki K Poulose wrote:
>>>> On 10/10/17 19:38, Dave Martin wrote:
> 
> [...]
> 
>>>>> @@ -670,6 +689,14 @@ void update_cpu_features(int cpu,
>>>>>   					info->reg_mvfr2, boot->reg_mvfr2);
>>>>>   	}
>>>>> +	if (id_aa64pfr0_sve(info->reg_id_aa64pfr0)) {
>>>>> +		taint |= check_update_ftr_reg(SYS_ZCR_EL1, cpu,
>>>>> +					info->reg_zcr, boot->reg_zcr);
>>>>> +
>>>>> +		if (!sys_caps_initialised)
>>>>> +			sve_update_vq_map();
>>>>> +	}
>>>>
>>>> nit: I am not sure if we should also check if the "current" sanitised value
>>>> of the id_aa64pfr0 also supports sve and skip the update if it isn't. The code
>>>> is as such fine without the check, its just that we can avoid computing the
>>>> map. It is in the CPU boot up path and hence is not performance critical.
>>>> So, either way we are fine.
>>>>
>>>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>
>>> I think I prefer to avoid adding extra code to optimise the "broken SoC
>>> design" case.
>>>
>>
>> Sure.
>>
>>> Maybe we could revisit this later if needed.
>>>
>>> Can you suggest some code?  Maybe the check is simpler than I think.
>>
>> Something like :
>>
>> if (id_aa64pfr0_sve(read_sanitised_ftr_reg(SYS_IDAA64PFR0)) &&
>>      id_aa64pfr0_sve(id_aa64pfr0)) {
>>      ...
>> }
>>
>> should be enough.
>>
>> Or even we could hack it to :
>>
>> if (id_aa64pfr0_sve(id_aa64pfr0 | read_sanitised_ftr_reg(SYS_IDAA64PFR0)))
>>
>> As I mentioned, the code as such is fine. Its just that we try to detect
>> if the SVE is already moot and skip the steps for this CPU.
> 
> How about the following, keeping the outer
> if(id_aa64pfr0_sve(int->reg_id_aa64pfr0)) from my current code:
> 
> -		if (!sys_caps_initialised)
> +		/* Probe vector lengths, unless we already gave up on SVE */
> +		if (id_aa64pfr0_sve(read_sanitised_ftr_reg(ID_AA64PFR0_SVE)) &&
> +		    !sys_caps_initialised)
> 			sve_update_vq_map();

Yep, that looks neater.

Cheers
Suzuki
