Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6767536655D
	for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 15:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774192138; cv=pass; b=XM+IS8BlsHyMv5ItQXKbx8RjLnpDUnMm9FDOKOnTlSPPtW4SEvQSHhBDwtX1Ka9pK/bwydTDCjSXIS1j53j3VAehb5pMKWj0LBkBf8y3mCHAGSAjjxt36hhotzEQaNTqn+2qvmZ5iT7rEcQJ9rxKuA95LEZKKXcxpjn+3CWc9ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774192138; c=relaxed/simple;
	bh=pwF6ptSCRSiMSzl4UxDpSHb2w4DQkBrR++7isbAPc1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QXaHlyT6pMYQhOhwhjFC7Rxcfy+aWg1mA/cG57MyJrxvCGf0WcaCv25WpUk4TwBqLZDw2RuS6xSC1GtbwTofuUZB/AXfzScQF8fnEcmpIi9/kHMnYWXa0r6Vp/gF5FDCS1OrPiDsYmsZbaYp2hZFdvutP4R+PNUrUKq8C8ZtFbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DLhsBuCP; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DLhsBuCP"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-509069a7a7fso790031cf.0
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 08:08:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774192136; cv=none;
        d=google.com; s=arc-20240605;
        b=EBFOyYDuLJS3w+DjnIQbk+nwubJwAQFT7mVcW2jqqJYTRaQjxjcRlYhx0VBfWQ9BYy
         QBnOQQxp2aE/Q1iFMU3eRL9En4xqlsGIjyaYgjpGiv3uh+FtUQK28lH83Rwb8WKayyag
         py0AkTiCVv8RUrNxgWiIph2z6xRBYkscyw1OoPVyjqZTbGTu+wtvlpLJfy2dvFpNDBam
         BZT2cjj+L2RyT5Q9KRTDk9sEafXh/CYlo0UfSng8X6XN8qlxkV1x80wg68SVbTIVAf9e
         f/394IGgrHRwC1gHTt11/vPUWz/ryv41Drby2nYUn6yrMkscYmHv/UZpZtFaqOypXb9W
         6d1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=TR5RyAMW7afQqyguOMIyPaHLXgPGUcb/ZSGixWj0Ook=;
        fh=br/O7ad/Dpl82iqHQ050DMUcdTbv2XuF8/c9+X0NSgk=;
        b=CJ/rHlWE4qhesu0xWLtW3LR0iOnHiBxsTGXR6VlqKtTsTQjBg8+JLYcE7sEWDPhppV
         gWKuo6SLITKpr4Wp8JvEKnjhox5H7WKXbH3ke8zvrjguDabI4OWLfqQ8xQ+Kn8o+5C5x
         x1iJklUm+KoeYXI0T3fWVhAUt7D6bKPxMP6PBNCaBsgo5gWDzkGqtxiHuOtWuzyyo1bg
         FXrC0nmPz/qjvNEjNR4ozdtR6CgrdTxgl/cMkPAgCqn2FlTbcVBaCMP8kXwIOxKK7QuO
         rbFUuDPBt9OumBtMGdBH7fsYYiDhkNrnVB1mw8FCIagpmG/nLGEtprMHsJRxHudMIaO7
         VT/w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774192136; x=1774796936; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TR5RyAMW7afQqyguOMIyPaHLXgPGUcb/ZSGixWj0Ook=;
        b=DLhsBuCPn4xS3VZ+m7eQiwnU8+wCjmaXPa3/VwUrRQX9PjZsGu54AUnYWTHu8XAGoz
         GFpidV38hJq4zyAq9j1VyCuyhp5By4iCosCF4j90afXUc6E/vP0I4l7HuKgxzS/Ij6Ax
         MASsL3H827ZQnc14QjYAicY1MWWXH2NFeBcNcaTHclZp7fMaWmoC/jXQVH8H3rzWEjSe
         WHM7FSF6e+Im1BETlP8Z5QG4POkYVrCAMTJwXAGRHHDbQbk4LuOMS12QWiy+m/olcETb
         9pTJHfJ89IbGAWk4CobfI4wDoeT694bDU07e6SUo0/odGelcKBwWeRkaNl+UfTv0NEEr
         Yt3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774192136; x=1774796936;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TR5RyAMW7afQqyguOMIyPaHLXgPGUcb/ZSGixWj0Ook=;
        b=aZhNR3LK4zYhIi/KvCZA4/kkDiOOoZOKF4wr3r2i1F10EnP4Ceh5WuBK/xnuc5bM+c
         J+SMx2YyfkJSj08nKgLWese/q4sMFyWYsNtB/1VX9MDSyvY/6m4uqbnyQNnymmXIfsL3
         BDWysIZ22M01/maiLsKCh+OZMPjtska5NLCllO1E5U6umR+6UWDdxFXwnbYJ7sDw9v3S
         fqLR3IcWPQWaFxi/xdRHifV5elEPVh/RrPGY6X3eeZlau58vCggie3yKUq07n0MgHhkj
         +2bcm3Zmcve8pFsQ8Dx5zrkZA23Ewug7J3wurLO4KCJIsx8upY9c7EfJ9pxP4OQwBlrT
         RK9Q==
