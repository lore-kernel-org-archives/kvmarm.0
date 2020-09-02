Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C90EC433E2
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:36:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E399D2078B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:36:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bYhlvxcl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E399D2078B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 946BE4B1C7;
	Wed,  2 Sep 2020 07:36:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a15dk9DOmg4L; Wed,  2 Sep 2020 07:36:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F1274B286;
	Wed,  2 Sep 2020 07:36:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A8084B27D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:36:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w9YHBy66hr8D for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 07:36:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 339FD4B1AA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:36:01 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 04DC820767;
 Wed,  2 Sep 2020 11:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599046560;
 bh=/etCU3YViUEtzQ0JISoSQugRycUsAudfDbC7jReJags=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=bYhlvxcl0QbskbrCkaKRoxD+rU16GQ7n2hk+Ufz/kkOLqyfDpAD9qoYNJdLnqp+b5
 D7W9u30uJBPULXYEsjRw1gM7+W4yTJu0+MbKzFnKC6Sd31z4/uS9JD4NbfeH6lQtL1
 6qcOjrxfl7o91qqyG5QKpuwo6kT7eFkNF3zSXhdM=
Date: Wed, 2 Sep 2020 12:35:56 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 04/21] KVM: arm64: Use generic allocator for hyp
 stage-1 page-tables
Message-ID: <20200902113555.GB5838@willie-the-truck>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-5-will@kernel.org>
 <35435dcb-e821-3769-ac0f-e75b1ede237f@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <35435dcb-e821-3769-ac0f-e75b1ede237f@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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

On Fri, Aug 28, 2020 at 05:32:16PM +0100, Alexandru Elisei wrote:
> On 8/25/20 10:39 AM, Will Deacon wrote:
> > Now that we have a shiny new page-table allocator, replace the hyp
> > page-table code with calls into the new API. This also allows us to
> > remove the extended idmap code, as we can now simply ensure that the
> > VA size is large enough to map everything we need.
> >
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_mmu.h       |  78 +----
> >  arch/arm64/include/asm/kvm_pgtable.h   |   5 +
> >  arch/arm64/include/asm/pgtable-hwdef.h |   6 -
> >  arch/arm64/include/asm/pgtable-prot.h  |   6 -
> >  arch/arm64/kvm/mmu.c                   | 414 +++----------------------
> >  5 files changed, 45 insertions(+), 464 deletions(-)
> >
> > [..]
> > @@ -2356,6 +2028,7 @@ static int kvm_map_idmap_text(pgd_t *pgd)
> >  int kvm_mmu_init(void)
> >  {
> >  	int err;
> > +	u32 hyp_va_bits;
> >  
> >  	hyp_idmap_start = __pa_symbol(__hyp_idmap_text_start);
> >  	hyp_idmap_start = ALIGN_DOWN(hyp_idmap_start, PAGE_SIZE);
> > @@ -2369,6 +2042,8 @@ int kvm_mmu_init(void)
> >  	 */
> >  	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
> >  
> > +	hyp_va_bits = 64 - ((idmap_t0sz & TCR_T0SZ_MASK) >> TCR_T0SZ_OFFSET);
> 
> idmap_t0sz is defined in mm/mmu.c as: TCR_T0SZ(VA_BITS) = (UL(64) - VA_BITS) <<
> TCR_T0SZ_OFFSET. Looks to me like hyp_va_bits == VA_BITS.

Careful! It can get rewritten in head.S if we determine that physical memory
is in an awkward place and not covered by VA_BITS in an identity mapping.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
