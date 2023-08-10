Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCB9EC0
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 04:26:03 +0000 (UTC)
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6bca857accbso481042a34.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Aug 2023 21:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691641562; x=1692246362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8SzlWpkO/G8eXJxm+wOIHBf7k158IaeAOHQb5zwz77g=;
        b=upVErD+im9yxS2c+J1AxUOFT3gb9ROrQtXAkJQWR/Od5Hlcaal5/JQFxpd910uiHMA
         rolfKNQdETXSZHI/JmL+9MEaqGs+Y2ANtpCPS/uGV1eBhOOR7gC3xt9Y2hAbSzT5Sd5e
         j1xQ9EQ/cXytXYLYYVC3QUNKzegtH0PLhOxRICScovv49Oiab+dPO7Y0r2sIRFt+Gz/f
         bN9+Rvs3XWMUiaRLZjooMQyeM9liWdUXjJ8GB32y7dQK1Evj8mpqkM8y6va8PCI0QIvU
         fZHVJyxXZ6UWyXQa2M0/cggiZ9FYaBcFC4zDQMYeCxCYiGIemD7IrNDMmaywESM7pKEb
         4pOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691641562; x=1692246362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8SzlWpkO/G8eXJxm+wOIHBf7k158IaeAOHQb5zwz77g=;
        b=FO+CoiUCdAssA32YXJzf3YG1p36k3rvRYLz65ElQZwXD6oo+W4WsAx+oLQRlUEWtsm
         fVP+lVKXqSzvlEhSZcP8rMr0pmSeOxKxR7EiSvGcAud0vFvgw53kuExa5DEOW5oIjLdu
         VXiujsXw1XQ5LYXVgGdxKbn4InKI1pV8JhjC7CK9laISoM0Sghk7iX4a9oXG8QCSg5eh
         3tpc9SjdTqrznB7q485yyRRmyh/n3yqtXllm4lDH6an9FODfSHV2n8Y2gKyzET2sHM1p
         L9CDPM6s5mp0PQtHnHxjYQE19cUWSOtUhRdWP6870FZ4Q/oJGUZzKhhkyDy3y8bL89aF
         dcYg==
X-Gm-Message-State: AOJu0YwxY4UoXzgFZsMYdMw4rC185dKoYyI2EJ1aas6/juGrzDjxtZ4b
	kMLnQaTu5m6vF3wAQxRgrGCE3eA3WQj6eEYqZctXqQ==
X-Google-Smtp-Source: AGHT+IGE7wa40ggnreKv846WO4nD3TWvJ+jAyG8x8cdRmwDbn5umSrJCg95VcM4tJqGJLJXLKtibuwap8bxbSr8UtF8=
X-Received: by 2002:a05:6870:95a6:b0:1bf:2aa4:ab0f with SMTP id
 k38-20020a05687095a600b001bf2aa4ab0fmr1476246oao.31.1691641562394; Wed, 09
 Aug 2023 21:26:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-3-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-3-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 9 Aug 2023 21:25:47 -0700
Message-ID: <CAAdAUthi8tDmFyboZzLaxSTfkUxrucBxjeh8+Fn5OahK4L5=9g@mail.gmail.com>
Subject: Re: [PATCH v3 02/27] arm64: Add missing ERX*_EL1 encodings
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
> We only describe a few of the ERX*_EL1 registers. Add the missing
> ones (ERXPFGF_EL1, ERXPFGCTL_EL1, ERXPFGCDN_EL1, ERXMISC2_EL1 and
> ERXMISC3_EL1).
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
> index 85447e68951a..ed2739897859 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -229,8 +229,13 @@
>  #define SYS_ERXCTLR_EL1                        sys_reg(3, 0, 5, 4, 1)
>  #define SYS_ERXSTATUS_EL1              sys_reg(3, 0, 5, 4, 2)
>  #define SYS_ERXADDR_EL1                        sys_reg(3, 0, 5, 4, 3)
> +#define SYS_ERXPFGF_EL1                        sys_reg(3, 0, 5, 4, 4)
> +#define SYS_ERXPFGCTL_EL1              sys_reg(3, 0, 5, 4, 5)
> +#define SYS_ERXPFGCDN_EL1              sys_reg(3, 0, 5, 4, 6)
>  #define SYS_ERXMISC0_EL1               sys_reg(3, 0, 5, 5, 0)
>  #define SYS_ERXMISC1_EL1               sys_reg(3, 0, 5, 5, 1)
> +#define SYS_ERXMISC2_EL1               sys_reg(3, 0, 5, 5, 2)
> +#define SYS_ERXMISC3_EL1               sys_reg(3, 0, 5, 5, 3)
>  #define SYS_TFSR_EL1                   sys_reg(3, 0, 5, 6, 0)
>  #define SYS_TFSRE0_EL1                 sys_reg(3, 0, 5, 6, 1)
>
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>
