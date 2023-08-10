Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFB0A3C
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 03:15:04 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-1bbaa549bcbso425040fac.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Aug 2023 20:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691637303; x=1692242103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L0xnzF+9+TsiFTxZIKv5dydNW+DBjE+4uA7qCMcvxxE=;
        b=Mx2VKu9lXnHZy2KpZjtFwGKCAiIYOguMlL6X3p9jEeJWehJq4lRAERLsee0OwhWPo7
         UlklvH0yw4SLzvvK6pvvbbTIgBNgKVIbcUJYYvoe2RHv3OQV+xaD0h42ToUShfaVgFib
         019bFPhoN7sXFPrZvOa8jfYckZPmQUEn4/sJQj5KFnTv/O3ymDajaQ6PHPCltPMv36Mi
         qef1SXUALBWng8veX2+50koiZQODaSip8M2XJdFi3hiV25s2RjyoHbHCh6ZzgPRFAHeT
         7ZF8nToHmpGAaSDLfowvoZSy4PaRb7PwWBTaJz1HxtgSbdWxLnLZ7Bnsz5QLil40Qp6W
         BBRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691637303; x=1692242103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L0xnzF+9+TsiFTxZIKv5dydNW+DBjE+4uA7qCMcvxxE=;
        b=W1pWhrRxLK1qyKGbKbwa9/QbBfM04/UCYNBGb57dATBckVX6Q18rUSq/AhyVmgtJS3
         l+BBu2BZU03TEF0wnBPKOrRrpgZJS1gGiXmpGXgzXtSB+8CeImrO76TnBWElmtfVPG5m
         8YpFz1AMuBkdKv7cJ80+4JFVC1t3Hki23q/hAEWgcPKFHczr1LGXUltHmJy9PBCawV76
         aQa29BFKJmAo65z+dhA9HeQjm1MXeVakC+eDpZ6Tm9wssDIynv17Jh0nkJZ1m+X4wQqR
         /8PMtlFP2UNgxaVKWYnLiO+DI5xgGZxIimFJ+m+/qVJeywNjCm4eiJOLE0gYdKWrZD2Z
         a7Zw==
X-Gm-Message-State: AOJu0YxoOhwLA8gQhXwMU8X3DCSDVTDoxrfn6kuULbmucXs/X4T2SmYt
	1NEFQaO2Ps6TP9wKxPrhQqokCARhl9wG46FIntL9Pg==
X-Google-Smtp-Source: AGHT+IHH4gmxjsj+Iov5+vq5Gep7DZjsOHnVLr4huK5zkOXXcQb6pG64Av7VwvEEHeZFV6ysCatxAgti+b/Ju14vP10=
X-Received: by 2002:a05:6870:d586:b0:1bb:e381:e1f1 with SMTP id
 u6-20020a056870d58600b001bbe381e1f1mr1482547oao.9.1691637303371; Wed, 09 Aug
 2023 20:15:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-2-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-2-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 9 Aug 2023 20:14:51 -0700
Message-ID: <CAAdAUtjaj7wCn6VG7KxGqmT_e+nth_LK00+4E2SfF=5dFpmbSA@mail.gmail.com>
Subject: Re: [PATCH v3 01/27] arm64: Add missing VA CMO encodings
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
> Add the missing VA-based CMOs encodings.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index b481935e9314..85447e68951a 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -124,6 +124,32 @@
>  #define SYS_DC_CIGSW                   sys_insn(1, 0, 7, 14, 4)
>  #define SYS_DC_CIGDSW                  sys_insn(1, 0, 7, 14, 6)
>
> +#define SYS_IC_IALLUIS                 sys_insn(1, 0, 7, 1, 0)
> +#define SYS_IC_IALLU                   sys_insn(1, 0, 7, 5, 0)
> +#define SYS_IC_IVAU                    sys_insn(1, 3, 7, 5, 1)
> +
> +#define SYS_DC_IVAC                    sys_insn(1, 0, 7, 6, 1)
> +#define SYS_DC_IGVAC                   sys_insn(1, 0, 7, 6, 3)
> +#define SYS_DC_IGDVAC                  sys_insn(1, 0, 7, 6, 5)
> +
> +#define SYS_DC_CVAC                    sys_insn(1, 3, 7, 10, 1)
> +#define SYS_DC_CGVAC                   sys_insn(1, 3, 7, 10, 3)
> +#define SYS_DC_CGDVAC                  sys_insn(1, 3, 7, 10, 5)
> +
> +#define SYS_DC_CVAU                    sys_insn(1, 3, 7, 11, 1)
> +
> +#define SYS_DC_CVAP                    sys_insn(1, 3, 7, 12, 1)
> +#define SYS_DC_CGVAP                   sys_insn(1, 3, 7, 12, 3)
> +#define SYS_DC_CGDVAP                  sys_insn(1, 3, 7, 12, 5)
> +
> +#define SYS_DC_CVADP                   sys_insn(1, 3, 7, 13, 1)
> +#define SYS_DC_CGVADP                  sys_insn(1, 3, 7, 13, 3)
> +#define SYS_DC_CGDVADP                 sys_insn(1, 3, 7, 13, 5)
> +
> +#define SYS_DC_CIVAC                   sys_insn(1, 3, 7, 14, 1)
> +#define SYS_DC_CIGVAC                  sys_insn(1, 3, 7, 14, 3)
> +#define SYS_DC_CIGDVAC                 sys_insn(1, 3, 7, 14, 5)
> +

How about sorting these new ones with existing ones to make it more readabl=
e?
Otherwise,
Reviewed-by: Jing Zhang <jingzhangos@google.com>

>  /*
>   * Automatically generated definitions for system registers, the
>   * manual encodings below are in the process of being converted to
> --
> 2.34.1
>
>

Jing
