Received: from out-63.mta0.migadu.com (out-63.mta0.migadu.com [91.218.175.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDB7882A
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 19:20:30 +0000 (UTC)
Date: Mon, 12 Jun 2023 21:20:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686597628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=56IOyjS+GBgnu/S1KNwnnS84oPh9pw2u4TnmZ1agPlk=;
	b=vxQGlxavmwCM2GxhYHZVC80KCwkgUIc425f9Gs1FF1Lng93Hrjy9TcFy1BsNCUlRmr6dN/
	03FELDKYstqVUPstcIAk7ruZ42iTiqG9wRdW8NHK1l5QZVd4jeQzHryLd4Hau1A9WeH7CY
	DyaI/JSQDeJArioBZdxiD3ic9TlyeEk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 05/17] arm64: Don't enable VHE for the kernel if
 OVERRIDE_HVHE is set
Message-ID: <ZIdv+q9hemnlIDtl@linux.dev>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-6-maz@kernel.org>
 <ZIduFSAPFumGotwV@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIduFSAPFumGotwV@arm.com>
X-Migadu-Flow: FLOW_OUT

Hey Catalin,

Thanks a bunch for the reviews/acks, I plan on queueing this up for 6.5.

On Mon, Jun 12, 2023 at 08:12:21PM +0100, Catalin Marinas wrote:
> On Fri, Jun 09, 2023 at 05:21:48PM +0100, Marc Zyngier wrote:
> > If the OVERRIDE_HVHE SW override is set (as a precursor of
> > the KVM_HVHE capability), do not enable VHE for the kernel
> > and drop to EL1 as if VHE was either disabled or unavailable.
> > 
> > Further changes will enable VHE at EL2 only, with the kernel
> > still running at EL1.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/kernel/hyp-stub.S | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> > index 9439240c3fcf..5c71e1019545 100644
> > --- a/arch/arm64/kernel/hyp-stub.S
> > +++ b/arch/arm64/kernel/hyp-stub.S
> > @@ -82,7 +82,15 @@ SYM_CODE_START_LOCAL(__finalise_el2)
> >  	tbnz	x1, #0, 1f
> >  
> >  	// Needs to be VHE capable, obviously
> > -	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 2f 1f x1 x2
> > +	check_override id_aa64mmfr1 ID_AA64MMFR1_EL1_VH_SHIFT 0f 1f x1 x2
> > +
> > +0:	// Check whether we only want the hypervisor to run VHE, not the kernel
> > +	adr_l	x1, arm64_sw_feature_override
> > +	ldr	x2, [x1, FTR_OVR_VAL_OFFSET]
> > +	ldr	x1, [x1, FTR_OVR_MASK_OFFSET]
> > +	and	x2, x2, x1
> > +	ubfx	x2, x2, #ARM64_SW_FEATURE_OVERRIDE_HVHE, #4
> > +	cbz	x2, 2f
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> (I think we are trying too hard to make this look like a hardware
> features when a tbz would do ;)).

I had a similar feeling and whined on v1 :) Perhaps we can make a macro
for testing software feature if/when we ever stop representing SW
features like ID registers, per your suggestion.

--
Thanks,
Oliver
