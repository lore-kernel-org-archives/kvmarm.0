Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7128AA3D
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 03:00:26 +0000 (UTC)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1c11d53221cso425187fac.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 20:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691722825; x=1692327625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UTJGjUqBapxVhvCdXTD7P0bpdJMZ6O+lPqjyCa3v71k=;
        b=vXUpok/T4f4PicGTiPoHq0EFJXLr816p6np/CAF2Fem9nUUCJHwpzYQVEP7RPcMPjo
         Q4i/Dn1zeqa3iSlR1qEjFIsygsGZwEEnKsCSVMJQmIY46rB7hSi8sTwOlMOuCd4oYaKf
         kbjawAhkXylXMh+tBuh6IifYtEh3fdNPs+0R/yW4IxbQXZqaH4Se7HKYpR6caGaaDayu
         aL/Il2WNNYBgFppcbfE1WgR+m2VzO684OKxMiOPdZO5RPgnIxN082GrXF+m3NafLYEGr
         MFt9e1CausCM+qw7QvEnprT/PkY0jEOOq3JwSQrA69QwnxTcrLrKkGri/QqG3S3attQD
         K6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691722825; x=1692327625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UTJGjUqBapxVhvCdXTD7P0bpdJMZ6O+lPqjyCa3v71k=;
        b=dmCOcGQ5Sya41iueLi6IOwhbbtV2dPKmjQqzxnfs1y+CNc0NY/x2Gi2UFyF1pOIPkF
         F4SvncDibaqTTxc/IYq73qjh4GrX4tQnkrGwvb6EwoWvMbbjfYvbxRLftyWp0jeso1Nt
         wb4U/F7Uhfr6vd0oiAj7B7hK8poPl4PAcFBCY+Iv43SkVUYtUwBImWyg02/OciJM+/j+
         YWBY8vVVqDxzTI3kHq7srIsclx3+lj7sklPaE3JvH4wmtM0jF3/ZZDHtSMXl3aQKfHIJ
         criWQ7uzc957SrMIIOyiUjYMm80o8oleQ1at2iBbLwYjXrZA+3FmWDBzV7MQENdiMe65
         s7sg==
X-Gm-Message-State: AOJu0YzyYNC90nDBE8I/XW+JLVLJnAFYVeLjx4cDphkVhVLprqj/IjpU
	lL8s2L2QNRkR2P/n9nqWviMIScXAnjMWLWECG+X9Lw==
X-Google-Smtp-Source: AGHT+IE4r9r52XP5QQyIa4kV7mjGBry+BkkZDTXNKGDTQSHIV8fdVgVCuEWMJzUei7+pxt1jhVKap2356aVv9pLNv/4=
X-Received: by 2002:a05:6870:7394:b0:1b7:4655:2ac9 with SMTP id
 z20-20020a056870739400b001b746552ac9mr719081oam.6.1691722825262; Thu, 10 Aug
 2023 20:00:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-7-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-7-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 10 Aug 2023 20:00:12 -0700
Message-ID: <CAAdAUthK6O6u3ZGePpGOqU1eVtfGfxd_0cBpm5LyvjAUzpnhRw@mail.gmail.com>
Subject: Re: [PATCH v3 06/27] arm64: Add debug registers affected by HDFGxTR_EL2
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
> The HDFGxTR_EL2 registers trap a (huge) set of debug and trace
> related registers. Add their encodings (and only that, because
> we really don't care about what these registers actually do at
> this stage).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 76 +++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index 76289339b43b..bb5a0877a210 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -194,6 +194,82 @@
>  #define SYS_DBGDTRTX_EL0               sys_reg(2, 3, 0, 5, 0)
>  #define SYS_DBGVCR32_EL2               sys_reg(2, 4, 0, 7, 0)
>
> +#define SYS_BRBINF_EL1(n)              sys_reg(2, 1, 8, (n & 15), (((n &=
 16) >> 2) | 0))
