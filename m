Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E386E48B395
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 15:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781710195; cv=pass; b=Jqj0aiSpNYjBcwgXIxGrfRbEsi4O9JTbMx+l5FPXLyVQGeP4EobgERYa3euQk5KBjIL/OHg6TJETonigfTpsKrr4qg30sBoHDN/HPeu3fS29WSgY7OngaVAvEe6PjxmsujNiqMlBftB+nP9ouakCns1nlM0Y47jhP5oe5L+3/Zc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781710195; c=relaxed/simple;
	bh=MKk5MluiAQJnSpa2Pf6/pQQh44RfvLoPtvDGJYV3mt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MfYx+tI/XLVHjBrgtfOqBUdBZZAej1EachLNHHeJr3tGXsIjWNuDvtz2Wj5KEqSAcXmGzbfEMfLuOMDvuWNS6CwVlAKBS5fPbtANE7LtpM45WJ/duUvkvaiLnKAYGh9gi6OEKxIApWpbzF3hfdUNBGHv+pcYHSNuNJJHzMCzVmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nh1BayIS; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nh1BayIS"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5175d339e8bso303221cf.0
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 08:29:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781710187; cv=none;
        d=google.com; s=arc-20240605;
        b=DdO5pMjEBPvLJ7N4Neb6OBomicCZAXqL2zZcScOMIJfWZgSm39oLi+rbGYNs/3VlvA
         9RQYqB6/lR+skORheeCBG1J1gY44STCmzrUMhqGOcC/L7CNHWiafYmkEJzYWzR1Sc+zz
         ausa+IixqaR4DKbLK2nuCJsruak8MQ/v5YXZD42wK3AFQNZZ9tOnWET/Q486Ekt3DfAb
         ZZ7f5G7j7ACt8TS4xF6mNv+DOO+2Xmf7bDrqkS1UnPrxhA3LFdxebJgu4XfciiHFY+wo
         32bgp56XlehDaSFeYm/cHxLUYcP/HJ3Pt7UfubdatNnAhSJli+/ZI1gUbg6WRA23R/xX
         lMtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ubB/kwmCmSaCx0iLF8+L4TShpYDwgBrKrRr5YdGlWvg=;
        fh=BOm5ffzusLmg0EzO7/QePpVrxNSvX3O/BCNTbUypm4g=;
        b=PTYUSv73It52q9vGJDAEBa8tece8nN40CgG58/ti1WvLfdK8SJoi3TK98o0Fqpx7cw
         OQdDAYGxSLRLMb2bOi1w/hjxHB6ksS7d5ZdjJFN/dBuqsf+lbtvQbue4/kHZn6pwDeXk
         SY9KZRuBkBpl3J/mB3cxonm1IFcg8npiTbYKvTaUmXqgGUPtX6pP5SN65uAbHL3YM4HT
         9gGUs7Bljptxr8eXkNXsUqa5HbHHZIUEfw7MR/G5l1+kAalfB/jnTkqRm+0+W2nN0eZA
         nuShJab+yNGH/Av5e7dOkwW/+5v3VSZ18joO3GuNZM+WTRN1Fb7WS+nqAOL7AOqBQY/i
         qQoQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781710187; x=1782314987; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ubB/kwmCmSaCx0iLF8+L4TShpYDwgBrKrRr5YdGlWvg=;
        b=Nh1BayISpFYKxCmH2ruTiwBdJhXVQSDksu4z63h+w0JLtcNeibmLEz/DeLw4gk536e
         ECScVFkWvvwPx4fnRg74t3QSC4jaJJnVWvWpaRZhW6GgaH08QVwFbVwOJG07g3Wr/mrr
         05hu3D8OMaNBscDHtC4khHHbWpHU64JvVGt75N+1PCNipxNtdthg0LigDiJb+tAdzKaV
         T3beHZVGMiofhEpk2RToUDXGkmskeaWRYQeEMPXOwbyvlD/BxydpZAXMXIMj8pNZCMXQ
         xKWF1YEuG+splmdbiC/GP1ot3tftpEKKqT2cURqWtiNA4sy0O+NySKMPGdiQYixlH3pN
         o9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781710187; x=1782314987;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ubB/kwmCmSaCx0iLF8+L4TShpYDwgBrKrRr5YdGlWvg=;
        b=RsfLucmzMUgh6Na4MyV3RgDbjcjDp+vY/LZpqdiB0DnfQh7mQGefsemwO+IVSV7Ch4
         cKEHXsp6BEyMlwUat5p+CI/Wm2/Q8a+xNlSz/R1Xs8//kxWKNzMqykuq005Z5KQYp3E7
         Dgnp4UZ86z4NLpYbFpWlnsYbLo/L15np1nxTwBkdh+9qU1lyxy4vLN2OieiOV8nEM26s
         zgyqgFb1sKX0nUdHtEcyRvZqdMsscAQOsq5ESprtf6EHfO/7OEUWeHdWYCcIcV8mEdA6
         C4eP5u4+GxP8mHG7eKA13e3mvhvYnvtfXYqRY6oXC0TNYcj/phU5ImXRXyEUsxZ1LDIZ
         WVCg==
