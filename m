Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E1BEA5
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 03:19:34 +0000 (UTC)
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-56ca9a337caso1243694eaf.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 20:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691723974; x=1692328774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w5bPqvfIuD0lOvDvPnrvc9t+bX6LtHjE8VL/AxKPQik=;
        b=XcWMmLQqpb0TX/E+MdCde6ILHTwFpAGb4az1KtnDaMk/8/pTcC5MH6bMekFYq7SBDY
         BQfOHjSdNn0uE2T3MILES0/MCOBP4pS2t0D7KDUGFYewfuJiBzRpxhDU306uwst8wScz
         vobtrRae1DVHXVF8V/Y0F1zgU0Rw42LvtX/GLehr/BbQzrN9LNSaJSA958fKBmFbfAXS
         GdRMnv7FJys9UTMeO6Zleb5zeC8IJtXwpRBlQpHNv3yf9s1FDAtNaTfrfWonqAbK3JeG
         0QnTo6S7sSnRglUaMA2oW6LCR8S5+B2p1OJdD4E+2A6c2R2pZQoXV1qlt42pMINg4Nbm
         GNGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691723974; x=1692328774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w5bPqvfIuD0lOvDvPnrvc9t+bX6LtHjE8VL/AxKPQik=;
        b=Ojbzr6/T+9SyPlxJ4wweTYqxDWixMQKinCEzr8JZERhHEVlW/x8Afr7CxQc/JvC2UH
         zDS5XDZEmCCHa+OYM6oNG8gIqVfvLbmx7ouQz8N/nt2nFRxO1f5B6GEZ7W7dFuYr9O8U
         8bj2lfDTsS0FZdla6JewYPZFiMitc210UjfPAjHPrFx7hbSgpd6x6iODhe6ClYDac2G8
         Zx3UZCM8FMb2N+10euQQbTR98I/zxMF4haWEIZ984WFj6meJ585pc4rP1adu7FbT2iTa
         /7jQuLorpSi2qSlT3NIm3NxhdxKTdMwQVaKU+g2t5YvF5Q7t2UwUnK8rbSpyP9v0b5nK
         w5og==
X-Gm-Message-State: AOJu0YzJUBlE2Im//DhWruddyMK9Ut4qcGg39yUc9V0pQNuB37C6PFs/
	PM3Taop9ZKqZrR6Agn7tv70Tdw83ZIUWGMnOTgyTOQ==
X-Google-Smtp-Source: AGHT+IHyLds//g1taO2l0faur+C2u6yObXhHcDdTX5VhQp1KrsPG0xHpvVXUgtgQ8wSIOCNbID/ID6lHvQPaRi5JM20=
X-Received: by 2002:a05:6871:28e:b0:1bf:295a:68a9 with SMTP id
 i14-20020a056871028e00b001bf295a68a9mr804869oae.19.1691723973779; Thu, 10 Aug
 2023 20:19:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-9-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-9-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 10 Aug 2023 20:19:21 -0700
