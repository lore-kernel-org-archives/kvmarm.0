Return-Path: <SRS0=w4A1=J6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FBBC433B4
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 06:27:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 14AE661249
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 06:27:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14AE661249
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 828924B394;
	Mon,  3 May 2021 02:27:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nhUFAY6nZ-BN; Mon,  3 May 2021 02:27:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 433174B39F;
	Mon,  3 May 2021 02:27:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DB1D4B39F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 02:27:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TE34GSL-dqJD for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 May 2021 02:27:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 27AED4B394
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 02:27:02 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id A376461185;
 Mon,  3 May 2021 06:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620023221;
 bh=ARgCJkbvRnhDoHk3mV9x6qfowVNrQmhn5MqXTbvPEYU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=JLCHzBplf919bfRjQhdvb086292DMWBVZ45XMSphxu+pcjDiMcckytIgWXw8oIMvl
 z18xh8OtBWrApFxp0Ap7DYavNOBdHbF2GD9xw92gKbbluKtpPRzgQzkjWTt2pRg3Bg
 wBhtw0n2qCbOyCudUIRfXQPYxbJIHPI9r/vQtzoJdLfoqQwsHc3DO0snvF4vcUGdP8
 Mlk/usfjkMj3HVCII0mYn451J74eeuCXvepkDWSRrDg5TugCTJasOKobmY9n9tah12
 TMr62xVdWVrQTTVeIrlfu9AMNqwI3MWcfSfk2gMjdB3lSwvuf6A4yLjtDHYLsFG9my
 ljVCh+EdI3S5w==
Date: Mon, 3 May 2021 09:26:52 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
Message-ID: <YI+XrAg4KOzOyt7c@kernel.org>
References: <YIZNq5HMfJ1rWytv@kernel.org>
 <2d879629-3059-fd42-428f-4b7c2a73d698@huawei.com>
 <YIet5X7lgygD9rpZ@kernel.org>
 <259d14df-a713-72e7-4ccb-c06a8ee31e13@huawei.com>
 <YIj5zcbHBHt7CC8B@kernel.org>
 <6ad2956c-70ae-c423-ed7d-88e94c88060f@huawei.com>
 <YIpY8TXCSc7Lfa2Z@kernel.org>
 <0cb013e4-1157-f2fa-96ec-e69e60833f72@huawei.com>
 <YIvTM5Yqit8AB4W8@kernel.org>
 <ca5b00bd-1312-0c69-ab69-a1bd749f51b6@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ca5b00bd-1312-0c69-ab69-a1bd749f51b6@huawei.com>
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Apr 30, 2021 at 07:24:37PM +0800, Kefeng Wang wrote:
> =

> =

> On 2021/4/30 17:51, Mike Rapoport wrote:
> > On Thu, Apr 29, 2021 at 06:22:55PM +0800, Kefeng Wang wrote:
> > > =

> > > On 2021/4/29 14:57, Mike Rapoport wrote:
> > > =

> > > > > > Do you use SPARSMEM? If yes, what is your section size?
> > > > > > What is the value if CONFIG_FORCE_MAX_ZONEORDER in your configu=
ration?
> > > > > Yes,
> > > > > =

> > > > > CONFIG_SPARSEMEM=3Dy
> > > > > =

> > > > > CONFIG_SPARSEMEM_STATIC=3Dy
> > > > > =

> > > > > CONFIG_FORCE_MAX_ZONEORDER =3D 11
> > > > > =

> > > > > CONFIG_PAGE_OFFSET=3D0xC0000000
> > > > > CONFIG_HAVE_ARCH_PFN_VALID=3Dy
> > > > > CONFIG_HIGHMEM=3Dy
> > > > > #define SECTION_SIZE_BITS    26
> > > > > #define MAX_PHYSADDR_BITS    32
> > > > > #define MAX_PHYSMEM_BITS     32
> > > =

> > > =

> > > With the patch,=A0 the addr is aligned, but the panic still occurred,
> > =

> > Is this the same panic at move_freepages() for range [de600, de7ff]?
> > =

> > Do you enable CONFIG_ARM_LPAE?
> =

> no, the CONFIG_ARM_LPAE is not set, and yes with same panic at
> move_freepages at
> =

> start_pfn/end_pfn [de600, de7ff], [de600000, de7ff000] :  pfn =3Dde600, p=
age
> =3Def3cc000, page-flags =3D ffffffff,  pfn2phy =3D de600000
> =

> > > __free_memory_core, range: 0xb0200000 - 0xc0000000, pfn: b0200 - b0200
> > > __free_memory_core, range: 0xcc000000 - 0xdca00000, pfn: cc000 - b0200
> > > __free_memory_core, range: 0xde700000 - 0xdea00000, pfn: de700 - b0200

Hmm, [de600, de7ff] is not added to the free lists which is correct. But
then it's unclear how the page for de600 gets to move_freepages()...

Can't say I have any bright ideas to try here...

> the __free_memory_core will check the start pfn and end pfn,
> =

>  if (start_pfn >=3D end_pfn)
>          return 0;
> =

>  __free_pages_memory(start_pfn, end_pfn);
> so the memory will not be freed to buddy, confused...

It's a check for range validity, all valid ranges are added.

> > > __free_memory_core, range: 0xe0800000 - 0xe0c00000, pfn: e0800 - b0200
> > > __free_memory_core, range: 0xf4b00000 - 0xf7000000, pfn: f4b00 - b0200
> > > __free_memory_core, range: 0xfda00000 - 0xffffffff, pfn: fda00 - b0200
> > > > It seems that with SPARSEMEM we don't align the freed parts on page=
block
> > > > boundaries.
> > > > =

> > > > Can you try the patch below:
> > > > =

> > > > diff --git a/mm/memblock.c b/mm/memblock.c
> > > > index afaefa8fc6ab..1926369b52ec 100644
> > > > --- a/mm/memblock.c
> > > > +++ b/mm/memblock.c
> > > > @@ -1941,14 +1941,13 @@ static void __init free_unused_memmap(void)
> > > >    		 * due to SPARSEMEM sections which aren't present.
> > > >    		 */
> > > >    		start =3D min(start, ALIGN(prev_end, PAGES_PER_SECTION));
> > > > -#else
> > > > +#endif
> > > >    		/*
> > > >    		 * Align down here since the VM subsystem insists that the
> > > >    		 * memmap entries are valid from the bank start aligned to
> > > >    		 * MAX_ORDER_NR_PAGES.
> > > >    		 */
> > > >    		start =3D round_down(start, MAX_ORDER_NR_PAGES);
> > > > -#endif
> > > >    		/*
> > > >    		 * If we had a previous bank, and there is a space
> > > > =

> > =


-- =

Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
