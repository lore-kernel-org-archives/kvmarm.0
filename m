Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EA94734CA;
	Fri,  7 Aug 2026 11:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786103610; cv=none; b=WeKEEXGiCw1SfpdMCSo/Yzh/m3z0k01mIVa4jBYrmQfHbbTalfd+89KFKWcU0cXaMPeVEQ/ezuZoiLXmKW9qSMmq8cJrPmPvBKm+CJHtDS1op85t1Jcg9ZNtMsD9J4L0jF84MueXt97HH6YI9Dfi7borSKUwYJtQj+2sYW4frcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786103610; c=relaxed/simple;
	bh=ETlpLQsplaZllbEul2ok1ZReAKo9f5y7ruRqHSsRu2U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IVOQ9KVQmb6cxTC31Wg9gXq+XPMhR9Zzw191cFJXXgUV6pfuOROji6NWH9Ez/8hcwC8gWJclUcgbhOfd+MLpOulgQK87+7vICRSdQlCVtByf0GtGOocQdFuBcB3yAaz41YkZTJHo9L32b/qTgRBFMix45djMssh/0DAqzuwdhQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AfSiwV9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AfSiwV9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724081F000E9;
	Fri,  7 Aug 2026 11:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786103597;
	bh=sN24TVU75tJi6aF3GJgCUVnNNH/Wt4WNo0dq+U01Yoo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AfSiwV9nOjo+ei1rXnBD6PfYpItCQWQhJecf6jecHVnLisU4lqMs2orKL9jq1lQNm
	 NgsDknZRREL6QHLlPTxtMYDJAXnYZHZZF5pbmfkLadv/i357DyJuKkLZ73VsW+74wq
	 LQcbZWYWhSz9fUvSA0tPtlBYCL/O3BsBk9gsxH4itTYh/cp5PXBHQcxnRc4rYv19lT
	 BkjBzY3ObI0BrEMJBZUlRuBmxBZ3SOq5gboQt7+AmMnNB9ozzHKLvJJu1btrCeuLaQ
	 5ZEDVB1GyUlCxujQqFnE0WBdJ8oDBXSnJ5NiSUOoUOSQsd347tak1xQvnAJSSWDCP7
	 JHzBazEuScI2w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 02/49] irqchip/gic-v5: Provide OF IRS config frame
 attrs to KVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260807111159.429128-3-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-3-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 11:53:16 +0000
Message-Id: <20260807115317.724081F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] `gic_of_setup_kvm_info()` unconditionally dereferences `irs_data`,=
 which may be NULL if CPU 0 is not connected to a GICv5 IRS.

Pre-existing issues:
- [High] Failure during IRS initialization leaves dangling pointers in `per=
_cpu_irs_data`, leading to a Use-After-Free.
--

--- Patch [2]: [PATCH v5 02/49] irqchip/gic-v5: Provide OF IRS config frame=
 attrs to KVM ---
commit 1b935b47d4b6186ec42dafa24166af9a1d8adb3d
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: irqchip/gic-v5: Provide OF IRS config frame attrs to KVM

This commit passes a pointer to an IRS config frame to KVM via the
gic_kvm_info structure. It uses the IRS config frame from CPU 0 as
a representative frame, assuming all IRS config frames are consistent,
and passes along coherency flags.

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
> +

[Severity: High]
This is a pre-existing issue, but if gicv5_irs_init() fails during IRS
initialization, a dangling pointer may be left in per_cpu_irs_data:

drivers/irqchip/irq-gic-v5-irs.c:gicv5_irs_of_init() {
    ...
	ret =3D gicv5_irs_of_init_affinity(node, irs_data, iaffid_bits);
    ...
	ret =3D gicv5_irs_init(irs_data);
	if (ret)
		goto out_iomem;
    ...
out_err:
	kfree(irs_data);
	return ret;
}

The error path frees irs_data without clearing the pointers previously popu=
lated
in per_cpu_irs_data by gicv5_irs_of_init_affinity() (and the ACPI equivalen=
t).
Since IRS probing ignores failures of individual IRS nodes, a dangling poin=
ter
remains in the per-CPU array.

Will returning that dangling pointer here lead to a Use-After-Free when it =
is
later accessed?

> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> index c04523a438cee..e7a7aedcfaf78 100644
> --- a/drivers/irqchip/irq-gic-v5.c
> +++ b/drivers/irqchip/irq-gic-v5.c
> @@ -1128,6 +1128,8 @@ static struct gic_kvm_info gic_v5_kvm_info __initda=
ta;
> =20
>  static void __init gic_of_setup_kvm_info(struct device_node *node)
>  {
> +	struct gicv5_irs_chip_data *irs_data =3D gicv5_irs_get_chip_data();
> +
[ ... ]
> @@ -1140,6 +1142,9 @@ static void __init gic_of_setup_kvm_info(struct dev=
ice_node *node)
> =20
>  	gic_v5_kvm_info.type =3D GIC_V5;
> =20
> +	gic_v5_kvm_info.gicv5_irs.base =3D irs_data->irs_base;
> +	gic_v5_kvm_info.gicv5_irs.non_coherent =3D !!(irs_data->flags & IRS_FLA=
GS_NON_COHERENT);
> +

[Severity: High]
If CPU 0 is not explicitly listed in the 'cpus' device tree property for any
IRS (meaning CPU 0 lacks an IRS), gicv5_irs_get_chip_data() will return NUL=
L.

Can this unconditionally dereference irs_data without a NULL check, potenti=
ally
causing a panic during boot on valid topologies?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D2
