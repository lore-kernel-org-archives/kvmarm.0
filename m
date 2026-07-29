Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB0D4734C6;
	Wed, 29 Jul 2026 11:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322817; cv=none; b=tqWfwT9JRmIyFONRTa6ac8YUP/iD2EkOO+dOZ7SgPXbBHsRo+QGzXwwedfQNjcAApRXG2XvytuD1caVImiS65CaqmcIsnoZRpPRKoIq1n7l3SZ02InuZcMZXQnUKs3sMXOfhhpIaRBDINRQBWv1hQWTEzAwhSOlqquhp0znieqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322817; c=relaxed/simple;
	bh=Iks2lo7pTQZ+anIEfmKxmMqCkb0c9LI3P7nLxXu6eGA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GS8VYSgzjjvRyHyyGDlKssPNjvzU40y+WSYebgADvE/HB1yVD1HuA4MDgJJSSJbpkxY+mT7Qa2oUU/pAv9jWmUkmpIokMi9ufSp/RKDUh0y49Xn1cF3qzCmkay9VNq1peAeI+72sdhuL+cQ5xFTKFJCJXta34rkY8cQlqAse4xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GcfxFq1T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GcfxFq1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372101F00A3A;
	Wed, 29 Jul 2026 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785322815;
	bh=CJT0pKwioiBCkLjCEJPIkP7TqvPI02sVefxMmlVFn4k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GcfxFq1T4m/ovkmccRE5DlUIZdYgGvVnUtZ97LbJdrE/xENFqenKbEDLrOVnUuKc1
	 PQfQvjaxLdAR7AlMwH243KAoM5hAmhBBHXFmEvA+5j4bPgA/rsdP4hHCvqiHYLQA0b
	 HLaWm0BUIkmmbiEBtAREz0Dvf0swhxTdmar0Q5MQ3/MlToSC2l37ijui9ooHNvkIy3
	 EIQZ5h4k33xF55mJCYKIuzNl3wuxL3mZ7pxAoARqOEbdLz5SqRrehz6L0V4EjNqUrr
	 lFU2Wx5Ng8GSe1kTFIDZVgcUi27sAkEG7u46l9REnwj5m+5MGHfUpY6xgTdOwSDS96
	 PbY/NlMPJHnBA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/11] kvm: Add arch-generic interface for
 hw-accelerated dirty-bitmap cleaning
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260729104548.3439958-6-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
 <20260729104548.3439958-6-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 11:00:14 +0000
Message-Id: <20260729110015.372101F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Successful hardware dirty log extraction completely bypasses t=
he generic software dirty bitmap, dropping internally-dirtied pages.
- [Critical] Hardware dirty bits are completely ignored when `KVM_CAP_MANUA=
L_DIRTY_LOG_PROTECT2` is enabled.
- [High] Fallback software loop clobbers partial hardware dirty log output =
and leaks garbage data if `kvm_arch_dirty_log_clear()` fails.
- [Medium] The `kvm_arch_dirty_log_clear` API overloads two distinct behavi=
ors based on an undocumented `NULL` parameter, risking a NULL pointer deref=
erence in arch implementations.
--

--- Patch [5]: [PATCH v3 05/11] kvm: Add arch-generic interface for hw-acce=
lerated dirty-bitmap cleaning ---
commit 4c5b443921b3fcc7c6b76fa46a7c11e8755ad50f
Author: Leonardo Bras <leo.bras@arm.com>

kvm: Add arch-generic interface for hw-accelerated dirty-bitmap cleaning

This patch introduces kvm_arch_dirty_log_clear() to allow architectures
to implement hardware-accelerated dirty-bitmap clearing. It adds hooks in
both kvm_get_dirty_log_protect() and kvm_clear_dirty_log_protect() to try
the hardware implementation first, falling back to the software loop if it
fails or is unimplemented.

> diff --git a/include/linux/kvm_dirty_bit.h b/include/linux/kvm_dirty_bit.h
> new file mode 100644
> index 0000000000000..fa4f6b67b6235
> --- /dev/null
> +++ b/include/linux/kvm_dirty_bit.h

