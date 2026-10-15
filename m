Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFC1483819
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096506; cv=none; b=hkgPVG8RKERvA4Qht9yjklQ2kguKR0U9prDHNFgARDVR7ttgWDI52csoJjyYSJ1FpS1X5rCX83KA/SlqcvK62u4Wc2kd98xfajfnGGdVlC1XdT4JsFwv+oV00oPZoWUA6iki2oYEXqmoXpN7IsC9OIe6BPfUIgT1czMol0idHNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096506; c=relaxed/simple;
	bh=TVChWadpAOPtY0rkOvHJCnqFfP512M404lz0L8QlT1o=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QrH7qLfxBB9f+pbMXAdLpLCqpRC7Gi2NzNpD9KHkSk+h6e17UmclndPKr3rOCag0hZMBuiOt6iU8m6rrFB3uqj7DMBPByoHAUfVRelymeUnJ1vQR94lBY2i8PX1WkxZC+uPdJH+6edfVeqGQpwr/G4HKyyHeNZ4E3p1q9su2yhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KCHjq5sl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KCHjq5sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC401F000C4;
	Thu, 15 Oct 2026 20:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096503;
	bh=9urv0JaO4o70dxT7ythyknY9Gm825zCp5Kq/DSq23gk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KCHjq5slaKDwfciZQXhu3etE82hZSKuKxy6npx+nMsqMPMTPI/nt34rbS7nCHSw3a
	 tX9U3tdJIKZmjLHKaUXzgGViRTtsKx4bX9KONYa5RciDg4pFNpc4goy3O88SEs9p+G
	 2A7Rt1245FML2Vw7EXb59GGgtdjKJT3tp3wBaqk11vJ37N6VlWJueh5QpXWd9C97Wd
	 LvXQ9GJCvCfPqRqz1Zhcf/Gea4VXH44sTAth37KWmLxJGUp0XSLJax5Cfo1BL8PAx6
	 oEWV91w3/RrLnKGTUnf55/B3TnnJp5e3ovkaey3+NkxPmXzNKqOYXr2Rl1Zgvs2Ie6
	 hfCq4jCwzMejA==
Message-ID: <sashiko-outbox-173402@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015200903.2735565-12-smostafa@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-12-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:35:03 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] iommu/arm-smmu-v3: native driver fallback bypasses pKVM DMA is=
olation
- [High] mm: UAF of smmu due to devres LIFO inversion on deferred probe
- [Medium] iommu/arm-smmu-v3: aux device creation failure aborts initializa=
tion for remaining SMMUs
--

commit 989c8869198ba4ebe30e4fc7554bb66910985d0b
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Add the kernel driver
   =20
When KVM runs in protected mode with CONFIG_ARM_SMMU_V3_PKVM, the
hypervisor owns the SMMUv3 hardware and presents emulated SMMUs to the
host through trap and emulate. This patch adds the host side of the driver,
using an auxiliary device approach for the emulated SMMUs.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-pkvm-init.c b/driv=
ers/iommu/arm/arm-smmu-v3/arm-smmu-v3-pkvm-init.c
> new file mode 100644
> index 0000000000000..5c5f0ff455e3b
> --- /dev/null
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-pkvm-init.c

[ ... ]

