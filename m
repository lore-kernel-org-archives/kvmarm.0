Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCF419D8BE
	for <kvmarm@lists.linux.dev>; Wed,  5 Jun 2024 18:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717611763; cv=none; b=Ejd4GUqetO2uCwA1XBMeWc5cimJEesnmmhO2Uy1aPCziyb7SqGAU9tbdAFszgO6MRKbIIywC0nIr40wFnFha1sXafuLjtBXdaPbcVHuRuM263dWykvbHV5ZyTUX4ELgeuvXcikcQMGowmWD1GSwpJrnKlTlv7wLU2/TQFTs4y7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717611763; c=relaxed/simple;
	bh=8Yl2+w81FXnntMILRI1QYhAqwCRXphAGHKrQXeUqBIA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oCh7luCvxRYhVjl5QkDmaLr39kF9RdIiYPoSCU8SETurdEFODt8TazeRnijpMtepamsh4cOC9STN6U7GR+MkQFRj1siwWZfPHAOE/F85o8iVyril7EEUX/49F7DsIlB5nGePmzpwO03OACUoFtHcEkVGzLhKP223sh8hH8TbjSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TdNW8ie3; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TdNW8ie3"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3d1facdf12bso31026b6e.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Jun 2024 11:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717611761; x=1718216561; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BOqedOYWtOVtPbtjeswNPTnq3pBDEi8nQj3J33r0HFU=;
        b=TdNW8ie3BjQO6A9tVF29Zo9KRmRv/ucm9o+59tIOfeOQCzNSuALKXpmfHDor/G7vK+
         JkqFXHjuOKjGjp87dQCCtWRbHtL2OtaO8Awy1FYoUqF9iNgPs7KmSn6M2VidgSaAqsMj
         3dRfGL+Dj/rVKkxDV8o5aufDX6R7gYD9Btk6p/utxPnd7pO6kHzhdXAxr5ovJ2K/tT0m
         CEkfPM+2TUy7iEQhBycZTr+MvNqRul1f2WI8PXUUtnNBhGuk+2uQ0Dtj8BwJmlkz1Uy7
         FWKK0A1CyDSb7JzYXxUzg9/B33yz98gW8PNCm8j53FdWrftxvfo6ci8JImT6YoOnfi8P
         hqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717611761; x=1718216561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BOqedOYWtOVtPbtjeswNPTnq3pBDEi8nQj3J33r0HFU=;
        b=eaI7vgso363HMQQJkIfCreAOg5oo2JUgn4DmM0rLRV90/cRZTi7JUZnSkFVPw3paCu
         JzW7oO/eIa+mDD88VeueYmcsQqCJw9CG9UYenxNcuKLBCrH0D7z5SnoWRyJ7a7M+xe3I
         ybKmOXjShx/WPqH+2kp/ps97ZZeHflLddQIqh7RHKEfcQRtQMxd3l2iO5ehDqhfuh8ok
         DdnN91ChPvLw4a+K3xYYBJ1Hq+2L1HpBl/gPJ8zA8dLEkcyU43UrOGqgLMsirL40fTZj
         x0SAaOoeMFWLUrAXHLAeu4D1vNBU65mJ2/N3p/V3AJ71PsqgAw0LlqmPiAdnN7ogCOE4
         2aeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrD+2KMChImtPEBUCN2K+wzqtryBXubbB+D9+r7SSTpu0OAPuz+ZyeFOqlHqHfiX2dA/UwVFxaGXsgjf/VvpoPXVboU2AM
X-Gm-Message-State: AOJu0YxzN2gv+mrI6q+v9QCBDxsdkDqBH/jTSrNpIg52WjVzkysQfZIS
	8npFS1ZrPrXugiJA8Rsp4HvSz/S9G3gEPvmz9s2rUjLCRVxPvvorGMK7H779PNQmUszaOXhcVOb
	NIGx0d7EYDWalY7CQzJVe9R1/fgOIMicYrFkR
X-Google-Smtp-Source: AGHT+IHsCbdc5SIxEdO83ZSuXLPQqM2CirxmFQGrXAysPbgK5BZQogLBsFsI95s/n1VGjNN6WgnF/fjK22vCs//hZXc=
X-Received: by 2002:a05:6808:8ca:b0:3d1:e7db:83a5 with SMTP id
 5614622812f47-3d20439d490mr3086311b6e.32.1717611760997; Wed, 05 Jun 2024
 11:22:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240605-kvm-arm64-sme-assert-v2-1-54391b0032f4@kernel.org>
In-Reply-To: <20240605-kvm-arm64-sme-assert-v2-1-54391b0032f4@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 5 Jun 2024 19:22:04 +0100
Message-ID: <CA+EHjTywH4BQNMpJokWgEiaD2zyc4rNisxSRDszogaxRBDnCdg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Fix confusion in documentation for pKVM
 SME assert
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Wed, Jun 5, 2024 at 7:11=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> As raised in the review comments for the original patch the assert and
> comment added in afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are
> disabled in protected mode") are bogus. The comments says that we check
> that we do not have SME enabled for a pKVM guest but the assert actually
> checks to see if the host has anything set in SVCR which is unrelated to
> the guest features or state, regardless of if those guests are protected
> or not. This check is also made in the hypervisor, it will refuse to run
> a guest if the check fails, so it appears that the assert here is
> intended to improve diagnostics.
>
> Update the comment to reflect the check in the code, and to clarify that
> we do actually enforce this in the hypervisor. While we're here also
> update to use a WARN_ON_ONCE() to avoid log spam if this triggers.

Reviewed-by: Fuad Tabba <tabba@google.com

Cheers,
/fuad
>
> Fixes: afb91f5f8ad7 ("KVM: arm64: Ensure that SME controls are disabled i=
n protected mode")
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> Changes in v2:
> - Commit message tweaks.
> - Change the assert to WARN_ON_ONCE().
> - Link to v1: https://lore.kernel.org/r/20240604-kvm-arm64-sme-assert-v1-=
1-5d98348d00f8@kernel.org
> ---
>  arch/arm64/kvm/fpsimd.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 521b32868d0d..820769567080 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -92,11 +92,14 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>         }
>
>         /*
> -        * If normal guests gain SME support, maintain this behavior for =
pKVM
> -        * guests, which don't support SME.
> +        * The pKVM hypervisor does not yet understand how to save or
> +        * restore SME state for the host so double check that if we
> +        * are running with pKVM we have disabled SME.  The hypervisor
> +        * enforces this when the guest is run, this check is for
> +        * clearer diagnostics.
>          */
> -       WARN_ON(is_protected_kvm_enabled() && system_supports_sme() &&
> -               read_sysreg_s(SYS_SVCR));
> +       WARN_ON_ONCE(is_protected_kvm_enabled() && system_supports_sme() =
&&
> +                    read_sysreg_s(SYS_SVCR));
>  }
>
>  /*
>
> ---
> base-commit: afb91f5f8ad7af172d993a34fde1947892408f53
> change-id: 20240604-kvm-arm64-sme-assert-5ad755d4e8a6
>
> Best regards,
> --
> Mark Brown <broonie@kernel.org>
>
