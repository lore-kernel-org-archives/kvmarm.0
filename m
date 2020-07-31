Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F94EC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 08:22:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 01017208E4
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 08:22:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="NLkS+3PR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01017208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEF064B4CE;
	Fri, 31 Jul 2020 04:22:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SshF5eGFrsnE; Fri, 31 Jul 2020 04:22:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B32E84B4D0;
	Fri, 31 Jul 2020 04:22:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF03B4B3E0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 04:22:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A1+XPRYx1Q+w for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 04:22:20 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E6674B2C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 04:22:20 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6405A2072A;
 Fri, 31 Jul 2020 08:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596183739;
 bh=RPnOOl0AXZ2PECyeyW87ffzti5nE+NZnXjsOipIlZX8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=NLkS+3PRP9Lgk6P9bro6R9mrsudXhafzio35pvb6G416cozueRrVXjlCtX0Sz1Esc
 vphcrsCojfd6tAvtKTYh5atU9ST97bkmJi1CxgnkjpTdnhQCuYp3zkiBwwfRJCM10d
 Pn9crGamjCAoGqTf9rEQwRLKh1nw6pQkCFrk6eD8=
Date: Fri, 31 Jul 2020 09:22:15 +0100
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 02/20] KVM: arm64: Add support for creating
 kernel-agnostic stage-1 page tables
Message-ID: <20200731082208.GA26291@willie-the-truck>
References: <20200730153406.25136-1-will@kernel.org>
 <20200730153406.25136-3-will@kernel.org>
 <20200731081436.GA3201636@google.com>
 <20200731081911.GB3201636@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200731081911.GB3201636@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Fri, Jul 31, 2020 at 09:19:11AM +0100, Quentin Perret wrote:
> On Friday 31 Jul 2020 at 09:14:36 (+0100), Quentin Perret wrote:
> > On Thursday 30 Jul 2020 at 16:33:48 (+0100), Will Deacon wrote:
> > > +void *kvm_pgtable_hyp_alloc_cookie(u32 va_bits)
> > > +{
> > > +	struct kvm_pgtable *pgt = kzalloc(sizeof(*pgt), GFP_KERNEL);
> > > +
> > > +	if (!pgt)
> > > +		return NULL;
> > > +
> > > +	pgt->ia_bits = va_bits;
> > > +	pgt->start_level = kvm_start_level(va_bits);
> > > +
> > > +	pgt->pgd = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL);
> > > +	if (!pgt->pgd) {
> > > +		kfree(pgt);
> > > +		pgt = NULL;
> > > +	}
> > > +
> > > +	return pgt;
> > > +}
> > > +
> > > +static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> > > +			   enum kvm_pgtable_walk_flags flag, void * const arg)
> > > +{
> > > +	free_page((unsigned long)kvm_pte_follow(*ptep));
> > > +	return 0;
> > > +}
> > > +
> > > +void kvm_pgtable_hyp_free_cookie(void *cookie)
> > > +{
> > > +	size_t pgd_sz;
> > > +	struct kvm_pgtable *pgt = cookie;
> > > +	struct kvm_pgtable_walker walker = {
> > > +		.cb	= hyp_free_walker,
> > > +		.flags	= KVM_PGTABLE_WALK_TABLE_POST,
> > > +	};
> > > +
> > > +	if (kvm_pgtable_walk(cookie, 0, BIT(pgt->ia_bits), &walker))
> > > +		kvm_err("Failed to free page-table pages\n");
> > > +
> > > +	pgd_sz = kvm_pgd_pages(pgt) * PAGE_SIZE;
> > > +	free_pages_exact(pgt->pgd, pgd_sz);
> > 
> > Given that the pgd is unconditionally a single page for the stage 1 case
> > (as per kvm_pgtable_hyp_alloc_cookie() above), should we simplify this
> > to a simple free_page()? Or did you want to factorize this with the
> > stage 2 free path?
> 
> Hmm, or maybe it's the alloc() path that needs fixing actually ...

No, I think you're right. The hyp stage-1 PGD is always a single page, so I
can simplify the free() path. At one point, I had a common free() path for
stage-1 and stage-2, but that didn't last very long, as the stage-2
page-table pages are refcounted so you end up having to deal with them
differently anyway.

Do you think there is a functional issue here? I don't immediately see it.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
