Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1670C2BC0E
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:02:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D3E52078E
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:02:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/YQSeRG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D3E52078E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA59E4B26C;
	Wed,  2 Sep 2020 07:02:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RwNxUYtUDAco; Wed,  2 Sep 2020 07:02:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD22D4B288;
	Wed,  2 Sep 2020 07:02:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A7B54B26C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:02:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eSgagRRbpVGy for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 07:02:39 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 343AB4B25D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:02:39 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A63B82078E;
 Wed,  2 Sep 2020 11:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599044558;
 bh=rqUKktWH8aA1Aa5o8UuWV/lNmyL+HZCoUqv8egIn3zE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=n/YQSeRG/iZl1orn8jPuU6CmblgXr070xtfqBUGKBu7wrZG5ChM4nwdd2dwELZ92W
 NTLQTynfWC+N5O7UCW+x0VPne9dEVgqhRmnQ8oHltEUo7WPuZtAIbRXr8C2sQSp3Gi
 vDH49s4Sl/cVdyQLHISs8KcUcbTByXCYNO6jzlsE=
Date: Wed, 2 Sep 2020 12:02:33 +0100
From: Will Deacon <will@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 02/21] KVM: arm64: Add stand-alone page-table walker
 infrastructure
Message-ID: <20200902110233.GE5567@willie-the-truck>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-3-will@kernel.org>
 <5ca35d7e-79c2-4e07-962c-cc2eb62f1acb@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5ca35d7e-79c2-4e07-962c-cc2eb62f1acb@redhat.com>
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

Hi Gavin,

On Wed, Sep 02, 2020 at 04:31:32PM +1000, Gavin Shan wrote:
> On 8/25/20 7:39 PM, Will Deacon wrote:
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
> >   arch/arm64/include/asm/kvm_pgtable.h | 101 ++++++++++
> >   arch/arm64/kvm/hyp/Makefile          |   2 +-
> >   arch/arm64/kvm/hyp/pgtable.c         | 290 +++++++++++++++++++++++++++
> >   3 files changed, 392 insertions(+), 1 deletion(-)
> >   create mode 100644 arch/arm64/include/asm/kvm_pgtable.h
> >   create mode 100644 arch/arm64/kvm/hyp/pgtable.c

[...]

> > +struct kvm_pgtable_walk_data {
> > +	struct kvm_pgtable		*pgt;
> > +	struct kvm_pgtable_walker	*walker;
> > +
> > +	u64				addr;
> > +	u64				end;
> > +};
> > +
> 
> Some of the following function might be worthy to be inlined, considering
> their complexity :)

I'll leave that for the compiler to figure out :)

> > +static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
> > +{
> > +	struct kvm_pgtable pgt = {
> > +		.ia_bits	= ia_bits,
> > +		.start_level	= start_level,
> > +	};
> > +
> > +	return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
> > +}
> > +
> 
> It seems @pgt.start_level is assigned with wrong value here.
> For example, @start_level is 2 when @ia_bits and PAGE_SIZE
> are 40 and 64KB separately. In this case, __kvm_pgd_page_idx()
> always return zero. However, the extra page covers up the
> issue. I think something like below might be needed:
> 
> 	struct kvm_pgtable pgt = {
> 		.ia_bits	= ia_bits,
> 		.start_level	= KVM_PGTABLE_MAX_LEVELS - start_level + 1,
> 	};

Hmm, we're pulling the start_level right out of the vtcr, so I don't see
how it can be wrong. In your example, a start_level of 2 seems correct to
me, as we'll translate 13 bits there, then 13 bits at level 3 which covers
the 24 bits you need (with a 16-bit offset within the page).

Your suggestion would give us a start_level of 1, which has a redundant
level of translation. Maybe you're looking at the levels upside-down? The
top level is level 0 and each time you walk to a new level, that number
increases.

But perhaps I'm missing something. Please could you elaborate if you think
there's a problem here?

> > +static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
> > +{
> > +	u32 idx;
> > +	int ret = 0;
> > +	struct kvm_pgtable *pgt = data->pgt;
> > +	u64 limit = BIT(pgt->ia_bits);
> > +
> > +	if (data->addr > limit || data->end > limit)
> > +		return -ERANGE;
> > +
> > +	if (!pgt->pgd)
> > +		return -EINVAL;
> > +
> > +	for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
> > +		kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
> > +
> > +		ret = __kvm_pgtable_walk(data, ptep, pgt->start_level);
> > +		if (ret)
> > +			break;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> 
> I guess we need bail on the following condition:
> 
>         if (data->addr >= limit || data->end >= limit)
>             return -ERANGE;

What's wrong with the existing check? In particular, I think we _want_
to support data->end == limit (it's exclusive). If data->addr == limit,
then we'll have a size of zero and the loop won't run.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
