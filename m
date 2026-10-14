Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCD235E952;
	Wed, 14 Oct 2026 09:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791971690; cv=none; b=idmOTewuvoIUZHRfeYK+vQFzLJr81X0zD8p40kf+CYS2z9QR4VPuLC0LxPu1mKM792xMGwNTCD5bHV3TAQCiVhCOLXYHdkZ4H1n1eYV2VWVJamiPQMaa2ibcRpH50cEEQ/vMLZ8vS5CB71oKQ91KnFNH1vbHQ5eETyrOzPPij1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791971690; c=relaxed/simple;
	bh=by9HS27Hk35QV7L5B10RxxLWISde+0aTPFaY6mRSkFM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KfwjWw5jV4ZXjJxSMRPAphmgm+470kNJm41vLDZwlaBbwNIZtpKWxxqYBxy8edenFVVlVOnyI30qQ1FM+kpaV/izfDd5Gx7Wl82V9ypMjH0C9cUDH+gMz3J7vA3Zma/925BQqyRK9Rl0TVMubI0ZpcFJj4UwNe6mgDJdogAueR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WS0D7JEA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WS0D7JEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FD11F000FF;
	Wed, 14 Oct 2026 09:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791971688;
	bh=pg5/1a/r7w84WCoZomj2AxxKYJZ6sPpaMM9WUP5HdHc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WS0D7JEAkz75c9YGPZCOkXsNWLX+F/ZLjJQuVu5NFbpRJYrP3q5/TACG7Ji2pQlEO
	 EuelI91UT2IUj1fsIaWhFw/pYdnzPR7w+yJuUAid3r/gsXCovoAYKA8fzzoPR9UOUm
	 u1qQUG661tdOjTyWUg+KYbiMQfBkrDOd8O3usjIvCJYBC7yEstapxxWVKShQXfIuqR
	 hLnES47412Jbnz0DRMH0fOvjJIYuu4Oib0/oucAaR+W2E3ccMjFdNOse1tzMpoiGrb
	 PEIBPhYEjPC/vhP3udEbtBB9jEv16ch2eHvWF5ACFEFxtXjPxKq+xPbOUC32eb0bMC
	 1JND5dR4b2CZw==
Message-ID: <sashiko-outbox-171101@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 08/11] iommufd/selftest: Add mock-domain IOVA
 queries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fred Griffoul" <griffoul@gmail.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261014093733.90312-9-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
 <20261014093733.90312-9-griffoul@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 09:54:47 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] iommufd: soft lockup in iommufd_test_md_check_mapped loop
- [Medium] iommufd: UAF race between mock page table walk and dma-buf revoke
--

commit 64ca9f35d00cc158de5f4700e220a39eb8a04615
Author: Fred Griffoul <fgriffo@amazon.co.uk>

iommufd/selftest: Add mock-domain IOVA queries

A test of memory that can be taken back or replaced does not know in
advance which frame a device reaches. IOMMU_TEST_OP_MD_CHECK_MAP only
compares against a known buffer.

Add MD_CHECK_MAPPED, which checks that a range is fully mapped or fully
unmapped, and MD_IOVA_TO_PHYS, which returns the frame behind an IOVA,
or 0 if it is unmapped. Both refuse an IOVA outside the domain's
aperture.

> diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/sel=
ftest.c
> index af07c642a5260..1f5cd2d00fda8 100644
> --- a/drivers/iommu/iommufd/selftest.c
> +++ b/drivers/iommu/iommufd/selftest.c
[ ... ]
> +static int iommufd_test_md_iova_to_phys(struct iommufd_ucmd *ucmd,
> +					unsigned int mockpt_id,
> +					unsigned long iova)
> +{
> +	struct iommu_test_cmd *cmd =3D ucmd->cmd;
> +	struct iommufd_hw_pagetable *hwpt;
> +	struct mock_iommu_domain *mock;
> +	unsigned int page_size;
> +	int rc;
> +
> +	hwpt =3D get_md_pagetable(ucmd, mockpt_id, &mock);
> +	if (IS_ERR(hwpt))
> +		return PTR_ERR(hwpt);
> +
> +	page_size =3D 1 << __ffs(mock->domain.pgsize_bitmap);
> +	if (iova % page_size || !mock_domain_covers(mock, iova, page_size)) {
> +		rc =3D -EINVAL;
> +		goto out_put;
> +	}
> +	down_write(mock_domain_unmap_lock(hwpt));
> +	cmd->iova_to_phys.out_phys =3D
> +		mock->domain.ops->iova_to_phys(&mock->domain, iova);

[Severity: Medium]
Could this page table walk race with a concurrent dma-buf revoke or memory
provider unmap?

Since those unmap operations run under their own pages mutex instead of
domains_rwsem, it seems possible for a concurrent unmap (for instance,
triggered by a fuzzer or concurrently running test) to free a page table
level while iova_to_phys() is still walking it, potentially leading to a
use-after-free.

> +	up_write(mock_domain_unmap_lock(hwpt));
> +	rc =3D iommufd_ucmd_respond(ucmd, sizeof(*cmd));
> +out_put:
> +	iommufd_put_object(ucmd->ictx, &hwpt->obj);
> +	return rc;
> +}
> +
> +static int iommufd_test_md_check_mapped(struct iommufd_ucmd *ucmd,
> +					unsigned int mockpt_id,
> +					unsigned long iova, size_t length,
> +					bool mapped)
> +{
[ ... ]
> +	down_write(mock_domain_unmap_lock(hwpt));
> +	for (; length; length -=3D page_size, iova +=3D page_size) {
> +		bool is_mapped =3D
> +			mock->domain.ops->iova_to_phys(&mock->domain, iova) !=3D 0;

[Severity: Medium]
Can this loop run for an unbounded amount of time and cause a soft lockup?

Since the test ioctl interface allows very large values for length, and
page_size can be as small as 4096 bytes, this loop could iterate trillions
of times without yielding.

Because it holds domains_rwsem for writing, would this stall the CPU and
starve other users of the semaphore?

> +
> +		if (is_mapped !=3D mapped) {
> +			rc =3D -ENOENT;
> +			break;
> +		}
> +	}
> +	up_write(mock_domain_unmap_lock(hwpt));
> +
> +out_put:
> +	iommufd_put_object(ucmd->ictx, &hwpt->obj);
> +	return rc;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014093733.9031=
2-1-griffoul@gmail.com?part=3D8
