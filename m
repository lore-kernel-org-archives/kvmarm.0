Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF93C288525
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 10:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767783036; cv=pass; b=Qx671fXdeiM44C+pBIszEbYVOj/8uOZAh9yyLLBo+N5Jn1GQv/ZOWFWS9vGw+Ir9996Pi4ggeiCYODPwIJEEeGomKJ0UoQtj2IhHCZnLrXSLY4goDRgATeLr8ZmfketxZdd6rQsFbwy9zMRobJ1cojgLdiEH2ZcNxh1jFZIPHWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767783036; c=relaxed/simple;
	bh=XSR2R2Yo0MAWO3TeDcje2rreiLzqdE9kiUmaNtDqOiU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MLMwiNIskfKSEuM5WlZWOTm89p990QfzNl/68sDizRSHjSze0OxBzlOl/GuDGS5Uns58J6e34bOB4aBej/0qEAM+1iuDGRU48wcy6uwDnKKXfSZIa26lv53OP8Qj+EBwIXp4gpChHX8oIrjm6NRlkZfu00Wg4bkWml2OE8xlc4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rHgTjMSi; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rHgTjMSi"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ee243b98caso268571cf.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Jan 2026 02:50:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767783032; cv=none;
        d=google.com; s=arc-20240605;
        b=dnHhcxS5Up//FJ31AGS+xZ3/N3cVtFesiMdl1O4fKhnpuhwnYjUv4yMfXcU72rCTnk
         tiTN2p4crT7s7osjJmV7okeTCIirNb4areP93E7sFxHwbz0ux7qOOzn/bq0FjBt09Uvv
         xShtHqVRm28Ggke4LlMozAMR/iLqAhErEF+zRQ821tag7p0tYrVwaO2yKufqyal70/XT
         iiM77HtjLwKaVNQ0oBkgPyphnoc4BZ0AHJCNu1wBfW38QkvI492ZAh40k9zuzY1C+mKv
         ORQrCDrebsEvYIHBIoyx3BfRl8bSJaZAlP750gDgXxnOfDnjfyZAYYSes0TuYRhu1HPY
         9MWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zOdTqCgbentjtLweVnPWK7fZIKtBydrzwGFFKr7sHsw=;
        fh=bZvE/ZokHdr9VUbXrRF47HjfhoNTJ8oLhHnjSEwsuyk=;
        b=Aner7gSGTuVYEO1aPZ8/nX3LJmOMYLNFMuzQse0cIEq+YPn1Re2CG6PzMh8C+AC5s2
         JC6cJuM0Dw9gn0CtMjaOjpPx+AfmLN6waTb5Dw7txuDL4rImtjhFLvdeLRVD09BxdorP
         49y+4DYpnGLMJXrbL0Khow5YYsTGpUFv7YH4aMBDlZarcTaFyjuaWnE82E2QU9xDf+g0
         fpfAGvyoKlrNIsx810Lk0oM5HOeex/MlAMTAnNnxWLPKK9K2IYJKzSk6LpUW3LilzO1W
         5J+WkmgBubvTo8O7FCXoe+2Bd5aOkyqfVaWTeneUR3ImRudpAa+MxtHzoNzfs8zfZnhP
         u+0w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767783031; x=1768387831; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zOdTqCgbentjtLweVnPWK7fZIKtBydrzwGFFKr7sHsw=;
        b=rHgTjMSiU2Uf0UeY2vAz9JGu634YVRuOhsUXWJGy4dhF2Htg82iSYtfSaiS6zuarvs
         LhG+wPwkIA5WhO41ehWRbus1MhE8TxhP+UUv/myodU5aC44N0sOFBEFqFJQCaT5RQ0FC
         SEpFKWQ7jrwIlnEaTPfg+yX/fZrrHTxzWibOLO6Pp7s3kl1xLgkDb5D8ShrXpP57C76p
         g41hPk2KEsAEcOnev3Dmtl99iocYSj/DmHpTNbpH56lZJzInznkW0IA+i05h5YbFie+K
         y3t1Ux9YHhQ5x3vw3Go/MffNQw2tXTcW6B5NI0xRB2balmtDpGt/iiJVw720FtcuiN5K
         LL7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767783031; x=1768387831;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOdTqCgbentjtLweVnPWK7fZIKtBydrzwGFFKr7sHsw=;
        b=c64uwTBZni/IFhsX2ltgLyoYAYleBk6rfA6ZaRViFG3tLH+h1kKABVUTC0e+1zFuDN
         ntKh/+B4oP9T2D3fhGueaksELNsKPJczzp5h2TrtJRCCzy9pI1VMRVpQ9xeKnaD2Ye2j
         5hAjsED7jLwXeuiEkIkXcca++K9YGfm1Op09PqFQ2s7b1C0N0R10bLTSqcHG6AmOuM6e
         5B+S5Zmyhqi32jx6LHeGSe5kAye60wIIKw5LGLCGJXkm9609ZzZ95hSbieCbbgHQzb67
         TsFqouxEzYNS3AoV4L+3VaPFZnxSSEo5pJ7gIjnMg537h44Xxg/88f9yjhFp+EtpZ8hD
         zWhg==
