Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A6D3542C9
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 17:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769709134; cv=pass; b=tNDAZd/9tCPYEIAS5IXVviIZ0UhsGWl4GZkIGd5Lo9bnwFL8kunb6HumqD4BSCNesUtZ+dcKRsdmLLbHQSn/0WjtK324aHcqlpyA2KglY9z4WleEaefaqPRPoFiKCWlYLiasZLm/I7vpsykuru2Rjn2/EOh3+aorZwJr69lQg2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769709134; c=relaxed/simple;
	bh=9Ak46LEVCwhOJ4dFCTIpVOefYezUL+JMSUS/w3aykog=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nXkr3+VKkHCpVEcsBca/+Cp89Y31ShJRQ/FvkHctvHMvmWfeS9hLxCKNy54rYxQwBZeIdSI3dQGetCMz97/WPz/LbEXsLXD6cwlXlDidrjzIf34Dgqh9tP53wb9lfIYhpogC/zplgoRA1LvKGPmm7a0O2I4ilRY+foBU7Gj3duM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4p0z0HqU; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4p0z0HqU"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5033b0b6eabso8101cf.1
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 09:52:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769709131; cv=none;
        d=google.com; s=arc-20240605;
        b=hh2eb/JIKEtSYiQjPUukOaD0pvMAgF2YQUeD52wcGeDvHaTw40Uw+mgZnxfXq7Q4V2
         glKQAtIRXgkF2ZgQ1rs+hc/zR4/ViJ5Oe94kobMSBe3SJGRrtaZjWCtP2Ec7moXz4NEX
         48RNTiaeQzSwiK3ecQnusvna0S0Vcede+4/DuBMrnosnsrkjhhbtsUBxcDfuAk703FEt
         m1IV8JUKY1uq5Mz6sR7UPOgfZfJl/kBcYlh56IN6rG7GBp27xqOjZgzG11n91iySMJtK
         Ytaj3atlCLVCuvFFJkKdUWr5Pyh+/tPxb2ZcsMynJiToya7adMH1Zv/VOWNBXJv3/n/P
         34rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=rFkUGWSSI69uP0vyiVno+p+O/XXB1AsOCXVbUdPg2U0=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=FvFMpUh8XGTUuz9kj12529BJU7ZAGzpqtDpJoEH8PgpatyVU2Mh/8C85obSqQeEiP1
         A2CX2psRacnstNuwaxj0FsF+74EJ/MQhHEZPI9gX+psAAT/JluRXAZAW7JJVTpXa19kL
         KrJsXycPf3RdA5EIPIUn+QMqMhzFkw1vCm3GkdafUod26oAibNLagiBSDHpAigs9ZP/h
         SmxEFLwmsE+f3O7KBIkMcgsfMgU13IF3l+kdPRLlZ/hgAGtOmaEDTxjVfIl1l/QU6Pl7
         hIkjl2MWRUlOlTsmrR2a9UGwXPJYPj3IPUsmmXU2xsnOueQ5CYKzDaNiXpz1TbX6cmU8
         Z3Fw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769709131; x=1770313931; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rFkUGWSSI69uP0vyiVno+p+O/XXB1AsOCXVbUdPg2U0=;
        b=4p0z0HqUb0EZCpFW2LnSDcb7Fshs7yTF+P8/2c4j6t/gIks3akhiw+VlGMo1yEFbVB
         mr2PWKMFjl62fGjkm86L8O4qD5WhMaYhWUXX99QF2hItGFzMUMFXSo6Kt0kpPohwZd/5
         GYEJPDUjQvzSLmnKozZTflJwuWBJ/4jHvudPrtXkcOUMTEVe6uur7Tne8y0zh6QzD3ZW
         kS0LPaH8JC78UbQy89smKd5ZQvPGlh1IGuYFEWWHweYqXNCO8p4eZvD4VOfHJtKVkxI8
         a/bxJpF5EZtM58V30gE74mBMLCDc7s6Xxm3uujligE2ue6pHucHk0z05izieI7J/eTl2
         Mfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769709131; x=1770313931;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rFkUGWSSI69uP0vyiVno+p+O/XXB1AsOCXVbUdPg2U0=;
        b=f2D5+rlyuitzuSNt1XFMwHRwpCU/uJ13j96wzr23qDc8S72RIBWgEaN55WTQrAfYuM
         JdK+5tTQ3QTrIbAWrxxqzFlJ9lVi5cyJHJN9nKrG4YPDPOFEYlFTReWJrconwuVt7gDn
         j/Ff3T1UF1PIopkXxtyXksV+E1bvt7esR8udfABLoU90tnELbBYbClu3QjlWGvU2v8mO
         OAZfEUSPK4mllGL+iQmG6vlpM0VQDdVdoGAytrjDR17eKIMFv7zWEYRbLmgYOYV3o/NE
         ZGKd8NtbGCjpcf0ygAG9vfv71xL8Ji2V/7Za8SRRlblwXI9jnkwzcdZilpXNoRAYrUJo
         cPjw==
