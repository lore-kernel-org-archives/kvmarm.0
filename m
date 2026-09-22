Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8E755C1DF
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083696; cv=none; b=Rd2cp6A6vcNIA6wu++tZNHjRWnzPVUEy6D32Gj3ae597YNt8egf+rI3VtLi+0zsTZqjvcbIRZuY3kuqTEi3bBQecrqjcraBheOM2HEMSV2JFPq2VUuNtmRYEB2ixsTu5BbrPKD0d2SVbZbfacVVqx/aDkkMwDDwTcoXKe06FbKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083696; c=relaxed/simple;
	bh=dc8OW0jvqabLBYiNEBBuXf1GU1ubwz2NZlvH3eWCYiI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=s//F3cb463j3kouDFTLZdmALHI9+7E48cw0PKRHS45XjfGzFawJ6w+GbQTngWVIGz4BnaypmqoqXZ3GyKpgTIemg5o2+u264cn+6ACQ5CVFt0flqfUVeelMd6QHGXVnvG18HPzpHESRpCROctbkR+V8pO2PdidAO7ttcsjz4Z/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hq66CMqG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hq66CMqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D398D1F000FF;
	Tue, 22 Sep 2026 13:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083695;
	bh=VsA+8vCLT4OtXRQAcPmQGI25zcCeJlDOw1DQdFAy4V0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hq66CMqG6iRvf3PY2pkfYjO0RbeiOnRI7bSPSl1ges0NnWRoJukh43JeC0LP7gUFY
	 FWUeQQNHTBfawpepofjZa+VV9+GVnIJKhU1c8n3Vp6NH9xZkcwct4aePptN3zRpiwE
	 1W34q4pxP+GJdducG0L/puW4ZSzUPuIxFUMr3+8du3F6XidY039FOOE71PEt3S5/Hm
	 SIq3m8hYMV22ty5nMIHEZknmBMhX2DHDmSUmOMGK9tJojbrF+5Lk6ezqX4yP/L+fCL
	 ZVplvru6Km889PB8BKLBen7QC5uwJVn5jMsfHN2wFoz6Wd5GSudCtaRNAaHrz+b6k2
	 nO5o4MAvxkFiA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260922131259.2975334-12-smostafa@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-12-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 13:28:14 +0000
Message-Id: <20260922132814.D398D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] iommu: pKVM DMA isolation bypass via unbound SMMUs falling bac=
k to host driver
- [High] iommu: Use-after-free of smmu during platform_device removal
--

commit a8ae8dbe858fbefdcb8b149d519f07175f91d794
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Add the kernel driver

This commit introduces the pKVM host driver for the Arm SMMUv3, allowing
the hypervisor to trap and emulate SMMU management when KVM runs in
protected mode. The driver probes these SMMUs and creates auxiliary
devices for them on the aux bus.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/io=
mmu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
> new file mode 100644
> index 0000000000000..9947d3a44304b
> --- /dev/null
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
[ ... ]
> +static int smmuv3_nesting_probe(struct platform_device *pdev)
> +{
> +	struct hyp_arm_smmu_v3_device *smmu =3D &kvm_arm_smmu_array[kvm_arm_smm=
u_cur];
> +	struct device *dev =3D &pdev->dev;
> +	struct resource *res;
> +
> +	/* Only device tree, ACPI not supported. */
> +	if (!dev->of_node)
> +		return -EINVAL;

[Severity: Critical]
Can an adversary bypass pKVM stage-2 memory protections here?

If an SMMU fails to bind to the hypervisor due to early returns in this
probe function (like missing a device tree node or hitting the cavium
erratum below), it is excluded from kvm_arm_smmu_array and the hypervisor
does not trap its MMIO.

When the native host arm_smmu_driver registers at device_initcall, it can
successfully bind to this unbound SMMU. Does this allow an adversary host
kernel at EL1 to natively program this untrapped SMMU to perform arbitrary
DMA into hypervisor or guest memory?

> +
> +	if (kvm_arm_smmu_cur >=3D kvm_arm_smmu_count)
> +		return -ENOSPC;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENODEV;
> +
> +	if (of_property_read_bool(dev->of_node, "cavium,cn9900-broken-page1-reg=
space"))
> +		return -EINVAL;
[ ... ]
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index 2043c6dc1bdf8..d6d1e2d30ef63 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
[ ... ]
> +static int arm_smmu_device_probe_emu(struct auxiliary_device *auxdev,
> +				     const struct auxiliary_device_id *id)
> +{
> +	struct device *parent =3D auxdev->dev.parent;
> +	void *group;
> +	int ret;
> +
> +	dev_info(&auxdev->dev, "Probing from %s\n", dev_name(parent));
> +	group =3D devres_open_group(parent, NULL, GFP_KERNEL);
> +	if (!group)
> +		return -ENOMEM;
> +
> +	ret =3D arm_smmu_device_probe(to_platform_device(parent));

[Severity: High]
Can this devres setup lead to a use-after-free during platform device
removal?

If the parent physical platform device is destroyed (for example, via
dynamic DT overlay removal), the driver core calls devres_release_all()
which processes cleanups in reverse order of addition (LIFO).

Because arm_smmu_device_probe() adds the smmu allocation to the parent's
devres list after the auxiliary device was created in
smmu_create_aux_device(), the smmu memory gets freed first.

Following that, the auxiliary_device_destroy devres action executes,
unregistering the aux device and triggering driver unbind via
arm_smmu_device_remove_emu() and arm_smmu_device_remove(). Does this
result in dereferencing the already freed smmu struct?

> +	if (ret)
> +		devres_release_group(parent, group);
> +	else
> +		devres_close_group(parent, group);
> +	return ret;
> +}
> +
> +static void arm_smmu_device_remove_emu(struct auxiliary_device *auxdev)
> +{
> +	arm_smmu_device_remove(to_platform_device(auxdev->dev.parent));
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922131259.2975=
334-1-smostafa@google.com?part=3D11
