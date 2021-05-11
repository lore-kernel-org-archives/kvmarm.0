Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B2CC433B4
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 08:48:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 038C56128E
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 08:48:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 038C56128E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F2F54B3F8;
	Tue, 11 May 2021 04:48:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yNqJo+zzuCfj; Tue, 11 May 2021 04:48:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5BBC4B46F;
	Tue, 11 May 2021 04:48:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A41AF4B415
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 04:48:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id siUYfLeHq0FB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 04:48:11 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E610B4B38A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 04:48:10 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7A48611F1;
 Tue, 11 May 2021 08:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620722889;
 bh=gWeoEHhrz/zhEY+10w21M2EBcdeQNy1sRm5F9WGr5UA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=GRbnl0/2UilceH2n3gUWtOCmaykcXN76OP9Ae7Uw23/BrI59NLKtdCzgbxCSOYUSh
 9GWTEZGaoBaNXA7+PrAnFNeo6jGEmV86hwIH2RowGUMjpM0qFwnTIIVV8p+9HIRDaA
 Qy2o6qVVMa4I+jMXZyQFTtv6iX36HhyoAqc1ttno6RCFFP+8S+vmuGsu3diUc/sBGz
 UZsA2jJQ+nMV262Uq5FFWBRcNGenBZSW0jULJYbSB8958oall/Kr+je5ssNgHnp6IR
 AcdCRzjXaWKlLX7BpeHLO1jKcVZSHwA//b+tQjCvMOb8uBz+fGY4KtW7NBaBWsERgd
 gueWxqRQ5hC/g==
Date: Tue, 11 May 2021 11:48:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
Message-ID: <YJpEwF2cGjS5mKma@kernel.org>
References: <ca5b00bd-1312-0c69-ab69-a1bd749f51b6@huawei.com>
 <YI+XrAg4KOzOyt7c@kernel.org>
 <24b37c01-fc75-d459-6e61-d67e8f0cf043@redhat.com>
 <YI+32ocTbec5Rm4e@kernel.org>
 <82cfbb7f-dd4f-12d8-dc76-847f06172200@huawei.com>
 <b077916e-d3f7-ec6c-8c80-b5b642ee111f@huawei.com>
 <YJUWywpGwOpM8hzo@kernel.org>
 <33c67e13-dc48-9a2f-46d8-a532e17380fb@huawei.com>
 <YJd6QXcmVl+HM4Ob@kernel.org>
 <b91cd653-842b-0e77-5c00-17a0ac9c4b50@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b91cd653-842b-0e77-5c00-17a0ac9c4b50@huawei.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, May 10, 2021 at 11:10:20AM +0800, Kefeng Wang wrote:
>
> > > The memory is not continuous, see MEMBLOCK:
> > >   memory size = 0x4c0fffff reserved size = 0x027ef058
> > >   memory.cnt  = 0xa
> > >   memory[0x0]    [0x80a00000-0x855fffff], 0x04c00000 bytes flags: 0x0
> > >   memory[0x1]    [0x86a00000-0x87dfffff], 0x01400000 bytes flags: 0x0
> > >   memory[0x2]    [0x8bd00000-0x8c4fffff], 0x00800000 bytes flags: 0x0
> > >   memory[0x3]    [0x8e300000-0x8ecfffff], 0x00a00000 bytes flags: 0x0
> > >   memory[0x4]    [0x90d00000-0xbfffffff], 0x2f300000 bytes flags: 0x0
> > >   memory[0x5]    [0xcc000000-0xdc9fffff], 0x10a00000 bytes flags: 0x0
> > >   memory[0x6]    [0xde700000-0xde9fffff], 0x00300000 bytes flags: 0x0
> > > ...
> > > 
> > > The pfn_range [0xde600,0xde700] => addr_range [0xde600000,0xde700000]
> > > is not available memory, and we won't create memmap , so with or without
> > > your patch, we can't see the range in free_memmap(), right?
> > 
> > This is not available memory and we won't see the reange in free_memmap(),
> > but we still should create memmap for it and that's what my patch tried to
> > do.
> > 
> > There are a lot of places in core mm that operate on pageblocks and
> > free_unused_memmap() should make sure that any pageblock has a valid memory
> > map.
> > 
> > Currently, that's not the case when SPARSEMEM=y and my patch tried to fix
> > it.
> > 
> > Can you please send log with my patch applied and with the printing of
> > ranges that are freed in free_unused_memmap() you've used in previous
> > mails?

> with your patch[1] and debug print in free_memmap,
> ----> free_memmap, start_pfn = 85800,  85800000 end_pfn = 86800, 86800000
> ----> free_memmap, start_pfn = 8c800,  8c800000 end_pfn = 8e000, 8e000000
> ----> free_memmap, start_pfn = 8f000,  8f000000 end_pfn = 90000, 90000000
> ----> free_memmap, start_pfn = dcc00,  dcc00000 end_pfn = de400, de400000
> ----> free_memmap, start_pfn = dec00,  dec00000 end_pfn = e0000, e0000000
> ----> free_memmap, start_pfn = e0c00,  e0c00000 end_pfn = e4000, e4000000
> ----> free_memmap, start_pfn = f7000,  f7000000 end_pfn = f8000, f8000000

It seems that freeing of the memory map is suboptimal still because that
code was not designed for memory layout that has more holes than Swiss
cheese. 

Still, the range [0xde600,0xde700] is not freed and there should be struct
pages for this range.

Can you add 

	dump_page(pfn_to_page(0xde600), "");

say, in the end of memblock_free_all()?
 
-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
