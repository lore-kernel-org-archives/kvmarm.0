Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DC61D6BB
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 14:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783865596; cv=none; b=j2KCJiWsgD4mr/w97U+A/+fkzAIjg90eqD3rvTVmdEUrkpVY12Yz53Qc+KYViWsya1EV5FsbcljTX5QSNah4wWgaP8JZYMlDM8PiaAeB9rgZanQnqs1wwCSiHrrLzYFc427idRm7XwmXtTE1y2FXIH8H+5P2Xs6/cWpXy2RBaqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783865596; c=relaxed/simple;
	bh=ejdi7iYQA+ytgEIjZT9BxqaXX6cf7LcuuXiPTf16R4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hM1xvCf+um/ECxX3A6K3z5unsUU85AmHwwT6jj9VOw5LQDiEY7Ds+eC7mVRG9b34rSl5RJ0jQF/byjeSnLy24Aymf65Chx9qlsXYv+VxBZfFd4WljsznXg1KpNUfCzfhROgmhRnrUcx9h6BmKIG8h4noe29A9dFV84BtTQbsmno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qjmMy78X; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qjmMy78X"
X-Forwarded-Encrypted: i=1; AHgh+RpmlEeWth9J8kEtyLGMlCH/pCqVoKO1/AoSE2uXtsI/Ksj5hzfkOj5sdBxFbxR0Hl6ZY/CGoAc=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783865593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q1p8G1qx/myCB1d4LebeVFWlONzgCOT5j0oP6baG9ro=;
	b=qjmMy78XKcJ/uVmA5b6iWIT+RHw6rLt0mcj/XzqnF9Dw26EtM9iCrt0nArqtpPaKClUS84
	FW9QffZLMcfiRSGFJCFr1Ju1JqS4AslY1IPJyUKy6kIv97Ofv5S0yCYuB5XTTPXZiYyIYq
	SB7Oa6f096AJ0p8oeK3RsdQBUOhJUaw=
X-Gm-Message-State: AOJu0YxdTZhjYlgL3GlvGfZ5dg45Kr34jOrRe0vv3lqPwCeNdRp96hz6
	X8uad2YdhnVNXa64e2Lhb4bTpe12GTsxQkiLkw86knpWxp7U/0F3De1Hfqd2VmuqGSAB50nOkCo
	Eo7IHiUeYMIw/kSepnnX5pOqnd3qnfUzJxbiGx5CG
X-Received: by 2002:a05:622a:2445:b0:51c:7a8b:c401 with SMTP id
 d75a77b69052e-51cbe52b8cdmr11059291cf.26.1783865588787; Sun, 12 Jul 2026
 07:13:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org> <20260709-kvm-arm64-sme-v12-4-d0301d79ef58@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v12-4-d0301d79ef58@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 12 Jul 2026 15:12:31 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzVLnXu1E3guYVABoxLLE4foTM6j1fdew-phtFrBqJ2Fg@mail.gmail.com>
X-Gm-Features: AUfX_mw_6gUrHc1w-6H1pc7a-cqHr6VwfuBC29l_JPEHSqk3sPWCHZfRDSEVflg
Message-ID: <CA+EHjTzVLnXu1E3guYVABoxLLE4foTM6j1fdew-phtFrBqJ2Fg@mail.gmail.com>
Subject: Re: [PATCH v12 04/29] arm64/sve: Factor virtualizable VL discovery
 out of SVE specific code
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	Jean-Philippe Brucker <jpb@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Peter Maydell <peter.maydell@linaro.org>, Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Mark,

On Thu, 9 Jul 2026 at 19:40, Mark Brown <broonie@kernel.org> wrote:
>
> In preparation for reuising it for SME pull the code for discovering the
> maximum virtualizable vector length out of sve_setup() into a separate
> function.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kernel/fpsimd.c | 41 ++++++++++++++++++++++++-----------------
>  1 file changed, 24 insertions(+), 17 deletions(-)
>
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index dc1ad10e39a2..5c156e2a47ea 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -1114,6 +1114,29 @@ int vec_verify_vq_map(enum vec_type type)
>         return 0;
>  }
>
> +static int vec_virtualisable_vl(struct vl_info *info)
> +{
> +       DECLARE_BITMAP(partial_only_map, SVE_VQ_MAX);
> +       unsigned long b_min_partial, b_max_virt;
> +
> +       bitmap_andnot(partial_only_map, info->vq_partial_map, info->vq_map,
> +                     SVE_VQ_MAX);
> +       b_min_partial = find_last_bit(partial_only_map, SVE_VQ_MAX);
> +
> +       /* All implemented VLs are virtualisable */
> +       if (b_min_partial >= SVE_VQ_MAX)
> +               return info->max_vl;
> +
> +       b_max_virt = find_next_bit(info->vq_map, SVE_VQ_MAX, b_min_partial);
> +
> +       /* No implemented VLs are virtualisable */
> +       if (b_max_virt >= SVE_VQ_MAX)
> +               return 0;

nit: this is a reimplementation rather than a straight move, the
no-virtualisable case returns 0 (and drops the WARN_ON) where
sve_setup() returned SVE_VQ_MIN. No change for SVE (that case isn't
architecturally possible), and 0 is correct for the SME case this
helper now also serves. Might be worth a word in the changelog, since
"pull ... into a separate function" reads as pure code motion.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad



> +
> +       /* At least one virtualisable VL exists */
> +       return sve_vl_from_vq(__bit_to_vq(b_max_virt));
> +}
> +
>  void cpu_enable_sve(const struct arm64_cpu_capabilities *__always_unused p)
>  {
>         write_sysreg(read_sysreg(CPACR_EL1) | CPACR_EL1_ZEN_EL1EN, CPACR_EL1);
> @@ -1125,8 +1148,6 @@ void cpu_enable_sve(const struct arm64_cpu_capabilities *__always_unused p)
>  void __init sve_setup(void)
>  {
>         struct vl_info *info = &vl_info[ARM64_VEC_SVE];
> -       DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
> -       unsigned long b;
>         int max_bit;
>
>         if (!system_supports_sve())
> @@ -1149,21 +1170,7 @@ void __init sve_setup(void)
>          */
>         set_sve_default_vl(find_supported_vector_length(ARM64_VEC_SVE, 64));
>
> -       bitmap_andnot(tmp_map, info->vq_partial_map, info->vq_map,
> -                     SVE_VQ_MAX);
> -
> -       b = find_last_bit(tmp_map, SVE_VQ_MAX);
> -       if (b >= SVE_VQ_MAX)
> -               /* No non-virtualisable VLs found */
> -               info->max_virtualisable_vl = SVE_VQ_MAX;
> -       else if (WARN_ON(b == SVE_VQ_MAX - 1))
> -               /* No virtualisable VLs?  This is architecturally forbidden. */
> -               info->max_virtualisable_vl = SVE_VQ_MIN;
> -       else /* b + 1 < SVE_VQ_MAX */
> -               info->max_virtualisable_vl = sve_vl_from_vq(__bit_to_vq(b + 1));
> -
> -       if (info->max_virtualisable_vl > info->max_vl)
> -               info->max_virtualisable_vl = info->max_vl;
> +       info->max_virtualisable_vl = vec_virtualisable_vl(info);
>
>         pr_info("%s: maximum available vector length %u bytes per vector\n",
>                 info->name, info->max_vl);
>
> --
> 2.47.3
>
