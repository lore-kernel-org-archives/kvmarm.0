Return-Path: <SRS0=ArS2=HK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826C5C433DB
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 12:02:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC46864E79
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 12:02:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC46864E79
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04BAE4B214;
	Mon,  8 Feb 2021 07:02:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9wsKGe9VQjfz; Mon,  8 Feb 2021 07:02:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 794AB4B0C0;
	Mon,  8 Feb 2021 07:02:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5525A4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 07:02:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DUtHsQjXCBvl for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2021 07:02:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 718C04AEDC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 07:02:53 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF24931B;
 Mon,  8 Feb 2021 04:02:52 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3AE893F73B;
 Mon,  8 Feb 2021 04:02:52 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3 11/11] arm64: gic: Use IPI test checking
 for the LPI tests
To: Auger Eric <eric.auger@redhat.com>, drjones@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210129163647.91564-1-alexandru.elisei@arm.com>
 <20210129163647.91564-12-alexandru.elisei@arm.com>
 <12c8b5a8-b515-64b8-eece-d9d85fb2fe72@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b9f49e6d-bd59-2b1a-323a-e7c153e8d87c@arm.com>
Date: Mon, 8 Feb 2021 12:02:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <12c8b5a8-b515-64b8-eece-d9d85fb2fe72@redhat.com>
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

On 2/5/21 1:30 PM, Auger Eric wrote:
> Hi Alexandru,
>
> On 1/29/21 5:36 PM, Alexandru Elisei wrote:
>> The LPI code validates a result similarly to the IPI tests, by checking if
>> the target CPU received the interrupt with the expected interrupt number.
>> However, the LPI tests invent their own way of checking the test results by
>> creating a global struct (lpi_stats), using a separate interrupt handler
>> (lpi_handler) and test function (check_lpi_stats).
>>
>> There are several areas that can be improved in the LPI code, which are
>> already covered by the IPI tests:
>>
>> - check_lpi_stats() doesn't take into account that the target CPU can
>>   receive the correct interrupt multiple times.
>> - check_lpi_stats() doesn't take into the account the scenarios where all
>>   online CPUs can receive the interrupt, but the target CPU is the last CPU
>>   that touches lpi_stats.observed.
>> - Insufficient or missing memory synchronization.
>>
>> Instead of duplicating code, let's convert the LPI tests to use
>> check_acked() and the same interrupt handler as the IPI tests, which has
>> been renamed to irq_handler() to avoid any confusion.
>>
>> check_lpi_stats() has been replaced with check_acked() which, together with
>> using irq_handler(), instantly gives us more correctness checks and proper
>> memory synchronization between threads. lpi_stats.expected has been
>> replaced by the CPU mask and the expected interrupt number arguments to
>> check_acked(), with no change in semantics.
>>
>> lpi_handler() aborted the test if the interrupt number was not an LPI. This
>> was changed in favor of allowing the test to continue, as it will fail in
>> check_acked(), but possibly print information useful for debugging. If the
>> test receives spurious interrupts, those are reported via report_info() at
>> the end of the test for consistency with the IPI tests, which don't treat
>> spurious interrupts as critical errors.
>>
>> In the spirit of code reuse, secondary_lpi_tests() has been replaced with
>> ipi_recv() because the two are now identical; ipi_recv() has been renamed
>> to irq_recv(), similarly to irq_handler(), to avoid confusion.
>>
>> CC: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/gic.c | 190 +++++++++++++++++++++++++-----------------------------
>>  1 file changed, 87 insertions(+), 103 deletions(-)
>>
>> [..]
>> @@ -796,18 +737,31 @@ static void test_its_trigger(void)
>>  	 * The LPI should not hit
>>  	 */
>>  	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
>> -	lpi_stats_expect(-1, -1);
>> +	stats_reset();
>> +	cpumask_clear(&mask);
>>  	its_send_int(dev2, 20);
>> -	check_lpi_stats("dev2/eventid=20 still does not trigger any LPI");
>> +	wait_for_interrupts(&mask);
>> +	report(check_acked(&mask, -1, -1),
>> +			"dev2/eventid=20 still does not trigger any LPI");
>>  
>>  	/* Now call the invall and check the LPI hits */
>> +	stats_reset();
>> +	/* The barrier is from its_send_int() */
>> +	wmb();
> In v1 it was envisionned to add the wmb in __its_send_it but I fail to
> see it. Is it implicit in some way?

Thank you for having a look at this, it seems I forgot to remove this barrier.

The barriers in __its_send_int() and the one above are not needed because the
barrier is already present in its_send_invall() -> its_send_single_command() ->
its_post_commands() -> writeq() (the removal from __its_send_int() is also
explained in the cover letter).

I'll remove the wmb() barrier in the next version.

Thanks,

Alex

