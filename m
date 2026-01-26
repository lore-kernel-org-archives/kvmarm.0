Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D49F341AD6
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 17:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769450073; cv=pass; b=bIVijPHwkN0MUpMcwGVSC7aK6EvaRPT7uH7ac3zZJPQEp5oPt0Sq+vIJTmNHIsT41nLWoO+PhvDgRrmMKq4Fin+cVf3c6CMTRZWsnh8Jj0wcCofMQ5yeZ1gJU0Z+XBLfIRc+ra3e6Zdn13t4iO7LU0bgVDTkPQK9V664VX7DSI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769450073; c=relaxed/simple;
	bh=DIDaa8firDc56kY0NwhQG07DNj47bE43T5LOLE1M3Ws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QYqVx7yRa2nWxjMUmPbQJY08jJ+KS7guf/VXqm+0sFvt9zO/vpJ0sJAJS452/64J1alRNZFQbMOUDjP5LDGIcCjw09gOaMT9+NCLwLOAJ+hRKYGXT8hDwz9OK+rQNug0qBQ2DEIORbnaMTMOxUwXkADlHEp/VY/nmgEkE5gnTJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J/CAIwwS; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J/CAIwwS"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5014acad6f2so6671cf.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 09:54:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769450069; cv=none;
        d=google.com; s=arc-20240605;
        b=dDJb3z4OrDZ/IgJw4Lrm+JxkeiYp5uFNpiRnWQamhOlp599XuSv6AeidN4YR2jjfrJ
         NqaN00307gDf/H3oyr+Hcgm1T+3AxuSQlXI/vgkkun2TeRu5jMQixJxBwlVXUl6bbjeM
         kr2fvINxbMvnS4QQjHTSFu1QHKXpL1zb0wyM9QRi02n7FnVuR+9d+7Bpiokxqo59Ziny
         0zEjoDJnaS//crQtpEeerWOoaXShvv+xpbtVcTptDcB2NyC70UI4kuY9bT+haK9uxAC0
         DJUKCdfhDPpnKVJKOamsHnT/H9IvVE8omL7IkQaprqGLQuTjRfHZeK65YzNUwg0T+B7o
         6r4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BaBaPbjRvnSlT5xuKPMaHPCMLrVAT3axwn7YGYLPHX8=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=bX/igCLOE6Jq40quhZBWwBNJ64/Uf6vq8xvpUJdN+0GDxTjywp+e3xaDWqiPMSj/Gv
         w0Wvaa1YcWKHlx1aGDATu5bjA+JLVVptGkoljQgIqMuvC8vVxImtAlPio/59CNoyc3Oi
         /K3xTW1uEBGjpMx1nxwjGRke9PtojtyxuAfhkWz/nJpd04g7OFRmtRPon1EmAHWs6l/Z
         Bd8VhacT2jikOC0Rbekz+uWSNMSySPlOlU64BiV6Z9gVSKSSn5MOQ5xmgM8zD+OqM/Js
         2NEmulJUyiO9LkvU1dGFWmEQoX+o/tbx7XbpTLn1lMWyy7BYykUcf/qzOtwzIn5YaHGU
         aPtw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769450069; x=1770054869; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BaBaPbjRvnSlT5xuKPMaHPCMLrVAT3axwn7YGYLPHX8=;
        b=J/CAIwwScumvvBG1yflONex5KKI48Zn3UM/5icINSBJdu4uUxx1s3HoSfMUnJt243L
         RDO2G80pEH4+RE0l7yOXT3GJAdlq3bd8mz11epCGOe92MctcdvtRWDdyGygDkfvq1+sJ
         wIiefVnVIb8Po3GBBqABC4JDOLf9PQMCIbXRUa/vmAGnKFLS5kSc1ftmCt4RiVdVgOOv
         k0t3mmm3SmsZ4s74ySdo5fN786DL11su/aor8R/XGgLZlpIGdbXdZ0jrdtfc5ToWwrsN
         q2DGvCqnKg+tpkfdGpA0CMNMPYNscHa4M6e02IuF5ORuimzAkSxWDIDNlSJWxiUg7ORM
         Dzog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769450069; x=1770054869;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BaBaPbjRvnSlT5xuKPMaHPCMLrVAT3axwn7YGYLPHX8=;
        b=r8xHJD3u6oLsBVG9+hsAZKeo7ucs1YW/VwrW2K76GsEnM5f2nSgv5Vf3wDXjs8DDDv
         vHn12lg9Ni/arTGpsLiGYd7HQ32cPmLShoLGfBovPjY3XrPphPoh2N4PzBjAu2U6p9pQ
         3Q16cEtnkMGGCmUBu3+67+P1g6f6Tg4QShwKkDcfip3YRYB1owbJ+nglcu7lU+iubkIe
         h5P6Ykyy7oI4nyx9nkLV33rZxKbtHHXb4pqFiJrM9QtqIyNTlljT2X+BzJX2L/7Z97jm
         ryvj4w2Q75xBgMRu+qdvzh/glhk9zZpkeV7Z0Sr3+gTleWgW2Dk01SZwUzgWwqJDDjSF
         0YUQ==
