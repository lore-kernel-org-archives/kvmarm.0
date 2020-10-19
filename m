Return-Path: <SRS0=pEf/=D2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B798C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 19 Oct 2020 12:25:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B91C8222B8
	for <kvmarm@archiver.kernel.org>; Mon, 19 Oct 2020 12:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B91C8222B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0B6A4B61B;
	Mon, 19 Oct 2020 08:25:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UJtbvLwPfZl9; Mon, 19 Oct 2020 08:25:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A2A54B3FD;
	Mon, 19 Oct 2020 08:25:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E5194B3FD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2020 08:25:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jw-wWbQ0Xuzn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Oct 2020 08:25:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9F8E4B363
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2020 08:25:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64B3730E;
 Mon, 19 Oct 2020 05:25:00 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.55.56])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 35F743F719;
 Mon, 19 Oct 2020 05:24:58 -0700 (PDT)
Date: Mon, 19 Oct 2020 13:24:55 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] perf: arm_spe: Use Inner Shareable DSB when draining the
 buffer
Message-ID: <20201019122455.GD34028@C02TD0UTHF1T.local>
References: <20201006150520.161985-1-alexandru.elisei@arm.com>
 <87ft6r4bgd.wl-maz@kernel.org>
 <8fa8af94-ab08-b43a-95e4-55a13de09efe@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8fa8af94-ab08-b43a-95e4-55a13de09efe@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

On Tue, Oct 06, 2020 at 05:13:31PM +0100, Alexandru Elisei wrote:
> Hi Marc,
> 
> Thank you for having a look at the patch!
> 
> On 10/6/20 4:32 PM, Marc Zyngier wrote:
> > Hi Alex,
> >
> > On Tue, 06 Oct 2020 16:05:20 +0100,
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >> From ARM DDI 0487F.b, page D9-2807:
> >>
> >> "Although the Statistical Profiling Extension acts as another observer in
> >> the system, for determining the Shareability domain of the DSB
> >> instructions, the writes of sample records are treated as coming from the
> >> PE that is being profiled."
> >>
> >> Similarly, on page D9-2801:
> >>
> >> "The memory type and attributes that are used for a write by the
> >> Statistical Profiling Extension to the Profiling Buffer is taken from the
> >> translation table entries for the virtual address being written to. That
> >> is:
> >> - The writes are treated as coming from an observer that is coherent with
> >>   all observers in the Shareability domain that is defined by the
> >>   translation tables."
> >>
> >> All the PEs are in the Inner Shareable domain, use a DSB ISH to make sure
> >> writes to the profiling buffer have completed.
> > I'm a bit sceptical of this change. The SPE writes are per-CPU, and
> > all we are trying to ensure is that the CPU we are running on has
> > drained its own queue of accesses.
> >
> > The accesses being made within the IS domain doesn't invalidate the
> > fact that they are still per-CPU, because "the writes of sample
> > records are treated as coming from the PE that is being profiled.".
> >
> > So why should we have an IS-wide synchronisation for accesses that are
> > purely local?
> 
> I think I might have misunderstood how perf spe works. Below is my original train
> of thought.
> 
> In the buffer management event interrupt we drain the buffer, and if the buffer is
> full, we call arm_spe_perf_aux_output_end() -> perf_aux_output_end(). The comment
> for perf_aux_output_end() says "Commit the data written by hardware into the ring
> buffer by adjusting aux_head and posting a PERF_RECORD_AUX into the perf buffer.
> It is the pmu driver's responsibility to observe ordering rules of the hardware,
> so that all the data is externally visible before this is called." My conclusion
> was that after we drain the buffer, the data must be visible to all CPUs.

FWIW, this reasoning sounds correct to me. The DSB NSH will be
sufficient to drain the buffer, but we need the DSB ISH to ensure that
it's visbile to other CPUs at the instant we call perf_aux_output_end().

Otherwise, if CPU x is reading the ring-buffer written by CPU y, it
might see the aux buffer pointers updated before the samples are
viisble, and hence read junk from the buffer.

We can add a comment to that effect (or rework perf_aux_output_end()
somehow to handle that ordering).

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
