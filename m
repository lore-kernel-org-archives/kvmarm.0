Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873BB4A65FD
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 14:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881426; cv=pass; b=WyBi6tLn+y1k3s/ulHd89nw2RsrCTPilKy9Z/IsUB7JfWBznPzH+zUvEiXZOcvhIiXSIE6izGUUEXnS9lJ1Ycix/gdGJcxh41xEX0Z8tK9FPXf4hQ1pVlYe73j6u046luVSvUqH6MpvhecAxBkqQhgpKCe9Qi94cdMIimZTC+6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881426; c=relaxed/simple;
	bh=fqIKEGVdrdDwWR5GKD0/DnIsXWNq4kTzHRbVfGW+jJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TIsdEQeEdaZ++RpO/q79I3nUipnl+D2uuhiNxmOc+zIZrgOj3U+zAeAuetRZ/2XcjEPzbgfzRnbDLWf4Vx8+WrOD9PxmD3UO5DHgHuPVytWYklJUJJtfI9/qSLiWu8y6c0L/MosZZzI3+23WN/tk1ByVQCyDRBp4REPfCh02wr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qkrPrWy4; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qkrPrWy4"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ffbaaafac4so743111cf.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Jan 2026 06:10:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767881423; cv=none;
        d=google.com; s=arc-20240605;
        b=W1V387Zu8E2kZaAGVCf8lEyl0CuZu+1SnkdEIHV7f8n85mpXIuIMyjOMwuI1pG3Nod
         OTbw/6Q2EIhQYeXfxTtd53S3a2s4280vFz4UJLpn+NH799ekeRwNYlm5TmYPsNksvWmQ
         k35i+LDBLPY+H/k+0HT5+MWqA6uKB39t/dG1Y3hQJxjHIDbSMQ72zhswvfB2CT+I7qIn
         LWilngBKDXpA/Iz1sLMF+PLZGIyP8RsNDJaE+Vq5ugBtQRsF0wXdaWmkPtORQ0kICdpU
         jfwoaS7drdbWdq7bPw8prqFXYHiK8QUChNRODlcdaUODXuA36GcGQ64JuxqB376/zd0g
         PRfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NaZEGS72KLSqcxT/8N5H1mx02StcfqZHeuPXe2e7POg=;
        fh=NeR+NieSi3w31yg1WhJ2Wv4J1Hxrh3Qe3YGinC3QTTo=;
        b=ednBVe3pmksdhA0AC7Ddbp/WWvZaIzKC9Vy07ruaEeXthDpljXnhmXbIypNEn9wM3C
         koiszr/fpcvDwbHrCdCXUjIvFBPTcyJEhqwn+oVPON6AQi6Fhwv7zI+gxCpX5jkWzrcC
         smdP9r6v9u1frg4Ataom0D+w9vDqPxupM3TGbs2i4jrr8sNFXF6ZtSlJHzp1UZBMDIWY
         kqdsbZLi8UJG/JNXTFdDzseQyINpZVUCFX9BjLZLo7LeO6GD72x/uInSSVKLzBtiBVOz
         LboYx+ZAXDKluGWhU+iONRxxDjn2jH6khPyOzmyTTH7EFHtlketGEV3xETH9Nikv4aTI
         LRgQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767881423; x=1768486223; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NaZEGS72KLSqcxT/8N5H1mx02StcfqZHeuPXe2e7POg=;
        b=qkrPrWy4kZOoWqyuewOxsid3sWVKOaV8rLzcSeV+hSjJEMR5eII/62cbECnIWpWRHP
         KFnc++Hdw3yo5fs6ifLaz0DB/QnszbeF4K6VithI92DYMYPkY2XobJ8v+u/N2Z0d8RMa
         /7hpQXDpoYhe+DEXP5PbYVIfCJvJMBnrUd6hlEYJRvWtc6vbsJafuAudQJsZWdcRbM2o
         CacKw0zGsGWF/HCSOxe5xERMCeGHdivPUCDqmWPGKCmFMLfPG6f10hpnMNASS+UmQtOr
         jOHHKinIGsi6uJkf9V+B2+g1I/aHB/Dkc+tHF6VSd6eb9u3C+9vFI8jRUZdYek/6cPu/
         2uLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881423; x=1768486223;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NaZEGS72KLSqcxT/8N5H1mx02StcfqZHeuPXe2e7POg=;
        b=dkvkUI4zUvf5Rr8QZuB6w0hfxdM89a6UNB7CFKkT7se397Qf1icj89WAfY8iDqpTQe
         jCX/uLZZMLttiOirTZmHzseRAqkl4JeGoYtZK4v2FB8fOrJEQ5ddPXPWhgMmHrLsnBPF
         NqQDun0a8DHk+sq05q8HLaGSGlIRCdxsa28LPon2D31ViHKUwekwgPCZAzN7/m69xt8k
         75p/EPYRmZXU0S8jzfaWy1MFzAY4yrK+7d+gtO+IRq03hhVLnqgLrMnDFJTgWXjJv5MJ
         +cauFHlRGQ5T+b2cZzAseiLAtKkKpepJhSh3UGn8MT78mkSmydOtw9BA/sckJorh1snI
         yhsg==
