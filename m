Return-Path: <SRS0=NHQQ=I4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3FC6C433C1
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 13:58:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4602E619BD
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 13:58:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4602E619BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C48554B2D9;
	Tue, 30 Mar 2021 09:58:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HodMnmaOawN4; Tue, 30 Mar 2021 09:58:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EB044B2B7;
	Tue, 30 Mar 2021 09:58:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89EBD4B25A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 09:58:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OJBnouvHMJuY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Mar 2021 09:58:52 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47B014B1F3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 09:58:52 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37A9D619C5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 13:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1617112731;
 bh=JI5r4iWTMzxxKpkwgR4DRqrrUttY99LSCCRr8pO9zJo=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=SRZB/WSZVB1DtDWpbCJYlkwnOpsxO4EFGHgokwfFBmWT7skjN9036ONZxIivBLMj8
 q5t8USuEoG/EOux8AxqGCbc1f8mL2ZaF6UBa1baKje5VOUdOOgkNcNoFUasKdAVDjq
 ieWlzA/x2Q5S2PQz5PLbhyEHNPfnWUVNBhGtc9HMCiaA8axrn8WtcrC0i5lFM+7ZoM
 9HLfqAj0k+iCwrJAoYJR+VhHZwXhJeie2nl3unQUGsHaSCqS0LyONHlpAwPUXPl1to
 3npK+pnYl4zw8Ha1nifKvk9Hnxa+8i6gqMTy0vTOtasg8jSheyImcQ+ZaPWy1ZvonS
 YgmbuDlFH+qNw==
Received: by mail-ot1-f49.google.com with SMTP id
 t23-20020a0568301e37b02901b65ab30024so15670895otr.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 06:58:51 -0700 (PDT)
X-Gm-Message-State: AOAM530x9OM2unzO3jx9ltPw+R/Bh9r1pivp7z3yM8Sr3cpO9L/ZODeJ
 8uIUstsN7jPcQ2p03CbaHtxMhZXgaiKnRftrTpM=
X-Google-Smtp-Source: ABdhPJx0qXhgaKk+0VdO9uqOrfe4HJZve+o+5OMq+oKFXAO57vSIqmfiiupQDBGCWmerq3c6+ds8Ng18c+rJFHJVoYk=
X-Received: by 2002:a9d:12cb:: with SMTP id g69mr26636532otg.77.1617112730554; 
 Tue, 30 Mar 2021 06:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210330112126.463336-1-ardb@kernel.org>
 <87lfa4rety.wl-maz@kernel.org>
 <CAMj1kXEL569SDFAR2PGJhAvJmYMDZm-Aumr0q6g2gnAMC0avxA@mail.gmail.com>
 <87k0pordvw.wl-maz@kernel.org>
 <CAMj1kXHx90pOUcG8YyLcvaYdv+2uPSUVy7rBoEu72eQo3xUVKg@mail.gmail.com>
 <87h7ksrbih.wl-maz@kernel.org>
In-Reply-To: <87h7ksrbih.wl-maz@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 30 Mar 2021 15:58:39 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHNHV8aoKykjE1mcsCLc9jfnZ5z1RLS0xdF8pM9XFFpZQ@mail.gmail.com>
Message-ID: <CAMj1kXHNHV8aoKykjE1mcsCLc9jfnZ5z1RLS0xdF8pM9XFFpZQ@mail.gmail.com>
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