X-Gm-Message-State: AOJu0YwyeDVS6Xr3ts08+Tqs51WR0YCKXkWtoy5Q4VwzD+mTduqV57Sc
	OjbJ5fyrfB2gmcUCc8y1pjvHpu8dL54YGt3yQ3KhMHQyU99iUeQtJ6w5zwak9a0QU42cV0b0ZSU
	NBMXsEX/yn9dev5AzpQVgGWBIcnrgNJkn1Lr8gLdR
X-Gm-Gg: AZuq6aKdywFXMtxCRLbZVhDxl1RdJQTFY4fUKspoW+PecJUwYIdT/3KF3XJeyVVELOb
	g+8zM1+9uVR3cpDLIv2+e5/5ZHyJ7rjyD3E8Ud6HrNIWQKq5tJvR3bNdah7lm5kSn+bkrDvO6Vj
	64zxJDdabk5sfzOhQrACjrQKCoOyfLm7KCcqeFdg9CBobOPvibRwWUgfYv/0oMVMRusRHUlyeHt
	ajTgoxHaHe/rOvx08bUHpR6cIfxrdhzQcszrt/+Y9onRvSjJAYfhmm5CZaar4TEq8ar6mgL
X-Received: by 2002:a05:622a:344:b0:501:4539:c81 with SMTP id
 d75a77b69052e-503142cc1d6mr14568201cf.2.1769450069071; Mon, 26 Jan 2026
 09:54:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-2-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Jan 2026 17:53:52 +0000
X-Gm-Features: AZwV_QgKcivEy-Bh-scWxupdI_fJg4uVKAjUzJrjPt4iiSwWyjT8Fk2XVUt0Fj0
Message-ID: <CA+EHjTzToNnEV6Ow0WaVwpYwE3RBfLfvuzvDcnOjSmGB028vvQ@mail.gmail.com>
Subject: Re: [PATCH 01/20] arm64: Convert SCTLR_EL2 to sysreg infrastructure
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Convert SCTLR_EL2 to the sysreg infrastructure, as per the 2025-12_rel
> revision of the Registers.json file.
>
> Note that we slightly deviate from the above, as we stick to the ARM
> ARM M.a definition of SCTLR_EL2[9], which is RES0, in order to avoid
> dragging the POE2 definitions...
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Other than the deliberate deviation for bit 9, it matches the spec.

