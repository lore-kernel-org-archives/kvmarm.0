Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED06018C3B
	for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 07:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716190681; cv=none; b=u6Ub4urGOZyOsbOVmQ+WOtwjdLIHDc4c6Fft/Oc8MBeLBx4+eScd2xV5mbN/sLAX7CFtG3L03UNsgT2+72QYc1zwAFGuNM7qfLS9GY0+/Krsb7xsqFIb/W3fXgqtMagur11dxgwlOi7KpQ9Aw0rcpt0Fq4K0YvkiODAPViXKmgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716190681; c=relaxed/simple;
	bh=V5A/Stqxx5SmPfAL8KCN7A4Vx0ha5JvoKhN+C7xbwhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QHsZ2MIefT9ALNxcjoJtT0Of0cvGUo13siw5Gt/S1GTo/tibppj94hFeGS4OYIHPScWtABQyIqWFDriI1VrKTltUk1a79aATFgdrs8CRZ+xV2aKic9YybyDYcPIPM4p/AmEk2H7278/3L6lADERueZ+n1c6ee+YDevKN71HWiIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U2LSsUDo; arc=none smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U2LSsUDo"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-47efcb120feso670617137.2
        for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 00:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716190679; x=1716795479; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAaPqsbFB3cEk+dorNmrtyA00NR6oa0FuU6jLgjXxqo=;
        b=U2LSsUDoPZufhhYP0X44Un4to4tyJVEVgyQYYKn+SvpdTqmjDrGwCl/0aGUDx922/t
         XExesQ2uBtgiowGu2vxmDGzTpJWmvV1OxHxsR4i+SatAIFCPJXfk5zwejWqKLr+bdnjl
         nFrGimbtVmcGVfFaAXKtoQjiLoB5iZCQH0q7vL12Mk1SdMbU1i5I9r+t7Ln20+GXUQBV
         XKk8nbxuOQ3psTuS7LUQ9T16BTpRPWYIrq3F+0y3h1c/08IAf6cIiB2u+NacTLFTdl5B
         ++COMkNeyuoPSS21q7vnCrDNsCHz+keZDdNOGMBKTNNipFm32I6O2fKbx2erKD7rpvqg
         2e6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716190679; x=1716795479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uAaPqsbFB3cEk+dorNmrtyA00NR6oa0FuU6jLgjXxqo=;
        b=Z6RITAq9jDjXOvDfB+ZOGLrHFPY8fU4D3DuO8LmzL6Am9wBdmY7qDT3Zieavh6eSPF
         DmDCve5qSK4XKSVha4AVxX+Jw/5Q1WHWKPfSI7THgXMEE+0wfigCzeFnbU4nysylqylM
         a/YS6MY2krlhtZ6oaHcs5u9aOqF4pg+irwz4cmYAzsnzYgKZw/QeYSEgA1TBgLBGuL48
         nfyqlQ/LfW1jrvW/aEz6dflgd0S032sKWwssDBTCN4mNfjTxQg1g5zI21mRQIJFnFLR3
         GuMJn7z9YTs2DI+gvUQnlgg49feDcsyf1aEHc0Oad+iQExeTcoD9zFqpC0gGcigwwFhY
         EnGw==
X-Gm-Message-State: AOJu0YzKbGr6KWb+CVqtJMhxa4xxYQ4HdWjCfyDMxmV2jkxZZdbfgMBv
	E1QJWxwL1cIN8cQfLqhBMaCDmDGkCj2NLHB1lTqUqThDkes/jI+BNdpEoCCjqASBsMLReu/ciqg
	Hb3E4fYTdfP/msK8NXR1SGGFJqRAX1USonOfR
X-Google-Smtp-Source: AGHT+IFANiOoU3VgSpxbJalxn/jMn+9sfF7tUA+mHcBYG2p2mCcRTtJvvkgnQf44zle6S+iO3AU3Ek7SpwGH3Qri/2w=
X-Received: by 2002:a05:6102:3f8b:b0:47e:f109:ea33 with SMTP id
 ada2fe7eead31-48162f9981amr31141230137.19.1716190678644; Mon, 20 May 2024
 00:37:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240517131814.719933-1-tabba@google.com> <20240517131814.719933-7-tabba@google.com>
 <ZkePS5jU6yEv6Nhp@linux.dev>
In-Reply-To: <ZkePS5jU6yEv6Nhp@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 20 May 2024 08:37:22 +0100
Message-ID: <CA+EHjTzFkNiPzH47Y52cEPd+LzNSAmGHD45C0o8p2ejB6LKHKQ@mail.gmail.com>
Subject: Re: [PATCH v1 6/7] KVM: arm64: Eagerly restore host fpsimd/sve state
 in pKVM
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, 
	broonie@kernel.org, joey.gouly@arm.com, rananta@google.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Fri, May 17, 2024 at 6:09=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Fuad,
>
> On Fri, May 17, 2024 at 02:18:13PM +0100, Fuad Tabba wrote:
> >  static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
> >  {
> > -     __fpsimd_save_state(*host_data_ptr(fpsimd_state));
> > +     /*
> > +      * Non-protected kvm relies on the host restoring its sve state.
> > +      * Protected kvm restores the host's sve state as not to reveal t=
hat
> > +      * fpsimd was used by a guest nor leak upper sve bits.
> > +      */
> > +     if (unlikely(is_protected_kvm_enabled() && system_supports_sve())=
) {
> > +             __hyp_sve_save_host();
> > +
> > +             /* Re-enable SVE traps for guests that do not support it.=
 */
> > +             if (!vcpu_has_sve(vcpu))
> > +                     sysreg_clear_set(cptr_el2, 0, CPTR_EL2_TZ);
>
> This doesn't account for hVHE. I wonder we'd be better off abstracting
> CPTR_EL2 behind a helper wherever it gets used in nVHE and translate
> into the VHE-format behind the scenes:

Right! Too many modes to keep track of :)

Abstracting cptr_el2 would make things clearer and less error-prone.
I'll do that on the respin.

Cheers,
/fuad

>
> static inline void __cptr_clear_set_hvhe(u64 cptr_clr, u64 cptr_set)
> {
>         u64 clr =3D 0, set =3D 0;
>
>         if (cptr_clr & CPTR_EL2_TFP)
>                 set |=3D CPACR_ELx_FPEN;
>         if (cptr_clr & CPTR_EL2_TZ)
>                 set |=3D CPACR_ELx_ZEN;
>         if (cptr_clr & CPTR_EL2_TSM)
>                 set |=3D CPACR_ELx_SMEN;
>
>         if (cptr_set & CPTR_EL2_TFP)
>                 clr |=3D CPACR_ELx_FPEN;
>         if (cptr_set & CPTR_EL2_TZ)
>                 clr |=3D CPACR_ELx_ZEN;
>         if (cptr_set & CPTR_EL2_TSM)
>                 clr |=3D CPACR_ELx_SMEN;
>
>         sysreg_clear_set(cpacr_el1, clr, set);
> }
>
> static inline void cptr_clear_set(u64 clr, u64 set)
> {
>         if (has_hvhe())
>                 __cptr_clear_set_hvhe(clr, set);
>         else
>                 sysreg_clear_set(cptr_el2, clr, set);
> }
>
> --
> Thanks,
> Oliver
