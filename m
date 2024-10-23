Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC5E1CB301
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 16:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729701552; cv=none; b=bWd7pRpOvbnlzS68/KqjDdOOoFKuwRzOvo025Z+Mumi62xnDAbd5ZalJGZtFb1a8dPaB+TuySXlR7C7EQmgKNwAiK3rg1DSyw3z1Js64Yc3YK52Dd/PeZGdgSCAgsFL1d/U3PgCLwa6qvVcpwB0pM84323UmDerTdMomhqqzhN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729701552; c=relaxed/simple;
	bh=gHkjsIBl2zCdBHabptiDZ7pNg52KgG/kROIPc6mU2+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KXlAxN6BvscPAONGdU2AjtzXlZdky5rFUSfblJIFaRkT9f48aXm8BApyPvgoruhWeOgc+ytyGk/oZsBvwYpJpQEqIUno64PKctRQxaRrBJVtzpuB2QyzR/cXhXHXW2YmoXj7J2IUBSnbP2NsY5rzWYZLPuTijfpFeDKjF65rHI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pztSQ2Cu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pztSQ2Cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C27BC4CEC6;
	Wed, 23 Oct 2024 16:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729701552;
	bh=gHkjsIBl2zCdBHabptiDZ7pNg52KgG/kROIPc6mU2+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pztSQ2CuekR85kezundgpCWe8ZdHIWxiO+YK3jULQx5DPzZvq/Ou3DmUS9fjUpAqf
	 +f/9BxxkaxsAfnrdXqAc6EIN33Yo7WGsOOyRAXDHL6MelgurG/x9HAGfapE6j5Co18
	 dlxpDBmYn9LrhsWksBld1ZnSboYMSm9ZWJtDvZdeXJYzq4pn0ZaL5prsfbHSJi1phf
	 e0z/UzzPjfltFYS7LYJcH180ZM8sZU5D5BAwZXfdQ3nOPqh6kCwFJeI0mw3LqAg7Ip
	 St4K8pkkOk7l7FXgIjzzooR7/y49VQ4WBkcVn+AbU8gEaibFLYNIWBoCGPimmJfEmQ
	 A9f3dB0Q9q6fQ==
Date: Wed, 23 Oct 2024 17:39:08 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/2] KVM: arm64: Don't map 'kvm_vgic_global_state' at EL2
 with pKVM
Message-ID: <20241023163907.GD29251@willie-the-truck>
References: <20241022144016.27350-1-will@kernel.org>
 <20241022144016.27350-3-will@kernel.org>
 <865xpk3wde.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865xpk3wde.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Oct 22, 2024 at 06:01:17PM +0100, Marc Zyngier wrote:
> On Tue, 22 Oct 2024 15:40:16 +0100,
> Will Deacon <will@kernel.org> wrote:
> > 
> > Now that 'kvm_vgic_global_state' is no longer needed for ICC_CTLR_EL1
> > emulation on machines with a broken SEIS implementation, drop the
> > pKVM hypervisor mapping of the page.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Oliver Upton <oliver.upton@linux.dev>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/setup.c | 17 -----------------
> >  1 file changed, 17 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > index 174007f3fadd..8fec099c2775 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > @@ -95,7 +95,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
> >  {
> >  	void *start, *end, *virt = hyp_phys_to_virt(phys);
> >  	unsigned long pgt_size = hyp_s1_pgtable_pages() << PAGE_SHIFT;
> > -	enum kvm_pgtable_prot prot;
> >  	int ret, i;
> >  
> >  	/* Recreate the hyp page-table using the early page allocator */
> > @@ -148,22 +147,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
> >  	}
> >  
> >  	pkvm_create_host_sve_mappings();
> > -
> > -	/*
> > -	 * Map the host sections RO in the hypervisor, but transfer the
> > -	 * ownership from the host to the hypervisor itself to make sure they
> > -	 * can't be donated or shared with another entity.
> > -	 *
> > -	 * The ownership transition requires matching changes in the host
> > -	 * stage-2. This will be done later (see finalize_host_mappings()) once
> > -	 * the hyp_vmemmap is addressable.
> > -	 */
> > -	prot = pkvm_mkstate(PAGE_HYP_RO, PKVM_PAGE_SHARED_OWNED);
> > -	ret = pkvm_create_mappings(&kvm_vgic_global_state,
> > -				   &kvm_vgic_global_state + 1, prot);
> > -	if (ret)
> > -		return ret;
> > -
> >  	return 0;
> >  }
> 
> Maybe add a note indicating that nVHE/hVHE still have that particular
> mapping via the rodata section?

I can add something to the commit message, is that what you had in mind?

> Reviewed-by: Marc Zyngier <maz@kernel.org>

Thanks!

Will
