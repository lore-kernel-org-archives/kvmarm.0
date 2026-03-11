Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B169D3B7B7E
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773224006; cv=pass; b=jUtY4VL89uWMBRjiQKUnJxpQY6pW6InhEY/ibXAEktv9auW3f1nPfUOmr8mhFcLoJs9vrIlW5pk2rzLyi1yQULGaj1NyHE49WJj3QIyuyMlR80RmxTmq5hgNGY9Czp875ZlkTzd7XLQ6EMLR1gMp2dkxaR7d8YqJvIoauAFgxaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773224006; c=relaxed/simple;
	bh=a57CWQUeFv9OIki4SmySICTS4iOKncvmiIkIL1vhPhQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LlE/7JADMXNaw/HBgsGlhtmTH6mSZwQDc2G6TFvv4WT8vMT8/YSwnlJRN4ESpAoNIwFeloCvXJX4eXvuDMW66Dmh3GLurZMY9723JdZdcecS9Byt4WpqE248xEEWZTi0HtgY0H9nY13zUhwHPmdujOguBEI9hQ3sYQsf/mpETxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dz6iqOMq; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dz6iqOMq"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-509062d829dso409191cf.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:13:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773224005; cv=none;
        d=google.com; s=arc-20240605;
        b=Cbn9yHQkXyl6A2qGjSHzhimLCb6MM2KR8KFi/KGpiKt+nw8sFbcAjrag7isQi60KFZ
         nLTPJFsMiF8+Mbm66e6E6WyDB++NO/WsvredA/azYm3OVeSWXgljY/ntUgnkQ3YW3P8R
         BHJYmeqoN/stXFvcx4G3g5qeW2NUfsuPX8FMFrAV+WNudqUEG76/N/SZTW9U8rWAnTQl
         7CGn0KmWix0lfszoTGBZttP0qgLwurU6yXEMjEMN58FxEB3Zo5qoFMgIhsJ9rglKZJho
         G/x18vcVryTqJ6gjMLfoX/wGGNVCwHU5DJ//WF48ZCdjgz4AYlbOHouydxIrWvkqAO7C
         W2LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EJUK1c7uh2qWa/PUs7/Gela8m5sgz/NTTAmffjVN7aY=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=gpg/Hnxr7aOOQhBzASV/32KAciNtCr/VrrSjyxSZZ6AV41McLaOvBSwR0h3Mji9Qyj
         dysygc6k160NiTdBdHdslaRhkHU5pBhjgyOOOE1UQryPmoeatyqwLHpZCLpjeFzokTDp
         5nVabKCTdsj+2iqn884Vi/YQX5Wrbs1P/fdpIOejOmaU4t000ElLTWoYvUhNLj4mB8P4
         Pkta/VNj6m6r7A7N8Jak/K1e0Ql3/FMNVF8MpbYBDJnbL9MjkjIbDXlX4P2LeYU4UXVF
         kYzyx/fJtVz7JD8cg4ryyGkJOoEZN5orj+8lbUdx2zQCNc64PrBP3WRiV0WUJGiILiv4
         tvdA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773224005; x=1773828805; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EJUK1c7uh2qWa/PUs7/Gela8m5sgz/NTTAmffjVN7aY=;
        b=Dz6iqOMqAxsYX9Ay1UXJMCJuJAmuTB0gijICw2YiiqahxeRwUtA6F63DbebUcq/lCG
         CtD8G67xvrVY2TDwqcRuKFQLOoYcZ/6XNkF+gP16Cz1YqC7o3TXe4q5Dlej2ZqQTRALM
         Mo73sGTMHGMXqFB4Dzsh8usiCT/Ft+fiGl+/UmXhdWPefibH60wNHOHYDBi30qS5JA4c
         Mmb6JyfK2OJ55Vgyw+SjKYXS2hMTn8k5gZ2/Ad2ud89r7X4ve6G+nXb9FDdpK2mgvj9G
         go63O8ll65k2lpOczFvFOrKFSNh5gHp24GXOd5SiJQErkkM6JjEnBqS0tHYYAEWXu3Tg
         N1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224005; x=1773828805;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJUK1c7uh2qWa/PUs7/Gela8m5sgz/NTTAmffjVN7aY=;
        b=VMjoct7Ti+8e+qNkaiI+3M0AIWH0Vv+Rz0v81coicRYZy4qJ23P80xV6mNJRrfWwue
         jO5zSs4JgZiny0L2zfbkABl8QPPHhBcJAVdXfYAwjz34TTav9ehCENb1ZTdKEyH4NkLe
         bew7AqtYMbd5VM3BJCwqBDZkMvYjh8JD056PNe7jYdVuo65y85MIxeWkg3lja6396YHT
         OchfuirdN714JWP7c031xfjDAPVNcgGB1g0xjBu7cdhYPZ7i8X8b5AiHd7gxuigaFwCF
         Mry2Q9vZvs+htKPbVO/7tR1kpMiMfWsYZc9V6V4ldzzEjyxHQrtTQjD4TuK1i7PyOeBT
         oxFA==