X-Forwarded-Encrypted: i=1; AJvYcCVFAvypgiF+d+xds2MvZbeCiJSuCH42V6vHVHYbZ3QPB5Ar3BBkrq4G0A+1MO4f+E28Co/0tlg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzS6tkjrikdO3tWQg8WBnra4xBHCl3Iaw+m1q0frBkNmWQJIp0i
	Dhij6z4sQ7mNtDONQx0kT9mMt46efz5Ek2vw/yr3ZvesAUr4ckZqjI8iIrLtix49YBVfDcLJG/B
	f4uqVjBixOlQHlzHRrsrKxqTy2F/s+OlVyo/hpEVT
X-Gm-Gg: AY/fxX6P4y0uLT6ZjQ1qiKAW2riXasxjTWbuMIPJP2G5BXD5Ih2wikQZNUtexFbgdy4
	IBrDV3cLYOFp4gO8dJezepWPCpzr5iHnbUIAr08sMqkqCWkx6vbuHimIMgcDAPgy3mtoYoEagLw
	vu5wG+SYNIki4jFLfP53KTS3bghY1y6jqmsUaSo0s77WtwP64AmDbk8A1ZuMS17AgCyykBjZqQm
	Z2cSMUs2PQg3CjTcPeBzLTh0wUNW0W3/J0XDKYp1scY+QZ7Y069pv9/QEpvbpTdQI6ah1uk
X-Received: by 2002:ac8:574f:0:b0:4f1:9c6e:cf1c with SMTP id
 d75a77b69052e-4ffc0997e9emr8640981cf.17.1767881422911; Thu, 08 Jan 2026
 06:10:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-7-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-7-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 8 Jan 2026 14:09:46 +0000
