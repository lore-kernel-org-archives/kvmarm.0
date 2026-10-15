Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E1C3AA518;
	Thu, 15 Oct 2026 14:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075453; cv=none; b=D7u9SCwbxUnQ2+I/t2GV4nUgAFSupDuCCkzHSq7ECU3sR6LsVkKGKdVNvjj2jOZfRcIUli5sJvfxVP+0sYtW1lg0nDPtBbn4DhM47dSF0u3p/phGu9FXYfu1tgNh7PWFm28VnH18ys2hcjC+khZ8sGMDicrHTHAm8PCGlE472rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075453; c=relaxed/simple;
	bh=6HZ2EJeaBRzMwQJee5p1grA8MrvE8bTCMFJm5GIB5c8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=R0uFx/oHwiG184Y2jSo0r7aM7QT3h24i0ebCFpwVz2iQ7DbToCJZ7yTlkwdPx+1luV0J+AaB9wWqwLO96qLxVVnL7p+AikmrEmeb0UQrdqgyesePxA+/zRP4tAraxNkwM818FlBNIrlu7ghABcqmOLPSZg0K8t+QAKtLKDai+Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TOo1oVXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TOo1oVXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A971F000C4;
	Thu, 15 Oct 2026 14:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075452;
	bh=z+CDkoCSZLN1MOVhIw3dKh4lpkaRSWDSWyNkXPNjypY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TOo1oVXD7ZPUEkiTcvuKJC1vohQVa/ydz1nmAWXc4OJW4tHY3VWHAUz+CZeSzCREe
	 6Ck9P3JeYcoM6wwv4Q7Y/Tw/U3yhLEOrfcmmndHN12CV93d5e0JHLBvdCJXzG1139w
	 SZXYHTWOp/gSJKeChOAcsjq8KN9B+iJofNlNWs9gk15gmnWvPsMsPvmYnzsnr8wVrA
	 L8fjC3GsWr5uQVN+DxNV+jyF1tc+rp0g/oYA0Ab0J2fhaXj87+lStrIeEo+Fb3ZFqT
	 YmY0Wtho8uknR/7qKJqqIEN4wf/D0ppuIbRGi+Vk5XMk9vCkcT8C+BwzISOeH5lOWT
	 oXMHleAfbBHig==
Message-ID: <sashiko-outbox-172976@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 12/15] vfio: Support VFIO devices that access the
 CPU MMU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Roberts" <ryan.roberts@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, robh@kernel.org, conor+dt@kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015142552.4128028-13-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-13-ryan.roberts@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 14:44:11 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] vfio: NULL pointer dereference in vfio_df_iommufd_bind() via cdev =
ioctl
- [High] vfio: NULL pointer deref when binding IOMMUFD to CPU_MMU cdev
--

commit 147c0e7516a85b91b63d3c3d8f78088a9ca5c65f
Author: Jean-Philippe Brucker <jpb@kernel.org>

vfio: Support VFIO devices that access the CPU MMU

Support devices that are attached to a CPU and perform DMA through a
MMU without an IOMMU or VFIO container. The VMM uses device-specific
knowledge to handle virtual device creation.

> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 423ead48aafe3..41fee81a14cbb 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -344,7 +344,8 @@ static int __vfio_register_dev(struct vfio_device *de=
vice,
>  {
>  	int ret;
> =20
> -	if (WARN_ON(IS_ENABLED(CONFIG_IOMMUFD) &&
> +	if (type !=3D VFIO_CPU_MMU &&
> +	    WARN_ON(IS_ENABLED(CONFIG_IOMMUFD) &&
>  		    (!device->ops->bind_iommufd ||
>  		     !device->ops->unbind_iommufd ||
>  		     !device->ops->attach_ioas ||
>  		     !device->ops->detach_ioas)))
>  		return -EINVAL;

[Severity: High]
Could this bypass lead to a NULL pointer dereference for users of the
character device interface?

When CONFIG_VFIO_DEVICE_CDEV is enabled, vfio_device_add() automatically
creates a character device node (e.g., /dev/vfio/devices/vfioX) for the
registered device. If an untrusted user opens this cdev file and invokes
the VFIO_DEVICE_BIND_IOMMUFD ioctl, the request routes through the
following path:

vfio_df_ioctl_bind_iommufd()
  vfio_df_open()
    vfio_df_device_first_open()
      vfio_df_iommufd_bind()

Inside vfio_df_iommufd_bind() in drivers/vfio/iommufd.c, the code=20
unconditionally executes:

return vdev->ops->bind_iommufd(vdev, ictx, &df->devid);

Since the updated check permits VFIO_CPU_MMU devices to be registered=20
without providing a bind_iommufd callback, this would result in an
immediate NULL pointer dereference.=20

Similarly, calling the VFIO_DEVICE_ATTACH_IOMMUFD_PT ioctl on the cdev=20
unconditionally dereferences the attach_ioas pointer in=20
vfio_df_ioctl_attach_pt(), which would also crash the kernel.

Should there be explicit checks in the cdev ioctl handlers to return
-EOPNOTSUPP for devices lacking these callbacks, or should VFIO_CPU_MMU=20
devices perhaps be excluded from cdev creation entirely?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015142552.4128=
028-1-ryan.roberts@arm.com?part=3D12
