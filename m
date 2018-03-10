From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH] arm64: KVM: Use SMCCC_ARCH_WORKAROUND_1 for Falkor BP
 hardening
Date: Sat, 10 Mar 2018 12:25:43 -0600
Message-ID: <e0c6d403-beab-395b-ae19-766deeb867aa@codeaurora.org>
References: <1520027418-10646-1-git-send-email-shankerd@codeaurora.org>
 <20180305155614.GG6618@arm.com>
 <05c25982-4939-593f-ad30-bf496e879885@codeaurora.org>
 <20180305171529.GA12869@arm.com>
 <770bb422-7a53-06b9-a136-4e38a0a4bed2@codeaurora.org>
 <20180306152540.GC18477@arm.com>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180306152540.GC18477@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Thomas Speier <tspeier@codeaurora.org>, Vikram Sethi <vikrams@codeaurora.org>, Sean Campbell <scampbel@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

On 03/06/2018 09:25 AM, Will Deacon wrote:
> On Mon, Mar 05, 2018 at 12:03:33PM -0600, Shanker Donthineni wrote:
>> On 03/05/2018 11:15 AM, Will Deacon wrote:
>>> On Mon, Mar 05, 2018 at 10:57:58AM -0600, Shanker Donthineni wrote:
>>>> On 03/05/2018 09:56 AM, Will Deacon wrote:
>>>>> On Fri, Mar 02, 2018 at 03:50:18PM -0600, Shanker Donthineni wrote:
>>>>>> @@ -199,33 +208,15 @@ static int enable_smccc_arch_workaround_1(void *data)
>>>>>>  		return 0;
>>>>>>  	}
>>>>>>  
>>>>>> +	if (((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR) ||
>>>>>> +	    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1))
>>>>>> +		cb = qcom_link_stack_sanitization;
>>>>>
>>>>> Is this just a performance thing? Do you actually see an advantage over
>>>>> always making the firmware call? We've seen minimal impact in our testing.
>>>>>
>>>>
>>>> Yes, we've couple of advantages using the standard SMCCC_ARCH_WOKAROUND_1 framework. 
>>>>   - Improves the code readability.
>>>>   - Avoid the unnecessary MIDR checks on each vCPU exit.
>>>>   - Validates ID_AA64PFR0_CVS2 feature for Falkor chips.
>>>>   - Avoids the 2nd link stack sanitization workaround in firmware.
>>>
>>> What I mean is, can we drop qcom_link_stack_sanitization altogether and
>>> use the SMCCC interface for everything?
>>>
>>
>> No, We would like to keep it qcom_link_stack_sanitization for host kernel
>> since it takes a few CPU cycles instead of heavyweight SMCCC call.
> 
> Is that something that you can actually measure in the workloads and
> benchmarks that you care about? If so, fine, but that doesn't seem to be the
> case for the Cortex cores we've looked at internally and it would be nice to
> avoid having different workarounds in the kernel just because the SMCCC
> interface wasn't baked in time, rather than because there's a meaningful
> performance difference.
>

We've seen noticeable performance improvement with the microbench workloads,
ans also some of our customers have observed improvements on heavy workloads. 
Unfortunately I can't share those specific results here. SMCCC call overhead 
is much higher as compared to link stack workaround on Falkor, ~99X.

Host kernel workaround takes less than ~20 CPU cycles, whereas SMCCC_ARCH_WOKAROUND_1
consumes thousands of CPU cycles to sanitize the branch prediction on Falkor.  

Especially workloads inside virtual machines provides much better results because
no KVM involvement is required whenever guest calls qcom_link_stack_sanitization().            
 
> Will
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
