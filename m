From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v3 2/5] arm64: Work around Falkor erratum 1003
Date: Tue, 24 Jan 2017 09:54:44 -0500
Message-ID: <abe718b7-c832-7748-f043-f9a62d0dd1e4@codeaurora.org>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-2-cov@codeaurora.org>
 <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
Sender: linux-doc-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Jon Masters <jcm@redhat.com>, Mark Langsdorf <mlangsdo@redhat.com>, Mark Salter <msalter@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Catalin,

On 01/11/2017 01:06 PM, Catalin Marinas wrote:
> Some minor comments below, nothing fundamental (as long as you say the
> new sequence doesn't have the speculative TLB load problem I mentioned
> on a previous version).

This workaround is documented as providing functional correctness for
both explicit and speculative memory accesses.

>> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
>> index 32682be..9ee46df 100644
>> --- a/arch/arm64/mm/proc.S
>> +++ b/arch/arm64/mm/proc.S
>> @@ -23,6 +23,7 @@
>>  #include <asm/assembler.h>
>>  #include <asm/asm-offsets.h>
>>  #include <asm/hwcap.h>
>> +#include <asm/mmu_context.h>
>>  #include <asm/pgtable.h>
>>  #include <asm/pgtable-hwdef.h>
>>  #include <asm/cpufeature.h>
>> @@ -140,6 +141,18 @@ ENDPROC(cpu_do_resume)
>>  ENTRY(cpu_do_switch_mm)
>>  	mmid	x1, x1				// get mm->context.id
>>  	bfi	x0, x1, #48, #16		// set the ASID
>> +#ifdef CONFIG_QCOM_FALKOR_ERRATUM_1003
>> +alternative_if ARM64_WORKAROUND_QCOM_FALKOR_E1003
>> +	mrs     x2, ttbr0_el1
>> +	mov     x3, #FALKOR_RESERVED_ASID
>> +	bfi     x2, x3, #48, #16                // reserved ASID + old BADDR
>> +	msr     ttbr0_el1, x2
>> +	isb
>> +	bfi     x2, x0, #0, #48                 // reserved ASID + new BADDR
>> +	msr     ttbr0_el1, x2
>> +	isb
>> +alternative_else_nop_endif
>> +#endif
>>  	msr	ttbr0_el1, x0			// set TTBR0
>>  	isb
>>  	post_ttbr0_update_workaround
> 
> Please move the above hunk to a pre_ttbr0_update_workaround macro for
> consistency with post_ttbr0_update_workaround.

How should I deal with inputs to the macro?

A) Use no input parameters and hard code x0 usage
B) Use a macro input parameter for the new TTBR value (x0)
C) Something else

Thanks,
Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
