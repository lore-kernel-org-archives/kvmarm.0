Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC2E3164C3
	for <kvmarm@lists.linux.dev>; Tue, 27 Jan 2026 17:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769536766; cv=pass; b=MxXFvXZLPgVceRL9uWitP9WjMndlLXnr2AMJqTOiwFyJkC8+iZPakuULcgNOpX5SpJKI/N09aHY7vl5knkM6vf9lHQH7jb5Qb8PwRsPYcAzpWGyrVEjxmFw6PwDGjbsMvvEUYa4ViEsjGPvd/0CHcDlFkl+oWKp/5HdTVcJ07hc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769536766; c=relaxed/simple;
	bh=LuYLHuhCerbgSFOxdxa54N8FGEdtX2o0/IlNWz3mAEY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MBVLwF6KzO+yKxJyN6oaR0/BKU3PjD9X4qbsLmrkrV2mAZT3mP4puNFojc/Hg/nCZT2ZZQOkhxWuv2HG1QUdcrGA9R5NXzagQoX5xQkvcKm4fmIn2S37bpcwUUCxfbGTGioUe/sRWvyV+Z2B/VDc/TjFG7Y+urPtTG61aYvZ1Hc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FpBn/H2U; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FpBn/H2U"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5014b5d8551so17391cf.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Jan 2026 09:59:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769536763; cv=none;
        d=google.com; s=arc-20240605;
        b=GApgs/oqSmeoaHECHd09dadXpnMZWVSrHgW2pmuzJnf1NJzSVwpMkbhDV+fZhZouXu
         oknvdVuXLi7dR2TnRvfzW0Sj+/j1j0LGNTrFwIAEggWv0gyyacOYupgrwkJm/jtZu/1K
         zq8Dre68qE4xMnzIj9wSDg0CDtX9NzRYQxLoJ7AQUbDPPSbq+WcOXvTxSDrSguX86AKR
         WT2zwomfP9H1NVNIvnO/5EXGzrwqXWQrn4r8TgGY/a6gmgHnpVD6b9u9NS8cdOo0qtLv
         1kYy8JDvhC6jBUJWh9tLIfL97LvjilGD+aAsAMXtsdtVFXvTJZys6pmT/vTS5bDSehDC
         VUFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UOQZvYTAv//pcJPda837MTWpR+PvpurRjquFigTQ1OA=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=Ho+ZlgqnnkT/mTNZYUI8KTnEtlr9f1Sv3ZDLjkRUnmgpfJCy8Hr5QKGf3qqa4Xr5gl
         sbwLkTeIOLbXdJkv4CmRTRm2/jJFVX/l+ZWLgSXJwagetb8hmTWMCkoyLRMJ1OR9BPPW
         Uf5KXJM3Gpdxou8Q3TRzC89uT4du4nXAnWqKWBkkU+W92HQHjIUJGp7EmjGfqwATwpkz
         fg4YHmqgl/I+35aTlSXGieyke5wBK9mwQ7Q4R+h53onXGJNdyRkjVbiP3LgfwpbsXLEG
         Cgio+P0FW97AO3LPRKkFSpv0rCO7+dad/XUF1m+OyLe/3ZioTN99LIoYUjnL4A00mMa2
         EmQw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769536763; x=1770141563; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UOQZvYTAv//pcJPda837MTWpR+PvpurRjquFigTQ1OA=;
        b=FpBn/H2UgOoEiAhsdBki03c5dIcyHTqmNaTIqMp3usdm6nw2x0ieyPJOckNFj2eFuY
         iF9OV0ZTolwoxjvBWQ9iwpf3+4SIGVQDseiRH5is+E9psbGN2CbKwNGba6JIpa3gn4hp
         DdPGjhC8D3mtMyNoW8PAHcstfYipti+qA7VzJTl8xpnITLzoZN+plWVnGw+skNo4rIhf
         3jUHLcYTtvzCtw7a/v3GLPfnet5G4OkrCnhJZG2WADN8hznZrSW7cnH/Zh8TpZK/REN4
         6s90gC4S3N8kC57cd9VVGXUqxlmukYL76IyebWcPCaH1yjkPd0SWg0DspFtXBmD1jGKJ
         8a6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769536763; x=1770141563;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UOQZvYTAv//pcJPda837MTWpR+PvpurRjquFigTQ1OA=;
        b=gY8GU3lN/nfNEFP2I9wUojGFiQc+RN2gN+v4stPCXwrxtaacjMtsOOIo9aZFZURton
         XQQI/KKzaiUEfDeF1GtdkdRW17czy4xI5ltELMeRzl/7kjEDbzXB6ZXxdrycJm6qrfUR
         hoCk38x4iKQbJGK7s1eyVtXSkkf13cJYTbCc6t6XjZo88ULDf6p6Ql1pL4lHOSsevKSJ
         +jlbnuPXySyuwPCCnnl5ztD/yRpo2NNM8ObSALiNNqH8qfobCi3FJRgJhMx32rSw1Ekg
         bp8uCq9H13ootvh4WDL5ViXz5sSScwmJOWdqaVOuXYiuWXOSQ/2roxzsA8dQGBSwcwPk
         MQ2g==
