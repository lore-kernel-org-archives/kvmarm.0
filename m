Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473EC330679
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 18:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769450729; cv=pass; b=jlhUZmS0m2Z2z6IAhOlqKgRw1eV0KkGDx5qOgm2YiU2s22svlfHHs0UmKNNko3sF2QdmYLmjLjWciY7uS9w4q2ltgEsQ3E4Dr+Ku7C6UfAy6/Sf6x3gwXmB8CpSTGkqQem1Svo4r3gHa9hLym0P0B7HG/2iex5R1VKU8Hoh/i8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769450729; c=relaxed/simple;
	bh=v+f8FvwBFg7dDGHKP/QYFcL4Q1S4zs4FWdHw639SGDY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hk9DYonK2vUtxSyMUJOFb7zMVa1DVI+FQNYqzx2cDnAvsjEUDgocx5lc6t+YolsFKBc1RqM7ZjmHBT8jd0Uu0JY5hEXn/1zmYApJqUE7c8Z6kLJAeS22zrX/4GzViBccg/M+Hanvus4mxQyZvpE9fM1HVfkOHOFvDNNMcgUXQJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KayzAQCe; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KayzAQCe"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5014acad6f2so12021cf.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 10:05:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769450727; cv=none;
        d=google.com; s=arc-20240605;
        b=RhEWfXPkZeAyvOKYgR+YOWwlP/lIo3q1mbY/Q5cEkQSbFx6XmpBcWwfMY6KwjQYBJv
         BAxn3i+t2dhlkNnP7oB1t4T2SeTMdk80+wzHb1jhX55oqtO/v2TbdXhFVgYDWXwJ/aPX
         aTVTMdYGj/WpQGsBxVqOx8iw87l37IvthUEngbRZ9JVrtBIHmyBYC4W1J3l7pzKxx4dO
         dg+bwC+8yKRpIHM0hRrKYp/OgAVcsx9rzxeoTC+RAzzx28bff1ITeZ3QaK8lnsDovI1Z
         KSGbktxw25q1MS9dEjcMw0kg89HMVlxbteiHGYADnNzPDJETyZATxVU7Wr03jf5lIex8
         aVtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=k9sW7exYhXYo5b3X/iX8Xd4kSUfKtlhUjch+6299QS8=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=hTCYvzAaVjbiP5MV7RFQK99ws7heaFe7frnKA/ScjF7Zh658FWofLUaMliPpnrij7p
         JVOWinVlygPO03RaPEQ0jeQu3AZrSGAhEGcFWDIHvr2So7mfQ2qD1wU45kFxJVe8hWzj
         q8xlgxi4F83dLcIfAZHojG+jQtv5cH2kqB7eLuPVAtBVoM7a1wDKQ4L5fFYiu7a7cKG8
         YyvyIb3H1POxARROt3t4xUNdznoU2RH0o50td9ezln/LL5NRtebLQYr4/DdbZJ6HmL/F
         0z29Zm1SvHfTlISz0l23gYvET4kvSZCQGTN0QzTsysvExznc22RxLxUx5Du7QS5kn6LE
         uD+g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769450727; x=1770055527; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k9sW7exYhXYo5b3X/iX8Xd4kSUfKtlhUjch+6299QS8=;
        b=KayzAQCeO+x5rm/PwQ1LPE2FeE28g942+Dpq6LO87eFDnueW1bxU7v32oyfnhuOV+p
         0RcrYM+9+ePeVezyYsSiiJdTIALcRswy9bBxwCEi3OQoaKL0wZo9sn9fUsKeCzoEin0R
         e7xxwUrHd2j6B/yYXe3pf0TM8IcH2UZoqpPy5Cx2F8ehZGAfzgogNdS/t9rx6Bf+qhSH
         YsNirsqm42wN/s6QWGnau1S57RHflS/1/5OgZ+xiBxXgVB1+R0XSM5ObqyRfO6xT+6Ig
         6RbCDXWTTaLzEaxDePUG+eUSfoYDwwyRkYnxYpLnsBsU+mHhcMXVHbZmBTray1rDVH7M
         0Ndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769450727; x=1770055527;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9sW7exYhXYo5b3X/iX8Xd4kSUfKtlhUjch+6299QS8=;
        b=A6rT8kuGol1U32j+ogZnY6yYC+BuP3X++Am2JsaHtQrBU+IFO12tevIgLgN1TpC7L/
         BDHS12ySxAzg0z0czp1OR58RQy7R3x95RMU7FnK5L7P0WpdPrVhaec8SkpjGXxhYpr+O
         lDCexme8ybHCC7X4kL+r4mvXvvFTnC9Wfwhpr5bIq7nTkUNHfYqk1Eu3lp+BdCFE++JG
         ug68Fgkd6u1CqZoZ4xHlVsXju15HhLb6R1UE8oAEfGiCgZOqBEH9Hj5UytHZXx4U7DkN
         sFsuG5kHf0LYRNAe7yqTdNzSaNHbASJY+hUke1T4M/5MPO4cnJrcysZjd4DZn7cKrig7
         Z7jg==
