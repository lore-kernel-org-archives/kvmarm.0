Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D2D3ECAAD3
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 10:04:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD5D74CAF4;
	Fri,  9 Sep 2022 06:04:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WIsCI4ojRdw4; Fri,  9 Sep 2022 06:04:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BBED4CA52;
	Fri,  9 Sep 2022 06:04:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7E2E4CA34
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 06:04:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CgK8iE0s0q6H for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 06:04:45 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A9C74C91D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 06:04:45 -0400 (EDT)
Date: Fri, 9 Sep 2022 11:04:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1662717884;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=xAYIHP+5okh1OBy0npVyjWSJCHPvarSH75P9UOmP2gY=;
 b=Xc4YtLmnMk9UMIltU2T6jAMcxCVLjBTM6REusu7WFdxNshnChTBrhcb7ICp6jdLMTCmKwm
 9w0kU7AqzOeD5t2eWDxeP3ew40EYNzn/C7oDpICH04pNMes3iaQJBedEW7zAv+E5be5Ndc
 cuJg4M4g8qPjMkt3n4MrAXyJ734Mbj4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 02/14] KVM: arm64: Tear down unlinked stage-2 subtree
 after break-before-make
Message-ID: <YxsPtT6DXxl2q/OG@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-3-oliver.upton@linux.dev>
 <Yxdaw1qng/Or0LLA@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yxdaw1qng/Or0LLA@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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

On Tue, Sep 06, 2022 at 02:35:47PM +0000, Quentin Perret wrote:
> Hi Oliver,
> 
> On Tuesday 30 Aug 2022 at 19:41:20 (+0000), Oliver Upton wrote:
> >  static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
> >  				     kvm_pte_t *ptep,
> >  				     struct stage2_map_data *data)
> >  {
> > -	if (data->anchor)
> > -		return 0;
> > +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> > +	kvm_pte_t *childp = kvm_pte_follow(*ptep, mm_ops);
> > +	struct kvm_pgtable *pgt = data->mmu->pgt;
> > +	int ret;
> >  
> >  	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
> >  		return 0;
> >  
> > -	data->childp = kvm_pte_follow(*ptep, data->mm_ops);
> >  	kvm_clear_pte(ptep);
> >  
> >  	/*
> > @@ -782,8 +786,13 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
> >  	 * individually.
> >  	 */
> >  	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> > -	data->anchor = ptep;
> > -	return 0;
> > +
> > +	ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
> > +
> > +	mm_ops->put_page(ptep);
> > +	mm_ops->free_removed_table(childp, level + 1, pgt);
> 
> By the look of it, __kvm_pgtable_visit() has saved the table PTE on the
> stack prior to calling the TABLE_PRE callback, and it then uses the PTE
> from its stack and does kvm_pte_follow() to find the childp, and walks
> from there. Would that be a UAF now?

Sure would, I suppose the actual UAF is hidden by the use of RCU later
in the series. Nonetheless, I'm going to adopt David's suggestion of
just rereading the PTE which should tidy this up.

Thanks for catching this.

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
