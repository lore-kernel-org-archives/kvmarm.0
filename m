Return-Path: <SRS0=w4A1=J6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B093C43461
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 08:44:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9514F61221
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 08:44:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9514F61221
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 168774B394;
	Mon,  3 May 2021 04:44:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8hSIr-ij3aDF; Mon,  3 May 2021 04:44:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF7A14B377;
	Mon,  3 May 2021 04:44:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB0B84B377
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 04:44:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mKCvej1nKzRN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 May 2021 04:44:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 868964B376
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 04:44:26 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD14B610EA;
 Mon,  3 May 2021 08:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620031465;
 bh=ayNupM3q5p2pA01eseLR8Dv+rDUcAmtcqGwl5AQ6O2k=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=f0mYXgd4+L6ElyJNZknXe3/27PpgI89ZAmo86Oo4Jh3B2bGUBoxOcR0uTAMwEH42P
 NRNWtYOMGR2ig6xRKT6656l72sNDNMGgG9hqtDUEy8BBcdk//kuvaH+acF5uh8tTsC
 QgsVPqfImbiGiTIo2EqQs4UGludApb8J0jFv0y3dmZ7/W/gVgXowjEJ3RKmLCIYsbZ
 sWxNbolPcs6NXVZczlnCV7WNJzUGXU45ZN7NoZvYUzdp+JM+uEumnuJiLL3zfAREMa
 +SbRCvNmMD+sE2VHxro6dsvN/Q2vzTHIGwhN/5RQfz3IC1cvDC15rPef4cWPSu6W20
 xCKxVUWPMoB/A==
Date: Mon, 3 May 2021 11:44:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
Message-ID: <YI+32ocTbec5Rm4e@kernel.org>
References: <YIet5X7lgygD9rpZ@kernel.org>
 <259d14df-a713-72e7-4ccb-c06a8ee31e13@huawei.com>
 <YIj5zcbHBHt7CC8B@kernel.org>
 <6ad2956c-70ae-c423-ed7d-88e94c88060f@huawei.com>
 <YIpY8TXCSc7Lfa2Z@kernel.org>
 <0cb013e4-1157-f2fa-96ec-e69e60833f72@huawei.com>
 <YIvTM5Yqit8AB4W8@kernel.org>
 <ca5b00bd-1312-0c69-ab69-a1bd749f51b6@huawei.com>
 <YI+XrAg4KOzOyt7c@kernel.org>
 <24b37c01-fc75-d459-6e61-d67e8f0cf043@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <24b37c01-fc75-d459-6e61-d67e8f0cf043@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
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

On Mon, May 03, 2021 at 10:07:01AM +0200, David Hildenbrand wrote:
> On 03.05.21 08:26, Mike Rapoport wrote:
> > On Fri, Apr 30, 2021 at 07:24:37PM +0800, Kefeng Wang wrote:
> > > =

> > > =

> > > On 2021/4/30 17:51, Mike Rapoport wrote:
> > > > On Thu, Apr 29, 2021 at 06:22:55PM +0800, Kefeng Wang wrote:
> > > > > =

> > > > > On 2021/4/29 14:57, Mike Rapoport wrote:
> > > > > =

> > > > > > > > Do you use SPARSMEM? If yes, what is your section size?
> > > > > > > > What is the value if CONFIG_FORCE_MAX_ZONEORDER in your con=
figuration?
> > > > > > > Yes,
> > > > > > > =

> > > > > > > CONFIG_SPARSEMEM=3Dy
> > > > > > > =

> > > > > > > CONFIG_SPARSEMEM_STATIC=3Dy
> > > > > > > =

> > > > > > > CONFIG_FORCE_MAX_ZONEORDER =3D 11
> > > > > > > =

> > > > > > > CONFIG_PAGE_OFFSET=3D0xC0000000
> > > > > > > CONFIG_HAVE_ARCH_PFN_VALID=3Dy
> > > > > > > CONFIG_HIGHMEM=3Dy
> > > > > > > #define SECTION_SIZE_BITS    26
> > > > > > > #define MAX_PHYSADDR_BITS    32
> > > > > > > #define MAX_PHYSMEM_BITS     32
> > > > > =

> > > > > =

> > > > > With the patch,=A0 the addr is aligned, but the panic still occur=
red,
> > > > =

> > > > Is this the same panic at move_freepages() for range [de600, de7ff]?
> > > > =

> > > > Do you enable CONFIG_ARM_LPAE?
> > > =

> > > no, the CONFIG_ARM_LPAE is not set, and yes with same panic at
> > > move_freepages at
> > > =

> > > start_pfn/end_pfn [de600, de7ff], [de600000, de7ff000] :  pfn =3Dde60=
0, page
> > > =3Def3cc000, page-flags =3D ffffffff,  pfn2phy =3D de600000
> > > =

> > > > > __free_memory_core, range: 0xb0200000 - 0xc0000000, pfn: b0200 - =
b0200
> > > > > __free_memory_core, range: 0xcc000000 - 0xdca00000, pfn: cc000 - =
b0200
> > > > > __free_memory_core, range: 0xde700000 - 0xdea00000, pfn: de700 - =
b0200
> > =

> > Hmm, [de600, de7ff] is not added to the free lists which is correct. But
> > then it's unclear how the page for de600 gets to move_freepages()...
> > =

> > Can't say I have any bright ideas to try here...
> =

> Are we missing some checks (e.g., PageReserved()) that pfn_valid_within()
> would have "caught" before?

Unless I'm missing something the crash happens in __rmqueue_fallback():

do_steal:
	page =3D get_page_from_free_area(area, fallback_mt);

	steal_suitable_fallback(zone, page, alloc_flags, start_migratetype,
								can_steal);
		-> move_freepages() =

			-> BUG()

So a page from free area should be sane as the freed range was never added
it to the free lists.

And honestly, with the memory layout reported elsewhere in the stack I'd
say that the bootloader/fdt beg for fixes...

-- =

Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