[ ... ]

> +static inline int kvm_arch_dirty_log_clear(struct kvm *kvm,
> +					   struct kvm_memory_slot *memslot,
> +					   struct kvm_clear_dirty_log *log,
> +					   unsigned long *bitmap,
> +					   bool *flush)

[Severity: Medium]
The signature here strongly implies the log parameter is a valid clear
operation struct. However, when this is called from
kvm_get_dirty_log_protect(), NULL is passed for the log parameter.

Could this establish an undocumented API contract where new arch
implementations blindly dereference the log pointer and cause a host
kernel panic?

> +{
> +	return -ENXIO;
> +}

[ ... ]

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 45e784462ec6e..7a13ef69b6e3e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c

[ ... ]

> @@ -2262,6 +2263,10 @@ static int kvm_get_dirty_log_protect(struct kvm *k=
vm, struct kvm_dirty_log *log)
>  		dirty_bitmap_buffer =3D kvm_second_dirty_bitmap(memslot);
>  		memset(dirty_bitmap_buffer, 0, n);
> =20
> +		if (kvm_arch_dirty_log_clear(kvm, memslot, NULL,
> +					     dirty_bitmap_buffer, &flush) >=3D 0)

[Severity: Critical]
Since this hardware clear is invoked inside the else block of the
if (kvm->manual_dirty_log_protect) check, are hardware dirty bits
completely ignored when manual protection is enabled?

Modern VMMs often enable manual dirty log protection by default. Will
skipping the hardware tracking here result in userspace only receiving
the software dirty bitmap, potentially causing silent memory corruption
on the destination after a live migration?

[Severity: Medium]
This is the call site passing NULL for the log parameter.

As mentioned above, does this pose a risk of NULL pointer dereferences
for architectural implementations expecting a valid
struct kvm_clear_dirty_log pointer?

> +			goto out;
> +

[Severity: Critical]
If kvm_arch_dirty_log_clear() succeeds, this goto out bypasses the generic
software dirty bitmap processing loop completely.

Does this mean KVM's internally-dirtied pages, such as those from MMIO
emulation or virtual timers marked via mark_page_dirty(), are silently
dropped from the dirty log?

[Severity: High]
If the arch-specific hardware routine fails partway through and returns
an error code, could it leave partial hardware bits in dirty_bitmap_buffer?

If it falls through to the software loop, the software loop might overwrite
hardware bits with software bits (if the software bit is 1) and preserve
garbage hardware bits (if the software bit is 0). Should
dirty_bitmap_buffer be cleared on failure?

>  		KVM_MMU_LOCK(kvm);
>  		for (i =3D 0; i < n / sizeof(long); i++) {
>  			unsigned long mask;

[ ... ]

> @@ -2373,6 +2379,10 @@ static int kvm_clear_dirty_log_protect(struct kvm =
*kvm,
>  	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
>  		return -EFAULT;
> =20
> +	if (kvm_arch_dirty_log_clear(kvm, memslot, log, dirty_bitmap_buffer,
> +				     &flush) >=3D 0)

[Severity: High]
If the arch hook modifies dirty_bitmap_buffer before failing and
returning an error, does it corrupt the mask used by the fallback
clear loop?

The fallback software loop uses dirty_bitmap_buffer to decide which bits
to clear. If it contains garbage from a failed hardware clear, could this
cause the wrong pages to be cleared?

> +		goto out;
> +

[Severity: Critical]
Similar to the GET path, this goto out bypasses the loop that clears bits
in memslot->dirty_bitmap using atomic_long_fetch_andnot().

If the hardware clear succeeds, will the software bits remain set
indefinitely since they are bypassed from being cleared from KVM's
internal tracking?

>  	KVM_MMU_LOCK(kvm);
>  	for (offset =3D log->first_page, i =3D offset / BITS_PER_LONG,
>  		 n =3D DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729104548.3439=
958-1-leo.bras@arm.com?part=3D5
