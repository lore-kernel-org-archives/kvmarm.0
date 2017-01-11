From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 2/5] arm64: Work around Falkor erratum 1003
Date: Wed, 11 Jan 2017 18:22:08 +0000
Message-ID: <278a45c0-bd49-b8a2-63ae-80ad851bab9b@arm.com>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-2-cov@codeaurora.org>
 <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48DC4404E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 13:20:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6l3Nov7cmNe5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Jan 2017 13:20:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4997C40064
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 13:20:28 -0500 (EST)
In-Reply-To: <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Christopher Covington <cov@codeaurora.org>
Cc: Mark Langsdorf <mlangsdo@redhat.com>, linux-doc@vger.kernel.org, kvm@vger.kernel.org, Jon Masters <jcm@redhat.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 11/01/17 18:06, Catalin Marinas wrote:
> Some minor comments below, nothing fundamental (as long as you say the
> new sequence doesn't have the speculative TLB load problem I mentioned
> on a previous version).
> 
> On Wed, Jan 11, 2017 at 09:41:15AM -0500, Christopher Covington wrote:
>> diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
>> index 405da11..7151aed 100644
>> --- a/Documentation/arm64/silicon-errata.txt
>> +++ b/Documentation/arm64/silicon-errata.txt
>> @@ -42,24 +42,25 @@ file acts as a registry of software workarounds in the Linux Kernel and
>>  will be updated when new workarounds are committed and backported to
>>  stable kernels.
>>  
>> -| Implementor    | Component       | Erratum ID      | Kconfig                 |
>> -+----------------+-----------------+-----------------+-------------------------+
>> -| ARM            | Cortex-A53      | #826319         | ARM64_ERRATUM_826319    |
>> -| ARM            | Cortex-A53      | #827319         | ARM64_ERRATUM_827319    |
>> -| ARM            | Cortex-A53      | #824069         | ARM64_ERRATUM_824069    |
>> -| ARM            | Cortex-A53      | #819472         | ARM64_ERRATUM_819472    |
>> -| ARM            | Cortex-A53      | #845719         | ARM64_ERRATUM_845719    |
>> -| ARM            | Cortex-A53      | #843419         | ARM64_ERRATUM_843419    |
>> -| ARM            | Cortex-A57      | #832075         | ARM64_ERRATUM_832075    |
>> -| ARM            | Cortex-A57      | #852523         | N/A                     |
>> -| ARM            | Cortex-A57      | #834220         | ARM64_ERRATUM_834220    |
>> -| ARM            | Cortex-A72      | #853709         | N/A                     |
>> -| ARM            | MMU-500         | #841119,#826419 | N/A                     |
>> -|                |                 |                 |                         |
>> -| Cavium         | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375    |
>> -| Cavium         | ThunderX ITS    | #23144          | CAVIUM_ERRATUM_23144    |
>> -| Cavium         | ThunderX GICv3  | #23154          | CAVIUM_ERRATUM_23154    |
>> -| Cavium         | ThunderX Core   | #27456          | CAVIUM_ERRATUM_27456    |
>> -| Cavium         | ThunderX SMMUv2 | #27704          | N/A		       |
>> -|                |                 |                 |                         |
>> -| Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585     |
>> +| Implementor   | Component       | Erratum ID      | Kconfig                  |
>> ++---------------+-----------------+-----------------+--------------------------+
>> +| ARM           | Cortex-A53      | #826319         | ARM64_ERRATUM_826319     |
>> +| ARM           | Cortex-A53      | #827319         | ARM64_ERRATUM_827319     |
>> +| ARM           | Cortex-A53      | #824069         | ARM64_ERRATUM_824069     |
>> +| ARM           | Cortex-A53      | #819472         | ARM64_ERRATUM_819472     |
>> +| ARM           | Cortex-A53      | #845719         | ARM64_ERRATUM_845719     |
>> +| ARM           | Cortex-A53      | #843419         | ARM64_ERRATUM_843419     |
>> +| ARM           | Cortex-A57      | #832075         | ARM64_ERRATUM_832075     |
>> +| ARM           | Cortex-A57      | #852523         | N/A                      |
>> +| ARM           | Cortex-A57      | #834220         | ARM64_ERRATUM_834220     |
>> +| ARM           | Cortex-A72      | #853709         | N/A                      |
>> +| ARM           | MMU-500         | #841119,#826419 | N/A                      |
>> +|               |                 |                 |                          |
>> +| Cavium        | ThunderX ITS    | #22375, #24313  | CAVIUM_ERRATUM_22375     |
>> +| Cavium        | ThunderX ITS    | #23144          | CAVIUM_ERRATUM_23144     |
>> +| Cavium        | ThunderX GICv3  | #23154          | CAVIUM_ERRATUM_23154     |
>> +| Cavium        | ThunderX Core   | #27456          | CAVIUM_ERRATUM_27456     |
>> +| Cavium        | ThunderX SMMUv2 | #27704          | N/A                      |
>> +|               |                 |                 |                          |
>> +| Freescale/NXP | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585      |
>> +| Qualcomm      | Falkor v1       | E1003           | QCOM_FALKOR_ERRATUM_1003 |
> 
> Please don't change the "Implementor" column width, there is no point
> and it makes the patch harder to read (i.e. this hunk should only have
> one line).
> 
>> diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
>> index 4c63cb1..5a0a82a 100644
>> --- a/arch/arm64/mm/context.c
>> +++ b/arch/arm64/mm/context.c
>> @@ -87,6 +87,11 @@ static void flush_context(unsigned int cpu)
>>  	/* Update the list of reserved ASIDs and the ASID bitmap. */
>>  	bitmap_clear(asid_map, 0, NUM_USER_ASIDS);
>>  
>> +	/* Reserve ASID for Falkor erratum 1003 */
>> +	if (IS_ENABLED(CONFIG_QCOM_FALKOR_ERRATUM_1003) &&
>> +	    cpus_have_cap(ARM64_WORKAROUND_QCOM_FALKOR_E1003))
>> +		__set_bit(FALKOR_RESERVED_ASID, asid_map);
>> +
>>  	/*
>>  	 * Ensure the generation bump is observed before we xchg the
>>  	 * active_asids.
>> @@ -244,6 +249,11 @@ static int asids_init(void)
>>  		panic("Failed to allocate bitmap for %lu ASIDs\n",
>>  		      NUM_USER_ASIDS);
>>  
>> +	/* Reserve ASID for Falkor erratum 1003 */
>> +	if (IS_ENABLED(CONFIG_QCOM_FALKOR_ERRATUM_1003) &&
>> +	    cpus_have_cap(ARM64_WORKAROUND_QCOM_FALKOR_E1003))
>> +		__set_bit(FALKOR_RESERVED_ASID, asid_map);
>> +
>>  	pr_info("ASID allocator initialised with %lu entries\n", NUM_USER_ASIDS);
>>  	return 0;
>>  }
> 
> You could as well write a small static function in this file and call it
> twice.
> 
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

In which case (and also for consistency), should we add that pre_ttbr0
macro to entry.S, just before __uaccess_ttbr0_enable? It may not be
needed in the SW pan case, but it is probably worth entertaining the
idea that there may be something to do there...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
