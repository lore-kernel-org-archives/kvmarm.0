Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F659328619
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763375844; cv=none; b=bgGPK8IsV6ZffJCLRXVFPJZBbDW85Qbxi6iD8ecswgz/1lDkZZH0EqFhZoj2tC5pFHlgrpU9Sw0wMk1wYaE+5eJaQ7YlAuu3ODd5b21pPUrzn4KIWjqv4fjjUuoSuj6XKqOVkIw9js6QGpWOjDzCVTmha3haQzpFqslfm/NYLQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763375844; c=relaxed/simple;
	bh=jU6y13VHOFy3Pi7WNXNgmgLs1immGWngiyX609zJHLw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CPPHkVU6/yvwiNtfWrmEF5cxpLqZWzL89xHaXjB+G9t0RQgDXZOZG8SW6iEElajznOZmuF2NX+7WzXsWXsoMDrQxmI1FaV+k2+iYAUUlSqsrIBx1qnjA1i8ABoLQu/IntVXeSdGLmOk3XwBAlvDVfh+CcxxOEe0efkR3npFdmfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cZ/TA4dM; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cZ/TA4dM"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ee147baf7bso403521cf.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 02:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763375841; x=1763980641; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cSCczuntyrjypJFmPl75f311GtN50oo2b0NuRkLWiBY=;
        b=cZ/TA4dMxq8FuLINfvfpKJyJTwFB5NFIrBBlH+xeDzh4Ivh5cklXyEuoKcv4382Vqn
         GHmnukX4TDACJJtUWL6xsqbPalS9FUKgGcJOvdQYrtvL+sOD2Mlts9jz4sOcj6f0Nbv8
         51ygTAOkCLiMd/uLYV6V4bKEaOn/vFNZLeZeRAyzClq4KD/5e58YySHoS+8F8Dnc98ds
         GrNC8y5koRDIRQRIsodnk+XfooOg+ZLkPQoW6aLRQn2hxFOcdbi+3nyaP7jJFoXkpptL
         m9aOKwdGNz4MpueblumgqqMg8hT0t/bGyn/dTmzYW8eihiXX0BZZm8U4XBQTnYkG0f89
         VwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763375841; x=1763980641;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cSCczuntyrjypJFmPl75f311GtN50oo2b0NuRkLWiBY=;
        b=WceQZYc5tHOAn64bby2xUTUKrbBJDCD/iI5wECNEZhALJkd9nr1kZfxW0R4RfncV+x
         lMGDB5lUawZ6VAJiV5yRcXZuEiwS9RsOE6mifP7E2A9MlB+aJs9ZSN2EtzD3o3hwBd/h
         23iH7d75gZP/7q8332JA0yeHPk6jTaMgt2KHGgL0mb9Qy0L/35KHaFdRDOk3wQaWnZfY
         6GoLhH6ows/P3qXhfO1MRE1yDLAcGxuATS20a5EcM2AcMIR8EvFmouanhOpd+zSHxqG0
         ol1WXLYa3Ofy+Zv3jdrX1bHTzaAvOZ8Od/JykRVW7yebFi35IVveDSsc4JTSm60DNY4q
         2oCw==
X-Gm-Message-State: AOJu0YyvgrKNSR4fa6zoljFOgjmYZEudGX9b40zxfEA/u/ZGAdNWg51N
	tt+J6I8fnyZSdL4OUBcuo0DGlyvdxiuQQAp49txm6IJCNMYikgCUPTZZKSYBpULovHmfch47Ye/
	VgYPQwpGzyJC5me9/NuKX35cBbtdjAwZCQ1D1Zo0J
X-Gm-Gg: ASbGncvGvQsKRGVas4w5KPuoKgAw9h0DwaJC3kjrcyoQmFT5NBUcog82+1d/m1K5gQQ
	KCxSxR/ZNcJm4yUoAaUXNaBzPfGIMmI0Uhw62WMZ6iLzoWguH/vjQF4TxDVAich7TH0B03EGCoQ
	RQstNEMB4KTdDkRKg3gk+2CrubchwshCN22R5BsGGEDIXGq6wMiRsuUZ3KiayD0WBVUCKH9et9H
	J9cjyk8S7o9olpvlb7nweELg3YybGKDDtSjaSnFobsWiQLUH13j875u4uaM8k5ee8e6i8teuhTs
	e7k6yA==
X-Google-Smtp-Source: AGHT+IFFM24GESKuymha8lz4kxmnQKTDe1ajE7ALZIAlCW3kwiBwOHxbJvkmtglaccu5bdOdgggOwWj6OAOtjgUpEJU=
X-Received: by 2002:a05:622a:1196:b0:4ed:7c45:9908 with SMTP id
 d75a77b69052e-4ee02abc1c8mr11423671cf.10.1763375841094; Mon, 17 Nov 2025
 02:37:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <20251117091527.1119213-3-maz@kernel.org>
In-Reply-To: <20251117091527.1119213-3-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 10:36:44 +0000
X-Gm-Features: AWmQ_bkOHIvxxrAN0Ta8I3LCFjnIE-AQuTMgHtHd82ZTpr8YLnfGv1xtAWeYWMw
Message-ID: <CA+EHjTy-vmMrOR_-BAd4q2JG99afzd3cisvf-VP6uM+M9Pg2=g@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] KVM: arm64: GICv3: Completely disable trapping on
 vcpu exit
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 17 Nov 2025 at 09:20, Marc Zyngier <maz@kernel.org> wrote:
>
> Fuad reports that on QEMU, the DIR trapping is still effective after
> a vcpu exit and that the host is running nVHE, resulting in a BUG()
> (we only expect DIR to be trapped for the guest, and never the host).
>
> As it turns out, this is an implementation-dependent behaviour, which
> the architecture allows, but that seem to be relatively uncommon across
> implementations.
>
> Fix this by completely zeroing the ICH_HCR_EL2 register when the
> vcpu exits.
>
> Reported-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> Fixes: ca30799f7c2d0 ("KVM: arm64: Turn vgic-v3 errata traps into a patched-in constant")
> Closes: https://lore.kernel.org/r/CA+EHjTzRwswNq+hZQDD5tXj+-0nr04OmR201mHmi82FJ0VHuJA@mail.gmail.com
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index e950efa225478..71199e1a92940 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -243,7 +243,7 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
>                 cpu_if->vgic_hcr |= val & ICH_HCR_EL2_EOIcount;
>         }
>
> -       write_gicreg(compute_ich_hcr(cpu_if) & ~ICH_HCR_EL2_En, ICH_HCR_EL2);
> +       write_gicreg(0, ICH_HCR_EL2);
>  }
>
>  void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
> --
> 2.47.3
>
>
