Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637B9175A69
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 12:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781699995; cv=pass; b=hGQ0L4Zq0JxudXWyObLdSyImNIojj9nWE5GjZhAp4v8+yhz1PT/RV540SrmPpNgrM+rs7ZcrrZIjvmsFX78bZ9UjtR0Wr1DVS4yEjtqUF/UJcRALHcqh2n2ODjoKl7WIHJltI51X8kr5z8rmUay7lihupCMYL4yTFou4pRFIjP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781699995; c=relaxed/simple;
	bh=t9viMQR94jVVD+nDvBDbpY98W8gKo84PmFUepmOCjZc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DIDuWONoE9q+9/T28XtOgw8U0SSY/HR/oLqWJdK+QPQpYgOCY6dbJxpgX3tcUwE5yT1Z9QrcanaIMLOklZJafFLuzywm3pmE/og7LT7e3sqYcJitYwSocm75+8/vRdf4a1huXQDCRcvvyhQQctoGJf9ml/geVK77IKtWUDVc8jI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e7rmlqJS; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e7rmlqJS"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51765531803so258551cf.0
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 05:39:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781699993; cv=none;
        d=google.com; s=arc-20240605;
        b=InnUweLexlYLy6zN7rQwpJcvSLTKQH+MQSayjyszlSrkdRNO9zZM5dyD+ye+tK106V
         Uw+KpaUanzrbeuAECinbArJMg2Wsc84p+6MC88SvzAzEImWjz7MnXd30PV7jsMAqCzGP
         NCGhxJuwzaUgjtK95v7JI4bB965Z1tuDiRdF68Vowq4fhM/tQIyQrP3Sn72ytjCiZnEo
         gqiz9NTRKs2m2ED3st6BEMKEeiyHsvGQcqQIKNRA/HG0kRiJkqSUlsPfpkIGU2hvPqLe
         ol2OK+JmrxRF6J9oRlRODeChPEQo6JyUyEuxnGggQqf79TYCN2fbWnD2MpfaX6JYzhR0
         rL5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=qhhtgQnSjLdOLlgeRgnMdwozVJra8F/T77Ka+Nix12g=;
        fh=/UpVRtjFf1WtyeU7B9jg3og8PZM5VSJMOUHob9jldnc=;
        b=EOtCO4c+SVMAbIyjWu6CplgUTgz97O1VjIm6iqLQUsxivKFfPH7CwZNYk0xtoL/IgE
         M2scyLKCttKkXA/S2/iZY9fPJ1t1Uyu1SkVnudNYgfXFRO4PaFp1kA2Bsu//Y21xB9Nx
         99IX9mEfn1avz0Zm9yz3qlfJ2WtzsfwSPnvMWJsLiu2B47Ar7VYeTKcsg4ie1nCg4y2a
         DuyqTFzxBvDn2H9pw36pZdD+vDJIpyqsCtadNE08VUDPuECFnrCyGth4DfjNZ4/owHpH
         HdHxm5Vz2Dh/sL43fSKGKzulvzH0g1gjvb1DgUjscq1Ksxbp4y4+VDXlojdXaQz/dG/R
         3ePQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781699993; x=1782304793; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qhhtgQnSjLdOLlgeRgnMdwozVJra8F/T77Ka+Nix12g=;
        b=e7rmlqJS0IKZOtzDUtq0SPLJpkQibRGeuTMkyWCciYWskd90+rXov6dipGXSvbiEpQ
         b+5opkxprfrzIujCx/AirorqIp9vv1hsgkzLPNCc64bX7DglxwmbwZLjk8a26wFpiIY8
         7hg9j18ay8Uet6TTRY29howo47jMIztS3SeZj31ZAFAaYGqriih1Ln4n9xky2EN9g10X
         3qO4Nikrb1Hck01oyMHjky1neWpyUYUH7TA5aicad9Da9o2Lc2qfeW2YIfvgJFtITAQC
         H0EGEUnk3Ubg9yspV+mJuygQ0XQOp4WWbDWfQ8EVfml43UnkBMBuTzhprT0+bIzzgKM0
         oTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781699993; x=1782304793;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qhhtgQnSjLdOLlgeRgnMdwozVJra8F/T77Ka+Nix12g=;
        b=C2IfhSxEqMA/zlFFr98VuJtFxfc8fdaREMQ5qzWdQGEdE1XJXJAPMDMwf2aP1hRUSY
         FAuJHt5iIE1ZmCEGmEvzL1Jz+GaYkOPgXG7Bum2mPhaen5Td+eP4nru2qAn8HRlwHTJM
         ea/pTi9XqgYrfAEl1pZjsXvhAYDrftaNtg587EsTGpJFG+lgP/NvK7AYc3X/J7Ylh4bx
         x3VGeMrSB/pTGQ4wnBPjSvBKg1U/9cxG7xvo9cOYprHhnRGIghPIbpK3UVg6LpHsgEIL
         MULLjY2jyVrw8WQHAxLubSJ6+zRXFHgtP/p9L5HnZTacU/icQLckg+5mI4/VpYGL9634
         te8w==
