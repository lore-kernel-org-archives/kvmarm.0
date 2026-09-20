Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694A93A962E
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 14:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789915396; cv=none; b=JmA/TANJMROBl2gdGGxB3VmgTv80GuRpszhyV4A953ZP9FgIdm5Wffm9HRoW1YJP4p1/mWwtLFS+B3AOptE2Ig9FQGJtUxuIpNcQjRBjWeKX6SwEkJRctHzorUfossix8ODIoGdV75btqwHesrFAGQ08u2jUlp7c1jfCaCrDKkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789915396; c=relaxed/simple;
	bh=yZadQIKLPBXUWvfsPFFRLWHe9vBIyM1Isv2IkYkJtAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ji6pcggIO+Ms6oWlsuET3xe6pWrXZhHhs2snTgyU7MXNfi7WrBwcHj6iyzQMU/MczLEgRoxxgC7brJ58mTUydimRzJ33uZXlQElWhC5IWG3MFlxMxmLeHGQ9rLXom/eNKSYT0Xaab7I1E9nVFeiFnWrFhBo0RVSzPksJ9V06/EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e6HbYnqO; arc=none smtp.client-ip=95.215.58.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e6HbYnqO"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=yZadQIKLPBXUWvfsPFFRLWHe9vBIyM1Isv2IkYkJtAU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789915390; v=1; x=1790520190;
 b=e6HbYnqOdXb8BfzjejE6qvaxGKs2j9LIBGyk2aiFYVVV2eFaSmGVzNYybyAyohCtR1fn5dZ0
 XKxbHYDSW8tnPapbAM3+C4IiI0cNJTB1ksdeXpQ3iYOdOee6tniEWrRZOAQsa20F9pSy5/xYDKa
 J9zGc7bOm1G0xTG+TSaLz45c=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 48170ead97f5f244;
	Sun, 20 Sep 2026 14:43:09 +0000
X-Mizu-Trace-ID: 48170ead97f5f244
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5b8c42da963so5600e87.0
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 07:43:09 -0700 (PDT)
X-Gm-Message-State: AFuF++l105QCXO/MZxVdE6JraiP4LdZ4ADxhZoux3ToJsh9PmQfql23+
	RSKFNLK5UGSmg1JqUfijGX9oJs4auBNbWYj0KWba+9pNngLeIfP/qQbypBP1W8zgCVELacWuxcU
	7gEq6LLc92x+eajoF20/sMxiPa/sdeFw1VHrgWqpn
X-Received: by 2002:a05:6512:3c86:b0:5b1:5141:9156 with SMTP id
 2adb3069b0e04-5b8c7eaa535mr93155e87.9.1789915388858; Sun, 20 Sep 2026
 07:43:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260919123150.3283606-1-maz@kernel.org> <20260919123150.3283606-4-maz@kernel.org>
In-Reply-To: <20260919123150.3283606-4-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 20 Sep 2026 15:42:32 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyeR8rSKToEuAy67iD-ZeWe65AWth2T7WWUKirTdfQURQ@mail.gmail.com>
X-Gm-Features: AcwNN1VvD-EPQpppZTjxhfK5ARJxwLQY5wTTc0-s8s8S86Iq_yKG8kGbEvu1UCc
Message-ID: <CA+EHjTyeR8rSKToEuAy67iD-ZeWe65AWth2T7WWUKirTdfQURQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: arm64: vgic-v5: Tidy-up programming of vpe
 descriptor address
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sascha Bischoff <sascha.bischoff@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 19 Sept 2026 at 13:31, Marc Zyngier <maz@kernel.org> wrote:
>
> Assigning an address calculation to a vpe_entry is poor practice, and
> results in sparse moaning loudly. Tidy things up by computing the
> physical address as such, and performing the cpu_to_le64() on that.
>
> Whilst at it, simplify the computing of that address, avoiding the
> shifting back and forth, and kill the pointless GICV5_VPED_ADDR_SHIFT
> definition.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/vgic/vgic-v5-tables.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgic-v5-tables.c
> index d7196ed5d1bfd..2c8d0f360506c 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
> @@ -63,7 +63,6 @@ static DEFINE_XARRAY(vm_info);
>  /* Virtual PE Table Entry */
>  #define GICV5_VPE_VALID                        BIT_ULL(0)
>  /* Note that there is no shift for the address by design. */
> -#define GICV5_VPED_ADDR_SHIFT          3ULL
>  #define GICV5_VPED_ADDR                        GENMASK_ULL(55, 3)
>
>  /* L2 Interrupt State Table Entry */
> @@ -725,7 +724,7 @@ int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
>         u32 vm_id = vgic_v5_vm_id(vcpu->kvm);
>         u16 vpe_id = vgic_v5_vpe_id(vcpu);
>         struct vgic_v5_vm_info *vmi;
> -       vpe_entry tmp, *vpet_base;
> +       vpe_entry *vpet_base;
>         void *vped;
>
>         /* Make sure we're not over what the hardware supports */
> @@ -751,10 +750,9 @@ int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
>         vped = (u8 *)vmi->vped_base +
>                 (size_t)vcpu->vcpu_idx * vmt_info->vped_size;
>
> -       tmp = FIELD_PREP(GICV5_VPED_ADDR, virt_to_phys(vped) >> GICV5_VPED_ADDR_SHIFT);
> -
>         scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
> -               WRITE_ONCE(vpet_base[vpe_id], cpu_to_le64(tmp));
> +               phys_addr_t paddr = virt_to_phys(vped) & GICV5_VPED_ADDR;
> +               WRITE_ONCE(vpet_base[vpe_id], cpu_to_le64(paddr));
>                 vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry));
>         }
>
> --
> 2.47.3
>
