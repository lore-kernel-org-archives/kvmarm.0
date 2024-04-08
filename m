Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCA72DF73
	for <kvmarm@lists.linux.dev>; Mon,  8 Apr 2024 13:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584175; cv=none; b=GB/Y0fvJSmJVdyLCy6nDhmyB4wKD7Au3Dkf4idTg82vfMrN18WZIcZXNti3ZbbCbYzQPsmUN2Twr94f57BdtAl6pOZV8AuvuxRMabe2x8XsmboKqvu2YnSsRowV1MajCasp6xSravbMCTy8+B0vSNJ7jKbtl8CHN5n152HN1RiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584175; c=relaxed/simple;
	bh=K500gqqP3h8SVimmkSGXb6iGkbOpNnJ0lBcXRYTEKvQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k8pVWvaqGTJU1yu2Ipykviyq6DrzQ1IBbpILRXxMknMIq7jmcavuUKIqDg2uCqKYRBCsB1Xu/xYkg8lOBa93gVH5CaV22me+6FIFVYlk1Y2obWqIUqRL478udKRm6y+/2AZG0VAAcHVF8VhCCNXSZZHpc2vurNoU2hLnV6d5O1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UZ/Rp+nG; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UZ/Rp+nG"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-479f84be13dso473031137.0
        for <kvmarm@lists.linux.dev>; Mon, 08 Apr 2024 06:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712584173; x=1713188973; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=viCcaY4aqPp5ct/AZ3kQz5Nd24yvZt7hrlq9MoMjQJI=;
        b=UZ/Rp+nGPUFj8/SZWiwiE5iN4oE230qJDKYfiaUxRhB55ayyvjCToINlWoNNEBO13n
         3k1cky9D0D7hqT59QO+FgV0dRfnHv0XKGVzKKakjJfXe0xP/OF9smc/38h+gKBZfYaMU
         i5NPbl2YH9KvBzIYWCWcvB2az+++4RQWNF0jw1cCyvPDAHx9UAa2ZlRX6Ub60XkJ7foj
         BQQRfvv4HRGZ+xN6BkP/0o6rRCQQqtX5/ztobU3k5exbOmaOlSGzaPKqpyKLGWjaI9d2
         pQTIf9pt3+NUtZe7gps4Ey8/Xij7YU5mmscCNo4jpodAIsZ6plLncYARpKl2UZcUYY6x
         dMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712584173; x=1713188973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=viCcaY4aqPp5ct/AZ3kQz5Nd24yvZt7hrlq9MoMjQJI=;
        b=DRHrWL5PMxz0E6m2VIC1NlUuDtbJWs3vfzsNALp4otQeTNdX3O3dI9bBM8OhBCZg7X
         CyT4EWpAIPt0wxOPldr3EBuijaDIBYOhXpwEMD1Ak+g0vhPyZY88xXTSi6uRXgrt+aux
         oZZ284Ir7t4YCShYx9GLAa6K8ezKGjMpfOPZIjxvA9G5uBD/eWHmMzFaueQPBBPnzL2+
         jqG3WeZAe9hZ9LWjdUPwfapMAX24pzL/rHSlU5S0u2En2ja1Xw0K0Nfj9az/7zBpYAFf
         xV+jg6nxiYQ6Ja2E3BPkkiTkJU4plwINFWFADIfiNVlucWTj4rHuh8AE17GPcmk3DzMo
         GxKw==
X-Gm-Message-State: AOJu0Yx3H7CUsMvvDUhpZf/o1MAxJNnfU+81VSio3JLwG5DZeW+wuIle
	MInv9PMzkEERi1WebOVW28/qJ6W4OCrvBoMNpwCUw/jTeRwvTFB4G010+XYi/7VVtdcFQaMqK2w
	VpuK4PRerVx8e+gPm8b2ufWRjM48eo23tZOy6
X-Google-Smtp-Source: AGHT+IGD5GRIGsv8G0fQ4YiaD25bDhip656E4lPm/n8V7eMzq8s0ubudlVwcdaTEZpEFVmJWcBRJyAMo+xRPUH04U/s=
X-Received: by 2002:a05:6102:3711:b0:47a:578:c6e4 with SMTP id
 s17-20020a056102371100b0047a0578c6e4mr1894078vst.28.1712584172798; Mon, 08
 Apr 2024 06:49:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com> <20240327173531.1379685-5-tabba@google.com>
 <8634rwti19.wl-maz@kernel.org>
In-Reply-To: <8634rwti19.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 8 Apr 2024 14:48:56 +0100
Message-ID: <CA+EHjTxoyTLThbqQd5Gy94JYHpjM8rdkw2kRGmwdWm1mbWE34g@mail.gmail.com>
Subject: Re: [PATCH v1 04/44] KVM: arm64: Avoid BUG-ing from the host abort path
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Mon, Apr 8, 2024 at 8:44=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 27 Mar 2024 17:34:51 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > From: Quentin Perret <qperret@google.com>
> >
> > Under certain circumstances __get_fault_info() may resolve the faulting
> > address using the AT instruction. Given that this is being done outside
> > of the host lock critical section, it is racy and the resolution via AT
> > may fail. We currently BUG() in this situation, which is obviously less
> > than ideal. Moving the address resolution to the critical section may
> > have a performance impact, so let's keep it where it is, but bail out
> > and return to the host to try a second time.
> >
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp=
/nvhe/mem_protect.c
> > index 861c76021a25..d48990eae1ef 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -533,7 +533,15 @@ void handle_host_mem_abort(struct kvm_cpu_context =
*host_ctxt)
> >       int ret =3D 0;
> >
> >       esr =3D read_sysreg_el2(SYS_ESR);
> > -     BUG_ON(!__get_fault_info(esr, &fault));
> > +     if (!__get_fault_info(esr, &fault)) {
> > +             /* Setting the address to an invalid value for use in tra=
cing. */
> > +             addr =3D (u64)-1;
>
> If this is relating to tracing, can this instead be added together with
> the tracing itself?

Will do.

Thanks,
/fuad

> > +             /*
> > +              * We've presumably raced with a page-table change which =
caused
> > +              * AT to fail, try again.
> > +              */
> > +             return;
> > +     }
> >
> >       addr =3D (fault.hpfar_el2 & HPFAR_MASK) << 8;
> >       ret =3D host_stage2_idmap(addr);
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
