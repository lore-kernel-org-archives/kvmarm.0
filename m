Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6BE3C2790;
	Wed, 14 Oct 2026 09:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791971503; cv=none; b=OUiCM9uZEMXkZl1II6kxZ/6m9dIVUeUDDE1YFbyFB9EpdhO2nsIWlf0Bjo2s6x3++kMy2ztC2jNe+dgw07tLwspYb/ljRksFAbaFWwN8YocUXx7/fErpH3eUvPD1nZ1gyvNkRsJxigEwGfLCgjuulPKoe0M1RZ/Zylcp+s882TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791971503; c=relaxed/simple;
	bh=GtJsW3ohLN7eapvVFtMaU9vey+E41ZPZ1vIU8ckyJY0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Meu6CRiyE+000Dkp77yHp0MJYKMUGVg0XltSzXg0PzyF21TD/+9W1lpe6RQUYx7ZrTv+ZZH1ttctW/xolLZj2BlXOk77c1OQL14gNZcFcrTnZOoUhlkTN4j7xXehFG1N1MYtU1P63meeklljZrm+eWGrl0AyYEIHaIyFm+YkpbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIFMdZs+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIFMdZs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C451F000FF;
	Wed, 14 Oct 2026 09:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791971501;
	bh=WE5kzl9dCqt5zBhUCmK5IQTL1v1OdPqYpzB/aULmllQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VIFMdZs+vkcIQPY7cirNfPyaYjwEIs9yRpfLx0LjY6Kfh0Bd5hXopEH0XLV9GRrH7
	 DtMnVDoWy6P+5F/rOU7HB3ZPab2fJAENAHWuxKKeAGCrg3Qyb6xP5ijzIkba+c90o7
	 25ghuncbNwvPhvXkQWFQ92nrlz0XkMlR8/eVVHcMUSvLpOsKl0JTy0DtrTFjz4Sq9J
	 vtmbZX+SVeg1ffTKyGEcP9J91YnS0vJ+7ycLerBYAkn62RBmeF6xepzJILzziRQM71
	 S/4l/5HyrDSyYDT9OEmJFin68fNXViz++kUIGTc/rINcQAIJ1YKiqfBS78C0QYvz4D
	 3FUJyao5eFl0w==
Message-ID: <sashiko-outbox-171095@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 01/11] KVM: guest_memfd: Introduce guest memory
 ops and route native gmem through them
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fred Griffoul" <griffoul@gmail.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261014093733.90312-2-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
 <20261014093733.90312-2-griffoul@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 09:51:40 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: ignored xa_store_range failure in kvm_gmem_native_bind allows=
 memory access to freed host pages
--

commit ab5f37736d076d164ccad403ab4a50bd2032eb9b
Author: David Woodhouse <dwmw@amazon.co.uk>

KVM: guest_memfd: Introduce guest memory ops and route native gmem through =
them

This commit introduces a vtable (struct kvm_gmem_ops) to allow alternate
subsystems to supply guest memory backing. The built-in guest_memfd
implementation is refactored to route its memory-side and file-level
callbacks through this new shared dispatch mechanism.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index db57c5766ab60..057f90eb835a1 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c

[ ... ]

> +static int kvm_gmem_native_bind(struct file *file, struct kvm *kvm,
> +				struct kvm_memory_slot *slot, loff_t offset)
> +{

[ ... ]

> +	/*
> +	 * memslots of flag KVM_MEM_GUEST_MEMFD are immutable, so bind must
> +	 * occur on a new memslot.  Because the memslot is not visible yet,
> +	 * kvm_gmem_get_pfn() is guaranteed to see the file.
> +	 */
> +	WRITE_ONCE(slot->gmem.file, file);
> +	slot->gmem.pgoff =3D start;
> +	if (kvm_gmem_supports_mmap(inode))
> +		slot->flags |=3D KVM_MEMSLOT_GMEM_ONLY;
> +
> +	xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL);
> +	r =3D 0;

[Severity: High]
Does this code handle potential memory allocation failures from=20
xa_store_range()?

xa_store_range() can fail with -ENOMEM when allocating internal nodes for t=
he
XArray. Because the return value is ignored and the path unconditionally
returns 0, the memslot is successfully bound from KVM's perspective, but is
missing from the f->bindings tracking structure.

During operations like fallocate (hole punch) or file release, KVM iterates
over f->bindings to find and zap the guest mappings. If the slot is missing
from the XArray, the guest mappings will not be zapped, which could allow t=
he
guest to retain read/write access to physical memory that has been returned
to the host allocator.

> +out:
> +	filemap_invalidate_unlock(inode->i_mapping);
> +	return r;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014093733.9031=
2-1-griffoul@gmail.com?part=3D1
