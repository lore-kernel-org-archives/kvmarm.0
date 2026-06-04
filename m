Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1874347B437
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780580127; cv=none; b=ccyRsaz/Y+vHKeJ1BM+npTi79apl7USC9pMONc8SkxNEoWsdN1cqsrKU/fq679axUFglGrEOHUh7L+kIze7gr20p+xVCCPwzgfcqigsKwhE3o/oIzg8WPBTdInLF+jSoMrnjA0uGVJUXKcazaVXrPjjiwNVPX5+wpcEn9MS766I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780580127; c=relaxed/simple;
	bh=wyW6K2tnqAxT+ZGhkvr0UmKWErX01GWaw0VeehNEL6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gSnFbBXKxBINGwJx6XvXMpfFXLn0ueyM+vxqah2xq+SBMXOONjI+zyMwbOCymfTXik7/XzUt1h0KKDiOuVBh3Fw9LCh5B4f+YUK5MqQ4aGW2T1EO5QjMFkZvikOK4Ip2urP7uf6AD3tn+vaCOJwYJ0yHaFw3lGcQpwpH0sEEt3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ssm1HwBv; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ssm1HwBv"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-36d6bb38b44so489335a91.0
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 06:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780580125; x=1781184925; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nbk67PysBg7DJJKGW/wCdu53ipJpqlNAOSXxv9Li8rs=;
        b=Ssm1HwBvRDMKX2lnpxMv7cmRY7CfWJdTz/hBEATitKZ9SZUxP6GFp3at9XOwJHIpfy
         lQlJ5bjPsyZg3sVvGkQorFg/5v9X1w0UrCGg4P7nLdK1TxSvqXXFeNR5fEGlq9AwwEfL
         ioodHsuemvN8hzZhZGCaNayOSNVr2eceR6ODGK7U+4ywVoGbHCvLFrOqjGEAkjvBqfyU
         Bt3VO96QRhDYqSM3BYDTHQ3tW3APt3PVD+wtUw4U/Yxt2qh2Mj9RXmSrMJi8VemwFyy3
         4R8tEOVpJtnJFvM55KxDadpov7nC6htZuG6XNboDFjIYaZKeupfoz24YT5Qj2C2KDO0M
         Erzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780580125; x=1781184925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nbk67PysBg7DJJKGW/wCdu53ipJpqlNAOSXxv9Li8rs=;
        b=POORSbjF3dNB+vtDvrvicxTTgMM/NkupExJ23vWbIZ30nStVIJLxfsFmz750Mb5xhW
         G8qQ+2RzCh5S3qftpwYMfnamA9eEJxEpyb2Gr2UiUmG5aqAqiTWvhQ4DdHEu3RdmCEZV
         /aMAPzcGdsMkF3L0NaIIH7ZVxA4SPgVgZtMIknz60BLqXDASKnzMPZNJYpAZ8+JNoY+w
         XVPn8I+IAu28PooJHCATgHb75X9DnMObx0hfH4DbVYQs0pXtz9jMAJcX3i83F5x2nigt
         9snr2k3mpa2xr4W0OxMiBi2XO6KgdJ3mF45JNHMzHqxnpkb2StyzpG0+3hIUreQg+9X2
         gYHA==
X-Forwarded-Encrypted: i=1; AFNElJ/BI4F2Ne35uUq3rt/+YXD52XWlPhUk+hCOJAasAzo/YSTYL91pjaIUHRUr95SE21jOypL0qbk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeBx704RCsEs5Py3AELTVQPb+8bZ/UUxwqVObj+SgzLJ41D3/B
	WNl3MUadJOc2EPQ6SdRcsvjRHPQaXonSoK6GPjnI/P7tqqK4Amu7vGy3
