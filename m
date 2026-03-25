Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6223D8918
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 13:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444509; cv=none; b=SsTEQ2BlIV31bqr5/BRQRaLZcFDAtLrlIkmjep0P71N7xHWTbJg4KUsz/HqMBGgeoFwEePkSwNXVmJ+Pfqdq1L/1p+iSmE4jKd+aM8WYFbdJLqCqgfCSEh1bkLhKjLHKJ8nlCs+WZlqlKxE0h12ponQzfQ+o9VxoUVgQ7/ukhYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444509; c=relaxed/simple;
	bh=pDs4rtEJ9z76dFAJhmmNFOtAXbxIxQwbcLbJvXoX10o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aEhzjxQB7Pn6UhQSNpzyLmTo5Rq4YTDrPusqYm6niCezvPUmSa8YiH0PJkHHB2VClfFigIcfOuLXH0B0Jl8iOByoB4kPiC7pijYtyZ4t69BhKaVJ/qVY89wtgXlRWQC2REjoITh3Acq4r5sxfmDMSljL54HdR8avl/Pa51DUJOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YNuUW6kz; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YNuUW6kz"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48569636800so69945e9.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 06:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774444505; x=1775049305; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fr/xJXr+pWIqYUCMaECKCggQV4ePG6j5BQohThHEf40=;
        b=YNuUW6kzbcj9WrjTvJru3w0Vyjou9PKGG3493nTZ9KiESEvIz2QpsQqWaopJLnQs5i
         KEx6SvEGEMeIQ+YiSQpLXly1hYjNNqu/VCzOuu+X7glgDy8BmPe3FEzgOGegUvvML93P
         cbw3PlQ1TAUyUCfhKJDKEk7x7n6Bpf5XHygo9Z3toIncekIbPqyjN3qb9Y4qgQf/Mbye
         PGm+hpcEUe0OmopElCzceBYbUsqsiq1iUtUpUCfDas+cXU9ENc8BJnozTTmQvT0qQlKM
         sZqdAAHY2llI3FQi3fmRuvNwm69Z2BeboNtqof+AJoc8aZhvnEAXLPLAiA7WofS/UlWv
         41Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774444505; x=1775049305;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fr/xJXr+pWIqYUCMaECKCggQV4ePG6j5BQohThHEf40=;
        b=sTM5ACRkkmLa6Cbjto1PFamBCsu1mY7KkQ5nP9fYUopt5RUoYUwUGVaq0FSqfE+gwu
         TInuF/AQW5L2f5JZA9a4p8OjRS378ebaYz9PCn8EQvB5Qxq0WKOi5OVEb8MeWtH2HeVM
         mL1/dRXJx+PXXiU2HehsCQAc88H7f37tlQ+goJoPgPqkJcpsnuyRuV40Ma/95LrZwiua
         KlyQ8kUvHIEzYDfYB9gnp5Ikfj0KQK2MyPC47qIrqLNap9Z7fyy8uuJbZ6LT9v5SEWfP
         8UKOKDFm8h3zzzs2bhLJi9dv564ExE7if8Ke7uNwtWBBdtlDpW5XznAM2HkRWo4MTVkr
         ID0A==
X-Forwarded-Encrypted: i=1; AJvYcCXhFC6rlbLPY/HjxgyV6Y9Uh8TX/+QXkDcPMOJT2eF+AEe4YTKOU6lzvdhCHHNx5RklZaHHIdQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzlfx5nec55yp4yVx45cXCtgrot4OVLVWuk8A/nIXNstRBGKlPB
	gTlBCIJiXQ5nMiIqcFEZr6ZMvkdLCNqOKGpF/S4GTiB2OTazPtuS/4bT6zbNoYeIXA==
