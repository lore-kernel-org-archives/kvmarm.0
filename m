Return-Path: <SRS0=NHQQ=I4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F56FC433C1
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 13:15:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A5D7061969
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 13:15:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5D7061969
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44C4E4B312;
	Tue, 30 Mar 2021 09:15:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JutJCGXRa3e7; Tue, 30 Mar 2021 09:15:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C4404B308;
	Tue, 30 Mar 2021 09:15:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12C894B306
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 09:15:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D5brQs8xv+Zi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Mar 2021 09:15:33 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14DAD4B2CF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 09:15:33 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id F35DD600CD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 13:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1617110132;
 bh=jYNEUTXvynh04DROg9mQqri4jkuuAHDVFQ/ifDTw1aU=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=fvE+K9XCmTESjp8RsSNZLoaayk8eWHPMJVEDwwpCiHWnhYat8b+RnIiWwgYj8+Z3j
 bYwLzdXJsxPgQyPRmjKLK112VFZJegYkOW5C0s4uZspBPfE3TVe9QaLK+p6Ev/OpIs
 +HwL+dPO4lYZk5tUsYSDgVEcgnx8hKelzorpjo89v0eQKkBZNqAbXmhigN29StkxFO
 QUa36HJf/I+q4blQGzEPoC0Kul4Qj6skaKfD+f29HN2Iw5PANerZbVzL44SsWCbNuw
 zAVtApPJCzmbTVtGsXqHDdbGFtVsI+1gIjLDSUkJuHt9PxyflaF3XdshYwwq6POTiy
 P/P8aM7UjLO/w==
Received: by mail-ot1-f43.google.com with SMTP id
 k14-20020a9d7dce0000b02901b866632f29so15562546otn.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 06:15:31 -0700 (PDT)
X-Gm-Message-State: AOAM531pGG5Jpq0JXipPwD4qyTQ8Ra5udE0V8F9kA+XcO2NS59iZFEn6
 RxjXwslBdGGLA5Qsa2eVA18eJeKQGQESWtiLyAk=
X-Google-Smtp-Source: ABdhPJxe75+FB/j3ON1xpr+EmfIcZ+jOzQfmkF7Wp0iGHNsGHCCtBZewDZ/ID2liijKOyO7fB8pjFyx5Y2cVl2dgN2c=
X-Received: by 2002:a9d:7ccf:: with SMTP id r15mr16161921otn.108.1617110131343; 
 Tue, 30 Mar 2021 06:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210330112126.463336-1-ardb@kernel.org>
 <87lfa4rety.wl-maz@kernel.org>
 <CAMj1kXEL569SDFAR2PGJhAvJmYMDZm-Aumr0q6g2gnAMC0avxA@mail.gmail.com>
 <87k0pordvw.wl-maz@kernel.org>
In-Reply-To: <87k0pordvw.wl-maz@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 30 Mar 2021 15:15:19 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHx90pOUcG8YyLcvaYdv+2uPSUVy7rBoEu72eQo3xUVKg@mail.gmail.com>
Message-ID: <CAMj1kXHx90pOUcG8YyLcvaYdv+2uPSUVy7rBoEu72eQo3xUVKg@mail.gmail.com>
Subject: Re: [PATCH] arm64: kvm: handle 52-bit VA regions correctly under nVHE
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Android Kernel Team <kernel-team@android.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Tue, 30 Mar 2021 at 15:04, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 30 Mar 2021 13:49:18 +0100,
> Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Tue, 30 Mar 2021 at 14:44, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Tue, 30 Mar 2021 12:21:26 +0100,
> > > Ard Biesheuvel <ardb@kernel.org> wrote:
> > > >
> > > > Commit f4693c2716b35d08 ("arm64: mm: extend linear region for 52-bit VA
> > > > configurations") introduced a new layout for the 52-bit VA space, in
> > > > order to maximize the space available to the linear region. After this
> > > > change, the kernel VA space is no longer split 1:1 down the middle, and
> > > > as it turns out, this violates an assumption in the KVM init code when
> > > > it chooses the layout for the nVHE EL2 mapping.
> > > >
> > > > Given that EFI does not support 52-bit VA addressing (as it only
> > > > supports 4k pages), and that in general, loaders cannot assume that the
> > > > kernel being loaded supports 52-bit VA/PA addressing in the first place,
> > > > we can safely assume that the kernel, and therefore the .idmap section,
> > > > will be 48-bit addressable on 52-bit VA capable systems.
> > > >
> > > > So in this case, organize the nVHE EL2 address space as a 2^48 byte
> > > > window starting at address 0x0, containing the ID map and the
> > > > hypervisor's private mappings, followed by a contiguous 2^52 - 2^48 byte
> > > > linear region. (Note that EL1's linear region is 2^52 - 2^47 bytes in
> > > > size, so it is slightly larger, but this only matters on systems where
> > > > the DRAM footprint in the physical memory map exceeds 3968 TB)
> > >
> > > So if I have memory in the [2^52 - 2^48, 2^52 - 2^47] range, not
> > > necessarily because I have that much memory, but because my system has
> > > multiple memory banks, one of which lands on that spot, I cannot map
> > > such memory at EL2. We'll explode at run time.
> > >
> > > Can we keep the private mapping to 47 bits and restore the missing
> > > chunk to the linear mapping? Of course, it means that the linear map
> > > is now potential no linear anymore, so we'd have to garantee that the
> > > kernel lines in the first 2^47 bits instead. Crap.
> > >
> >
> > Yeah. The linear region needs to be contiguous. Alternatively, we
> > could restrict the upper address limit for loading the kernel to 47
> > bits.
>
> Is that something we can do retroactively? We could mandate it for
> LVA systems only, but that's a bit odd.
>

Yeah, especially given the fact that LVA systems will be VHE capable
and may therefore not care in the first place.

On systems that have memory that high, EFI is likely to load the
kernel there, as it usually allocates from the top down, and it tries
to avoid having to move it around unless asked to (via KASLR), in
which case it will currently randomize over the entire available
memory space.

So it is going to add a special case for a corner^2 case, i.e., nVHE
on 52-bit/64k pages with more than 3968 TB distance between the start
and end of DRAM. Ugh.

It seems to me that the only way to solve this is to permit the idmap
and the hyp linear region to overlap, and use the 2^47 byte window at
the top of the address space for the hyp private mappings instead of
the one at the bottom.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