X-Gm-Gg: Acq92OHYmz+0/z2rju4VSX7Ox/jRgibMx4emSDxehr5rOhKoKiUYG3UrAAe75Hax3LM
	LqCw9ngkohc48ShHQk7DmpRhvRJBM+Bj94C6wFr4lDJjeXF14+LgVpM3jxt648TtnvLputM3Wgg
	OYYZBb/Cc2fZY+r14p/PlHO9/45/fxdgRFvXuYTo3G5n4f7C9ww0OjgavQ0DJddtfpVOUD5tWAR
	z7LmguNLbB/lmx6whgqI5QeB2VeCq7A0wrg8/8RkDE52LkEAU1mkjjsT2ouaqOO2QNBFaPOd12b
	KwdDwHvIu8dDzP7fep0R8vjFNNslwFhOdILK1oGTLXDHacyg8PfUEWmNm8XTBGbnho8+5Qb72/9
	3sow62TnGB3yIIy2/XyVOzuF4FgsKmnuAYe342fE31qOTEBdZlECwXupS5d887nqSQvXhzQZMJc
	CLOBeTqVJZVS7KipuGdFmMoD8RJe6YHsH/cT/hQmug98CMAT2iiGHzPw==
X-Received: by 2002:a17:90a:f94e:b0:36a:ee1:fc24 with SMTP id 98e67ed59e1d1-36e2f3c3635mr8502314a91.8.1780580125219;
        Thu, 04 Jun 2026 06:35:25 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f70a29cd6sm3133442a91.11.2026.06.04.06.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 06:35:24 -0700 (PDT)
Date: Thu, 4 Jun 2026 22:35:20 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: Re: [PATCH] KVM: arm64: Sanitise host vCPU fields in flush_hyp_vcpu()
Message-ID: <aiF_GLmaDdD5i1Cp@v4bel>
References: <aiFe-CXo-XVTFz1g@v4bel>
 <CA+EHjTwgPFbbp7khcy+DZ9HZWCX-OWPfO78Gj_eQuCoj+SA90g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwgPFbbp7khcy+DZ9HZWCX-OWPfO78Gj_eQuCoj+SA90g@mail.gmail.com>

On Thu, Jun 04, 2026 at 02:01:17PM +0100, Fuad Tabba wrote:
> Hi Hyunwoo,
> 
> On Thu, 4 Jun 2026 at 12:18, Hyunwoo Kim <imv4bel@gmail.com> wrote:
> >
> > flush_hyp_vcpu() copies the host vCPU context and vGIC state into the
> > hyp's private vCPU on every run. ctxt_to_vcpu() expects a guest context
> > to have a NULL __hyp_running_vcpu, which is only ever set on the host
> > context, so that it resolves the vCPU via container_of(). The vGIC list
> > register save and restore expect used_lrs to stay within the number of
> > implemented list registers. While this is generally the case,
> > flush_hyp_vcpu() copies both fields verbatim from the host vCPU and
> > enforces neither expectation.
> >
> > Fix by clearing __hyp_running_vcpu and clamping used_lrs after the copy.
> 
> Nice catch, both fixes are correct.

Thanks for the review.

> 
> Please split this into two patches, one per field. They are independent
> bugs that just happen to share a Fixes: tag and the function. Both are
> host -> EL2, so worth stating that in the commit messages.

I'll split this into two patches and resend it as a series.

> 
> Otherwise this looks right to me.
> 
> Cheers,
> /fuad
> 
> 
> >
> > Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
> > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 06db299c37a89..ef9318ff0c25e 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -7,6 +7,7 @@
> >  #include <hyp/adjust_pc.h>
> >  #include <hyp/switch.h>
> >
> > +#include <asm/arch_gicv3.h>
> >  #include <asm/pgtable-types.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_emulate.h>
> > @@ -128,6 +129,9 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> >
> >         hyp_vcpu->vcpu.arch.ctxt        = host_vcpu->arch.ctxt;
> >
> > +       /* A guest context must keep a NULL __hyp_running_vcpu. */
> > +       hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
> > +
> >         hyp_vcpu->vcpu.arch.mdcr_el2    = host_vcpu->arch.mdcr_el2;
> >         hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
> >         hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
> > @@ -139,6 +143,13 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> >
> >         hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
> >
> > +       /* Bound the host-provided used_lrs by the implemented list registers. */
> > +       if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
> > +               hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs =
> > +                       min_t(unsigned int,
> > +                             hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs,
> > +                             (read_gicreg(ICH_VTR_EL2) & 0xf) + 1);
> > +
> >         hyp_vcpu->vcpu.arch.pid = host_vcpu->arch.pid;
> >  }
> >
> > --
> > 2.43.0
> >
> >


Best regards,
Hyunwoo Kim
