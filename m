Return-Path: <SRS0=r+CV=5K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E768C43331
	for <kvmarm@archiver.kernel.org>; Wed, 25 Mar 2020 11:28:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11E9C20772
	for <kvmarm@archiver.kernel.org>; Wed, 25 Mar 2020 11:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1bwUEUqj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11E9C20772
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9D014B092;
	Wed, 25 Mar 2020 07:28:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Au5I4WimX6tk; Wed, 25 Mar 2020 07:28:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B9B74B099;
	Wed, 25 Mar 2020 07:28:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 887E64B092
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 07:28:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u-a6OvE6xRdI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2020 07:28:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A5854A4C0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 07:28:06 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2A45D20775;
 Wed, 25 Mar 2020 11:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1585135685;
 bh=BHTyMXxT7R8s+L2COQD3ZAPpvsUWEcKjOljLSm0Wu3A=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=1bwUEUqjm9b6Mu/q9P+ajsOvu8VDv0nzyoM8tr0rAOdb3wfxf8xV6I1bG+QkYdolU
 YSaXl0Qj0TcdTgpWBURD98tmoz+quFnMkGo4VZOE7xJYVAF/x7xnDnGnM6Gkj13Tcj
 6CNsTSaqH9S+u4kijUyZl5p+ocWanrS9G41Dtdts=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jH4CZ-00FYAH-Fv; Wed, 25 Mar 2020 11:28:03 +0000
MIME-Version: 1.0
Date: Wed, 25 Mar 2020 11:28:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zhenyu Ye <yezhenyu2@huawei.com>
Subject: Re: [PATCH v2 67/94] arm64: Add level-hinted TLB invalidation helper
In-Reply-To: <b4120382-d175-0c2f-249e-cc77a09709db@huawei.com>
References: <20200211174938.27809-1-maz@kernel.org>
 <20200211174938.27809-68-maz@kernel.org>
 <b4120382-d175-0c2f-249e-cc77a09709db@huawei.com>
Message-ID: <ff18c6737eed7baa29adee5de4f044c5@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yezhenyu2@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, suzuki.poulose@arm.com,
 andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com,
 james.morse@arm.com, alexandru.elisei@arm.com, jintack@cs.columbia.edu,
 julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Zhenyu,

On 2020-03-25 10:38, Zhenyu Ye wrote:
> Hi Marc,
> 
> On 2020/2/12 1:49, Marc Zyngier wrote:
>> Add a level-hinted TLB invalidation helper that only gets used if
>> ARMv8.4-TTL gets detected.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/include/asm/tlbflush.h | 30 ++++++++++++++++++++++++++++++
>>  1 file changed, 30 insertions(+)
>> 
>> diff --git a/arch/arm64/include/asm/tlbflush.h 
>> b/arch/arm64/include/asm/tlbflush.h
>> index bc3949064725..a3f70778a325 100644
>> --- a/arch/arm64/include/asm/tlbflush.h
>> +++ b/arch/arm64/include/asm/tlbflush.h
>> @@ -10,6 +10,7 @@
>> 
>>  #ifndef __ASSEMBLY__
>> 
>> +#include <linux/bitfield.h>
>>  #include <linux/mm_types.h>
>>  #include <linux/sched.h>
>>  #include <asm/cputype.h>
>> @@ -59,6 +60,35 @@
>>  		__ta;						\
>>  	})
>> 
>> +#define TLBI_TTL_MASK	GENMASK_ULL(47, 44)
>> +
>> +#define __tlbi_level(op, addr, level)					\
>> +	do {								\
>> +		u64 arg = addr;						\
>> +									\
>> +		if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) &&	\
>> +		    level) {						\
>> +			u64 ttl = level;				\
>> +									\
>> +			switch (PAGE_SIZE) {				\
>> +			case SZ_4K:					\
>> +				ttl |= 1 << 2;				\
>> +				break;					\
>> +			case SZ_16K:					\
>> +				ttl |= 2 << 2;				\
>> +				break;					\
>> +			case SZ_64K:					\
>> +				ttl |= 3 << 2;				\
>> +				break;					\
>> +			}						\
> 
> Can we define a macro here to replace the switch? It will be more
> clearly and efficient. Such as:
> 
> #define __TG ((PAGE_SHIFT - 12) / 2 + 1)
> ttl |= __TG << 2;

Let me rephrase this: a convoluted formula with magic numbers in it
is clearer than the values documented in the specification (Table 
D5-53)?
I have the exact opposite view.

As for efficency, you do realize that the compiler always discards two 
third
of this code on any possible configuration, right?

I think the code above is the clearest way to express table D5-53, and
the only missing bit is a reference to that table.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
