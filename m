Return-Path: <SRS0=pEf/=D2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E92CC433E7
	for <kvmarm@archiver.kernel.org>; Mon, 19 Oct 2020 13:01:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 606D4222E7
	for <kvmarm@archiver.kernel.org>; Mon, 19 Oct 2020 13:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="du4KWCHj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 606D4222E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A85D94B668;
	Mon, 19 Oct 2020 09:01:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DgcYBVe6vb-D; Mon, 19 Oct 2020 09:01:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7441F4B644;
	Mon, 19 Oct 2020 09:01:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03F9F4B34C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2020 09:01:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DkWQcu4GoWWU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Oct 2020 09:01:20 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F148F4B302
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2020 09:01:19 -0400 (EDT)
Received: from willie-the-truck (unknown [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DDA90222BA;
 Mon, 19 Oct 2020 13:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603112478;
 bh=GgGkZAaRlizj7Hi/+mHqvSgG6p+ntVUBjwnOiM3XDlQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=du4KWCHjBVYLKJUft5CYwfv20d0edDysVSZ9+SoMX4DD+4Gz7SVW9I/f+e/rIz//U
 FhypW6Tk5/M7jl1s2Suca4/aKJsYvSrGKolGLHHTtrByhSHzXsaiaoQCwsB7ZBnTq6
 O8ninp9XeA7zPWR9okz/UOXqYycVCi40Fmmbhn/U=
Date: Mon, 19 Oct 2020 14:01:09 +0100
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] perf: arm_spe: Use Inner Shareable DSB when draining the
 buffer
Message-ID: <20201019130109.GA14994@willie-the-truck>
References: <20201006150520.161985-1-alexandru.elisei@arm.com>
 <87ft6r4bgd.wl-maz@kernel.org>
 <8fa8af94-ab08-b43a-95e4-55a13de09efe@arm.com>
 <20201019122455.GD34028@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201019122455.GD34028@C02TD0UTHF1T.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Mon, Oct 19, 2020 at 01:24:55PM +0100, Mark Rutland wrote:
> On Tue, Oct 06, 2020 at 05:13:31PM +0100, Alexandru Elisei wrote:
> > On 10/6/20 4:32 PM, Marc Zyngier wrote:
> > > On Tue, 06 Oct 2020 16:05:20 +0100,
> > > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > >> From ARM DDI 0487F.b, page D9-2807:
> > >>
> > >> "Although the Statistical Profiling Extension acts as another observer in
> > >> the system, for determining the Shareability domain of the DSB
> > >> instructions, the writes of sample records are treated as coming from the
> > >> PE that is being profiled."
> > >>
> > >> Similarly, on page D9-2801:
> > >>
> > >> "The memory type and attributes that are used for a write by the
> > >> Statistical Profiling Extension to the Profiling Buffer is taken from the
> > >> translation table entries for the virtual address being written to. That
> > >> is:
> > >> - The writes are treated as coming from an observer that is coherent with
> > >>   all observers in the Shareability domain that is defined by the
> > >>   translation tables."
> > >>
> > >> All the PEs are in the Inner Shareable domain, use a DSB ISH to make sure
> > >> writes to the profiling buffer have completed.
> > > I'm a bit sceptical of this change. The SPE writes are per-CPU, and
> > > all we are trying to ensure is that the CPU we are running on has
> > > drained its own queue of accesses.
> > >
> > > The accesses being made within the IS domain doesn't invalidate the
> > > fact that they are still per-CPU, because "the writes of sample
> > > records are treated as coming from the PE that is being profiled.".
> > >
> > > So why should we have an IS-wide synchronisation for accesses that are
> > > purely local?
> > 
> > I think I might have misunderstood how perf spe works. Below is my original train
> > of thought.
> > 
> > In the buffer management event interrupt we drain the buffer, and if the buffer is
> > full, we call arm_spe_perf_aux_output_end() -> perf_aux_output_end(). The comment
> > for perf_aux_output_end() says "Commit the data written by hardware into the ring
> > buffer by adjusting aux_head and posting a PERF_RECORD_AUX into the perf buffer.
> > It is the pmu driver's responsibility to observe ordering rules of the hardware,
> > so that all the data is externally visible before this is called." My conclusion
> > was that after we drain the buffer, the data must be visible to all CPUs.
> 
> FWIW, this reasoning sounds correct to me. The DSB NSH will be
> sufficient to drain the buffer, but we need the DSB ISH to ensure that
> it's visbile to other CPUs at the instant we call perf_aux_output_end().
> 
> Otherwise, if CPU x is reading the ring-buffer written by CPU y, it
> might see the aux buffer pointers updated before the samples are
> viisble, and hence read junk from the buffer.
> 
> We can add a comment to that effect (or rework perf_aux_output_end()
> somehow to handle that ordering).

Given that DSB is about completion rather than ordering, completion only
matters for endpoints and the endpoint in this scenarion is part of the
same observer, DSB NSH should be sufficient. Ordering of accesses as
observed by other CPUs should be handled with DMB or acquire/release.

So if the aux buffer code is missing barriers, we should add them there,
like you proposed before:

https://lore.kernel.org/lkml/20180510130632.34497-1-mark.rutland@arm.com/

What happened to that?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
