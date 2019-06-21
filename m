Return-Path: <SRS0=LUtr=UU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C142C43613
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 14:16:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B8D62083B
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 14:16:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B8D62083B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ACFE4A4F3;
	Fri, 21 Jun 2019 10:16:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uy-ZfY4YvrzM; Fri, 21 Jun 2019 10:16:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66E1A4A4F9;
	Fri, 21 Jun 2019 10:16:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 386AC4A4F6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 10:16:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ip-L7geAFDyM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Jun 2019 10:16:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E03B94A4F3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 10:16:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55BFB28;
 Fri, 21 Jun 2019 07:16:12 -0700 (PDT)
Received: from arrakis.emea.arm.com (arrakis.cambridge.arm.com [10.1.196.78])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 D8FA43F575; Fri, 21 Jun 2019 07:16:09 -0700 (PDT)
Date: Fri, 21 Jun 2019 15:16:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
Message-ID: <20190621141606.GF18954@arrakis.emea.arm.com>
References: <20190321163623.20219-1-julien.grall@arm.com>
 <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
 <CAJF2gTStSR7Jmu7=HaO5Wxz=Zn8A5-RD8ktori3oKEhM9vozAA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJF2gTStSR7Jmu7=HaO5Wxz=Zn8A5-RD8ktori3oKEhM9vozAA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: aou@eecs.berkeley.edu, Marc Zyngier <marc.zyngier@arm.com>,
 Anup Patel <anup.Patel@wdc.com>, will.deacon@arm.com,
 linux-kernel@vger.kernel.org, rppt@linux.ibm.com, hch@infradead.org,
 Atish.Patra@wdc.com, Julien Grall <julien.grall@arm.com>,
 Palmer Dabbelt <palmer@sifive.com>, gary@garyguo.net, paul.walmsley@sifive.com,
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

On Wed, Jun 19, 2019 at 07:51:03PM +0800, Guo Ren wrote:
> On Wed, Jun 19, 2019 at 4:54 PM Julien Grall <julien.grall@arm.com> wrote:
> > On 6/19/19 9:07 AM, Guo Ren wrote:
> > > Move arm asid allocator code in a generic one is a agood idea, I've
> > > made a patchset for C-SKY and test is on processing, See:
> > > https://lore.kernel.org/linux-csky/1560930553-26502-1-git-send-email-guoren@kernel.org/
> > >
> > > If you plan to seperate it into generic one, I could co-work with you.
> >
> > Was the ASID allocator work out of box on C-Sky?
> 
> Almost done, but one question:
> arm64 remove the code in switch_mm:
>   cpumask_clear_cpu(cpu, mm_cpumask(prev));
>   cpumask_set_cpu(cpu, mm_cpumask(next));
> 
> Why? Although arm64 cache operations could affect all harts with CTC
> method of interconnect, I think we should keep these code for
> primitive integrity in linux. Because cpu_bitmap is in mm_struct
> instead of mm->context.

We didn't have a use for this in the arm64 code, so no point in
maintaining the mm_cpumask. On some arm32 systems (ARMv6) with no
hardware broadcast of some TLB/cache operations, we use it to track
where the task has run to issue IPI for TLB invalidation or some
deferred I-cache invalidation.

(there was also a potential optimisation on arm64 to avoid broadcast
TLBI if the task only ran on a single CPU but Will found that was rarely
the case on an SMP system because of rebalancing happening during
execve(), ending up with two bits set in the mm_cpumask)

The way you use it on csky is different from how it is done on arm. It
seems to clear the mask for the scheduled out (prev) task but this
wouldn't work on arm(64) since the TLB still contains prev entries
tagged with the scheduled out ASID. Whether it matters, I guess it
depends on the specifics of your hardware.

While the algorithm may seem fairly generic, the semantics have a few
corner cases specific to each architecture. See [1] for a description of
the semantics we need on arm64 (CnP is a feature where the hardware
threads of the same core can share the TLB; the original algorithm
violated the requirements when this feature was enabled).

BTW, if you find the algorithm fairly straightforward ;), see this
bug-fix which took a formal model to identify: a8ffaaa060b8 ("arm64:
asid: Do not replace active_asids if already 0").

[1] https://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/kernel-tla.git/tree/asidalloc.tla#n79

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
