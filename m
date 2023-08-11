Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77F663B6
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 15:31:26 +0000 (UTC)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-1a28de15c8aso1783716fac.2
        for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 08:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691767885; x=1692372685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MkHxuuUE1racnF7AqWkiPAPBMqIdT5jrsMuLVcWQoXY=;
        b=IkHeT5HL72sVQg87oKLKAWG2T8oyxYgOdRcRjayYES9J4+s9MiAFDfKXWU2VL4jnIw
         GcV4Vh+5PTwAV2cDuSOsLMW9B/1wrUcaj0a3K+lgKia+k6aDlZCauxBq7Kwh2tqTwB6n
         ymfnNRLB6fN8YahjGhAW6XA+0paKNUnK8l4T1whS3XOlxtTdvSkLEm7CR8Gr4PixYNqC
         Fkw5g2Nk0XpQzI6DAXueDlaYo27bz8ICjkl424bv+kp9LS/piJIKrpmC0LFQ1mRKqH5C
         OV2ais3ra5DO+1B+PCaVEn+qSHhxghrqliF0r4aiDx+izf0qKK3BQVbLe8Rgd9PVIxyP
         F1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691767885; x=1692372685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MkHxuuUE1racnF7AqWkiPAPBMqIdT5jrsMuLVcWQoXY=;
        b=W6vJKKNC9vVnUG52imgvn6szh6dfNCA/cTSJGBjZPxqlKL24KHeijSnm8EZgW1gryt
         6IOilL2eH0+2fhkoEbTDL1lBxHealGUJ5J8IEQ6WJCKMBmSDa8nSGpadcAU1ue0JstQb
         BUW1r8Qto1OaLfCnFu+EN9G9iSUpbJLRiCsdncJIWWzdJgxyK4nN7qg77R8xUK757FR1
         oxpc75UG6RViuf3dWpWBHEhzcGBOExfCm4L5DCoXMA6N4Nii3XAvLo7df42/s+yDbnw/
         1B34saMwXofQfvkjHYRSWwwIRNNquotHFSESusYsEC+ok2q+sV62BTPrqRdLogAd1TSs
         osiw==
X-Gm-Message-State: AOJu0YxBq1oT0sZ0rDXNNdvN0pkmKXnb+XbZ5nH7FsTX4+xU+jERpy0j
	fW/NIMyDQJz8nfOBAXptPbIVNR2hdSrJSfiwIHJ5BQ==
X-Google-Smtp-Source: AGHT+IFuU0i4ssk4mXymypXRlN8YzctH8Of+BhP+Z9PlFvCANq23FxDZvhz42dJQbPZ6dyi0OSaExylXwPX2H0Vqzw4=
X-Received: by 2002:a05:6870:9687:b0:1bf:ce5b:436 with SMTP id
 o7-20020a056870968700b001bfce5b0436mr2760098oaq.58.1691767885480; Fri, 11 Aug
 2023 08:31:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-11-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-11-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 11 Aug 2023 08:31:13 -0700
Message-ID: <CAAdAUtjOo_Bhpy2hvmVTEeG4vTmdHF9uoqnphdKBBW8jKRAndA@mail.gmail.com>
Subject: Re: [PATCH v3 10/27] KVM: arm64: Correctly handle ACCDATA_EL1 traps
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

On Tue, Aug 8, 2023 at 4:48=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> As we blindly reset some HFGxTR_EL2 bits to 0, we also randomly trap
> unsuspecting sysregs that have their trap bits with a negative
> polarity.
>
> ACCDATA_EL1 is one such register that can be accessed by the guest,
> causing a splat on the host as we don't have a proper handler for
> it.
>
> Adding such handler addresses the issue, though there are a number
> of other registers missing as the current architecture documentation
> doesn't describe them yet.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 2 ++
>  arch/arm64/kvm/sys_regs.c       | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index 043c677e9f04..818c111009ca 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -387,6 +387,8 @@
>  #define SYS_ICC_IGRPEN0_EL1            sys_reg(3, 0, 12, 12, 6)
>  #define SYS_ICC_IGRPEN1_EL1            sys_reg(3, 0, 12, 12, 7)
>
> +#define SYS_ACCDATA_EL1                        sys_reg(3, 0, 13, 0, 5)
> +
>  #define SYS_CNTKCTL_EL1                        sys_reg(3, 0, 14, 1, 0)
>
>  #define SYS_AIDR_EL1                   sys_reg(3, 1, 0, 0, 7)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2ca2973abe66..38f221f9fc98 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2151,6 +2151,8 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>         { SYS_DESC(SYS_CONTEXTIDR_EL1), access_vm_reg, reset_val, CONTEXT=
IDR_EL1, 0 },
>         { SYS_DESC(SYS_TPIDR_EL1), NULL, reset_unknown, TPIDR_EL1 },
>
> +       { SYS_DESC(SYS_ACCDATA_EL1), undef_access },
> +
>         { SYS_DESC(SYS_SCXTNUM_EL1), undef_access },
>
>         { SYS_DESC(SYS_CNTKCTL_EL1), NULL, reset_val, CNTKCTL_EL1, 0},
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>
