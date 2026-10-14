Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E966254AFF;
	Wed, 14 Oct 2026 09:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791971495; cv=none; b=SeVT39I2ip5EuCB9b81vmrLPHcDI7WAWBy7U/fo1ndOfIROntUearg+/Gl24K4oFlR8/NsdYvcWbhQX8NFuSQCERwwvbzhkO1zkHriZCNiKPuzw75Ca1Lz83cdo9HzP8d9w6AXdxfO9ZTwYvvRpFucAs4kTxbEv/cDPUrERRNk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791971495; c=relaxed/simple;
	bh=YgpNkwA5vZ+A7y2XTYRSQdghVYmtyhesaYY4nVWbvqI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=otvq61YOQoqgKQYXtyjuTeGU5TOUrMdjtHXQFO43JA/knOiPI4TWwdfnb7bRYDm5aHWCwwUMdp1F2EmelVGEV+7R+HAU2ZXYqlCTPdbUQSSRXeeubBHT4/DzzeR4CJZTVn/wnsLETKfH8XOfhVmCja75zayUCDH6y3E4OG+gotU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BnM3+Gb0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BnM3+Gb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C791F000FF;
	Wed, 14 Oct 2026 09:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791971494;
	bh=Z+c7wWPw2i4fZEitImCxJiR+jCicY0RPg4t6NPlbliY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BnM3+Gb0dVynged3KuBiQBMPadvMY7nvzEv0cM+ZVGzuq8oTOwHj1sc5uq/k64f8f
	 oxktsGqAtTGdQQtMATcNYYua2olml2k7KvSHRlLFAYL4gy9SHrkubydjOMPKGCxouJ
	 CdSWurNfWdLNZHUmNAf/3UjD8JXd3GpTadl0UKsA08kF04T+75kiJptmsmggcR7Vyf
	 GYOeshOKaP/QjrFZlquxKXFtdyJFu29wJev94V2RmC9s6IZDiaHeRysHKV63gJ0yBC
	 lkcXQ0wtkYpRS2ugxcf53YLARMsPQVlEwtJ6nJvm7isn7Bs2VThh2K9qs30Ikwc9nQ
	 qH3VQY5fGye4g==
Message-ID: <sashiko-outbox-171093@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 06/11] iommufd: Map memory provider files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fred Griffoul" <griffoul@gmail.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261014093733.90312-7-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
 <20261014093733.90312-7-griffoul@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 09:51:33 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] iommufd: 32-bit truncation of file offset breaks provider revokes
- [Medium] iommufd: missing cond_resched() in large IOVA mapping/unmapping =
loops
--

commit b6da636b8b49032486fd2a6044789fc9bf757f2b
Author: Fred Griffoul <fgriffo@amazon.co.uk>

iommufd: Map memory provider files

This patch adds support for mapping memory provider files into iommufd=20
domains. It bypasses pinning and accounting, and allows the provider to=20
dynamically back or revoke memory ranges while keeping mappings in sync.

> diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd=
/io_pagetable.h
> index ba539bfaac317..80d926c86c6cf 100644
> --- a/drivers/iommu/iommufd/io_pagetable.h
> +++ b/drivers/iommu/iommufd/io_pagetable.h
> @@ -207,6 +213,14 @@ struct iopt_pages_dmabuf {
>  	unsigned long start;
>  };
> =20
> +struct iopt_pages_provider {
> +	struct mem_provider_attachment att;
> +	/* Byte offset in the provider file, always PAGE_SIZE aligned */
> +	unsigned long start;

[Severity: High]
The UAPI structure iommu_ioas_map_file defines the file start offset as a
64-bit __aligned_u64, but it is stored here as an unsigned long. On 32-bit
systems, does this silently truncate offsets larger than 4GB?

> +	/* Charged for the page tables that a revoke allocates */
> +	struct mem_cgroup *memcg;
> +};
> +
>  /*
>   * This holds a pinned page list for multiple areas of IO address space.=
 The
>   * pages always originate from a linear chunk of userspace VA. Multiple

[ ... ]

> diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
> index 660af3d46f5e1..aa7740326ad6a 100644
> --- a/drivers/iommu/iommufd/pages.c
> +++ b/drivers/iommu/iommufd/pages.c
> @@ -238,6 +240,35 @@ static void iommu_unmap_nofail(struct iommu_domain *=
domain, unsigned long iova,
>  	WARN_ON(ret !=3D size);
>  }
> =20
> +/*
> + * Provider pages are mapped with PAGE_SIZE entries, and may have holes.=
  Some
> + * IOMMU drivers warn when asked to unmap an IOVA that is not mapped, so=
 find
> + * the runs that are mapped and unmap each one, without touching the hol=
es.
> + * iopt_provider_map() refuses frame 0, which iova_to_phys() reports for
> + * an IOVA that is not mapped.
> + */
> +static void iopt_provider_unmap(struct iopt_area *area,
> +				struct iommu_domain *domain,
> +				unsigned long start_index,
> +				unsigned long last_index)
> +{
> +	unsigned long iova =3D iopt_area_index_to_iova(area, start_index);
> +	size_t left =3D (last_index - start_index + 1) * PAGE_SIZE;
> +
> +	while (left) {
> +		size_t len =3D 0;
> +
> +		while (len < left && iommu_iova_to_phys(domain, iova + len))
> +			len +=3D PAGE_SIZE;

[Severity: Medium]
Memory provider files can be extremely large. Since this loop unmaps the=20
entire range in a single pass without explicitly yielding the CPU, could=20
this cause soft lockups on kernels without forced preemption? Would it be
better to add a cond_resched() here?

> +		if (len)
> +			iommu_unmap_nofail(domain, iova, len);
> +		/* Step over the run and the hole page that ended it. */
> +		len =3D min(len + PAGE_SIZE, left);
> +		iova +=3D len;
> +		left -=3D len;
> +	}
> +}

