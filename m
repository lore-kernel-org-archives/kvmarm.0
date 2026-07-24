Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B16425898;
	Fri, 24 Jul 2026 11:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784891964; cv=none; b=r2XdREL18ms3knJ3tLyt3m8eyAU/66yI6akChPQIMiQogrjjoUB3p4qxDMeHjb3G8Ss7PQ/ZFizBarR6VpcA/b6XFniWueLw8+JUiYa2XJV8C9Ssj/d7sHzsEhOZH8Sbt8iV6S+oW217eA4zv1+OGWBZGhZniRQqZ6muItaOUoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784891964; c=relaxed/simple;
	bh=xJ+YuNqYAmZmS3p9ikPCkRNw9SFGFVdL0ZI9j/7UPIw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=txRQrQ53q5MGVKdqDoBrN6LyYQc+bP5qfOOUuTttrWUpEjq9QjqECc/yFFN4jBCVO/nbUwcgsws8nCcbAWyZW4GsidJqTPr8A2iS2DYuEbq8VPbz+wrUMsfsJDyTxuDGl5tKwlMiN5ROlMmZuGEEOwVPR5+//RJsEIyf45ucHqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j1vvOa5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j1vvOa5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAB41F000E9;
	Fri, 24 Jul 2026 11:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784891959;
	bh=8jnr+9SFsZYNhXUUp+HnC6AUMHHgFJpnmBm18zYvji8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j1vvOa5tK8n5ySqgXigxG5hgsRV6tbG05Mn9Syf5IMw+cavs25EDFawEVuCnvk47D
	 KY/NFYY1tDMljHIkbtrhcdOOF4wYM9oXEDR4lbNiG0vum+PZjFgty6xPEkCfHv98dI
	 tUbOFn5isJynSZidxV/ATmyuAJ42eRI4F4e2ubs5xL6IST5NEyB1cfv7H9uSm0xUJT
	 TKfuz5293rdiiEA1ioXxmZbwM2DHpr3jrnmTmpkVChXlIGKsP/YOoOeSnW9fDP82Uv
	 Pe7K8WBU/ubGd58h6wTA+fKkvxEmFGU2RNIUFzaSjk45h7irEUrKknc+Ad6+h2J4F/
	 WSwlh1YkHnvQA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 07/48] KVM: arm64: gic-v5: Extract host IRS caps from
 IRS config frame
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260724104819.1296803-8-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-8-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:19:19 +0000
Message-Id: <20260724111919.7EAB41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Inconsistent handling of ID bit counts likely miscalculates `max=
_vms` by a factor of 2.
--

--- Patch [7]: [PATCH v4 07/48] KVM: arm64: gic-v5: Extract host IRS caps f=
rom IRS config frame ---
commit 2b896f2ac90e022fb55d61f670ccdb056cff2664
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Extract host IRS caps from IRS config frame
   =20
The host irqchip driver provides KVM with a pointer to an IRS's config
frame. This commit extracts and stashes the VM and IST capabilities
from IRS_IDR2, IRS_IDR3, and IRS_IDR4 into a capability structure.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index d4789ff3e7402..3f7b132110114 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> @@ -34,6 +35,45 @@ static void vgic_v5_get_implemented_ppis(void)
>  	__assign_bit(GICV5_ARCH_PPI_PMUIRQ, ppi_caps.impl_ppi_mask, system_supp=
orts_pmuv3());
>  }
> =20
> +static u32 irs_readl_relaxed(const u32 reg_offset)
> +{
> +	return readl_relaxed(irs_caps.irs_base + reg_offset);
> +}
> +
> +static void vgic_v5_irs_extract_vm_caps(const struct gic_kvm_info *info)
> +{
> +	u64 idr;
> +
[ ... ]
> +	idr =3D irs_readl_relaxed(GICV5_IRS_IDR3);
> +
> +	irs_caps.max_vms =3D BIT(FIELD_GET(GICV5_IRS_IDR3_VM_ID_BITS, idr));

[Severity: Medium]
Should this have a + 1 applied to the field value, similar to how VPE_ID_BI=
TS
is handled below?=20

GIC architecture ID bit fields canonically store the number of bits minus 1.
If VM_ID_BITS follows the same pattern, omitting the + 1 will result in KVM
calculating exactly half of the actual maximum number of VMs supported by t=
he
hardware, leading to premature resource exhaustion.

> +	irs_caps.two_level_vmt_support =3D (idr & GICV5_IRS_IDR3_VMT_LEVELS);
> +
> +	if (idr & GICV5_IRS_IDR3_VMD)
> +		irs_caps.vmd_size =3D BIT(FIELD_GET(GICV5_IRS_IDR3_VMD_SZ, idr));
> +	else
> +		irs_caps.vmd_size =3D 0;
> +
> +	idr =3D irs_readl_relaxed(GICV5_IRS_IDR4);
> +
> +	irs_caps.vped_size =3D BIT(FIELD_GET(GICV5_IRS_IDR4_VPED_SZ, idr));
> +	/* Field stores VPE_ID_BITS - 1 */
> +	irs_caps.max_vpes =3D BIT(FIELD_GET(GICV5_IRS_IDR4_VPE_ID_BITS, idr) + =
1);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D7
