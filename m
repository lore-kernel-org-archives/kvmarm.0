Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA018C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 16:50:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 542D8206A5
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 16:50:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="riheCyTm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 542D8206A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0286A4B2AC;
	Thu,  3 Sep 2020 12:50:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KTNhapq42cLF; Thu,  3 Sep 2020 12:50:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0D384B1DD;
	Thu,  3 Sep 2020 12:50:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D91A54B1DD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 12:50:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ipK6C9CVblb1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 12:50:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA1E14B15B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 12:50:26 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6EAA720716;
 Thu,  3 Sep 2020 16:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599151826;
 bh=SxV6b5DWiuiTUilOGP66Lgu5Un5sWRs6Gj8Z2yo4omc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=riheCyTmfxInRrx88zbQ8sBXKp4yggB/z/YyrSr15LQMjv2uuV+qPHWC8WVPyRGNQ
 u4EqozjnlMG16YprsMQg+1ToDtZGATEEPuOgQLW0Pqi33/Wvq8T9hhn0h7z+esH6yw
 ctAuoOJi2VrP1gth4+sNVczenTzze1hDhVlvPqbM=
Date: Thu, 3 Sep 2020 17:50:21 +0100
From: Will Deacon <will@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 20/21] KVM: arm64: Remove unused 'pgd' field from
 'struct kvm_s2_mmu'
Message-ID: <20200903165020.GC7791@willie-the-truck>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-21-will@kernel.org>
 <f0a64bb2-5371-9f44-1c64-035cbc6dcf5b@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f0a64bb2-5371-9f44-1c64-035cbc6dcf5b@redhat.com>
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

On Thu, Sep 03, 2020 at 03:07:17PM +1000, Gavin Shan wrote:
> On 8/25/20 7:39 PM, Will Deacon wrote:
> > The stage-2 page-tables are entirely encapsulated by the 'pgt' field of
> > 'struct kvm_s2_mmu', so remove the unused 'pgd' field.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >   arch/arm64/include/asm/kvm_host.h | 1 -
> >   arch/arm64/kvm/mmu.c              | 2 --
> >   2 files changed, 3 deletions(-)
> > 
> 
> I think this might be folded into PATCH[18] as both patches are
> simple enough. I'm not sure the changes introduced in PATCH[19]
> prevent us doing this.
> 
> There is another question below.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 0b7c702b2151..41caf29bd93c 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -79,7 +79,6 @@ struct kvm_s2_mmu {
> >   	 * for vEL1/EL0 with vHCR_EL2.VM == 0.  In that case, we use the
> >   	 * canonical stage-2 page tables.
> >   	 */
> > -	pgd_t		*pgd;
> >   	phys_addr_t	pgd_phys;
> >   	struct kvm_pgtable *pgt;
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index ddeec0b03666..f28e03dcb897 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -384,7 +384,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
> >   	mmu->kvm = kvm;
> >   	mmu->pgt = pgt;
> >   	mmu->pgd_phys = __pa(pgt->pgd);
> > -	mmu->pgd = (void *)pgt->pgd;
> >   	mmu->vmid.vmid_gen = 0;
> >   	return 0;
> > @@ -470,7 +469,6 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
> >   	spin_lock(&kvm->mmu_lock);
> >   	pgt = mmu->pgt;
> >   	if (pgt) {
> > -		mmu->pgd = NULL;
> >   		mmu->pgd_phys = 0;
> >   		mmu->pgt = NULL;
> >   		free_percpu(mmu->last_vcpu_ran);
> > 
> 
> I guess mmu->pgd_phys might be removed either because kvm_get_vttbr()
> is the only consumer.

Hmm, but kvm_get_vttbr() is still used after these patches, so I think
the pgd_phys field needs to stick around.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
