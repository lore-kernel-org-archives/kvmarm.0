Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FB410F0
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 04:29:17 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6bd0a0a6766so488504a34.2
        for <kvmarm@lists.linux.dev>; Wed, 09 Aug 2023 21:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691641757; x=1692246557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSfTgAgX08RA8KJNECzRqx6VSrVwrPxTtbQrQqdYk/Q=;
        b=fLHMHPvEQHLnIoTQe/pKnhjKXg9Dns+4MsWdkepWoSPXQKplvhSt4ILJQjaDa5jb+i
         TI4C8rmyA0CLw4wXhLEj7Xf0994xn1m70Mwg0SGLVIwR3546xXSL7KaiCsHJjRVOmClK
         0/dv0fmet7PtR7x7DLdmuvqM7j3Kh0pL4IbSRAKKsFDLsZSHigOSecjUGjaQnVeaiDzL
         xvS40K9MdEW5zLVDgbpnbMXASj3X7C1fDG01/o8GiLY5988IKImRAg6fPV3ZiSEl1M/P
         2nnSK9Ys4HCktXjedf6toHzBO6HQzvdIRJ1woTDtPqEIxYaTpPuiHK/edhZce6tyB98Q
         A3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691641757; x=1692246557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gSfTgAgX08RA8KJNECzRqx6VSrVwrPxTtbQrQqdYk/Q=;
        b=UokAMZVYpmX4xA4M9yqO7znbGxXQnswtaKSxMLAQCMY9oQYByRKoapHIZj6cBN1Iv3
         IL8DtECFshCJdfZg4eviQYlW2JInp+sS8k4XoSBQjFH7s2GUsYhnF5NBmAEeqmvOWJUi
         Jc6Ufp3BMm2oMMNI0S1S3vM3gSFkGyfOcO5r5Y4iiudzxCO7+qdI4OkQtTrwHTiG8ZUp
         v1/m2kyiv88I/8PZqAAyfcUdTh8/bqsISaMADimH4bPwIFA9VMuqE4nMthZNZPTVltlF
         x7eUYv0PpJN2/gq/1tSaOmpQSN6KEu32j3ipdfjs+t3pfkJHG1kC461+CVlKW8axblMD
         FfCw==
X-Gm-Message-State: AOJu0YyLcKSN9n59QL39dXHoYjTY8N4XAVXykYyCMZi95VSWHNOBEYQ+
	5NCvdUWh/fLoxgqOGJC/hIR/3l0sdhWvgMTUFh3Sbw==
X-Google-Smtp-Source: AGHT+IEbbgtaxDzsvT16sQ8NkvMgXB+NbTz5AAm7Isq3L+6p2LRbNo6wBcMMoliVkWQBKhPDC0cZngV1h2tuItRkqtU=
X-Received: by 2002:a05:6870:248e:b0:1be:cf5d:6f7b with SMTP id
 s14-20020a056870248e00b001becf5d6f7bmr1660262oaq.17.1691641755955; Wed, 09
 Aug 2023 21:29:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-4-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-4-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 9 Aug 2023 21:29:03 -0700
Message-ID: <CAAdAUtj-pPqj92dt1XxvDUDKAHP3gsjnpgQYi3YSLXnWGiVtww@mail.gmail.com>
Subject: Re: [PATCH v3 03/27] arm64: Add missing DC ZVA/GVA/GZVA encodings
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

On Tue, Aug 8, 2023 at 4:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> Add the missing DC *VA encodings.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index ed2739897859..5084add86897 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -150,6 +150,11 @@
>  #define SYS_DC_CIGVAC                  sys_insn(1, 3, 7, 14, 3)
>  #define SYS_DC_CIGDVAC                 sys_insn(1, 3, 7, 14, 5)
>
> +/* Data cache zero operations */
> +#define SYS_DC_ZVA                     sys_insn(1, 3, 7, 4, 1)
> +#define SYS_DC_GVA                     sys_insn(1, 3, 7, 4, 3)
> +#define SYS_DC_GZVA                    sys_insn(1, 3, 7, 4, 4)
> +

Reviewed-by: Jing Zhang <jingzhangos@google.com>

>  /*
>   * Automatically generated definitions for system registers, the
>   * manual encodings below are in the process of being converted to
> --
> 2.34.1
>
>
