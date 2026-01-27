Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C75B3242A9
	for <kvmarm@lists.linux.dev>; Tue, 27 Jan 2026 17:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769536758; cv=pass; b=KejB/ZbcqpL4V4BnGRqiy4PdTr3Op7Dyi+njlzGffyAFygwvikI+wPlt0DrYpQ4XgXIiI57a80xiHg1Cg/5X/Q/hJknmiwKMarh0Ha117fDjbDe3VRdCayT1BFlqVNTldcDCCwPRlsA3jfp6WlcdcAOctQBCh2Um03hxqYVfS+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769536758; c=relaxed/simple;
	bh=+hId3SRsn0ruZaW1Cfmoewhzbba8HuhwYa226fcimVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A4bFR/lnEzEFrky8XLssaOYzMIQCx8EXX/qP72Px6Ucj7ADFFy9uQdKBtpR+ecu3FKHBSKELxaRod6sCMHf2I7RI3hqKTCfGe0Q8DagZ6uZFf/+sXo5EzhkohJ+/bb+PLHrvW7OfZZcvAmyKIQo+g6VEdtebCKfYIGsXMKQgzsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HWM7YMKc; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HWM7YMKc"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5014b5d8551so17241cf.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Jan 2026 09:59:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769536756; cv=none;
        d=google.com; s=arc-20240605;
        b=NL0FqbpQQ8Hz8xZRyNjDK5Ip+9GJlOm9EMnUNxi9cB2QJ5ffBaI/a2gT/XTwS4DX2P
         6GH2LLX//ivBZ+k6vxYAXuG887IHUYGCpLSnXp5oLfbaXBetnLBhK52YbHjrbejx6U7K
         7/chsonwx0OFHqLIgBlsVH4DvwzGiTpt+3Zm41GPrcFbiXds/z+iEibrAuwLd6bPHjr8
         mw2EMxOGRNWoJCVHUKnx838lMmhOKfGF0myR5mhgao3EMhZrGh4laWsKQAvapanVdkRU
         89HmoCcVCXGRyNaB+m8qun8ISD+fPNDvUG80sOY4Z7bPNlkx3KjbcYpa3XUshHizn1a8
         dQeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WXQLAHVKOq8T4zWobG4KuuypQi16GgCGUfWQ2Xeqgb4=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=VHgfm0vTPZ6YvM76NiJPcGbiBprFTh6kRjMwto9CcC9GVdTaNFn2p7PuW5pWVSEPk5
         N2RgZggce65SfQohemBGFPmNmtCjQrtbmPoRhZhN7/lR7YJx7p/jfvtzmRDincV7Vxrj
         RWkmLL3UoyeBdh716Uz9xtG0zKhj2tqShrUPaoHETTWJTzyPmofIs7Y/xAPZMFSh0sSo
         Oc8B563jf7NH9xIWGACCycgnmtqJyei/lrzjSvxJ2QxzffbyLQJPkjuCpbm9OFjJS01Y
         zz5v5JqZjelo/K+xISI+OvkMex+3x+ERjIAhAvCjzKbpOJHjcjPfJbgPwz+19iu8zYR9
         MGSw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769536756; x=1770141556; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WXQLAHVKOq8T4zWobG4KuuypQi16GgCGUfWQ2Xeqgb4=;
        b=HWM7YMKchj+lWuffUDtsJ8JDYLfufts5LZ0qGqkY71U2lg5zZn7mym7GgwPrRP8ig9
         9bRNA5iK57UIh1RzQWwhBjhlvomp9std8y9Cow8CUR0oVhpe8FtBE9gQLvKCTKR0Eh8X
         TOmaoqgBHu9PLjQo1CE0Z4tA2EXJqt/ncjVCPeTy4vnmj2eX93yBEexx2tQqFNu/FbaW
         gAedn/e2Tl17rqryDKB2u67+F8OWFT41gDUaHNfHuMrUjCJK5pXPMrY0c5XUhhv0lwBH
         8GkgPMAsuX85BTMGmSblis3Eul0aZQbSZ6JuE6Pz7f/z+dgQrzxw48kWIphblf0KeiZY
         GIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769536756; x=1770141556;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WXQLAHVKOq8T4zWobG4KuuypQi16GgCGUfWQ2Xeqgb4=;
        b=MQ/lL9dA8MQ0z5GLmFXoFAjobYIJDZLeVjeSl9PQGt+2I+d8SnVZmjffozAtbTImia
         wQP6OVycu+2bcHvC2eZaa99lGJqN3BDUFDv/nRtdAMZc6i0QkqE60DPLJ6QeooYMUGom
         U1xNHY2rrXpXGvTOqj6Snu/hgaqhBDb8gymYeI1LquxapaZJAxoKPOCfuD5rIPRJyX3p
         65FicNgVnt50+/sqtSz855suB+hQ7jawhy+1GmDXOWoXoL4nEycTsp+zYb7fXf4MkJgT
         7989cpW5cN3JHH0fz5vtGqfnF8Rzep1FJeRS17T7Pvb/XCpA+wPw8Irb176L/ofIX/hc
         GwiQ==
