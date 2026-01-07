Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73543331A4C
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 19:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767813987; cv=pass; b=li4V0n4h94p7RMUCDXdho8wDjVBtCuDsKdySfK6xLgUq9KBTXAYk0VXwrGSpavN4w2xRQlakbhuUcM6M1+l4fXskhCSuC9vIdC9ogPkQOSBkTaSfPnLeKVyIL7RaKyyBNbJu2lENe8CEPRsTfd2S32BO6KnavNZfTuGvKaI5HQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767813987; c=relaxed/simple;
	bh=2LhpsPeSyE8bX8HA6xDr9D/rfFVNInchGx8D0QTzubs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NUpOYeM/xt2VVeuZRZ8rUxKlrZEpNKySMq7fGmkueiyw+aHQdZyOLEgrJr4XjLyACBvzut154nD0NOPaldyyI1W64n19cktKt2iiasJ72uH87ZrkRhClAmcajFdtsokE1+6xesvNrDCHOBEov7nj/+pm75kRZV+qKGXhrkdTZlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1IztLCY0; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1IztLCY0"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4edb8d6e98aso720531cf.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Jan 2026 11:26:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767813984; cv=none;
        d=google.com; s=arc-20240605;
        b=S+c0BAubnXtB1ywEEYjB22nnzD4l1hNEbj70KBtja1kv3ZTsVtYyVrIZct4v9x+uKO
         xOz0hge8krMPWTGEFvKtxA6wgIKUXq0Cbild2k0meUVWBYXZk8k0V5f7Yg9CQCOZgXW1
         vva6I0cGtRFujXp913dA1k7CNzItYteCZsOe/xwUpz+XZaDPBHxEeGGIA9pzge9Yi5Ih
         A3fYv+Kb03t9pxuEpsdtUbziqiRb0S/SJhL/aN3VhcwHjKswKmfwgwi/Yt9UGO7ul+i1
         EuwzrygtzvVTfrKACzIeNUmBL+kdN2IEFCiUiKD2w4VKgYcpseYdJB9VdQopwKJ+2HQD
         0Qww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bWQBkRucMfj+8IZule2bckxNws/YyczMOLNESP4WNJk=;
        fh=14L2b23VwWoOs0+DomKQHZ3DWo6y9NTTZHv0QrNYh/o=;
        b=Bi8G/qrAvVYOBGHsBbSkW4ZgZks6oPlx/hv+SHOshKputYHNmHY9uAKPAKQxiX+Kf3
         ld0XAM6u7R0l5YjUgrDCgZfB0r1wbSF1ZOwkp2yVOS2w6v79yzlj9ZYmOdXB2m8w1YFw
         f1McEzry3RsKtslCITv48EG++60s9ttc7mMb9ovsiCYOdk2U3VZqjAldGQDDDjijvuwx
         AqKv0/BqzQQQGg23U4pXcLoDT97nMX4elUjb6V6l6+jb0hUWR3PozSJX4dCLWSo7yis+
         97MdgaA7iBnO/ot1z97eZ228RTH2RL0p75rUjLMpiwhW3KJYQaXttmBJfbm1k1uHNZ+J
         bVFQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767813984; x=1768418784; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bWQBkRucMfj+8IZule2bckxNws/YyczMOLNESP4WNJk=;
        b=1IztLCY0CzwoffQ4IeaF+BwRhTu0wLdcc6OqCjQQPObQUcs6X8H3juA7NfYuwPYxMN
         ep4In2SkMrPu9G+Pt3DqKbLXBGSo/0W48WggGNW6xysPd3YxZ86Z18rgJeMssaYnj312
         LawoPFBUzBPD2ziTvIme6gHbBuO6bLTiACY0CzqF3P3UvUy12Q1JDS3OM3XBe23S7r+N
         j2Y+4q0Z4HiEzTaV7sV77NUGsJ6gfZ0/zQ1V90OLdNw7jEXS/ZJ7reYA0AtoJ0c0Z8Uz
         3sCR3SpRS73uO/EipPKqIVjQcq9IW8dOJEwQkLjlVwwAPLI7hbc4nfBGMjKJnP5DoGOA
         3WJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767813984; x=1768418784;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bWQBkRucMfj+8IZule2bckxNws/YyczMOLNESP4WNJk=;
        b=s1KWhMSHiEDzQP6lUwXbqpKDRNTM8KrdCfffG3jV96teviS240ENVcfmkQdmLZvJ4N
         jOXlpU7Tjmjnokwn793SqcA6eovaZXUA0VS+S3ILQzjwQ2dnCFu+5uY7yR6x03n3F9vj
         NYs6dUDKwcTeZcDb/8wwI+PYvXGtje/gG5OjQUrCh5B832wM2vxKF77mQf6AgHgm/Uu+
         Vnw5JKg9iXA+ZzmG8xKKozAuSSWFu941PFA8Def/epb8C+44/YmrpjP+2BA/3I85zpir
         KLSzCOlbZY5tljUPvNhteGtD+dSviBTY1a0QQ9+3cYDusdSi/+/a4wAFUGpW/ebHsh9G
         ER/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXicgcnE124qLfvXbctNhTZWEX7muqOcfaj1zM93LliOn4TXUEVU3IwlhJZynzViJ7Cpanx+K8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3Q9x99SEvqdlEaGBWZKhW2IYhv004kAHZ4PbS6YRWlj0IhcWf
	5+4WavODE+ZzLLDtG7KB/IHNtXQHCIuIR4gOpYrNXExVL6GtV2PT8ztNpcZ4evjpMTYXWrIgbcE
	sx1VbucUpoGmhrwaO0vNjHvh6dmcCkHA7RRBaU3pY
