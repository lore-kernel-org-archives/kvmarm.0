Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCD1C64E7C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 14:05:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B86F820705
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 14:05:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B86F820705
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E79E24B394;
	Wed,  2 Dec 2020 09:05:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Uqx0nYEJ7e5g; Wed,  2 Dec 2020 09:05:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A00284B37B;
	Wed,  2 Dec 2020 09:05:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A98374B37B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 09:05:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pp5RSzDgG3gn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 09:05:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C2AA4B372
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 09:05:06 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3EF2C1063;
 Wed,  2 Dec 2020 06:05:06 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 841C83F718;
 Wed,  2 Dec 2020 06:05:05 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 04/10] arm/arm64: gic: Remove unnecessary
 synchronization with stats_reset()
To: Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, drjones@redhat.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-5-alexandru.elisei@arm.com>
 <e7bd5d3a-831a-ba47-9fe3-b820c33e5972@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <313978c4-b35e-bcb7-c698-18ad2eb2b04a@arm.com>
Date: Wed, 2 Dec 2020 14:06:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <e7bd5d3a-831a-ba47-9fe3-b820c33e5972@redhat.com>
Content-Language: en-US
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

Hi Eric,

On 12/1/20 4:48 PM, Auger Eric wrote:
> Hi Alexandru,
>
> On 11/25/20 4:51 PM, Alexandru Elisei wrote:
>> The GICv3 driver executes a DSB barrier before sending an IPI, which
>> ensures that memory accesses have completed. This removes the need to
>> enforce ordering with respect to stats_reset() in the IPI handler.
>>
>> For GICv2, we still need the DMB to ensure ordering between the read of the
>> GICC_IAR MMIO register and the read from the acked array. It also matches
>> what the Linux GICv2 driver does in gic_handle_irq().
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/gic.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index 4e947e8516a2..7befda2a8673 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -60,7 +60,6 @@ static void stats_reset(void)
>>  		bad_sender[i] = -1;
>>  		bad_irq[i] = -1;
>>  	}
>> -	smp_wmb();
> Here we are (pair removed). Still the one in check_acked still exists.

The smp_rmb() from check_acked() is there to implement the message passing pattern
wrt the writes from the ipi_handler() function, not the writes from stats_reset().
See the next patch where I try to explain how the barriers should work.

Thanks,

Alex

>>  }
>>  
>>  static void check_acked(const char *testname, cpumask_t *mask)
>> @@ -150,7 +149,13 @@ static void ipi_handler(struct pt_regs *regs __unused)
>>  
>>  	if (irqnr != GICC_INT_SPURIOUS) {
>>  		gic_write_eoir(irqstat);
>> -		smp_rmb(); /* pairs with wmb in stats_reset */
>> +		/*
>> +		 * Make sure data written before the IPI was triggered is
>> +		 * observed after the IAR is read. Pairs with the smp_wmb
>> +		 * when sending the IPI.
>> +		 */
>> +		if (gic_version() == 2)
>> +			smp_rmb();
>>  		++acked[smp_processor_id()];
>>  		check_ipi_sender(irqstat);
>>  		check_irqnr(irqnr);
>>
> Thanks
>
> Eric
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
