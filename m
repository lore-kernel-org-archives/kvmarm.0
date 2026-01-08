Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C0048AE1B
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 14:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881421; cv=pass; b=h4WzJl6GxrHMyN5I8M4cuO1NKsXjEfV69cZcI9ozfJFZ2zweee1FMgOszYa+vn8Y0Q5EhB7kr3voChEKfhIp+wOe1qT4r5zhrQPBTVmZb3pJHQnUAywgn2QjC382FMwRzfTXiqHo3s7NlQ3u97qGEySslbOBPF6His3wtzm1wPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881421; c=relaxed/simple;
	bh=nd9v6rOTsgtmeIcSOzUf+JTIDj5sX0xCl7dm1iZzN1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bFQSCERJ46hF0WGDa3nbVGguPbAKvexjjU+D+MBEpsB3iNyzSHvOc9hUgEGIRL493B2VggEMUs4NLnSM9jEkVoFsRFRLsEzpwsFFonZBnPW8z7PjyGtMK1xFuR8WLFnqstc7sMjQjgo2bi1b7B1A255qNFZjDRy3XOMsz8LcuSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=onzhDGCW; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="onzhDGCW"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ffbaaafac4so742921cf.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Jan 2026 06:10:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767881418; cv=none;
        d=google.com; s=arc-20240605;
        b=L6hXxdLlcgghcRriZgl5Quzy+MFslIf+HMrYBb8uRpkL3o4kOlaT5k8xxzNNTCGAaS
         htLGq6AqCVCSwjej8bLAEw0epQxPtKgjLrAk5iyL69UNSC3i/zoOv+VQEZMtd7zxKAeE
         BH0R7DjILHYroSIVqvE3ah/klSRElV8nFZNt/tdPvUaHuqH5TJl4/uTNSZlAXHMYEvro
         Kery6zOwVtEeHpGToUCAFgDp2M3/IRZbQy+7QyjFtSy12POsiVht5IHauii7ATRgO1Xl
         WO89QcvqJ1SmLWyYcmqYVAAV6hEaZLydpaYnWPaTyWUko7D3xmcn7DHq6ZgPNSyrdYK8
         RW7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=M6v8yJzivCkGRPQD2RD9WlokTdTcLOTAtGeFegCEmXw=;
        fh=ZBMQlOs8uRnO7QPLtnh+nzkfxnM7CSJEptaoL9k0iJ8=;
        b=jyQ5IEjNFjR71bOxCfClAYlJeCCll2d6tWbsyRwbcO9RkXEgXoQJHyDl0aYW6P0mtM
         9MYXaZtC2TM5TYb8LaIGOZIoZpDyHnt8IEmAnLRmLgcOac1Qls4UwQVsM1aNnirW6frX
         zpi69DWmEdHbbID6751bmpQHT3gsvf8eYZQDVPTaChLj1HLJm9OcQ4dkbjCfhT6bdIxS
         kf4B7Io6zygpr5G23lpAU36YQpmK2TyawEDF3IJ3QQZkDWe1wV/GkLSQKia+/clfQsaa
         Wj9UUNpS+S1pgiJH+eTUnKeIpeDte+FKqdz0ON/ATtodSvLInkbY+i7vOcJMPSOsUgss
         sy7Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767881418; x=1768486218; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M6v8yJzivCkGRPQD2RD9WlokTdTcLOTAtGeFegCEmXw=;
        b=onzhDGCWdZCd7PfmKRq4y1zbHAp66M45iu6dmryHfxbGWmthEwVZ/1buX/UrVvs/wL
         OhZOXqnLnGPrTmbRGJfn4ohCiW2ZYULOnhBix2CsiSAHxKWezIx/g9RH7PUQad3BCiCu
         IygQZIPcLD7kvYNgfWvhZeKI8bkFR1zgjgk7K60fNDGW0NArPLqSAOu9wU95E7BTpswu
         gnbNE8mSdtdM5Dz0sGsXtIbU0gzdUnL9vah9PV5XasK1gVdhbMoYhVljBi/nPQ+EvOp0
         LiHoE6GTRq4sj79qEn+nLyalABINE/7KY5E7lR9BtOaPoRq0xkqoa3SBkjClErKWgNmQ
         YQ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881418; x=1768486218;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M6v8yJzivCkGRPQD2RD9WlokTdTcLOTAtGeFegCEmXw=;
        b=EAcWCD8AtfrtiFtR4d4t/+LT5xhCWY3LtUQLBfwLeb2VYhsSmOdFT5l+DvzThWqXGM
         pBLiO03yL9Fl1n+217pPh/9nhFG0dYxhXypW00+gS71qhuhlEknb7MRFrGgfevMHYuEf
         6obOf4gSCZ4+Em7QB/BviMtETLzu/oFFogveUly/TAFJnAxxRWWM6AUG8288OhD/f8Tl
         +iDfE2IrVdt2EiQ7I+0vdpePqBGVqP52M17Qv8s2XHJgJbneTi1RSbFTDAEAnTnzI+i1
         gAuk4Mbf+1LClVld4aZm+vrB53RtfQdVNiFUifg8333S+Y1XfdqZBomATBHXrXNqgLTk
         3J4Q==
