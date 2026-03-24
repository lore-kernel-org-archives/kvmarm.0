Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D086401487
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 15:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774365271; cv=pass; b=eFvDm4AC68WnRD7KXnhRgKXIwxILqs40lvEwX2jUcIWDUCq8AQ6iLQ84lA2NS0X1/7V2eOnO/qD30D+/lCQAfB4MUMKpZ0xf1PSiMwodvcb3qXVvRpKFy3xgGEhLegt4ngA+k/wIxSPMLokTAcUnyofyZvLlAs/0Sb+OILk1IgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774365271; c=relaxed/simple;
	bh=e2ywZe5l+2hlBbLalnlAUysBkNhUX4IrgPkQZd56AxA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mkg7LF2YfSsktBXRIyjiWfCI6zoH16j03uq7/pW6uI1SUr8ZamvH1waPyj1Z9gxQnXw6U+sEFFQowiCvjTNdctwuqkrM2mTVtMYYJ+/RO+rM3x3nq8MSdb4cM2K99O8tWhfgN8rUNQssYryedqcbzhSweVv3vl1YTn+i938gCew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O45O3Md0; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O45O3Md0"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-509062d829dso616551cf.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 08:14:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774365269; cv=none;
        d=google.com; s=arc-20240605;
        b=IAjfkwV/D6gD2IASBdSVSbIn3Uk7OlM6VEY2hvD6+VbXw0ATfE7u5JqA0FLS/6RR3F
         yTrMekFeRjaHhW6qFdVi7NIYbmWA8922zDSvVQ9Dq0dlDcEtJGu8FFVyEeDhBe7QqPdb
         6rws+BgCti56+hBB/GnLt3vcnO1FUwDs35/jKA1XkTc5KL1xeBjoC4syjYXgFafE7JXL
         7LGNcb3b9SrNiJrACC7OGp2yBk0IkB78GZMm8PyVVSSLuJV+nCDgL6IbYGvRTeE/ee+q
         1tv3kifdeLezMBFiFAmeq8Cs4iYner/hJXF/kjVG7XqNk6Q8pInsyam+x7HFSSK9zruF
         gCNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OHhlIbgR51v0pWgOdMRItIhO1Sy0NpL6OXQHGCDdAtk=;
        fh=iZaa2om5wWBJWFLntUfbMOSst+i/AFLdbQldp22Ec4E=;
        b=KPMtWEqYK45CBfZLRFoB+KZKG3iPqbzdXIbxRFZQEYSsFnIKkncV+1TpRWLI6a/iDk
         JRevT0W6dEdBObl0ONkrvuojwIzGhHcHUMSbGC43Y0fm9627cdXQF3/JGLFC/AMaLNem
         mukrdA3w55tXrieQHSc0c15yOJtwN8v2eawVmlklmH0xXL14ciIinvOrdO9mU9X/gO0z
         yTyYzrNcEsybAKslL3GaDt4OG/54C/CI/jCySwx6DpErMvxP50O0DyWr8F3Otv3luTUf
         5W1/RfQaezrWnUaQh5mS/UJufus6TgUr/BAjyck7Zbw3vdVVexQCMerZoTeQ1g0uT1FP
         6gSw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774365269; x=1774970069; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OHhlIbgR51v0pWgOdMRItIhO1Sy0NpL6OXQHGCDdAtk=;
        b=O45O3Md0OpMdBQ9kIvjF8oOomUxZEoEHtv2rDPezuYEdq5Jb4XikYgRJpV23sMYl/o
         8vKAMj+rDGQ4g+AhC8v22tLVuULq3XJI2yM+i65Or0pN+ddodYx78jZqYDV9kDUIAuf4
         jKXSg8gMFJAJ80WtoCQIFlt2OwNOGYUFIDsexzGsBmPWHMe8P3IAev4h6Z+GctTqvpan
         kMzbAF3swNI7+AC4EdYxB6Fxg+nGMsZiMUsqz1qqe+gA1mLsDH5qTmVk9//uNGOtGtFE
         Mxi6JuWXO1UVaqfCxe+RkngGeUsIn2WmIzNiCc5LqWBAI+PsoB1KCctdMpNCLFCRsU6T
         0u8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774365269; x=1774970069;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHhlIbgR51v0pWgOdMRItIhO1Sy0NpL6OXQHGCDdAtk=;
        b=I4/nJf4bVcmDr/WZtb/OPnW2989IOENB/ftwqXk/KQjLrpkUcQDzC9mydThZFkJRN1
         50nDrF0WusBuhCcGvNGCCV8u5786/zrSoO0RfqRHfEd0JMGPvOiqqh3UPfmzEv1Hhe59
         8BEpKe/8k+vVNjMqBYQq4BVfSQ+cFY6UPkBz0m7mSNRiqt8nzqmmrGYQpz2e2FyKIZ7W
         TZKNpMoaVTpKF1R3yjg/yoW5ASMR3Z5QiLAGR51B5UW45V+gO9NNOJRXRCSB1z69IK3O
         2Ksw50MYhZd48k6s3Bd2LuKFzr8dIiYKDxDsR0hvGH79+nTC+t7i7zqwZtyR6mG9p1qe
         Vuow==
