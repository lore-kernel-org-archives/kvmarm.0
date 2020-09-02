Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C13CDC433E2
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:48:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4383E20758
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:48:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHfhY8rf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4383E20758
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB7734B273;
	Wed,  2 Sep 2020 07:48:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id piO95qwEFgus; Wed,  2 Sep 2020 07:48:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE5784B298;
	Wed,  2 Sep 2020 07:48:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A06004B289
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:48:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mcApe1Nl9J63 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 07:48:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 892314B273
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:48:46 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6C90D20758;
 Wed,  2 Sep 2020 11:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599047325;
 bh=P62K1vfQj5A37QVdWfe9HPv5BxM/jUb/63hAe70okfg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=aHfhY8rfyzhtxxkMsmvHf/VaTt4PxP5A4xfH4Em4oz076NRp0bou0fr6DumiAr5QB
 DW4r5bIRgS3xRR3hqavOQlN7ElUV6Vf6DAK+VFwpuuClzgsGlDuXxhstaN8YDwew6M
 bg7gcP5imj70+aWERIR5fDn3xMo66BqkH47ljykI=
Date: Wed, 2 Sep 2020 12:48:41 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 07/21] KVM: arm64: Convert kvm_phys_addr_ioremap() to
 generic page-table API
Message-ID: <20200902114841.GD5838@willie-the-truck>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-8-will@kernel.org>
 <a25db0df-0238-4f81-b0ab-27a55e1de932@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a25db0df-0238-4f81-b0ab-27a55e1de932@arm.com>
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

On Tue, Sep 01, 2020 at 06:08:01PM +0100, Alexandru Elisei wrote:
> On 8/25/20 10:39 AM, Will Deacon wrote:
> > Convert kvm_phys_addr_ioremap() to use kvm_pgtable_stage2_map() instead
> > of stage2_set_pte().
> >
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 14 +-------------
> >  arch/arm64/kvm/mmu.c         | 29 ++++++++++++-----------------
> >  2 files changed, 13 insertions(+), 30 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 41ee8f3c0369..6f65d3841ec9 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -439,18 +439,6 @@ struct stage2_map_data {
> >  	struct kvm_mmu_memory_cache	*memcache;
> >  };
> >  
> > -static kvm_pte_t *stage2_memcache_alloc_page(struct stage2_map_data *data)
> > -{
> > -	kvm_pte_t *ptep = NULL;
> > -	struct kvm_mmu_memory_cache *mc = data->memcache;
> > -
> > -	/* Allocated with GFP_PGTABLE_USER, so no need to zero */
> > -	if (mc && mc->nobjs)
> > -		ptep = mc->objects[--mc->nobjs];
> > -
> > -	return ptep;
> > -}
> > -
> >  static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
> >  				    struct stage2_map_data *data)
> >  {
> > @@ -531,7 +519,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> >  	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
> >  		return -EINVAL;
> >  
> > -	childp = stage2_memcache_alloc_page(data);
> > +	childp = kvm_mmu_memory_cache_alloc(data->memcache);
> 
> I think this hunk and the above could have been squashed in the previous patch, I
> think we could have used kvm_mmu_memory_cache_alloc directly from the start.

Urgh, looks like I squashed into the wrong patch when I rebased this before.
Thanks, I'll fix that (but damn, rebasing this series sucks rocks).

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
