From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: Work around Falkor erratum 1009
Date: Thu, 8 Dec 2016 11:35:34 +0000
Message-ID: <e7b4c7f5-a40b-58b2-acb0-ec973928fdb0@arm.com>
References: <20161207200028.4420-1-cov@codeaurora.org>
 <20161207200431.4587-1-cov@codeaurora.org> <20161208112042.GB706@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161208112042.GB706@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Christopher Covington <cov@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/16 11:20, Will Deacon wrote:
> On Wed, Dec 07, 2016 at 03:04:31PM -0500, Christopher Covington wrote:
>> From: Shanker Donthineni <shankerd@codeaurora.org>
>>
>> During a TLB invalidate sequence targeting the inner shareable
>> domain, Falkor may prematurely complete the DSB before all loads
>> and stores using the old translation are observed; instruction
>> fetches are not subject to the conditions of this erratum.
>>
>> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
>> ---
>>  arch/arm64/Kconfig                | 10 +++++++++
>>  arch/arm64/include/asm/cpucaps.h  |  3 ++-
>>  arch/arm64/include/asm/tlbflush.h | 43 +++++++++++++++++++++++++++++++++++++++
>>  arch/arm64/kernel/cpu_errata.c    |  7 +++++++
>>  arch/arm64/kvm/hyp/tlb.c          | 39 ++++++++++++++++++++++++++++++-----
>>  5 files changed, 96 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 1004a3d..125440f 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -485,6 +485,16 @@ config QCOM_FALKOR_ERRATUM_E1003
>>  
>>  	  If unsure, say Y.
>>  
>> +config QCOM_FALKOR_ERRATUM_E1009
>> +	bool "Falkor E1009: Prematurely complete a DSB after a TLBI"
>> +	default y
>> +	help
>> +	  Falkor CPU may prematurely complete a DSB following a TLBI xxIS
>> +	  invalidate maintenance operations. Repeat the TLBI operation one
>> +	  more time to fix the issue.
>> +
>> +	  If unsure, say Y.
> 
> Call me perverse, but I like this workaround. People often tend to screw
> up TLBI and DVM sync, but the IPI-based workaround is horribly invasive
> and fragile. Simply repeating the operation tends to be enough to make
> the chance of failure small enough to be acceptable.
> 
>> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
>> index cb6a8c2..5357d7f 100644
>> --- a/arch/arm64/include/asm/cpucaps.h
>> +++ b/arch/arm64/include/asm/cpucaps.h
>> @@ -35,7 +35,8 @@
>>  #define ARM64_HYP_OFFSET_LOW			14
>>  #define ARM64_MISMATCHED_CACHE_LINE_SIZE	15
>>  #define ARM64_WORKAROUND_QCOM_FALKOR_E1003	16
>> +#define ARM64_WORKAROUND_QCOM_FALKOR_E1009	17
> 
> Could you rename this to something like ARM64_WORKAROUND_REPEAT_TLBI, so
> that it could potentially be used by others?

And add a parameter to it so that we can generate multiple TLBIs,
depending on the level of brokenness? ;-)

	M.
-- 
Jazz is not dead. It just smells funny...
