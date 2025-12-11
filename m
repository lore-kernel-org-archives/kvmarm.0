Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD5B239567
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 09:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765445628; cv=none; b=nIVCn1QytSyFo1yIeQr0DLnr19WHI1/hI/GVYBvpAZxU6ulDzjQ2i/4Pq4r9hV6vgRvb/i4e2T6soC6VDuXoKKVnl4JJKXIJhoH28ZbVPn8UJhz1qcZDqPgu8TGI8JnMpBdV6W7q4nnkLhWwcayHZYqTWmQg1u9j5IxVC1erVVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765445628; c=relaxed/simple;
	bh=hmfsFF7nWW1MNifDGPOiey6zKLj8xrPrYNRWY8Bq9kg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCE8+UR3xXDFCUkNuHrBqh5Idva4Cwh+FW0mm/2OaJu1Jtlag1foSOIHsdzi+52AVJ0WiuH3FfhYDkIzsJtLWHhK9U1ZBEyJMCpSnjZaXL6/XlB3phVzDxBCtC/m6U0IELKtasAuzZIEI+cjmtJ/NYsdr3FP4eI4nAOfCVNctik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0974F153B;
	Thu, 11 Dec 2025 01:33:38 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2B033F740;
	Thu, 11 Dec 2025 01:33:43 -0800 (PST)
Date: Thu, 11 Dec 2025 09:33:40 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, qperret@google.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/2] KVM: arm64: Remove extra argument for
 __pvkm_host_{share,unshare}_hyp()
Message-ID: <aTqP9M_E7ROGpfbB@raptor>
References: <20251210132102.137631-1-alexandru.elisei@arm.com>
 <20251210132102.137631-3-alexandru.elisei@arm.com>
 <86zf7po2n3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86zf7po2n3.wl-maz@kernel.org>

Hi Marc,

On Thu, Dec 11, 2025 at 08:15:28AM +0000, Marc Zyngier wrote:
> On Wed, 10 Dec 2025 13:21:02 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > __pvkm_host_share_hyp() and __pkvm_host_unshare_hyp() both have one
> > parameter, the pfn, not two. Even though correctness isn't impacted because
> > the SMCCC handlers pass the first argument and ignore the second one, let's
> > call the functions with the proper number of arguments.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 7cc964af8d30..6c6abcd8e89e 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -497,7 +497,7 @@ static int share_pfn_hyp(u64 pfn)
> >  	this->count = 1;
> >  	rb_link_node(&this->node, parent, node);
> >  	rb_insert_color(&this->node, &hyp_shared_pfns);
> > -	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn, 1);
> > +	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
> >  unlock:
> >  	mutex_unlock(&hyp_shared_pfns_lock);
> >  
> 
> Yeah, we lost all form of type-checking when everything was hastily
> converted to SMCCC to avoid function pointers. Somehow, I feel that
> the cure was worse than the disease.
> 
> I wish we'd reintroduce some form of compile-time checks, maybe by
> having generated stubs?

I also think compile-time checks would be useful, do you have something
particular in mind?

If not, right now I can't think of a way to generate the stubs automagically,
but I can give it a (probably bad) try and take it from there.

Thanks,
Alex
