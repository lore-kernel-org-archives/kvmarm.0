Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F68A3D
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 03:07:27 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6b9cf1997c4so1430454a34.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 20:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691723246; x=1692328046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FHeO7UY2tsm58hfH7H0nwe5QKdXphxLD9vhP6nCKdC4=;
        b=o01bKWiI/LISpCw3V0zQjWENOFkNWWloy9galEzdm9JUnG14oBHdijMLr3PJ6bGANO
         Y0YQvGFCCCwpWM/J4wOjBR2XZ63nJZwq9zFtWeXOrcl8IXbGjITKnnk7HEE/yDDEVa+Q
         sKW7I7UyLWurYd5SBfzdxpCsUTFQzdBbbbE7eLuan86Ngw0arLg8f+W8Wk6i0Eyo324p
         Aux/rLUUcwVhUxWRyVs7fnbDwhjeBasIuSPHAVZjncD0mn2uiZqkxA6+s+h+qBq/aRue
         ou7fNzQE8VbnkX9/VhCD8gpGo0GwKbzPC1jSymNMJGaETev0thnwPfzARWD34l2geAaT
         NRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691723246; x=1692328046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FHeO7UY2tsm58hfH7H0nwe5QKdXphxLD9vhP6nCKdC4=;
        b=J9GycT80NDA02wZ05d2aUI3G/vRF6NQMcC4AKEF+um7QF+NoBm6z58W1RBkmo9PCnK
         N2v9udRLxSM/iMn3eA8ruScYeI91WMIOJZbyrWHEoLRYEbJ+a9q9lXqBRbrxuE14Z+Pl
         CvnEEKo1ESBln6TMplStI8hkj0J6yEeg2Liwo2v7cCU0rThzU9UfkY2V3EOxczQxl4my
         wS297ED8vh3IH4nG21YSNPI5kCvINRPAZksoFGAJvLZu49PHL4gw3UbxqycFb6ENrSW4
         AT0/szF260nWHzASODIDCG8QN3CNrJwYW/tm+8y/qguWT7mfeIjzgOhDJau1mCmaShHU
         LjOg==
X-Gm-Message-State: AOJu0Yx1ZcQDObdjXxaAX1gSZvesNPLeYX/TBnXNme+ArZyJgAfLrlvN
	bvfopZKcWOIPtsWMsSz24SAbN0/SERrBh8OICdpivw==
X-Google-Smtp-Source: AGHT+IGsCw74vqVL18ZpnHQYN9TDoWnX9JA+M811vhcj5uVlc65Nuji3bO6OIrG5QP/pM9+rvGSLFZsiYe5aXdIrwNo=
X-Received: by 2002:a05:6870:9722:b0:1b7:4168:e2db with SMTP id
 n34-20020a056870972200b001b74168e2dbmr720652oaq.43.1691723246102; Thu, 10 Aug
 2023 20:07:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-8-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-8-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 10 Aug 2023 20:07:13 -0700
Message-ID: <CAAdAUthUnAk6ob0mxk07soomCeOOPwB4CM2B3QVmEqkeC5JZdQ@mail.gmail.com>
Subject: Re: [PATCH v3 07/27] arm64: Add missing BRB/CFP/DVP/CPP instructions
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
> HFGITR_EL2 traps a bunch of instructions for which we don't have
> encodings yet. Add them.
>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index bb5a0877a210..6d9d7ac4b31c 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -735,6 +735,13 @@
>  #define OP_TLBI_VALE2NXS               sys_insn(1, 4, 9, 7, 5)
>  #define OP_TLBI_VMALLS12E1NXS          sys_insn(1, 4, 9, 7, 6)
>
> +/* Misc instructions */
> +#define OP_BRB_IALL                    sys_insn(1, 1, 7, 2, 4)
> +#define OP_BRB_INJ                     sys_insn(1, 1, 7, 2, 5)
> +#define OP_CFP_RCTX                    sys_insn(1, 3, 7, 3, 4)
> +#define OP_DVP_RCTX                    sys_insn(1, 3, 7, 3, 5)
> +#define OP_CPP_RCTX                    sys_insn(1, 3, 7, 3, 7)
> +
>  /* Common SCTLR_ELx flags. */
>  #define SCTLR_ELx_ENTP2        (BIT(60))
>  #define SCTLR_ELx_DSSBS        (BIT(44))
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
