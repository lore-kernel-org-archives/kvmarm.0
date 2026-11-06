Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794000651;
	b=gRKPiHVW+RRSr3WKDmKWkGJLCCwEqDuNsMvCf4i9G14jsVrmnL8JyQJp5ki5HK7Bzs9l
	 3+7I0Hgqn1g18YGv5HGEdqMiGBFFAygbVaEfuIP/ptEeVNEsRaq/YGh/bD2BqmDpB1qJp
	 Xj+OB8bfh2Yj8tGbaI4Qwcdm+gOMmlT005nkciggOU6O103D6mJdUGEQmnxjvkMHCaL2p
	 5mCCy0DW7rEeKtVFB5RAT5Vk+T1ySLq1+BCN16HDgj5ZvcZGNMtGul0P1RzC5spDADMdH
	 BkN8sABnjn4h69a+TLlsfotEtLdi38MNXsqn7F8PMtX9MKZcW6CVuQwxPiq5g37NOWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794000651;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=78M0zrQN/RKEdSRK6OCH+d/aWaVmSInC9noJ9fmrXic=;
	b=uqwK7GOR7aYpFu2ZAbIRmyQMmF+nZBikhZaPTD7P9BRe2nZQgnQmAsSgye6bOdkpXo9t
	 jbslPGt5fJd7ByW0wt+uZXyXzwEltQzjwdsGiZD5s6AGODS4CQy+XlXHJLtTvxryk6q+A
	 P6svhi2nAqxLlY2EC2BttRyUAkY/I0Qi050gzEZB8qM76y1pLMXXfe/IJJldGummsAPRK
	 wU5COYeEInzxU8FcNxTwDZLbDpYwdMQH5TMfyUmECAGn8/+bcgMgbZ59nl5wvp8iT8ceo
	 oLCSDHOOggxY7kfGhrr0rQdf5jF6B8s7NG0FaOy0FU27YOCsM7LNj9ixuYKBV48RYFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PcT7Yd6C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3FF606A326;
	Fri,  6 Nov 2026 21:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PcT7Yd6C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C341F0089F;
	Fri,  6 Nov 2026 21:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794000651;
	bh=78M0zrQN/RKEdSRK6OCH+d/aWaVmSInC9noJ9fmrXic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PcT7Yd6C7pVaiTAbNk1xDLmne8b05Xa/cipXiW5cKizpmjkF8uk36vMmF5HpW0CdL
	 dLC7hjPx7aIloMlLA76aKVG2HmBTP+1Wdag84B3HLYcK58NiBjgkkOLElVj5Q8/LiH
	 lSj8ua5j+cZ7vJPxwVofcbhsS5yFzB07MDV8SvrVM/22ses78wF+WKKE2OPiC7GYOP
	 xAN3hLiiF6J68PJCuwXfxU/vdqjpoetaT6cmHUGeZHEsITB/ToOftpj0bVSFEABvyD
	 g2VNx1ouCSWm0LZR4Ulh6bpSKFSIntO02xcIi9Fwa2AAGqx+KvRjwVlxudMHLvT1OR
	 9Wv2w/GMrRLfA==
Date: Fri, 6 Nov 2026 13:30:49 -0800
From: Oliver Upton <oupton@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 6/8] KVM: arm64: Add sys_reg_descs for remaining MTE
 CMO instructions
Message-ID: <au5HCZ4Ygasx-qKi@kernel.org>
References: <20261106183154.3590825-1-oupton@kernel.org>
 <20261106183154.3590825-7-oupton@kernel.org>
 <sashiko-outbox-202094@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-202094@kernel.org>

On Fri, Nov 06, 2026 at 06:45:39PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] KVM: arm64: possible missing MTE_CMO_INSN entries for DC GVA and
>   DC GZVA
> --
> 
> commit c80fdbddf913183cac8f63dfc60ce6f48445eafa
> Author: Oliver Upton <oupton@kernel.org>
> 
> KVM: arm64: Add sys_reg_descs for remaining MTE CMO instructions
> 
> This commit adds MTE_CMO_INSN descriptors with mte_visibility to
> sys_insn_descs[] for MTE cache maintenance instructions trapped by
> HCR_EL2.TPCP so that they inject an UNDEFINED exception when MTE is not
> enabled for the VM.
> 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index b456354713443..7f7a197a9ad6b 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> [ ... ]
> > @@ -4394,6 +4403,15 @@ static struct sys_reg_desc sys_insn_descs[] = {
> >  	SYS_INSN(TLBI_VALE1NXS, handle_tlbi_el1),
> >  	SYS_INSN(TLBI_VAALE1NXS, handle_tlbi_el1),
> >  
> > +	MTE_CMO_INSN(DC_CGVAC, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CGDVAC, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CGVAP, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CGDVAP, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CGVADP, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CGDVADP, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CIGVAC, bad_cmo_trap),
> > +	MTE_CMO_INSN(DC_CIGDVAC, bad_cmo_trap),
> 
> [Severity: Low]
> This question rests on an architecture detail that could not be confirmed
> from the kernel source: can SYS_DC_GVA and SYS_DC_GZVA trap to EL2 via
> HCR_EL2.TDZ or HFGITR_EL2.DCZVA when MTE is not enabled for the VM?
> 
> If so, encoding_to_cgt[] maps both instructions to CGT_HCR_TDZ and
> encoding_to_fgt[] maps them to HFGITR_EL2.DCZVA, which is marked NEVER_FGU
> in config.c because the trap bit is shared with SYS_DC_ZVA.  Without
> MTE_CMO_INSN entries for SYS_DC_GVA and SYS_DC_GZVA in sys_insn_descs[],
> triage_sysreg_trap() has neither an FGU bit nor a visibility() callback to
> filter them, and will forward traps from a nested guest to L1 when L1 sets
> HCR_EL2.TDZ or HFGITR_EL2.DCZVA instead of injecting an UNDEFINED
> exception.

Urgh, I'm starting to get the sense that we should pursue a generalized
solution. This relies on adding a subtle detail to KVM's trap behavior
when what we're trying to do already has a direct description in the
architecture...

Thanks,
Oliver
