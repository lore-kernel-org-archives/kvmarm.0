Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA712349CE2;
	Wed,  2 Sep 2026 16:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367782; cv=none; b=UXP5MoC8na+ZAwYHvFwQMazHVYTms3BM2i4QGT9Ts/NQbTn6KNss2lkHo7ZtkPEvtJ+5nzL0oUCKAj4wQh3bQp00KSnDx91sYi/jKCHBzy70lycdBxwHEMuVI4AlPCZcDDVuKuoejTGSq/XbbX9aBXi8n5prpemUI5GNWCuBXAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367782; c=relaxed/simple;
	bh=QlhCrxjRKyesPy6KtjybmIsVAJyi9LiI9EUV/ZnOjFU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JJ619nW4teuLtWt3dinsZsPtH85AEGd4Yw/NR+9gCd25DGmjSLZyYQsD1MfGTuNb8jUvS4ueR3OEGeYDZzKa1H+EkEpHqOv+Zy94ry0UvKNCtte5xEcMZveEXiEdUjEozX+aaLpVhTkqWCQloh2NC4ZFGW2pRMr8bNegTMzH6Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVq+T8oy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVq+T8oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CECB1F00A3A;
	Wed,  2 Sep 2026 16:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788367780;
	bh=74xtE6SakVKobDYhiA8KIRjR9G/Df+2i6vnmfKlzipI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EVq+T8oyOU2WtlP0AemojQjctM/HxSCc30efbhnxsQRxcXRgwpriF2DdFt+DzUn0g
	 QDd4I5z8lX6x2S5Q22wH8vt6LJvujqtgARpKNy8QAppAQk//QpIXYgOxdjvm+i6Kg/
	 DEMPPunyBBJk9P5odbds2gLKI+nx7fXnEb+6GY+8xVjzsKwKJh1cSymlSncCYsYP2z
	 nULa8knV/uLdA6cVaYjJ97fgRmoCt0h6oJSfjS+7RwPknLAjzKdZ/hKFK7jngxkMgN
	 SG/0OT3Wtd5GL5ILnc/K8AtOon8ILbpMHgmERkXUc0OIkqgUO42hknrKEQINDScW9+
	 1vrgpEFKtdInw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/20] KVM: selftests: Extend page allocator to
 support naturally aligned allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260902164123.2546762-7-seanjc@google.com>
References: <20260902164123.2546762-1-seanjc@google.com>
 <20260902164123.2546762-7-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 16:49:39 +0000
Message-Id: <20260902164940.5CECB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `ALIGN()` macro is used with `nr_pages` as the alignment con=
straint, but there is no validation to ensure `nr_pages` is a power of two,=
 which `ALIGN()` strictly requires.
--

commit 1b8052ce0034b1eff1950b660c7716fd2dffde7a
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Extend page allocator to support naturally aligned allocati=
ons

This commit extends the KVM selftests page allocator to support naturally
aligned allocations. This is primarily for some flavors of PowerPC page tab=
les
that require multiple guest pages per table, and those tables need to be
naturally aligned.

> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index bbf6d7684c0ca..896da440659e3 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
[ ... ]
> @@ -2032,9 +2033,10 @@ const char *exit_reason_str(unsigned int exit_reas=
on)
>   *
>   * Note, success is guaranteed!
>   */
> -gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min=
_gpa,
> -			   u32 memslot, bool protected)
> +gpa_t ____vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t m=
in_gpa,
> +			     u32 memslot, bool protected, bool naturally_aligned)
>  {
> +	size_t alignment =3D naturally_aligned ? nr_pages : 1;
>  	struct userspace_mem_region *region;
>  	sparsebit_idx_t pg, base;
> =20
[ ... ]
> @@ -2051,6 +2053,7 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_=
t nr_pages, gpa_t min_gpa,
> =20
>  	base =3D min_gpa >> vm->page_shift;
>  again:
> +	base =3D ALIGN(base, alignment);

[Severity: Medium]
Are there any scenarios where ____vm_phy_pages_alloc() is called with
naturally_aligned set to true but nr_pages is not a power of two?

The ALIGN() macro uses bitwise arithmetic and mathematically requires the
alignment constraint to be a power of two. If nr_pages is not a power of
two, ALIGN() will silently compute an incorrect base address.

Would it be safer to add a check to ensure nr_pages is a power of two when
naturally_aligned is requested?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902164123.2546=
762-1-seanjc@google.com?part=3D6
