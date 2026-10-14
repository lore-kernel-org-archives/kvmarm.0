Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B543ED3D8;
	Wed, 14 Oct 2026 09:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791971438; cv=none; b=StURusgS+qObj7lXyIXmfTnItZ3DI5UGE27dkG/IYjuFpyDjMHRZFLQYN5lSOkkw5jgoukeok/53L9C3e79mHb+PvAf1QUJtZA3P0J/pZlkAzVdnk3IOluNTJnk5S3Ib5axAoZidnjgFYFMRrJy9ABe0X3vyiF4OXasaB782kzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791971438; c=relaxed/simple;
	bh=mYa0vX0x5e3WoxMmjXu8GA7LR5hwpOK/hvns/2s5UDc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VgVeHvpLQ1mCkzWgYxsNtyvFYZDAsEDX+rIZjXYnS4w99D276o6Mn+eJ8GSZhXgcFo+pjOk9CW0mRhOk6b5LzbfRezHSFH723WnA3aw5/PZoCeCvuux5g5bGxfRwBEbjaYXz8wGkjSJe0gWZKuCUzW2b5UboSOa8opemjwsaJf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DCea8kyG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DCea8kyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05C41F000FF;
	Wed, 14 Oct 2026 09:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791971437;
	bh=EDydDziZqhTgvbH4QIPu1b6f/5SznGNMqSsPvfGMgtA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DCea8kyGebyWy1fGrAZrTQat9NyJPLLYdCoZBh23P10tg17JOcJ2EPkkMHhttyUmv
	 PvU10DiBnuupBDp3OFqTqqdq+BoXo1xtfS9A1w6Oo0YDd7W75DZqw8lcrTzQHxrM51
	 Noaxmqcr55+Qev/korxvBjlyxR0wBHWo5leUfJPtlaeAKGQz21ubbgltdedr2npOVS
	 TYXxzE5ILkq9nbyb69lNjtmNprpJZtsdvGIBJZWS36zUu5o8PPXiOWzouBlXBsjAnN
	 tHQvHzhR8V0oyICc4XfbU5+CsIxdrgftZ4YtvepZLcRJ8ClzId/P57Rvp6CrEvGGVB
	 gsHiz5doQXxDg==
Message-ID: <sashiko-outbox-171092@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 10/11] samples/kvm: Add a memory provider sample
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fred Griffoul" <griffoul@gmail.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261014093733.90312-11-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
 <20261014093733.90312-11-griffoul@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 09:50:36 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] kvm: misaligned huge page PFN causes host memory corruption
- [High] mm: bitmap integer truncation leads to out-of-bounds write
--

commit 361e4f16cd6774e9f8e63152565759849581de53
Author: Fred Griffoul <fgriffo@amazon.co.uk>

samples/kvm: Add a memory provider sample

This patch adds a sample memory provider for guest_memfd and iommufd. It le=
nds a
physical memory region, either given by addr/len parameters or allocated via
alloc_contig_pages(), to guest VMs and moves pages between children.

> diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider=
_sample.c
> index 0000000000000..8180959ab78ff 100644
> --- /dev/null
> +++ b/samples/kvm/mem_provider_sample.c
> @@ -0,0 +1,855 @@
[ ... ]
> +static int mps_mp_get_page(struct mem_provider_file *mpf, pgoff_t index,
> +			   unsigned long *pfn, int *max_order, u32 *attrs)
> +{
> +	struct mps_info *info =3D container_of(mpf, struct mps_info, mpf);
> +	unsigned long run;
> +
> +	if (index >=3D info->npages)
> +		return -EINVAL;
> +
> +	if (!mps_page_present(info, index))
> +		return -EFAULT;
> +
> +	/* The aligned block around @index must be one run. */
> +	run =3D mps_run(info, index);
> +	while (*max_order) {
> +		unsigned long first =3D ALIGN_DOWN(index, 1UL << *max_order);
> +
> +		if (first + (1UL << *max_order) <=3D index + run &&
> +		    (first =3D=3D index || mps_page_present(info, first)) &&
> +		    mps_run(info, first) >=3D 1UL << *max_order)
> +			break;
> +		(*max_order)--;
> +	}

[Severity: Critical]
Are we missing a hardware PFN alignment check for huge pages?

The loop validates that the internal state is consistent for a block, but
doesn't verify if info->base_pfn + first is naturally aligned to the huge
page boundary (1UL << *max_order).

Because alloc_contig_pages() or the addr module parameter do not guarantee
alignment to arbitrary huge page boundaries, KVM or the hardware MMU could
force alignment by masking the lower bits of the PFN. Would this result in
the guest mapping memory before the intended base_pfn and accessing unowned
host memory?

[ ... ]
> +static void mps_set_readonly(struct mps_info *info, unsigned long start,
> +			     unsigned long end, bool readonly)
> +{
> +	mutex_lock(&info->lock);
> +	if (readonly)
> +		bitmap_set(info->readonly, start, end - start);
> +	else
> +		bitmap_clear(info->readonly, start, end - start);

[Severity: High]
Can start and end - start silently truncate here?

These parameters are unsigned long, but bitmap_set() and bitmap_clear()
expect unsigned int for the start and nbits arguments. If the region size
is extremely large, this could result in mapping into a truncated bitmap
footprint and corrupting adjacent kernel heap memory.

> +	mps_revoke(info, start, end);
> +	mutex_unlock(&info->lock);
> +}
[ ... ]
> +static int mps_new_file(unsigned long base_pfn, unsigned long npages,
> +			u32 flags, struct mps_info **infop,
> +			 struct file **filep)
> +{
> +	struct mps_info *info;
> +	struct file *file;
> +	int fd, ret;
> +
> +	info =3D kzalloc_obj(*info);
> +	if (!info)
> +		return -ENOMEM;
> +	mem_provider_file_init(&info->mpf);
> +	info->base_pfn =3D base_pfn;
> +	info->npages =3D npages;
> +	info->mmap_capable =3D flags & MPS_FLAG_MMAP_CAPABLE;
> +	info->absent =3D bitmap_zalloc(npages, GFP_KERNEL);
> +	info->readonly =3D bitmap_zalloc(npages, GFP_KERNEL);

[Severity: High]
Will the allocation size be truncated here?

The npages parameter is an unsigned long derived from the user-controlled
setup.size (via ioctl) or the len module parameter. Because bitmap_zalloc()
accepts an unsigned int for nbits, any npages value exceeding UINT_MAX (e.g=
.,
a region > 16 TB) will be silently truncated, causing massively undersized
bitmaps to be allocated.

> +	if (!info->absent || !info->readonly) {
> +		ret =3D -ENOMEM;
> +		goto err_free;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014093733.9031=
2-1-griffoul@gmail.com?part=3D10
