Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF3717E
	for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 00:03:01 +0000 (UTC)
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2b9dc1bff38so88515891fa.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 17:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692144180; x=1692748980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I8FmgQMS4+VEtN3YWaf3XTC6qJSdTgKCK/OCtZRJ2AM=;
        b=uDD3wZbsa1FJm4jgmPqfC89zpb19U+Ch5I0RBSK6mIPi5HCVTnAUbXQGdlx+efArze
         KlKn/V+eLitTXMrjQLDP5xE5psTDnuzGO35YnDvUN1MQcj2Yv3X+WqOQMOBGJm+8iNs6
         qtN6nxZrIL23UulabY5gv7o0CFvQS9aK3X3mcTXhNyRgm+PnpcH8x6WWk6F79Gq8PSzf
         5bMBuB9SoBfWraZb07MoX41IZcjbZMSuA6TnUIJFxt8wFJso72YGkHKw4+Vv4UuLligy
         bXwZRahs3NOkWD1WK16+JCV+QgbZDc8GGmQdvyJhrmZenZULW8Wb7+Et2LTmgoPXyQNQ
         6w2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692144180; x=1692748980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I8FmgQMS4+VEtN3YWaf3XTC6qJSdTgKCK/OCtZRJ2AM=;
        b=HOyF/mlPzXD5nUcx23IKj95fjlTV9+ofSB1+RItqynqzWEKdJEPnkn+sJaj4LedYT0
         qOxRdG4H6XkK27i14BvFEQDy1RlojVsA2ZZyx17XBIoq6/lNCvCvmZGGJvkN9EKJntiY
         DDmw1wOr0fcbs47uLrtdato5dHhBdosZnoqeJ9VTWrMMw3HR6mNeVx8COy/4/JSAbmNr
         41NkmqAPn1KYAjJJ4CAZjxMumroTCagr4V3/vu7qzoA4J5l96pHLYaLzWr0PqoixsWB7
         YPAIoIZU61Wzo1sU0VwcyEcx32RjItQvu6jvXDJR6HACi2BOxIVG1Iu/tNhr+gmLwOkM
         XTJQ==
X-Gm-Message-State: AOJu0Yw2hwGfk8ZEtYEd/XUJjprpO9C79eOLLpEAlEA5/4MJAxe0jvj8
	acZz7Pa8DsijH1mBS6L5NKFSMRHArX+eJt7uZhTD3w==
X-Google-Smtp-Source: AGHT+IGzXSHI262nd8TAHecg5+PE5eyEfT/q71qRXLJuGAUfyX/wyH8dQPUrUJHQzlDTntpzBLv8+QSiDCIv/ZhlXYw=
X-Received: by 2002:a2e:a17b:0:b0:2b9:da28:c508 with SMTP id
 u27-20020a2ea17b000000b002b9da28c508mr199586ljl.31.1692144179945; Tue, 15 Aug
 2023 17:02:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-27-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-27-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 15 Aug 2023 17:02:47 -0700
Message-ID: <CAAdAUtiQwwSjZ_LHmRP+sW2VWSoe_cSQ5Rrh92f7-o5C2x_s7g@mail.gmail.com>
Subject: Re: [PATCH v4 26/28] KVM: arm64: nv: Expose FGT to nested guests
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

On Tue, Aug 15, 2023 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Now that we have FGT support, expose the feature to NV guests.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 7f80f385d9e8..3facd8918ae3 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -71,8 +71,9 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sy=
s_reg_params *p,
>                 break;
>
>         case SYS_ID_AA64MMFR0_EL1:
> -               /* Hide ECV, FGT, ExS, Secure Memory */
> -               val &=3D ~(GENMASK_ULL(63, 43)            |
> +               /* Hide ECV, ExS, Secure Memory */
> +               val &=3D ~(NV_FTR(MMFR0, ECV)             |
> +                        NV_FTR(MMFR0, EXS)             |
>                          NV_FTR(MMFR0, TGRAN4_2)        |
>                          NV_FTR(MMFR0, TGRAN16_2)       |
>                          NV_FTR(MMFR0, TGRAN64_2)       |
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
