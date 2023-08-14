Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1025D528
	for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 21:08:43 +0000 (UTC)
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2b9b904bb04so76239031fa.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 14:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692047321; x=1692652121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HSp/PBgFuqjU5FU2wSVwIwvbq+BUoL+z7yaXrbjmk7E=;
        b=OS9OcTyyhb0MI7YCPjUC8NTPZAqUrVrUllRWSw1QWEtcLSMWO1aXtrg0HUBCj9yqDf
         qkMl0AjE4N+YwB1uBuRRlsVs1zgxiNdzIROOb0TNV25Fuz5HkyI8Hyv6muEiV9T8Ggzr
         7NTuZsmwSHxBicLIgMgzvrMnVtcrn1f56FqfQSKaOIplzWK4g6pP48WIbHB5PpMCngzk
         Yje2kX4dEXTa1+/0oE3kJ6dlBEBApyN4t5zuZ9vJ3tnWeN7PM86YPbgLH01k2wlzYwj0
         UPL27kWoVw+NW6v7aOqySigoX1koIA0C5FV8OgFovFsK9tzGThAR94nPxD1lEYvi+pCY
         0Fxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692047321; x=1692652121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HSp/PBgFuqjU5FU2wSVwIwvbq+BUoL+z7yaXrbjmk7E=;
        b=Ooyy20RqsvbWQpY2E0/b8ptC22CYDzMyxCbXxrNovP5zvWXHNDL3UOmcEQd6U/7is9
         iMCp/nl9gQsEy1uoigF93lUS6plKb0J9z7yeUULdRgEzCYSsXv+QNrXh2M51dGsoAdsk
         /WFZs3W9JDzOElHIE9EW3Qmysri1isVF+81eClHD/17poGLxTmrNLYuoAh76KtV30mHg
         1LI0IibqQTltIfmr7O6JvMd86zUwdILTz8xY12vMw0HXQNG2d9q52q2H1guQaE5ZytcX
         tWUPLIVV6EWC+mICvlYXibpLQaaQuK+HRb2Dajzt8Eb0QqY/DRcvxPu9/lqkIDeQm7El
         C4zQ==
X-Gm-Message-State: AOJu0YzxuRATlW/+xN8c38y2MWHQuWBk59tBsl39yhpkPeVfKXhJaHs3
	ckIy/z3hOMbsxFucFA6XJbMnsQiluBDTvBAck6zgRA==
X-Google-Smtp-Source: AGHT+IEmydD7Vg63lIM0FBUIs9+BBEzh+aAHaZt+2h9ySTyHScdO/ox2c3DfLJT1FXQenxJY8qkzoCaqPavs81FI74Y=
X-Received: by 2002:a2e:8752:0:b0:2b6:c61c:745b with SMTP id
 q18-20020a2e8752000000b002b6c61c745bmr7782564ljj.3.1692047321419; Mon, 14 Aug
 2023 14:08:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-17-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-17-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 14 Aug 2023 14:08:29 -0700
Message-ID: <CAAdAUtjvnbdr==SyKz+8UC-ZDPOc9W-Rp-3JjtMjfbVeB=zuPA@mail.gmail.com>
Subject: Re: [PATCH v3 16/27] KVM: arm64: nv: Expose FEAT_EVT to nested guests
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
> Now that we properly implement FEAT_EVT (as we correctly forward
> traps), expose it to guests.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 315354d27978..7f80f385d9e8 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -124,8 +124,7 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct =
sys_reg_params *p,
>                 break;
>
>         case SYS_ID_AA64MMFR2_EL1:
> -               val &=3D ~(NV_FTR(MMFR2, EVT)     |
> -                        NV_FTR(MMFR2, BBM)     |
> +               val &=3D ~(NV_FTR(MMFR2, BBM)     |
>                          NV_FTR(MMFR2, TTL)     |
>                          GENMASK_ULL(47, 44)    |
>                          NV_FTR(MMFR2, ST)      |
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