On Tue, 30 Mar 2021 at 15:56, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 30 Mar 2021 14:15:19 +0100,
> Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Tue, 30 Mar 2021 at 15:04, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Tue, 30 Mar 2021 13:49:18 +0100,
> > > Ard Biesheuvel <ardb@kernel.org> wrote:
> > > >
> > > > On Tue, 30 Mar 2021 at 14:44, Marc Zyngier <maz@kernel.org> wrote:
> > > > >
> > > > > On Tue, 30 Mar 2021 12:21:26 +0100,
> > > > > Ard Biesheuvel <ardb@kernel.org> wrote:
> > > > > >
> > > > > > Commit f4693c2716b35d08 ("arm64: mm: extend linear region for 52-bit VA
> > > > > > configurations") introduced a new layout for the 52-bit VA space, in
> > > > > > order to maximize the space available to the linear region. After this
> > > > > > change, the kernel VA space is no longer split 1:1 down the middle, and
> > > > > > as it turns out, this violates an assumption in the KVM init code when
> > > > > > it chooses the layout for the nVHE EL2 mapping.
> > > > > >
> > > > > > Given that EFI does not support 52-bit VA addressing (as it only
> > > > > > supports 4k pages), and that in general, loaders cannot assume that the
> > > > > > kernel being loaded supports 52-bit VA/PA addressing in the first place,
> > > > > > we can safely assume that the kernel, and therefore the .idmap section,
> > > > > > will be 48-bit addressable on 52-bit VA capable systems.
> > > > > >
> > > > > > So in this case, organize the nVHE EL2 address space as a 2^48 byte
> > > > > > window starting at address 0x0, containing the ID map and the
> > > > > > hypervisor's private mappings, followed by a contiguous 2^52 - 2^48 byte
> > > > > > linear region. (Note that EL1's linear region is 2^52 - 2^47 bytes in
> > > > > > size, so it is slightly larger, but this only matters on systems where
> > > > > > the DRAM footprint in the physical memory map exceeds 3968 TB)
> > > > >
> > > > > So if I have memory in the [2^52 - 2^48, 2^52 - 2^47] range, not
> > > > > necessarily because I have that much memory, but because my system has
> > > > > multiple memory banks, one of which lands on that spot, I cannot map
> > > > > such memory at EL2. We'll explode at run time.
> > > > >
> > > > > Can we keep the private mapping to 47 bits and restore the missing
> > > > > chunk to the linear mapping? Of course, it means that the linear map
> > > > > is now potential no linear anymore, so we'd have to garantee that the
> > > > > kernel lines in the first 2^47 bits instead. Crap.
> > > > >
> > > >
> > > > Yeah. The linear region needs to be contiguous. Alternatively, we
> > > > could restrict the upper address limit for loading the kernel to 47
> > > > bits.
> > >
> > > Is that something we can do retroactively? We could mandate it for
> > > LVA systems only, but that's a bit odd.
> > >
> >
> > Yeah, especially given the fact that LVA systems will be VHE capable
> > and may therefore not care in the first place.
> >
> > On systems that have memory that high, EFI is likely to load the
> > kernel there, as it usually allocates from the top down, and it tries
> > to avoid having to move it around unless asked to (via KASLR), in
> > which case it will currently randomize over the entire available
> > memory space.
> >
> > So it is going to add a special case for a corner^2 case, i.e., nVHE
> > on 52-bit/64k pages with more than 3968 TB distance between the start
> > and end of DRAM. Ugh.
>
> Yeah. I'd rather we ignore that memory altogether, but I don't think
> we can.
>
> > It seems to me that the only way to solve this is to permit the idmap
> > and the hyp linear region to overlap, and use the 2^47 byte window at
> > the top of the address space for the hyp private mappings instead of
> > the one at the bottom.
>
> But that's the hard problem I want to avoid thinking of.
>
> We need to ensure that there is no EL1 VA that is congruent with the
> idmap over the kern_hyp_va() transformation. It means imposing
> restrictions over the EL1 linear map, and prevent any allocation that
> would result in this overlap (and that is including text).
>
> How do we do that?
>

A phys to virt offset of 0x0 is perfectly acceptable, no? The only
difference is that the idmapped bits are in another part of the VA
space.

> Frankly, I think we need to start looking into enabling VHE for the
> nVHE /behaviour/. Having a single TTBR on these systems is just
> insane.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
