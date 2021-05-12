Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A495C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 05:32:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB512613BE
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 05:32:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB512613BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 620A14B5AC;
	Wed, 12 May 2021 01:32:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Rxqr-gYYTjx; Wed, 12 May 2021 01:31:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12ED34B556;
	Wed, 12 May 2021 01:31:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6024B4B532
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 01:31:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WpL1ZhoWm8It for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 01:31:57 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 024404B502
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 01:31:56 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EDC861370;
 Wed, 12 May 2021 05:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620797515;
 bh=TxWm1LIFrLgLEDN6G3IKv8ki7BMXodxEwq43YsP1HCQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=g8m/fPUZsByQlUglXc/EHxVww2QHzpdwYHP0WQ6Pwjn4PfpgBnQA52LWD1+KsGPIl
 dxWoC5o4qlbanljdgfmTcHpNi+HusqMu5OlW6ZWgL2YnL6DUJrQIKuU0K+d/xcbyfG
 Xh7JM3tVao4DQf8s7MKRLDYHlqLjcV6sTfgd11HPsMWnvHCQip3705mr9Qu6J2/DiK
 OJE1LqGTZW28lAamPRrpLM9D/Ww2gZPoZTSQzPi0/uQqUmD86Xe7qcaABVWzsyiwiC
 X1zJd+DSMOOE2z6qbGKnwfa/LfhtBr/+YPWmQ/7mn0GoJ99JrjPHJlBHalXq0USGYm
 SwPp8PBtbhJsA==
Date: Wed, 12 May 2021 08:31:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 4/4] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
Message-ID: <YJtoQhidtIJOhYsV@kernel.org>
References: <20210511100550.28178-1-rppt@kernel.org>
 <20210511100550.28178-5-rppt@kernel.org>
 <20210511164001.7e905659fdbb8a5e190d303a@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210511164001.7e905659fdbb8a5e190d303a@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
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

On Tue, May 11, 2021 at 04:40:01PM -0700, Andrew Morton wrote:
> On Tue, 11 May 2021 13:05:50 +0300 Mike Rapoport <rppt@kernel.org> wrote:
> 
> > From: Mike Rapoport <rppt@linux.ibm.com>
> > 
> > The arm64's version of pfn_valid() differs from the generic because of two
> > reasons:
> > 
> > * Parts of the memory map are freed during boot. This makes it necessary to
> >   verify that there is actual physical memory that corresponds to a pfn
> >   which is done by querying memblock.
> > 
> > * There are NOMAP memory regions. These regions are not mapped in the
> >   linear map and until the previous commit the struct pages representing
> >   these areas had default values.
> > 
> > As the consequence of absence of the special treatment of NOMAP regions in
> > the memory map it was necessary to use memblock_is_map_memory() in
> > pfn_valid() and to have pfn_valid_within() aliased to pfn_valid() so that
> > generic mm functionality would not treat a NOMAP page as a normal page.
> > 
> > Since the NOMAP regions are now marked as PageReserved(), pfn walkers and
> > the rest of core mm will treat them as unusable memory and thus
> > pfn_valid_within() is no longer required at all and can be disabled by
> > removing CONFIG_HOLES_IN_ZONE on arm64.
> > 
> > pfn_valid() can be slightly simplified by replacing
> > memblock_is_map_memory() with memblock_is_memory().
> > 
> > ...
> >
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -1052,9 +1052,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
> >  	def_bool y
> >  	depends on NUMA
> >  
> > -config HOLES_IN_ZONE
> > -	def_bool y
> > -
> >  source "kernel/Kconfig.hz"
> >  
> >  config ARCH_SPARSEMEM_ENABLE
> 
> https://lkml.kernel.org/r/20210417075946.181402-1-wangkefeng.wang@huawei.com
> already did this, so I simply dropped that hunk? 
> And I don't think the changelog needs updating for this?

We need another hunk instead (below)

> And I don't think the changelog needs updating for this?

maybe "s/disabled by removing CONFIG_HOLES_IN_ZONE/disabled/", but does not
seem that important to me.

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 3d6c7436a2fa..d7dc8698cf8e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -201,7 +201,6 @@ config ARM64
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_GENERIC_VDSO
-	select HOLES_IN_ZONE
 	select IOMMU_DMA if IOMMU_SUPPORT
 	select IRQ_DOMAIN
 	select IRQ_FORCED_THREADING
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
