Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46281C84B8
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 15:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754409143; cv=none; b=gA/esad0O/CR74IR9gVNLn3IVwwp5S2JBhkMomLQ9suZkgWuSxGyeSUPAu+P2rrX40jxYjrQ8m9qr0fs8bG6fWEcdkomJrmcNCuktsxCV0YYz0EPfVvjR5t2XQirsAlE7Z/pLrIHgDBixlcmAoOHzvm7D+cFV5CjTd0mqNNpNaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754409143; c=relaxed/simple;
	bh=fyO4reQXeGKhGsr7Y56nGjeCrWj+hWNl/mSVcQpg+Kc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nmK2qJTRTTh4mSrMOttmLDUSO0N9jUxoUohRHeoT28zcvH1KVXUnYC6vqelwdrNaiRFNJnYGiiATp0iLeSjMuNqDA219mMda0r1BEv59E5zoJR+fXQNjtE/oU9s707UWvAs0H5VF9YIWYEotm9ev5NnmSk+f1s5KtwK0rjbRaoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=15PHGB0t; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="15PHGB0t"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso320041cf.1
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 08:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754409141; x=1755013941; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tjX1yDKhoAMYocT3xj/0AsKA7BcblHg4H+9czODs6Ds=;
        b=15PHGB0tAXw9z7kZ3t4RJSenAlBh9GlvCIva0kV+1uK6+4cvTj+B3qmeyA6LKc1UBJ
         9V6yPpmFLM/SywF0l+fSFiAxh+R1w3z4A/4bgVwBCO3aXoY+kgz5ss1iRBHLOZGklGf3
         A15My18GRv+3XgaEn1hS5nsa53L5C0sCPiu3YEGgdB2YHjuXwEh+OmVm994x7tnhBDYh
         06/ldJRBLAHyPkWme8AXBehEyhJE8S31/KWkyr5d/U9msAJu0PQLj++SbWSON42TsHFV
         dOlnATCGPdyu59ZxkyPtsN+r2h43WYhPEhFGOn2hGjxcMrseBqVZpWvEV4N5w/ec1B88
         V8bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754409141; x=1755013941;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tjX1yDKhoAMYocT3xj/0AsKA7BcblHg4H+9czODs6Ds=;
        b=S5HN0yjkpvaYxD5hReQKVbaWLXUg8qeRRfCfAXKU7I2JSPcMFIM+WixxDJD3/+zu3y
         YMWFnpSzxsYbwmm81sqB4h3Pd5tZ0Ich6HodDKYQFgo8ZPHbWyG29tq37X7P5CVjVra7
         MXerhZaiJNKKlgslaH8yvDEWDatv60iPIQxpt2x6aorZHlWDCW4M3hkqPO87OndPRjRl
         MLjdxX6R8YfUSa2uA5QY+rjIeqsF03ZkAjs6GafXGfNEgTPT/9iHu4CHpGSw6xAVGRDT
         ZKoSmjqZwaWbCSfcVO4JINmdzeEHNRtrv6WxmQyHUOPYq02DvSKTXDwUJuHECSfvUZbd
         xKyQ==
X-Gm-Message-State: AOJu0YzookU+WOjz/edg9Aw/OymQoLmJ57BhX25wkEk1yhwqe98/9MMC
	rbpsWY9CyhQ5LqtaNdAd3kXgg7urXtTWUv79Va0FtZmArtJrH5zU+uHSUgWMFNXix87dfCtLTB8
	epwn42e9G5zuXZpkdM9Pm7R0jDGU7eLYwZQBTq2IudY9CKrZOYYP2/Ji+
X-Gm-Gg: ASbGncvDaXPiy3fA+FhCBWjS6QGPkSZyX6kFgWs7kUkvrWCL5MX7GEUZ0yFK8f90EVq
	kFgb8hN9cceGm8F7x6kCvCiH1EwCoYm5luqCSaULj8hxPXOu2g2Ca8k0ShpDia1BzR0biy/QQ2i
	tE/XIa5fKOqLsggdswnEPcwnL/LIoftTKB0X5Mrib7xqUT1m0IhoF2l22lIN5InTg1tMMohAVNU
	lTF+PXU
X-Google-Smtp-Source: AGHT+IGbRK8JECKTHipEp5ScNvysVry8hhcYGrLgedBJ1sNn4eetXEItpZTcRmxnSLaIkN5bfay/z2pwDKVSvv1QGc4=
X-Received: by 2002:ac8:5fd6:0:b0:4b0:8318:a95 with SMTP id
 d75a77b69052e-4b084f118f8mr4295551cf.8.1754409140243; Tue, 05 Aug 2025
 08:52:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250805135617.831971-1-tabba@google.com> <20250805135617.831971-3-tabba@google.com>
 <aJIXerl04PDah1db@willie-the-truck>
In-Reply-To: <aJIXerl04PDah1db@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 5 Aug 2025 16:51:43 +0100
X-Gm-Features: Ac12FXyK_iYmZ8yIpjR9FKi_Zz057gBdcMrKioHmqRePthAo7QCB0owev24d6vs
Message-ID: <CA+EHjTwaz=TnTJRxZmmCNY7bJyNrmXtPdEUW65en4=khcL_aag@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Will,

