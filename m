Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BF0C43461
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:57:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0EB9720BED
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:57:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yu5PpokJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EB9720BED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47F844B280;
	Thu, 10 Sep 2020 06:57:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ICW-t8q485Am; Thu, 10 Sep 2020 06:57:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B0024B368;
	Thu, 10 Sep 2020 06:57:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3936C4B35E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:57:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vHhaYe8StpQc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 06:57:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37E5D4B280
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:57:34 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 37A6B20BED;
 Thu, 10 Sep 2020 10:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599735453;
 bh=AEAtw8EJgKeoXMPWto+9quUxLrmFhEfBRBwjWEZ2/0Y=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Yu5PpokJ3ghEAjezuRVBNjyMIUAC6gxk0QekWNAP7XwByeidMT97mVgPOUc4XearW
 y328m4PQnGmtWHYgT9RPskc9vn8+255FSWhuzcln27GYeiob9U9SboGUOB4v8IZP8y
 3elMItzoSrgPPrcEX4cHN5ek8RqCx/v9f52KSiT0=
Date: Thu, 10 Sep 2020 11:57:27 +0100
From: Will Deacon <will@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 02/21] KVM: arm64: Add stand-alone page-table walker
 infrastructure
Message-ID: <20200910105727.GC17887@willie-the-truck>
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-3-will@kernel.org>
 <56510d79-ce08-c058-03f8-10b1a37d05b0@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56510d79-ce08-c058-03f8-10b1a37d05b0@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Sep 08, 2020 at 10:03:30AM +1000, Gavin Shan wrote:
> On 9/8/20 1:23 AM, Will Deacon wrote:
> > The KVM page-table code is intricately tied into the kernel page-table
> > code and re-uses the pte/pmd/pud/p4d/pgd macros directly in an attempt
> > to reduce code duplication. Unfortunately, the reality is that there is
> > an awful lot of code required to make this work, and at the end of the
> > day you're limited to creating page-tables with the same configuration
> > as the host kernel. Furthermore, lifting the page-table code to run
> > directly at EL2 on a non-VHE system (as we plan to to do in future
> > patches) is practically impossible due to the number of dependencies it
> > has on the core kernel.
> > 
> > Introduce a framework for walking Armv8 page-tables configured
> > independently from the host kernel.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> 
> It looks good to me. However, If you get a chance to respin, I guess
> it would be nice to add some comments about kvm_block_mapping_supported().
> More details are provoided below.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>

[...]

> > +static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
> > +{
> > +	u64 granule = kvm_granule_size(level);
> > +
> > +	/*
> > +	 * Reject invalid block mappings and don't bother with 4TB mappings for
> > +	 * 52-bit PAs.
> > +	 */
> > +	if (level == 0 || (PAGE_SIZE != SZ_4K && level == 1))
> > +		return false;
> > +
> > +	if (granule > (end - addr))
> > +		return false;
> > +
> > +	return IS_ALIGNED(addr, granule) && IS_ALIGNED(phys, granule);
> > +}
> > +
> 
> If you get a chance to respin, it would be nice to have more comments to
> explain why 4TB block mapping is rejected here. I guess it depends on the
> fact: hugeTLB/THP doesn't support such kind of huge block mapping yet?

It's just because I'm lazy, really :) We don't know if we're using 52-bit
PAs here, and I couldn't be bothered to propagate that information given
that this doesn't seem like something anybody will be using at the moment.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