X-Gm-Features: AQt7F2pJrrFIu8j-RnjtZsOw-SyaBAdPJA09Q8QxhF8SmvfGBU7bWTwW9oJJhUU
Message-ID: <CA+EHjTzTjaZoGQzivOSd97Z9VzySOAM=Qvye0p-R5rzUDwrSFw@mail.gmail.com>
Subject: Re: [PATCH v9 07/30] KVM: arm64: Pull ctxt_has_ helpers to start of sysreg-sr.h
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
> Rather than add earlier prototypes of specific ctxt_has_ helpers let's just
> pull all their definitions to the top of sysreg-sr.h so they're all
> available to all the individual save/restore functions.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 84 +++++++++++++++---------------
>  1 file changed, 41 insertions(+), 43 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index a17cbe7582de..5624fd705ae3 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -16,8 +16,6 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>
> -static inline bool ctxt_has_s1poe(struct kvm_cpu_context *ctxt);
> -
>  static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
>  {
>         struct kvm_vcpu *vcpu = ctxt->__hyp_running_vcpu;
> @@ -28,47 +26,6 @@ static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
>         return vcpu;
>  }
>
> -static inline bool ctxt_is_guest(struct kvm_cpu_context *ctxt)
> -{
> -       return host_data_ptr(host_ctxt) != ctxt;
> -}
> -
> -static inline u64 *ctxt_mdscr_el1(struct kvm_cpu_context *ctxt)
> -{
> -       struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
> -
> -       if (ctxt_is_guest(ctxt) && kvm_host_owns_debug_regs(vcpu))
> -               return &vcpu->arch.external_mdscr_el1;
> -
> -       return &ctxt_sys_reg(ctxt, MDSCR_EL1);
> -}
> -
> -static inline u64 ctxt_midr_el1(struct kvm_cpu_context *ctxt)
> -{
> -       struct kvm *kvm = kern_hyp_va(ctxt_to_vcpu(ctxt)->kvm);
> -
> -       if (!(ctxt_is_guest(ctxt) &&
> -             test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &kvm->arch.flags)))
> -               return read_cpuid_id();
> -
> -       return kvm_read_vm_id_reg(kvm, SYS_MIDR_EL1);
> -}
> -
> -static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
> -{
> -       *ctxt_mdscr_el1(ctxt)   = read_sysreg(mdscr_el1);
> -
> -       // POR_EL0 can affect uaccess, so must be saved/restored early.
> -       if (ctxt_has_s1poe(ctxt))
> -               ctxt_sys_reg(ctxt, POR_EL0)     = read_sysreg_s(SYS_POR_EL0);
> -}
> -
> -static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
> -{
> -       ctxt_sys_reg(ctxt, TPIDR_EL0)   = read_sysreg(tpidr_el0);
> -       ctxt_sys_reg(ctxt, TPIDRRO_EL0) = read_sysreg(tpidrro_el0);
> -}
> -
>  static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
>  {
>         struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
> @@ -131,6 +88,47 @@ static inline bool ctxt_has_sctlr2(struct kvm_cpu_context *ctxt)
>         return kvm_has_sctlr2(kern_hyp_va(vcpu->kvm));
>  }
>
> +static inline bool ctxt_is_guest(struct kvm_cpu_context *ctxt)
> +{
> +       return host_data_ptr(host_ctxt) != ctxt;
> +}
> +
> +static inline u64 *ctxt_mdscr_el1(struct kvm_cpu_context *ctxt)
> +{
> +       struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
> +
> +       if (ctxt_is_guest(ctxt) && kvm_host_owns_debug_regs(vcpu))
> +               return &vcpu->arch.external_mdscr_el1;
> +
> +       return &ctxt_sys_reg(ctxt, MDSCR_EL1);
> +}
> +
> +static inline u64 ctxt_midr_el1(struct kvm_cpu_context *ctxt)
> +{
> +       struct kvm *kvm = kern_hyp_va(ctxt_to_vcpu(ctxt)->kvm);
> +
> +       if (!(ctxt_is_guest(ctxt) &&
> +             test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &kvm->arch.flags)))
> +               return read_cpuid_id();
> +
> +       return kvm_read_vm_id_reg(kvm, SYS_MIDR_EL1);
> +}
> +
> +static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
> +{
> +       *ctxt_mdscr_el1(ctxt)   = read_sysreg(mdscr_el1);
> +
> +       // POR_EL0 can affect uaccess, so must be saved/restored early.
> +       if (ctxt_has_s1poe(ctxt))
> +               ctxt_sys_reg(ctxt, POR_EL0)     = read_sysreg_s(SYS_POR_EL0);
> +}
> +
> +static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
> +{
> +       ctxt_sys_reg(ctxt, TPIDR_EL0)   = read_sysreg(tpidr_el0);
> +       ctxt_sys_reg(ctxt, TPIDRRO_EL0) = read_sysreg(tpidrro_el0);
> +}
> +
>  static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  {
>         ctxt_sys_reg(ctxt, SCTLR_EL1)   = read_sysreg_el1(SYS_SCTLR);
>
> --
> 2.47.3
>
