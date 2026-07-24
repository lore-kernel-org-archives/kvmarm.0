Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C819F3FADFA;
	Fri, 24 Jul 2026 11:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784891448; cv=none; b=MP2kBNB0bZfADrDv9o32M8W+JWwR3JO+NWo9yjrjiiQpp8qoe7Jvf9KVLY9RUOKeU3XqpU01TzomscmGV5tCPpJyhIdHrXuy8o3LgN/8Toz4fZOnEANbE/1KYrLIdwJY+HGEGl0lU1G2UWlQYP/VyGJZDEjqd19NuyMvvPJtWZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784891448; c=relaxed/simple;
	bh=FwNSwmO7MRpcuA/v1C/0vNtaIOzlPruoTdQbpPXLG58=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OJU8zgxYV6P9sqmTU2rJxP89WIaUmjMJxHqzYNBtK9AMpr+DOiJGfkJR/tuw7klGUsdd2WXBSu2MKzoMsMRnetmfTnirEAPKnmwDv/EHcGF80x+I0HSSWUsf+pL+h2Ak/kXDf/SREOr+Zlp7R3BZGkObJmQD7yMNidFBgCLBdAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAzNi5Q4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAzNi5Q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1D11F0429A;
	Fri, 24 Jul 2026 11:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784891447;
	bh=vr0npTkhIlq8CX2B1m8P7MSa6+kERlhhz+2SAxGlg68=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gAzNi5Q4WofWg0jqyj4B5vWaompURssux3mviRFaalKRmFrZ8BW5rKZ2Wd1t2r7mi
	 5bR13uLeHuN9dBJES2qfAU2H+x3ZxaA5ztSsqcWuqPzFZVLmX39T/iwt3Xm4TRJU13
	 yqUl/Dwe03G5Frjh0blNJios0CMcndKpGDMHVRxIO3pcgm3joeYiOG5hLzjgNz2ujK
	 eVkWBHLmR5v5w83Pdm3WQl5Xa16CYOD5tDjOggruRVQI0GL8fohxLd0Tcmxmm98amA
	 +g2VviV5lC8u2xUv0QHU65fe97vAn/OinqKvJfrX90XrvDB5r6pvwcRrdksSmIGwSU
	 0pmOUxDYSzTUw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 02/48] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260724104819.1296803-3-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-3-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:10:46 +0000
Message-Id: <20260724111047.4D1D11F0429A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Unchecked dereference of `irs_data` in `gic_of_setup_kvm_info()` c=
auses a kernel panic if CPU 0 is unassociated with an IRS.

Pre-existing issues:
- [High] Failure to clear `per_cpu_irs_data` on IRS initialization error le=
aves dangling pointers, causing a Use-After-Free.
--

--- Patch [2]: [PATCH v4 02/48] irqchip/gic-v5: Provide OF IRS config frame=
 attrs to KVM ---
commit 6022367a12dfea4087fa1185ff131015d445a1aa
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

irqchip/gic-v5: Provide OF IRS config frame attrs to KVM

This commit passes an IRS config frame pointer and coherency flag to KVM
via struct gic_kvm_info for OF configurations. It adds a helper to retrieve
the IRS chip data for CPU 0.

> diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v=
5-irs.c
> index f3fce0b1e25d9..607e066821b52 100644
> --- a/drivers/irqchip/irq-gic-v5-irs.c
> +++ b/drivers/irqchip/irq-gic-v5-irs.c
[ ... ]
> @@ -50,6 +48,11 @@ static void irs_writeq_relaxed(struct gicv5_irs_chip_d=
ata *irs_data,
>  	writeq_relaxed(val, irs_data->irs_base + reg_offset);
>  }
> =20
> +struct gicv5_irs_chip_data *gicv5_irs_get_chip_data(void)
> +{
> +	return per_cpu(per_cpu_irs_data, 0);
> +}

[Severity: High]
This is a pre-existing issue, but does returning this per-cpu pointer risk a
use-after-free if the IRS initialization failed earlier?

In gicv5_irs_of_init(), gicv5_irs_of_init_affinity() populates
per_cpu(per_cpu_irs_data, cpu) with a newly allocated irs_data. If a
subsequent step fails, the error path frees irs_data but does not clear
the per-cpu pointers for the associated CPUs.

If CPU 0 belonged to a failed IRS, would this helper now return a dangling
pointer that gets unconditionally dereferenced by gic_of_setup_kvm_info()
during boot?

> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> index c04523a438cee..e7a7aedcfaf78 100644
> --- a/drivers/irqchip/irq-gic-v5.c
> +++ b/drivers/irqchip/irq-gic-v5.c
[ ... ]
> @@ -1128,6 +1128,8 @@ static struct gic_kvm_info gic_v5_kvm_info __initda=
ta;
> =20
>  static void __init gic_of_setup_kvm_info(struct device_node *node)
>  {
> +	struct gicv5_irs_chip_data *irs_data =3D gicv5_irs_get_chip_data();
> +
>  	/*
>  	 * If we don't have native GICv5 virtualisation support, then
>  	 * we also don't have FEAT_GCIE_LEGACY - the architecture
> @@ -1140,6 +1142,9 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
> =20
>  	gic_v5_kvm_info.type =3D GIC_V5;
> =20
> +	gic_v5_kvm_info.gicv5_irs.base =3D irs_data->irs_base;
> +	gic_v5_kvm_info.gicv5_irs.non_coherent =3D !!(irs_data->flags & IRS_FLA=
GS_NON_COHERENT);

[Severity: High]
Can irs_data be NULL here, leading to a kernel panic when dereferencing
irs_data->irs_base and irs_data->flags?

If the system's Device Tree topology does not map logical CPU 0 to any IRS,
gicv5_irs_get_chip_data() returns NULL. Would it be safer to check if
irs_data is valid before assigning these fields?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D2
