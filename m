Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E591E222580;
	Sat, 13 Jun 2026 00:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310905; cv=none; b=OgD31zuEK+nD+KF2fjM/JIVEPF95Tw3POViA4RnUopaiuCqrzORkIiuovAnlMklI6sZrb12N6L26zHtmqWBIoO7pNta9UntmJF+WWoG2wALTmqFnPaKT9fgBnJ6zAiXnn6wIBzcjbSIKUyCPZVF0XKQx/UBpLDJQgDnmQbYZ4wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310905; c=relaxed/simple;
	bh=aLgbRPI5QladbTRYfORYqfuEsYqcluMPLr7+HJ1XXbg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jS16mpMX8eAK0QWhLCrAKOUhd93BWcA2/e6UYQnxcCWnChb7q/hsaFVVrTQVuq2cH4qcGEn7atLXzk2w1nR0jo9hocxO+hA1sFSy6W05VRphSb/qAAvMFztKGRjlRRUHdYKPjvhR/d44ga5YL9vBhZdYk42STWrKKuNlErxC+b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jmmuvvwn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jmmuvvwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5951F000E9;
	Sat, 13 Jun 2026 00:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781310902;
	bh=m08QP8UI/SGYAlAmalaWB4AWEVPKZ72ZDKPFq57GncU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jmmuvvwn5FgiUVyOqHPwYVZg0jA17t4eKGfXRo6vpOHjTBi4JKUeBXM8Vh/1ZQxMU
	 txwELwp79FZwDp/mADe/rEch3YhMWbSChLj6WM1IwKpdMcp9LSp3e1jyyTQ1wyUx7V
	 zItUd8jviNVZJ3KviPn9/BUOWGO0A3aWSDVxYx2fWnpyjVbhuse+IU6jd3edIM2uPQ
	 //KmD7enbs/neTpbGARlEPW8dz7B37AD7TUOAeWsnvDZUmdxvQB+Tr0gdL9fnoqf/g
	 6mbaiEZHWUfy5mrkCmAxsANuGT2yEWKtstEkoTGBDBr579/0ZzbB+/3SDvWDGgBeSX
	 RJSUrAJy+yajQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 09/20] KVM: selftests: Add VFIO device support to
 eventfd IRQ test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260613002031.745413-10-seanjc@google.com>
References: <20260613002031.745413-10-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 13 Jun 2026 00:35:01 +0000
Message-Id: <20260613003501.DD5951F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] probe_iommu_type() incorrectly probes the /dev/vfio directory in=
stead of the /dev/vfio/vfio legacy container character device, bypassing th=
e framework's intended skip behavior for unprivileged users.
- [Medium] vfio_setup_msi() hardcodes the device's DMA region IOVA to 0, wh=
ich can cause IOMMU mapping failures on platforms that reserve or restrict =
IOVA 0.
--

commit 2bdd8160743775c8d18e4004e72e7ff0898fbd70
Author: David Matlack <dmatlack@google.com>

KVM: selftests: Add VFIO device support to eventfd IRQ test

This commit extends the eventfd IRQ test to support triggering interrupts
using a VFIO device instead of manually signaling the eventfd. It also
probes for IOMMUFD vs legacy VFIO availability.

Link: https://lore.kernel.org/all/20260602222941.3133236-1-jrhilke%40google=
.com [1]

> diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selft=
ests/kvm/irq_test.c
> index 9f8895b898214..6888be54ee4a9 100644
> --- a/tools/testing/selftests/kvm/irq_test.c
> +++ b/tools/testing/selftests/kvm/irq_test.c
[ ... ]
> @@ -55,6 +58,36 @@ static void *vcpu_thread_main(void *arg)
>  	return NULL;
>  }
> =20
> +static int vfio_setup_msi(struct vfio_pci_device *device)
> +{
> +	const int flags =3D MAP_SHARED | MAP_ANONYMOUS;
> +	const int prot =3D PROT_READ | PROT_WRITE;
> +	struct dma_region *region;
> +
> +	/* A driver is required to generate an MSI. */
> +	TEST_REQUIRE(device->driver.ops);
> +
> +	/* Set up a DMA-able region for the driver to use. */
> +	region =3D &device->driver.region;
> +	region->iova =3D 0;

[Severity: Medium]
Does hardcoding the DMA region's IOVA to 0 cause IOMMU mapping failures on
platforms that reserve or restrict IOVA 0?

If IOVA 0 is unsupported, it seems like iommu_map() will fail and trigger a
test assertion crash instead of running.

> +	region->size =3D SZ_2M;
> +	region->vaddr =3D kvm_mmap(region->size, prot, flags, -1);
> +	TEST_ASSERT(region->vaddr !=3D MAP_FAILED, "mmap() failed\n");
> +	iommu_map(device->iommu, region);
> +
> +	vfio_pci_driver_init(device);
> +	return device->driver.msi;
> +}
[ ... ]
> @@ -74,11 +107,29 @@ static void kvm_route_msi(struct kvm_vm *vm, u32 gsi=
, struct kvm_vcpu *vcpu,
>  	vm_ioctl(vm, KVM_SET_GSI_ROUTING, &routing.header);
>  }
> =20
> +static const char *probe_iommu_type(void)
> +{
> +	int io_fd;
> +
> +	io_fd =3D open("/dev/iommu", O_RDONLY);
> +	if (io_fd >=3D 0) {
> +		close(io_fd);
> +		return MODE_IOMMUFD;
> +	}
> +
> +	io_fd =3D __open_path_or_exit("/dev/vfio", O_RDONLY,

[Severity: Medium]
Because /dev/vfio is a directory, will this open() call succeed for any user
with read and execute permissions to the directory, bypassing the intended =
skip
behavior?

Should this probe the /dev/vfio/vfio legacy container character device inst=
ead
so the test can skip gracefully for unprivileged users rather than crashing
later in iommu_init() due to lack of device permissions?

> +				    "Is VFIO (or IOMMUFD) loaded and enabled?");
> +	close(io_fd);
> +	return MODE_VFIO_TYPE1_IOMMU;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260613002031.7454=
13-1-seanjc@google.com?part=3D9
