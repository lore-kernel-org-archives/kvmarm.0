Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C43B242D86
	for <kvmarm@lists.linux.dev>; Fri,  5 Sep 2025 07:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757058492; cv=none; b=g9Z53Pn/I2kjiD7f15Kqxi1CZOoKg2e+c2nqtK9ytsK4IMiSeIeIz6SYYMQuwn5jo0u5A+icY3ZUQdnkMNn0qrWFNfIER4fmUSkLaEWNP8xuYeEkvbaH05XRzzWoGFHeNLOwHhIGw5cfNFIuk9uIGtftKKs0I89zVO6evW9bmDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757058492; c=relaxed/simple;
	bh=W0BZZH2P+iFH6WYZoq2yGe7BYdujIfHQopESIKmJt7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KpJkbK7OP4ejoJN16ud1buzcgDqz00729RvimaCLVLRqmNrAivM8W5hEfdpqzylddQdbKt/XO4oSLwK2wATwMJP6CwXPF5bILJ5imvDv0TrUriTSgSOA+RPveqeIya5WvHkkT53BzW0FW8wlt2+rnDAQJSjxe+5Ua8Qa42HPSvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gX10oQlv; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gX10oQlv"
Date: Fri, 5 Sep 2025 00:19:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757058488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Cn6arcdUbclsr/vvq5z2G1HjcpABmQT+ily1ikXZzo=;
	b=gX10oQlvtgYLvRCtbLmDsj/lnqodhUuFyUskskaKSm86+ujHSNCJxgFYEb1D0bcUDjYtzB
	Prjlec2O9MTnlh9J0zh0QtVfbeH2JvpTWNzBA27kJamlCYie4tzP8liVMCXPoMr2Sfn1b1
	TTsj3Wf+IDYEnpStDupm8j45eMsq+S4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	syzbot+cef594105ac7e60c6d93@syzkaller.appspotmail.com
Subject: Re: [PATCH 3/5] KVM: arm64: vgic-v3: Erase LPIs from xarray outside
 of raw spinlocks
Message-ID: <aLqPCkBktGoZZcqb@linux.dev>
References: <20250904062348.223976-1-oliver.upton@linux.dev>
 <20250904062348.223976-4-oliver.upton@linux.dev>
 <87qzwlz6l5.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87qzwlz6l5.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 05, 2025 at 08:44:38AM +0100, Marc Zyngier wrote:
> On Thu, 04 Sep 2025 07:23:46 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> > index ed0e96031a65..af224db3cf72 100644
> > --- a/include/kvm/arm_vgic.h
> > +++ b/include/kvm/arm_vgic.h
> > @@ -139,7 +139,11 @@ struct vgic_irq {
> >  	bool pending_latch;		/* The pending latch state used to calculate
> >  					 * the pending state for both level
> >  					 * and edge triggered IRQs. */
> > -	bool active;			/* not used for LPIs */
> > +	union {
> > +		bool active;		/* not used for LPIs */
> > +		bool pending_release;	/* LPI pending a release */
> > +	};
> > +
> 
> Err... no. Please don't do that. An activated LPI that hasn't been
> EOI'd yet does have the active state in the LR (yes, the original
> comment is totally broken, please remove it).

Yeah, this obviously wasn't thought about too carefully. I'll squash in
a fix unless there's something more ugly that needs addressing.

Thanks,
Oliver
