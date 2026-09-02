Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C0F3DE423
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 15:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788362821; cv=none; b=Irdw6o8pHyUYT2AdCtEp2wfOJgwEONUiP5m5CONHBOGADz0KaCmAd3fLiwgZOkuqsa9mjDb995QbERxDVsGb/q3PlNet4kl3b5C5QSoPEXNVOGb6ocHV6MQsdDExWzy/lC1uHZEC+uqs3hhbbz0Me0EQwL/q5p+BErbOpVHYGW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788362821; c=relaxed/simple;
	bh=XJw/3qLdMVreWxf4FjGR+cbdVl/3cC31DxO0jrJHwXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D4Ziaj2OQqI9yhLzDPDyq6zrNcuHSrz+CL1Ztil1qKuIOfgqf6lipBDlysQvkD8e+lbGZpOKvjl6CcqyMwH7ID/BkTPQLzrJGGNE2Qn+DUz6D+oRVU1CrW4qhTAttVMFZmhnQaR6CGCPRL9veMNvanEx00LY9eRkLe6yp5954xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AZPd80Iw; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AZPd80Iw"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49b0d8bc2aaso11127715e9.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 08:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788362816; x=1788967616; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sjVl9xzFfNgY952LphDWb8k5JraTM7MAooStXeF8NfA=;
        b=AZPd80Iw9F7ZanY8X95UnR21Y7CcjAk60D/ayKqMbFM7loI0JUUCCNcSgheOyw+Klq
         5NAgsve6L8tofVG0JDSxTiVHrSScx+hlblP1Mol2T5p633aCwjdfdyx1rvQfTRh4cS3r
         RZDnkL4sMFqlyg+rcrZnRAJAcZ2YytHJ/rk5kpY8V506OQTIgpJ4pDOCF0poFtyVFSsq
         6FT+iX1LtP98B92uIEULRP7VcswT1vTo3iBOLhLt+F6tXd4GJIvliFdegE2+foftI9qb
         4PaZ0krDnvyKYULBYzycK6w4Gf3Rkx+i3xoy/ogSgsr/NWmQc2FryNpNWLcw1DHqJNyA
         k8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788362816; x=1788967616;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sjVl9xzFfNgY952LphDWb8k5JraTM7MAooStXeF8NfA=;
        b=p8TitfTa7SCrLQhxh6BDOUgLJ36O/2FD68b+1TI/YRX/MWr4iFX1vlWLKYJ5KRXXyL
         GxjzHyY/d90YHC05O6bW+CNFOKHb7nIEopcItttmdMK23lBv25b+hdkutpzGUGZ2UfxA
         mUH86GkWm2SfA4Abwg5kLdNfOOv6emGT6JCNsuH2denQe6EoEFdQPN6hC0W4MaBGImUS
         Lxp9zga49B3bzDRWYC+UZyKLME7Yix6NCM300Q2JCoW3yBU5zSyKMaV5Jx0G9mstAjUy
         voJw8HRmELupx+XtfxXm0NCkbvx9YFlGhZxIMy2WbpC5teJPD3YNPDlzL/I757QF9RHR
         LrfA==
X-Forwarded-Encrypted: i=1; AHgh+RqZAm7R7Y+0Iptc59W+V72wzCCW0PZPaMIMQ1ShbukQXCblHbFscz7gRV9g4Z96J58DfPy+KLY=@lists.linux.dev
X-Gm-Message-State: AFuF++n6g53unQuw8FwdJ4TeM0CDj7j2T5OswBvz+YRia2ZnukI8dRIj
	tKN3tJ0FPaKy8803V0GVgtMOjkSUskfs3D9+6zUftND1BHvfaZYV4BtImPoUaylDnA==
X-Gm-Gg: AR+sD10dmAU2WWVT61bLHHvKJdyZIc85YIisDjRvXrBNWItVRTQGGce3eV2FHrQjCBz
	elSGHbA+dSRS8fETPoMwkcQT6ym/Rh2RYZ34x0yx0Oh/5iQJ1kUNhs9gkh18ypNZrCB7gQhx9j1
	Uz7KWM+yGXHFpQtk3/cdXOX/WifJfS9eYMSlg1JrHdG18wUcxRotJxLlsF6h1LCcS9LlH8Ib/BE
	+FXt6oovw/VPu8Hf7X9Ey6Ny5ZRDdoA7T1+syy6w4KLaQAEDaZsQtwYJYGW6U/TyuBEA39COnpt
	TQGelCNwtbQmdEm8+OHOOKHxdAI2bU37jH4Yb/jcuQyJLBQhJtRphZp1nGM+A0yL60vh5GvHrFr
	k1sOQz6FZ7jvOkgUwFcpVha5jvQ87l98sI3SNFP1HeQc/dr5jsfVhotAN1tDyUn7pQOeS2PToWD
	Wih0egcvEw1PmsU/k8Ma/wmI7Mky5h4xVYWj2j1H7vYe6Rdr/M2KVde/ZBqE6n9bTp/PnhVBaXD
	QkNTzeA+DNWq6xJm8FCXDnyAUzxwR5gi3J54lzfMFg=
X-Received: by 2002:a05:600c:1906:b0:499:8b13:3a98 with SMTP id 5b1f17b1804b1-49ce57e7a9dmr97272945e9.4.1788362815816;
        Wed, 02 Sep 2026 08:26:55 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce4642235sm77916425e9.2.2026.09.02.08.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 08:26:54 -0700 (PDT)