X-Forwarded-Encrypted: i=1; AJvYcCU2gAgXWfb+pNmKpurVZOXqjFg+iIC1dcbfv+JZmzK+66oNUIgD6ab4gK3MXPHpx9nTkAcZ9js=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz74lgrTwD404VT7sPibp2o3FRVT8H59JKB8Net8lUFPCkWkMaH
	qANNUPXwpjoSNdtWxG6TgA1BQtMMYDyMgW2fZctF4Rh2nWnNAHBTMIy7pZbSwPDL7b02GSLW+dM
	n9kQ8AbIN74DAxUVpBEzU98ZN3/oPSZRgxp172brD
X-Gm-Gg: AY/fxX4iqN1Oxq71nx5+cvKfzAp806srToNbhV1cpAac7Z3RuTTI4Ogr7ERPq+FSXPd
	dRVaUAeKykyvYQ9YW7H0MuiMeZYhoq56vKHes6iWdVJHdjcqnGAV49ebhE79G9pVxZKK+5Acxr8
	0dmeHR1obPNs420Z5byV5h0UXfjWX2g5Fm9rFjIBWvJdztOBWS+/6LglqRU+IkAcL9IzN+LtGuk
	dRh1zY5jCGtCLP8MpzzOoK8KpJzeYgNGK8dCedwqy0NHK+6g04RSTQn/kWaeZyxG9HZ6k/q
X-Received: by 2002:a05:622a:1191:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-4ffc0897ee3mr8604171cf.1.1767881418089; Thu, 08 Jan 2026
 06:10:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-6-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-6-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 8 Jan 2026 14:09:41 +0000
X-Gm-Features: AQt7F2rcFTpAi-WrxH-BJGuce-rrvqsGKbxHYZVaorpjl6SSauHiDAfYA3cghe4
Message-ID: <CA+EHjTznG=6+bYW+mmmBs_QqZ2rXkKTzNxA5KSh3S67H_BBaHg@mail.gmail.com>
Subject: Re: [PATCH v9 06/30] KVM: arm64: Pay attention to FFR parameter in
 SVE save and load
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

On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> The hypervisor copies of the SVE save and load functions are prototyped
> with third arguments specifying FFR should be accessed but the assembly
> functions overwrite whatever is supplied to unconditionally access FFR.
> Remove this and use the supplied parameter.
>
> This has no effect currently since FFR is always present for SVE but will
> be important for SME.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/hyp/fpsimd.S | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
> index e950875e31ce..6e16cbfc5df2 100644
> --- a/arch/arm64/kvm/hyp/fpsimd.S
> +++ b/arch/arm64/kvm/hyp/fpsimd.S
> @@ -21,13 +21,11 @@ SYM_FUNC_START(__fpsimd_restore_state)
>  SYM_FUNC_END(__fpsimd_restore_state)
>
>  SYM_FUNC_START(__sve_restore_state)
> -       mov     x2, #1
>         sve_load 0, x1, x2, 3
>         ret
>  SYM_FUNC_END(__sve_restore_state)
>
>  SYM_FUNC_START(__sve_save_state)
> -       mov     x2, #1
>         sve_save 0, x1, x2, 3
>         ret
>  SYM_FUNC_END(__sve_save_state)
>
> --
> 2.47.3
>
