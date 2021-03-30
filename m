Return-Path: <SRS0=NHQQ=I4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7DCC433C1
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 12:49:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 51D5C61957
	for <kvmarm@archiver.kernel.org>; Tue, 30 Mar 2021 12:49:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51D5C61957
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C424F4B2C3;
	Tue, 30 Mar 2021 08:49:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5I4gsBmp1A+a; Tue, 30 Mar 2021 08:49:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E87B4B2D5;
	Tue, 30 Mar 2021 08:49:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F6EE4B229
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 08:49:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X3arAmhNFE00 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Mar 2021 08:49:33 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02E5C4B21C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 08:49:32 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B95961957
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 12:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1617108571;
 bh=L8hVxHx3HkTsJOL4dwBkjNIyiKLy0gnVbjHhEZb2/Kg=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=TtAUctKCi63kfOG5bXKlD5oXfrX7rvT12kEK3p63ajGIJKPzQ1XLSMpQQeJXfC8Ux
 OqYVepXtHKs5jurkJV0XH94YGg73af5Fyp/7owhkSfrEuqE8xYQHkbG/2nwe1T3F7O
 s6miWMUdjIagdZNAZ2yY3mx3vXsGjin3zTneirJNjf5mQzs6cV18rBDyV5FEyl7kCV
 rybp+K9Yo7VX5BQdVSVwp+GqAkcrt6O1OhO+L3rpfDzxVaAvFPBSw7JkJo/bOT0D5e
 UE9PpqQYkXKVxTKmMbOLbYfgkU/VBDuRIb1wi+vgm9/wYBAewYGMu8edakokwsd0hE
 ot7ihOvZWkRoA==
Received: by mail-ot1-f44.google.com with SMTP id
 w31-20020a9d36220000b02901f2cbfc9743so15435867otb.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Mar 2021 05:49:31 -0700 (PDT)
X-Gm-Message-State: AOAM532zffDYyKFXbhpkkCJ28kAv3TOGfRVsohgb5X2B6VqLBKITXtWM
 s6TtCDllVzwOp5lVjuXOe8VZy36g7wzG2o9o+/8=
X-Google-Smtp-Source: ABdhPJyEtaUBQEkibi81Ef2Z9bmXCvvIFk+e2LlexKI3NNlX2yfdkNi5cRfI00gUiQmRx/u+UPJrVHM3Um/HoxYfTUE=
X-Received: by 2002:a9d:12cb:: with SMTP id g69mr26379794otg.77.1617108570384; 
 Tue, 30 Mar 2021 05:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210330112126.463336-1-ardb@kernel.org>
 <87lfa4rety.wl-maz@kernel.org>
In-Reply-To: <87lfa4rety.wl-maz@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 30 Mar 2021 14:49:18 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEL569SDFAR2PGJhAvJmYMDZm-Aumr0q6g2gnAMC0avxA@mail.gmail.com>
Message-ID: <CAMj1kXEL569SDFAR2PGJhAvJmYMDZm-Aumr0q6g2gnAMC0avxA@mail.gmail.com>
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

