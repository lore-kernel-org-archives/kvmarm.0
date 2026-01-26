Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CFF279DB3
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 19:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769455023; cv=pass; b=jHRGDPhLd5vYI3ESFK7JGNV8w17wBCxhZz8DHU5q5vd3i9zPh+gPwnthpaRmNGABM9oYqGqeHUE5DI6JN1VLouZUiiyWqoNBnvMDmigTADxXtJN9MBKihWpUOiHOCd0GIjVhsQeEsA1DzxIoephaO0KI3IKSl9tCHpAlzxcuzuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769455023; c=relaxed/simple;
	bh=shASez4WWN24nr1jfpbfUJWlDIHBrF006qMDmGLDxkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JpHiiQHKDmKKFXKWdxHehxhqehitNVNXeY58kaoX+SAGVKoTvjRetW1Fw65MldWxV5iDu0nr4eWYbD3AIaiQ//mwyHnR9W8qz0hVlMV1no2NbL36kKoFrJukoh9XgTf5yG9xvd5XMl2cvhGyVZemJS9i5fC4kGq5L6EJlgw7Y7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UYLUlIkA; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UYLUlIkA"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5014acad6f2so48491cf.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 11:17:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769455021; cv=none;
        d=google.com; s=arc-20240605;
        b=cEtw4wzu+FawRH2HdGv/YUeo3N+fhhiyyLKJ+c/F0Nkhm9IAgVmT6jsGsKFKCOE2D7
         5kJDFYobw+XjOl2Jla/rhKG/NQVHqvBp8755rvlPZswHHfz+WU99PdFyvRgxNANJdktd
         DzEnsrxwoe4nFs6259mYW3CrRfv2gb7eUrh2Fnqf+zAgZ7iNVUiq8WA9VKYIV9tBTlbg
         QtPj9nw90r3NkA86lY9KMNaaDRaSSEi6uq/ddK7o19ywYBYRAobbouw4dlqhfooDOmG7
         VcHUIVI/1sefp7TgjKH6IV0CZPYpUBhiSNLup6NS7IaaqnFJ6XVsXhWivwkK0/KJfb7O
         mt0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Q78Gf8ey3PlNHaQFSeNbIKQ639y8O+joeYk6mwpkVco=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=bYKrGOWq0YC20iEygZqoJUEBJ+UcuBCb7nTbknZwos7KoVij49wV/qQ165GsRfN+lw
         4ICtC2Q+tQebxLm2Y+H5EFlRnj6uVDEV6Fm74+P+UzSOg4OTWI+gkAa2veLbr/j7rDe3
         g/VAS8g8RG9viuiRJGds3Qo/tNdnU755vyQRfVBORN2Hnqkn/6Tug56jRu0jUaGc315w
         bZUS+WJRBcmxTpeEZn8VSUXoiJjHXdkRMcOvowJTA4YCPshhCZiOB3D6AuQ5hYaEg/Tp
         jKKOj4k4CnRWj6A+KTpffboqNdovoR7KFnBJkF8TprGGkwLqFOI+FckE5MBZGmi6QqRd
         mxkA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769455021; x=1770059821; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q78Gf8ey3PlNHaQFSeNbIKQ639y8O+joeYk6mwpkVco=;
        b=UYLUlIkAsJn3aFSpJ0MmYkAM686xToDHakEdqU648ALoIozUa9xpvBDGeGoB38ZDfo
         UY0tBnGN1LkZXcVvB5o54JkC0oKg+aWwRfqknpMFuN9ZOGYQPArN1rurPxXKtSuxFLSl
         sMBd/WJY8APET/aC7spmKi8Va3x0FtkmLMymN2wboBTj4bIAZ1xvCpiUGwiAQMgehuHc
         DFpuNEMdbChGJIhQG5yjGO8KebewXtwSTt1Ci8gJyMQE0pcSjCcMl4H3HGtxwAYOk79V
         yfNesc/EbDMm/no73o9MnzUOaBaW5HsV5Uz/cklTyLj6Uo25kJi+lYaJVzZzSQafjh+v
         otWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769455021; x=1770059821;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q78Gf8ey3PlNHaQFSeNbIKQ639y8O+joeYk6mwpkVco=;
        b=dztiD8A2GnCbikNdPmOQq4J9JS1RXAsxJGn1f93GXOSU2MYJs9KkoLBD/BPIOaNFcW
         +RA/ix4XQoUOZCDa5zTWrsFL0UJpNXRbjABb7HPkYfrt59R7pK0PxJeZyQiRFOcHJyDZ
         0hLEHq3M0x1LnCIcN96tvbjhU9AWs/WjhDSk0aLfc8iz5ukzbG5M+HmlAQj0JmYEDla1
         SDpUJEyf+ynk2F62VotuS4JESw6uqr6rjie+vO4CsopnYiXEsA3SOJhQqSmoV9Q3mUDk
         dv2cMPh+wG4Z6dGtnzNHPrM2oKvpw7FuHEIMbcJQWzeR94pZTg5ytO5yfZa5S2j+Upu7
         /Yhg==