On Tue, 5 Aug 2025 at 15:39, Will Deacon <will@kernel.org> wrote:
>
> On Tue, Aug 05, 2025 at 02:56:15PM +0100, Fuad Tabba wrote:
> > Allow vcpu_{read,write}_sys_reg() to be called from EL2. This makes it
> > possible for hyp to use existing helper functions to access the vCPU
> > context.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_emulate.h | 184 +++++++++++++++++++++++++++
> >  arch/arm64/include/asm/kvm_host.h    |   3 -
> >  arch/arm64/kvm/sys_regs.c            | 184 ---------------------------
> >  3 files changed, 184 insertions(+), 187 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index 0720898f563e..1f449ef4564c 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -224,6 +224,190 @@ static inline bool vcpu_is_host_el0(const struct kvm_vcpu *vcpu)
> >       return is_hyp_ctxt(vcpu) && !vcpu_is_el2(vcpu);
> >  }
> >
> > +#define PURE_EL2_SYSREG(el2)                                         \
> > +     case el2: {                                                     \
> > +             *el1r = el2;                                            \
> > +             return true;                                            \
> > +     }
> > +
> > +#define MAPPED_EL2_SYSREG(el2, el1, fn)                                      \
> > +     case el2: {                                                     \
> > +             *xlate = fn;                                            \
> > +             *el1r = el1;                                            \
> > +             return true;                                            \
> > +     }
> > +
> > +static bool get_el2_to_el1_mapping(unsigned int reg,
> > +                                unsigned int *el1r, u64 (**xlate)(u64))
> > +{
>
> I guess this needs to be 'inline' too, but...
>
> > +static inline u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> > +{
> > +     u64 val = 0x8badf00d8badf00d;
> > +     u64 (*xlate)(u64) = NULL;
> > +     unsigned int el1r;
> > +
> > +     if (!vcpu_get_flag(vcpu, SYSREGS_ON_CPU))
> > +             goto memory_read;
> > +
> > +     if (unlikely(get_el2_to_el1_mapping(reg, &el1r, &xlate))) {
> > +             if (!is_hyp_ctxt(vcpu))
> > +                     goto memory_read;
> > +
> > +             /*
> > +              * CNTHCTL_EL2 requires some special treatment to
> > +              * account for the bits that can be set via CNTKCTL_EL1.
> > +              */
> > +             switch (reg) {
> > +             case CNTHCTL_EL2:
> > +                     if (vcpu_el2_e2h_is_set(vcpu)) {
> > +                             val = read_sysreg_el1(SYS_CNTKCTL);
> > +                             val &= CNTKCTL_VALID_BITS;
> > +                             val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
> > +                             return val;
> > +                     }
> > +                     break;
> > +             }
> > +
> > +             /*
> > +              * If this register does not have an EL1 counterpart,
> > +              * then read the stored EL2 version.
> > +              */
> > +             if (reg == el1r)
> > +                     goto memory_read;
> > +
> > +             /*
> > +              * If we have a non-VHE guest and that the sysreg
> > +              * requires translation to be used at EL1, use the
> > +              * in-memory copy instead.
> > +              */
> > +             if (!vcpu_el2_e2h_is_set(vcpu) && xlate)
> > +                     goto memory_read;
> > +
> > +             /* Get the current version of the EL1 counterpart. */
> > +             WARN_ON(!__vcpu_read_sys_reg_from_cpu(el1r, &val));
> > +             if (reg >= __SANITISED_REG_START__)
> > +                     val = kvm_vcpu_apply_reg_masks(vcpu, reg, val);
> > +
> > +             return val;
> > +     }
> > +
> > +     /* EL1 register can't be on the CPU if the guest is in vEL2. */
> > +     if (unlikely(is_hyp_ctxt(vcpu)))
> > +             goto memory_read;
> > +
> > +     if (__vcpu_read_sys_reg_from_cpu(reg, &val))
> > +             return val;
> > +
> > +memory_read:
> > +     return __vcpu_sys_reg(vcpu, reg);
> > +}
>
> ... isn't this now pretty huge to be inlining? Similarly for the write
> accessor. What does the bloat-o-meter script say?

In terms of the bloat-o-meter script:

add/remove: 4/4 grow/shrink: 27/5 up/down: 16720/-108 (16612)
Function                                     old     new   delta
vcpu_read_sys_reg                            648    4132   +3484
__vcpu_read_sys_reg_from_cpu                 428    2112   +1684
vcpu_write_sys_reg                           672    2016   +1344
get_el2_to_el1_mapping                       404    1616   +1212
is_hyp_ctxt                                  216    1256   +1040
__vcpu_write_sys_reg_to_cpu                  420    1232    +812
vcpu_el2_e2h_is_set                          296    1032    +736
...
Total: Before=33050106, After=33066718, chg +0.05%

Looking more carefully at the code, I should be using __vcpu_sys_reg()
and __vcpu_assign_sys_reg() directly, since we're !VHE. I'll fix it
when I respin.

Thanks!
/fuad

> Will
>