X-Gm-Message-State: AOJu0YwWXp6yVHxqeYGuBtI8JFokmFKA2gxAUAPHST/uYtggtzPOdKeE
	iWDofALmfbqKUb1Jl6fAtMRUI58fXCS9vwaiGlLO2qja61PBTSKb0F2X7+MFOjHM+vfRTHQzGko
	O7MoGQJVvhCRpo9eyn3+L6AJntiI5cDhYV7cAv1nP
X-Gm-Gg: AZuq6aJjKjrrW44TwhD5NuuCrSpNRG389Q9thmvm6BFRp+GNquw9K2v8TAWs1XoX8Ks
	kzmE0rNmeQ0rV231EW0KgbuW6KPDSKl+biQ8xpHLkpBGE3MvWzO+0YqA1dQTqels/dupdZoQPCb
	HNnrcwK6rrzKShinf9l94AqMQ1dtfCuhf3lB1mn58Vmu7Azq5qCmXzgQacTWBpccp54EolJ8gb/
	VO7if6l6Le+ODzOt3AV8QvTLJSjIom/7pcNXNeRmFoNqZYZ+AvJt4BVS09L9AOa81hqhFOX
X-Received: by 2002:ac8:7d89:0:b0:501:3b94:bcae with SMTP id
 d75a77b69052e-5032f479773mr10069921cf.8.1769536755734; Tue, 27 Jan 2026
 09:59:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-7-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-7-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Jan 2026 17:58:38 +0000
X-Gm-Features: AZwV_QhS3T7BGI_KLXpUw2zt_uf_weVG0r6EiuX_Phs-QUEKVVf5BCeOHp72BZA
Message-ID: <CA+EHjTzU=rNQd7YU9O+ombTsZgTHgFThe6BGP20ii2xC2V473Q@mail.gmail.com>
Subject: Re: [PATCH 06/20] KVM: arm64: Inherit RESx bits from FGT register descriptors
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> The FGT registers have their computed RESx bits stashed in specific
> descriptors, which we can easily use when computing the masks used
> for the guest.
>
> This removes a bit of boilerplate code.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/config.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index a907195bd44b6..8d152605999ba 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1344,6 +1344,11 @@ struct resx compute_reg_resx_bits(struct kvm *kvm,
>         resx = compute_resx_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
>                                  require, exclude);
>
> +       if (r->feat_map.flags & MASKS_POINTER) {
> +               resx.res0 |= r->feat_map.masks->res0;
> +               resx.res1 |= r->feat_map.masks->res1;
> +       }
> +
>         tmp = compute_resx_bits(kvm, &r->feat_map, 1, require, exclude);
>
>         resx.res0 |= tmp.res0;
> @@ -1424,47 +1429,36 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
>         switch (reg) {
>         case HFGRTR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hfgrtr_desc, 0, 0);
> -               resx.res1 |= HFGRTR_EL2_RES1;
>                 break;
>         case HFGWTR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hfgwtr_desc, 0, 0);
> -               resx.res1 |= HFGWTR_EL2_RES1;
>                 break;
>         case HFGITR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hfgitr_desc, 0, 0);
> -               resx.res1 |= HFGITR_EL2_RES1;
>                 break;
>         case HDFGRTR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hdfgrtr_desc, 0, 0);
> -               resx.res1 |= HDFGRTR_EL2_RES1;
>                 break;
>         case HDFGWTR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hdfgwtr_desc, 0, 0);
> -               resx.res1 |= HDFGWTR_EL2_RES1;
>                 break;
>         case HAFGRTR_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hafgrtr_desc, 0, 0);
> -               resx.res1 |= HAFGRTR_EL2_RES1;
>                 break;
>         case HFGRTR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hfgrtr2_desc, 0, 0);
> -               resx.res1 |= HFGRTR2_EL2_RES1;
>                 break;
>         case HFGWTR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hfgwtr2_desc, 0, 0);
> -               resx.res1 |= HFGWTR2_EL2_RES1;
>                 break;
>         case HFGITR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hfgitr2_desc, 0, 0);
> -               resx.res1 |= HFGITR2_EL2_RES1;
>                 break;
>         case HDFGRTR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hdfgrtr2_desc, 0, 0);
> -               resx.res1 |= HDFGRTR2_EL2_RES1;
>                 break;
>         case HDFGWTR2_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hdfgwtr2_desc, 0, 0);
> -               resx.res1 |= HDFGWTR2_EL2_RES1;
>                 break;
>         case HCRX_EL2:
>                 resx = compute_reg_resx_bits(kvm, &hcrx_desc, 0, 0);
> --
> 2.47.3
>