X-Gm-Gg: AY/fxX5UFnf+gZ/Ob7wEjjCdaJN2SQ3qCdL+j7pGBFdC1bsLNP6r+TPI0uAd0qEdlQU
	cZW9A/kpTa6+cBWEf5zzdhRq7a+DJ50FqULNgWouZPdHJkrSdG5dUTAjmG2rSj2hJrqgfVF87u/
	MLrh1wWDkZkzuLZAc9bDUs57Z5pdFUg6Ky2GaLzEPkBx7tTymmdzMbCSvQS86o0nX+cRVYEuS0J
	flkM3PZJ2yNbJzdLA37GQHkpWe4TxV8YbZtPJDv3ZfoEv31TVjGaPvUrrbFUjeBWWPB8Zch
X-Received: by 2002:ac8:7d0a:0:b0:4ed:ff77:1a87 with SMTP id
 d75a77b69052e-4ffbf94a082mr1122261cf.19.1767813983752; Wed, 07 Jan 2026
 11:26:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-5-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-5-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Jan 2026 19:25:47 +0000
X-Gm-Features: AQt7F2qO0uzZBb7qE9TqF-7WKMNBoVsC6m-23DUQhmoLKw26Bq83cmx6SM9OSu4
Message-ID: <CA+EHjTycP4Wz0V7S8hzWygpeXGzeehTL8RFfit7Eaq4rT+Eu+Q@mail.gmail.com>
Subject: Re: [PATCH v9 05/30] arm64/fpsimd: Determine maximum virtualisable
 SME vector length
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Hi Mark,

On Tue, 23 Dec 2025 at 01:21, Mark Brown <broonie@kernel.org> wrote:
>
> As with SVE we can only virtualise SME vector lengths that are supported by
> all CPUs in the system, implement similar checks to those for SVE. Since
> unlike SVE there are no specific vector lengths that are architecturally
> required the handling is subtly different, we report a system where this
> happens with a maximum vector length of -1.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kernel/fpsimd.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index f4e8cee00198..22f8397c67f0 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -1257,7 +1257,8 @@ void cpu_enable_sme(const struct arm64_cpu_capabilities *__always_unused p)
>  void __init sme_setup(void)
>  {
>         struct vl_info *info = &vl_info[ARM64_VEC_SME];
> -       int min_bit, max_bit;
> +       DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
> +       int min_bit, max_bit, b;
>
>         if (!system_supports_sme())
>                 return;
> @@ -1288,12 +1289,32 @@ void __init sme_setup(void)
>          */
>         set_sme_default_vl(find_supported_vector_length(ARM64_VEC_SME, 32));
>
> +       bitmap_andnot(tmp_map, info->vq_partial_map, info->vq_map,
> +                     SVE_VQ_MAX);
> +
> +       b = find_last_bit(tmp_map, SVE_VQ_MAX);
> +       if (b >= SVE_VQ_MAX)
> +               /* All VLs virtualisable */
> +               info->max_virtualisable_vl = SVE_VQ_MAX;
> +       else if (b == SVE_VQ_MAX - 1)
> +               /* No virtualisable VLs */
> +               info->max_virtualisable_vl = -1;

I'm not sure about -1 as the "No virtualisable VLs" value. Unless I've
missed something, this value gets used without being checked,
potentially even assigned to an unsigned int:

> kvm_max_vl[ARM64_VEC_SME] = sme_max_virtualisable_vl();

Cheers,
/fuad


> +       else
> +               info->max_virtualisable_vl = sve_vl_from_vq(__bit_to_vq(b +  1));
> +
> +       if (info->max_virtualisable_vl > info->max_vl)
> +               info->max_virtualisable_vl = info->max_vl;
> +
>         pr_info("SME: minimum available vector length %u bytes per vector\n",
>                 info->min_vl);
>         pr_info("SME: maximum available vector length %u bytes per vector\n",
>                 info->max_vl);
>         pr_info("SME: default vector length %u bytes per vector\n",
>                 get_sme_default_vl());
> +
> +       /* KVM decides whether to support mismatched systems. Just warn here: */
> +       if (info->max_virtualisable_vl < info->max_vl)
> +               pr_warn("SME: unvirtualisable vector lengths present\n");
>  }
>
>  void sme_suspend_exit(void)
>
> --
> 2.47.3
>
