Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94945C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 18:20:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08D624D8A3;
	Wed, 20 Jul 2022 14:20:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rs0kbD6SG1dk; Wed, 20 Jul 2022 14:20:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBD4A4D8A4;
	Wed, 20 Jul 2022 14:20:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 606CC4D8A2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 14:20:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MmtLL4jRdJHx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 14:20:15 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B11E4D89C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 14:20:14 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 15559618EE;
 Wed, 20 Jul 2022 18:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2ECC3411E;
 Wed, 20 Jul 2022 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658341213;
 bh=RFIC0wPWWnsb7x9huQFBiUskEG9V1MexNTrQ63YkjCI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Kh/XOeAj9yTK6Ny2ATKcdQn0Cqn2oJ+nbYN4qPBr0RDH22FynIsbmXDzNbcz76MwE
 Zgs1fqLrmj92GDLs4GILCkfVGANlveeYouqnKONFvJ2PEc59+9t7RnUgzb5U9pi14R
 eaLFTLt7887tOS6D4j5Q3Tn5sMcfLTyqpWv4x/v7xP9GJwL/88sbBd2NxRQ2LtovPR
 K+COdA12gkXBDZxmEV4ZKTTGyQHh/6D0+iuF6IIz9FUiffRk+Iw6lpaTsQ41c0SC19
 9/kRFMCFhjwspjT7l/5siBgxzZGRZe1aGvdBveMkfY1sFJiYWy9pohSAOeIgu0911r
 lcVH8wNo2eRlw==
Date: Wed, 20 Jul 2022 19:20:05 +0100
From: Will Deacon <will@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v2 12/24] KVM: arm64: Introduce shadow VM state at EL2
Message-ID: <20220720182005.GB16603@willie-the-truck>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-13-will@kernel.org>
 <YtWpBYPrBcdyp9r6@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YtWpBYPrBcdyp9r6@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>, Andy Lutomirski <luto@amacapital.net>,
 linux-arm-kernel@lists.infradead.org, Michael Roth <michael.roth@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu
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

Hi Vincent,

Thanks for going through this.

On Mon, Jul 18, 2022 at 07:40:05PM +0100, Vincent Donnefort wrote:
> [...]
> 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 9f339dffbc1a..2d6b5058f7d3 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -288,6 +288,14 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
> >   */
> >  u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
> >  
> > +/*
> 
> /** ?
> 
> > + * kvm_pgtable_stage2_pgd_size() - Helper to compute size of a stage-2 PGD
> > + * @vtcr:	Content of the VTCR register.
> > + *
> > + * Return: the size (in bytes) of the stage-2 PGD
> > + */

I'll also check this is valid kernel-doc before adding the new comment
syntax!

> > +/*
> > + * Holds the relevant data for maintaining the vcpu state completely at hyp.
> > + */
> > +struct kvm_shadow_vcpu_state {
> > +	/* The data for the shadow vcpu. */
> > +	struct kvm_vcpu shadow_vcpu;
> > +
> > +	/* A pointer to the host's vcpu. */
> > +	struct kvm_vcpu *host_vcpu;
> > +
> > +	/* A pointer to the shadow vm. */
> > +	struct kvm_shadow_vm *shadow_vm;
> 
> IMHO, those declarations are already self-explanatory. The comments above don't
> bring much.

Agreed, and Sean has ideas to rework bits of this as well. I'll drop the
comments.

> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 99c8d8b73e70..77aeb787670b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -7,6 +7,9 @@
> >  #include <linux/kvm_host.h>
> >  #include <linux/mm.h>
> >  #include <nvhe/fixed_config.h>
> > +#include <nvhe/mem_protect.h>
> > +#include <nvhe/memory.h>
> 
> I don't think this one is necessary, it is already included in mm.h.

I thought it was generally bad form to rely on transitive includes, as it
makes header rework even more painful than it already is.

> > +static void unpin_host_vcpus(struct kvm_shadow_vcpu_state *shadow_vcpu_states,
> > +			     unsigned int nr_vcpus)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < nr_vcpus; i++) {
> > +		struct kvm_vcpu *host_vcpu = shadow_vcpu_states[i].host_vcpu;
> 
> IIRC, checkpatch likes an empty line after declarations.

We can fix that!

> > +static unsigned int insert_shadow_table(struct kvm *kvm,
> > +					struct kvm_shadow_vm *vm,
> > +					size_t shadow_size)
> > +{
> > +	struct kvm_s2_mmu *mmu = &vm->kvm.arch.mmu;
> > +	unsigned int shadow_handle;
> > +	unsigned int vmid;
> > +
> > +	hyp_assert_lock_held(&shadow_lock);
> > +
> > +	if (unlikely(nr_shadow_entries >= KVM_MAX_PVMS))
> > +		return -ENOMEM;
> > +
> > +	/*
> > +	 * Initializing protected state might have failed, yet a malicious host
> > +	 * could trigger this function. Thus, ensure that shadow_table exists.
> > +	 */
> > +	if (unlikely(!shadow_table))
> > +		return -EINVAL;
> > +
> > +	/* Check that a shadow hasn't been created before for this host KVM. */
> > +	if (unlikely(__exists_shadow(kvm)))
> > +		return -EEXIST;
> > +
> > +	/* Find the next free entry in the shadow table. */
> > +	while (shadow_table[next_shadow_alloc])
> > +		next_shadow_alloc = (next_shadow_alloc + 1) % KVM_MAX_PVMS;
> 
> Couldn't it be merged with __exists_shadow which already knows the first free
> shadow_table idx?

Good idea, that would save us going through it twice.

> 
> > +	shadow_handle = idx_to_shadow_handle(next_shadow_alloc);
> > +
> > +	vm->kvm.arch.pkvm.shadow_handle = shadow_handle;
> > +	vm->shadow_area_size = shadow_size;
> > +
> > +	/* VMID 0 is reserved for the host */
> > +	vmid = next_shadow_alloc + 1;
> > +	if (vmid > 0xff)
> 
> Couldn't the 0xff be found with get_vmid_bits() or even from host_kvm.arch.vtcr?
> Or does that depends on something completely different?
> 
> Also, appologies if this has been discussed already and I missed it, maybe
> KVM_MAX_PVMS could be changed for that value - 1. Unless we think that archs
> supporting 16 bits would waste way too much memory for that?

We should probably clamp the VMID based on KVM_MAX_PVMS here, as although
some CPUs support 16-bit VMIDs, we don't currently support that with pKVM.
I'll make that change to avoid hard-coding the constant here.

Thanks!

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
