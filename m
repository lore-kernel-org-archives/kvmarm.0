Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D42C2153CB
	for <kvmarm@lists.linux.dev>; Mon, 23 Jun 2025 09:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670773; cv=none; b=klLa+biU1GOwmrNtW9FfRi12a/ub5JUGVKsJIcEyYy/ecEnokpI2JoYvlUulNDbNTrV9kDVh46Av918LmrXs3yRHJ16BxgbYbuWCNgNIn3x4R2Te7JrZswapZpFHiJhNL1kL5WGxHuAjic3fYLbEOQ5NFNj4jiWLu6gAPx/qIv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670773; c=relaxed/simple;
	bh=Vv4ayd7W7DMeee5o7ChnZuQvv6LMAkcOZqMkG0vkIb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S7qBR2GO16btoeMiMg1U7cD/nLA9sKz98B5MnDFQ8MHY8aclEG8R10vbz4sq5w4qx6JusFePFwNYPI34fs8zlFwmg8xm1qAapimNsyTynYFBScas4BV8VvngPaddEArY1ATgbtl281dr2kJ4/lWh1iYPYNK+iudpQ3oBzn4RJ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rA/N5fxM; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rA/N5fxM"
Date: Mon, 23 Jun 2025 02:25:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750670765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tZQ09S5HUXQL8QzEMqvPTcx0P4EQYBwyl6nfwHAEjAk=;
	b=rA/N5fxMhzQdApW5Xv7M+X1a139TwAKG9UaWY2mpQpeEc/c+dIet3ZFxIS0LV2rCru/SXL
	fzQKIqSKK8k7HU15zCSL2sZA6TYN2LfAYSGv33CQx46tpWptwXBDeTV/rQXBr9Pu/6ZhS7
	kS1R51UD95Se6iuE+blTrVPTU1UHYjc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Ananta <rananta@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/4] KVM: arm64: Introduce attribute to control
 GICD_TYPER2.nASSGIcap
Message-ID: <aFkdofSolis53JgO@linux.dev>
References: <20250613155239.2029059-1-rananta@google.com>
 <20250613155239.2029059-4-rananta@google.com>
 <87frftfpg7.wl-maz@kernel.org>
 <aFkTDmj9u1ERnvHO@linux.dev>
 <868qliddzt.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868qliddzt.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 23, 2025 at 10:05:42AM +0100, Marc Zyngier wrote:
> On Mon, 23 Jun 2025 09:40:46 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Sat, Jun 21, 2025 at 09:50:48AM +0100, Marc Zyngier wrote:
> > > On Fri, 13 Jun 2025 16:52:37 +0100, Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > > @@ -683,8 +714,14 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
> > > >  			return 0;
> > > >  		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
> > > >  			return 0;
> > > > +		default:
> > > > +			return -ENXIO;
> > > >  		}
> > > > +	case KVM_DEV_ARM_VGIC_GRP_FEATURES:
> > > > +		return attr->attr != KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap ?
> > > > +		       -ENXIO : 0;
> > > 
> > > Do we really want to advertise KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap even
> > > when we don't have GICv4.1? This seems rather odd. My take on this API
> > > is that this should report whether the feature is configurable, making
> > > it backward compatible with older versions of KVM.
> > 
> > So this was because of me, as I wanted nASSGIcap to behave exactly like
> > the ID registers. I do think exposing the capability unconditionally is
> > useful, as otherwise there's no way to definitively say whether or not
> > the underlying platform supports GICv4.1.
> > 
> > KVM_HAS_DEVICE_ATTR can't be used alone for probing since old kernels
> > use GICv4.1 but don't expose the attribute.
> > 
> > Does that make sense?
> 
> My own reasoning is that if we expose the capability, userspace is
> able to use it and rely on it to take effect (VPE allocation error
> notwithstanding). This is not the case with this approach, and that's
> at odds with the other attributes.
> 
> But taking a step back: if we want to control the nASSGIcap bit, why
> don't we allow writing to GICD_TYPER2 from userspace? This does
> matches your view that we treat it as an ID register (GICD_TYPER2
> matches this definition if you squint hard enough). It also avoids
> adding new UAPI with unusual semantics.

This approach would bring its own set of complications. At least right
now we allocate vPEs at vgic_init() but prevent register accesses prior
to initialization. If we want to bake this thing into GICD_TYPER2
directly we either need to relax this register to be accessed before
init or defer the vPE allocation later on.

I'm worried that the latter approach is gonna be a mess, and the
attribute was done to avoid a one-off accessor in the VGIC state. But if
you'd like to see it done that way then that's OK with me.

Thanks,
Oliver