X-Gm-Message-State: AOJu0Yy6g/vS6ZParcebwr9OyHS+BSFmAUgU+X1FQeVnpQ52Q7FuJVfH
	ETXgmQ2nclvetTKn0qdYtpxcIytcQVfvIfUVtQdXZrDvFUc17szov6KYM4rdEgz5O+BjDASCUp2
	zV3NrfLGR8wUtF5EEMXKvqZFucYW1nvVbel4+HctIQUv+tS69IyVq0X4N
X-Gm-Gg: AZuq6aLUodvCTSkE/Y89fYqAhpujtQbnxJYjgLCyYPTSKmpFTIPc+Y1H0UTU6cbXOqt
	/M2cbhQf1xw7jG1oWzII4ijNiJiD/fWw1l7oI0eXeRDWRxuPa972mAHhDTcVEGOSkG8EToCrVck
	07RgAxMbubRjc90PVlrwFv1BqRtujsxAXKpa9FJhGMIKVjRCb+DTDsxqJdpolccorJ0tI0Ajjmz
	d/wH679/S4E0yu/4svnr6N6PBCKXrVUFgQeGi0pKsWQfj4OpxRnQdtAIkfU7Wr23DO3WSNA
X-Received: by 2002:a05:622a:1651:b0:4f0:2e33:81aa with SMTP id
 d75a77b69052e-50314395914mr14193861cf.11.1769455020509; Mon, 26 Jan 2026
 11:17:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-6-maz@kernel.org>
In-Reply-To: <20260126121655.1641736-6-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Jan 2026 19:15:00 +0000
X-Gm-Features: AZwV_Qjj96yrEnieCy5TgVtfTcOY3xBDAy9jwhHwQBFe31riTdky8XYLoS7UhzA
Message-ID: <CA+EHjTzmr+479uxdQgnM6Ai5jcx1=L2-ufQPD67fvqsCL1gZ8A@mail.gmail.com>
Subject: Re: [PATCH 05/20] KVM: arm64: Extend unified RESx handling to runtime sanitisation
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
>
> Add a new helper to retrieve the RESx values for a given system
> register, and use it for the runtime sanitisation.
>
> This results in slightly better code generation for a fairly hot
> path in the hypervisor.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 13 +++++++++++++
>  arch/arm64/kvm/emulate-nested.c   | 10 +---------
>  arch/arm64/kvm/nested.c           | 13 ++++---------
>  3 files changed, 18 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a7e4cd8ebf56f..9dca94e4361f0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -635,6 +635,19 @@ struct kvm_sysreg_masks {
>         struct resx mask[NR_SYS_REGS - __SANITISED_REG_START__];
>  };
>
> +#define kvm_get_sysreg_resx(k, sr)                                     \
> +       ({                                                              \
> +               struct kvm_sysreg_masks *__masks;                       \
> +               struct resx __resx = {};                                \
> +                                                                       \
> +               __masks = (k)->arch.sysreg_masks;                       \
> +               if (likely(__masks &&                                   \
> +                          sr >= __SANITISED_REG_START__ &&             \
> +                          sr < NR_SYS_REGS))                           \
> +                       __resx = __masks->mask[sr - __SANITISED_REG_START__]; \
> +               __resx;                                                 \
> +       })
> +

This now covers all registers that need to be sanitized, not just
VNCR-backed ones now.

nit: wouldn't it be better to capture sr in a local variable rather
than reuse it? It is an enum, but it would make checkpatch feel
slightly better :)

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad





>  #define kvm_set_sysreg_resx(k, sr, resx)               \
>         do {                                            \
>                 (k)->arch.sysreg_masks->mask[sr - __SANITISED_REG_START__] = resx; \
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 774cfbf5b43ba..43334cd2db9e5 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2427,15 +2427,7 @@ static enum trap_behaviour compute_trap_behaviour(struct kvm_vcpu *vcpu,
>
>  static u64 kvm_get_sysreg_res0(struct kvm *kvm, enum vcpu_sysreg sr)
>  {
> -       struct kvm_sysreg_masks *masks;
> -
> -       /* Only handle the VNCR-backed regs for now */
> -       if (sr < __VNCR_START__)
> -               return 0;
> -
> -       masks = kvm->arch.sysreg_masks;
> -
> -       return masks->mask[sr - __SANITISED_REG_START__].res0;
> +       return kvm_get_sysreg_resx(kvm, sr).res0;
>  }
>
>  static bool check_fgt_bit(struct kvm_vcpu *vcpu, enum vcpu_sysreg sr,
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index c5a45bc62153e..75a23f1c56d13 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1669,16 +1669,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>  u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *vcpu,
>                              enum vcpu_sysreg sr, u64 v)
>  {
> -       struct kvm_sysreg_masks *masks;
> -
> -       masks = vcpu->kvm->arch.sysreg_masks;
> -
> -       if (masks) {
> -               sr -= __SANITISED_REG_START__;
> +       struct resx resx;
>
> -               v &= ~masks->mask[sr].res0;
> -               v |= masks->mask[sr].res1;
> -       }
> +       resx = kvm_get_sysreg_resx(vcpu->kvm, sr);
> +       v &= ~resx.res0;
> +       v |= resx.res1;
>
>         return v;
>  }
> --
> 2.47.3
>
