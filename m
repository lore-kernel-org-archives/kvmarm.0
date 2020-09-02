Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67239C433E7
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:30:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D53602065E
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:30:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1SIc18CI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D53602065E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 768794B1AA;
	Wed,  2 Sep 2020 07:30:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZhQsoF6LC1tK; Wed,  2 Sep 2020 07:30:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C03CB4B2AE;
	Wed,  2 Sep 2020 07:30:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A45274B2AC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:30:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ykP4NGmIeocQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 07:30:23 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8EA454B2AB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:30:23 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 11F992065E;
 Wed,  2 Sep 2020 11:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599046222;
 bh=/QphwwPl0pPHSe5XcEimALyTKTsr0FajRgwf964VZls=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=1SIc18CIsgpbgZoEScseMXlZJgmz34vuIlKGYIk7GKuvGWBkLqI2QOmKfqmmS7qbe
 jdN9PaSxE3+OwIXS6Op+VlZtRlK+UPpyV5ZgzxgNeeX7mQVMBcdq9uza7dATQ55Lwl
 nUj6fZxOi9w8vKg5xgYUB23cj4ms4HjnyzB6Tnz0=
Date: Wed, 2 Sep 2020 12:30:17 +0100
From: Will Deacon <will@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 05/21] KVM: arm64: Add support for creating
 kernel-agnostic stage-2 page tables
Message-ID: <20200902113014.GA5838@willie-the-truck>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-6-will@kernel.org>
 <e0b07673-bc32-95e4-be7a-382c80240000@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e0b07673-bc32-95e4-be7a-382c80240000@redhat.com>
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

On Wed, Sep 02, 2020 at 04:40:03PM +1000, Gavin Shan wrote:
> On 8/25/20 7:39 PM, Will Deacon wrote:
> > Introduce alloc() and free() functions to the generic page-table code
> > for guest stage-2 page-tables and plumb these into the existing KVM
> > page-table allocator. Subsequent patches will convert other operations
> > within the KVM allocator over to the generic code.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >   arch/arm64/include/asm/kvm_host.h    |  1 +
> >   arch/arm64/include/asm/kvm_pgtable.h | 18 +++++++++
> >   arch/arm64/kvm/hyp/pgtable.c         | 51 ++++++++++++++++++++++++++
> >   arch/arm64/kvm/mmu.c                 | 55 +++++++++++++++-------------
> >   4 files changed, 99 insertions(+), 26 deletions(-)
> > 
> 
> With the following one question resolved:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks!

> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index fabd72b0c8a4..4607e9ca60a2 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -668,47 +668,49 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
> >    * @kvm:	The pointer to the KVM structure
> >    * @mmu:	The pointer to the s2 MMU structure
> >    *
> > - * Allocates only the stage-2 HW PGD level table(s) of size defined by
> > - * stage2_pgd_size(mmu->kvm).
> > - *
> > + * Allocates only the stage-2 HW PGD level table(s).
> >    * Note we don't need locking here as this is only called when the VM is
> >    * created, which can only be done once.
> >    */
> >   int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
> >   {
> > -	phys_addr_t pgd_phys;
> > -	pgd_t *pgd;
> > -	int cpu;
> > +	int cpu, err;
> > +	struct kvm_pgtable *pgt;
> > -	if (mmu->pgd != NULL) {
> > +	if (mmu->pgt != NULL) {
> >   		kvm_err("kvm_arch already initialized?\n");
> >   		return -EINVAL;
> >   	}
> > -	/* Allocate the HW PGD, making sure that each page gets its own refcount */
> > -	pgd = alloc_pages_exact(stage2_pgd_size(kvm), GFP_KERNEL | __GFP_ZERO);
> > -	if (!pgd)
> > +	pgt = kzalloc(sizeof(*pgt), GFP_KERNEL);
> > +	if (!pgt)
> >   		return -ENOMEM;
> > -	pgd_phys = virt_to_phys(pgd);
> > -	if (WARN_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm)))
> > -		return -EINVAL;
> > +	err = kvm_pgtable_stage2_init(pgt, kvm);
> > +	if (err)
> > +		goto out_free_pgtable;
> >   	mmu->last_vcpu_ran = alloc_percpu(typeof(*mmu->last_vcpu_ran));
> >   	if (!mmu->last_vcpu_ran) {
> > -		free_pages_exact(pgd, stage2_pgd_size(kvm));
> > -		return -ENOMEM;
> > +		err = -ENOMEM;
> > +		goto out_destroy_pgtable;
> >   	}
> >   	for_each_possible_cpu(cpu)
> >   		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
> >   	mmu->kvm = kvm;
> > -	mmu->pgd = pgd;
> > -	mmu->pgd_phys = pgd_phys;
> > +	mmu->pgt = pgt;
> > +	mmu->pgd_phys = __pa(pgt->pgd);
> > +	mmu->pgd = (void *)pgt->pgd;
> >   	mmu->vmid.vmid_gen = 0;
> > -
> >   	return 0;
> > +
> > +out_destroy_pgtable:
> > +	kvm_pgtable_stage2_destroy(pgt);
> > +out_free_pgtable:
> > +	kfree(pgt);
> > +	return err;
> >   }
> > 
> 
> kvm_pgtable_stage2_destroy() might not needed here because
> the stage2 page pgtable is empty so far. However, it should
> be rare to hit the case. If I'm correct, what we need to do
> is just freeing the PGDs.

Right, but kvm_pgtable_stage2_destroy() also frees the PGDs because it
knows how many pages there are and they were allocated by
kvm_pgtable_stage2_init().

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
