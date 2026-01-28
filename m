Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5D936E46F
	for <kvmarm@lists.linux.dev>; Wed, 28 Jan 2026 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769622261; cv=pass; b=QKQD6Y0mjdu3LlBEnCcZAlKIKhAqXoIGzfWXcNHpZifC6B5vNRCzsTMndATCiAz2w+Nv0J73lxKCU5tnekTi9mqC4dFSiYoo0tGFoI8H5uxDjOkOS/yOWiT1A8Ec7MKYuxOoz6Ea9gf5xsUaIj3jOTsxZagw8qBfBh1CUnsrmSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769622261; c=relaxed/simple;
	bh=n9qMoCX3G+jYOXH3ah2jgfZmawPnIAGRu4txfYSI8bI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jWPeCq8ECU9oZR9l2SZU1fX07Ifb3mDYzms/obM5jh20cUl2Fvl+kF2HnlFyDXX9OAANE85KXOjG4ZL95AvhKNkxHt1ySaDku1DJKw2H3j96fcAzoQHWo++oIaZPFJeqnEWRlotrLjpvA90VjhBweV464BUZqPDuQf8We09rMAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kopFBG3M; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kopFBG3M"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50299648ae9so111cf.1
        for <kvmarm@lists.linux.dev>; Wed, 28 Jan 2026 09:44:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769622258; cv=none;
        d=google.com; s=arc-20240605;
        b=F2MxIGZhooQ2KvmbbaDOm08PpayRTY5hLIGQd4AahqeddqVMox0iEZ/iFg0dY4kwO3
         eM5rAnGTMx9y0sOPwe6y3d2VmKWOLO3pQjoPEJI/QxBQVP7Zs0vcJS704/1VXWmEAMLe
         vbCO2tGqY+cZybLYhKRsU559F6oFBq2jtS8Y1lzCShCMqf2p5aNuUm2dPKuchUCCf6vS
         6sICZ5AtvakcJIZFA3GBRU2ecu3O75eH6ej6pDMr9VO6aFrAJ2859rQYyNfoF2DN8Ypr
         khw3x511LbcsKHqz7YQ7AL+pTIBkq7RXQ76hMeSNi8bPxhIMdBeXAnH9pEOL/Ex40j/Z
         /9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bQ28KNx3pxtawA1nFwPKCc2RQpAN4D6gIqSKFp3a8PE=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=ZRb20m9+/p8lFnflb30ysCtAbxftzNGpTddNw0zY0izBdRP9EUEZkRXr2j4vff8cQe
         3hkl5CAlPM3jyurD97qC5ixAYlziyG87agviKO5sNArMxEDGb3LJFWPqpvIKD+MpvLkU
         7oeeFHDVrVwtoU5BRiyGu5EWs1OnTjOyD2V8kEJVB6mzPxmFWL7pfU1IGXYzOQdlEKB2
         CUYhHaGuRUaO3ZpVYaPPLzcaH0NQdn8QMQ6uCEl6gGq1nRiAoJtuSU1hC1rDJvSFCVck
         FYS1qHhJiezn7qGA7rVx3Y/7Y6FfRu8C6YfiSTK81tE1GwkUcIp0NcdF7k7GY0r/MaWf
         gMjA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769622258; x=1770227058; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bQ28KNx3pxtawA1nFwPKCc2RQpAN4D6gIqSKFp3a8PE=;
        b=kopFBG3MQCVl7caiqtQJPopSUzMeVpKd6q/9C6DTrvpreD6zJRF78ZdgW0uhv3bqpU
         raoO8XTgj0gbCeASKtdOPWSSwcnGzxppTA/qHo1nnbpF5PC2IhoQKABK1kn5wtO5hMNP
         pfk54yFRw7RRQsLJAY+guxT3ALWhqnj5y9B1oEWYQ+rRU5j/OVO6sd8yMbHTTdvUv/oF
         R4FaqTM/pR6/FQC8pFlWJXbKCeg9ylk8UmOXoYFkJkimWu3qlnYGWJRZ0dBvsixNESUW
         zk7TcFKxc2qFZ0/igsv7nHDTBcNRbfB7FwnurYCCaaNZk8yyGm2lRqfWzDUiEiN4t2rc
         Nz/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769622258; x=1770227058;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQ28KNx3pxtawA1nFwPKCc2RQpAN4D6gIqSKFp3a8PE=;
        b=iqnjYXv8MGVPMewdrqOIQkKkV/CW0mNXsW4WQbA7mzKcqBBXS+S2Od8a8XSwaqOg/J
         3D4bsWYbJf35r1w6TtdEWlqX+4Fhb4Ff8gRFeJ4dEeBcNOcyE9m0XDgH7/pERa52qGtc
         6hVMy/Qi3OO99jSN1vRRV6jIkIPxrIX2Sg9hlqJBG2K7Ba4JPzlLewh/CS2thKRV+RH2
         253tMb9cL+sk2mwIkgiE2SV0ry7O2DxjTQ6+ua0+kFLO9HzxS/WrafuMTQaQ+nTTbHuF
         K2vc1jhvc3On7Q6HVhAZlxr5s2oHf6/rV3PNBRhDF5i1zc6AoE84VWkklagirPNMn1qp
         6pjA==
X-Gm-Message-State: AOJu0YyND0ewZjSxCm/7DwCp6QLUJhiWJtVwMnahC8vJaz8yHqOTNn6l
	2CQOOYM+v8Ma/a6tBs9ucAcTtv2SPe+cQjLKzy5nVN4/PBAitYr5tuSeRE5aY7mplN4QgYzBgaf
	Xhw2li2mVtK2ue7IYIy2Zyu7hYtTyMoapeoy5HbkY
