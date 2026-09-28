Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3099537A843;
	Mon, 28 Sep 2026 10:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790592975; cv=none; b=nM/R9str89uFNehBI+qWKXll9jp+TbQPb0DDpF1qg/GwMDTxv7rQcAl2HHwzHPZf6eiXtxvEnpn+KqNfzoB259KJvo6U8JBPX0gRgPhwNEpTc2RWPnIyAs04EmSsXm3r7Y643jAdDoKsniX21k/42jYsj182LBdk6kkD4zn15Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790592975; c=relaxed/simple;
	bh=4ZDYUKK7hOkkuW853RREZKTeQzSVG3+xdenNOiJCiu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W3fNKHkey3FWyqNlv6hQruXC68IGouB8EgA5mD+hWqjfLQ3Wse0+IBmN5jmaR9xMhS0sPhBw13Ap+wjd3WuGOTXaEYAqNNJnzSc36iuCbCvSFX4bC09RihEw9HhFXETimlNiTCAKK3M3nA4BN+Nd1slH6JrE0G2fILTXKfZmOgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RwAPO1m6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RwAPO1m6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDA5E1595;
	Mon, 28 Sep 2026 03:56:09 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 407163F86F;
	Mon, 28 Sep 2026 03:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790592973; bh=4ZDYUKK7hOkkuW853RREZKTeQzSVG3+xdenNOiJCiu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RwAPO1m6ueQDCoe7BwagSGk7/imEh9oCpN0sB+LocdRIxt9mqz3LBRJTRj0rJ1Eg+
	 kKIZa8QMyNmU2NY7aqju1Plx5tQPUbqS3R1imrJ7Wov6LtNpFsGFHooOreadgmPN1l
	 NEStHyVr5cNqcmNatJpe9KjCcLWgGMii0xafwFZU=
Date: Mon, 28 Sep 2026 11:56:06 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 4/4] KVM: arm64: Convert TCR_EL2 to config-driven
 sanitisation
Message-ID: <zgq6ehb6ddllbp5wetdmuyq23tf26i74hznzpmiyu76b4pi4tf@vdy7l23kktcu>
References: <20260917214215.74135-1-weilin.chang@arm.com>
 <20260917214215.74135-5-weilin.chang@arm.com>
 <20260917220029.4D9911F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260917220029.4D9911F000FF@smtp.kernel.org>

On Thu, Sep 17, 2026 at 10:00:28PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] kvm: arm64: static TCR_EL2 mask based on FEAT_E2H0 breaks dynamic E2H layouts
> --
> 
> commit 18ffaaa0986bf7864d7ed4beba6765c60e2a26c1
> Author: Wei-Lin Chang <weilin.chang@arm.com>
> 
> KVM: arm64: Convert TCR_EL2 to config-driven sanitisation
>     
> This commit converts the translation control register TCR_EL2 to use the
> config-driven sanitisation framework. It extracts feature dependencies
> from the BSD-licensed AARCHMRS Registers.json, applying some manual
> deviations for dependencies like TCR_EL2.TCMA and FEAT_ASID16.
> 
> > diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> > index 1053676551aff..080b3510b7831 100644
> > --- a/arch/arm64/kvm/config.c
> > +++ b/arch/arm64/kvm/config.c
> [ ... ]
> > @@ -1611,6 +1718,12 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
> >  	case SCTLR2_EL2:
> >  		resx = compute_reg_resx_bits(kvm, &sctlr2_desc, 0, 0);
> >  		break;
> > +	case TCR_EL2:
> > +		if (kvm_has_feat(kvm, FEAT_E2H0))
> > +			resx = compute_reg_resx_bits(kvm, &tcr_el2_desc, 0, 0);
> > +		else
> > +			resx = compute_reg_resx_bits(kvm, &vhe_tcr_el2_desc, 0, 0);
> > +		break;
> 
> [Severity: High]
> Does this static choice in get_reg_fixed_bits() break dynamic E2H layouts for
> nested guests? When FEAT_E2H0 is present on the host, this restricts the sysreg
> mask to the E2H=0 layout for all TCR_EL2 accesses, ignoring that guests can
> still dynamically enter E2H=1 mode.
> 
> If a nested hypervisor runs on a host with FEAT_E2H0, sets HCR_EL2.E2H = 1,
> and writes to TCR_EL2 expecting the VHE layout, KVM will intercept the write.
> When passed to kvm_vcpu_apply_reg_masks(), the VHE-specific bits (e.g., EPD1,
> T1SZ, TG1, IPS) will be cleared because they overlap with RES0 bits in the
> static nVHE mask. Could this corrupt translation table configurations and
> cause translation aborts?

No. VMs can't change their effective HCR_EL2.E2H value.

> 
> >  	case TCR2_EL2:
> >  		resx = compute_reg_resx_bits(kvm, &tcr2_el2_desc, 0, 0);
> >  		break;
> 
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 7f13f0077c9f4..3e01123d00ca0 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> [ ... ]
> > @@ -1957,6 +1957,10 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
> >  	resx = get_reg_fixed_bits(kvm, HFGITR2_EL2);
> >  	set_sysreg_masks(kvm, HFGITR2_EL2, resx);
> >  
> > +	/* TCR_EL2 */
> > +	resx = get_reg_fixed_bits(kvm, TCR_EL2);
> > +	set_sysreg_masks(kvm, TCR_EL2, resx);
> 
> [Severity: High]
> Does this application in kvm_init_nv_sysregs() cause valid guest writes to be
> clobbered?
> 
> Since the wrongly computed static mask is applied to the VM's sysreg_masks
> array here, it looks like it will break nested virtualization for any nested
> guest running in VHE mode.

No. VMs can't change their effective HCR_EL2.E2H value.

Thanks,
Wei-Lin Chang

> 
> > +
> >  	/* TCR2_EL2 */
> >  	resx = get_reg_fixed_bits(kvm, TCR2_EL2);
> >  	set_sysreg_masks(kvm, TCR2_EL2, resx);
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260917214215.74135-1-weilin.chang@arm.com?part=4
