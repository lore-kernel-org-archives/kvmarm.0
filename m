Return-Path: <SRS0=b97j=N4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDA0C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 10:19:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BFC1760FBF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 10:19:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BFC1760FBF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AC294B282;
	Mon,  6 Sep 2021 06:19:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NeZaWVx-1aH6; Mon,  6 Sep 2021 06:19:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F056A4B256;
	Mon,  6 Sep 2021 06:19:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F28F74B252
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 06:19:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VpzzjHRdGILy for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Sep 2021 06:19:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC6C54B210
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 06:19:10 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39725D6E;
 Mon,  6 Sep 2021 03:19:10 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C89813F73D;
 Mon,  6 Sep 2021 03:19:07 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH 1/5] lib: arm: Print test exit status
 on exit if chr-testdev is not available
To: Andrew Jones <drjones@redhat.com>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-2-alexandru.elisei@arm.com>
 <20210712163647.oxntpjapur4z23sl@gator>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <7814beab-547e-98d9-9aa0-3b7e5afd803b@arm.com>
Date: Mon, 6 Sep 2021 11:20:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210712163647.oxntpjapur4z23sl@gator>
Content-Language: en-US
Cc: lvivier@redhat.com, linux-s390@vger.kernel.org, thuth@redhat.com,
 frankja@linux.ibm.com, kvm@vger.kernel.org, david@redhat.com,
 andre.przywara@arm.com, cohuck@redhat.com, kvm-ppc@vger.kernel.org,
 vivek.gautam@arm.com, maz@kernel.org, pbonzini@redhat.com,
 imbrenda@linux.ibm.com, kvmarm@lists.cs.columbia.edu
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

Sorry for taking so long to reply, been busy with other things.

On 7/12/21 5:36 PM, Andrew Jones wrote:
> On Fri, Jul 02, 2021 at 05:31:18PM +0100, Alexandru Elisei wrote:
>> The arm64 tests can be run under kvmtool, which doesn't emulate a
>> chr-testdev device. In preparation for adding run script support for
>> kvmtool, print the test exit status so the scripts can pick it up and
>> correctly mark the test as pass or fail.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/chr-testdev.h |  1 +
>>  lib/arm/io.c      | 10 +++++++++-
>>  lib/chr-testdev.c |  5 +++++
>>  3 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
>> index ffd9a851aa9b..09b4b424670e 100644
>> --- a/lib/chr-testdev.h
>> +++ b/lib/chr-testdev.h
>> @@ -11,4 +11,5 @@
>>   */
>>  extern void chr_testdev_init(void);
>>  extern void chr_testdev_exit(int code);
>> +extern bool chr_testdev_available(void);
>>  #endif
>> diff --git a/lib/arm/io.c b/lib/arm/io.c
>> index 343e10822263..9e62b571a91b 100644
>> --- a/lib/arm/io.c
>> +++ b/lib/arm/io.c
>> @@ -125,7 +125,15 @@ extern void halt(int code);
>>  
>>  void exit(int code)
>>  {
>> -	chr_testdev_exit(code);
>> +	if (chr_testdev_available()) {
>> +		chr_testdev_exit(code);
> chr_testdev_exit() already has a 'if !vcon goto out' in it, so you can
> just call it unconditionally. No need for chr_testdev_available().

I'm not sure what you mean. There has to be a way to check if chr-testdev is
available, and if it's not present on the system, to print the EXIT: STATUS
message, and vcon is static in chr-testdev.c.

Are you suggesting that we move the message to chr_testdev_exit(code)?

Thanks,

Alex

>
>> +	} else {
>> +		/*
>> +		 * Print the test return code in the format used by chr-testdev
>> +		 * so the runner script can parse it.
>> +		 */
>> +		printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
>> +	}
>>  	psci_system_off();
>>  	halt(code);
>>  	__builtin_unreachable();
>> diff --git a/lib/chr-testdev.c b/lib/chr-testdev.c
>> index b3c641a833fe..301e73a6c064 100644
>> --- a/lib/chr-testdev.c
>> +++ b/lib/chr-testdev.c
>> @@ -68,3 +68,8 @@ void chr_testdev_init(void)
>>  	in_vq = vqs[0];
>>  	out_vq = vqs[1];
>>  }
>> +
>> +bool chr_testdev_available(void)
>> +{
>> +	return vcon != NULL;
>> +}
>> -- 
>> 2.32.0
>>
> Thanks,
> drew 
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
