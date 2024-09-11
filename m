Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA64819CC31
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 15:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726069897; cv=none; b=JUJWHMeMbQZ6EH5qweyv5YMuvoyJVxNLYoZefHJQQpz65bkJAb3uFvfZqeMC3vA8zhTc/NZEuHZ5XLdTDeYm6cKKJfY2dz/ilrpF1P5BZsVFss3BIq3jmt68IFZwjenAa0lR3FXtDkkNua39V8rFnHy85bF6oCZW5j5c8F/tzp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726069897; c=relaxed/simple;
	bh=DJcG4Jwz42u8yWiFSfRgZEJvIBcA6akcJZnWRTWkVcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mcZJsWVyihAjzolUfyGjox/j2z89GBLqxchMomb8X4gRmDj2FJC+SkrkPWl8djsYfqv6L4YpiSizjQ42e3CVZikGiqtpqEfTBcGF/J/EEdgE82r5yY2LhbY/v9LnqK0pj9hUbc7GFDlJKMI+wubALim7oxscnyQGRUUfrrvZwzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 686B01063;
	Wed, 11 Sep 2024 08:52:04 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F7FF3F66E;
	Wed, 11 Sep 2024 08:51:33 -0700 (PDT)
Date: Wed, 11 Sep 2024 16:51:28 +0100
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
Message-ID: <20240911155128.GA1087252@e124191.cambridge.arm.com>
References: <20240911135151.401193-1-maz@kernel.org>
 <20240911135151.401193-19-maz@kernel.org>
 <20240911141513.GA1080224@e124191.cambridge.arm.com>
 <86o74u6vzu.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o74u6vzu.wl-maz@kernel.org>

On Wed, Sep 11, 2024 at 04:38:45PM +0100, Marc Zyngier wrote:
> On Wed, 11 Sep 2024 15:15:13 +0100,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > On Wed, Sep 11, 2024 at 02:51:45PM +0100, Marc Zyngier wrote:
> 
> [...]
> 
> > > +static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
> > > +						struct s1_walk_info *wi,
> > > +						struct s1_walk_result *wr,
> > > +						struct s1_perms *s1p)
> > > +{
> > 
> > How about:
> > 
> > 	if (wi->hpd)
> > 		return;
> 
> I was hoping not to add anything like this, because all the table bits
> are 0 (we simply don't collect them), and thus don't have any effect.

I just thought it was more obvious that they wouldn't apply in this case, don't
feel super strongly about it.

> 
> Or did you spot any edge case where that would result in in a
> different set of permissions?
> 
> Thanks,
> 
> 	M.
> 

Thanks,
Joey
