Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07ED739B49D
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 09:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782119086; cv=none; b=ASrmCUvB96Rs0wm1AaWMdTUYH6qEXpgL6mggQqP1tyFnHDd16CEsQ+mlbGoHp1MRueTBAL3Lv3c6pG+aPyLf2j63XrmwNiFJnFWjwvk/Ssnw5MekTXlCvflAVbna8hTGLiwzHe4FwLMR1qHDIy3YdCvktySm6WdOUA2VLHPqLTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782119086; c=relaxed/simple;
	bh=HgiOx3Gxk7v+YKyg+0NTf2l18tte0N14NUCjjhZytL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QwRfPSHQyPVBXqHGk3xlxkd1dbiUsBo7+u2mokNLdxlv+NWNUwY0kxaX6T4CkiEd+fuXqRlMtAqPpYWukmMJ9A02D9lMxtNSygeG+PmP/laXhlJDmmWIdFWg7yANhiclljraU2z1xX3G3/RkYJ/+dfPZ8IPosML4+aC28+QtHoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PxbboRwp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PxbboRwp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 444D81BF3;
	Mon, 22 Jun 2026 02:04:32 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F8853F62B;
	Mon, 22 Jun 2026 02:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782119076; bh=HgiOx3Gxk7v+YKyg+0NTf2l18tte0N14NUCjjhZytL8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PxbboRwpE2vS964Ehc5mDpWLSytaoETOaqhnaSQgQLz44uCl6YrGFOX3uhGIgcLsD
	 RdxoMznAxnesiwlOTbTdRyqfY2n29clRiaQkWGw4b6Ne78MxEtPSnbHMbsGTjt58U0
	 mN2wMTADr7F/T+x6DLmQUKJw3mWIMxkAumkIuj2w=
Date: Mon, 22 Jun 2026 10:04:32 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
	jean-philippe.brucker@arm.com, andre.przywara@arm.com,
	suzuki.poulose@arm.com, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH kvmtool v2 7/7] arm64: Improve KVM_ARM_VCPU_PMU_V3_CTRL
 diagnostics
Message-ID: <ajj6oGxytFm2NE4T@raptor>
References: <20260618155001.226266-1-alexandru.elisei@arm.com>
 <20260618155001.226266-8-alexandru.elisei@arm.com>
 <ajRBpMnlcNkhWzQL@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajRBpMnlcNkhWzQL@kernel.org>

Hi Oliver,

On Thu, Jun 18, 2026 at 12:06:12PM -0700, Oliver Upton wrote:
> On Thu, Jun 18, 2026 at 04:50:01PM +0100, Alexandru Elisei wrote:
> > kvmtool issues several ioctls when configuring the PMU, and each of them
> > can fail for different reasons. Be more specific about the ioctl that
> > failed when that happens.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arm64/pmu.c | 31 ++++++++++++++++++++++++-------
> >  1 file changed, 24 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arm64/pmu.c b/arm64/pmu.c
> > index 92cacd62479e..78c15f153fad 100644
> > --- a/arm64/pmu.c
> > +++ b/arm64/pmu.c
> > @@ -12,6 +12,24 @@
> >  
> >  #include "asm/pmu.h"
> >  
> > +static const char *pmu_attr_names[] = {
> > +	[KVM_ARM_VCPU_PMU_V3_IRQ]	= "KVM_ARM_VCPU_PMU_V3_IRQ",
> > +	[KVM_ARM_VCPU_PMU_V3_INIT]	= "KVM_ARM_VCPU_PMU_V3_INIT",
> > +	[KVM_ARM_VCPU_PMU_V3_FILTER]	= "KVM_ARM_VCPU_PMU_V3_FILTER",
> > +	[KVM_ARM_VCPU_PMU_V3_SET_PMU]	= "KVM_ARM_VCPU_PMU_V3_SET_PMU",
> > +	[KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS] = "KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTER",
> > +};
> > +
> > +static const char *pmu_get_attr_name(u64 attr)
> > +{
> > +	switch (attr) {
> > +	case KVM_ARM_VCPU_PMU_V3_IRQ ... KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
> > +		return pmu_attr_names[attr];
> > +	default:
> > +		return "UNKNOWN";
> > +	}
> > +}
> > +
> >  static bool pmu_has_attr(struct kvm_cpu *vcpu, u64 attr)
> >  {
> >  	struct kvm_device_attr pmu_attr = {
> > @@ -32,13 +50,12 @@ static void set_pmu_attr(struct kvm_cpu *vcpu, void *addr, u64 attr)
> >  	};
> >  	int ret;
> >  
> > -	if (pmu_has_attr(vcpu, attr)) {
> > -		ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pmu_attr);
> > -		if (ret)
> > -			die_perror("PMU KVM_SET_DEVICE_ATTR");
> > -	} else {
> > -		die_perror("PMU KVM_HAS_DEVICE_ATTR");
> > -	}
> > +	if (!pmu_has_attr(vcpu, attr))
> > +		die_perror("KVM_HAS_DEVICE_ATTR(%s)", pmu_get_attr_name(attr));
> > +
> > +	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pmu_attr);
> > +	if (ret)
> > +		die_perror("KVM_SET_DEVICE_ATTR(%s)", pmu_get_attr_name(attr));
> >  }
> 
> The whole if (ret) die_perror(...) thing is a bit repetetive IMO. A
> treewide cleanup replacing this with macros would be nice, then you could
> stringize the ioctl under the hood.

