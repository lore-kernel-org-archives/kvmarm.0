Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED3CC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 10:29:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA5E423B6B
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 10:29:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA5E423B6B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA39E4B2B6;
	Wed,  9 Dec 2020 05:29:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3Ofe0IzG+0yU; Wed,  9 Dec 2020 05:29:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E7EF4B2C9;
	Wed,  9 Dec 2020 05:29:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C1FD4B2C9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 05:29:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HkpN8dvA3UgY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 05:29:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF42E4B2B6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 05:29:34 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4296B31B;
 Wed,  9 Dec 2020 02:29:34 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C4FE3F718;
 Wed,  9 Dec 2020 02:29:33 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 10/10] arm64: gic: Use IPI test checking
 for the LPI tests
To: Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, drjones@redhat.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-11-alexandru.elisei@arm.com>
 <31f306fe-f553-13ef-6b7b-c2dfc880fd43@redhat.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b66ca0e4-615e-5528-3c70-aac67bcd570e@arm.com>
Date: Wed, 9 Dec 2020 10:29:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <31f306fe-f553-13ef-6b7b-c2dfc880fd43@redhat.com>
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

On 12/3/20 2:59 PM, Auger Eric wrote:
> Hi Alexandru,
> On 11/25/20 4:51 PM, Alexandru Elisei wrote:
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
>> [..]
>> @@ -767,13 +700,27 @@ static void test_its_trigger(void)
>>  
>>  	report_prefix_push("int");
>>  
>> -	lpi_stats_expect(3, 8195);
>> +	stats_reset();
>> +	/*
>> +	 * its_send_int() is missing the synchronization from the GICv3 IPI
>> +	 * trigger functions.
>> +	 */
>> +	wmb();
> so don't you want to add it in __its_send_int instead?

The memory synchronization in the IPI sender functions make perfect sense, that's
how IPIs are used - one CPU kicks the target, the target reads from a shared
memory location.

I don't think receiving an interrupt from a device is how one would usually expect
to do inter-processor communication. However, I did more digging about this
ability to trigger interrupts from made-up devices, and it seems to me that this
was introduced for testing purposes (please correct me if I'm wrong). With this in
mind, I guess it wouldn't be awkward to have the wmb() in its_send_int(), because
we are using it just like we would an IPI. And it also reduces the boilerplate code.

I'll make the change in the next iteration.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