Message-ID: <CAAdAUtjc=vsibaxyz5pzhho7a9N2digP1vgHpCN_y9LUoaTOaw@mail.gmail.com>
Subject: Re: [PATCH v3 08/27] arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Chase Conklin <chase.conklin@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Darren Hart <darren@os.amperecomputing.com>, Miguel Luis <miguel.luis@oracle.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Tue, Aug 8, 2023 at 4:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> As we're about to implement full support for FEAT_FGT, add the
> full HDFGRTR_EL2 and HDFGWTR_EL2 layouts.
>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> ---
>  arch/arm64/include/asm/sysreg.h |   2 -
>  arch/arm64/tools/sysreg         | 129 ++++++++++++++++++++++++++++++++
>  2 files changed, 129 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index 6d9d7ac4b31c..043c677e9f04 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -495,8 +495,6 @@
>  #define SYS_VTCR_EL2                   sys_reg(3, 4, 2, 1, 2)
>
>  #define SYS_TRFCR_EL2                  sys_reg(3, 4, 1, 2, 1)
> -#define SYS_HDFGRTR_EL2                        sys_reg(3, 4, 3, 1, 4)
> -#define SYS_HDFGWTR_EL2                        sys_reg(3, 4, 3, 1, 5)
>  #define SYS_HAFGRTR_EL2                        sys_reg(3, 4, 3, 1, 6)
>  #define SYS_SPSR_EL2                   sys_reg(3, 4, 4, 0, 0)
>  #define SYS_ELR_EL2                    sys_reg(3, 4, 4, 0, 1)
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 65866bf819c3..2517ef7c21cf 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2156,6 +2156,135 @@ Field   1       ICIALLU
>  Field  0       ICIALLUIS
>  EndSysreg
>
> +Sysreg HDFGRTR_EL2     3       4       3       1       4
> +Field  63      PMBIDR_EL1
> +Field  62      nPMSNEVFR_EL1
> +Field  61      nBRBDATA
> +Field  60      nBRBCTL
> +Field  59      nBRBIDR
> +Field  58      PMCEIDn_EL0
> +Field  57      PMUSERENR_EL0
> +Field  56      TRBTRG_EL1
> +Field  55      TRBSR_EL1
> +Field  54      TRBPTR_EL1
> +Field  53      TRBMAR_EL1
> +Field  52      TRBLIMITR_EL1
> +Field  51      TRBIDR_EL1
> +Field  50      TRBBASER_EL1
> +Res0   49
> +Field  48      TRCVICTLR
> +Field  47      TRCSTATR
> +Field  46      TRCSSCSRn
> +Field  45      TRCSEQSTR
> +Field  44      TRCPRGCTLR
> +Field  43      TRCOSLSR
> +Res0   42
> +Field  41      TRCIMSPECn
> +Field  40      TRCID
> +Res0   39:38
> +Field  37      TRCCNTVRn
> +Field  36      TRCCLAIM
> +Field  35      TRCAUXCTLR
> +Field  34      TRCAUTHSTATUS
> +Field  33      TRC
> +Field  32      PMSLATFR_EL1
> +Field  31      PMSIRR_EL1
> +Field  30      PMSIDR_EL1
> +Field  29      PMSICR_EL1
> +Field  28      PMSFCR_EL1
> +Field  27      PMSEVFR_EL1
> +Field  26      PMSCR_EL1
> +Field  25      PMBSR_EL1
> +Field  24      PMBPTR_EL1
> +Field  23      PMBLIMITR_EL1
> +Field  22      PMMIR_EL1
> +Res0   21:20
> +Field  19      PMSELR_EL0
> +Field  18      PMOVS
> +Field  17      PMINTEN
> +Field  16      PMCNTEN
> +Field  15      PMCCNTR_EL0
> +Field  14      PMCCFILTR_EL0
> +Field  13      PMEVTYPERn_EL0
> +Field  12      PMEVCNTRn_EL0
> +Field  11      OSDLR_EL1
> +Field  10      OSECCR_EL1
> +Field  9       OSLSR_EL1
> +Res0   8
> +Field  7       DBGPRCR_EL1
> +Field  6       DBGAUTHSTATUS_EL1
> +Field  5       DBGCLAIM
> +Field  4       MDSCR_EL1
> +Field  3       DBGWVRn_EL1
> +Field  2       DBGWCRn_EL1
> +Field  1       DBGBVRn_EL1
> +Field  0       DBGBCRn_EL1
> +EndSysreg
> +
> +Sysreg HDFGWTR_EL2     3       4       3       1       5
> +Res0   63
> +Field  62      nPMSNEVFR_EL1
> +Field  61      nBRBDATA
> +Field  60      nBRBCTL
> +Res0   59:58
> +Field  57      PMUSERENR_EL0
> +Field  56      TRBTRG_EL1
> +Field  55      TRBSR_EL1
> +Field  54      TRBPTR_EL1
> +Field  53      TRBMAR_EL1
> +Field  52      TRBLIMITR_EL1
> +Res0   51
> +Field  50      TRBBASER_EL1
> +Field  49      TRFCR_EL1
> +Field  48      TRCVICTLR
> +Res0   47
> +Field  46      TRCSSCSRn
> +Field  45      TRCSEQSTR
> +Field  44      TRCPRGCTLR
> +Res0   43
> +Field  42      TRCOSLAR
> +Field  41      TRCIMSPECn
> +Res0   40:38
> +Field  37      TRCCNTVRn
> +Field  36      TRCCLAIM
> +Field  35      TRCAUXCTLR
> +Res0   34
> +Field  33      TRC
> +Field  32      PMSLATFR_EL1
> +Field  31      PMSIRR_EL1
> +Res0   30
> +Field  29      PMSICR_EL1
> +Field  28      PMSFCR_EL1
> +Field  27      PMSEVFR_EL1
> +Field  26      PMSCR_EL1
> +Field  25      PMBSR_EL1
> +Field  24      PMBPTR_EL1
> +Field  23      PMBLIMITR_EL1
> +Res0   22
> +Field  21      PMCR_EL0
> +Field  20      PMSWINC_EL0
> +Field  19      PMSELR_EL0
> +Field  18      PMOVS
> +Field  17      PMINTEN
> +Field  16      PMCNTEN
> +Field  15      PMCCNTR_EL0
> +Field  14      PMCCFILTR_EL0
> +Field  13      PMEVTYPERn_EL0
> +Field  12      PMEVCNTRn_EL0
> +Field  11      OSDLR_EL1
> +Field  10      OSECCR_EL1
> +Res0   9
> +Field  8       OSLAR_EL1
> +Field  7       DBGPRCR_EL1
> +Res0   6
> +Field  5       DBGCLAIM
> +Field  4       MDSCR_EL1
> +Field  3       DBGWVRn_EL1
> +Field  2       DBGWCRn_EL1
> +Field  1       DBGBVRn_EL1
> +Field  0       DBGBCRn_EL1
> +EndSysreg
> +
>  Sysreg ZCR_EL2 3       4       1       2       0
>  Fields ZCR_ELx
>  EndSysreg
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
