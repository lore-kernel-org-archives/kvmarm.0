Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE314FC346
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790026115; cv=none; b=YjiVWrBiR5keCpimpIji54g+ahb2erXKJ9c2bvN3PTOijKYhvGmdJwC31YaRMpJ9fkGGDvbA5NmKxsghxLjdZeC69hCnhFu/cHUhaigpPZ8ZVVFUOMNqDzjuCytUHpcZpm5NMEYCAY9Tc+DqhyuF/zZRXdMoVijlE8lNx//e+Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790026115; c=relaxed/simple;
	bh=WtIwvf/euxf2hGsr57rC8KqJEVr4lsGKbhwiI3tyl+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QAEDJM50ymuP5MNZ7H718dvawnpbkcbS4D8sjf0UFHdSjqzzigX5SO9uu5sBnCr/m9HvJCAkWmDAPITKkyeZ0TpmlMQKcaj2JW5/LjuFDo2XmJRvSZ+ToWhya/M197fB3I25VZhzLSoMUILxsbhtrKWw+IVzAX1siK0a5zFNtlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eJefezYH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eJefezYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843811F000FF;
	Mon, 21 Sep 2026 21:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790026113;
	bh=pzJgMWo5k58EgcOYrAXQGbvTalL1yXdhMjwG6gSIlDw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eJefezYH0UEeMEijBzEK93agALfvOw2vSm1gp01piBY4DACDXtEMsFhf6muXlJUax
	 i6yWVYzlnRrK8/z6PgmJMLrH0Rh9H2RxizxcWINjjaY0pq/O7MAuMXdTBIejd183LK
	 wLs8FUluM5RGMOB4eWKcaB/tBJBCMZ4P9pZOwBa/ExOmXFaMdX8hPXGKdqCksQizCT
	 hKqqA08eK5UA03HPtD20khEODFf6cHltR9wBM1VbD4B92XUh3tdFf8ty8bQ/EZhR7v
	 tQoVTSmXSeZvi59wyvudyMdXuUrXujsZ/8LKG62j0ZenvGzCxbU2q6lDbMIjgKDSG2
	 nZoe4YYOGxREA==
Date: Mon, 21 Sep 2026 14:28:32 -0700
From: Oliver Upton <oupton@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 02/22] KVM: arm64: nv: Consolidate computation of stage-2
 permissions
Message-ID: <arGhgGB5icVpDxnQ@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-3-oupton@kernel.org>
 <arE1KVBNtkEWJDvN@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arE1KVBNtkEWJDvN@LeoBrasDK>

Hi Leo,

On Mon, Sep 21, 2026 at 02:46:17PM +0100, Leonardo Bras wrote:
> > +static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
> > +				   struct s2_walk_step *ws, struct kvm_s2_trans *trans)
> > +{
> > +	u8 s2ap = FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S2_S2AP, ws->desc);
> > +	u8 xn = FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, ws->desc);
> > +
> > +	if (!kvm_has_xnx(vcpu->kvm))
> > +		xn &= 0b10;
> > +
> > +	switch (xn) {
> > +	case 0b00:
> > +		trans->px = trans->ux = true;
> > +		break;
> > +	case 0b01:
> > +		trans->px = false;
> > +		trans->ux = true;
> > +		break;
> > +	case 0b10:
> > +		trans->px = trans->ux = false;
> > +		break;
> > +	case 0b11:
> > +		trans->px = true;
> > +		trans->ux = false;
> > +		break;
> > +	}
> > +
> 
> Nit: couldn't the above be summarized as below?
> 
> 	trans->ux = !(xn & BIT(1));
> 
> 	if (kvm_has_xnx(vcpu->kvm) && xn & BIT(0)) 
> 		trans->px = !trans->ux;
> 	else
> 		trans->px = trans->ux;
> 					
> 
> or maybe even skip the FIELD_GET and do:
> 
> 	trans->ux = !(ws->desc & KVM_PTE_LEAF_ATTR_HI_S1_UXN);
> 
> 	if (kvm_has_xnx(vcpu->kvm) &&
> 	    ws->desc & KVM_PTE_LEAF_ATTR_HI_S1_PXN) 
> 		trans->px = !trans->ux;
> 	else
> 		trans->px = trans->ux;
> 
> 
> Maybe it's just me, but that looks easier to understand what each bit does 
> based on the feature.

I had opted for a switch statement because I think it's a direct
translation of the truth table in R_STCTY.

> FWIW:
> Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!

Best,
Oliver
