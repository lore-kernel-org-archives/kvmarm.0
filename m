Return-Path: <SRS0=sayA=JR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8647C43461
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 15:25:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E223D613CF
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 15:25:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E223D613CF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63D704B3CA;
	Tue, 20 Apr 2021 11:25:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D6uVIY2AwvVB; Tue, 20 Apr 2021 11:25:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EE0E4B3C3;
	Tue, 20 Apr 2021 11:25:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F324B3C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 11:25:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wEtWD13SfkKA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Apr 2021 11:25:11 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B99774B3A2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 11:25:11 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 982F161264;
 Tue, 20 Apr 2021 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1618932310;
 bh=MAjswkG1d6uIfyIvGoPH2JcXnT5VvPujn7l2uT7Uvj4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=XWMQKAMU43ygxwHm/tIVp+WpJQapUl0Kd60x6HPlbDjcKHnf74tigDwWzGVjUZtAA
 tSdT+jZGx+d3ZPsKLu+jqBEA39bKT+7+0vr0dhyxEZGCpGlPxkgZ97678lO8WgGG4d
 QgW3tLOkl5mV+MxGBxxN5j8RAFrxIUGHaYegouiIHqIGoy34Dvfl8diR65SAtnm2sr
 Lmm/xaDLwYIOcOCnrqMkGqhYpZmIddlqTjCcrJUYJP4M5Cr95OivNBA3jWrHSClyG2
 NlCodhM9dvGtr9D03VRf+IlIRcvRBQbVUFXaCEmYNLH08BeSOZ5UALddCrzzC0+Eer
 T0ouGAFTRdlJA==
Date: Tue, 20 Apr 2021 18:25:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v1 2/4] memblock: update initialization of reserved pages
Message-ID: <YH7yTahcTVy31Uxk@kernel.org>
References: <20210420090925.7457-1-rppt@kernel.org>
 <20210420090925.7457-3-rppt@kernel.org>
 <ed8f10a0-9b68-1d12-0305-90fd378af6b9@redhat.com>
 <YH7tL77Z9UzTAFca@kernel.org>
 <45a7e13d-3e44-3b94-a253-2df72649a83d@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <45a7e13d-3e44-3b94-a253-2df72649a83d@redhat.com>
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

On Tue, Apr 20, 2021 at 05:18:55PM +0200, David Hildenbrand wrote:
> On 20.04.21 17:03, Mike Rapoport wrote:
> > On Tue, Apr 20, 2021 at 03:56:28PM +0200, David Hildenbrand wrote:
> > > On 20.04.21 11:09, Mike Rapoport wrote:
> > > > From: Mike Rapoport <rppt@linux.ibm.com>
> > > > 
> > > > The struct pages representing a reserved memory region are initialized
> > > > using reserve_bootmem_range() function. This function is called for each
> > > > reserved region just before the memory is freed from memblock to the buddy
> > > > page allocator.
> > > > 
> > > > The struct pages for MEMBLOCK_NOMAP regions are kept with the default
> > > > values set by the memory map initialization which makes it necessary to
> > > > have a special treatment for such pages in pfn_valid() and
> > > > pfn_valid_within().
> > > 
> > > Just a general question while thinking about it:
> > > 
> > > Would we right now initialize the memmap of these pages already via
> > > memmap_init_zone()->memmap_init_range()? (IOW, not marking the
> > > PageReserved?)
> > 
> > Yep. These pages are part of memblock.memory so they are initialized in
> > memmap_init_zone()->memmap_init_range() to the default values.
> > 
> 
> So instead of fully initializing them again, we mostly would only have to
> set PageReserved(). Not sure how big that memory usually is -- IOW, if we
> really care about optimizing the double-init.

IIUC, these are small areas reserved by the firmware, like e.g. ACPI
tables.

@Ard, am I right?

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