> +#define SYS_BRBINFINJ_EL1              sys_reg(2, 1, 9, 1, 0)
> +#define SYS_BRBSRC_EL1(n)              sys_reg(2, 1, 8, (n & 15), (((n &=
 16) >> 2) | 1))
> +#define SYS_BRBSRCINJ_EL1              sys_reg(2, 1, 9, 1, 1)
> +#define SYS_BRBTGT_EL1(n)              sys_reg(2, 1, 8, (n & 15), (((n &=
 16) >> 2) | 2))
> +#define SYS_BRBTGTINJ_EL1              sys_reg(2, 1, 9, 1, 2)
> +#define SYS_BRBTS_EL1                  sys_reg(2, 1, 9, 0, 2)
> +
> +#define SYS_BRBCR_EL1                  sys_reg(2, 1, 9, 0, 0)
> +#define SYS_BRBFCR_EL1                 sys_reg(2, 1, 9, 0, 1)
> +#define SYS_BRBIDR0_EL1                        sys_reg(2, 1, 9, 2, 0)
> +
> +#define SYS_TRCITECR_EL1               sys_reg(3, 0, 1, 2, 3)
> +#define SYS_TRCACATR(m)                        sys_reg(2, 1, 2, ((m & 7)=
 << 1), (2 | (m >> 3)))
> +#define SYS_TRCACVR(m)                 sys_reg(2, 1, 2, ((m & 7) << 1), =
(0 | (m >> 3)))
> +#define SYS_TRCAUTHSTATUS              sys_reg(2, 1, 7, 14, 6)
> +#define SYS_TRCAUXCTLR                 sys_reg(2, 1, 0, 6, 0)
> +#define SYS_TRCBBCTLR                  sys_reg(2, 1, 0, 15, 0)
> +#define SYS_TRCCCCTLR                  sys_reg(2, 1, 0, 14, 0)
> +#define SYS_TRCCIDCCTLR0               sys_reg(2, 1, 3, 0, 2)
> +#define SYS_TRCCIDCCTLR1               sys_reg(2, 1, 3, 1, 2)
> +#define SYS_TRCCIDCVR(m)               sys_reg(2, 1, 3, ((m & 7) << 1), =
0)
> +#define SYS_TRCCLAIMCLR                        sys_reg(2, 1, 7, 9, 6)
> +#define SYS_TRCCLAIMSET                        sys_reg(2, 1, 7, 8, 6)
> +#define SYS_TRCCNTCTLR(m)              sys_reg(2, 1, 0, (4 | (m & 3)), 5=
)
> +#define SYS_TRCCNTRLDVR(m)             sys_reg(2, 1, 0, (0 | (m & 3)), 5=
)
> +#define SYS_TRCCNTVR(m)                        sys_reg(2, 1, 0, (8 | (m =
& 3)), 5)
> +#define SYS_TRCCONFIGR                 sys_reg(2, 1, 0, 4, 0)
> +#define SYS_TRCDEVARCH                 sys_reg(2, 1, 7, 15, 6)
> +#define SYS_TRCDEVID                   sys_reg(2, 1, 7, 2, 7)
> +#define SYS_TRCEVENTCTL0R              sys_reg(2, 1, 0, 8, 0)
> +#define SYS_TRCEVENTCTL1R              sys_reg(2, 1, 0, 9, 0)
> +#define SYS_TRCEXTINSELR(m)            sys_reg(2, 1, 0, (8 | (m & 3)), 4=
)
> +#define SYS_TRCIDR0                    sys_reg(2, 1, 0, 8, 7)
> +#define SYS_TRCIDR10                   sys_reg(2, 1, 0, 2, 6)
> +#define SYS_TRCIDR11                   sys_reg(2, 1, 0, 3, 6)
> +#define SYS_TRCIDR12                   sys_reg(2, 1, 0, 4, 6)
> +#define SYS_TRCIDR13                   sys_reg(2, 1, 0, 5, 6)
> +#define SYS_TRCIDR1                    sys_reg(2, 1, 0, 9, 7)
> +#define SYS_TRCIDR2                    sys_reg(2, 1, 0, 10, 7)
> +#define SYS_TRCIDR3                    sys_reg(2, 1, 0, 11, 7)
> +#define SYS_TRCIDR4                    sys_reg(2, 1, 0, 12, 7)
> +#define SYS_TRCIDR5                    sys_reg(2, 1, 0, 13, 7)
> +#define SYS_TRCIDR6                    sys_reg(2, 1, 0, 14, 7)
> +#define SYS_TRCIDR7                    sys_reg(2, 1, 0, 15, 7)
> +#define SYS_TRCIDR8                    sys_reg(2, 1, 0, 0, 6)
> +#define SYS_TRCIDR9                    sys_reg(2, 1, 0, 1, 6)
> +#define SYS_TRCIMSPEC(m)               sys_reg(2, 1, 0, (m & 7), 7)
> +#define SYS_TRCITEEDCR                 sys_reg(2, 1, 0, 2, 1)
> +#define SYS_TRCOSLSR                   sys_reg(2, 1, 1, 1, 4)
> +#define SYS_TRCPRGCTLR                 sys_reg(2, 1, 0, 1, 0)
> +#define SYS_TRCQCTLR                   sys_reg(2, 1, 0, 1, 1)
> +#define SYS_TRCRSCTLR(m)               sys_reg(2, 1, 1, (m & 15), (0 | (=
m >> 4)))
> +#define SYS_TRCRSR                     sys_reg(2, 1, 0, 10, 0)
> +#define SYS_TRCSEQEVR(m)               sys_reg(2, 1, 0, (m & 3), 4)
> +#define SYS_TRCSEQRSTEVR               sys_reg(2, 1, 0, 6, 4)
> +#define SYS_TRCSEQSTR                  sys_reg(2, 1, 0, 7, 4)
> +#define SYS_TRCSSCCR(m)                        sys_reg(2, 1, 1, (m & 7),=
 2)
