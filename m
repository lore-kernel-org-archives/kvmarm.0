Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A3A3148A0
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 16:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761583374; cv=none; b=E34STangt7iWlY7aW5w124uFKMcRe6J5xqVtCtqLryHLLYamF1XWIrmOS+q7nyx6zw7VF74vTjTXgCMyg0ZuHQuL3W78J4ic57s7DJ1GqmWkxRW2BRLNih3ESUT6lXbY4R5LScH36rdyeYQCLVN15/OpbBIjhFfgyeycJ//DdE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761583374; c=relaxed/simple;
	bh=UUysKEeNz7Tgg2dxFbmWl3NmClv4oF03ZgJirQL/j1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gzkbrhNMXgV380/tMXvkzj+ax8JvVkFOGX0eKwYTOwunpAA4/hSmyAAe/Ug6v6OsAvXSB+uKCHybmW7vpgjv4OFRN/FHiXvIxxwcRaMMq3hOzivouMxuvHb7wtH4pjMbKGcGJg3EPTaLRlEOGoF+YYhbyqIy5g7JqzdI75+53MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=y/IoE0F8; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y/IoE0F8"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-78617e96ae1so1973267b3.0
        for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 09:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761583370; x=1762188170; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iIqSimi39klofHZtZnL5Vj2K3y0rXxrFl3z6jktwTZo=;
        b=y/IoE0F8h+py/4hLbmBtV3Y2UYCGzBKW2cfy1yj91SkVSSfLFQL8gkLD2u6sf8WpaL
         CZ7g8gfT9pt0LqHvZ5NpcetU0H3lY/6LPMJOI2QWZGx5DdCqSvtI6CnAg2rpXkt3ybWN
         NPVdDuU/8ePq4Ko99jf5ItS3pXuLO5wQ8q5IYqszVQR81N1qqLAB9m0f/sSOblaB+BWH
         5nSIVv1QCSw6IaW5OrTF6FY99+lFjfMb5PR1kLrG4PcMoaoj8+XQZ4d3eE0A5A/OKG5O
         c3HMjkSgh2kO+p7o/MCKLhHNZ1vh1C9bsbjeZ2MAnbazIg/VqLTK3KBcHGHKnuHRzPGa
         KLIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761583370; x=1762188170;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iIqSimi39klofHZtZnL5Vj2K3y0rXxrFl3z6jktwTZo=;
        b=KkoM2wwoplt3M2AsNXvm7nodAXSurMI/GL8oB1XbTNC20umi0GozRTGPDmAmCVAFeq
         zj39HqWo8MrqyQSy5vyqXzFECnY2EhXPec66PH38aFcuvE6hmypTauFCHu7BKuZUtzHy
         VbFuVIB6hJpfrYp7yHFSDltmA4Jf7h1BgMmdM8o6Uu29Do/GiK8Fe4jUCzZfcy6d8yYW
         2tBfU/lMXnYY4OFg7ebmKezVloG35NG0MkPBwrcDoa74Aen9SRvGh1FrnAdGq7iUhcAq
         PWs/amxbB8kexEo/VtBmAnWVEwUG8qZcEsmMluX15hjd5EoxcHo9OY551JwKBu2BNVw2
         D6XA==
X-Forwarded-Encrypted: i=1; AJvYcCV9e5Cd1frhmvhkd/ODB4nRbtqlJlpNYnsYFxZ2llccuB8Ie/I2eq4lwOCsTdITs8vX+blP8XY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFetDKdOkBUJkTbsqPAaaQS4U1BmQmsnpkRRoCIh8iSJYkBf8v
	cN0nCXCW08LI71W0dwcXI5AKF1vFlXKupuJTXsnj4OjMNOPiZ6W2OTvfxP8dNDUnfQrL20CR+DF
	5DIS0ZhtxWM1rc650m5v4/J3P7tyJWlorZlEX+f9AmHCfEIOJ5DTa
X-Gm-Gg: ASbGncsIefj2G+hglTjPb6G9imKcHNXz1PPmmpeXEgVsbv8dmDn1ercR3z2F8UqLFum
	pTY34RilagoP9CzhTtDckOWSSjlZxz9EbUuapABa/OkRIFMC3wgFewwPXOpRQmyEsPN3tEcZZ68
	p+/yoeEdWTYczCzvvY8NU7/vqzWHXElrHZHkOtUoln+DIeUgEmVhy2WAkmfnvObkVkmZUWNhsHd
	ocuxp8tyeB+M9LTY/8tqEgTvMWERPclFK7l/IqWC7GMPTcDiD3fH53bKB4gxw==
