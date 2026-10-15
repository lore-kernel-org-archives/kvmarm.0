Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A86239D6FA;
	Thu, 15 Oct 2026 14:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075637; cv=none; b=DY4EpGtbztsfib/K5leyy+WMv/ZDcRTGvNStbU7qbSGcr+NMd3EcxZInaSripdPIEO9GoSNXzfRmTYgboOaMvvyo2HQvcAh6va/y8Sd6XN+DzSSoXzlackulfVU8r2urhvWJwrkTpkelNgqMGzVxBiZI+QYEwAZRFbevA9GjXUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075637; c=relaxed/simple;
	bh=rAF4YlSF7hUo8DAkMHthAjXGepF7SRPihX2Ex5pfZgI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=FUuXZ4EFOKJDyRNqh4TTdbJIXvFM88ZELT3HSzsVs9Eem/kUEC8RdIGOJd3P9XCKFOioKI9BEWSdiIfhC1T4bcNb7Z6e+Srx0WRugeAgXZU6JHRnsVbtbU5sodiXUCbMu/wQeSglMqZJVDZIjTErBiyv0BOFOsIjLf+Ke25CUgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnZc/iVm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnZc/iVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF881F000C5;
	Thu, 15 Oct 2026 14:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075635;
	bh=3j+m2tKl65aJQplhL2PcqyVb7I0LigfZ2IYh3ohIJz4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lnZc/iVmo2BemktisXZ7FeDT+Z/JZ3X3NyM4LMWn58rRh36Ps3olDN34uvIoQYj5n
	 zYqkClSKqayoQiEVjvlbg/7KzZgDhWr6GdAdzNWL90B4782g73La/bpNzL+wv1TYIq
	 btbc+q+VuTYRVadi/oR4z2/jgpsZ3kZcpcnfg8ai/4alD4KCCun9K/8QOcgwjpGjhD
	 OabKaVbOB92U1DndPB8esr1YpMHZ+LOCgFddJj0eZw3wR7dd6dgwfaZ6RSf4P/yzXB
	 plj5Yf9yHAQGGFHDtRYyiBwNztkkO1TXMEhTb3NvKeqCJXe5yCYf2t9pEeKKJT2NX8
	 icy2/WYaE3y9A==
Message-ID: <sashiko-outbox-172989@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 09/15] misc/arm-cla: Add userspace interface
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ryan Roberts" <ryan.roberts@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, robh@kernel.org, conor+dt@kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015142552.4128028-10-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-10-ryan.roberts@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 14:47:15 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] core: format string mismatch in dev_set_name causes init failure o=
n 32-bit archs
- [Medium] misc/arm-cla: missing array_index_nospec in cla_vma_fault create=
s Spectre v1 gadget
--

commit 91161eb49b1b380686ad6f07674f5b53c3cf7baa
Author: Ryan Roberts <ryan.roberts@arm.com>

    misc/arm-cla: Add userspace interface
   =20
    Expose CLA devices through a character device so userspace can enumerate
    the available hardware and map accelerator register frames.

> diff --git a/drivers/misc/arm-cla/cla-user.c b/drivers/misc/arm-cla/cla-u=
ser.c
> new file mode 100644
> index 0000000000000..41cd5e4a7d017
> --- /dev/null
> +++ b/drivers/misc/arm-cla/cla-user.c
> @@ -0,0 +1,541 @@
[ ... ]
> +static vm_fault_t cla_vma_fault(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma =3D vmf->vma;
> +	struct cla_ctx_key key =3D CLA_CTX_KEY_PL0(vma->vm_mm, vma->vm_file);
> +	struct cla_domain *domain;
> +	struct cla_dev *dev;
> +	struct cla_ctx *ctx;
> +	unsigned long pg;
> +
> +	/*
> +	 * Reassignment needs mmap_lock, so we cannot wait while holding it.
> +	 * The private futex fault-in path can reach here without allowing
> +	 * mmap_lock to be dropped. Reject faults that do not allow retry.
> +	 */
> +	if (!(vmf->flags & FAULT_FLAG_ALLOW_RETRY))
> +		return VM_FAULT_SIGBUS;
> +
> +	pg =3D vma->vm_pgoff + ((vmf->address - vma->vm_start) >> PAGE_SHIFT);
> +	dev =3D cla_lut_pg[pg];
> +	domain =3D dev->domain;

[Severity: Medium]
In cla_vma_fault(), pg is calculated from the user-controlled vmf->address
and used to index the global cla_lut_pg array.

Is there a risk that speculative execution could bypass the VMA bounds chec=
ks
prior to this handler, resulting in an out-of-bounds read that is immediate=
ly
dereferenced? Could this create a Spectre v1 gadget, and should we use
array_index_nospec() to clamp pg before indexing?

> +
> +	mutex_lock(&domain->lock);
> +	ctx =3D cla_domain_lookup_ctx(domain, &key);
[ ... ]
> +static int __init cla_accel_class_add(const struct cla_accel_desc *desc)
> +{
> +	struct cla_accel_class *aclass;
> +	unsigned int i;
> +	int ret;
[ ... ]
> +	aclass->desc =3D *desc;
> +	device_initialize(&aclass->dev);
> +	aclass->dev.class =3D cla_class;
> +	aclass->dev.devt =3D cla_devt + cla_nr_classes;
> +	aclass->dev.release =3D cla_accel_class_release;
> +
> +	ret =3D dev_set_name(&aclass->dev, "%03lx:%03lx",
> +			   FIELD_GET(CLA_IIDR_IMPLEMENTER, desc->iidr),
> +			   FIELD_GET(CLA_IIDR_PRODUCTID, desc->iidr));

[Severity: High]
Does this format string cause argument misalignment on 32-bit architectures?

Because desc->iidr is a u64, FIELD_GET() returns a 64-bit value. Using %03lx
expects a 32-bit unsigned long on 32-bit systems. This could cause the first
%03lx to consume the lower 32 bits, and the second %03lx to consume the upp=
er
32 bits, completely ignoring the intended PRODUCTID argument.

If devices share the same implementer but have different product IDs, could
this result in identical names and cause device_add() to fail with -EEXIST?

> +	if (ret)
> +		goto err_put;
> +
> +	/* The node cannot be opened until cla_user_init() adds the cdev. */
> +	ret =3D device_add(&aclass->dev);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015142552.4128=
028-1-ryan.roberts@arm.com?part=3D9
