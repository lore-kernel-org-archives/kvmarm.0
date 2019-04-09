Return-Path: <SRS0=N2lg=SL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182EFC10F0E
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 09:16:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 942DC20833
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 09:16:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 942DC20833
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF9384A476;
	Tue,  9 Apr 2019 05:16:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yZVSeZRkNXup; Tue,  9 Apr 2019 05:16:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D24F94A382;
	Tue,  9 Apr 2019 05:16:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D0E04A382
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 05:16:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XnUQQdsMelDV for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Apr 2019 05:16:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3EED4A36D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 05:16:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CFB1374;
 Tue,  9 Apr 2019 02:16:06 -0700 (PDT)
Received: from [10.1.215.53] (e121566-lin.cambridge.arm.com [10.1.215.53])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70BD83F59C;
 Tue,  9 Apr 2019 02:16:05 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] lib: arm: Use correct halt() prototype
 from smp.h
To: Andrew Jones <drjones@redhat.com>
References: <20190408151125.32080-1-alexandru.elisei@arm.com>
 <20190409074005.6fc5sve4kbpq6e5r@kamzik.brq.redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3dea090b-9c48-34b2-f004-37661cb71f0e@arm.com>
Date: Tue, 9 Apr 2019 10:15:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190409074005.6fc5sve4kbpq6e5r@kamzik.brq.redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190409091559.aJ8P_ADnOleEFx-4gvC03H3IC_0bf0vcN99tQpIvr5w@z>

On 4/9/19 8:40 AM, Andrew Jones wrote:
> On Mon, Apr 08, 2019 at 04:11:25PM +0100, Alexandru Elisei wrote:
>> The prototype for the halt() function is incorrect, because halt() doesn't
>> take any arguments. Fix it by using the prototype from smp.h.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/arm/io.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/arm/io.c b/lib/arm/io.c
>> index 8226b765bdc5..6d3d7afed002 100644
>> --- a/lib/arm/io.c
>> +++ b/lib/arm/io.c
>> @@ -15,11 +15,10 @@
>>  #include <asm/psci.h>
>>  #include <asm/spinlock.h>
>>  #include <asm/io.h>
>> +#include <asm/smp.h>
>>  
>>  #include "io.h"
>>  
>> -extern void halt(int code);
>> -
>>  static struct spinlock uart_lock;
>>  /*
>>   * Use this guess for the uart base in order to make an attempt at
>> @@ -93,6 +92,6 @@ void exit(int code)
>>  {
>>  	chr_testdev_exit(code);
>>  	psci_system_off();
>> -	halt(code);
>> +	halt();
>>  	__builtin_unreachable();
>>  }
>> -- 
>> 2.17.0
>>
> I don't mind this change, because per the code it is the "correct"
> thing to do. However, I was being a bit tricky here when I wrote it.
> By changing the prototype to take 'code' as argument we guarantee
> that 'code' will be in x0/r0 when we halt, giving us a last chance
> to see it when inspecting the halted unit test state.
>
> Anyway, like I said, I'm fine with the cleanup, but the prototype
> abuse does serve a purpose - maybe just not a good enough purpose
> to justify the weirdness.

Now it makes sense. I didn't think it was intentional, but now that you have
mentioned it, the same pattern is used by powerpc.

Perhaps a comment explaining that having different prototypes was on purpose
would be the best solution?

>
> Thanks,
> drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
