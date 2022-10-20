Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A12D5C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 08:36:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04C214B943;
	Thu, 20 Oct 2022 04:36:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id atELejse4MbK; Thu, 20 Oct 2022 04:36:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA3854B945;
	Thu, 20 Oct 2022 04:36:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F7194B93E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 04:36:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mq5sIDoBfPYQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 04:36:00 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A735E4B8F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 04:36:00 -0400 (EDT)
Date: Thu, 20 Oct 2022 11:35:54 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1666254959;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=4bFmitmS0e0DfzO3u2Vz/2OAVtqGb2XuvT7fYH4csp4=;
 b=gdBGORDykXgxNOmBPdP5jxs2zgIt7+2yLsb9L5Loojh51BmO9Bhp5sbXOZYcs2wOL5nFou
 3usATUday8HjdXJBureCI2ohWaixAFeplEUvxR9+F8baHiLfoFuegG0YhtUezyXFW61Xe+
 Sy2IkrG1hDqhkDtSUxXERJ4D86HQ/20=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2 15/15] KVM: arm64: Handle stage-2 faults in parallel
Message-ID: <Y1EIar1OGgxMKzSf@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007233253.460257-1-oliver.upton@linux.dev>
 <Y1CJFLVnnbX4Ck85@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y1CJFLVnnbX4Ck85@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
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

On Wed, Oct 19, 2022 at 11:32:36PM +0000, Sean Christopherson wrote:
> On Fri, Oct 07, 2022, Oliver Upton wrote:
> > @@ -1534,7 +1517,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> >  	 */
> >  	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, range->start << PAGE_SHIFT,
> >  			       PAGE_SIZE, __pfn_to_phys(pfn),
> > -			       KVM_PGTABLE_PROT_R, NULL);
> > +			       KVM_PGTABLE_PROT_R, NULL, KVM_PGTABLE_WALK_SHARED);
> 
> All MMU notifier events acquire mmu_lock for write when invoking arch code, i.e.
> this isn't a shared walk.

Derp, didn't intend to set the flag here. I'll fix it in v3.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
