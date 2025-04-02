Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C6A78C91
	for <kvmarm@lists.linux.dev>; Wed,  2 Apr 2025 21:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743630737; cv=none; b=Mo1dIv6U6DmRUT8jC7598MWn7ZyRFOzLUedWeGc0r0Xk96yfc/O9chJKNHs3gVehYbgctM0DMw0CSCJBSIHE/05Pf3lNP/wP1P1Xf53MeffWaKexlGF2ET3vs0O/gdXhxdkDkXoCTfnuV/cYrRyZyCo7+fczwsBUM3ACeLLwOUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743630737; c=relaxed/simple;
	bh=QSGniL5700SXUi68bJ8CqNAoCK9WIIfz5WKlZw2EHdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oBRey8P9y6IHPNOjuo5SqqnG6Vntb572S6dJocsWwF8R1fjWcOqQpHztl9kCY6apdJrb/LF8cGHTTwx7rLjiPnmU1XEvdQ3cIOjnjrQspUh/q849c/Lq0f3m+YKl3IJ4UULZNlc/8DMasFGSImucZ7VNofpMsWu+eGb3oCxbmKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pv9bPUtC; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pv9bPUtC"
Date: Wed, 2 Apr 2025 14:52:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743630729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fG1uyfjpSLFrYrWYkzfvmC5Bn1FBsJpGnrK0O5RO8d8=;
	b=Pv9bPUtCNhx5dxWx0L8YLpxwaLoRNxYGltEHlRRM5WHdKUHDhpN+gsoMbX5YTttJb9lVdF
	PsWdLFYsEBdKPjoqo3QpV+SDUvdr+MZDAOT59gRCWp6W2CnTVRYe4qupOn6VnKkDQGihn1
	GUrbuD8kFBgWuNkKXV2BMYqqpSRk1co=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Only read HPFAR_EL2 when value is
 architecturally valid
Message-ID: <Z-2xgjsrRAI-sq2G@linux.dev>
References: <20250402201725.2963645-1-oliver.upton@linux.dev>
 <20250402201725.2963645-2-oliver.upton@linux.dev>
 <87cyduz138.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cyduz138.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 02, 2025 at 10:48:43PM +0100, Marc Zyngier wrote:
> On Wed, 02 Apr 2025 21:17:23 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > KVM's logic for deciding when HPFAR_EL2 is UNKNOWN doesn't align with
> > the architecture. Most notably, KVM assumes HPFAR_EL2 contains the
> > faulting IPA even in the case of an SEA.
> > 
> > Align the logic with the architecture rather than attempting to
> > paraphrase it. Additionally, take the opportunity to improve the
> > language around ARM erratum #834220 such that it actually describes the
> > bug.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/asm/esr.h           | 22 ++++++++++--
> >  arch/arm64/kvm/hyp/include/hyp/fault.h | 46 ++++++++++++++++----------
> >  2 files changed, 48 insertions(+), 20 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > index d1b1a33f9a8b..92fb26e90840 100644
> > --- a/arch/arm64/include/asm/esr.h
> > +++ b/arch/arm64/include/asm/esr.h
> > @@ -121,6 +121,15 @@
> >  #define ESR_ELx_FSC_SEA_TTW(n)	(0x14 + (n))
> >  #define ESR_ELx_FSC_SECC	(0x18)
> >  #define ESR_ELx_FSC_SECC_TTW(n)	(0x1c + (n))
> > +#define ESR_ELx_FSC_ADDRSZ	(0x00)
> > +
> > +/*
> > + * Annoyingly, the negative levels for Address size faults aren't laid out
> > + * contiguously (or in the desired order)
> > + */
> > +#define ESR_ELx_FSC_ADDRSZ_nL(n)	((n) == -1 ? 0x25 : 0x2C)
> > +#define ESR_ELx_FSC_ADDRSZ_L(n)		((n) < 0 ? ESR_ELx_FSC_ADDRSZ_nL(n) : \
> > +						   (ESR_ELx_FSC_ADDRSZ + (n)))
> 
> Oh gawd, D128 and its level -2. Do we really want to add this now?

I certainly don't want to, but the other FSC level macros (whether
intentional or not) already cope with D128. So I did the same for the
sake of consisency.

Thanks,
Oliver
