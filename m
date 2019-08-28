Return-Path: <SRS0=VgM6=WY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 286DFC3A5A1
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 15:46:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B1C4A2070B
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 15:46:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1C4A2070B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE2894A588;
	Wed, 28 Aug 2019 11:46:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qhysz+E2Sk0v; Wed, 28 Aug 2019 11:46:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8ECC4A56E;
	Wed, 28 Aug 2019 11:46:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDB784A54B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 11:46:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HXoZwfB8EkLC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Aug 2019 11:46:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD8EC4A52B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 11:46:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3365128;
 Wed, 28 Aug 2019 08:46:06 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 213FF3F59C;
 Wed, 28 Aug 2019 08:46:05 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH 10/16] lib: Add UL and ULL definitions
 to linux/const.h
To: Andrew Jones <drjones@redhat.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-11-git-send-email-alexandru.elisei@arm.com>
 <20190828151006.x6bfxlseqp5s55su@kamzik.brq.redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <c476a2cc-98d7-6315-a742-df252ff56be5@arm.com>
Date: Wed, 28 Aug 2019 16:46:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190828151006.x6bfxlseqp5s55su@kamzik.brq.redhat.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, maz@kernel.org, andre.przywara@arm.com,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On 8/28/19 4:10 PM, Andrew Jones wrote:
> On Wed, Aug 28, 2019 at 02:38:25PM +0100, Alexandru Elisei wrote:
>> The UL macro was previously defined in lib/arm64/asm/pgtable-hwdef.h. Move
>> it to lib/linux/const.h so it can be used in other files. To keep things
>> consistent, also add an ULL macro.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/linux/const.h             | 7 +++++--
>>  lib/arm64/asm/pgtable-hwdef.h | 2 --
>>  2 files changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/lib/linux/const.h b/lib/linux/const.h
>> index c872bfd25e13..e3c7fec3f4b8 100644
>> --- a/lib/linux/const.h
>> +++ b/lib/linux/const.h
>> @@ -21,7 +21,10 @@
>>  #define _AT(T,X)	((T)(X))
>>  #endif
>>  
>> -#define _BITUL(x)	(_AC(1,UL) << (x))
>> -#define _BITULL(x)	(_AC(1,ULL) << (x))
>> +#define UL(x) 		_AC(x, UL)
>> +#define ULL(x)		_AC(x, ULL)
>> +
>> +#define _BITUL(x)	(UL(1) << (x))
>> +#define _BITULL(x)	(ULL(1) << (x))
> I don't mind this, but if we want to keep this file consistent with
> Linux's include/uapi/linux/const.h, which is actually the goal, then we
> should be adding _UL and _ULL instead. But in that case we'd probably
> want to leave the define below.
>
> Thanks,
> drew

Hm... The next patch needs the UL define. Consistency is good, so if we want to
keep it consistent with include/uapi/linux/const.h, then I will change the
defines (and the uses) to _UL and _ULL, if that's fine with you.

Thanks,
Alex
>
>>  
>>  #endif /* !(_LINUX_CONST_H) */
>> diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
>> index 045a3ce12645..e6f02fae4075 100644
>> --- a/lib/arm64/asm/pgtable-hwdef.h
>> +++ b/lib/arm64/asm/pgtable-hwdef.h
>> @@ -9,8 +9,6 @@
>>   * This work is licensed under the terms of the GNU GPL, version 2.
>>   */
>>  
>> -#define UL(x) _AC(x, UL)
>> -
>>  #define PTRS_PER_PTE		(1 << (PAGE_SHIFT - 3))
>>  
>>  /*
>> -- 
>> 2.7.4
>>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