X-Gm-Message-State: AOJu0YxSVJW4Fr0bSrJO6S/8aW9RKVjgP0/y+pVlRZF5YcEEUkR4dWny
	lioT9uDIju/l2yq7v7KkboWI0pJzvjDG4IhGb7ColEKFEIe7MGqsTmywuCuI2isSKaDF7LUGrHD
	zSGeiZ6mkYi/+ocCCHeO7oNsEDQUVkgKzh8ve5ifs
X-Gm-Gg: ATEYQzwJAZmyhmiBsGXFrUdXdVptoEUe7GuY1ghzrfDMbWGGBZMhxu4fbw4BLTdzl9e
	gSZ0H9yXHTAh7B8U1erIN4ygzszAEHzwEUjPCtgi66gghFQgkqRWe9rWTB7U768IokWHzAntVcd
	lCuDa3dLtsdsQkW2tsO3IYa2egYa7af98H6+Ic36iqgqojxPUDzLgyP7N5e2LrQRCl3meXm1e4O
	9sQ8QBzQECP9nJRjUncILAkfTqhJq0UyAIZXD9d34vKgd8XcFb1i6T5YEqr6Iw4WEkm6BrnHDYP
	ZJ5Dw3jwhjW0E7ksq28V8DdmVc2a2v+b0oSa8Q==
X-Received: by 2002:a05:622a:1449:b0:509:105c:74a9 with SMTP id
 d75a77b69052e-509382ae1camr11927581cf.18.1773224004181; Wed, 11 Mar 2026
 03:13:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-18-will@kernel.org>
In-Reply-To: <20260305144351.17071-18-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:12:47 +0000
X-Gm-Features: AaiRm50tqIjNQKfWSBmDN7C0OQpW0WkI6OuSdjJkK9RHrz0ZGsHlr6SsTi2slmE
Message-ID: <CA+EHjTxwPPDeDoW7krEpH5NMWHgp8dFZ+Q3RrAGZd=fJAaqx8A@mail.gmail.com>
Subject: Re: [PATCH v3 17/36] KVM: arm64: Support translation faults in inject_host_exception()
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:45, Will Deacon <will@kernel.org> wrote:
>
> Extend inject_host_exception() to support the injection of translation
> faults on both the data and instruction side to 32-bit and 64-bit EL0
> as well as 64-bit EL1. This will be used in a subsequent patch when
> resolving an unhandled host stage-2 abort.
>
> Cc: Fuad Tabba <tabba@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/trap_handler.h |  2 ++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c             | 18 +++++++++++++++---
>  2 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
> index ba5382c12787..32d7b7746e8e 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/trap_handler.h
> @@ -16,4 +16,6 @@
>                                 __always_unused int ___check_reg_ ## reg;       \
>                                 type name = (type)cpu_reg(ctxt, (reg))
>
> +void inject_host_exception(u64 esr);
> +
>  #endif /* __ARM64_KVM_NVHE_TRAP_HANDLER_H__ */
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index adfc0bc15398..6db5aebd92dc 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -705,15 +705,24 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
>         kvm_skip_host_instr();
>  }
>
> -static void inject_host_exception(u64 esr)
> +void inject_host_exception(u64 esr)
>  {
>         u64 sctlr, spsr_el1, spsr_el2, exc_offset = except_type_sync;
>         const u64 spsr_mask = PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT |
>                               PSR_V_BIT | PSR_DIT_BIT | PSR_PAN_BIT;
>
> -       exc_offset += CURRENT_EL_SP_ELx_VECTOR;
> -
>         spsr_el1 = spsr_el2 = read_sysreg_el2(SYS_SPSR);
> +       switch (spsr_el1 & (PSR_MODE_MASK | PSR_MODE32_BIT)) {
> +       case PSR_MODE_EL0t:
> +               exc_offset += LOWER_EL_AArch64_VECTOR;
> +               break;
> +       case PSR_MODE_EL0t | PSR_MODE32_BIT:
> +               exc_offset += LOWER_EL_AArch32_VECTOR;
> +               break;
> +       default:
> +               exc_offset += CURRENT_EL_SP_ELx_VECTOR;
> +       }
> +
>         spsr_el2 &= spsr_mask;
>         spsr_el2 |= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
>                     PSR_MODE_EL1h;
> @@ -728,6 +737,9 @@ static void inject_host_exception(u64 esr)
>         if (system_supports_mte())
>                 spsr_el2 |= PSR_TCO_BIT;
>
> +       if (esr_fsc_is_translation_fault(esr))
> +               write_sysreg_el1(read_sysreg_el2(SYS_FAR), SYS_FAR);
> +
>         write_sysreg_el1(esr, SYS_ESR);
>         write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
>         write_sysreg_el1(spsr_el1, SYS_SPSR);
> --
> 2.53.0.473.g4a7958ca14-goog
>