[ ... ]

> @@ -1647,6 +1687,228 @@ void iopt_pages_untrack_all_domains(struct iopt_a=
rea *area,
>  	}
>  }
> =20
> +static int iopt_provider_prot(struct iopt_area *area, u32 attrs)
> +{
> +	int prot =3D area->iommu_prot;
> +
> +	if (attrs & MEM_PROVIDER_ATTR_READONLY)
> +		prot &=3D ~IOMMU_WRITE;
> +	if (mem_provider_type(attrs) !=3D MEM_PROVIDER_TYPE_RAM) {
> +		prot &=3D ~IOMMU_CACHE;
> +		prot |=3D IOMMU_MMIO;
> +	}
> +	return prot;
> +}
> +
> +/*
> + * Map what the provider backs in [start_index, last_index] of the area =
into
> + * @domain, and leave the holes unmapped.  Each frame is mapped with a
> + * PAGE_SIZE entry, so that a revoke of part of a large block never has =
to
> + * split a larger IOMMU page.  On failure nothing in the range is mapped.
> + */
> +static int iopt_provider_map(struct iopt_area *area, struct iopt_pages *=
pages,
> +			     struct iommu_domain *domain,
> +			     unsigned long start_index,
> +			     unsigned long last_index)
> +{
> +	unsigned long base =3D pages->provider.start >> PAGE_SHIFT;
> +	unsigned long index =3D start_index;
> +	int rc;
> +
> +	lockdep_assert_held(&pages->mutex);
> +
> +	if ((1UL << __ffs(domain->pgsize_bitmap)) > PAGE_SIZE)
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * A revoke unmaps under pages->mutex only, so it would race with a
> +	 * dirty bitmap read, and lose the dirty bits of what it unmaps.
> +	 * Provider pages are not mapped in a domain with dirty tracking.
> +	 */
> +	if (domain->dirty_ops)
> +		return -EOPNOTSUPP;
> +
> +	while (index <=3D last_index) {
> +		unsigned long pfn, iova, block_end, nr, i;
> +		int order =3D PUD_ORDER;
> +		u32 attrs;
> +		int prot;
> +
> +		rc =3D mem_provider_get_page(&pages->provider.att, base + index,
> +					   &pfn, &order, &attrs);

[Severity: Medium]
Similarly, mapping a very large provider file could translate to processing
millions of frames in one go. Should this loop also yield the CPU to prevent
soft lockups?

> +		if (rc =3D=3D -EFAULT) {
> +			index++;
> +			continue;
> +		}

[ ... ]

> +/*
> + * The provider changed the frames behind [offset, offset + len).  In ev=
ery
> + * domain, unmap the range and map what the provider backs now.  A devic=
e that
> + * accesses the range in between faults.
> + */
> +static void iopt_provider_revoke(struct mem_provider_attachment *att,
> +				 loff_t offset, loff_t len)
> +{
> +	struct iopt_pages *pages =3D
> +		container_of(att, struct iopt_pages, provider.att);
> +	u64 start =3D pages->provider.start;
> +	u64 end =3D start + (u64)pages->npages * PAGE_SIZE;
> +	struct iopt_pages_track *track;
> +	struct mem_cgroup *old_memcg;
> +	unsigned long first, last;
> +	int rc;
> +
> +	if (offset < 0 || len <=3D 0 || offset >=3D end || offset + len <=3D st=
art)
> +		return;

[Severity: High]
Because pages->provider.start is stored as an unsigned long, it will wrap=20
on 32-bit systems for offsets larger than 4GB.

When the provider later calls iopt_provider_revoke() with a 64-bit loff_t=20
offset, this bounds check will compare the correct 64-bit offset against
the wrapped 32-bit start/end values.=20

Will this cause the bounds check to evaluate to true (e.g. offset >=3D end)=
=20
and abort early, bypassing the unmap and leaving the device with access to=
=20
revoked memory?

> +	first =3D (max_t(u64, offset, start) - start) >> PAGE_SHIFT;
> +	last =3D (min_t(u64, offset + len, end) - start - 1) >> PAGE_SHIFT;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014093733.9031=
2-1-griffoul@gmail.com?part=3D6