X-Gm-Gg: ATEYQzwsMCgCcat+GFjEJF3ixaWOrEuCwVVtwhCQOsZQwKp7t0JbCkVEAzUe9xnp9/m
	nF62qZnmnQLSpO1vr0CaAKNXvdzbGv+E2stluFM2GfkGGPszRRXTRUB6VGHg3TD/Ln9NXyIMWBe
	YGQRZ20hCeXW++jIfL+gpwkcO65IG9y5/05M7BHymeafPNDexjIFMh5Gi9IWRvUnPlU/Wgj8BRb
	wyoiMLGlvTcM5srRJT1DhJ/0N2tFkpuWFO81DcoCimJma7GOCkIiZ3/x0wR9gToro1glQBv1sX6
	D1xq92XUIauPQ01hRzPVFfu9EMP0QLR1/v+9857xvJ5gz9f9ZRzJTKs1BO9U+KyuqEXmoFHGNzM
	PciNN75I0HHLIXzYYx567dREIKrEp+GF5jT6sqdeBjiCuznfdWKi5+31j/HSLuAjwa4xzM4o04h
	/qE5LqVsCW+lTTLSa0n6k4VCUxs0vsaf6RUwfdDlrwTfqWPolUZLqO+3CFHfL13FvCBc4=
X-Received: by 2002:a05:600c:2d43:b0:483:6a76:11a6 with SMTP id 5b1f17b1804b1-4871787d9e2mr493345e9.5.1774444504645;
        Wed, 25 Mar 2026 06:15:04 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-487116ee514sm157350785e9.13.2026.03.25.06.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 06:15:04 -0700 (PDT)
Date: Wed, 25 Mar 2026 13:15:00 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com, joey.gouly@arm.com,
	mark.rutland@arm.com, oupton@kernel.org, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH v2] KVM: arm64: Prevent the host from using an smc with
 imm16 != 0
Message-ID: <acPf1J2dOLvpXHhE@google.com>
References: <20260325113138.4171430-1-sebastianene@google.com>
 <acPIdoA8oc7T8wKX@google.com>
 <86ldfg3ze2.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ldfg3ze2.wl-maz@kernel.org>

On Wed, Mar 25, 2026 at 11:46:29AM +0000, Marc Zyngier wrote:
> On Wed, 25 Mar 2026 11:35:18 +0000,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > On Wed, Mar 25, 2026 at 11:31:38AM +0000, Sebastian Ene wrote:
> > > The ARM Service Calling Convention (SMCCC) specifies that the function
> > > identifier and parameters should be passed in registers, leaving the
> > > 16-bit immediate field of the SMC instruction un-handled.
> > > Currently, our pKVM handler ignores the immediate value, which could lead
> > > to non-compliant software relying on implementation-defined behavior.
> > > Enforce the host kernel running under pKVM to use an immediate value
> > > of 0 by decoding the ISS from the ESR_EL2 and return a not supported
> > > error code back to the caller.
> > > 
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > ---
> > > v1 -> v2:
> > > 
> > >  - Dropped injecting an UNDEF and return an error instead
> > >    (SMCCC_RET_NOT_SUPPORTED)
> > >  - Used the mask ESR_ELx_xVC_IMM_MASK instead of masking with U16_MAX
> > >  - Updated the title of the commit message from:
> > >    "[PATCH] KVM: arm64: Inject UNDEF when host is executing an
> > >     smc with imm16 != 0
> > 
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > index e7790097db93..4ffe30fd8707 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > @@ -762,6 +762,12 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
> > >  		handle_host_hcall(host_ctxt);
> > >  		break;
> > >  	case ESR_ELx_EC_SMC64:
> > > +		if (ESR_ELx_xVC_IMM_MASK & esr) {
> > > +			cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
> > > +			kvm_skip_host_instr();
> > > +			break;
> > > +		}
> > > +
> > 
> > I wonder if it isn't better to move that into handle_host_smc() as this is part
> > of how we handle the SMC after all? (and it calls that kvm_skip_host_instr()
> > already)
> 
> Yes, that'd be vastly better.
> 

good, I will update the patch to do this.

> It also begs the question: if you don't want to handle SMCs with a
> non-zero immediate, why is it OK to do it for HVCs?

I talked a bit with Will about this before writing it. My understanding is that we
don't have to do it for HVCs because the interface with the hypervisor
is controlled by us whereas with non-standard SMCs we need at least to
tell the host that we are not handling non-zero imm16.
 
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Thanks,
Sebastian