> +static int __init kvm_arm_smmu_v3_register(void)
> +{
> +	size_t nr_pages =3D smmu_hyp_pgt_pages();
> +	int ret;
> +
> +	if (!is_protected_kvm_enabled() || !nr_pages)
> +		return 0;
> +
> +	ret =3D kvm_arm_smmu_array_alloc();
> +	if (ret)
> +		goto out_err;
> +
> +	ret =3D platform_driver_probe(&smmuv3_nesting_driver, smmuv3_nesting_pr=
obe);
> +	if (ret)
> +		goto out_free;
> +
> +	ret =3D pkvm_iommu_register_driver(&kvm_nvhe_sym(smmu_ops), nr_pages);
> +	if (ret)
> +		goto out_unregister;
> +
> +	/*
> +	 * These variables are stored in the nVHE image, and won't be accessible
> +	 * after KVM initialization. Ownership of kvm_arm_smmu_array will be
> +	 * transferred to the hypervisor as well.
> +	 */
> +	kvm_hyp_arm_smmu_v3_smmus =3D kvm_arm_smmu_array;
> +	kvm_hyp_arm_smmu_v3_count =3D kvm_arm_smmu_cur;
> +	return ret;
> +
> +out_unregister:
> +	platform_driver_unregister(&smmuv3_nesting_driver);

[Severity: Critical]
Does this fail-open behavior bypass pKVM DMA isolation?

If an SMMU is rejected by smmuv3_nesting_probe() (e.g. due to Cavium errata
or unaligned MMIO), or if pkvm_iommu_register_driver() fails, the affected
SMMU devices are left unbound or the nesting driver is unregistered.

Later, the native arm_smmu_driver is registered unconditionally in
arm-smmu-v3.c and will successfully bind to these unbound SMMU devices.
Since the hypervisor wasn't given the MMIO regions for the skipped SMMUs,
it does not enforce stage-2 trapping on them. The host EL1 could then
program these native SMMUs to perform unrestricted DMA into pKVM-protected
guest or hypervisor memory, compromising protected VMs.

> +out_free:
> +	kvm_arm_smmu_array_free();
> +out_err:
> +	kvm_arm_smmu_count =3D 0;
> +	kvm_arm_smmu_array =3D NULL;
> +	return ret;
> +}
> +
> +static int __init smmu_create_aux_device(struct device *dev, void *data)
> +{
> +	static int dev_id;
> +	struct auxiliary_device *auxdev;
> +
> +	auxdev =3D __devm_auxiliary_device_create(dev, "protected_kvm",
> +						"smmu_v3_emu", NULL, dev_id++);
> +	if (!auxdev)
> +		return -ENODEV;
> +	return 0;
> +}
> +
> +static int __init kvm_arm_smmu_v3_post_init(void)
> +{
> +	if (!kvm_arm_smmu_count)
> +		return 0;
> +
> +	/*
> +	 * If KVM failed to initialise, the host stage-2 is never enabled and
> +	 * the SMMUs are driven natively through the same path.
> +	 */
> +	WARN_ON(driver_for_each_device(&smmuv3_nesting_driver.driver, NULL,
> +				       NULL, smmu_create_aux_device));

[Severity: Medium]
Does this halt initialization for all remaining SMMUs if one fails?

In kvm_arm_smmu_v3_post_init(), driver_for_each_device() iterates over all
bound SMMUs. If smmu_create_aux_device() fails (e.g. due to an ID collision
or memory allocation failure in __devm_auxiliary_device_create()), it
returns -ENODEV.

The core driver_for_each_device() function halts iteration and returns
immediately upon receiving a non-zero value. Consequently, if a single SMMU
fails aux device creation, all subsequent SMMUs are silently skipped. These
skipped SMMUs won't be probed by the host's arm_smmu_driver_emu, breaking
DMA translation for any peripherals behind them.

Should the callback log the error and return 0 to allow the remaining
devices to initialize?

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index c2ec33c763a0f..66f38c54742b8 100644
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

[Severity: High]
Can this lead to a use-after-free of the smmu struct due to devres LIFO
inversion during a deferred probe retry?

If arm_smmu_device_probe() returns -EPROBE_DEFER (e.g. from
iommu_device_register() -> bus_iommu_probe() -> probe_iommu_group()),
arm_smmu_device_probe_emu() correctly cleans up and returns the error,
causing the auxiliary bus to defer the probe.

However, __devm_auxiliary_device_create() has already proceeded to register
the auxiliary_device_destroy action on the parent's devres list. Later,
when the deferred probe retries and succeeds, arm_smmu_device_probe()
allocates the smmu struct via devm_kzalloc() and attaches it to the parent's
devres list *after* the destroy action.

On parent platform device removal (e.g. via device tree overlay removal or
system teardown), devres_release_all(parent) destroys devres actions in LIFO
order. It first frees the smmu struct, and subsequently executes
auxiliary_device_destroy. This unregisters the aux device and triggers
arm_smmu_device_remove_emu(), which then dereferences the freed smmu pointe=
r.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015200903.2735=
565-1-smostafa@google.com?part=3D11
