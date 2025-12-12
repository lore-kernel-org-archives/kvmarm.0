Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECC6288C30
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 08:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765526688; cv=pass; b=RXttIbzru/upG8/gG1wowqhEZO2ceRF4+QEI3cwsS+fOg89hD88JMtOiMK7mNjeZ/iG5IDPxJGiw/KpdOpPmOp17uuVsv4sIn5aUXtL5+MjPOSD7/EmP6LhO9mnlWOGZnJxiwdcSTW3Go6jEz2MO/ffQxyQDoi9rcl+cjHaujnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765526688; c=relaxed/simple;
	bh=fR2klWCppQaFHnTEKTEWn7Dx8bcRJpNJV4ZE2BoUbt4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ftqrHJbj04zJnZEq5UCIIAh7a6xQDb16jQrrYNuEqzJwFKbjkW8L6PTNTtgDxSN4V+CfYZyewWd6tfZcrBf7YCXYmU41Lhn1OfyqO2mvUXT+iwAcmFaxt0k+ezTeX99FLPzwZgxSU5HfXZcpb7DkPLf/6XBpwcEantcnD0w89N8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=upTR8oKX; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="upTR8oKX"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4edb8d6e98aso1237511cf.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 00:04:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765526684; cv=none;
        d=google.com; s=arc-20240605;
        b=QYQleOZJdklTlWQ8uK8EaDg1a2s9WDYQ/i/JmpJCrO3bwBktRqvEUo9gE+78WhE/r4
         Jra1sbKLQVkYWuyCVdUxs3cAB+lJFzL9TYD3yc5UOCTg7cDRRbregw58g+o39v4Jauvq
         O7FqFVIlCTGipIarIDywItjQRDIHR/919e+k0qyZ7CrfGcLNkB73TL+fT9pBEStRj60g
         5KJj3M7yrK6GbmFpxiMmdBFefE45+RImGbkKFMdMgyMZh1Haxm7UpKDiy/GYf2J0kNNJ
         qtpfN3MOdeZpOY/8dkdIFZXBc5SoQgeAe9El5zYm4gMy71DrgAbPur1IdDo4pFGjT2tc
         JOEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+U8+dNznpFslZOt3jZDGf7JqED9dm8pLESuGBInwRgU=;
        fh=DVwc+tRCqe7ToMUGYt0SRI0SWsKK+Mu5y3pDhnw4hn4=;
        b=fsRamQuumf8bD2PaToahaR57LG3wFLl2ka8432QxBl4zbxoOqghydD8OGk4Zz/iRZN
         P5iZk/b0oBisAFdN0e5jcfzCfvuR4m0PJ0LvSeNidf+H30QcN1/L7nL8samwc+CBF5zK
         UjoUpqqytGfoAIiY8ia1V8HMI/xeHKuazmo/QlraIF0kzSZ7+euoy0FoS/GO1iA2MKlG
         KVbuwTmxS9f9CWWXa7vFIOqKEHzh2WuuasnL4ueF7EbyNfAKAlnYz6NedToVqyP626Hb
         RFwqv8izGUSLpYC4J6LHheoORDky7U16kSxX9DoVJrY/C0Wb3glTVkYJzwcJWuiiW3aG
         S9TA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765526684; x=1766131484; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+U8+dNznpFslZOt3jZDGf7JqED9dm8pLESuGBInwRgU=;
        b=upTR8oKXJKVTM7A0wlc0XulTkUd16MlnC1kv6RD6lHT93qw+2SzkQdzCOqweSekaUa
         BUW1VOYWKV38/aal7YNHNdRW7mKgF9M9PfTnfN1uaWRve/oLUi7uZCHlRZRnk2W7n4W+
         y2lkYF7snCWWGtz2BlRR0DzomWon5EXrJ2pA0mEvOF+bQHNnxhCzVWGhSKeAZsnl5b+T
         LWISAkFTM3+g9kc75rvwcUiW7kz9LVVht2t2W5I2YeYB7wqbubHyr5g4z/iacQ36WfvI
         CbpoKfk/6w1Ur68TCmVYmm0qAkBCeYPXZmJrRrLydJ/hHIa4SwY231zsZR5zJgF1XA9s
         M4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765526684; x=1766131484;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+U8+dNznpFslZOt3jZDGf7JqED9dm8pLESuGBInwRgU=;
        b=NJ/aWD86jT2N8B9nRU/khrDtK8rVeZajuNctM3iLhMvS8UszVg1/0AdaGR31ePlpN9
         zzKZ9jG6GbCHM0D/tet/qL1yr0yubdDRwnCp0hU0pBMFtvfWG+dBsCtBOIw9hKC+YgO+
         yEB6cVfAjJRAPYiKl+4aT/cFhShYL0A/lvppi5yrNMRLyN89pGQRlQQfUxxZcwIp/sT+
         Uf8nx5rV0UD8DPy/2dZzSPfGEAGVvcWnPcprg6qpo9IWiDSJN3k8hLZxJ4/szD/BVZk/
         8HyaCamkXzlvkZsPemv5BvOxGyykk3UVkmDtx3KHkiOwfscKqU1J8SajQgpT9OUDzCRF
         xF8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVJ8VQ1Y0q5BypB9AORI6Ykw9k+IYLflbLFFB66FIMTLjxtdZxDLySpi7YmXQaWDH4AwBaFKII=@lists.linux.dev
