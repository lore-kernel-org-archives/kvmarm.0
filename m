Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A0E35BDB1
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767977854; cv=pass; b=bnBxhmxlJU5rY/0D0o6o+gRNAszbxjZHVDpBh3L7qlieRbFUKlFJrujFNi5Sl9AW8onMF+e0mQ8pUQjxIr+2Sx3y+oAmz7xAf/1IOs2XMbTIeQfBPbMLj/iqfVi4tfois5SanWoBqahbIBJQKcuEs8jjoN3T0Z/pJiv+CfASdWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767977854; c=relaxed/simple;
	bh=SkjHGF8FR8F2ZPGg4e/H1IK+TJO92/b+hbarPM46pt4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kgpgr6G8KY8CBoF7H3bkFVg4ha7ofE6AAgGiw29k8A7ruq6vWeuuOiNbR7AZcGT2aGgdzcPl4v7gJjr8g75fgzMVa9+ukCDjqj/PqSa17EytgHFBExHq4dkTrLNFZHCDsmXXojQbWvNlCwAQjwMTxhQ9zzKu/lnpqYONI/s2MWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gmQUJ8q8; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gmQUJ8q8"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee147baf7bso486591cf.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 08:57:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767977851; cv=none;
        d=google.com; s=arc-20240605;
        b=WEKZtaNyfABLOP24ezoTZSpEVrtBbzuttFQJ9EMRyG7iT/bNyw/FyUlfuW6iDeRr4Q
         D8e6CWhEG9PFDYBGrfA+Ixyi9i1G0iyJ34farlQMye9u64GjGNc7Gpc4hchG1cD/6Uzb
         cpG6oDblp0IA1c3cxB4zZQg4ZdpnlTnUDXJi2u/0ek5J1lWNTP1H5OK4djSlH2Cdz3x7
         RNNUWwv0SpoOtEYSjCdnsuLgmHkPhn2aIfIVuT4lBJzNI09+nkFxztcZRH//+3H8dzwL
         +AmWLgEEf+Icf/VeR5zvqwkUFXSll4WFM3F9zIU9Fc/xBwAGlhaFSVwCZ+GZrpVk2tWN
         HPIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=MpztCWy9ipsSXHs0mL6YjlVmfult44YS26X504J/dJw=;
        fh=/lJP2AppFnZOsZXGKSLXZuV+6uVTVD6sjpqq0xrS8x0=;
        b=bjboe5ixdR+Dy9e3Kk/aVyFqufnwM1y8OVFlYwh2wkbPWsa02r4UlNutcKQ+o1tUqv
         qDHuh6o9pfnr6qXdccOIq4NevLipcVjtMd0xqYpeMC+TD6OnmjCSQyFayii1nAwiE5w8
         wxd6bMYjcYkBu4TAcuHHHXesSrz8wm+le+FX5iAInC2IDLfIyv8jh80NENEGEe9/JN7R
         SWCdGxiHqJmPKeE8v+IvmMVAcLqKAmnli+BAO2pkWRQb0XiX+J86jw7Sgwh4nleEhO2q
         MAFHLGEW2FqXo94jeITDDCylPECdQ3ATtEF03H04BMd51A+UaHnAzrm6C7/slvGji4mV
         Z3RQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767977851; x=1768582651; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MpztCWy9ipsSXHs0mL6YjlVmfult44YS26X504J/dJw=;
        b=gmQUJ8q8oSpEU0teKrA810vXDxSL6sKzPt+qHMRuOvahgAMd0+70BKFlsyNhSziDjm
         TGsfWhi+MDhH4kHkNtE+fv9VeVistme5ojg3RMkpmSdLnSxJ5b1ab54L8PFZqYopoj1O
         mGoWFAwoXpObql9YFdphb9++psrfQ8ylfhV2WMiQ7NwXqbc6xo5NelrGFKMebF/cfKHW
         rTZ6E/UkobxG9b//G6l4dsYpYckm6l0626NlGK/RlGUws17eV1KsxW+vmAe12PKB7NTo
         30agLNKULdU/1fHLegZy1blvLpqU3Zl8pmBIB5BIuetgceh6tAr8OyVWv4Y+KPQKPpqI
         XVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767977851; x=1768582651;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpztCWy9ipsSXHs0mL6YjlVmfult44YS26X504J/dJw=;
        b=mQvKgkvnrUQRvX+AYpI32j482ol+uv9QdRdLorHsj+Ag0hDl2b60Ii9jlPO7bK+XeI
         IVaZ9GJJOr5I1HlHeEZttHP9nbi8A27mGdID47fg/mVOFvwHgOEQTTfD00c5w+j73nSn
         vytX3dm56A+802jq3pcFngayVwSKNjdmUWmj3wVI0aSHr9KRziFKR1RqidhDkcXq1hx6
         d6WldV0s08EDcQ+cZJ5ebSw6EREXcnt7XNFvb3KniRAddW6+cN7lq5uC9pmEsWZsmLdE
         rry5XAKpHSV62tXycY3sEl65qa04Iw2bZaigJfHTzf04V0GMfYoWuMlVLGU3gfedB9Kj
         /pYA==