X-Gm-Message-State: AOJu0YyfF8HOPLSzybRP6sRsxtjv1BP8I4Gt+WptWwNb+x443LtWttVI
	+g+HdQvnMGXTHYryFc4V92SAKcGu99SB3CAOyqVnZRNFp0Pk+nI4oL2Q4s3p+u37tXZSI3WETk2
	U0qL16f787AEwe5SzSdq/hLklXX4q9z+tBLbVWsYU
X-Gm-Gg: AZuq6aLVfue5BqMgPqdqE1kjFEJpKwG3vRdEywdXhgEEn1x2ps9ToN27mvgodQ31SIX
	keR0z4htf27OGX+XBfrmg64mVqv8b/SH6O+q8MHkeWmjjiAmidsJZXUlI9Eg/F2qcQLQ9E4Nyae
	KUkJvHRBa7vfW8anTrFo/MzA8RPDoy6ZFtwYh6NN9UnhQwM1MO2WTdrCsJUlRK9GV3gfJI8WZ7A
	6/piVZ4tm1slK6tzmryfXkKWXrJWWn5cw3Lb4VKzEWKiPjhuU8/FaRmg6PgxFAXq3H3qK6saayR
	1P/CtkA=
X-Received: by 2002:a05:622a:1214:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-503142cc142mr12796471cf.1.1769450726757; Mon, 26 Jan 2026
 10:05:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-3-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-3-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Jan 2026 18:04:00 +0000
X-Gm-Features: AZwV_Qgr9raUBYRUZBfOH_mHnPcBMFzt0yhWhO3RKbwtE7BDMNNTotzOUCwDyNg
Message-ID: <CA+EHjTynFzZK5APC3LRzNbTC8RrtcavBE5=aqwg5a8CCp+oBhw@mail.gmail.com>
Subject: Re: [PATCH 02/20] KVM: arm64: Remove duplicate configuration for SCTLR_EL1.{EE,E0E}
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> We already have specific constraints for SCTLR_EL1.{EE,E0E}, and
> making them depend on FEAT_AA64EL1 is just buggy.

Looking at the spec, I see that they depend on FEAT_MixedEnd and
FEAT_MixedEndEL0, not on FEAT_AA64EL1. They are already in the right
place in config.c.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad






>
> Fixes: 6bd4a274b026e ("KVM: arm64: Convert SCTLR_EL1 to config-driven sanitisation")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 9c04f895d3769..0bcdb39885734 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1140,8 +1140,6 @@ static const struct reg_bits_to_feat_map sctlr_el1_feat_map[] = {
>                    SCTLR_EL1_TWEDEn,
>                    FEAT_TWED),
>         NEEDS_FEAT(SCTLR_EL1_UCI        |
> -                  SCTLR_EL1_EE         |
> -                  SCTLR_EL1_E0E        |
>                    SCTLR_EL1_WXN        |
>                    SCTLR_EL1_nTWE       |
>                    SCTLR_EL1_nTWI       |
> --
> 2.47.3
>
