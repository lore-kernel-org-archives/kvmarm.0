From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH 5/7] arm64: Do not apply BP hardening for hyp entries from
 EL2
Date: Thu, 8 Nov 2018 12:23:06 +0000
Message-ID: <36b8c11d-345a-efd5-c3e0-9b6284c16e87@arm.com>
References: <1537970184-44348-1-git-send-email-julien.thierry@arm.com>
 <1537970184-44348-6-git-send-email-julien.thierry@arm.com>
 <20181107215918.GG12248@brain-police>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C68E4A339
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Nov 2018 07:23:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NhQLpTk+2nfP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Nov 2018 07:23:10 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 325574A2B7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Nov 2018 07:23:10 -0500 (EST)
In-Reply-To: <20181107215918.GG12248@brain-police>
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
To: Will Deacon <will.deacon@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, Dave.Martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 07/11/18 21:59, Will Deacon wrote:
> On Wed, Sep 26, 2018 at 02:56:22PM +0100, Julien Thierry wrote:
>> When an EL2 entry of __kvm_hyp_vector is taken, it means an entry from a
>> lower EL was previously taken to exit the guest. Taking that lower EL entry
>> already applied BP hardening if it was needed, so there is no need to do
>> it again.
>>
>> Only apply BP hardening for exception coming from lower EL.
>>
>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> ---
>>   arch/arm64/kernel/cpu_errata.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
>> index dec1089..9db5ecc 100644
>> --- a/arch/arm64/kernel/cpu_errata.c
>> +++ b/arch/arm64/kernel/cpu_errata.c
>> @@ -103,10 +103,16 @@ static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
>>   	void *dst = lm_alias(__bp_harden_hyp_vecs_start + slot * SZ_2K);
>>   	int i;
>>
>> -	for (i = 0; i < SZ_2K; i += 0x80)
>> +	/*
>> +	 * Only overwrite hyp entries for exceptions from lower EL.
>> +	 * Exception vection vector is 2K bytes, first 1K bytes concern
>> +	 * exception from EL2 (EL2t, EL2h), last 1K concert lower exception
>> +	 * levels (ELx-64bits, ELx-32bits).
>> +	 */
>> +	for (i = SZ_1K; i < SZ_2K; i += 0x80)
>>   		memcpy(dst + i, hyp_vecs_start, hyp_vecs_end - hyp_vecs_start);
>>
>> -	__flush_icache_range((uintptr_t)dst, (uintptr_t)dst + SZ_2K);
>> +	__flush_icache_range((uintptr_t)dst + SZ_1K, (uintptr_t)dst + SZ_2K);
>>   }
> 
> I'd personally find this clearer if you did:
> 
> 	dst += SZ_1K;
> 
> before the for loop and with your comment above it. Then the for loop
> becomes:
> 
> 	for (i = 0; i < SZ_1K; i += 0x80)
> 
> and the range of the cache maintenance is [dst, dst + SZ_1K)
> > But I'll leave it up to Marc.
> 

I'd say I agree with your suggestion, so unless Marc finds it better in 
the current state, I'll make the change.

Thanks,

-- 
Julien Thierry
