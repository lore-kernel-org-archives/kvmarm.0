Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB3F19922
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 17:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBADC433EF;
	Thu,  8 Jun 2023 17:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686244878;
	bh=+1JMZudb5uniaYe3Y3wFcz2tkfuMGhPDOo6QPhGbJeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hvsQRNBUpffh2bzrvN4vsPMPOZ/NuzUw6AHwjYs+TmO/+5bq/B1NLn/y9DvjM3vhD
	 qSYXcAB1x479VEs7sJKgWqnpn1IxrjyvRCEHsQpzVJ2wAtqfyTdzWnp2kqDYhndLTF
	 7lNh5AlZn4b7Gp1kiAVotShPo4PJIvxx5SJexnBt7DGohA6CcKd2HCSbS0Y09VYk6M
	 y5iOpEOFO7lRNIFm9ZNMfqWzNmIBEOylkDaVyxyf5C+GS0RZkmTx2ywWbtBx80IMXu
	 aFRCzIeUuHSohx/8P4St1qor5bg+AYU8lVoMceWtUHz66aZlJ1OC/N/AgBafHJP/j1
	 +WU4ndAfymBuA==
Date: Thu, 8 Jun 2023 18:21:13 +0100
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Colton Lewis <coltonlewis@google.com>,
	kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/3] KVM: arm64: Skip break phase when we have FEAT_BBM
 level 2
Message-ID: <20230608172112.GA1606@willie-the-truck>
References: <20230602170147.1541355-1-coltonlewis@google.com>
 <20230602170147.1541355-4-coltonlewis@google.com>
 <87sfb7octw.wl-maz@kernel.org>
 <ZH5VQMEoiHEITmF4@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH5VQMEoiHEITmF4@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jun 05, 2023 at 02:36:00PM -0700, Oliver Upton wrote:
> On Sun, Jun 04, 2023 at 09:23:39AM +0100, Marc Zyngier wrote:
> > On Fri, 02 Jun 2023 18:01:47 +0100, Colton Lewis <coltonlewis@google.com> wrote:
> > > +static bool stage2_try_make_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu, kvm_pte_t new)
> > >  {
> > >  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > > 
> > > -	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> > > +	if (!stage2_has_bbm_level2())
> > > +		WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> > > +
> > > +	if (!stage2_try_set_pte(ctx, new))
> > > +		return false;
> > > +
> > > +	if (kvm_pte_table(ctx->old, ctx->level))
> > > +		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> > > +	else if (kvm_pte_valid(ctx->old) && !stage2_pte_perms_equal(ctx->old, new))
> > > +		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, mmu, ctx->addr, ctx->level);
> > 
> > Why a non-shareable invalidation? Nothing in this code captures the
> > rationale for it. What if the permission change was a *restriction* of
> > the permission? It should absolutely be global, and not local.
> 
> IIRC, Colton was testing largely with permission relaxation, and had
> forward progress issues b.c. the stale TLB entry was never invalidated
> in response to a permission fault.

Would the series at:

https://lore.kernel.org/r/5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com

help with that?

Will
