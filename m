Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8D616DEAA
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 16:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725901043; cv=none; b=dYjAg61xSxujweKty26VJcnPr6MQGYhVN90h9ZJxnnqqWZVoZDCxFVxQJBtZb+bFuUCXTo6HW9ubNFnFzM1cfoseSop++eDdzIVtVM6a+K8JzN3+s/XHc3BtkdoeFp1GTeM7zOOexm3YLVBZUTU6vS41N6AOjJxh7Mj9vuUslEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725901043; c=relaxed/simple;
	bh=l0qq2HkKop3cQ0mfPzt8undFd4WpalgMB8fr1QfrYHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FwJRZ1B7H33XcWnqaafkUYSUCQY9lwJDqARBOv+TZXz/ctD0AVJp4TJc7oGUXTh1baWOFe2lM2Qvuy4eOeY6EB5GzNvy2lTWSxGZ8E80CgoeQUeGcWDtuosn5fuMCRIu+AjJnz1jTlDBa/Ol11X2to2nXVpR43V9Z8oMTGVFRaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f2Kxj4M0; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f2Kxj4M0"
Date: Mon, 9 Sep 2024 16:57:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725901038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b4Q6k7ILzpbWKU+1qn7skwmOIQZSvYtkCP5tdT7H9Ek=;
	b=f2Kxj4M0Cx/cUYoZtnp4/0rQ7W3eTMy6B01E2JqADnwrBRN6RZLRdvsYonBtTFHt94kJoV
	wB6pDoH4H3zSYrfmakp7TymX/Xo/o3xugv79ZW5xkqYoD2NIQAnBrRwk20pW+jk5iYcFRU
	LOPhUuH4tEgqK9qhhD8VrA/aLEugvy8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Sebastian Ott <sebott@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	yuzenghui <yuzenghui@huawei.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v5 07/10] KVM: arm64: Treat CTR_EL0 as a VM feature ID
 register
Message-ID: <Zt8o6fStuQXANSrX@linux.dev>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
 <20240619174036.483943-8-oliver.upton@linux.dev>
 <0db19a081d9e41f08b0043baeef16f16@huawei.com>
 <864j6o94fz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864j6o94fz.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 09, 2024 at 05:28:48PM +0100, Marc Zyngier wrote:
> Hi Shameer,
> 
> On Mon, 09 Sep 2024 16:19:54 +0100,
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:
> > 
> > Hi Oliver/Sebastian,
> > 
> > > -----Original Message-----
> > > From: Oliver Upton <oliver.upton@linux.dev>
> > > Sent: Wednesday, June 19, 2024 6:41 PM
> > > To: kvmarm@lists.linux.dev
> > > Cc: Marc Zyngier <maz@kernel.org>; James Morse
> > > <james.morse@arm.com>; Suzuki K Poulose <suzuki.poulose@arm.com>;
> > > yuzenghui <yuzenghui@huawei.com>; kvm@vger.kernel.org; Sebastian Ott
> > > <sebott@redhat.com>; Shaoqin Huang <shahuang@redhat.com>; Eric Auger
> > > <eric.auger@redhat.com>; Oliver Upton <oliver.upton@linux.dev>
> > > Subject: [PATCH v5 07/10] KVM: arm64: Treat CTR_EL0 as a VM feature ID
> > > register
> > 
> > [...] 
> >  
> > > @@ -2487,7 +2490,10 @@ static const struct sys_reg_desc sys_reg_descs[] =
> > > {
> > >  	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
> > >  	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
> > >  	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown,
> > > CSSELR_EL1 },
> > > -	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
> > > +	ID_WRITABLE(CTR_EL0, CTR_EL0_DIC_MASK |
> > > +			     CTR_EL0_IDC_MASK |
> > > +			     CTR_EL0_DminLine_MASK |
> > > +			     CTR_EL0_IminLine_MASK),
> > 
> > (Sorry if this was discussed earlier, but I couldn't locate it anywhere.)
> > 
> > Is there a reason why we can't make the L1Ip writable as well here?
> > We do have hardware that reports VIPT and PIPT for L11p.
> > 
> > The comment here states,
> > https://elixir.bootlin.com/linux/v6.11-rc7/source/arch/arm64/kernel/cpufeature.c#L489
> > 
> > " If we have differing I-cache policies, report it as the weakest - VIPT."
> > 
> > Does this also mean it is safe to downgrade the PIPT to VIPT for Guest as well?
> 
> It should be safe, as a PIPT CMO always does at least the same as
> VIPT, and potentially more if there is aliasing.

+1, there was no particular reason why this wasn't handled before.

We should be careful to only allow userspace to select VIPT or PIPT
(where permissible), and not necessarily any value lower than what's
reported by hardware.

-- 
Thanks,
Oliver
