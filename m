Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E83385D90;
	Tue, 22 Sep 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790099153; cv=none; b=KXxGHGIufo/eipKovqUkN9J0nlPpqPs2WE40lAisIQpgrxvapdzvn1J5Kr2juhX2q4JQGVcxSX+gfA+RHuqzr7lz3tQG+vLey5Y04VNGFyuAfTwtgIAZMHRtqmrlBghcwkd5XJrJ+sLm5QQdyqhdtzBYcfWQ5OSai1fagtzNk+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790099153; c=relaxed/simple;
	bh=+MBQr7Lq88vMwlqVg9Y0+7ZpoOh9i2ra2bsBZTG9yOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gFXuxmy7rNxnKUc+E+9zECbg7Losb3CVE37lBTPz6HXZTS6tVVoqgcWA748L2PfvEcugHvMVkBeF5TzKia84xUXI+4Vz48d5C8ZiTwuo45B35OxnULaSCR6/8d6R4vaBHA/134gX8mr1i+P3+8tmcLAOrrW5e4evDWloKmMX53Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LK/JYxRB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LK/JYxRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38251F000FF;
	Tue, 22 Sep 2026 17:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790099152;
	bh=3XbNBEXalOL7wiFA7qwtlOxm81Xd6k8sewjrN0xUfqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LK/JYxRBXLqT9oNDbHo0Vmb4Kvj0SOxpClLPhlDhoEDp990c2FuIfud12HQJuvoxi
	 bDGECRYUfdSZP9gXhK4fXF614eddRmfhGFyn3I5yvyMc5JGtE8JWdEnqplwGl+30wp
	 IgFFys8YWwUU/5cihbkrSBZb77Gp190OamEKXHrXLnzKxw4mjcFgUR4trsz+gvyhfm
	 NkjzqhIVxzST0eRe/o24/p9M2Ef1ZchwIqf095j6f1qxLjBuNLY4oxTPM4672c12dP
	 GifkY8ow2B/PzWEoKFKZ6UhhlpfkA0s204foNKtzVTN2L1kzD9wUQvZUXezjpuhwZz
	 57kC61yAXm67A==
Date: Tue, 22 Sep 2026 18:45:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Randy Dunlap <rdunlap@infradead.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 02/14] arm64: Add ESR fault helpers
Message-ID: <arK8ZnBSFwmjizuk@gremlin>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-2-787bd3bc7e3f@kernel.org>
 <arK0N7H1w-pcixba@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arK0N7H1w-pcixba@kernel.org>

On Tue, Sep 22, 2026 at 10:00:39AM -0700, Oliver Upton wrote:
> On Tue, Sep 22, 2026 at 03:17:56PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Add helper functions which operate directly on an ESR value rather than
> > trying to access the register itself.
> >
> > These mirror equivalent KVM vCPU wrappers in kvm_emulate.h and allow those
> > wrappers and KVM's stage-2 fault handling to operate on a plain ESR value.
> >
> > This is needed to later generate a synthetic fault for the stage-2 page
> > table pre-faulting mechanism.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  arch/arm64/include/asm/esr.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > index f816f5d77f1a..9c0205983d9a 100644
> > --- a/arch/arm64/include/asm/esr.h
> > +++ b/arch/arm64/include/asm/esr.h
> > @@ -437,6 +437,50 @@
> >  #ifndef __ASSEMBLER__
> >  #include <asm/types.h>
> >
> > +static __always_inline u8 esr_get_ec(unsigned long esr)
> > +{
> > +	return ESR_ELx_EC(esr);
> > +}
>
> Why do we need to wrap the macro in an inline function?

It seemed like a more consistent way of doing this but looking through the code
ESR_ELx_EC() is referenced directly in quite a few places so will swap out.

>
> > +static __always_inline bool esr_trap_is_iabt(unsigned long esr)
> > +{
> > +	return esr_get_ec(esr) == ESR_ELx_EC_IABT_LOW;
> > +}
> > +
> > +static __always_inline bool esr_abt_is_s1ptw(unsigned long esr)
> > +{
> > +	return esr & ESR_ELx_S1PTW;
> > +}
>
> This helper doesn't make a ton of sense outside of KVM, since
> ESR_ELx.S1PTW is RES0 (not RAZ) outside of a stage-2 abort.

OK, kvm_emulate.h better?

>
> Thanks,
> Oliver

--
Cheers, Lorenzo
