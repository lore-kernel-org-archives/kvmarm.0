Return-Path: <SRS0=koWH=3S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CECC33CB7
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jan 2020 09:30:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B9E820716
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jan 2020 09:30:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FB4TtNvn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B9E820716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC6834A959;
	Wed, 29 Jan 2020 04:30:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9y9sNoSmY0o6; Wed, 29 Jan 2020 04:30:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69DE34A5C6;
	Wed, 29 Jan 2020 04:30:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4817D4A5BD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jan 2020 04:30:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JrBugLEBiIyx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jan 2020 04:30:02 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F00CC4A588
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jan 2020 04:30:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1580290201;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=D9f7QdvFboxwQ5TVJWf6be3JYQu7wrZQ2uymnn5sFPo=;
 b=FB4TtNvno+stKgCH9epq7+Si3Q4f+J+G1v1J8mAikxE8J6MX27wIhlF6xc+LLXhBlWbJrr
 BQwjWLr3vOpOGvyCYmqRXEP8gWwAsWkaiIY5RHe6VnmTUkBy8BdkqhRj8fXKla9/uen84Q
 67V8aS4s6xliNknnFgq+4ddGG2DGx+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-eI79hYDfNj62FSq7pKOfoA-1; Wed, 29 Jan 2020 04:29:55 -0500
X-MC-Unique: eI79hYDfNj62FSq7pKOfoA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DF45800D41;
 Wed, 29 Jan 2020 09:29:53 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1095D60BE0;
 Wed, 29 Jan 2020 09:29:47 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 12/14] arm/run: Allow Migration tests
To: Thomas Huth <thuth@redhat.com>, eric.auger.pro@gmail.com, maz@kernel.org, 
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org, 
 qemu-arm@nongnu.org
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-13-eric.auger@redhat.com>
 <3962373a-0e03-5ab9-30cc-3b385fc55702@redhat.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <c00b26e8-5197-a977-963e-b0b9366ad6d0@redhat.com>
Date: Wed, 29 Jan 2020 10:29:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <3962373a-0e03-5ab9-30cc-3b385fc55702@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: andre.przywara@arm.com
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

Hi Thomas,

On 1/29/20 9:07 AM, Thomas Huth wrote:
> On 28/01/2020 11.34, Eric Auger wrote:
>> Let's link getchar.o to use puts and getchar from the
>> tests.
>>
>> Then allow tests belonging to the migration group to
>> trigger the migration from the test code by putting
>> "migrate" into the uart. Then the code can wait for the
>> migration completion by using getchar().
>>
>> The __getchar implement is minimalist as it just reads the
>> data register. It is just meant to read the single character
>> emitted at the end of the migration by the runner script.
>>
>> It is not meant to read more data (FIFOs are not enabled).
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v2 -> v3:
>> - take the lock
>> - assert if more than 16 chars
>> - removed Thomas' R-b
>> ---
>>  arm/Makefile.common |  2 +-
>>  arm/run             |  2 +-
>>  lib/arm/io.c        | 28 ++++++++++++++++++++++++++++
>>  3 files changed, 30 insertions(+), 2 deletions(-)
>>
>> diff --git a/arm/Makefile.common b/arm/Makefile.common
>> index b8988f2..a123e85 100644
>> --- a/arm/Makefile.common
>> +++ b/arm/Makefile.common
>> @@ -32,7 +32,7 @@ CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
>>  asm-offsets = lib/$(ARCH)/asm-offsets.h
>>  include $(SRCDIR)/scripts/asm-offsets.mak
>>  
>> -cflatobjs += lib/util.o
>> +cflatobjs += lib/util.o lib/getchar.o
>>  cflatobjs += lib/alloc_phys.o
>>  cflatobjs += lib/alloc_page.o
>>  cflatobjs += lib/vmalloc.o
>> diff --git a/arm/run b/arm/run
>> index 277db9b..a390ca5 100755
>> --- a/arm/run
>> +++ b/arm/run
>> @@ -61,6 +61,6 @@ fi
>>  M+=",accel=$ACCEL"
>>  command="$qemu -nodefaults $M -cpu $processor $chr_testdev $pci_testdev"
>>  command+=" -display none -serial stdio -kernel"
>> -command="$(timeout_cmd) $command"
>> +command="$(migration_cmd) $(timeout_cmd) $command"
>>  
>>  run_qemu $command "$@"
>> diff --git a/lib/arm/io.c b/lib/arm/io.c
>> index 99fd315..d8e7745 100644
>> --- a/lib/arm/io.c
>> +++ b/lib/arm/io.c
>> @@ -87,6 +87,34 @@ void puts(const char *s)
>>  	spin_unlock(&uart_lock);
>>  }
>>  
>> +static int ____getchar(void)
> 
> Three underscores? ... that's quite a lot already. I'd maybe rather name
> the function "do_getchar" or something similar instead. Or simply merge
> the code into the __getchar function below - it's just three lines.
OK
> 
>> +{
>> +	int c;
>> +
>> +	spin_lock(&uart_lock);
>> +	c = readb(uart0_base);
>> +	spin_unlock(&uart_lock);
>> +
>> +	return c ? : -1;
> 
> Just a matter of taste, but I prefer the elvis operator without space in
> between.
OK
> 
>> +}
>> +
>> +/*
>> + * Minimalist implementation for migration completion detection.
>> + * Without FIFOs enabled on the QEMU UART device we just read
>> + * the data register: we cannot read more than 16 characters.
> 
> Where are the 16 bytes buffered if FIFOs are disabled?
I think this is in the PL011 data register (UARTDR), 4 words.
https://developer.arm.com/docs/ddi0183/latest/programmers-model/register-descriptions/data-register-uartdr

> 
>> + */
>> +int __getchar(void)
>> +{
>> +	int c = ____getchar();
>> +	static int count;
>> +
>> +	if (c != -1)
>> +		++count;
>> +
>> +	assert(count < 16);
>> +
>> +	return c;
>> +}
> 
> The above comments were only nits ... feel free to ignore them if you
> don't want to respin the series just because of this.
No Problem. Thank you for your time.

Thanks

Eric
> 
>  Thomas
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