X-Gm-Message-State: AOJu0YyD0siKP6ybs1mxRW/i8XdpmWOfENoAmm/3DzzDGV8SJPqmaU40
	J62vxxKviwi2sNCtgj+X3lyxhp3dYPJIbi4guOM4ZM/wLWfFA8H//CMG7c8Jwgv4sF1I2iyzJey
	g+otL2GcqoJQ1qBuydcpLZWj/chA0JhOFP6bRTK0B
X-Gm-Gg: AY/fxX5KuAZkXoEjiRfaN45Zz6RD5SR2JuwMz4Dru3nqv7KUm5Ll+oTydpJqEglHxsD
	ZatlhrMtS95+iwUpuo8J1aTkhnN7iR5cyK277GG1JE/x8cznMMHL3d2QcTyajIMEOGTKsIX363C
	Ql97m4qr+eCD/9ke2bAflG+OSQw+uwcqj0ge+M3yY2BmrinH9PeoTlAMcKfIm4ihojUFAIk5iT+
	+hZBpCT6u8F37tntePyMEWnl0/+M+sS0KN/SvqcYkqqJw+EcoJ0Hy/E6CVTxP3E9uQeCxe8
X-Google-Smtp-Source: AGHT+IFVdi59OsP3fmwvGAVvHEYCwmSnxEeO5zTktWlzni97TuZa78q8LVRVlb3nurJBxIY+bjfeYS+tgZqGnE3/N9U=
X-Received: by 2002:a05:622a:4d1:b0:4ed:b665:3779 with SMTP id
 d75a77b69052e-4f1bd956c90mr10154741cf.16.1765526683971; Fri, 12 Dec 2025
 00:04:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210132102.137631-1-alexandru.elisei@arm.com> <20251210132102.137631-2-alexandru.elisei@arm.com>
In-Reply-To: <20251210132102.137631-2-alexandru.elisei@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 12 Dec 2025 08:04:07 +0000
X-Gm-Features: AQt7F2qhTzwVzsydho6e40R4qIxakCmrjVFzoPGIgOsInIjz7_T83i-YOn6fwUU
Message-ID: <CA+EHjTxMmNrJT5-biZJDiTE4E5RaKpr+SGuj_jnpAfsbxzaR3g@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Copy FGT traps to unprotected pKVM VCPU
 on VCPU load
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Alexandru,

On Wed, 10 Dec 2025 at 13:21, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Commit fb10ddf35c1c ("KVM: arm64: Compute per-vCPU FGTs at vcpu_load()")
> introduced per-VCPU FGT traps. For an unprotected pKVM VCPU, the untrusted
> host FGT configuration is copied in pkvm_vcpu_init_traps(), which is called
> from __pkvm_init_vcpu(). __pkvm_init_vcpu() is called once per VCPU (when
> the VCPU is first run) which means that the uninitialized, zero, values for
> the FGT registers end up being used for the entire lifetime of the VCPU.
> This causes both unwanted traps (for the inverse polarity trap bits) and
> the guest being allowed to access registers it shouldn't.
>
> Fix it by copying the FGT traps for unprotected pKVM VCPUs when the
> untrusted host loads the VCPU.
>
> Fixes: fb10ddf35c1c ("KVM: arm64: Compute per-vCPU FGTs at vcpu_load()")
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 12 ++++++++++--
>  arch/arm64/kvm/hyp/nvhe/pkvm.c     |  1 -
>  2 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 29430c031095..ee0f1343100c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -167,6 +167,7 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
>         DECLARE_REG(unsigned int, vcpu_idx, host_ctxt, 2);
>         DECLARE_REG(u64, hcr_el2, host_ctxt, 3);
>         struct pkvm_hyp_vcpu *hyp_vcpu;
> +       struct kvm_vcpu *hyp_kvm_vcpu;
>
>         if (!is_protected_kvm_enabled())
>                 return;
> @@ -175,10 +176,17 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
>         if (!hyp_vcpu)
>                 return;
>
> +       hyp_kvm_vcpu = &hyp_vcpu->vcpu;
> +
>         if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
>                 /* Propagate WFx trapping flags */
> -               hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
> -               hyp_vcpu->vcpu.arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);
> +               hyp_kvm_vcpu->arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
> +               hyp_kvm_vcpu->arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);
> +       } else {
> +               struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> +
> +               memcpy(&hyp_kvm_vcpu->arch.fgt, host_vcpu->arch.fgt,
> +                      sizeof(hyp_kvm_vcpu->arch.fgt));
>         }
>  }

With the fix Will mentioned (hyp-main.c never uses the variable name
hyp_kvm_vcpu, it's vcpu for the hyp, or host_vcpu for the host's).

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 43bde061b65d..05774aed09cb 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -172,7 +172,6 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
>
>                 /* Trust the host for non-protected vcpu features. */
>                 vcpu->arch.hcrx_el2 = host_vcpu->arch.hcrx_el2;
> -               memcpy(vcpu->arch.fgt, host_vcpu->arch.fgt, sizeof(vcpu->arch.fgt));
>                 return 0;
>         }
>
> --
> 2.52.0
>
>
