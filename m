Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F924C4741F
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 15:57:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4F0D12067D
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 15:57:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F0D12067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8794D4B4E3;
	Fri, 30 Oct 2020 11:57:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hsVktRRq4Cyi; Fri, 30 Oct 2020 11:57:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E5AA4B450;
	Fri, 30 Oct 2020 11:57:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEB944B3CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 11:57:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H-cqqglYmDXQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 11:57:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88D244B3C2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 11:57:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16A9E30E;
 Fri, 30 Oct 2020 08:57:04 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 689D23F719;
 Fri, 30 Oct 2020 08:57:03 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH v2 2/5] lib/{bitops, alloc_page}.h: Add
 missing headers
To: Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <20201027171944.13933-3-alexandru.elisei@arm.com>
 <8474ba0a-ab47-9b83-5f30-0418cf6f0b24@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <44e2651a-58a0-000c-719d-b3f9c0791c03@arm.com>
Date: Fri, 30 Oct 2020 15:58:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <8474ba0a-ab47-9b83-5f30-0418cf6f0b24@redhat.com>
Content-Language: en-US
Cc: pbonzini@redhat.com
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

Hi Eric,

On 10/30/20 3:29 PM, Auger Eric wrote:
> Hi Alexandru,
> On 10/27/20 6:19 PM, Alexandru Elisei wrote:
>> bitops.h uses the 'bool' and 'size_t' types, but doesn't include the
>> stddef.h and stdbool.h headers, where the types are defined. This can cause
>> the following error when compiling:
>>
>> In file included from arm/new-test.c:9:
>> /path/to/kvm-unit-tests/lib/bitops.h:77:15: error: unknown type name 'bool'
>>    77 | static inline bool is_power_of_2(unsigned long n)
>>       |               ^~~~
>> /path/to/kvm-unit-tests/lib/bitops.h:82:38: error: unknown type name 'size_t'
>>    82 | static inline unsigned int get_order(size_t size)
>>       |                                      ^~~~~~
>> /path/to/kvm-unit-tests/lib/bitops.h:24:1: note: 'size_t' is defined in header '<stddef.h>'; did you forget to '#include <stddef.h>'?
>>    23 | #include <asm/bitops.h>
>>   +++ |+#include <stddef.h>
>>    24 |
>> make: *** [<builtin>: arm/new-test.o] Error 1
>>
>> The same errors were observed when including alloc_page.h. Fix both files
>> by including stddef.h and stdbool.h.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/alloc_page.h | 2 ++
>>  lib/bitops.h     | 2 ++
>>  2 files changed, 4 insertions(+)
>>
>> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
>> index 88540d1def06..182862c43363 100644
>> --- a/lib/alloc_page.h
>> +++ b/lib/alloc_page.h
>> @@ -4,6 +4,8 @@
>>   * This is a simple allocator that provides contiguous physical addresses
>>   * with byte granularity.
>>   */
>> +#include <stdbool.h>
>> +#include <stddef.h>
> nit: you may move those includes after the #ifndef ALLOC_PAGE_H as it is
> usually done.

Oops, you're right, I missed that, will change.

>>  
>>  #ifndef ALLOC_PAGE_H
>>  #define ALLOC_PAGE_H 1
>> diff --git a/lib/bitops.h b/lib/bitops.h
>> index 308aa86514a8..5aeea0b998b1 100644
>> --- a/lib/bitops.h
>> +++ b/lib/bitops.h
>> @@ -1,5 +1,7 @@
>>  #ifndef _BITOPS_H_
>>  #define _BITOPS_H_
>> +#include <stdbool.h>
>> +#include <stddef.h>
>>  
>>  /*
>>   * Adapted from
>>
> Besides
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
