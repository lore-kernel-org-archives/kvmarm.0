Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7EC384CD4;
	Thu, 15 Oct 2026 14:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075743; cv=none; b=afJSPlNpe8ViK1poAiyPuG0dxbFQhPCdpheQ2MbDyZ1Prl9/mFI9yyUhOTpjT97ZpuzmJr6/l51t93an6JL8RAkYyKlifWOofuMCJ7jXhOVinjAPQHItfgE5ssdB7tWSPuouyWflLj6BNYNqsnNpJIEhPHdt1QbQbMwFaCYbFX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075743; c=relaxed/simple;
	bh=e+/hiPEyfV/71lr2xMXM3dbfkE4HxZp1gyq4QfAyFCk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=TpGmmh2w1/sA7Zqo21BQaBg9YNXFGJdzgrk1O4VfMxY/HoTlnnL3gXWPmxcrBman49UL5V/bnrJH1nXoxYBPYZIGAK+noJPw+7DQyBNEPVORjf2ic+/Ua35G4v4a8bQ7ZD1OgoyruUGIuJQBfAVaFwaGmKVNzIsTbr04GP11LBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTBXtSuR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTBXtSuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937FE1F000C4;
	Thu, 15 Oct 2026 14:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075742;
	bh=hPgsp5mk9UmQR5EXdQQuBho4RZ/GGl5KVCts0gDXoOI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JTBXtSuR0ucd8oqNIEeMVoHTZq2Y8nf41xNfd/69yWy0vp+664i2NYqvOwS5KC7Wg
	 JYG/TYwY5ixj8MUqeQKlnf2/MFUbyMvniXyBmYSTqaK7woJzdJ4VRs2nD+yITjf3+h
	 NGlGR/QOsB/iK2hNb8gd8h76CvnDWoqcPyxvIq/sDPeVN2s39u+WCN3t/dD5qBuuRC
	 9Jg9GYqpkk2rre7iimE6UOdVWkVOqO2jIjJesJO6kTh9Gcw8/oS5I6JhoEZA3qAY7n
	 kf/TlY+xWzWZLn4OZtqRQ49fjIEkuh4wQi65ce/U4uAQrqZMTQtBhzs3/7Qayp2Pmc
	 IiDxazEHW3ipA==
Message-ID: <sashiko-outbox-172994@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 15/15] misc/arm-cla: Add vfio-mdev user interface
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Roberts" <ryan.roberts@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, robh@kernel.org, conor+dt@kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015142552.4128028-16-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-16-ryan.roberts@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 14:49:01 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] sysfs: NULL pointer dereference in cpu_show() during mdev probe
- [Low] kconfig: ARM_CLA_MDEV linkage error when VFIO or KVM are modules
- [Low] char: cla_mdev_ioctl() returns -EINVAL instead of -ENOTTY for unkno=
wn ioctls
--

commit dd12438e45e5acb03e5d810526fd148e9b134169
Author: Jean-Philippe Brucker <jpb@kernel.org>

misc/arm-cla: Add vfio-mdev user interface

This commit implements an interface to assign CLA devices to KVM guests
using the VFIO mediated device framework. It sets up the stage-2 MTC for
the assigned VMs and exposes a sysfs interface for device discovery.

> diff --git a/drivers/misc/arm-cla/Kconfig b/drivers/misc/arm-cla/Kconfig
> index f8436a12c1e64..5def727b7a342 100644
> --- a/drivers/misc/arm-cla/Kconfig
> +++ b/drivers/misc/arm-cla/Kconfig
> @@ -8,3 +8,19 @@ config ARM_CLA
>  	  accelerators. It is only accessible from its associated CPU.
> =20
>  	  If unsure, say N.
> +
> +config ARM_CLA_MDEV
> +	bool "Mediated device for Arm CLA"
> +	default y
> +	depends on KVM
> +	depends on VFIO

[Severity: Low]
Will this cause linker errors if ARM_CLA is built-in but KVM or VFIO
are built as modules?

Because ARM_CLA_MDEV is a bool depending on tristate symbols (KVM, VFIO),
it evaluates to y even when KVM or VFIO are m. If ARM_CLA=3Dy, cla-mdev.o
is compiled into the kernel. Since cla-mdev.c references module symbols
from vfio and kvm, this can result in undefined reference errors during
the kernel build.

Should the Kconfig dependencies enforce that if ARM_CLA is built-in, its
tristate dependencies must also be built-in?

> diff --git a/drivers/misc/arm-cla/cla-mdev.c b/drivers/misc/arm-cla/cla-m=
dev.c
> new file mode 100644
> index 0000000000000..66c5dd197542e
> --- /dev/null
> +++ b/drivers/misc/arm-cla/cla-mdev.c

[ ... ]

> +static ssize_t cpu_show(struct device *dev, struct device_attribute *att=
r,
> +			char *buf)
> +{
> +	struct cla_mdev *mdev =3D dev_get_drvdata(dev);
> +
> +	return sysfs_emit(buf, "%u\n", mdev->dev->cpu);

[Severity: High]
Can this result in a NULL pointer dereference during device probe?

The cla_mdev_driver defines dev_groups =3D cla_mdev_sysfs_groups, meaning
the sysfs core creates the cpu file before cla_mdev_probe() is called.
If userspace reads the newly created file concurrently, cpu_show() executes
before the drvdata is set later in cla_mdev_probe():

static int cla_mdev_probe(struct mdev_device *mdev)
{
    ...
    dev_set_drvdata(&mdev->dev, cla_mdev);

This would cause dev_get_drvdata() to return NULL, leading to a crash
when accessing mdev->dev->cpu.

[ ... ]

> +static long cla_mdev_ioctl(struct vfio_device *vdev, unsigned int cmd,
> +			       unsigned long arg)
> +{
> +	struct cla_mdev *mdev =3D
> +		container_of(vdev, struct cla_mdev, vdev);
> +	unsigned long minsz;
> +
> +	switch (cmd) {
> +	case VFIO_DEVICE_GET_INFO:
> +	{

[ ... ]

> +	}
> +	case VFIO_DEVICE_RESET:
> +		return cla_mdev_reset(mdev);
> +	case VFIO_DEVICE_GET_IRQ_INFO:
> +	case VFIO_DEVICE_SET_IRQS:
> +	default:
> +		return -EINVAL;
> +	}
> +	return -ENOTTY;

[Severity: Low]
Does this ioctl handler incorrectly return -EINVAL instead of -ENOTTY for
unknown commands?

The default case catches all unknown ioctls and returns -EINVAL, which
makes the final return -ENOTTY unreachable. Userspace applications probing
for features often rely on -ENOTTY to properly detect unsupported
commands. Returning -EINVAL could mislead them into thinking the command
is supported but their arguments are invalid.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015142552.4128=
028-1-ryan.roberts@arm.com?part=3D15
