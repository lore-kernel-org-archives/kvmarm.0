Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D952989BC
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 17:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769101519; cv=none; b=RBkROPoI2NR66coZkl/0demPhqxJLQGNV0iTa1tBV76Ce+GiUcn00qm1mhNQpTf9B7DHvk+jrJlW66CKVf+jLXnlOdcE+qlK9mnU8rMxqgB8+BuG8YYBS6AKR4HigPli7fmeuoS3+ONaPeWFIJzF9U9Uhr2K0B7AOws5qaGZ+YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769101519; c=relaxed/simple;
	bh=oGwVJwPhkUypqjfPNP7lgeDm0bczOg2CvbFMzcz+o7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mOE/tFwgBAL/mG7Wzgg9hMaHEpJmodTDYSW4pFmPD9cH1XG10NrK48mp+5GbRoSO55BYUhUpmXpanbkDhGJhpowxl4LES+DiSW90Bn7mvVXzjJdvUARwfpp/7EFqkQeF95wtzLdFreazp8fCQnaU4t2GUta+X6MUFex68iYpPS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rTiRn1y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rTiRn1y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48B4C116C6;
	Thu, 22 Jan 2026 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769101518;
	bh=oGwVJwPhkUypqjfPNP7lgeDm0bczOg2CvbFMzcz+o7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rTiRn1y8WqHg6NIcBpaDooI84i04C0FMbadxvr7w5YgQJWSJOxuhZCwX7pWYKQGC8
	 cjbXHtPAVIaX8FpqK0/QbsxfBll1RcPHu/ZDCWVzWGw/j539n7H1kLnd5GJS9v4DTs
	 W+Zf6Y9fUp9sESs1RGYnS7k7RA3NvL9mFgnHz5zzIJhCAM44ys45jCVn2hq5UmDTnr
	 GcUOxMizpORaFf6hm9ZDyKl+V/mRkto9Rpw1BHmL/Da0cDPnEpNK5yWOww8JiURw6w
	 Nm1AdUyNFDK71KBK/gIA9SJ7mGPP2a86+MEXtvBQOOA3IbWBtbW9ce/uoMfxWJJglO
	 jo+9dXSaTWhdQ==
Date: Thu, 22 Jan 2026 17:05:13 +0000
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 2/6] KVM: arm64: Add KVM_PGTABLE_S2_AS_S1 flag
Message-ID: <aXJYydu3SplkF68o@willie-the-truck>
References: <20260119105651.255693-1-maz@kernel.org>
 <20260119105651.255693-3-maz@kernel.org>
 <CA+EHjTzxbuyJcJRvwinrS0cqaVqMY03P6x6A8FH99onXphdjPQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzxbuyJcJRvwinrS0cqaVqMY03P6x6A8FH99onXphdjPQ@mail.gmail.com>

On Thu, Jan 22, 2026 at 03:08:32PM +0000, Fuad Tabba wrote:
> On Mon, 19 Jan 2026 at 10:56, Marc Zyngier <maz@kernel.org> wrote:
> >
> > Plumb the MT_S2{,_FWB}_AS_S1 memory types into the KVM_S2_MEMATTR()
> > macro with a new KVM_PGTABLE_S2_AS_S1 flag.
> >
> > Nobody selects it yet.
> >
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h |  2 ++
> >  arch/arm64/kvm/hyp/pgtable.c         | 13 ++++++++++++-
> >  2 files changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index fc02de43c68dd..9ce51a637da0a 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -232,10 +232,12 @@ struct kvm_pgtable_mm_ops {
> >   * @KVM_PGTABLE_S2_NOFWB:      Don't enforce Normal-WB even if the CPUs have
> >   *                             ARM64_HAS_STAGE2_FWB.
> >   * @KVM_PGTABLE_S2_IDMAP:      Only use identity mappings.
> > + * @KVM_PGTABLE_S2_AS_S1:      Final memory attributes are that of Stage-1.
> >   */
> >  enum kvm_pgtable_stage2_flags {
> >         KVM_PGTABLE_S2_NOFWB                    = BIT(0),
> >         KVM_PGTABLE_S2_IDMAP                    = BIT(1),
> > +       KVM_PGTABLE_S2_AS_S1                    = BIT(2),
> >  };
> >
> >  /**
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 947ac1a951a5b..3c5f399b1b986 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -659,7 +659,18 @@ void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> >         }
> >  }
> >
> > -#define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fwb(pgt))
> > +#define KVM_S2_MEMATTR(pgt, attr)                                      \
> > +       ({                                                              \
> > +               kvm_pte_t __attr;                                       \
> 
> nit: new line?
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>

If you're going back to fix nits then:

> > +               if((pgt)->flags & KVM_PGTABLE_S2_AS_S1)                 \

please stick a space after the 'if' as well :)

Will
