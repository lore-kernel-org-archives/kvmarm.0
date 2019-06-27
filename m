Return-Path: <SRS0=RzzQ=U2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB5EC48BD7
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jun 2019 10:27:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A11720828
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jun 2019 10:27:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ufNNsQ7P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A11720828
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3CF04A507;
	Thu, 27 Jun 2019 06:27:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eCoeKktnJu3y; Thu, 27 Jun 2019 06:27:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9217B4A4C1;
	Thu, 27 Jun 2019 06:27:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC68A4A4BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jun 2019 06:27:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bEztsQdarDlX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jun 2019 06:27:04 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8FC884A49F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jun 2019 06:27:04 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id F00C420828;
 Thu, 27 Jun 2019 10:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1561631223;
 bh=+aboWwW7RRRk1C/RYk5UOWQp4PDh2UA+to5qKLSsG5A=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ufNNsQ7PR/cG5oM3QhBjje8hgBKvThE0uaI9H9xM3+okTUjOvbrBIYQPnqnHbRbNy
 0t+KK8xaWhxO0Sb25thuG7jRqSWjh7gyuw+7eiQuFz4Jnys7TskYd/ZdNopyXT4nnP
 fsmY0hf/CSX8CAYEu4OwsGjutyiF0uZfK+cHA1lY=
Date: Thu, 27 Jun 2019 11:26:57 +0100
From: Will Deacon <will@kernel.org>
To: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
Message-ID: <20190627102656.elizqwby4sw4vi5j@willie-the-truck>
References: <20190321163623.20219-1-julien.grall@arm.com>
 <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
 <CAJF2gTStSR7Jmu7=HaO5Wxz=Zn8A5-RD8ktori3oKEhM9vozAA@mail.gmail.com>
 <20190621141606.GF18954@arrakis.emea.arm.com>
 <CAJF2gTTVUToRkRtxTmtWDotMGXy5YQCpL1h_2neTBuN3e6oz1w@mail.gmail.com>
 <20190624102209.ngwtosgr5fvp3ler@willie-the-truck>
 <c5be6baa-91aa-c178-6698-c83d4d82a217@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c5be6baa-91aa-c178-6698-c83d4d82a217@jp.fujitsu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Cc: "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
 "hch@infradead.org" <hch@infradead.org>, Atish Patra <Atish.Patra@wdc.com>,
 Julien Grall <julien.grall@arm.com>, Anup Patel <anup.Patel@wdc.com>,
 Guo Ren <guoren@kernel.org>, "gary@garyguo.net" <gary@garyguo.net>,
 Palmer Dabbelt <palmer@sifive.com>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On Thu, Jun 27, 2019 at 09:41:42AM +0000, qi.fuli@fujitsu.com wrote:
> 
> On 6/24/19 7:22 PM, Will Deacon wrote:
> > On Mon, Jun 24, 2019 at 12:35:35AM +0800, Guo Ren wrote:
> >> On Fri, Jun 21, 2019 at 10:16 PM Catalin Marinas
> >> <catalin.marinas@arm.com> wrote:
> >>> On Wed, Jun 19, 2019 at 07:51:03PM +0800, Guo Ren wrote:
> >>>> On Wed, Jun 19, 2019 at 4:54 PM Julien Grall <julien.grall@arm.com> wrote:
> >>>>> On 6/19/19 9:07 AM, Guo Ren wrote:
> >>>>>> Move arm asid allocator code in a generic one is a agood idea, I've
> >>>>>> made a patchset for C-SKY and test is on processing, See:
> >>>>>> https://lore.kernel.org/linux-csky/1560930553-26502-1-git-send-email-guoren@kernel.org/
> >>>>>>
> >>>>>> If you plan to seperate it into generic one, I could co-work with you.
> >>>>> Was the ASID allocator work out of box on C-Sky?
> >>>> Almost done, but one question:
> >>>> arm64 remove the code in switch_mm:
> >>>>    cpumask_clear_cpu(cpu, mm_cpumask(prev));
> >>>>    cpumask_set_cpu(cpu, mm_cpumask(next));
> >>>>
> >>>> Why? Although arm64 cache operations could affect all harts with CTC
> >>>> method of interconnect, I think we should keep these code for
> >>>> primitive integrity in linux. Because cpu_bitmap is in mm_struct
> >>>> instead of mm->context.
> >>> We didn't have a use for this in the arm64 code, so no point in
> >>> maintaining the mm_cpumask. On some arm32 systems (ARMv6) with no
> >>> hardware broadcast of some TLB/cache operations, we use it to track
> >>> where the task has run to issue IPI for TLB invalidation or some
> >>> deferred I-cache invalidation.
> >> The operation of set/clear mm_cpumask was removed in arm64 compared to
> >> arm32. It seems no side effect on current arm64 system, but from
> >> software meaning it's wrong.
> >> I think we should keep mm_cpumask just like arm32.
> > It was a while ago now, but I remember the atomic update of the mm_cpumask
> > being quite expensive when I was profiling this stuff, so I removed it
> > because we don't need it for arm64 (at least, it doesn't allow us to
> > optimise our shootdowns in practice).
> 
> I think mm_cpumask can be used for filtering the cpus that there are TBL 
> entries on.

I'm aware that you want to use IPIs for broadcasting TLB invalidation
but that is only tangentially related to this thread, which is about the
current ASID algorithm and the need to update mm_cpumask today.

Please don't conflate the two threads; I already made my position reasonably
clear:

https://lore.kernel.org/linux-arm-kernel/20190617170328.GJ30800@fuggles.cambridge.arm.com/

I will follow-up with another reply there.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