Date: Wed, 2 Sep 2026 16:26:51 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 05/17] KVM: arm64: Skip fixed-feature state flush for
 protected vCPUs
Message-ID: <aphAO_nmoTzI6Yvf@google.com>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
 <20260831163421.272420-6-fuad.tabba@linux.dev>
 <apg7KNpamnpYi-kl@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apg7KNpamnpYi-kl@google.com>

On Wed, Sep 02, 2026 at 04:05:12PM +0100, Vincent Donnefort wrote:
> On Mon, Aug 31, 2026 at 05:34:09PM +0100, Fuad Tabba wrote:
> > flush_hyp_vcpu() copies the host's mdcr_el2, TWI/TWE and debug state
> > into the hyp vCPU on every entry, so for a protected vCPU the host's
> > trap configuration overrides the one pkvm_vcpu_init_traps() computed
> > at EL2. Move those copies into the non-protected branch, and sync the
> > debug state back for non-protected vCPUs only: a protected guest's
> > debug registers are hypervisor-owned, and it takes the host's TWI/TWE
> > at vCPU load. MDCR_EL2.TDA traps only the guest's own accesses; it
> > does not stop the world switch from loading host-supplied breakpoints
> > and MDSCR_EL1.
> > 
> > EL2's mdcr_el2 starts from 0, and HPMN == 0 is reserved without
> > FEAT_HPMN0. Set HPMN to the CPU's event counter count at vCPU load,
> > the value the host's copy carried; a protected guest's PMU accesses
> > trap regardless.
> > 
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 31 +++++++++++++++++++-----------
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c     |  2 +-
> >  2 files changed, 21 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index ca7122b0bccdd..14e847b122abf 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -231,7 +231,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> >  	u8 esr_ec;
> >  
> >  	fpsimd_sve_flush();
> > -	flush_debug_state(hyp_vcpu);
> >  
> >  	/*
> >  	 * If we deal with a non-protected guest and the state is potentially
> > @@ -241,7 +240,14 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> >  	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> >  		if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
> >  			flush_hyp_vcpu_state(hyp_vcpu);
> > +
> > +		hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
> > +		hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
> > +							 (HCR_TWI | HCR_TWE);
> > +
> > +		hyp_vcpu->vcpu.arch.mdcr_el2 = host_vcpu->arch.mdcr_el2;
> >  		hyp_vcpu->vcpu.arch.iflags = host_vcpu->arch.iflags;
> > +		flush_debug_state(hyp_vcpu);
> >  	} else {
> >  		hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
> >  	}
> > @@ -249,17 +255,13 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> >  	/* __hyp_running_vcpu must be NULL in a guest context. */
> >  	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
> >  
> > -	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
> >  	/*
> > -	 * HCR_EL2.VSE is host-owned (a pending virtual SError to inject), not a
> > -	 * trap-control bit, so it must flow to the hyp vCPU alongside TWI/TWE
> > -	 * for the vSError to be delivered. sync_hyp_vcpu() reflects it back.
> > +	 * A host-injected vSError is masked by the guest's own PSTATE.A, so it
> > +	 * applies to protected guests too.
> >  	 */
> > -	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE | HCR_VSE);
> > -	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
> > -						 (HCR_TWI | HCR_TWE | HCR_VSE);
> > -
> > -	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
> > +	hyp_vcpu->vcpu.arch.hcr_el2 &= ~HCR_VSE;
> > +	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) & HCR_VSE;
> > +	hyp_vcpu->vcpu.arch.vsesr_el2 = host_vcpu->arch.vsesr_el2;
> >  
> >  	flush_hyp_vgic_state(hyp_vcpu);
> >  
> > @@ -288,7 +290,8 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
> >  	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> >  
> >  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
> > -	sync_debug_state(hyp_vcpu);
> > +	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> > +		sync_debug_state(hyp_vcpu);
> 
> nit: We can't use the else arm below?

or actually could we move the check into sync_debug_state() just like
sync_hyp_timer_state() does?

> 
> >  
> >  	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> >  		host_vcpu->arch.ctxt = hyp_vcpu->vcpu.arch.ctxt;
> > @@ -329,6 +332,12 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
> >  		/* Propagate WFx trapping flags */
> >  		hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
> >  		hyp_vcpu->vcpu.arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);
> > +
> > +		/* HPMN == 0 is reserved without FEAT_HPMN0. */
> > +		if (system_supports_pmuv3())
> > +			u64p_replace_bits(&hyp_vcpu->vcpu.arch.mdcr_el2,
> > +					  FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0)),
> > +					  MDCR_EL2_HPMN);
> >  	} else {
> >  		memcpy(&hyp_vcpu->vcpu.arch.fgt, hyp_vcpu->host_vcpu->arch.fgt,
> >  		       sizeof(hyp_vcpu->vcpu.arch.fgt));
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 459bd9eb7e4bc..e85f13233da08 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -102,7 +102,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
> >  
> >  	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP)) {
> >  		val |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
> > -		val &= ~(MDCR_EL2_HPME | MDCR_EL2_MTPME | MDCR_EL2_HPMN_MASK);
> > +		val &= ~(MDCR_EL2_HPME | MDCR_EL2_MTPME);
> >  	}
> >  
> >  	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, IMP))
> > -- 
> > 2.39.5
> > 

-- 
Vincent