X-Gm-Message-State: AOJu0Yziwyojwc+9GL+w6WGia9RBIv3qY0Xf6GltbIFxtuKVfG7CM1UM
	ed0zOHCbOXc62qJIkdMOn6QNiPpgHjYPzUQB1mdsK0fOAWg8OD/cnoC4Yaz6NQp1Qa28v0evjaJ
	dGctqLcHWjt5d/0RcUYPfnv+CF8Yi7LozA1jZH80B
X-Gm-Gg: ATEYQzyRHHY+p+YYUDngqUoO2GtqftuiyMSQBjfEPEixNqEZpSdkQDilS6t0+gq4Sp+
	iKfbKFcpGnHrCGPqiKbnKHAHMZofw6pLTsMos74TaoAtDQAfl6kcE7lr40a7QygUrx2UdW6urzp
	fyVp8Lq5Af2Jq3THQkRJKmNemyWD6OFVnEnTKfxpANfE1kMCck4hZGGgEfUML6S3yRuWi1fNgGf
	A9L99EZ3KvJGAzMPdL76zoyEHQWmfvdSGIUsRyJQii44vOHxhIZAS825blHU8Zn9zRnIiSWp+PU
	3OVgrgaagS0ugoJ3omJQBq8/qIE3J87TWaVubrzGcn2CkQ0=
X-Received: by 2002:a05:622a:4d91:b0:509:15b6:f69f with SMTP id
 d75a77b69052e-50b6fad61bbmr17131941cf.2.1774365268527; Tue, 24 Mar 2026
 08:14:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260324135728.3532400-1-sebastianene@google.com>
In-Reply-To: <20260324135728.3532400-1-sebastianene@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 24 Mar 2026 15:13:51 +0000
X-Gm-Features: AQROBzATxAiMLCKzmxNe09xoPDaD-5DeEa4L_Kx89Id0GO_kSoP9AtUg-97MxTQ
Message-ID: <CA+EHjTycaE363WXD1f9ztYv9cTe9xeo-3FQ2Ep0aVO4592XGtQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Inject UNDEF when host is executing an smc
 with imm16 != 0
To: Sebastian Ene <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, android-kvm@google.com, catalin.marinas@arm.com, 
	joey.gouly@arm.com, mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, 
	suzuki.poulose@arm.com, vdonnefort@google.com, will@kernel.org, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Hi Seb,

On Tue, 24 Mar 2026 at 13:57, Sebastian Ene <sebastianene@google.com> wrote:
>
> The ARM Service Calling Convention (SMCCC) specifies that the function
> identifier and parameters should be passed in registers, leaving the
> 16-bit immediate field of the SMC instruction un-handled.
> Currently, our pKVM handler ignores the immediate value, which could lead
> to non-compliant software relying on implementation-defined behavior.
> Enforce the host kernel running under pKVM to use an immediate value
> of 0 by decoding the ISS from the ESR_EL2 and inject an undefined
> instruction exception back to the caller.
>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index e7790097db93..ff6a90a4a4c7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -756,13 +756,18 @@ static bool handle_host_mte(u64 esr)
>  void handle_trap(struct kvm_cpu_context *host_ctxt)
>  {
>         u64 esr = read_sysreg_el2(SYS_ESR);
> +       u16 imm16;
>
>         switch (ESR_ELx_EC(esr)) {
>         case ESR_ELx_EC_HVC64:
>                 handle_host_hcall(host_ctxt);
>                 break;
>         case ESR_ELx_EC_SMC64:
> -               handle_host_smc(host_ctxt);
> +               imm16 = esr & U16_MAX;
> +               if (!imm16)

Do we need to introduce a new variable for this? This isn't easier to read than:
+               if (!(esr & U16_MAX))

Also, we have a mask for this: ESR_ELx_xVC_IMM_MASK , please use that instead

Cheers,
/fuad



> +                       handle_host_smc(host_ctxt);
> +               else
> +                       inject_undef64();
>                 break;
>         case ESR_ELx_EC_IABT_LOW:
>         case ESR_ELx_EC_DABT_LOW:
> --
> 2.53.0.983.g0bb29b3bc5-goog
>