X-Forwarded-Encrypted: i=1; AFNElJ+5dA7SR4rRrLHC9OuUzq0+jjTL+YrHzqKvDjb2D5Q4wqOSpKW5p0oa92FDjATBVJyOUt4bMeY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0OvAl6y4l5YxWTLDzTNsvBuMHQFdrUEpl/MHULZ4ZMJsfeiRs
	XVLJbR/ERy940hBpxxXoNJdXNtPXBnea5JrLUniIF1ZhN1hWJAxDiRnvsG9DU7b7HtOS8EbeC71
	pc+zeN0A0uvyKJKs43cOhPc/k2PAhCtY+pK0uIMNO
X-Gm-Gg: Acq92OEkrkSEHDIs8YJ9hfqvl6uForhIfONvGI6cOB/Z3qnTxV6+av7EFm/93BXORjm
	FqhjraJ8TnVl6QBqTeZhkC9nn2UA6h1j1yuxCg1Yr8xax5YAxv25RX3JcElKh6DvKDpa/pzySfn
	w0pOa2u6CiK7yK6PkDRN8QEtD4OHqvRNlhED4aja2LucAG2WCDjdhsg9V/dJ6bDbiVJY2fXeHAk
	nk69157jVRlRCpX/+9bkt6JnE+qdIXWoiZwokS2Aow0TPkk4dGS3DVmEaVhJVp4op+d2pDbPyJX
	y1JbaoXW4I2qv7KJ7SsNJhZie/Y=
X-Received: by 2002:ac8:5fd1:0:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-519ad98aad1mr7033901cf.5.1781699992272; Wed, 17 Jun 2026
 05:39:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260614163336.3490925-5-tabba@google.com> <20260614164547.D398B1F000E9@smtp.kernel.org>
 <CA+EHjTwHoveK6FT0CGcKuj97aUaHpv7vk=DQjRxT9c6UkkSeoA@mail.gmail.com> <86wlvxs5r0.wl-maz@kernel.org>
In-Reply-To: <86wlvxs5r0.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 17 Jun 2026 13:39:14 +0100
X-Gm-Features: AVVi8Cct_ZHP1KQdVJAOvW56vMpd8WJo9KZTslpamsJbbcKsypOLTzJK376mQOM
Message-ID: <CA+EHjTzWpLBxy=Pi=K0G-9JU0cPTsGSNB4Esy+K+vFYNM0DnNw@mail.gmail.com>
Subject: Re: [PATCH 4/7] KVM: arm64: Set IL for injected FPAC exceptions
 during ERET emulation
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 17 Jun 2026 at 13:36, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 15 Jun 2026 13:42:23 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > On Sun, 14 Jun 2026 at 17:45, <sashiko-bot@kernel.org> wrote:
> > >
> > One thing I noticed while looking at this:
> > kvm_check_illegal_exception_return() preserves {N,Z,C,V,D,A,I,F} from
> > the current PSTATE, but the Arm ARM says these should come from
> > SPSR_ELx on an illegal exception return (EL and SP are unchanged, but
> > the flags and masks are taken from SPSR). PAN and ALLINT should also
> > come from SPSR_ELx if their respective features are implemented.
> >
> > Marc, is the current behavior intentional, or should we be
> > constructing PSTATE from the original SPSR_EL2 for those fields?
>
> This looks like a long standing bug for something we really never
> tested. I reckon the patch below would do the trick.
>
>         M.
>
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2746,17 +2746,29 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
>             (spsr & PSR_MODE32_BIT) ||
>             (vcpu_el2_tge_is_set(vcpu) && (mode == PSR_MODE_EL1t ||
>                                            mode == PSR_MODE_EL1h))) {
> +               u64 mask;
> +
>                 /*
>                  * The guest is playing with our nerves. Preserve EL, SP,
> -                * masks, flags from the existing PSTATE, and set IL.
> -                * The HW will then generate an Illegal State Exception
> -                * immediately after ERET.
> +                * masks, flags from the existing SPSR, and set IL (see
> +                * R_VWJHB). The HW will then generate an Illegal State
> +                * Exception immediately after ERET.
>                  */
> -               spsr = *vcpu_cpsr(vcpu);
> -
> -               spsr &= (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
> +               mask  = (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
>                          PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT |
>                          PSR_MODE_MASK | PSR_MODE32_BIT);
> +
> +               if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, IMP))
> +                       mask |= PSR_PAN_BIT;
> +               if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, NMI, IMP))
> +                       mask |= ALLINT_ALLINT;
> +               /* Account for FEAT_SPE_EXC and FEAT_TRBE_EXC one day... */
> +               if (kvm_has_feat(vcpu->kvm, ID_AA64DFR1_EL1, EBEP, IMP))
> +                       mask |= BIT_ULL(32);
> +               if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
> +                       mask |= BIT_ULL(34);
> +
> +               spsr &= mask;

I'm on it...

Cheers,
/fuad

>                 spsr |= PSR_IL_BIT;
>         }
>
>
> --
> Without deviation from the norm, progress is not possible.
