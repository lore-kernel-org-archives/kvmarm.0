Received: from out-167.mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25BD3AEF57
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 12:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785845449; cv=none; b=ChcjccWzaRaTUKl1/guRGc+ytop6l4acq0E8lXnczPxJUw1KwQRQHK7HPhY5bA2D89bEf33cMxziIXUeYAwaOHRozcAgaJAjcWA8HxLd5jLeCTmdAqq0J7haTEnfN1+vW5jVuySJ5gyLai20Q7eMUKSxZtdlasN8l4CpQdEZUhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785845449; c=relaxed/simple;
	bh=1u2o741wPj3Q6DkaxBlUD3RXyl3cVDtoIhsVj719EZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FhFEa6rVVbgr+DiO8bDfqmYf8zGXxlVXrsnVl8yMnpNFyh6PVul7g8LANdwbYtwic5zmfXEasM8106YdjFuF6Ds/Wsd9Icac3e0TUrcROBJcUlAzfWkcsJZUCcinBh9EcxHCUNZjkXKIfazVLUfyzYddQf2s0IWzI4TGzOfWOCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XknNEPTs; arc=none smtp.client-ip=95.215.58.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XknNEPTs"
X-Gm-Message-State: AOJu0YxEpBSuPV8Acq99MDPvolIt17ze1khmlHsxWFDWknK8dtmv6ovb
	VQNzTKzcE6In3lNGmw5+DDS7CoJ9wqSUCtYwNsy7GbPYGRwQTkFdNYJW0EcXwznRLNbZlFQAZQq
	zi2PGD9WB2pTWyU9QkUHmw2IMF23AVy31/UKKPEpY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785845444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iNaZqTvfBl/mQOhB5xmcJfLUMlJ3nxP86XVXkQHXrYg=;
	b=XknNEPTs77ykhDwpP3luLKZrgHTHnuphse2fBkyn7pOB214D6mS5iTF2uqrkJp95ViAcNp
	uvQvGyrUMCQR4mVnRenfQcFYnRq1+sWsLa4356U90iwdBEb16Ip6+9LSxcBslqS0uFI1nb
	f1RglIpz6yQSknH7mU31pidyxzwQsg8=
X-Received: by 2002:ac8:6f1b:0:b0:52c:d3a1:358a with SMTP id
 d75a77b69052e-52cd4fc8ac0mr14559141cf.14.1785845418465; Tue, 04 Aug 2026
 05:10:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260804112317.1937387-1-fuad.tabba@linux.dev>
 <20260804112317.1937387-11-fuad.tabba@linux.dev> <20260804114056.922561F000E9@smtp.kernel.org>
In-Reply-To: <20260804114056.922561F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 4 Aug 2026 13:09:41 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwHtFrGU0ZDFFXBdtbibobqCzNC1ivWOGcNMe8GTKsWgg@mail.gmail.com>
X-Gm-Features: AUfX_mwDwLhYc4wfMy1EBhYxYPf2GLWFDa7oHKuVGKmSjIiwt76hi61DOOWerys
Message-ID: <CA+EHjTwHtFrGU0ZDFFXBdtbibobqCzNC1ivWOGcNMe8GTKsWgg@mail.gmail.com>
Subject: Re: [PATCH v3 10/11] KVM: arm64: nVHE: Check hypercall handlers
 against the declared ABI
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Tue, 4 Aug 2026 at 12:41, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Missing context synchronization event (ISB) after writing to SYS=
_SCTLR.

I thought we'd covered this [1]. The ERET back to the host is itself a
CSE, and SCTLR_EL2.DSSBS only sets the default PSTATE.SSBS on the
*next* exception entry to EL2, nothing executing at EL2 consumes it
before the return, so an ISB is redundant.

> - [High] Double-fetch of untrusted host memory in pkvm_refill_memcache() =
leading to a TOCTOU vulnerability.

Not a TOCTOU: __pkvm_host_donate_hyp() does a host+hyp-locked
ownership transition on each page before EL2 dereferences it, and
nr_pages is only the loop's target count. Worst case the host
under-donates its own pages and starves its own vCPU.

/fuad


[1] https://github.com/masoncl/review-prompts/blob/main/kernel/subsystem/ar=
m64.md


> --
>
> --- Patch [10]: [PATCH v3 10/11] KVM: arm64: nVHE: Check hypercall handle=
rs against the declared ABI ---
> commit c02cd7851991d5d8c9aac5af1e86684fe8258ca4
> Author: Fuad Tabba <fuad.tabba@linux.dev>
> KVM: arm64: nVHE: Check hypercall handlers against the declared ABI
>
> This patch replaces manually unmarshalled hypercall arguments using
> DECLARE_REG() with generated handlers via DEFINE_KVM_HOST_HCALL() and
> DEFINE_KVM_HOST_HCALL0(). This ensures that the parameter list is type-ch=
ecked
> against the signature declared in <asm/kvm_hcall.h> to prevent mismatches
> between caller and handler.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 23cb4313c60a2..675d607727929 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>
> [ ... ]
>
> >  static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
> >  {
> >       struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> >
> >       return refill_memcache(&hyp_vcpu->vcpu.arch.pkvm_memcache,
> >                              host_vcpu->arch.pkvm_memcache.nr_pages,
> >                              &host_vcpu->arch.pkvm_memcache);
>                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> [Severity: High]
> This is a pre-existing issue, but could this double-fetch of untrusted ho=
st
> memory lead to a TOCTOU race condition?
>
> The host memory is dereferenced here to read nr_pages and then passed as =
a
> pointer to refill_memcache(), which fetches from it again:
>
> arch/arm64/kvm/hyp/nvhe/mm.c:refill_memcache() {
>     ...
>     struct kvm_hyp_memcache tmp =3D *host_mc;
>     ...
> }
>
> If the host concurrently modifies the struct between the fetches, EL2 mig=
ht
> use a min_pages target that differs from the actual struct state. Should =
the
> struct be copied to EL2 private memory first before acting on it?
>
> >  }
>
> [ ... ]
>
> > -static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt=
)
> > +DEFINE_KVM_HOST_HCALL0(void, __kvm_enable_ssbs)
> >  {
> >       u64 tmp;
> >
> >       tmp =3D read_sysreg_el2(SYS_SCTLR);
> >       tmp |=3D SCTLR_ELx_DSSBS;
> >       write_sysreg_el2(tmp, SYS_SCTLR);
> >  }
>    ^
>
> [Severity: High]
> This isn't a bug introduced by this patch, but should an isb() instructio=
n be
> issued after the write to SYS_SCTLR?
>
> Updates to control-plane system registers like SYS_SCTLR require a Contex=
t
> Synchronization Event (CSE) to be visible to subsequent instructions.
> Returning without an immediate isb() might leave the processor operating =
with
> an architecturally undefined pipeline state.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260804112317.19=
37387-1-fuad.tabba@linux.dev?part=3D10
