Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39D0C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 16:22:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20C1464F33
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 16:22:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20C1464F33
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B2854B640;
	Mon, 15 Mar 2021 12:22:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VabJdlw9pCIW; Mon, 15 Mar 2021 12:22:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A9B64B5F1;
	Mon, 15 Mar 2021 12:22:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B1994B5DE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 12:22:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xibwA2s1xoaQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 12:22:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43D534B5CF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 12:22:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DBCD1FB;
 Mon, 15 Mar 2021 09:22:25 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 235C43F718;
 Mon, 15 Mar 2021 09:22:25 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/6] arm/arm64: Remove unnecessary ISB when
 doing dcache maintenance
To: Andrew Jones <drjones@redhat.com>
References: <20210227104201.14403-1-alexandru.elisei@arm.com>
 <20210227104201.14403-4-alexandru.elisei@arm.com>
 <20210312145950.whq7ofrhbklwhprx@kamzik.brq.redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <2b6cd31a-ae8d-0fd6-dc82-583d73f79a9b@arm.com>
Date: Mon, 15 Mar 2021 16:22:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210312145950.whq7ofrhbklwhprx@kamzik.brq.redhat.com>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Hi Drew,

On 3/12/21 2:59 PM, Andrew Jones wrote:
> On Sat, Feb 27, 2021 at 10:41:58AM +0000, Alexandru Elisei wrote:
>> The dcache_by_line_op macro executes a DSB to complete the cache
>> maintenance operations. According to ARM DDI 0487G.a, page B2-150:
>>
>> "In addition, no instruction that appears in program order after the DSB
>> instruction can alter any state of the system or perform any part of its
>> functionality until the DSB completes other than:
>>
>> - Being fetched from memory and decoded.
>> - Reading the general-purpose, SIMD and floating-point, Special-purpose, or
>>   System registers that are directly or indirectly read without causing
>>   side-effects."
>>
>> Similar definition for ARM in ARM DDI 0406C.d, page A3-150:
>>
>> "In addition, no instruction that appears in program order after the DSB
>> instruction can execute until the DSB completes."
>>
>> This means that we don't need the ISB to prevent reordering of the cache
>> maintenance instructions.
>>
>> We are also not doing icache maintenance, where an ISB would be required
>> for the PE to discard instructions speculated before the invalidation.
>>
>> In conclusion, the ISB is unnecessary, so remove it.
> Hi Alexandru,
>
> We can go ahead and take this patch, since you've written quite a
> convincing commit message, but in general I'd prefer we be overly cautious
> in our common code. We'd like to ensure we don't introduce difficult to
> debug issues there, and we don't care about optimizations, let alone
> micro-optimizations. Testing barrier needs to the letter of the spec is a
> good idea, but it's probably better to do that in the test cases.

You are correct, the intention of this patch was to do the minimum necessary to
ensure correctness.

Thank you for the explanation, I will keep this in mind for future patches.

Thanks,

Alex

>
> Thanks,
> drew
>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/cstart.S   | 1 -
>>  arm/cstart64.S | 1 -
>>  2 files changed, 2 deletions(-)
>>
>> diff --git a/arm/cstart.S b/arm/cstart.S
>> index 954748b00f64..2d62c1e6d40d 100644
>> --- a/arm/cstart.S
>> +++ b/arm/cstart.S
>> @@ -212,7 +212,6 @@ asm_mmu_disable:
>>  	ldr	r1, [r1]
>>  	sub	r1, r1, r0
>>  	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
>> -	isb
>>  
>>  	mov     pc, lr
>>  
>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>> index 046bd3914098..c1deff842f03 100644
>> --- a/arm/cstart64.S
>> +++ b/arm/cstart64.S
>> @@ -219,7 +219,6 @@ asm_mmu_disable:
>>  	ldr	x1, [x1, :lo12:__phys_end]
>>  	sub	x1, x1, x0
>>  	dcache_by_line_op civac, sy, x0, x1, x2, x3
>> -	isb
>>  
>>  	ret
>>  
>> -- 
>> 2.30.1
>>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