X-Forwarded-Encrypted: i=1; AJvYcCWaDad5lxa7fb++lbO0DhZzRXJKoc+t9FB2kWuWOjP/AdGVS10PqRWuCi9BPQdjpzKK/zQOSJE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy82vwQ8zGJHIQcLOIe/ZKmnbkq9dDsCGwjmPcUvHDFHlj7+YaP
	hYo0OJA5obbK79c3+h4Ay+DHvGuBojz76VcwoH4suINiES4UqNemrqNWXI1xMQ9JeIVkeEjpHwk
	xQkV5eq84WmC72xi4DofeqHbjwBSicFCgd17Uk8P6
X-Gm-Gg: AY/fxX4F+76Rq5VO+4SF6W+YXpi5z3SllGZ3qONoDgnWukAHZvg53Cfg35TsmCpnhmB
	o/qwIdN+THhJIp5cEkGRZSXZpV8W3jrnnlCqPsEKojjF8M/uQQI7VeL3o/OGpZ9SYwx7FGt3RCf
	ioegKvfVa44wcjNaCtQ7/krA5uPhMepLnO195H/zppN0imFct0EXGmJq5JtqiiWfdFmTcyAEGD6
	HmXTSSU9WVZknIZgWO4fvb8AgGlZZMGiZ0WUf2TUbfu1hziQ3QVWSb3XV+qBZeMqKYIk/5p
X-Received: by 2002:a05:622a:198e:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-4ffca38a667mr12955411cf.14.1767977851098; Fri, 09 Jan 2026
 08:57:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-16-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-16-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 9 Jan 2026 16:57:00 +0000
X-Gm-Features: AZwV_QiwST85CNc25KZYMBDJwxaQzBlftzyvIde5n_9dAYz2SEbvmx43n1faTzI
Message-ID: <CA+EHjTwTmjNEV+4w8w=LXfR0g_v7yHk1pQD+Oos8V3vFfEVdMw@mail.gmail.com>
Subject: Re: [PATCH v9 16/30] KVM: arm64: Support TPIDR2_EL0
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> SME adds a new thread ID register, TPIDR2_EL0. This is used in userspace
> for delayed saving of the ZA state but in terms of the architecture is
> not really connected to SME other than being part of FEAT_SME. It has an
> independent fine grained trap and the runtime connection with the rest
> of SME is purely software defined.
>
> Expose the register as a system register if the guest supports SME,
> context switching it along with the other EL0 TPIDRs.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/include/asm/kvm_host.h          |  1 +
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 15 +++++++++++++++
>  arch/arm64/kvm/sys_regs.c                  |  3 ++-
>  3 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f24441244a68..825b74f752d6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -448,6 +448,7 @@ enum vcpu_sysreg {
>         CSSELR_EL1,     /* Cache Size Selection Register */
>         TPIDR_EL0,      /* Thread ID, User R/W */
>         TPIDRRO_EL0,    /* Thread ID, User R/O */
> +       TPIDR2_EL0,     /* Thread ID, Register 2 */
>         TPIDR_EL1,      /* Thread ID, Privileged */
>         CNTKCTL_EL1,    /* Timer Control Register (EL1) */
>         PAR_EL1,        /* Physical Address Register */
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index 5624fd705ae3..8c3b3d6df99f 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -88,6 +88,17 @@ static inline bool ctxt_has_sctlr2(struct kvm_cpu_context *ctxt)
>         return kvm_has_sctlr2(kern_hyp_va(vcpu->kvm));
>  }
>
> +static inline bool ctxt_has_sme(struct kvm_cpu_context *ctxt)
> +{
> +       struct kvm_vcpu *vcpu;
> +
> +       if (!system_supports_sme())
> +               return false;
> +
> +       vcpu = ctxt_to_vcpu(ctxt);
> +       return kvm_has_sme(kern_hyp_va(vcpu->kvm));
> +}
> +
>  static inline bool ctxt_is_guest(struct kvm_cpu_context *ctxt)
>  {
>         return host_data_ptr(host_ctxt) != ctxt;
> @@ -127,6 +138,8 @@ static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
>  {
>         ctxt_sys_reg(ctxt, TPIDR_EL0)   = read_sysreg(tpidr_el0);
>         ctxt_sys_reg(ctxt, TPIDRRO_EL0) = read_sysreg(tpidrro_el0);
> +       if (ctxt_has_sme(ctxt))
> +               ctxt_sys_reg(ctxt, TPIDR2_EL0)  = read_sysreg_s(SYS_TPIDR2_EL0);
>  }
>
>  static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
> @@ -204,6 +217,8 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
>  {
>         write_sysreg(ctxt_sys_reg(ctxt, TPIDR_EL0),     tpidr_el0);
>         write_sysreg(ctxt_sys_reg(ctxt, TPIDRRO_EL0),   tpidrro_el0);
> +       if (ctxt_has_sme(ctxt))
> +               write_sysreg_s(ctxt_sys_reg(ctxt, TPIDR2_EL0), SYS_TPIDR2_EL0);
>  }
>
>  static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5c912139d264..7e550f045f4d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3504,7 +3504,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>           .visibility = s1poe_visibility },
>         { SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
>         { SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
> -       { SYS_DESC(SYS_TPIDR2_EL0), undef_access },
> +       { SYS_DESC(SYS_TPIDR2_EL0), NULL, reset_unknown, TPIDR2_EL0,
> +         .visibility = sme_visibility},
>
>         { SYS_DESC(SYS_SCXTNUM_EL0), undef_access },
>
>
> --
> 2.47.3
>
