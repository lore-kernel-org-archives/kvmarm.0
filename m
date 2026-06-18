Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7777315D40
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 08:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781770722; cv=pass; b=B+zqs22nXy6WjfC+YusHwvhhxn3QwiBLULlcVFIoYD4ZSsK0d+51TQ2AJ3TPsZIEtQRmcVBDIYy5Q5EdRj70x/ExWwNSiJfiuLN5YJP1q5rFGvSHBAqDs5LmgKMI/Ph6NpfC0oGa29aB0en64jOBt157F4XWEWLNXelioFgCkiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781770722; c=relaxed/simple;
	bh=bqgcEe7gFwdD3M/OM4P1pARTT8M9rycYg6qkxBaJ3E4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y1STFziVnLzjHhZha5MuwiBwgR0VBVq/jjZd5x2OIXSviilrcmBFWgdatqju1ZA9kkZvSzsxVNegtWWPHccVv0xcj+NAWvHPhxZ4PaYPQwAZ+DeOtWX+TlMIC9tuTFPT0UsO0sLLlDj6yjHI5Wz4CFytszN65/HMa20sOVGFc8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VKiNCpQV; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VKiNCpQV"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5177d1ff061so145521cf.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 01:18:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781770718; cv=none;
        d=google.com; s=arc-20260327;
        b=RQ0RebYCSeO9eGsqztTJehq5y5rQHbPqi87QSC06Kb1ymOeH01Kv5RG+HWz60VNDEn
         xh2Vzm45dsbwmGupKHVUEiUBIJ+5rg0FluQt2CxDLRgcjlHkOozcbVRuW37rhEcccddu
         AAaCae2fZkjBEiiL9rlfvgyq+q2KD7ZiHOKgv+OtPH1GhiGLuE3076qx6pj4NOBucp1D
         krAxqBfDxfQlyLzOw9cFJjfDt0/J1PF6AHuR/oWUEmB17frGRQJJQlFm2rESlqco79Mz
         zGaBpEFlenq6QOSi5Aqb3aIrcuNtrqHl128RZZQNaf2vtJTA4FzVbbiScF2YK5jPKipx
         O8fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=c45y9wnnyb2cnPIO+srEHNjmV4JorsdhhQBjkEOIpgM=;
        fh=/CLpp1/J71xyxAeM+YXE5x2cJ9ky1Y9pPjYlaXm7GlI=;
        b=R9dVpx794K+KZ9qjhwRK0vbQQzDDEoLZcEMZg6nZ6U4N03ZJgrTIfYuVdbFpulJhyq
         NygkpSZlpOo9WUY9OOhbS3t9uGPQxP4O13iD2XeoDkc3LF+TsOvgZ16rzBXZExclqJ1c
         bHNobdPr286RMI9lee9997bKZW/gYiizSj7nvY9yLVgntE8xBResXqblx7ERTzPsOcwz
         8VFFHGxCJ62sRTlfLeMK/7QE+d0JLTrML3jgF1bahgRvKSw03M3lg+LMbcIN3YKp8R5M
         3SPB/xfGSTuoEL0s+mL1C0hgwidWJRSUzf0Tdhyu2dkcZ4oRiiVhoCC5luhCrBE8UC2q
         8l5A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781770718; x=1782375518; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c45y9wnnyb2cnPIO+srEHNjmV4JorsdhhQBjkEOIpgM=;
        b=VKiNCpQVPtoy6yVTNIO9iN+jEzWcp6PjVM8oMm+IN+3Ui7JoCvWNzIl3tq+pPzddE9
         9i66NX4LwaBybjoVwyuVZPGDJpn1vSG/uB/jeT/QAeJZlAOrsJB+IQrlrncriIsNlDjm
         cqpqIpgR1Ilx6NL5Lb5O649/nKIeAXXPUf+qSxNVSIR3FvbQpDnIk9ZIjlUS8l1lNEGR
         Exe2NlF/oTqBcDW8ofr9J8uTunD/DIRxISSEBXWl8qnMaF3bHNGmP6rx40D4abx6uEy+
         V0zfVxrsJa7mp8gM5hWPo/IlAZfqtrBgtS2dBJ5Xg1RjKWPZ4YEZKSiFZsVXSMDOArAo
         u7NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781770718; x=1782375518;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=c45y9wnnyb2cnPIO+srEHNjmV4JorsdhhQBjkEOIpgM=;
        b=tYjHXUS7QBoEzuCHlrTIdjRJnFWWwbpAlt1WLWSAt+T6/UYHWc4TyyeLHyBoh7PbFy
         2f1zsv7OvJbuClXpnBM4XBmbGYdA8Mi1UClv7uXDKDW5F84dmzjhdsbnajaWPMvFonDA
         oOirggVZiDVRmKRaIWDI+tXbaBfg3W3BE7gP4NhYhtTgGmk8D65thGpijJWt+LoIqGzv
         8TG6L6OS/vrgdoCeJBukRreYTjCb74pEhVEjS4GxdqG3OjYTDwynrVOrvgubgoA8vQxD
         pvyTg+YdoW4MCkBjlf9bcXq8MPJwsp/hMBIARWtGYB9YhxLmV36hkzj2F77oNJ7HKBcp
         x76w==
