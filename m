Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134FB3BB670;
	Mon, 29 Jun 2026 11:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782733101; cv=none; b=tWO+R63r3yB3ecqDpWxFL9zrnR2z7VNN+64QAFFJR9XkWvjknIKaS6Nh/KlCPVmDKPXo02MlOMftcuGF6BiJGFyz9GbuQwR5h1kE095E1OVTYCOIhmORSfiGVjdCt5qb4g/ux92jEyY0nj1qXkkRcawGFmGhjvBAFK+W6A4QbHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782733101; c=relaxed/simple;
	bh=wHs7sgs+dM9p+Sm9RNJWJkayI9VKWHJryYnpOsxiEfo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hAwctMuplDXA1Ij0e+vHtKvozuiqnE7pV2YydSG/Qyex2QUvs5hn20n6BTaLi+5yf9+KxQGNXt/UwoOBIZoekMMU7c9qHTb04yJ90rzkZuZc/5BX41D49c005o7+KSHCR46vcdGUXKaaL7A72ArBdg2viDoBSMxaAb93pNaoqWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l9dKtUi7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l9dKtUi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619D91F000E9;
	Mon, 29 Jun 2026 11:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782733099;
	bh=i1U2j1uKMWDGCRprgio6dHbk3duHDmLaecK7kxCwlXM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l9dKtUi7BD1LHDg9Sh9bpqTSYh1gy0xuNe/LS6qNSRq9/aqVXJIjFf8fAUV58hGzo
	 3jHCh1cNrWunQFIBEZsVHn6WmFKs+Xhdgn58aff0jY/nUq9nJsasDdqh7zb3llRczZ
	 it8Bt4d0oECiFyUGVJEuVhpHG0lAvUmYv4sbJNnLV1F7AwwxB7KCQWcwc4NL6zrB6F
	 WecFWYFrYWrlgpGQiMreq71mS+XHZFWXC9l/y0fG2NnbYtYO8Uo22jLhrgY4ahQK88
	 vMIhdw7l53AZVmGHy/zfEMt/VoRKiqyeRihojjyyZQB1TLhRAiaRkldUQ74zsbR4KR
	 4AMH6YMgaQgFw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/13] kvm: Add arch-generic interface for
 hw-accelerated dirty-bitmap cleaning
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260629111820.1873540-8-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-8-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 11:38:18 +0000
Message-Id: <20260629113819.619D91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Data loss (lost dirty pages) when kvm_arch_dirty_log_clear fai=
ls during KVM_GET_DIRTY_LOG.
- [High] Out-of-bounds read of userspace buffer in kvm_arch_dirty_log_clear=
 during KVM_CLEAR_DIRTY_LOG.
--

commit ea34df3acf2397922e1a2152d707b3b9f6012964
Author: Leonardo Bras <leo.bras@arm.com>

kvm: Add arch-generic interface for hw-accelerated dirty-bitmap cleaning

Introduce kvm_arch_dirty_log_clear() that allow implementation of
arch-specific hardware-accelerated dirty-log routines.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e44c20c049610..a25b8902cdfc1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2262,6 +2263,10 @@ static int kvm_get_dirty_log_protect(struct kvm *k=
vm, struct kvm_dirty_log *log)
>  		dirty_bitmap_buffer =3D kvm_second_dirty_bitmap(memslot);
>  		memset(dirty_bitmap_buffer, 0, n);
> =20
> +		if (kvm_arch_dirty_log_clear(kvm, memslot, NULL,
> +					     dirty_bitmap_buffer, &flush) >=3D 0)
> +			goto out;
> +

[Severity: Critical]
If kvm_arch_dirty_log_clear() successfully clears some pages in hardware but
subsequently fails and returns an error, will the fallback loop overwrite t=
he
successfully cleared bits?

It appears that if the arch hook returns an error, KVM falls back to the
generic software loop which includes:

    mask =3D xchg(&dirty_bitmap[i], 0);
    dirty_bitmap_buffer[i] =3D mask;
   =20
Because the generic fallback loop blindly overwrites dirty_bitmap_buffer[i]
with the remaining uncleared bits, could this result in silently losing the
dirty pages that the arch hook managed to clear before failing?

[ ... ]

> @@ -2373,6 +2379,10 @@ static int kvm_clear_dirty_log_protect(struct kvm =
*kvm,
>  	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
>  		return -EFAULT;
> =20
> +	if (kvm_arch_dirty_log_clear(kvm, memslot, log, dirty_bitmap_buffer,
> +				     &flush) >=3D 0)
> +		goto out;
> +

[Severity: High]
Could passing dirty_bitmap_buffer directly to the arch-specific routine lead
to an out-of-bounds read?

When userspace calls KVM_CLEAR_DIRTY_LOG with a first_page > 0, KVM copies
exactly num_pages bits into dirty_bitmap_buffer starting at index 0.

If the arch implementation of kvm_arch_dirty_log_clear() assumes the buffer
represents the entire memslot and reads from it using an absolute offset li=
ke
log->first_page / BITS_PER_LONG, would it read past the end of this
partially-sized array?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629111820.1873=
540-1-leo.bras@arm.com?part=3D7
