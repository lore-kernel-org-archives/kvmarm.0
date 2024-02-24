Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BFB241E3
	for <kvmarm@lists.linux.dev>; Sat, 24 Feb 2024 11:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708772572; cv=none; b=Tzqof2rBP1xE3yIRZr+f3fenN2wiejsUpDK+RET2+JYhrvGtFNPce4/+20KfSPoMiEDyqDxpFPnKix5J6mg+JjbIurPVtrp49vTJ6Ps4RV3sO7yLXV+Nk6FdXTm64RjZBvvz08YMLHKuK56ExVd8Fs0yOCxZDM25TWTS9RfWoVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708772572; c=relaxed/simple;
	bh=uNjvaojA4iNqK2eMDEKYqtYjlOdhE1jDHAvMJPe/bCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b9ZITx96Yfjnvk6i5rQxAyLURaiqtQc4OJTje+MhmVpRT48q5Avf0bhjbx5R85fshSWwcQjUYa1fq969abAU7z1Ftv2l/o2G6WFrMvo+NjMOfbDK/6M2vyZjZul4fDYVg2eCocByuQU/oPIhpoIVhg3npp+HFSzsiBxQeR2sQic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SVkU/0KO; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SVkU/0KO"
Date: Sat, 24 Feb 2024 11:02:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708772568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vuWp/+7BcPYQXEWx/FGeNBwG2S56ypB+UYiRZv6cNM4=;
	b=SVkU/0KOQbxe4zhbMr3MEjYxu/5B6QD+MuxKlmxcTzwOcIYpDaHYA0/0XmxIEgUR7ZE1pG
	tq3vAoQsj2/P9WvPOZRO1kcgG11YUhVcBQuE9mU77Zvb25s0hUH+rH4QFl/+nUDpVvoGqO
	d+Kx0MHdeBHQ6mweiSFL9KqbQn9b4Po=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 2/3] irqchip/gic-v3-its: Spin off GICv4 init into a
 separate function
Message-ID: <ZdnM0DDsGCTPMpwl@linux.dev>
References: <20240219185809.286724-1-oliver.upton@linux.dev>
 <20240219185809.286724-3-oliver.upton@linux.dev>
 <87cysm9mtv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cysm9mtv.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 24, 2024 at 10:30:04AM +0000, Marc Zyngier wrote:
> On Mon, 19 Feb 2024 18:58:07 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > @@ -3193,7 +3210,8 @@ static void its_cpu_init_lpis(void)
> >  		 * ancient programming gets left in and has possibility of
> >  		 * corrupting memory.
> >  		 */
> > -		val = its_clear_vpend_valid(vlpi_base, 0, 0);
> > +		its_clear_vpend_valid(vlpi_base, 0, 0);
> > +		return;
> 
> I'm not sure about the necessity of this return statement.
> allocate_vpe_l1_table() checks for rvpeid already, so it should be
> fine to carry on.

Yup, definitely not necessary. My aim was to have the control flow make
it a bit more obvious to the reader what's going on.

Having what reads as an allocation helper do a feature check isn't
entirely obvious.

I have no opinion either way though.

> >  	}
> >  
> >  	if (allocate_vpe_l1_table()) {
> > @@ -3205,15 +3223,6 @@ static void its_cpu_init_lpis(void)
> >  		gic_rdists->has_rvpeid = false;
> >  		gic_rdists->has_vlpis = false;
> >  	}
> > -
> > -	/* Make sure the GIC has seen the above */
> > -	dsb(sy);
> 
> ... we're now missing a dsb affecting the VPE table programming, as we
> expect things to take effect immediately.

LOL, and on the back of a bugfix no less. I'll fix this.

-- 
Thanks,
Oliver