On Tue, 30 Mar 2021 at 14:44, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 30 Mar 2021 12:21:26 +0100,
> Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > Commit f4693c2716b35d08 ("arm64: mm: extend linear region for 52-bit VA
> > configurations") introduced a new layout for the 52-bit VA space, in
> > order to maximize the space available to the linear region. After this
> > change, the kernel VA space is no longer split 1:1 down the middle, and
> > as it turns out, this violates an assumption in the KVM init code when
> > it chooses the layout for the nVHE EL2 mapping.
> >
> > Given that EFI does not support 52-bit VA addressing (as it only
> > supports 4k pages), and that in general, loaders cannot assume that the
> > kernel being loaded supports 52-bit VA/PA addressing in the first place,
> > we can safely assume that the kernel, and therefore the .idmap section,
> > will be 48-bit addressable on 52-bit VA capable systems.
> >
> > So in this case, organize the nVHE EL2 address space as a 2^48 byte
> > window starting at address 0x0, containing the ID map and the
> > hypervisor's private mappings, followed by a contiguous 2^52 - 2^48 byte
> > linear region. (Note that EL1's linear region is 2^52 - 2^47 bytes in
> > size, so it is slightly larger, but this only matters on systems where
> > the DRAM footprint in the physical memory map exceeds 3968 TB)
>
> So if I have memory in the [2^52 - 2^48, 2^52 - 2^47] range, not
> necessarily because I have that much memory, but because my system has
> multiple memory banks, one of which lands on that spot, I cannot map
> such memory at EL2. We'll explode at run time.
>
> Can we keep the private mapping to 47 bits and restore the missing
> chunk to the linear mapping? Of course, it means that the linear map
> is now potential no linear anymore, so we'd have to garantee that the
> kernel lines in the first 2^47 bits instead. Crap.
>

Yeah. The linear region needs to be contiguous. Alternatively, we
could restrict the upper address limit for loading the kernel to 47
bits.

> >
> > Fixes: f4693c2716b35d08 ("arm64: mm: extend linear region for 52-bit VA configurations")
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  Documentation/arm64/booting.rst |  6 +++---
> >  arch/arm64/kvm/va_layout.c      | 18 ++++++++++++++----
> >  2 files changed, 17 insertions(+), 7 deletions(-)
> >
> > diff --git a/Documentation/arm64/booting.rst b/Documentation/arm64/booting.rst
> > index 7552dbc1cc54..418ec9b63d2c 100644
> > --- a/Documentation/arm64/booting.rst
> > +++ b/Documentation/arm64/booting.rst
> > @@ -121,8 +121,8 @@ Header notes:
> >                         to the base of DRAM, since memory below it is not
> >                         accessible via the linear mapping
> >                       1
> > -                       2MB aligned base may be anywhere in physical
> > -                       memory
> > +                       2MB aligned base may be anywhere in the 48-bit
> > +                       addressable physical memory region
> >    Bits 4-63  Reserved.
> >    ============= ===============================================================
> >
> > @@ -132,7 +132,7 @@ Header notes:
> >    depending on selected features, and is effectively unbound.
> >
> >  The Image must be placed text_offset bytes from a 2MB aligned base
> > -address anywhere in usable system RAM and called there. The region
> > +address in 48-bit addressable system RAM and called there. The region
> >  between the 2 MB aligned base address and the start of the image has no
> >  special significance to the kernel, and may be used for other purposes.
> >  At least image_size bytes from the start of the image must be free for
> > diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
> > index 978301392d67..e9ab449de197 100644
> > --- a/arch/arm64/kvm/va_layout.c
> > +++ b/arch/arm64/kvm/va_layout.c
> > @@ -62,9 +62,19 @@ __init void kvm_compute_layout(void)
> >       phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
> >       u64 hyp_va_msb;
> >
> > -     /* Where is my RAM region? */
> > -     hyp_va_msb  = idmap_addr & BIT(vabits_actual - 1);
> > -     hyp_va_msb ^= BIT(vabits_actual - 1);
> > +     /*
> > +      * On LVA capable hardware, the kernel is guaranteed to reside
> > +      * in the 48-bit addressable part of physical memory, and so
> > +      * the idmap will be located there as well. Put the EL2 linear
> > +      * region right after it, where it can grow upward to fill the
> > +      * entire 52-bit VA region.
> > +      */
> > +     if (vabits_actual > VA_BITS_MIN) {
> > +             hyp_va_msb = BIT(VA_BITS_MIN);
> > +     } else {
> > +             hyp_va_msb  = idmap_addr & BIT(vabits_actual - 1);
> > +             hyp_va_msb ^= BIT(vabits_actual - 1);
> > +     }
> >
> >       tag_lsb = fls64((u64)phys_to_virt(memblock_start_of_DRAM()) ^
> >                       (u64)(high_memory - 1));
> > @@ -72,7 +82,7 @@ __init void kvm_compute_layout(void)
> >       va_mask = GENMASK_ULL(tag_lsb - 1, 0);
> >       tag_val = hyp_va_msb;
> >
> > -     if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && tag_lsb != (vabits_actual - 1)) {
> > +     if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && tag_lsb < (vabits_actual - 1)) {
> >               /* We have some free bits to insert a random tag. */
> >               tag_val |= get_random_long() & GENMASK_ULL(vabits_actual - 2, tag_lsb);
> >       }
>
> It seems __create_hyp_private mapping() still refers to (VA_BITS - 1)
> to choose where to allocate the IO mappings, and
> __pkvm_create_private_mapping() relies on similar things based on what
> hyp_create_idmap().
>

That was probably broken already then, given that it should refer to
vabits_actual. I'll address that in a separate patch.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