Of course, this changes the semantics of SCTLR_EL2_RES1, since now
it's 0. But I see you handle the consequences of this change later on.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> ---
>  arch/arm64/include/asm/sysreg.h       |  7 ---
>  arch/arm64/tools/sysreg               | 69 +++++++++++++++++++++++++++
>  tools/arch/arm64/include/asm/sysreg.h |  6 ---
>  3 files changed, 69 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 939f9c5bbae67..30f0409b1c802 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -504,7 +504,6 @@
>  #define SYS_VPIDR_EL2                  sys_reg(3, 4, 0, 0, 0)
>  #define SYS_VMPIDR_EL2                 sys_reg(3, 4, 0, 0, 5)
>
> -#define SYS_SCTLR_EL2                  sys_reg(3, 4, 1, 0, 0)
>  #define SYS_ACTLR_EL2                  sys_reg(3, 4, 1, 0, 1)
>  #define SYS_SCTLR2_EL2                 sys_reg(3, 4, 1, 0, 3)
>  #define SYS_HCR_EL2                    sys_reg(3, 4, 1, 1, 0)
> @@ -837,12 +836,6 @@
>  #define SCTLR_ELx_A     (BIT(1))
>  #define SCTLR_ELx_M     (BIT(0))
>
> -/* SCTLR_EL2 specific flags. */
> -#define SCTLR_EL2_RES1 ((BIT(4))  | (BIT(5))  | (BIT(11)) | (BIT(16)) | \
> -                        (BIT(18)) | (BIT(22)) | (BIT(23)) | (BIT(28)) | \
> -                        (BIT(29)))
> -
> -#define SCTLR_EL2_BT   (BIT(36))
>  #ifdef CONFIG_CPU_BIG_ENDIAN
>  #define ENDIAN_SET_EL2         SCTLR_ELx_EE
>  #else
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index a0f6249bd4f98..969a75615d612 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3749,6 +3749,75 @@ UnsignedEnum     2:0     F8S1
>  EndEnum
>  EndSysreg
>
> +Sysreg SCTLR_EL2       3       4       1       0       0
> +Field  63      TIDCP
> +Field  62      SPINTMASK
> +Field  61      NMI
> +Field  60      EnTP2
> +Field  59      TCSO
> +Field  58      TCSO0
> +Field  57      EPAN
> +Field  56      EnALS
> +Field  55      EnAS0
> +Field  54      EnASR
> +Res0   53:50
> +Field  49:46   TWEDEL
> +Field  45      TWEDEn
> +Field  44      DSSBS
> +Field  43      ATA
> +Field  42      ATA0
> +Enum   41:40   TCF
> +       0b00    NONE
> +       0b01    SYNC
> +       0b10    ASYNC
> +       0b11    ASYMM
> +EndEnum
> +Enum   39:38   TCF0
> +       0b00    NONE
> +       0b01    SYNC
> +       0b10    ASYNC
> +       0b11    ASYMM
> +EndEnum
> +Field  37      ITFSB
> +Field  36      BT
> +Field  35      BT0
> +Field  34      EnFPM
> +Field  33      MSCEn
> +Field  32      CMOW
> +Field  31      EnIA
> +Field  30      EnIB
> +Field  29      LSMAOE
> +Field  28      nTLSMD
> +Field  27      EnDA
> +Field  26      UCI
> +Field  25      EE
> +Field  24      E0E
> +Field  23      SPAN
> +Field  22      EIS
> +Field  21      IESB
> +Field  20      TSCXT
> +Field  19      WXN
> +Field  18      nTWE
> +Res0   17
> +Field  16      nTWI
> +Field  15      UCT
> +Field  14      DZE
> +Field  13      EnDB
> +Field  12      I
> +Field  11      EOS
> +Field  10      EnRCTX
> +Res0   9
> +Field  8       SED
> +Field  7       ITD
> +Field  6       nAA
> +Field  5       CP15BEN
> +Field  4       SA0
> +Field  3       SA
> +Field  2       C
> +Field  1       A
> +Field  0       M
> +EndSysreg
> +
>  Sysreg HCR_EL2         3       4       1       1       0
>  Field  63:60   TWEDEL
>  Field  59      TWEDEn
> diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
> index 178b7322bf049..f75efe98e9df3 100644
> --- a/tools/arch/arm64/include/asm/sysreg.h
> +++ b/tools/arch/arm64/include/asm/sysreg.h
> @@ -847,12 +847,6 @@
>  #define SCTLR_ELx_A     (BIT(1))
>  #define SCTLR_ELx_M     (BIT(0))
>
> -/* SCTLR_EL2 specific flags. */
> -#define SCTLR_EL2_RES1 ((BIT(4))  | (BIT(5))  | (BIT(11)) | (BIT(16)) | \
> -                        (BIT(18)) | (BIT(22)) | (BIT(23)) | (BIT(28)) | \
> -                        (BIT(29)))
> -
> -#define SCTLR_EL2_BT   (BIT(36))
>  #ifdef CONFIG_CPU_BIG_ENDIAN
>  #define ENDIAN_SET_EL2         SCTLR_ELx_EE
>  #else
> --
> 2.47.3
>
