Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6318222DA13
	for <kvmarm@lists.linux.dev>; Mon, 23 Jun 2025 08:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750668069; cv=none; b=WrSkdiYiGezuTCzgE9QBhxbBHmfaLkFEDtBsc3xU0VxgZ6Njva5byy7qanNGsPjdNIqJrwEDT6CKtQGntu22MPnK/aEX9Tm97bL6XxLNejpuA0g79kCGFOq7KSeqzOtDRLSrUqLZINznC1Tf1ptFaaQAXZJa22JKaByQ5unMi6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750668069; c=relaxed/simple;
	bh=dK2/nk5Dk95inlWUhVxlyOVlxm1wOh6kKl2zKSksdrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GcENUjDeznL+DMA57vuLjoTXlWL7M8GKBMfLV7ORVNihyRpFRQVXTa/TqBfrvIrjkIZUyNt+RJLBGzjpXkJELkMFmE0AV26sYWrlplzx1+qk7JcaVDM/Fh6Sv1ypUN19EBUmaaFsHr0FsyN7QA/MllZr3a+rgCYxoFsCUCwzdx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vXhgy8BI; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vXhgy8BI"
Date: Mon, 23 Jun 2025 01:40:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750668060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r16EnTRqICp2s4o/VmEbqOJZDlq1jQbD4/5SrPKHiGk=;
	b=vXhgy8BI2eQT3nYZFNPvge0v3pNI+5OHueB5YbHaYwCW+TT9AQHY0yJHWTYeBTTKK+bXVc
	oi5EsbsszqVgdBVJtFUje6uy4RYpnmR43FqwM9HnWzxpkObe9VzrsPqZmevtpEJmO2Wy/Y
	zdyKSvNt+gzmZ8O3Ny3eRiR0q/supVI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Ananta <rananta@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/4] KVM: arm64: Introduce attribute to control
 GICD_TYPER2.nASSGIcap
Message-ID: <aFkTDmj9u1ERnvHO@linux.dev>
References: <20250613155239.2029059-1-rananta@google.com>
 <20250613155239.2029059-4-rananta@google.com>
 <87frftfpg7.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87frftfpg7.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 21, 2025 at 09:50:48AM +0100, Marc Zyngier wrote:
> On Fri, 13 Jun 2025 16:52:37 +0100, Raghavendra Rao Ananta <rananta@google.com> wrote:
> > @@ -683,8 +714,14 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
> >  			return 0;
> >  		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
> >  			return 0;
> > +		default:
> > +			return -ENXIO;
> >  		}
> > +	case KVM_DEV_ARM_VGIC_GRP_FEATURES:
> > +		return attr->attr != KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap ?
> > +		       -ENXIO : 0;
> 
> Do we really want to advertise KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap even
> when we don't have GICv4.1? This seems rather odd. My take on this API
> is that this should report whether the feature is configurable, making
> it backward compatible with older versions of KVM.

So this was because of me, as I wanted nASSGIcap to behave exactly like
the ID registers. I do think exposing the capability unconditionally is
useful, as otherwise there's no way to definitively say whether or not
the underlying platform supports GICv4.1.

KVM_HAS_DEVICE_ATTR can't be used alone for probing since old kernels
use GICv4.1 but don't expose the attribute.

Does that make sense?

Thanks,
Oliver