X-Gm-Message-State: AOJu0YxAZZhuyh1zTuMg5ZN5x5FfxqhVrm4EGhroy7GNDnKAAschvfwN
	vi2SIS3KA45o6OlDysG9FC3T2Jw8eMAXILqMtq5e7HR/EsH0SbHNzWiI5ppMXxbuMej8A8cm7fS
	GU61sN/2j5B0LX34edk1ySHPJfl70eiCYFAYnXHEJZVWBqhUOPqAdAxdM
X-Gm-Gg: AZuq6aLSIAzhNKYtlg+NofDscNaWzFy0otsZbEgcJ5KlTP2mmJzSIQsUV/CUbDN89lN
	KKOGOyWdNl/vJHXqdTSmh1YeB8UMivswIVAq3qO2Y5EOkGFosDT3FK9AYOoeRFehq+mrOGryD6Q
	Zomlo8VObI3cDjdtseQGbETKjfeYZUT/n9ZoKQXUtma41X6PAsuNalCjxNMorkncJ3qtZt4jyN1
	/0d2t94Qnm6bHhwLfxTmAWH6nGa7Ajvj6MlrLtx4iZcw4vrxkovJ88ZiZ/GlFz7OHPXmAq5
X-Received: by 2002:ac8:7fcd:0:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-503b6705a55mr15283421cf.12.1769709129198; Thu, 29 Jan 2026
 09:52:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-19-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-19-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 17:51:32 +0000
X-Gm-Features: AZwV_QhPQvIsUhtu0m4Xb8tRLlQCeNpAfaZsDAJefW0mGcGoCi3YrpM0LthDHFU
Message-ID: <CA+EHjTxJbWkCcNimSGYHSgjYSp4xGuEk1cwf4Dc5giQAM74Bhg@mail.gmail.com>
Subject: Re: [PATCH 18/20] KVM: arm64: Remove all traces of HCR_EL2.MIOCNCE
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> MIOCNCE had the potential to eat your data, and also was never
> implemented by anyone. It's been retrospectively removed from
> the architecture, and we're happy to follow that lead.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

The field HCR_EL2.MIOCNCE is deprecated and made RES0.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad






> ---
>  arch/arm64/kvm/config.c | 1 -
>  arch/arm64/tools/sysreg | 3 +--
>  2 files changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index f892098b70c0b..eebafb90bcf62 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -944,7 +944,6 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>                    HCR_EL2_FMO          |
>                    HCR_EL2_ID           |
>                    HCR_EL2_IMO          |
> -                  HCR_EL2_MIOCNCE      |
>                    HCR_EL2_PTW          |
>                    HCR_EL2_SWIO         |
>                    HCR_EL2_TACR         |
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 650d7d477087e..724e6ad966c20 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3834,8 +3834,7 @@ Field     43      NV1
>  Field  42      NV
>  Field  41      API
>  Field  40      APK
> -Res0   39
> -Field  38      MIOCNCE
> +Res0   39:38
>  Field  37      TEA
>  Field  36      TERR
>  Field  35      TLOR
> --
> 2.47.3
>
