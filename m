Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985F621FF4D
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 13:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774617851; cv=pass; b=DO5YBKrO1k9CNuFoM4uif7MtM9a5blRQj8AJFrvf0wDfVJOKRKMciqtG9BPBFEVtiMkyj2SRr9dvDkqAJVN7zvjFeL/aH8em4UN9jtTv7HNRLV5+JZ2VzInsK3QVQZFqAxcgFYW7Dqk57etD8+ntRFfDj1JJ0CEytjf0LvsPgPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774617851; c=relaxed/simple;
	bh=yesB6Plg3RuXeSkpEjhOxrxY2X+FhhhzeDC+5seUcS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IOUiv0MFyQisa+uGwTMfCnzOrbUKvX06GmP0KdXXYUo5jsjqhJYXaVqPzm5CPS9xZ9Kl8fZ14x3jRdu6PhMDhlJ4iSKraXsrK3Xp6earUM4wKJ3oLCfteQZtMdcYlpf/KJq9Usay/qFnK3ImnHpHPaEu9vq68d0PQxIL9Z6ep94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hdaDzckD; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hdaDzckD"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-509062d829dso476891cf.1
        for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 06:24:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774617849; cv=none;
        d=google.com; s=arc-20240605;
        b=iE2yCHdgup2TMctZHBoytTlCblCRM8yUkyTly6Gx41RQS6SM8JEdPxN9IGongSwMaB
         Kfb2TW0q1UzueNR4hoCDfevkvVHOJD2xssEEDtGib65y2+me2ORbvzvyAwFpyV7leAkM
         or44OXUEzKykkP4MbJn98Qzm+jnd4F7jeDwgG2XxQ5rhZ6ZAZdxjXnUggw597hN7xUo/
         8are2NkI8QmZkylACMwk4xruflMtUjjgA5QYCkilduqnC9w9fd2eJxtdhs7t13OEDJ2h
         B+lb9xIRl2/wOhYVBA79FNUSKR5MriVgeOXh92Sm0Kqnc4z4KMlflShAkChkNdO37vGo
         sYtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5bY74UhjM4gzlwNhf6XzZKBW5M6iBaLhGIe7w2cyyBQ=;
        fh=WXifrakrhHpMKuV+YM1LZ/K83mZPglPFmcpcPxsJbCI=;
        b=W5VSCBGrIa5vu05taiFumDe5dgijcEUygTXfQlRdAZ+ocgireBmHcndmaqA7cv3dk9
         6mhNAO1XyMW0YnhUMpk+JFNpStKrgfp8puw/cuuR+ew3sBGQDvZYfBMkNh9Wx2ngyhZD
         NVbzuZgnhqQ39kKv5rRUhK4mDQBbB4eSakWN5LuAXwD+QZn7zeExWbvAFSjrWYBo7BYB
         /gfGGkciTwR8WKmafX3IAl7I+hToNvJJzBC/vtXxRz/UigIaV3tgFTpkQ3IGK7l08LhS
         L8xoZkRaSn66o33TeXtiAXyWJoFefjVTtf6NU4StLyGDpDVPoxDvGQ0jOwOv3Q0umnww
         oZBg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774617849; x=1775222649; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5bY74UhjM4gzlwNhf6XzZKBW5M6iBaLhGIe7w2cyyBQ=;
        b=hdaDzckDe1O/Vu4v2yG1FlF2jPHSeAqvYOj4VdLotYtveALFS4+9jV/7sKfi3FP6Nt
         XB0/OeWm4T9Ok5PA/wj91+yl3hH4FhswusNiWPgD6RzfM97/r5G1lYXlXW9SXDa7Dclq
         Hvf8neVLcXur4hQRKJRvCNZKiRb7U/2JxnvcWSsM9jrC+THTIpbhPSNuB1NNvaUkAcYI
         vUwBu3Jy23XGv4nfMFOwv4UGfuLTTSL6gVeYRC0WwY49xEwrdeIsjGvsaQSFEELIASWC
         Zv0rZSr3QHJpu4SS1pfeDHwT/mrZu8+n3Re8tfn5h6ykt5hX95bOvHUBiPRkPix9Ic63
         aH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774617849; x=1775222649;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bY74UhjM4gzlwNhf6XzZKBW5M6iBaLhGIe7w2cyyBQ=;
        b=YNYmi2QLz2Sks49t5AK3sbEZytqrBhO8Loer9m3OdbsVKWtWvDL8eBmN1vs2ZIy2oq
         MDeZb9rrD9CGG/DNqIpf3D3zNFwnWfqwfDRatTpXnmZf4Xs2RAh8J4Lqna7gk1mSveRx
         QjkmlIO/Q66PVoforAn9q6Dt6Fna1eWlxSUl07AQ+5tO1JBkjZQFwyMgPLKxqGMk9AHw
         H6iKKQE3toZl3hl+aB3YtJSDtsAtIq4qNDjEovkEfrBVx2+HJitU4fuq3zbqacUtmag3
         4iov1xoJd88gFdSi0jlS5bzG2d0t7BMydlG1//Nm056JlDMTcMx5Y+xOam0WiQkQn0fC
         US0Q==