X-Forwarded-Encrypted: i=1; AJvYcCW1slo15aOn4KUW2L8WndXAjZ3t3GwPSsm8AXk1fqZ1/mQphOp2bYm6Pb73xDKGWRaGIGd1tnc=@lists.linux.dev
X-Gm-Message-State: AOJu0YztEkmDyLn/TjTYkbpOq/Ymm15HAGwXG7Ol1T3UblGYcKNpwwWj
	jw5AEgEiVCN6sNehHMU9+0JDop7ZeRw4jhMCi0n3f24PLWU+AlfE0tgXnaAD2H6YxvERCKG8VwJ
	FqW01JicVB26zkMhcG+lF0jGdouoc4tgInK09coOe
X-Gm-Gg: AY/fxX4A+p/LlgvcYHgAMSVlMsTNI5bQQxAL0t5noeVaaL2FGkhHvWNTujzfshIN2jn
	638gw9Hc460UEGOeyd5AG0adOX5KY+K3yuiy+aqFVd8aifrS18OqAbNie9m3Bp7LLbkNb85jt9D
	Y732XyeeTOePy0hPWUmS7LL1iPlB7TbdiJC6vH6YMZLWyuNk5LwL5o096g9W6K23hcQ6uwC0koM
	BbWFWcnp3Dyixf0ClS9IoxWhZ5VcnuODspVdPB8TqXBtSUfOVvTsdrGbdRwt0L0dwU1o8v53UlA
	NK2+pGB9obO+ZWNGtndplfsw
X-Google-Smtp-Source: AGHT+IEe90KKT6Is3Q//ET89+VgQGSKhvBCLlRu+JqIYYHLh4Bb9dxSb6fKrazIySvaw1r4vpRWvk1XNficw4nqj1JM=
X-Received: by 2002:a05:622a:209:b0:4ed:ff77:1a87 with SMTP id
 d75a77b69052e-4ffb3fbd166mr9425051cf.19.1767783031452; Wed, 07 Jan 2026
 02:50:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260106173707.3292074-1-mark.rutland@arm.com> <20260106173707.3292074-4-mark.rutland@arm.com>
In-Reply-To: <20260106173707.3292074-4-mark.rutland@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Jan 2026 10:49:55 +0000
X-Gm-Features: AQt7F2pKAPPHBCOYW941AWJblwtEnJyF8jzMQ_QYvclZLTFjIyYDXEVB9OYfq6g
Message-ID: <CA+EHjTzPtxySO=iyEduqbisN+KCqwGfK=BnXaEQeAARh_0ydUQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Remove ISB after writing FPEXC32_EL2
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	broonie@kernel.org, catalin.marinas@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, will@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 6 Jan 2026 at 17:37, Mark Rutland <mark.rutland@arm.com> wrote:
>
> The value of FPEX32_EL2 has no effect on execution in AArch64 state, and
> consequently there's no need for an ISB after writing to it in the hyp
> code (which executes in AArch64 state). When performing an exception
> return to AArch32 state, the exception return will provide the necessary
> context synchronization event.
>
> Remove the redundant ISB.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks!
/fuad

> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 8dce3da85da35..91aa1862349cb 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -59,10 +59,8 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>          * If FP/ASIMD is not implemented, FPEXC is UNDEFINED and any access to
>          * it will cause an exception.
>          */
> -       if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd()) {
> +       if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd())
>                 write_sysreg(1 << 30, fpexc32_el2);
> -               isb();
> -       }
>  }
>
>  static inline void __activate_cptr_traps_nvhe(struct kvm_vcpu *vcpu)
> --
> 2.30.2
>