X-Forwarded-Encrypted: i=1; AFNElJ+EX1zSY5PvhfISxmzDTaiQvZ0ZshVMcAUabBybH5W5Y5jnrNN8aHWteGgsq1u0YavNMhM1kKA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhGh3C/P+wtXrZpLl2kphTxca2brkr6dL8MiWnLOa7z0gM0q0M
	J6UMMcD6eqaY8QrdC0aFeaFdQCc+zatj2Rd0ggc+7tvOAtW2lLE2/p7/aETQ2HfvFrS5Q8ON2HE
	MLAxaFBpOe8Bhuk0eHB0xH0633+CUaXIL/M0PLewq
X-Gm-Gg: AfdE7clK1If7iusdtdP2SU1w54yWQRvu2BhqwAkKh9IxtdjLHTUHJdksudJ+GyNtGW/
	ajfDZbHhOp90IZlFIHVxDfEgG4Ht38Tso6e+llgBlhxtNjGcOXy9Wuob66vz7Lmh/UIuTyezyaX
	PASMYgFGHtfnyYpfRaitL4j0XHHepWzcABIxOzs7MxROKJUGocxhUOnwV1vvJDK1+HUuiw9EACQ
	9fg5n+fA9rgOPmJ0Bm0ASVppsUPyOgSmHmFqXY5iikfyJ2/ICgwixBiCF1tT9qBRgUXa6a9hg==
X-Received: by 2002:a05:622a:60e:b0:50f:b69a:f4a8 with SMTP id
 d75a77b69052e-519c97442c5mr5265581cf.7.1781770717860; Thu, 18 Jun 2026
 01:18:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260614163336.3490925-1-tabba@google.com> <20260614163336.3490925-5-tabba@google.com>
 <86o6h8s2gx.wl-maz@kernel.org>
In-Reply-To: <86o6h8s2gx.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 18 Jun 2026 09:18:00 +0100
X-Gm-Features: AVVi8CeEsIe0WLVwg5GBkio2jYJMgyWACknxGyB7zwKW8NC6Ll8jR15uMdsNjAs
Message-ID: <CA+EHjTz1dtmmZ-JcJTEw6Pv+VephGEjpcNpt8zayUeESxcKyuw@mail.gmail.com>
Subject: Re: [PATCH 4/7] KVM: arm64: Set IL for injected FPAC exceptions
 during ERET emulation
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Jun 2026 at 09:00, Marc Zyngier <maz@kernel.org> wrote:
>
> On Sun, 14 Jun 2026 17:33:33 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > The FPAC syndrome constructed during nested ERET emulation does not set
> > IL. For FPAC (EC=0x1C), IL reflects the instruction length. ERET and
> > its authenticated variants are always A64 32-bit instructions, so IL
> > must be 1.
> >
> > Fixes: 213b3d1ea161 ("KVM: arm64: nv: Handle ERETA[AB] instructions")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/emulate-nested.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> > index dba7ced74ca5..4b39363cf891 100644
> > --- a/arch/arm64/kvm/emulate-nested.c
> > +++ b/arch/arm64/kvm/emulate-nested.c
> > @@ -2777,7 +2777,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
> >                */
> >               if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE) && !(spsr & PSR_IL_BIT)) {
> >                       esr &= ESR_ELx_ERET_ISS_ERETA;
> > -                     esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC);
> > +                     esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC) | ESR_ELx_IL;
>
> In general, I prefer retaining information that is present in the
> source exception, rather than adding arbitrary bits without much
> context, even if we only support AArch64 for NV. In this case, I'd
> rather see this:
>
>                         esr &= (ESR_ELx_ERET_ISS_ERETA | ESR_ELx_IL);

Sounds good to me. I'll rebase on 7.1 and respin.

Cheers,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