X-Gm-Message-State: AOJu0Yzd1UDcDU9rwS2NJWt3HEBMCOigAjP8LOAgf7wczWB2uLl+piMJ
	GKEOtJ9F9d/KaaWnIV0ItGCHuMSDp0krf5tlQ37+IwKcuHNZK7JeiMH/w1BasUPDJKGytOHnDbu
	cpuOOKu1dQLUP1yyyStEu5iClgdqzyPY/DFH7gl9Hx8rCV9K3M/KHYZyl
X-Gm-Gg: AZuq6aJVjA8rmylHNtD5HnHWCTxcLJTkVB4tZT8VBZAFj/reOMLoHn9jOZzkeIBRQfA
	HHJlFR6CukIDWO6QdEbTbVp7q/kuNR3vekeY4NrycnlFmaeGNDD39BnnO63TYRxCEqnDUNJek8K
	pwfNwdr1bUibUcJ4VLedC6L7QCObLky6d0Ye3alhxUIIJJXevh8+Dm1Pce+UXkskBQITo6WAK4D
	r3KgEsoXCHLD8DdBr3oVT7HGdRNP+WI/fCMjLmASefZPFX+WTNiWiBkUvzZbyfKs/6f5ho5
X-Received: by 2002:ac8:5acd:0:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-5032f523d2cmr9890351cf.17.1769536763293; Tue, 27 Jan 2026
 09:59:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-8-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-8-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 27 Jan 2026 17:58:46 +0000
X-Gm-Features: AZwV_QhifucCrTaCB27apGhiPavJg-rm3JFwqkfMUM-JyXvNsgDNJJ3r6uYLx6U
Message-ID: <CA+EHjTzk_0n+Z3+WmHz0no+dJAcAxCtJgQFFs9hHG4WAw0rX=A@mail.gmail.com>
Subject: Re: [PATCH 07/20] KVM: arm64: Allow RES1 bits to be inferred from configuration
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> So far, when a bit field is tied to an unsupported feature, we set
> it as RES0. This is almost forrect, but there are a few exceptions
> where the bits become RES1.

You need to correct forrect :)

> Add a AS_RES1 qualifier that instruct the RESx computing code to
> simply do that.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 8d152605999ba..6a4674fabf865 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -24,6 +24,7 @@ struct reg_bits_to_feat_map {
>  #define        CALL_FUNC       BIT(1)  /* Needs to evaluate tons of crap */
>  #define        FIXED_VALUE     BIT(2)  /* RAZ/WI or RAO/WI in KVM */
>  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
> +#define        AS_RES1         BIT(4)  /* RES1 when not supported */
>
>         unsigned long   flags;
>
> @@ -1316,8 +1317,12 @@ struct resx __compute_fixed_bits(struct kvm *kvm,
>                 else
>                         match = idreg_feat_match(kvm, &map[i]);
>
> -               if (!match || (map[i].flags & FIXED_VALUE))
> -                       resx.res0 |= reg_feat_map_bits(&map[i]);
> +               if (!match || (map[i].flags & FIXED_VALUE)) {
> +                       if (map[i].flags & AS_RES1)
> +                               resx.res1 |= reg_feat_map_bits(&map[i]);
> +                       else
> +                               resx.res0 |= reg_feat_map_bits(&map[i]);
> +               }

checkpatch is complaining about whitespaces here. I can't blame it.

With those fixed, looks good to me.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>         }
>
>         return resx;



> --
> 2.47.3
>
