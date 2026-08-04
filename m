Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568A53EC81F
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 08:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785830576; cv=none; b=StpOtjxP9Khp3W45wjdiZZMfZEZwTMTk61J3PocKO1cJQzKzdVubUnjcvIwRXIPy8S7Je2ms/a/yqp+SdQC5qUbWBSnhqHxNrzJ5BoV+vKniWaNywlbdAdbW6EgUD13fUTnOz17qxeEyYObTcSq3j5cnFYxhVgrdTGclu/waGpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785830576; c=relaxed/simple;
	bh=EQwpD9w+Fp8H0yPzgecdz37R/SGJuffqN5H/3wFsO+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=usJw+Nr1B2N/aPJ30ZRJxAAvWr5IaPmGxDNC+41zUBtgu/o+emQ9QuEbh35mv24g5SHAST+1ZnHEB0VJBHcF0EK160g9f8HmIf1AgyFSPNgKoIM6dg0+azpX2k9bwCr+eT0TOeDOa2rPGKhmEqxeofJhzrHDd9OlR8vz48+rXXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jv6986fS; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jv6986fS"
X-Forwarded-Encrypted: i=1; AHgh+Rou8SnToCvK1qrVAQB8lq8OcPoW9BJsSvig13Qx4DB4PF0E5ocezd1epwAyZeWSPqkE/LREGHQ=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785830570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DOqewZ17+UXgtO2g1c37YHAxSsuB+qHLrfqx0/I97UQ=;
	b=jv6986fSoYYNYQsjyBVrl2fpccEva3F1Qjc+1CFXb5LnMyfxQdHLHZFgjufPP8NfvMlB3X
	+poMhxX5J5BmTEViSGlAUz8YMfsJHjMqTQDTMB5q8mW8ZqWk24+HhXUYY3yk4XDSKScBli
	yMVBbadK+gF5HuI1GZ88ECBIAt4acx4=
X-Gm-Message-State: AOJu0YyW0xkUxtTm1W/TzvH1BfNCUmksGpaa+NNlphuQcqEt84lYc4b1
	fu6aNFfAIDOfpMhZREpQ8es8yQ99qGlf2bNnmrOLowfuzn6hoNvfSizBov7Iqn/15m7ouzhf1r3
	11QHDLb1agUXR5IUQL2bpM6+uuC6n9EqVyvGDelMq
X-Received: by 2002:a05:622a:858c:b0:52b:4ec6:52ba with SMTP id
 d75a77b69052e-52cd4e7f28dmr9889511cf.6.1785830543921; Tue, 04 Aug 2026
 01:02:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260803-kvm-arm64-idreg-final-v2-0-d7d7e4efc640@kernel.org>
 <20260803-kvm-arm64-idreg-final-v2-1-d7d7e4efc640@kernel.org> <20260803231200.D62F81F000E9@smtp.kernel.org>
In-Reply-To: <20260803231200.D62F81F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 4 Aug 2026 09:01:47 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwm7DkwV=TNmA6dKmu3mxrO-C4qsX-FZjfpY-iA3fF1=w@mail.gmail.com>
X-Gm-Features: AUfX_mzyHcsb7KkkOIEpAmtex-UJ_yU5dFw1NywMOAKwqdmBPASMUkpyECWVU14
Message-ID: <CA+EHjTwm7DkwV=TNmA6dKmu3mxrO-C4qsX-FZjfpY-iA3fF1=w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Finalize guest-wide sysregs prior to
 per-vCPU sysregs
To: sashiko-reviews@lists.linux.dev
Cc: Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Tue, 4 Aug 2026 at 00:13, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Numeric range comparison over sparse `enum vcpu_sysreg` covers u=
nintended registers.

False positive. The gaps are real, but the loop body is a
value-preserving no-op on them and stays in bounds, so there is
nothing to touch.

/fuad
> --
>
> --- Patch [1]: [PATCH v2 1/2] KVM: arm64: Finalize guest-wide sysregs pri=
or to per-vCPU sysregs ---
> commit d51df44c26211dddcc71c5fe7798bb6cbbc7e67e
> Author: Mark Brown <broonie@kernel.org>
>
> KVM: arm64: Finalize guest-wide sysregs prior to per-vCPU sysregs
>
> This commit splits the sysreg initialization into a per-VM and a per-vCPU
> function to ensure that guest-wide settings are finalized before per-vCPU
> NV initialization runs.
>
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 5d5c579d45790..958d7ef78785f 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> [ ... ]
> > @@ -5825,6 +5814,29 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
> [ ... ]
> > +int kvm_vcpu_finalize_sys_regs(struct kvm_vcpu *vcpu)
> > +{
> [ ... ]
> > +     if (vcpu_has_nv(vcpu)) {
> > +             ret =3D kvm_init_nv_sysregs(vcpu);
>
> [Severity: High]
> This isn't a bug introduced by this patch, but does the initialization in
> kvm_init_nv_sysregs() touch unintended registers by iterating over the
> sparse vcpu_sysreg enumeration?
>
> Looking at the loop at the end of kvm_init_nv_sysregs() in
> arch/arm64/kvm/nested.c:
>
>     for (enum vcpu_sysreg sr =3D __SANITISED_REG_START__; sr < NR_SYS_REG=
S; sr++)
>         __vcpu_rmw_sys_reg(vcpu, sr, |=3D, 0);
>
> Because VNCR-mapped entries are numbered by their VNCR-page byte offset
> rather than declaration order, iterating using a numeric range comparison
> over the enum covers unassigned gaps and other registers that happen to f=
all
> in that byte span.
>
> Could this loop inadvertently corrupt or desync guest state by treating
> offsets as sequential enum entries?
>
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     return 0;
> > +}
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803-kvm-arm6=
4-idreg-final-v2-0-d7d7e4efc640@kernel.org?part=3D1
>
