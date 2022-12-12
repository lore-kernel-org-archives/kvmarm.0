Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34491C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 06:08:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B44F4BA59;
	Mon, 12 Dec 2022 01:08:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yMJFSSuheANn; Mon, 12 Dec 2022 01:08:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2124C4BA19;
	Mon, 12 Dec 2022 01:08:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBC454BA16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 01:08:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1oDrGjxCRW5F for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 01:08:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 487944B9BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 01:08:24 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C6031FB;
 Sun, 11 Dec 2022 22:09:04 -0800 (PST)
Received: from [10.162.43.6] (unknown [10.162.43.6])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1A4A3F71E;
 Sun, 11 Dec 2022 22:08:19 -0800 (PST)
Message-ID: <b6737780-1fec-4419-05e0-2f74d859b147@arm.com>
Date: Mon, 12 Dec 2022 11:38:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/1] KVM: arm64: PMU: Fix PMCR_EL0 reset value
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>, James Clark <james.clark@arm.com>
References: <20221209164446.1972014-1-james.clark@arm.com>
 <20221209164446.1972014-2-james.clark@arm.com> <Y5N3R+w3GF94hxHa@google.com>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <Y5N3R+w3GF94hxHa@google.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 12/9/22 23:28, Oliver Upton wrote:
> On Fri, Dec 09, 2022 at 04:44:46PM +0000, James Clark wrote:
>> ARMV8_PMU_PMCR_N_MASK is an unshifted value which results in the wrong
>> reset value for PMCR_EL0, so shift it to fix it.
> 
> That's just mean. *_MASK tends to be a shifted mask, although it would
> appear that asm/perf_event.h does not follow this convention. Fixing
> that would be nice (as I'm sure somebody else will get burned by this),
> but for the sake of an immediate fix:

New arch/arm64/tools/sysreg generates shifted i.e in place masks for register
fields. Once all these PMU registers move into arch/arm64/tools/sysreg, this
problem will be solved.

> 
>> This fixes the following error when running qemu:
>>
>>   $ qemu-system-aarch64 -cpu host -machine type=virt,accel=kvm -kernel ...
>>
>>   target/arm/helper.c:1813: pmevcntr_rawwrite: Assertion `counter < pmu_num_counters(env)' failed.
>>
>> Fixes: 292e8f149476 ("KVM: arm64: PMU: Simplify PMCR_EL0 reset handling")
>> Signed-off-by: James Clark <james.clark@arm.com>
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> --
> Thanks,
> Oliver
> 
>> ---
>>  arch/arm64/kvm/sys_regs.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index d5ee52d6bf73..c6cbfe6b854b 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -646,7 +646,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>>  		return;
>>  
>>  	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
>> -	pmcr = read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N_MASK;
>> +	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
>>  	if (!kvm_supports_32bit_el0())
>>  		pmcr |= ARMV8_PMU_PMCR_LC;
>>  
>> -- 
>> 2.25.1
>>
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