X-Gm-Message-State: AOJu0YxsIlf9Wdh9l9PH/9dlBbwbkt4JGXHfXTZ6iYv9GFVWw994X2Vt
	sQNyte9415dRgrEieK95Up9CfQmNAX78fciZaNLv/uieqz27TPMBzcHAMGv04X1qJCVJyyb1JYQ
	m4lnyA9HVGalZnXetP2LSZy+SH8BHbZ2KgSDaEMfz
X-Gm-Gg: ATEYQzz/CaUvIsFpOsjZWRlWxwfUF+z923Isn0Kd7HhhqsF5LeSZJd8oqVZr1Ac1IYL
	guuFB0UulAfyJq6UM/C6tpDLEtH3/HaSgdhhDiAQn04cXLqyXuo9Obm9MoF9Dls9K8H2fuvgsBQ
	ae2f16lgkayfxuI461S68D2bAQze6m+J0UKB9GwvMUrb1dYrsjaOn1Rc7UdALQjf3B+ObGADySo
	ArYiouioN/nW7PNzPzkyqg4kIgS9lYdUEwSAyn/HjSfL4K0u2VQOZ5WVHcvXx4K4+G2/Fr9M6DR
	E+Y/ugch
X-Received: by 2002:a05:622a:4a8f:b0:509:cd7:aa18 with SMTP id
 d75a77b69052e-50b46cd0bbamr20546021cf.10.1774192135946; Sun, 22 Mar 2026
 08:08:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260321212419.2803972-1-maz@kernel.org> <20260321212419.2803972-2-maz@kernel.org>
In-Reply-To: <20260321212419.2803972-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 22 Mar 2026 15:08:19 +0000
X-Gm-Features: AQROBzChkGh3Y5_KqgUzXigR7VJuZFDR7yUQIpecNEvPXr0n70MRqp06E-mDBgE
Message-ID: <CA+EHjTzkB9TXxjbSmWPW1T2HS=4tk5L=y-DLNv0hUFzqh7m7aQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: arm64: pkvm: Move error handling to the end of kvm_hyp_cpu_entry
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Mostafa Saleh <smostafa@google.com>, Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 21 Mar 2026 at 21:24, Marc Zyngier <maz@kernel.org> wrote:
>
> We currently handle CPUs having booted at EL1 in the middle of
> the kvm_hyp_cpu_entry function. Not only this adversely affects
> readability, but this is also at a bizarre spot should more
> error handling be added (which we're about to do).
>
> Move the WFE/WFI loop to the end of the function and fix a comment.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index 0d42eedc7167c..5d00bde092010 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -201,14 +201,9 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
>         /* Check that the core was booted in EL2. */
>         mrs     x0, CurrentEL
>         cmp     x0, #CurrentEL_EL2
> -       b.eq    2f
> -
> -       /* The core booted in EL1. KVM cannot be initialized on it. */
> -1:     wfe
> -       wfi
> -       b       1b
> +       b.ne    1f
>
> -2:     msr     SPsel, #1                       // We want to use SP_EL{1,2}
> +       msr     SPsel, #1                       // We want to use SP_EL2
>
>         init_el2_hcr    0
>
> @@ -222,6 +217,11 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
>         mov     x0, x29
>         ldr     x1, =kvm_host_psci_cpu_entry
>         br      x1
> +
> +       // The core booted in EL1. KVM cannot be initialized on it.
> +1:     wfe
> +       wfi
> +       b       1b
>  SYM_CODE_END(__kvm_hyp_init_cpu)
>
>  SYM_CODE_START(__kvm_handle_stub_hvc)
> --
> 2.47.3
>
