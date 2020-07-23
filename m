Return-Path: <SRS0=bqG1=BC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0432EC433EB
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 10:08:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 84E6F2086A
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 10:08:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="znBEr0fj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84E6F2086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FB1B4B2D9;
	Thu, 23 Jul 2020 06:08:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TH8LYG63dNTJ; Thu, 23 Jul 2020 06:08:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE1A14B2BE;
	Thu, 23 Jul 2020 06:08:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C54614B1FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2020 06:08:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H6YV+slP2Nj0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jul 2020 06:08:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 98AFA4B1CF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2020 06:08:49 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4CBB22086A;
 Thu, 23 Jul 2020 10:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595498928;
 bh=AML2GZZ2Ph91q1oR/Eg49IMw55Q5QbxKvzvu1iz4bIg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=znBEr0fjlV5rdxomE2c2cQfMuQCavRErZqYac5EeyDHjYb8f0l2fdRZsHNZmfC2wq
 yy/ZPIbgy+ilYflMX3t24hpAMnehRlU3O/PJIcrtIvDsQtxVLtJH/IKUVkubqYQZ+J
 lp0pMsjHDo6n8wGKQefFPgy22LP0Efb/r3nN81AE=
Date: Thu, 23 Jul 2020 11:08:44 +0100
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't inherit exec permission across
 page-table levels
Message-ID: <20200723100843.GA15711@willie-the-truck>
References: <20200722131511.14639-1-will@kernel.org>
 <20200722155428.GA275809@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200722155428.GA275809@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
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

Hi Quentin,

On Wed, Jul 22, 2020 at 04:54:28PM +0100, Quentin Perret wrote:
> On Wednesday 22 Jul 2020 at 14:15:10 (+0100), Will Deacon wrote:
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 8c0035cab6b6..69dc36d1d486 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1326,7 +1326,7 @@ static bool stage2_get_leaf_entry(struct kvm *kvm, phys_addr_t addr,
> >  	return true;
> >  }
> >  
> > -static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
> > +static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr, unsigned long sz)
> >  {
> >  	pud_t *pudp;
> >  	pmd_t *pmdp;
> > @@ -1338,9 +1338,9 @@ static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
> >  		return false;
> >  
> >  	if (pudp)
> > -		return kvm_s2pud_exec(pudp);
> > +		return sz == PUD_SIZE && kvm_s2pud_exec(pudp);
> >  	else if (pmdp)
> > -		return kvm_s2pmd_exec(pmdp);
> > +		return sz == PMD_SIZE && kvm_s2pmd_exec(pmdp);
> >  	else
> >  		return kvm_s2pte_exec(ptep);
> 
> This wants a 'sz == PAGE_SIZE' check, otherwise you'll happily inherit
> the exec flag when a PTE has exec rights while you create a block
> mapping on top.

Nice catch! Somehow I thought we always had PAGE_SIZE in the 'else' case,
but that's obviously not true now that you've pointed it out.

> Also, I think it should be safe to make the PMD and PUD case more
> permissive, as 'sz <= PMD_SIZE' for instance, as the icache
> invalidation shouldn't be an issue there? That probably doesn't matter
> all that much though.

I'll make that change anyway.

> > @@ -1958,7 +1958,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  	 * execute permissions, and we preserve whatever we have.
> >  	 */
> >  	needs_exec = exec_fault ||
> > -		(fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
> > +		(fault_status == FSC_PERM &&
> > +		 stage2_is_exec(kvm, fault_ipa, vma_pagesize));
> >  
> >  	if (vma_pagesize == PUD_SIZE) {
> >  		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
> > -- 
> > 2.28.0.rc0.105.gf9edc3c819-goog
> > 
> 
> FWIW, I reproduced the issue with a dummy guest accessing memory just
> the wrong way, and toggling dirty logging at the right moment. And this
> patch + my suggestion above seems to cure things.

Testing?! It'll never catch on...

> So, with the above applied:
> 
> Reviewed-by: Quentin Perret <qperret@google.com>
> Tested-by: Quentin Perret <qperret@google.com>

Cheers. v2 coming up.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