X-Forwarded-Encrypted: i=1; AFNElJ+9h1Vi5AxnTpb+n6bK2zNIbEOMTGjzN/zjG5aCS4VZ0xo/Ot6bJflA1vgcYAXzcn0erh0QSo4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxOHvOpx4O/Ncb8poDFFqvJ+C9uL5u3sfxQi4FwPMVS1jWzIUuc
	46V/AJJsg/82AbskanTtEsp+WXT0nqEHadmt1yB+wzHcrSUulrF3Pejkn++nE5ofju9//1Svpfz
	mH9Eu9Iu6UMzn26zvhi1E0sIND8Pihsp/DMu+AZy+HtComOfZEySwEiwIPDA=
X-Gm-Gg: Acq92OF2BeDvaVy3ledd1dbVvmEvZ+1+Sh11H12yxKiJN9R2TH5W4Re/pNja6i+QYzC
	rVZQF5LLfiJs7asz0WGCRS2MIYoQUCcdq047Zx0El9QfBd74dj8cM+OJ26toBoqAhtXAQ1xie3h
	NUDhvCg3AE0sDfvzaFPLwCCnMHUstqSjdHHzqhoFp9ybIMJUDkLNg6m4jslLT6NECmR+1ZjsVnK
	+XGoE6cfnLFZid0fdHdjQTUaUg7WAEV2UfLqNwva1FwoUzReYyiFMuk73oNn9MGIjiNAIDC6u94
	HyvAvY5fmFyi+WkAvPOtZE4/nw==
X-Received: by 2002:a05:622a:5a0c:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-519aa976470mr10556381cf.8.1781710186875; Wed, 17 Jun 2026
 08:29:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260617144907.2972095-1-tabba@google.com> <20260617150438.66E3A1F000E9@smtp.kernel.org>
In-Reply-To: <20260617150438.66E3A1F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 17 Jun 2026 16:29:09 +0100
X-Gm-Features: AVVi8CcDF_ndawt-hT_yYHscpCN_9-TB4HVtY75uSEgCoFxG-oPzigLrxSYXAig
Message-ID: <CA+EHjTybyMvQtBAbRhShXA8Ba0=-W8E7-RvCKO2X3EMnMXhhuw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: nv: Fix PSTATE construction on illegal
 exception return
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jun 2026 at 16:04, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Incomplete PSTATE allowlist on illegal exception return causes g=
uest state corruption
> --
>
> commit 93d5c5c2769fe9f58076ca66eb01cbe04fd87921
> Author: Fuad Tabba <tabba@google.com>
>
> KVM: arm64: nv: Fix PSTATE construction on illegal exception return
>
> This commit updates PSTATE construction during an illegal exception retur=
n
> to correctly source flags and masks from the SPSR being returned to, as
> per ARM rule R_VWJHB. It constructs the PSTATE by taking these fields fro=
m
> the SPSR while preserving EL, SP, nRW, and EXLOCK from the current PSTATE=
.
>
> Link: https://lore.kernel.org/all/86wlvxs5r0.wl-maz@kernel.org/
>
> > diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-n=
ested.c
> > index dba7ced74ca5e..ace2b40cf8756 100644
> > --- a/arch/arm64/kvm/emulate-nested.c
> > +++ b/arch/arm64/kvm/emulate-nested.c
> > @@ -2738,17 +2738,30 @@ static u64 kvm_check_illegal_exception_return(s=
truct kvm_vcpu *vcpu, u64 spsr)
>
> [ ... ]
>
> > +             mask =3D PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
> > +                    PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT;
> > +
> > +             if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, IMP))
> > +                     mask |=3D PSR_PAN_BIT;
> > +             if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, NMI, IMP))
> > +                     mask |=3D ALLINT_ALLINT;
> > +             /* FEAT_SPE_EXC and FEAT_TRBE_EXC also gate PSTATE.PM one=
 day... */
> > +             if (kvm_has_feat(vcpu->kvm, ID_AA64DFR1_EL1, EBEP, IMP))
> > +                     mask |=3D BIT_ULL(32);    /* PSTATE.PM */
> > +
> > +             spsr &=3D mask;
>
> [Severity: High]
> This is a pre-existing issue, but this explicit allowlist approach seems =
to
> omit several architecturally defined and KVM-supported PSTATE fields.
>
> For example, PSR_SSBS_BIT, PSR_DIT_BIT, PSR_UAO_BIT, PSR_TCO_BIT, and
> PSR_BTYPE_MASK are not included in the mask. Because spsr is masked with
> this incomplete allowlist, won't these valid bits be silently zeroed out
> instead of being preserved?
>
> When the guest takes the resulting Illegal State Exception, its SPSR_ELx
> will have lost these bits, which could corrupt the guest's architectural
> state and break guest exception handlers that rely on them.
>
> Would a denylist approach (masking out only the mode bits and EXLOCK from
> SPSR and taking them from CPSR) be safer to ensure all relevant bits are
> retained?

I don't think so, but Marc, please correct me if I'm wrong.

My reading of the ARM ARM is that these fields are UNKNOWN on an illegal
exception return, not preserved. R_VWJHB says "All of the following are
UNKNOWN" and lists PSTATE.{UAO, DIT, TCO, SSBS, BTYPE, PACM}. If that is
right, masking them to 0 is a valid realisation of UNKNOWN rather than a
loss of state, since a guest cannot rely on them surviving an illegal ERET.

Cheers,
/fuad

>
> > +             spsr |=3D cpsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
> > +             if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
> > +                     spsr |=3D cpsr & BIT_ULL(34);     /* PSTATE.EXLOC=
K */
> >               spsr |=3D PSR_IL_BIT;
> >       }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260617144907.29=
72095-1-tabba@google.com?part=3D1
