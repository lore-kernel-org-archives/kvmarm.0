Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7123CFF77
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 11:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774438885; cv=none; b=GAPSLZUkaqp20hS48TE4WtaAxaBc/cmXQLqs1NG6ikoKwh3LCU77lfKRTTTZszwT87UWT2Ix1miMFDQx/x2xI5nmDa4ieT6HS7ZKh43gL67vKnPt24d1X9XdLBeHupmjDFN285f9AsIagZA1xZYdr5gYEPXEh/vHyJS5AyyGeEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774438885; c=relaxed/simple;
	bh=MpcjsemM3LmMcoHooTMoaxadZdP5gIT5DsFtteobzUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TJ+Dne7OeK8xYHEqKuFF3MlG8hlgjVUNH8AI9d4y9pUpdJotiUN/W6LPuev/6cJhIMGDoN0ZJQmwRTKJ0U97KK3y7G+HFuv540xkxaIBYxGocmXGflHDUksGp/J9XcCu6BGGKvge2HpmmwL2g7rNNRS31PFdeynlEnw8LrMtKvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hezOppcj; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hezOppcj"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-486fb990b9eso73495e9.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 04:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774438882; x=1775043682; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cs9jWxbOU9zeEIpB1f4ZXLcUS7XMeoF1APCchnD0TKU=;
        b=hezOppcj9D5WMzVkZyG4QmEtBtZTYDzNt756HzoEalPc72CI9zpu5m7K1x++kYEVw4
         IlcYgFNKT+mo2BUb+DWhFLVX7SQpCfK9Y84uv3qRygaTu1q68yJWdDj5o2iEjok5rirz
         D0f7UMeEhnYORsTOWw7I5s9krP7VjzyKPkAzwHFPYNOTnLf2EXxf17Vu3Eb983aOgPyj
         Q2Gl2yQjW5Fklad6J2BaEp3opUfYERzRqUcZOLdDDONEVCoyaPjld3YxowDq/sPdo23n
         dMDApYTe3iCTKt0tvCIKppPRbPeY46Q08uzztdTha10HaoTmvRKctbVs3U2jbmohwf61
         SkIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774438882; x=1775043682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cs9jWxbOU9zeEIpB1f4ZXLcUS7XMeoF1APCchnD0TKU=;
        b=DVD2qlEMSQUA/F9NIZ/lNAH03v0K5jMCZRzmoHmAy4BCxCEzMSXzvXuS7fK7sf0MGb
         Fjglj3ebjITjB91+hXEVW/yME2/qcMnLJjWI0U1Q/lhrZWNEyOI1k7cG3EWQyTVmXne0
         Q3nSY8Aq3dI7RNGImJPFm0HJKSJHXBeQJPEbubqh03SXEZwANZF2HQck2LYvHyOJtNYq
         DSuQhqXrZaJXFVRjgPYULLtTZTeRORtQbzomQkHUfvi9Z2AMu/jlho6ukkaH8Ica0CL0
         u7eRrdnKIqJ7ZufQC5YDxaz7FA1tdQx8Bho5GwqrxhhHKaZQIU8MOVk7aBwXys8Cs90W
         lo0w==
X-Gm-Message-State: AOJu0Ywh4NwNG4bOSKfHYP/SIx+TgiN3H9ft1JCmdmorzAjIvzZ17s+m
	rhkKWIj6qU8JL9pun088VtBJeLKMetrYMqRiwZQj+FwokBwEopXRgpCz6kn6YJMDVQ==
X-Gm-Gg: ATEYQzwAkspSOqIDb7AClhlJcN+sTCjZM9HoPzIj/CK/sAlIev2TFA8UO932stVUP8Q
	90Pjwf1lvLyJ9wvssYJ5NEomVjDGboiZu7/oYcZEtTMuH5H48sMX/6qNtU22IfbKiw0X0uZ4znk
	QotD5LHDQ+JnlZmBDyzyOpsYnjfxW8nKIV8hdx2HHMJxkmipr4cP69QlBi99lV3TDtGB81mJhuS
	6KZyy2kVYoIBF+XoKlBLOa/3UF7P5afNGAzDhG03mqOHFZDyMvjwZbf347C2GQYBSZFNGF8neMO
	K0G8ZrkA6dOI/0E2kYPstBkZnUTlhX1kq5SOHSx6xJti7/ZgKT8/wqaF7W/BIxvnOLFSBI0mOKw
	8Emto0H4S5n4DZCBY/SOHr89VMsqeaLIkwjMbczJn5+Ojp34evOCsRHUO/cnHQevImvWFzI5oGT
	esHGXv5uvlZ6TXzAO9Euzo6AEKah9YeybJRdqstFuXOKnGmjsl8ejLKITwO05ClPhfwOs=
X-Received: by 2002:a05:600c:17d6:b0:480:683f:743d with SMTP id 5b1f17b1804b1-48716828baamr534525e9.14.1774438881656;
        Wed, 25 Mar 2026 04:41:21 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644ae37dsm48451320f8f.2.2026.03.25.04.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 04:41:21 -0700 (PDT)
Date: Wed, 25 Mar 2026 11:41:17 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com,
	maz@kernel.org, oupton@kernel.org, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH v2] KVM: arm64: Prevent the host from using an smc with
 imm16 != 0
Message-ID: <acPJ3Z9hDKc0Sm2t@google.com>
References: <20260325113138.4171430-1-sebastianene@google.com>
 <acPIdoA8oc7T8wKX@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acPIdoA8oc7T8wKX@google.com>

On Wed, Mar 25, 2026 at 11:35:18AM +0000, Vincent Donnefort wrote:
> On Wed, Mar 25, 2026 at 11:31:38AM +0000, Sebastian Ene wrote:
> > The ARM Service Calling Convention (SMCCC) specifies that the function
> > identifier and parameters should be passed in registers, leaving the
> > 16-bit immediate field of the SMC instruction un-handled.
> > Currently, our pKVM handler ignores the immediate value, which could lead
> > to non-compliant software relying on implementation-defined behavior.
> > Enforce the host kernel running under pKVM to use an immediate value
> > of 0 by decoding the ISS from the ESR_EL2 and return a not supported
> > error code back to the caller.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> > v1 -> v2:
> > 
> >  - Dropped injecting an UNDEF and return an error instead
> >    (SMCCC_RET_NOT_SUPPORTED)
> >  - Used the mask ESR_ELx_xVC_IMM_MASK instead of masking with U16_MAX
> >  - Updated the title of the commit message from:
> >    "[PATCH] KVM: arm64: Inject UNDEF when host is executing an
> >     smc with imm16 != 0
> 
> > ---
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index e7790097db93..4ffe30fd8707 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -762,6 +762,12 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
> >  		handle_host_hcall(host_ctxt);
> >  		break;
> >  	case ESR_ELx_EC_SMC64:
> > +		if (ESR_ELx_xVC_IMM_MASK & esr) {
> > +			cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
> > +			kvm_skip_host_instr();
> > +			break;
> > +		}
> > +
> 
> I wonder if it isn't better to move that into handle_host_smc() as this is part
> of how we handle the SMC after all? (and it calls that kvm_skip_host_instr()
> already)
> 

I was thinking of doing that as well but I prefer this since we don't
have to look again at the esr in the callee. 

> >  		handle_host_smc(host_ctxt);
> >  		break;
> >  	case ESR_ELx_EC_IABT_LOW:
> > -- 
> > 2.53.0.1018.g2bb0e51243-goog
> > 