X-Google-Smtp-Source: AGHT+IFnTy4GuL39gQqo5cO5/AtjK3ueLANt8SL8mKD6Wd3Al0HmUJPCwVFv88tqthud15vc4T2fVPU5v7ZGG0ZTM0s=
X-Received: by 2002:a05:690c:a90:b0:784:a6d4:dc21 with SMTP id
 00721157ae682-7861838ccc5mr3677497b3.52.1761583370329; Mon, 27 Oct 2025
 09:42:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250911144923.24259-1-sebott@redhat.com> <20250911144923.24259-3-sebott@redhat.com>
In-Reply-To: <20250911144923.24259-3-sebott@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 27 Oct 2025 16:42:39 +0000
X-Gm-Features: AWmQ_bnGFe7efhNQOt02HzPY7w4uzHv-6KQOwTPx1B30MSJa7HImhr0NK5nCCdw
Message-ID: <CAFEAcA-urFX=V7kuRA3cRik7PifFQER5eoXC_CZ2jKg7OZz9iA@mail.gmail.com>
Subject: Re: [PATCH 2/2] target/arm/kvm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
>
> Provide a kvm specific vcpu property to override the default
> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst |  5 +++
>  target/arm/cpu.h                 |  6 +++
>  target/arm/kvm.c                 | 70 +++++++++++++++++++++++++++++++-
>  3 files changed, 80 insertions(+), 1 deletion(-)
>
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index 37d5dfd15b..1d32ce0fee 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -204,6 +204,11 @@ the list of KVM VCPU features and their descriptions.
>    the guest scheduler behavior and/or be exposed to the guest
>    userspace.
>
> +``kvm-psci-version``
> +  Override the default (as of kernel v6.13 that would be PSCI v1.3)
> +  PSCI version emulated by the kernel. Current valid values are:
> +  0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
> +
>  TCG VCPU Features
>  =================
>
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index c15d79a106..44292aab32 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -974,6 +974,12 @@ struct ArchCPU {
>       */
>      uint32_t psci_version;
>
> +    /*
> +     * Intermediate value used during property parsing.
> +     * Once finalized, the value should be read from psci_version.
> +     */
> +    uint32_t prop_psci_version;
> +
>      /* Current power state, access guarded by BQL */
>      ARMPSCIState power_state;
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 6672344855..bc6073f395 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -483,6 +483,59 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>  }
>
> +static char *kvm_get_psci_version(Object *obj, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    const char *val;
> +
> +    switch (cpu->prop_psci_version) {
> +    case QEMU_PSCI_VERSION_0_1:
> +        val = "0.1";
> +        break;
> +    case QEMU_PSCI_VERSION_0_2:
> +        val = "0.2";
> +        break;
> +    case QEMU_PSCI_VERSION_1_0:
> +        val = "1.0";
> +        break;
> +    case QEMU_PSCI_VERSION_1_1:
> +        val = "1.1";
> +        break;
> +    case QEMU_PSCI_VERSION_1_2:
> +        val = "1.2";
> +        break;
> +    case QEMU_PSCI_VERSION_1_3:
> +        val = "1.3";
> +        break;
> +    default:
> +        val = "0.2";
> +        break;
> +    }
> +    return g_strdup(val);
> +}
> +
> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +
> +    if (!strcmp(value, "0.1")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_0_1;
> +    } else if (!strcmp(value, "0.2")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_0_2;
> +    } else if (!strcmp(value, "1.0")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_0;
> +    } else if (!strcmp(value, "1.1")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_1;
> +    } else if (!strcmp(value, "1.2")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_2;
> +    } else if (!strcmp(value, "1.3")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_3;

We already have six values here and it's not implausible
we might end up with more in future; maybe we should make the
mapping between string and constant data-driven rather
than having code written out longhand in the get and set
functions?

> +    } else {
> +        error_setg(errp, "Invalid PSCI-version value");
> +        error_append_hint(errp, "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3\n");
> +    }
> +}

thanks
-- PMM
