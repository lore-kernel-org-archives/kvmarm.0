From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 11/21] arm64: cpufeature: Detect CPU RAS Extentions
Date: Thu, 02 Nov 2017 12:15:50 +0000
Message-ID: <59FB0C76.2000608@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-12-james.morse@arm.com> <20171031131403.GJ5584@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91B8140795
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 08:15:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lPCXGjmD0RKk for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Nov 2017 08:15:55 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6363B406D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 08:15:55 -0400 (EDT)
In-Reply-To: <20171031131403.GJ5584@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

On 31/10/17 13:14, Will Deacon wrote:
> On Thu, Oct 19, 2017 at 03:57:57PM +0100, James Morse wrote:
>> From: Xie XiuQi <xiexiuqi@huawei.com>
>>
>> ARM's v8.2 Extentions add support for Reliability, Availability and
>> Serviceability (RAS). On CPUs with these extensions system software
>> can use additional barriers to isolate errors and determine if faults
>> are pending.
>>
>> Add cpufeature detection and a barrier in the context-switch code.
>> There is no need to use alternatives for this as CPUs that don't
>> support this feature will treat the instruction as a nop.
>>
>> Platform level RAS support may require additional firmware support.

>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index cd52d365d1f0..0fc017b55cb1 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -125,6 +125,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
>>  };
>>  
>>  static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64PFR0_RAS_SHIFT, 4, 0),

> We probably want FTR_LOWER_SAFE here now, right? (we changed the other
> fields in for-next/core).

Ah, yes.
(Looks like some copy-and-paste)


>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>> index 2dc0f8482210..5e5d2f0a1d0a 100644
>> --- a/arch/arm64/kernel/process.c
>> +++ b/arch/arm64/kernel/process.c
>> @@ -365,6 +365,9 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
>>  	 */
>>  	dsb(ish);
>>  
>> +	/* Deliver any pending SError from prev */
>> +	esb();

> I'm assuming this is going to be expensive.

I'm hoping not, but without numbers to prove otherwise...


> What if we moved it to switch_mm
> instead. Do we actually need thread granularity for error isolation?

(after a verbal discussion with Will:)

This would be needed to blame the correct thread, but until we have kernel-first
handling this is moot as do_serror() will panic() regardless.

So, lets drop the esb() here and decide what to do if/when we get kernel-first
handling. If that only acts on groups of threads, then switch_mm is a better
place for it.

In the meantime if we see RAS SError panic()s we should remember it may have
just switched task, which in practice will probably be obvious from the stack trace.

There is no firmware-first angle here as SError is unmasked either side of this,
unlike in the KVM example.

I'll apply the same logic to the KVM version in patch 20...



Thanks,

James
