Return-Path: <SRS0=87+N=UX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AA8C43613
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jun 2019 11:20:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A278212F5
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jun 2019 11:20:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="JwiHHdW7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A278212F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA2C24A4A9;
	Mon, 24 Jun 2019 07:20:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MClT2lvr09-E; Mon, 24 Jun 2019 07:20:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0CFF4A4F0;
	Mon, 24 Jun 2019 07:20:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DD944A4E1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jun 2019 06:22:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DwzyIJEIuaV6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jun 2019 06:22:17 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFE1B4A4CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jun 2019 06:22:17 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 691F9208E4;
 Mon, 24 Jun 2019 10:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1561371736;
 bh=d4H3ytDN4+6bzOFsrB7H72D5xnyH2d7DzxF9eKjN0sY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=JwiHHdW7tU89KwjK81T7yWoMzvqANGQZczB5UCgT2eBTMTSj/2WtBXwPLu9Bm31O5
 r/b9kyNOheWOPU6eueHBoKQB11SLCVWYnVhoKTq/4mVb1bd1PgiaqOudYcyxSqF2PT
 S4tMcKDxPqFg/3U3pumEBb3BDhOvWlvqmdZEXn2I=
Date: Mon, 24 Jun 2019 11:22:10 +0100
From: Will Deacon <will@kernel.org>
To: Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
Message-ID: <20190624102209.ngwtosgr5fvp3ler@willie-the-truck>
References: <20190321163623.20219-1-julien.grall@arm.com>
 <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
 <CAJF2gTStSR7Jmu7=HaO5Wxz=Zn8A5-RD8ktori3oKEhM9vozAA@mail.gmail.com>
 <20190621141606.GF18954@arrakis.emea.arm.com>
 <CAJF2gTTVUToRkRtxTmtWDotMGXy5YQCpL1h_2neTBuN3e6oz1w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJF2gTTVUToRkRtxTmtWDotMGXy5YQCpL1h_2neTBuN3e6oz1w@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Mailman-Approved-At: Mon, 24 Jun 2019 07:20:08 -0400
Cc: Julien Grall <julien.grall@arm.com>, aou@eecs.berkeley.edu,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
 rppt@linux.ibm.com, hch@infradead.org, Atish Patra <Atish.Patra@wdc.com>,
 Anup Patel <anup.Patel@wdc.com>, gary@garyguo.net,
 Palmer Dabbelt <palmer@sifive.com>, paul.walmsley@sifive.com,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
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

On Mon, Jun 24, 2019 at 12:35:35AM +0800, Guo Ren wrote:
> On Fri, Jun 21, 2019 at 10:16 PM Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> >
> > On Wed, Jun 19, 2019 at 07:51:03PM +0800, Guo Ren wrote:
> > > On Wed, Jun 19, 2019 at 4:54 PM Julien Grall <julien.grall@arm.com> wrote:
> > > > On 6/19/19 9:07 AM, Guo Ren wrote:
> > > > > Move arm asid allocator code in a generic one is a agood idea, I've
> > > > > made a patchset for C-SKY and test is on processing, See:
> > > > > https://lore.kernel.org/linux-csky/1560930553-26502-1-git-send-email-guoren@kernel.org/
> > > > >
> > > > > If you plan to seperate it into generic one, I could co-work with you.
> > > >
> > > > Was the ASID allocator work out of box on C-Sky?
> > >
> > > Almost done, but one question:
> > > arm64 remove the code in switch_mm:
> > >   cpumask_clear_cpu(cpu, mm_cpumask(prev));
> > >   cpumask_set_cpu(cpu, mm_cpumask(next));
> > >
> > > Why? Although arm64 cache operations could affect all harts with CTC
> > > method of interconnect, I think we should keep these code for
> > > primitive integrity in linux. Because cpu_bitmap is in mm_struct
> > > instead of mm->context.
> >
> > We didn't have a use for this in the arm64 code, so no point in
> > maintaining the mm_cpumask. On some arm32 systems (ARMv6) with no
> > hardware broadcast of some TLB/cache operations, we use it to track
> > where the task has run to issue IPI for TLB invalidation or some
> > deferred I-cache invalidation.
> The operation of set/clear mm_cpumask was removed in arm64 compared to
> arm32. It seems no side effect on current arm64 system, but from
> software meaning it's wrong.
> I think we should keep mm_cpumask just like arm32.

It was a while ago now, but I remember the atomic update of the mm_cpumask
being quite expensive when I was profiling this stuff, so I removed it
because we don't need it for arm64 (at least, it doesn't allow us to
optimise our shootdowns in practice).

I still think this is over-engineered for what you want on c-sky and making
this code generic is a mistake.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
