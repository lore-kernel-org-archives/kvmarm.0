Return-Path: <SRS0=jLK7=UW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BF9C43613
	for <kvmarm@archiver.kernel.org>; Sun, 23 Jun 2019 16:35:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 212AE206BA
	for <kvmarm@archiver.kernel.org>; Sun, 23 Jun 2019 16:35:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="WoTik3i7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 212AE206BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A38C74A580;
	Sun, 23 Jun 2019 12:35:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M2kTebJEBc+f; Sun, 23 Jun 2019 12:35:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BD1E4A574;
	Sun, 23 Jun 2019 12:35:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB7214A571
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Jun 2019 12:35:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Pn+OWqyq28Y for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Jun 2019 12:35:50 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E6974A54C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Jun 2019 12:35:50 -0400 (EDT)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B6675214C6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Jun 2019 16:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1561307749;
 bh=f4wzwRqVtnbeGMbGLTUq9DbopFJOpD4awTGdr8HMu0c=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=WoTik3i7uVOtG9x3r9i96Ag9GXjA5+USAyJht8X/qBPra0PBApIG8JI9f6E8NDiSi
 CHO/c4Hsn/R99/LCKEtYzlnwWDJLEtQdF65WJ9f4axQZIsz8xhsXyuPzsiaPPUciq0
 ifLAnqxrMbQFdaTEKtPF9Oo8vcgcRee+CxrRPVIA=
Received: by mail-wm1-f44.google.com with SMTP id s15so10958621wmj.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Jun 2019 09:35:48 -0700 (PDT)
X-Gm-Message-State: APjAAAU0Ryc8FeXt1ledP5r8MHl7ajkqskX+J+96ZwxEoZzi9BZ1a6ri
 49g0i9YezdZAYPNGxfTBFIa5v0+O9/wy9HzfpT0=
X-Google-Smtp-Source: APXvYqytV0iot533SQYILeur1ABvpdvSmQ61FQnlhf7mWoX4c7AKw6SIGZCm/OWATKrhGhf7ydEFv29PmbNlV0vRGhM=
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr12259887wmj.79.1561307747231; 
 Sun, 23 Jun 2019 09:35:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190321163623.20219-1-julien.grall@arm.com>
 <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
 <CAJF2gTStSR7Jmu7=HaO5Wxz=Zn8A5-RD8ktori3oKEhM9vozAA@mail.gmail.com>
 <20190621141606.GF18954@arrakis.emea.arm.com>
In-Reply-To: <20190621141606.GF18954@arrakis.emea.arm.com>
From: Guo Ren <guoren@kernel.org>
Date: Mon, 24 Jun 2019 00:35:35 +0800
X-Gmail-Original-Message-ID: <CAJF2gTTVUToRkRtxTmtWDotMGXy5YQCpL1h_2neTBuN3e6oz1w@mail.gmail.com>
Message-ID: <CAJF2gTTVUToRkRtxTmtWDotMGXy5YQCpL1h_2neTBuN3e6oz1w@mail.gmail.com>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: aou@eecs.berkeley.edu, Marc Zyngier <marc.zyngier@arm.com>,
 Anup Patel <anup.Patel@wdc.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, rppt@linux.ibm.com, hch@infradead.org,
 Atish Patra <Atish.Patra@wdc.com>, Julien Grall <julien.grall@arm.com>,
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

Thx Catalin,

On Fri, Jun 21, 2019 at 10:16 PM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> On Wed, Jun 19, 2019 at 07:51:03PM +0800, Guo Ren wrote:
> > On Wed, Jun 19, 2019 at 4:54 PM Julien Grall <julien.grall@arm.com> wrote:
> > > On 6/19/19 9:07 AM, Guo Ren wrote:
> > > > Move arm asid allocator code in a generic one is a agood idea, I've
> > > > made a patchset for C-SKY and test is on processing, See:
> > > > https://lore.kernel.org/linux-csky/1560930553-26502-1-git-send-email-guoren@kernel.org/
> > > >
> > > > If you plan to seperate it into generic one, I could co-work with you.
> > >
> > > Was the ASID allocator work out of box on C-Sky?
> >
> > Almost done, but one question:
> > arm64 remove the code in switch_mm:
> >   cpumask_clear_cpu(cpu, mm_cpumask(prev));
> >   cpumask_set_cpu(cpu, mm_cpumask(next));
> >
> > Why? Although arm64 cache operations could affect all harts with CTC
> > method of interconnect, I think we should keep these code for
> > primitive integrity in linux. Because cpu_bitmap is in mm_struct
> > instead of mm->context.
>
> We didn't have a use for this in the arm64 code, so no point in
> maintaining the mm_cpumask. On some arm32 systems (ARMv6) with no
> hardware broadcast of some TLB/cache operations, we use it to track
> where the task has run to issue IPI for TLB invalidation or some
> deferred I-cache invalidation.
The operation of set/clear mm_cpumask was removed in arm64 compared to
arm32. It seems no side effect on current arm64 system, but from
software meaning it's wrong.
I think we should keep mm_cpumask just like arm32.

>
> (there was also a potential optimisation on arm64 to avoid broadcast
> TLBI if the task only ran on a single CPU but Will found that was rarely
> the case on an SMP system because of rebalancing happening during
> execve(), ending up with two bits set in the mm_cpumask)
>
> The way you use it on csky is different from how it is done on arm. It
> seems to clear the mask for the scheduled out (prev) task but this
> wouldn't work on arm(64) since the TLB still contains prev entries
> tagged with the scheduled out ASID. Whether it matters, I guess it
> depends on the specifics of your hardware.
Sorry for the mistake quote, what I mean is what is done in arm32:
clear all bits of mm->cpu_mask in new_context(), and set back one by
one. Here is my patch:
https://lore.kernel.org/linux-csky/CAJF2gTQ0xQtQY1t-g9FgWaxfDXppMkFooCQzTFy7+ouwUfyA6w@mail.gmail.com/T/#m2ed464d2dfb45ac6f5547fb3936adf2da456cb65

>
> While the algorithm may seem fairly generic, the semantics have a few
> corner cases specific to each architecture. See [1] for a description of
> the semantics we need on arm64 (CnP is a feature where the hardware
> threads of the same core can share the TLB; the original algorithm
> violated the requirements when this feature was enabled).
C-SKY SMP is only one hart per core, but here is a patch [1] with my
thought on SMT duplicate tlb flush:
[1] https://lore.kernel.org/linux-csky/1561305869-18872-1-git-send-email-guoren@kernel.org/T/#u

For TLA+ model, I still need some learning before I could talk with you.

>
> BTW, if you find the algorithm fairly straightforward ;), see this
> bug-fix which took a formal model to identify: a8ffaaa060b8 ("arm64:
> asid: Do not replace active_asids if already 0").
I think it's one fo the cases that other archs also could get benefit
from arm's asid allocator code.
Btw, Is this detected by arm's aisd allocator TLA+ model ? Or a real
bug report ?

--
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
