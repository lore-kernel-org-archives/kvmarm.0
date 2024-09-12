Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 090B8192B6D
	for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726135483; cv=none; b=qIn9q4WTdR2e31FYUmnowTZfRN7NLW7AuaJOzA2ByaCDciy4ra3PrdN7cJH/OJPvqZ24XMfWBOSDHLCl7l8aH2Nf0SLxbTNB+BrhaHoxLYAFX6E2uD9DUxfr4VWVoP7nhAqUsH7HClhyBSFmKpHir9sqMYNt1SFRsziyS7URmss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726135483; c=relaxed/simple;
	bh=9g5kxZXNC+JzmL6CmFu2yIDGL/vmZExNTwoAcSSACkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTlO1BW1OW21FHFVa3M8+0D/h3TiEmzUvO3/HcsFwONjegTMDgAQfnlJinn8DNnxPxqsXZokgE/T+Tdaai0/CXH1lEfERehoDuPuqDxanj8maK5OsZdGeR6evxx3Qbu1xPk1gJ8tE2OlKJg3WI4WSbBTuvwljTsqO4uE3JsHaoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B82D6DA7;
	Thu, 12 Sep 2024 03:05:09 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D10A63F73B;
	Thu, 12 Sep 2024 03:04:38 -0700 (PDT)
Date: Thu, 12 Sep 2024 11:04:33 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 18/24] KVM: arm64: Split S1 permission evaluation into
 direct and hierarchical parts
Message-ID: <20240912100433.GA1162893@e124191.cambridge.arm.com>
References: <20240911135151.401193-1-maz@kernel.org>
 <20240911135151.401193-19-maz@kernel.org>
 <20240911141513.GA1080224@e124191.cambridge.arm.com>
 <86o74u6vzu.wl-maz@kernel.org>
 <20240911155128.GA1087252@e124191.cambridge.arm.com>
 <86mske6ujn.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86mske6ujn.wl-maz@kernel.org>

On Wed, Sep 11, 2024 at 05:10:04PM +0100, Marc Zyngier wrote:
> On Wed, 11 Sep 2024 16:51:28 +0100,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > On Wed, Sep 11, 2024 at 04:38:45PM +0100, Marc Zyngier wrote:
> > > On Wed, 11 Sep 2024 15:15:13 +0100,
> > > Joey Gouly <joey.gouly@arm.com> wrote:
> > > > 
> > > > On Wed, Sep 11, 2024 at 02:51:45PM +0100, Marc Zyngier wrote:
> > > 
> > > [...]
> > > 
> > > > > +static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
> > > > > +						struct s1_walk_info *wi,
> > > > > +						struct s1_walk_result *wr,
> > > > > +						struct s1_perms *s1p)
> > > > > +{
> > > > 
> > > > How about:
> > > > 
> > > > 	if (wi->hpd)
> > > > 		return;
> > > 
> > > I was hoping not to add anything like this, because all the table bits
> > > are 0 (we simply don't collect them), and thus don't have any effect.
> > 
> > I just thought it was more obvious that they wouldn't apply in this case, don't
> > feel super strongly about it.
> 
> If you want it to be obvious, how about this instead?
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 8a5e1c4682619..fb9de5fc2cc26 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -985,7 +985,8 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu, u32 op,
>  	else
>  		compute_s1_indirect_permissions(vcpu, wi, wr, s1p);
>  
> -	compute_s1_hierarchical_permissions(vcpu, wi, wr, s1p);
> +	if (!wi->hpd)
> +		compute_s1_hierarchical_permissions(vcpu, wi, wr, s1p);
>  
>  	if (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) {
>  		bool pan;
> 

That's even better, if you're happy to include it.

> 
> Thanks,
> 
> 	M.

Thanks,
	J.

> 
> -- 
> Without deviation from the norm, progress is not possible.
