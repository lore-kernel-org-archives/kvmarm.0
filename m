Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29E327CB35
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 21:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220206; cv=none; b=tvxqGKby+f9/Rb2IWhRV005Qy5lhgZajQJ6zZ3/R5kNC5Tes8eqHCA1sCo3WYhudPhVr4iw13oVyc4k9PJ7Qyd5zTtvcPge2qYKGUfBjBXl626lfBaiv2H3J+vMUQa5EkYtXkbZhk22N6a0POSwfYqxdvVkgxc8wojTL3f8rZM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220206; c=relaxed/simple;
	bh=ar26MvjIB/BOwHPrOjxmWzi7Qv0GZjyDJaqnU9Lo/to=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZsFLUkuaM6KsFFSxhGc//yn3KWD7JJQmXCzJk6oRuX3sFtATsUHEaUsvbHqz/Yd9RlytsIbp44T3P0JuOASv/sGNQ0VneJ1rWYGST6E30aTQ5hoiPvKcyUtIPgw//3FFthKWENvTXuASnoMBFOIRDVHHJUgA1Xpcpdd7E7bu03w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ASZTzEmZ; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ASZTzEmZ"
Date: Tue, 22 Jul 2025 14:36:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753220201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LiRSt3+98EGMgN3IxrWiHbm2Se5ENuudfER0VQONOHY=;
	b=ASZTzEmZO4NJRCnsjCzONfIH1bE7fwzy/IgXsI7VjhyexHKhbnYOtAs4i4yndQosVFmhfO
	CxanmV5eMHKDBN7PfFSVL6zhuo7BAOFYEvdMNHPdGjyy2lILsjLAQcJ0ub0edo0FmN43yF
	cJhVJwOBNUV6I3YsaNrrsjA8xVm2PLI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Eric Auger <eauger@redhat.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Zhou Wang <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v4 1/6] KVM: arm64: Disambiguate support for vSGIs v.
 vLPIs
Message-ID: <aIAEUU_1eCbuM9YT@linux.dev>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-2-oliver.upton@linux.dev>
 <50eee3a2-55d5-4128-8b42-47a37306b8a1@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50eee3a2-55d5-4128-8b42-47a37306b8a1@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 14, 2025 at 12:20:14PM +0200, Eric Auger wrote:
> Ho Oliver,

Yo -- Eric! Sorry for the latency, ${WORK}.

> On 7/9/25 11:14 PM, Oliver Upton wrote:
> > vgic_supports_direct_msis() is a bit of a misnomer, as it returns true
> > if either vSGIs or vLPIs are supported. Pick it apart into a few
> > predicates and replace some open-coded checks for vSGIs.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/vgic/vgic-init.c    |  4 ++--
> >  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 16 ++++++++++------
> >  arch/arm64/kvm/vgic/vgic-v4.c      |  4 ++--
> >  arch/arm64/kvm/vgic/vgic.c         |  4 ++--
> >  arch/arm64/kvm/vgic/vgic.h         |  7 +++++++
> >  5 files changed, 23 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > index eb1205654ac8..5e0e4559004b 100644
> > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > @@ -395,7 +395,7 @@ int vgic_init(struct kvm *kvm)
> >  	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
> >  	 * enable it if we present a virtual ITS to the guest.
> the above comment refers to vSGISs. While the below change looks OK, I
> feel difficult to associate it to the code below.

I'm not sure the comment serves much purpose at this point. If anything,
it should go with the implementation of vgic_supports_direct_irqs()

> >  	 */
> > -	if (vgic_supports_direct_msis(kvm)) {
> > +	if (vgic_supports_direct_irqs(kvm)) {
> >  		ret = vgic_v4_init(kvm);
> >  		if (ret)
> >  			goto out;
> > @@ -443,7 +443,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
> >  		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
> >  	}
> >  
> > -	if (vgic_supports_direct_msis(kvm))
> > +	if (vgic_supports_direct_irqs(kvm))
> >  		vgic_v4_teardown(kvm);
> >  
> >  	xa_destroy(&dist->lpi_xa);
> > diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > index ae4c0593d114..1a9c5b4418b2 100644
> > --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> > @@ -50,8 +50,12 @@ bool vgic_has_its(struct kvm *kvm)
> >  
> >  bool vgic_supports_direct_msis(struct kvm *kvm)
> >  {
> > -	return (kvm_vgic_global_state.has_gicv4_1 ||
> > -		(kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm)));
> > +	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
> > +}
> > +
> > +bool vgic_supports_direct_sgis(struct kvm *kvm)
> > +{
> > +	return kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi();
> In some checks we now have "&& gic_cpuif_has_vsgi()" added whereas we
> previously only checked kvm_vgic_global_state.has_gicv4_1. This may be
> described in the commit message too and explain whether this is a fix
> for some configs.

Happy to add a mention to the changelog since this is definitely a
subtle bugfix. Although I hope there aren't any actual implementations
like this (i.e. GICv4.1 ITS w/o ability to deliver vSGIs)

Thanks for having a look,
Oliver
