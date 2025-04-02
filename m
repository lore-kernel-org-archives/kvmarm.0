Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D1310F9
	for <kvmarm@lists.linux.dev>; Wed,  2 Apr 2025 16:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743611994; cv=none; b=lROfTS+UQn3AaHzPbWtqY9Qjfv4dFnga7wfyaBtD1COYGNGUiExrMh1U6VujG3vtrr2zCEv40WhjqK/04NJ6QZpc54erTCrc6rBmfX66dcnijJgAc3cJpx8sDP7/HFP624yZLAlFojYe7WFnRPXI+8L/5xvgm9TniRSoFytD+lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743611994; c=relaxed/simple;
	bh=W8xMjkxFZeM4DldEJMUeHiPgLUIdVVzpDheHxIhQ4Oc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dvWBglRZ8DyZWJ0r4O3CeKWXvtd7ONikLvqTbYpwDu7QS8dnRz/F1VbZDC51SylnthoO0FQ9ms7nWD6rE1KHZALRUgzGiwei32NRZzCdNks83KdJedlWCH/1LsxZNAajrXp6EBCqW67viMplQzqtlViktfM8xdNCrmb5zYMELpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S20wcdg5; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S20wcdg5"
Date: Wed, 2 Apr 2025 09:39:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743611989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c0uQ/gnUiEuLcOGsZ5j1546vtCSWjohgAaBlrIOd9Sg=;
	b=S20wcdg5y6BtOM+O9NU3v4oIU0WqMTt2aVtMGLxol0OX7aKwIyM0brO5hiNSohidNOw+KC
	u2yk/XgVaAWpA3ar+MQg8BHGTpxdXAxNYjXB+VCXZfLfuhbFbE6WycmkBWV1EGVtWqNb4E
	I8eCLMlN3iG6dS2Ja/HoS+1phCGJCNI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Only read HPFAR_EL2 when value is
 architecturally valid
Message-ID: <Z-1oTgrx4V-BT3Ik@linux.dev>
References: <20250401224234.2906739-1-oliver.upton@linux.dev>
 <20250401224234.2906739-2-oliver.upton@linux.dev>
 <87iknmzudz.wl-maz@kernel.org>
 <87h636ztpm.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h636ztpm.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 02, 2025 at 12:30:29PM +0100, Marc Zyngier wrote:
> On Wed, 02 Apr 2025 12:15:52 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > On Tue, 01 Apr 2025 23:42:32 +0100,
> > Oliver Upton <oliver.upton@linux.dev> wrote:
> > > 
> > > KVM's logic for deciding when HPFAR_EL2 is UNKNOWN doesn't align with
> > > the architecture. Most notably, KVM assumes HPFAR_EL2 contains the
> > > faulting IPA even in the case of an SEA.
> > > 
> > > Align the logic with the architecture rather than attempting to
> > > paraphrase it. Additionally, take the opportunity to improve the
> > > language around ARM erratum #834220 such that it actually describes the
> > > bug.
> > > 
> > > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > > ---
> > >  arch/arm64/include/asm/esr.h           |  1 +
> > >  arch/arm64/kvm/hyp/include/hyp/fault.h | 46 ++++++++++++++++----------
> > >  2 files changed, 29 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > > index d1b1a33f9a8b..7b096ed87360 100644
> > > --- a/arch/arm64/include/asm/esr.h
> > > +++ b/arch/arm64/include/asm/esr.h
> > > @@ -121,6 +121,7 @@
> > >  #define ESR_ELx_FSC_SEA_TTW(n)	(0x14 + (n))
> > >  #define ESR_ELx_FSC_SECC	(0x18)
> > >  #define ESR_ELx_FSC_SECC_TTW(n)	(0x1c + (n))
> > > +#define ESR_ELx_FSC_ADDRESS	(0x00)
> > 
> > I think this should probably read "ADDRESS_SIZE", rather than just
> > "ADDRESS".
> 
> Actually, we have
> 
> #define ESR_ELx_FSC_ADDRSZ	(0x00)
> 
> since
> 
> 61e30b9eef7f ("KVM: arm64: nv: Implement nested Stage-2 page table walk logic")
> 
> It just isn't at the expected spot.

Durrrrr :)

Thanks,
Oliver
