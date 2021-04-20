Return-Path: <SRS0=sayA=JR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA7EC433B4
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 15:03:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 22C6F610A1
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 15:03:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22C6F610A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AB6D4B3C3;
	Tue, 20 Apr 2021 11:03:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nLWklqki-RRK; Tue, 20 Apr 2021 11:03:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 781CE4B3C6;
	Tue, 20 Apr 2021 11:03:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C79A04B3C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 11:03:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G7XUm77yJ76o for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Apr 2021 11:03:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BDCA84B3C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 11:03:22 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB1B9610A1;
 Tue, 20 Apr 2021 15:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1618930999;
 bh=j2AhiOXhAEFdSXlVtOmuTch74/ss0CH34AqlDj2lObw=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=rghGQ4Jms/10w+c2YUoA0xR7pEvFY+pxR5xN1nGHNOtIWuVhOZjS4OjDGWh0wTPzI
 RUuP17zgJlqsGRhFIpV2eRuid/0uqrYF74K5VpG4lVFZWkqrPIcbIkHikAMeITJKVU
 WhjGYkyswCKkggInHbmvW57ScJAZxQ3UUloLx6rEPnUsWD6H6pql50reuV5IONOLNM
 seMsNftgoixkTpCGEgvGDiOb+PlXgfV+0OMBu9tnscaCRp61/9BC0qt1zQ9w1w4Rdr
 1n0zGLpmgjzZrjQpdUQCNSL1blMLFdzLl/ObWLC+ohd+RDp4p1ZkAn5AS3/acz9zlU
 /SNxFd6Pbb/Jg==
Date: Tue, 20 Apr 2021 18:03:11 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v1 2/4] memblock: update initialization of reserved pages
Message-ID: <YH7tL77Z9UzTAFca@kernel.org>
References: <20210420090925.7457-1-rppt@kernel.org>
 <20210420090925.7457-3-rppt@kernel.org>
 <ed8f10a0-9b68-1d12-0305-90fd378af6b9@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ed8f10a0-9b68-1d12-0305-90fd378af6b9@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
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

On Tue, Apr 20, 2021 at 03:56:28PM +0200, David Hildenbrand wrote:
> On 20.04.21 11:09, Mike Rapoport wrote:
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > The struct pages representing a reserved memory region are initialized
> > using reserve_bootmem_range() function. This function is called for each
> > reserved region just before the memory is freed from memblock to the buddy
> > page allocator.
> > 
> > The struct pages for MEMBLOCK_NOMAP regions are kept with the default
> > values set by the memory map initialization which makes it necessary to
> > have a special treatment for such pages in pfn_valid() and
> > pfn_valid_within().
> 
> Just a general question while thinking about it:
> 
> Would we right now initialize the memmap of these pages already via
> memmap_init_zone()->memmap_init_range()? (IOW, not marking the
> PageReserved?)

Yep. These pages are part of memblock.memory so they are initialized in
memmap_init_zone()->memmap_init_range() to the default values.

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