>
> Thanks
>
> Eric
>> +	cpumask_clear(&mask);
>> +	cpumask_set_cpu(3, &mask);
>>  	its_send_invall(col3);
>> -	lpi_stats_expect(3, 8195);
>> -	check_lpi_stats("dev2/eventid=20 pending LPI is received");
>> +	wait_for_interrupts(&mask);
>> +	report(check_acked(&mask, 0, 8195),
>> +			"dev2/eventid=20 pending LPI is received");
>>  
>> -	lpi_stats_expect(3, 8195);
>> +	stats_reset();
>> +	cpumask_clear(&mask);
>> +	cpumask_set_cpu(3, &mask);
>>  	its_send_int(dev2, 20);
>> -	check_lpi_stats("dev2/eventid=20 now triggers an LPI");
>> +	wait_for_interrupts(&mask);
>> +	report(check_acked(&mask, 0, 8195),
>> +			"dev2/eventid=20 now triggers an LPI");
>>  
>>  	report_prefix_pop();
>>  
>> @@ -818,9 +772,13 @@ static void test_its_trigger(void)
>>  	 */
>>  
>>  	its_send_mapd(dev2, false);
>> -	lpi_stats_expect(-1, -1);
>> +	stats_reset();
>> +	cpumask_clear(&mask);
>>  	its_send_int(dev2, 20);
>> -	check_lpi_stats("no LPI after device unmap");
>> +	wait_for_interrupts(&mask);
>> +	report(check_acked(&mask, -1, -1), "no LPI after device unmap");
>> +
>> +	check_spurious();
>>  	report_prefix_pop();
>>  }
>>  
>> @@ -828,6 +786,7 @@ static void test_its_migration(void)
>>  {
>>  	struct its_device *dev2, *dev7;
>>  	bool test_skipped = false;
>> +	cpumask_t mask;
>>  
>>  	if (its_setup1()) {
>>  		test_skipped = true;
>> @@ -844,13 +803,23 @@ do_migrate:
>>  	if (test_skipped)
>>  		return;
>>  
>> -	lpi_stats_expect(3, 8195);
>> +	stats_reset();
>> +	cpumask_clear(&mask);
>> +	cpumask_set_cpu(3, &mask);
>>  	its_send_int(dev2, 20);
>> -	check_lpi_stats("dev2/eventid=20 triggers LPI 8195 on PE #3 after migration");
>> +	wait_for_interrupts(&mask);
>> +	report(check_acked(&mask, 0, 8195),
>> +			"dev2/eventid=20 triggers LPI 8195 on PE #3 after migration");
>>  
>> -	lpi_stats_expect(2, 8196);
>> +	stats_reset();
>> +	cpumask_clear(&mask);
>> +	cpumask_set_cpu(2, &mask);
>>  	its_send_int(dev7, 255);
>> -	check_lpi_stats("dev7/eventid=255 triggers LPI 8196 on PE #2 after migration");
>> +	wait_for_interrupts(&mask);
>> +	report(check_acked(&mask, 0, 8196),
>> +			"dev7/eventid=255 triggers LPI 8196 on PE #2 after migration");
>> +
>> +	check_spurious();
>>  }
>>  
>>  #define ERRATA_UNMAPPED_COLLECTIONS "ERRATA_8c58be34494b"
>> @@ -860,6 +829,7 @@ static void test_migrate_unmapped_collection(void)
>>  	struct its_collection *col = NULL;
>>  	struct its_device *dev2 = NULL, *dev7 = NULL;
>>  	bool test_skipped = false;
>> +	cpumask_t mask;
>>  	int pe0 = 0;
>>  	u8 config;
>>  
>> @@ -894,17 +864,27 @@ do_migrate:
>>  	its_send_mapc(col, true);
>>  	its_send_invall(col);
>>  
>> -	lpi_stats_expect(2, 8196);
>> +	stats_reset();
>> +	cpumask_clear(&mask);
>> +	cpumask_set_cpu(2, &mask);
>>  	its_send_int(dev7, 255);
>> -	check_lpi_stats("dev7/eventid= 255 triggered LPI 8196 on PE #2");
>> +	wait_for_interrupts(&mask);
>> +	report(check_acked(&mask, 0, 8196),
>> +			"dev7/eventid= 255 triggered LPI 8196 on PE #2");
>>  
>>  	config = gicv3_lpi_get_config(8192);
>>  	report(config == LPI_PROP_DEFAULT,
>>  	       "Config of LPI 8192 was properly migrated");
>>  
>> -	lpi_stats_expect(pe0, 8192);
>> +	stats_reset();
>> +	cpumask_clear(&mask);
>> +	cpumask_set_cpu(pe0, &mask);
>>  	its_send_int(dev2, 0);
>> -	check_lpi_stats("dev2/eventid = 0 triggered LPI 8192 on PE0");
>> +	wait_for_interrupts(&mask);
>> +	report(check_acked(&mask, 0, 8192),
>> +			"dev2/eventid = 0 triggered LPI 8192 on PE0");
>> +
>> +	check_spurious();
>>  }
>>  
>>  static void test_its_pending_migration(void)
>> @@ -961,6 +941,10 @@ static void test_its_pending_migration(void)
>>  	pendbaser = readq(ptr);
>>  	writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
>>  
>> +	/*
>> +	 * Reset and initialization values for acked are the same, so we don't
>> +	 * need to explicitely call stats_reset().
>> +	 */
>>  	gicv3_lpi_rdist_enable(pe0);
>>  	gicv3_lpi_rdist_enable(pe1);
>>  
>>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
