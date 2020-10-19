Return-Path: <SRS0=pEf/=D2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93986C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 19 Oct 2020 12:55:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3137222C3
	for <kvmarm@archiver.kernel.org>; Mon, 19 Oct 2020 12:55:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="V9QHrxwu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3137222C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A7294B609;
	Mon, 19 Oct 2020 08:55:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 31l-JVBP8lJ8; Mon, 19 Oct 2020 08:55:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0081E4B63E;
	Mon, 19 Oct 2020 08:55:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35AE44B609
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2020 08:55:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 806bTpJALbIk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Oct 2020 08:55:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E63AC4B5C5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2020 08:55:45 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 98A6F222BA;
 Mon, 19 Oct 2020 12:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603112144;
 bh=y4Ld2IaKjGmIN1elN0FhvRwU9UgaCyx25hueIiCiNK8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=V9QHrxwu9+A3Einr5uHzpudzhlSqIbwQTDSR4q4euLcjUHjifnEPq0fRNu6RSpjsL
 0e3A7YKiP0wZzYF74VXPqoyXqRJA4l8Z1TDSlsEBbXNeMTXl6Xz/Q4AZ1Pj/0qz4zE
 Sf1kOyYbl8fERQiuxcO4TFNoXDBeAAkXi5/DKqRs=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kUUhS-002QC6-NQ; Mon, 19 Oct 2020 13:55:42 +0100
MIME-Version: 1.0
Date: Mon, 19 Oct 2020 13:55:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] perf: arm_spe: Use Inner Shareable DSB when draining the
 buffer
In-Reply-To: <20201019122455.GD34028@C02TD0UTHF1T.local>
References: <20201006150520.161985-1-alexandru.elisei@arm.com>
 <87ft6r4bgd.wl-maz@kernel.org>
 <8fa8af94-ab08-b43a-95e4-55a13de09efe@arm.com>
 <20201019122455.GD34028@C02TD0UTHF1T.local>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <6878fd559ca5c63a251c47c271df7c5e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On 2020-10-19 13:24, Mark Rutland wrote:
> On Tue, Oct 06, 2020 at 05:13:31PM +0100, Alexandru Elisei wrote:
>> Hi Marc,
>> 
>> Thank you for having a look at the patch!
>> 
>> On 10/6/20 4:32 PM, Marc Zyngier wrote:
>> > Hi Alex,
>> >
>> > On Tue, 06 Oct 2020 16:05:20 +0100,
>> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> >> From ARM DDI 0487F.b, page D9-2807:
>> >>
>> >> "Although the Statistical Profiling Extension acts as another observer in
>> >> the system, for determining the Shareability domain of the DSB
>> >> instructions, the writes of sample records are treated as coming from the
>> >> PE that is being profiled."
>> >>
>> >> Similarly, on page D9-2801:
>> >>
>> >> "The memory type and attributes that are used for a write by the
>> >> Statistical Profiling Extension to the Profiling Buffer is taken from the
>> >> translation table entries for the virtual address being written to. That
>> >> is:
>> >> - The writes are treated as coming from an observer that is coherent with
>> >>   all observers in the Shareability domain that is defined by the
>> >>   translation tables."
>> >>
>> >> All the PEs are in the Inner Shareable domain, use a DSB ISH to make sure
>> >> writes to the profiling buffer have completed.
>> > I'm a bit sceptical of this change. The SPE writes are per-CPU, and
>> > all we are trying to ensure is that the CPU we are running on has
>> > drained its own queue of accesses.
>> >
>> > The accesses being made within the IS domain doesn't invalidate the
>> > fact that they are still per-CPU, because "the writes of sample
>> > records are treated as coming from the PE that is being profiled.".
>> >
>> > So why should we have an IS-wide synchronisation for accesses that are
>> > purely local?
>> 
>> I think I might have misunderstood how perf spe works. Below is my 
>> original train
>> of thought.
>> 
>> In the buffer management event interrupt we drain the buffer, and if 
>> the buffer is
>> full, we call arm_spe_perf_aux_output_end() -> perf_aux_output_end(). 
>> The comment
>> for perf_aux_output_end() says "Commit the data written by hardware 
>> into the ring
>> buffer by adjusting aux_head and posting a PERF_RECORD_AUX into the 
>> perf buffer.
>> It is the pmu driver's responsibility to observe ordering rules of the 
>> hardware,
>> so that all the data is externally visible before this is called." My 
>> conclusion
>> was that after we drain the buffer, the data must be visible to all 
>> CPUs.
> 
> FWIW, this reasoning sounds correct to me. The DSB NSH will be
> sufficient to drain the buffer, but we need the DSB ISH to ensure that
> it's visbile to other CPUs at the instant we call 
> perf_aux_output_end().

Right. I think I missed that last bit (and Alex's email at the same 
time).

> Otherwise, if CPU x is reading the ring-buffer written by CPU y, it
> might see the aux buffer pointers updated before the samples are
> viisble, and hence read junk from the buffer.
> 
> We can add a comment to that effect (or rework perf_aux_output_end()
> somehow to handle that ordering).

I'd rather this is done in perf_aux_output_end(), as a full blown DSB 
ISH
on guest entry is pretty harsh... It would also nicely split the 
responsibilities:

- KVM stops SPE and make sure the output is drained
- Perf makes the data visible to all CPUs

Thoughts?

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