X-Gm-Message-State: AOJu0YyNy3pST+Slbjw/jWv3cxXCXtcWWyx0AsKY0eww0Q5TPnXImavs
	y3ilA/tCVodiRSGMlfbdPX4+qOwOMAcII3WmLwmRt86zjVW0QKo5dW6fNv6H38bHMEruMpegLny
	zVetWvwKJRE4BzmoRvX9z2aePc+IlPXYVwVsf13P3
X-Gm-Gg: ATEYQzykw6lskoAZRYHTf8mHCQ3VGHD4K0RdORqD4WaNGjTfRR5z/ZE9QzFWFLudvqa
	KJc6nK1VeCbv1nAPtDA0DGuYmyjkJNu9gkdwHQCEBE0cAInSfuKhPukz8QDGPLaOF/BsTJ2YmFq
	X/Pbo133zKQHFlSDm94Iq74eo5m3VVMzSjfoaQasYqHE7Zj8zx038HvjYbxNcLedshDGTA6ShWr
	m1eLAoi2PXnlf/MP7RfpxoePHcRp7O/4+PM05iSkFL8NPfF3JALXfj3+wRSQM7WdfTjiLestwtW
	rgDzHnAo
X-Received: by 2002:a05:622a:d1b:b0:4ff:cb72:7c03 with SMTP id
 d75a77b69052e-50ba318eb6fmr13176191cf.3.1774617848903; Fri, 27 Mar 2026
 06:24:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260327130047.21065-1-will@kernel.org> <20260327130047.21065-4-will@kernel.org>
In-Reply-To: <20260327130047.21065-4-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 27 Mar 2026 13:23:31 +0000
X-Gm-Features: AQROBzCC10PnLcTP381DSEChdZl5cJJMbR_OpsHzbEE59JG3IBeGP0k-sEwEXIY
Message-ID: <CA+EHjTxNTiMpM7c-YwvZpW-n+2s0sNrFa7qMCeepf6v1LJBeFg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] KVM: arm64: Don't pass host_debug_state to BRBE
 world-switch routines
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, James Clark <james.clark@linaro.org>, Leo Yan <leo.yan@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Yabin Cui <yabinc@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 27 Mar 2026 at 13:01, Will Deacon <will@kernel.org> wrote:
>
> Now that the SPE and BRBE nVHE world-switch routines operate on the
> host_debug_state directly, tweak the BRBE code to do the same for
> consistency.
>
> This is purely cosmetic.

It is indeed... until sashiko proves me wrong again :)

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oupton@kernel.org>
> Cc: James Clark <james.clark@linaro.org>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 84bc80f4e36b..f8904391c125 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -156,8 +156,10 @@ static void __trace_switch_to_host(void)
>                           *host_data_ptr(host_debug_state.trfcr_el1));
>  }
>
> -static void __debug_save_brbe(u64 *brbcr_el1)
> +static void __debug_save_brbe(void)
>  {
> +       u64 *brbcr_el1 = host_data_ptr(host_debug_state.brbcr_el1);
> +
>         *brbcr_el1 = 0;
>
>         /* Check if the BRBE is enabled */
> @@ -173,8 +175,10 @@ static void __debug_save_brbe(u64 *brbcr_el1)
>         write_sysreg_el1(0, SYS_BRBCR);
>  }
>
> -static void __debug_restore_brbe(u64 brbcr_el1)
> +static void __debug_restore_brbe(void)
>  {
> +       u64 brbcr_el1 = *host_data_ptr(host_debug_state.brbcr_el1);
> +
>         if (!brbcr_el1)
>                 return;
>
> @@ -190,7 +194,7 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>
>         /* Disable BRBE branch records */
>         if (host_data_test_flag(HAS_BRBE))
> -               __debug_save_brbe(host_data_ptr(host_debug_state.brbcr_el1));
> +               __debug_save_brbe();
>
>         if (__trace_needs_switch())
>                 __trace_switch_to_guest();
> @@ -206,7 +210,7 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>         if (host_data_test_flag(HAS_SPE))
>                 __debug_restore_spe();
>         if (host_data_test_flag(HAS_BRBE))
> -               __debug_restore_brbe(*host_data_ptr(host_debug_state.brbcr_el1));
> +               __debug_restore_brbe();
>         if (__trace_needs_switch())
>                 __trace_switch_to_host();
>  }
> --
> 2.53.0.1018.g2bb0e51243-goog
>