> +#define SYS_TRCSSCSR(m)                        sys_reg(2, 1, 1, (8 | (m =
& 7)), 2)
> +#define SYS_TRCSSPCICR(m)              sys_reg(2, 1, 1, (m & 7), 3)
> +#define SYS_TRCSTALLCTLR               sys_reg(2, 1, 0, 11, 0)
> +#define SYS_TRCSTATR                   sys_reg(2, 1, 0, 3, 0)
> +#define SYS_TRCSYNCPR                  sys_reg(2, 1, 0, 13, 0)
> +#define SYS_TRCTRACEIDR                        sys_reg(2, 1, 0, 0, 1)
> +#define SYS_TRCTSCTLR                  sys_reg(2, 1, 0, 12, 0)
> +#define SYS_TRCVICTLR                  sys_reg(2, 1, 0, 0, 2)
> +#define SYS_TRCVIIECTLR                        sys_reg(2, 1, 0, 1, 2)
> +#define SYS_TRCVIPCSSCTLR              sys_reg(2, 1, 0, 3, 2)
> +#define SYS_TRCVISSCTLR                        sys_reg(2, 1, 0, 2, 2)
> +#define SYS_TRCVMIDCCTLR0              sys_reg(2, 1, 3, 2, 2)
> +#define SYS_TRCVMIDCCTLR1              sys_reg(2, 1, 3, 3, 2)
> +#define SYS_TRCVMIDCVR(m)              sys_reg(2, 1, 3, ((m & 7) << 1), =
1)
> +
> +/* ETM */
> +#define SYS_TRCOSLAR                   sys_reg(2, 1, 1, 0, 4)
> +
>  #define SYS_MIDR_EL1                   sys_reg(3, 0, 0, 0, 0)
>  #define SYS_MPIDR_EL1                  sys_reg(3, 0, 0, 0, 5)
>  #define SYS_REVIDR_EL1                 sys_reg(3, 0, 0, 0, 6)
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>
