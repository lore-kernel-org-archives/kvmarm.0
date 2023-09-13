Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18B41F95E
	for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 17:28:01 +0000 (UTC)
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5007616b756so26375e87.3
        for <kvmarm@lists.linux.dev>; Wed, 13 Sep 2023 10:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694626079; x=1695230879; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+DqPIsZFtugl3Ebs9kY786FjdhqhI/ka8Sx6QaBhio=;
        b=IPda1h7skXgUQbuSR1JHOvkScUt/T4845kLRAMVWVG2r9L5W0mJ2vG/9hvuMcpfZsa
         Czfka7LRNUstEhc5ctA9AjSdosQznfKgF/r9aBJ5fJkL7Vxn7Wt7VM+Xu8Kf3b1GTaU+
         zRCUoH4UtHpuz/4u8jfDPSLmAVCYX4/4rdo0+6vVv19eTNYOcQUYIVh53/TVX9X/AavQ
         OHP77RuWK+Rq6WNA3rxXeZAkNoT4I+HfDwuzMGzvAojqYBqsl2Qqy71QNpO/zhhC4teE
         zG21wBfuuA7v4VvHUxmUk/HACkT2EMS+OPTsFvGtQCwMoB7zzG0pxP4rZoNpB2dY+0Cs
         6o+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694626079; x=1695230879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+DqPIsZFtugl3Ebs9kY786FjdhqhI/ka8Sx6QaBhio=;
        b=X5zYTQU8mKN18dze0hkpjcAB1n9GzGKLgrcXNISpABe2Hdly4CygBiVSwaseatdQz2
         1KimFaxFyxBeUx9DJOuwl3gCQeqS72segJufLZQMM/NR7cmL2bl1JI94ctjaXnVOHN7+
         2jfpFDhhkHqbvKg9a+dWeV6kg1nl/1Di2Tcs4IGsJ+ajEfDB6Hf1KU6ovAtOtPwEmcz8
         jqctyhonmo9EQKRDvtSvS1LuryJT8mTdfHTSPR5sU12CdPtWA3cK+0EKKbll+edX4ewp
         FYlbx+Fc7nGRioEM6WttR22u4XvFVgUfqgt/ACLYTh+84ohUczmsjnbRGO8p91hcekOb
         oPyQ==
X-Gm-Message-State: AOJu0YyWFtlGdrJcEYOFgXKwka+wWMBcFwOdm+fJ7deS8/nrhh/up0nk
	T6OCMT76KqOftPNUoaBoa6gUHDjSWRG51vEY7rfxNA==
X-Google-Smtp-Source: AGHT+IG/2Y7iXKR9nHNNQNTdoe9u3xhm8Pd9RnXoAkxXl8ypYqri5so/4BxjbptLDpNYM72GX6LWhvrdQBvyUpVkTBU=
X-Received: by 2002:a19:6415:0:b0:500:9de4:5968 with SMTP id
 y21-20020a196415000000b005009de45968mr2330866lfb.59.1694626079514; Wed, 13
 Sep 2023 10:27:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230913165645.2319017-1-oliver.upton@linux.dev>
In-Reply-To: <20230913165645.2319017-1-oliver.upton@linux.dev>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 13 Sep 2023 10:27:46 -0700
Message-ID: <CAAdAUtgsWwH5gfxnU38m4pEddXAYUtwGE4arSEYDJw9cqPRoLQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Don't use kerneldoc comment for arm64_check_features()
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Wed, Sep 13, 2023 at 9:56=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> A double-asterisk opening mark to the comment (i.e. '/**') indicates a
> comment block is in the kerneldoc format. There's automation in place to
> validate that kerneldoc blocks actually adhere to the formatting rules.
>
> The function comment for arm64_check_features() isn't kerneldoc; use a
> 'regular' comment to silence automation warnings.
>
> Link: https://lore.kernel.org/all/202309112251.e25LqfcK-lkp@intel.com/
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e92ec810d449..818a52e257ed 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1228,7 +1228,7 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const s=
truct arm64_ftr_bits *ftrp,
>         return arm64_ftr_safe_value(&kvm_ftr, new, cur);
>  }
>
> -/**
> +/*

Thanks for the fix.
Jing

>   * arm64_check_features() - Check if a feature register value constitute=
s
>   * a subset of features indicated by the idreg's KVM sanitised limit.
>   *
>
> base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
> --
> 2.42.0.459.ge4e396fd5e-goog
>
