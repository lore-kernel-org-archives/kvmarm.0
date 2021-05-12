Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5711AC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 03:51:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A451961554
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 03:51:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A451961554
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 008DD4B485;
	Tue, 11 May 2021 23:51:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i33Wf+vyKkcx; Tue, 11 May 2021 23:51:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83C064B557;
	Tue, 11 May 2021 23:51:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34D6E4B4CB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 23:51:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8TMKloM2lzLe for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 23:51:44 -0400 (EDT)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 771AF4B4A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 23:51:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=aTvKpxfUjpa51UfREN7+HPOb94z389kuVFnSFnj9YgU=; b=tWukLvpVP3mWDqMnudvsVMOPTc
 CmanCzPaqq7vaM/1/jq6bWGBSxQ3KbDbSrx7HXFJbsmPDtkYy4Otxvki0LA5rW70CbgL2eZOF7QvP
 9B7yVLaQD0Hjxcrq7IujWR/L1KaTqkAXO6A4mqboJgFywAHTN0/T0UsT26KwQwny3Ls3Q28LnABN0
 B8BV0mR9rlxHn61P/4eRUggbQ3nQsnWrLywPbuJMq0PKzhrw3nVzQJlTVxJ6t9vNlpVcIDQLtjauW
 6rkqQgGSKWKfH4CGfwBd2PqMSMmKJErqrtglN00r3qEjnwg4Mjl5Xp9NUTYSt3H2fxePeFZjFa00p
 s7nH+zzQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
 Linux)) id 1lgftX-007ukN-UV; Wed, 12 May 2021 03:50:54 +0000
Date: Wed, 12 May 2021 04:50:47 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
Message-ID: <YJtQl3wLUo4msF+Y@casper.infradead.org>
References: <20210421065108.1987-1-rppt@kernel.org>
 <9aa68d26-d736-3b75-4828-f148964eb7f0@huawei.com>
 <YIEl8aKr8Ly0Zd3O@kernel.org>
 <33fa74c2-f32d-f224-eb30-acdb717179ff@huawei.com>
 <2a1592ad-bc9d-4664-fd19-f7448a37edc0@huawei.com>
 <YIUYG8N9T3/C/tSG@kernel.org>
 <52f7d03b-7219-46bc-c62d-b976bc31ebd5@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52f7d03b-7219-46bc-c62d-b976bc31ebd5@huawei.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Mike Rapoport <rppt@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

On Sun, Apr 25, 2021 at 03:51:56PM +0800, Kefeng Wang wrote:
> we see the PC is at PageLRU, same reason like arm64 panic log,
> 
> "PageBuddy in move_freepages returns false Then we call PageLRU, the macro
> calls PF_HEAD which is compound_page() compound_page reads
> page->compound_head, it is 0xffffffffffffffff, so it resturns
> 0xfffffffffffffffe - and accessing this address causes crash"

Oh.  I posted patches to fix this back in 2018.

https://lore.kernel.org/linux-mm/20180414043145.3953-6-willy@infradead.org/

and 2019.

https://lore.kernel.org/linux-mm/20190501202433.GC28500@bombadil.infradead.org/

and 2020.

https://lore.kernel.org/linux-mm/20200408150148.25290-6-willy@infradead.org/

Looks like it's about that time of year for me to try to fix this again.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