X-Gm-Gg: AZuq6aK2Uc6rmXCccxZEnpNfDV/I1/bscf18eOBpF4EP2zECSJUNLq1B7KRDOalQiBw
	bWuGxpqPSMcSdmW1TbvmBxRh+/JkxX/zsdkJXo/Od0+MlqryNR+4Wm6FWWwAvcchYA8yYYT3P4S
	OMM1gNUUyU7uAs2i1GD7RqG/bTnehmsvHTaC3oKzGfE1ZtD38sm+a5V97l9GYQLGL3B6e/+w5rD
	gu30Spkzrq9G3ljQU9FV1tXiRnZXL2EpNYFQ3AiJ11pGycnxoN9o51jsbQD+WD0S8kxpb6QawBB
	xH4iLCY=
X-Received: by 2002:a05:622a:a64d:b0:4ed:a65c:88d0 with SMTP id
 d75a77b69052e-503340e241emr18057281cf.6.1769622257513; Wed, 28 Jan 2026
 09:44:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-13-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-13-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 28 Jan 2026 17:43:40 +0000
X-Gm-Features: AZwV_Qjw_-4jQqLbJsa_gafDcYnoQTp1vBemlKSUmMjvAlynKsInG-LHMbmXpQc
Message-ID: <CA+EHjTzL6bNZ=sZoub3GY=VZ2bJ+4bFr4jkuiMMBCEqXuAkQPA@mail.gmail.com>
Subject: Re: [PATCH 12/20] KVM: arm64: Add RESx_WHEN_E2Hx constraints as
 configuration flags
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> "Thanks" to VHE, SCTLR_EL2 radically changes shape depending on the
> value of HCR_EL2.E2H, as a lot of the bits that didn't have much
> meaning with E2H=0 start impacting EL0 with E2H=1.
>
> This has a direct impact on the RESx behaviour of these bits, and
> we need a way to express them.
>
> For this purpose, introduce a set of 4 new constaints that, when
> the controlling feature is not present, force the RESx value to
> be either 0 or 1 depending on the value of E2H.
>
> This allows diverging RESx values depending on the value of E2H,
> something that is required by a bunch of SCTLR_EL2 bits.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 1990cebc77c66..7063fffc22799 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -26,6 +26,10 @@ struct reg_bits_to_feat_map {
>  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
>  #define        AS_RES1         BIT(4)  /* RES1 when not supported */
>  #define        REQUIRES_E2H1   BIT(5)  /* Add HCR_EL2.E2H RES1 as a pre-condition */
> +#define        RES0_WHEN_E2H0  BIT(6)  /* RES0 when E2H=0 and not supported */
> +#define        RES0_WHEN_E2H1  BIT(7)  /* RES0 when E2H=1 and not supported */
> +#define        RES1_WHEN_E2H0  BIT(8)  /* RES1 when E2H=0 and not supported */
> +#define        RES1_WHEN_E2H1  BIT(9)  /* RES1 when E2H=1 and not supported */
>
>         unsigned long   flags;
>
> @@ -1298,10 +1302,24 @@ struct resx compute_resx_bits(struct kvm *kvm,
>                         match &= !e2h0;
>
>                 if (!match) {
> +                       u64 bits = reg_feat_map_bits(&map[i]);
> +
> +                       if (e2h0) {
> +                               if      (map[i].flags & RES1_WHEN_E2H0)
> +                                       resx.res1 |= bits;
> +                               else if (map[i].flags & RES0_WHEN_E2H0)
> +                                       resx.res0 |= bits;
> +                       } else {
> +                               if      (map[i].flags & RES1_WHEN_E2H1)
> +                                       resx.res1 |= bits;
> +                               else if (map[i].flags & RES0_WHEN_E2H1)
> +                                       resx.res0 |= bits;
> +                       }
> +
>                         if (map[i].flags & AS_RES1)
> -                               resx.res1 |= reg_feat_map_bits(&map[i]);
> -                       else
> -                               resx.res0 |= reg_feat_map_bits(&map[i]);
> +                               resx.res1 |= bits;
> +                       else if (!(resx.res1 & bits))
> +                               resx.res0 |= bits;

The logic here feels a bit more complex than necessary, specifically
regarding the interaction between the E2H checks and the fallthrough
to AS_RES1.

Although AS_RES1 and RES0_WHEN_E2H0 are mutually exclusive in
practice, the current structure technically permits a scenario where
both res0 and res1 get set if the flags are mixed (the e2h0 block sets
res0, and the AS_RES1 block falls through and sets res1). This cannot
be ruled out by looking at this function alone.

  It might be cleaner (and safer) to determine the res1 first, and
then apply the masks. Something like:

+                       bool is_res1 = false;
+
+                       if (map[i].flags & AS_RES1)
+                               is_res1 = true;
+                       else if (e2h0)
+                               is_res1 = (map[i].flags & RES1_WHEN_E2H0);
+                       else
+                               is_res1 = (map[i].flags & RES1_WHEN_E2H1);
...

This also brings up a side point: given the visual similarity of these
flags, it is quite easy to make a typo and accidentally combine
incompatible flags (e.g., AS_RES1 | RESx_WHEN_E2Hx, or RES0_WHEN_E2H0
| RES1_WHEN_E2H0), would it be worth adding a check to warn on
obviously invalid combinations?

Or maybe even redefining AS_RES1 to be
(RES1_WHEN_E2H1|RES1_WHEN_E2H0), which is what it is conceptually.
That could simplify this code even further:

+                       if (e2h0)
+                               is_res1 = (map[i].flags & RES1_WHEN_E2H0);
+                       else
+                               is_res1 = (map[i].flags & RES1_WHEN_E2H1);

What do you think?

Cheers,
/fuad




>                 }
>         }
>
> --
> 2.47.3
>
