Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33FBC433E2
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:51:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1821120BED
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:51:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bU7PfvHx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1821120BED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46E184B286;
	Thu, 10 Sep 2020 06:51:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qt8phiayT+O7; Thu, 10 Sep 2020 06:51:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 511D14B341;
	Thu, 10 Sep 2020 06:51:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA0124B286
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:51:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D6sWnTgVHrcz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 06:51:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC61F4B284
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:51:14 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D8FF720872;
 Thu, 10 Sep 2020 10:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599735073;
 bh=Ef5qXHNCHTSnJWo8jpqPfA06Z1ezvhOUOSx+GwCrD6k=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=bU7PfvHxA98l2gOXJg3kMfU40t9OY9gmXFR6dUOlQh7Pi2/ruOG4A+CD9vZEbpk1B
 oGUEJF0fXSeI5qAlqp6eVrm8CygP15faVGQskPetVG3mScLMnqBI8BuNi7zU5MusD7
 AXm/poaCjNxrABno6B1p5q6RxpP1GusefwxgBx3s=
Date: Thu, 10 Sep 2020 11:51:08 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 17/21] KVM: arm64: Convert user_mem_abort() to generic
 page-table API
Message-ID: <20200910105107.GA17887@willie-the-truck>
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-18-will@kernel.org>
 <2ae77a66-9cc4-f4e1-9e98-a50d5891cf20@arm.com>
 <c2e5e055251db637327f81da452cea2c@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c2e5e055251db637327f81da452cea2c@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Sep 09, 2020 at 06:12:29PM +0100, Marc Zyngier wrote:
> On 2020-09-09 15:20, Alexandru Elisei wrote:
> > On 9/7/20 4:23 PM, Will Deacon wrote:
> > > @@ -1610,62 +1605,31 @@ static int user_mem_abort(struct kvm_vcpu
> > > *vcpu, phys_addr_t fault_ipa,
> > >  	if (vma_pagesize == PAGE_SIZE && !force_pte)
> > >  		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
> > >  							   &pfn, &fault_ipa);
> > > -	if (writable)
> > > +	if (writable) {
> > > +		prot |= KVM_PGTABLE_PROT_W;
> > >  		kvm_set_pfn_dirty(pfn);
> > > +		mark_page_dirty(kvm, gfn);
> > 
> > The previous code called mark_page_dirty() only if the vma_pagesize ==
> > PAGE_SIZE
> > (and writable was true, obviously). Is this supposed to fix a bug?
> 
> No, this is actually introducing one. mark_page_dirty() checks that there is
> an
> associated bitmap, and thus only happens when writing to a single page, but
> we
> shouldn't do it for R/O memslots, which the current code avoids. It should
> be
> guarded by logging_active.

gfn_to_pfn_prot() will set "writable" to false for R/O memslots, so I think
we're good here.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