Thank you for having a look, that's a great idea, it will avoid out of bounds
array access if KVM gets a new PMU ioctl and the name array is not updated at
the same time - that's quite possible since ioctl numbers are pulled by running
update_headers.sh, and the dependency is not obvious.

I think the compilation errors are a bit higher priority than this, and a
treewide change would more involved, possibly involving a change in behaviour
(the gic seems to propagate the error instead of calling die_perror(), for
example), would you mind if for this series I'll only introduce the macro for
the pmu and convert the rest of the code in a separate series?

Thanks,
Alex

> 
> diff --git a/arm64/pmu.c b/arm64/pmu.c
> index 5f31d6b..0d9f3df 100644
> --- a/arm64/pmu.c
> +++ b/arm64/pmu.c
> @@ -23,23 +23,19 @@ static bool pmu_has_attr(struct kvm_cpu *vcpu, u64 attr)
>  	return ret == 0;
>  }
>  
> -static void set_pmu_attr(struct kvm_cpu *vcpu, void *addr, u64 attr)
> -{
> -	struct kvm_device_attr pmu_attr = {
> -		.group	= KVM_ARM_VCPU_PMU_V3_CTRL,
> -		.addr	= (u64)addr,
> -		.attr	= attr,
> -	};
> -	int ret;
> -
> -	if (pmu_has_attr(vcpu, attr)) {
> -		ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pmu_attr);
> -		if (ret)
> -			die_perror("PMU KVM_SET_DEVICE_ATTR");
> -	} else {
> -		die_perror("PMU KVM_HAS_DEVICE_ATTR");
> -	}
> -}
> +#define kvm_set_device_attr(fd, _group, _attr, _addr)					\
> +do {											\
> +	struct kvm_device_attr __attr = {						\
> +		.group	= (_group),							\
> +		.attr	= (_attr),							\
> +		.addr	= (u64)(_addr),							\
> +	};										\
> +	int r;										\
> +											\
> +	r = ioctl((fd), KVM_SET_DEVICE_ATTR, &__attr);					\
> +	if (r)										\
> +		die_perror("KVM_SET_DEVICE_ATTR(group:"#_group", attr:"#_attr")");	\
> +} while (0)
>  
>  #define SYS_EVENT_SOURCE	"/sys/bus/event_source/devices/"
>  /*
> @@ -218,14 +214,18 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>  
>  	for (i = 0; i < kvm->nrcpus; i++) {
>  		vcpu = kvm->cpus[i];
> -		set_pmu_attr(vcpu, &irq, KVM_ARM_VCPU_PMU_V3_IRQ);
> +		kvm_set_device_attr(vcpu->vcpu_fd, KVM_ARM_VCPU_PMU_V3_CTRL,
> +				    KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
>  		/*
>  		 * PMU IDs 0-5 are reserved; a positive value means a PMU was
>  		 * found.
>  		 */
>  		if (pmu_id > 0)
> -			set_pmu_attr(vcpu, &pmu_id, KVM_ARM_VCPU_PMU_V3_SET_PMU);
> -		set_pmu_attr(vcpu, NULL, KVM_ARM_VCPU_PMU_V3_INIT);
> +			kvm_set_device_attr(vcpu->vcpu_fd, KVM_ARM_VCPU_PMU_V3_CTRL,
> +					    KVM_ARM_VCPU_PMU_V3_SET_PMU, &pmu_id);
> +
> +		kvm_set_device_attr(vcpu->vcpu_fd, KVM_ARM_VCPU_PMU_V3_CTRL,
> +				    KVM_ARM_VCPU_PMU_V3_INIT, NULL);
>  	}
>  
>  	_FDT(fdt_begin_node(fdt, "pmu"));
