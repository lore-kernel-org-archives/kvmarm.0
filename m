Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8B4431A31;
	Tue, 28 Jul 2026 12:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785241228; cv=none; b=OP6+XLRHUn4ih57BkoqzkRVEqmYXkasqu6q34Do49HUvj5iK5VWjwukQpunsqnrfCiRkZ/IZo4Umv38uctWa/Dr1/Z8Aw7jkT83Phcw07aj8qfyXIMZf96Lp/Ay9HFpcPgrML4cEVCvtHwAWYk/0LZrVaIJ6igEHgSY8y36WOzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785241228; c=relaxed/simple;
	bh=qrJGDGydwRyZX6aDSWexShL+iG9o4DIwtROBQz9lKGs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=glanaooG+uIbEbPibdbYpRCC3aLGtuscfJ3SaROFCTBB4LeMucnLCOUQVMK9+U8DUB2d/LhGHBhLWKumGVv1yNEFScv7mnETyYs8OZS7se3oci7J6v1Grn3YuyKe4W95uHIsuBkd/+ztS4UfktW5jWqPcigl0r/xl0JwDvZ0vXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMmUiDtl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMmUiDtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E831F000E9;
	Tue, 28 Jul 2026 12:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785241227;
	bh=UkhhBMDtVVEdjIADkdXBk9vaoGMo1F4zNJMDAeNd/lI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZMmUiDtlTOyIj0nWXHdZRr6lrjwFvq1UxMzL1ib3SJ4tK1unRmTlKwcPVBSZSbAQ1
	 GodlpxKRIwmOqNJVSRB22IStA3qhd42F67ousDprIWo/OeB+rfIayLQZbxdD3GRY4F
	 44BTK7d7KBbWTpVVxvvkUKUEM6GJoW2yRuaNF13J9Uj4MFMB1I6q4P4OOzdQ//ZeCC
	 ldBOUbSwrqBdIT2PAQnYk9LQi5PapsPFqwSaoJeCecd/7Z+Y1ARMdKHv4MwEK6U4Ma
	 MO5Ct+ZQwXUK9xGUFmKiSvDY1kFYfd3zYQJSBrBl6G8UNmkDyjp+xbQUc+FY93pojd
	 B65X7+03EvrDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing
 mappings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260728121138.1103610-8-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-8-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 12:20:26 +0000
Message-Id: <20260728122026.E3E831F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Holding the global `kvm_gmem_freeze_srcu` read lock during unbound=
ed `fallocate` operations allows an unprivileged tenant to block `kvm_gmem_=
freeze()` indefinitely for other VMs.
--

--- Patch [7]: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing =
mappings ---
commit de8f141a41c06197ca510e03554977beeeb4fcdf
Author: Tarun Sahu <tarunsahu@google.com>

KVM: guest_memfd: Add support for freezing mappings

This commit introduces kvm_gmem_freeze() to freeze a guest_memfd inode's
mapping to prevent fallocate and page fault allocations during preservation.
It uses a global SRCU to synchronize freeze state checkers without incurring
per-fault locking overhead or per-CPU memory exhaustion.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fe1adc9ba48d1..a4d9d348e4d16 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
[ ... ]
> @@ -273,16 +284,30 @@ static long kvm_gmem_allocate(struct inode *inode, =
loff_t offset, loff_t len)
>  static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offse=
t,
>  			       loff_t len)
>  {
> +	struct inode *inode =3D file_inode(file);
>  	int ret;
> +	int idx;
> =20
> -	if (!(mode & FALLOC_FL_KEEP_SIZE))
> -		return -EOPNOTSUPP;
> +	idx =3D srcu_read_lock(&kvm_gmem_freeze_srcu);
> +	if (kvm_gmem_is_frozen(inode)) {
> +		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
> +		return -EPERM;
> +	}
[ ... ]
>  	if (mode & FALLOC_FL_PUNCH_HOLE)
>  		ret =3D kvm_gmem_punch_hole(file_inode(file), offset, len);
>  	else
>  		ret =3D kvm_gmem_allocate(file_inode(file), offset, len);
> =20
>  	if (!ret)
>  		file_modified(file);
> +
> +out:
> +	srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>  	return ret;
>  }

[Severity: High]
Does this code allow an unprivileged tenant to stall the system by holding =
the
global kvm_gmem_freeze_srcu read lock across unbounded fallocate operations?

If a tenant requests a massive hole punch or allocation, kvm_gmem_fallocate=
()
holds the read lock for the entire duration of kvm_gmem_punch_hole() or
kvm_gmem_allocate().

If another VM triggers kvm_gmem_freeze(..., true) during this time, it will
block in synchronize_srcu(&kvm_gmem_freeze_srcu) until the massive operation
completes.

Could this lead to a cross-tenant denial of service where one VM blocks live
updates and preservation operations for all other VMs on the same hyperviso=
r?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260728121138.1103=
610-1-tarunsahu@google.com?part=3D7
