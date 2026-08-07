Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF94F38AC78
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 17:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122053; cv=none; b=AAMuaIXdccNS7GEbQ86hAsIgVl0hZR22DULchgh2X9BZF52aOxe5ndbns+FK6EPHF4ihnPVCITaYXfB3nzSsdTII4en/7yk4DH4aLUjgF9ikFDXVm6nBZmSa/OvpI5t7ZlV41rHCDoC9Wcr1rXj3VMsXHckbXv70xnnbqfZTqIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122053; c=relaxed/simple;
	bh=fvTLEYHCc5r7hkLkqCIEyV2+eszyGhHKgmJxFf09/sA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SQmfKsLchLXAQUk4l7FgF315kHI2FK+5I7tVdKSzoXKbKx8hBLPLtXO72Iml61kNDZG5c0p+8ta1C19U7yBTcjZzLoXikMpt3GtNSM4m3B+6RjJvOJER3A3mh3Z0Ao4NF3Hh8EkbnBrKgi+HFkzx0zaJefY/0Yr8sVRACyzhnm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bhNDebBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bhNDebBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E27B1F000E9;
	Fri,  7 Aug 2026 17:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786122051;
	bh=IWcVFNS0NKzuU5oo3HrahJ9A7iYr3USNrGP1x6EFIkU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bhNDebBCJ7X3+3RuG/c0ML4V3u1KUkzx4AiHOeraSeraROen4u1dLUh0WSXWl5GkU
	 P/H117Lr3j5hRrObiiddghsTafAVEsOkPaZ4eaMSODnKDvSbW2MaEXc0od0OhaU9Kt
	 M+SfCADuwMO5oSNcQlzQhGmoZeNJcX3ATMjBPDG++BaiFk7OupAuoIblMsCL78DLXQ
	 H7Tke5aYepdO2ADoy7fVgv3qyC89l7NP+1guU+xydlr1TUPh8thzjT4fNC3Z4fZU6r
	 Qb6z1gafomD6w1Z3rTzdZcVhqdRyHM1En6pOwpN5bvKIjkbGjJfQ/9eF6EzUnxvAeO
	 EuunVZjKMTPIQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/13] KVM: arm64: Track host-unmapped MMIO regions
 in a static array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260807164322.2970811-4-sebastianene@google.com>
References: <20260807164322.2970811-2-sebastianene@google.com>
 <20260807164322.2970811-4-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:00:50 +0000
Message-Id: <20260807170051.0E27B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The error rollback path incorrectly maps previously unmapped prote=
cted MMIO regions into the host stage-2 page tables, breaking isolation.
- [High] Invalid use of the linear map macro `__hyp_va()` for physical MMIO=
 addresses causes hypervisor page table bounds checks to fail or collide wi=
th private VA regions.
--

--- Patch [2]: [PATCH v2 02/13] KVM: arm64: Track host-unmapped MMIO region=
s in a static array ---
commit 8dc1d17638f0ac1801faef9ffe3be3d70a9ddf5c
Author: Sebastian Ene <sebastianene@google.com>
Subject: KVM: arm64: Track host-unmapped MMIO regions in a static array

This commit introduces a registry to track protected MMIO regions that are
unmapped from the host stage-2 page tables. It stores these regions in a
fixed-size array and donates their ownership to the hypervisor during
initialization to ensure host-exclusion and persistent tracking.

> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/se=
tup.c
> index 75b00c3233102..64c0290da888f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
[ ... ]
> @@ -284,6 +284,26 @@ static int fix_hyp_pgtable_refcnt(void)
> +static int donate_protected_mmio_regions(void)
> +{
> +	int ret;
> +	int i;
> +
> +	for (i =3D 0; i < num_protected_reg; i++) {
> +		ret =3D __pkvm_host_donate_hyp_mmio(hyp_pfn_to_phys(pkvm_protected_reg=
s[i].pfn),
> +						  pkvm_protected_regs[i].nr_pages << PAGE_SHIFT);
[Severity: High]
This is a pre-existing issue, but does calling __pkvm_host_donate_hyp_mmio()
here work for physical MMIO addresses?

Looking at __pkvm_host_donate_hyp_mmio(), it uses __hyp_va() to compute the
virtual address:

__pkvm_host_donate_hyp_mmio() {
	...
	virt =3D __hyp_va(addr + offset);
	...
}

Since __hyp_va() applies the linear map offset, which is sized and aligned
specifically for RAM, applying it to physical MMIO addresses (which reside
outside RAM boundaries) yields an invalid virtual address. This causes the
subsequent hypervisor page table bounds checks to fail with -ERANGE, or
silently corrupts EL2 private memory structures, reliably forcing the failu=
re
path to execute.

> +		if (ret)
> +			goto err_setup;
> +	}
> +
> +	return 0;
> +err_setup:
> +	while (--i >=3D 0)
> +		__pkvm_hyp_donate_host_mmio(hyp_pfn_to_phys(pkvm_protected_regs[i].pfn=
),
> +					    pkvm_protected_regs[i].nr_pages << PAGE_SHIFT);
[Severity: High]
This isn't a bug introduced by this patch, but could this error rollback pa=
th
inadvertently map previously unmapped regions into the host stage-2?

The regions tracked in pkvm_protected_regs are intended to remain unmapped
from the host stage-2 page tables. However, __pkvm_hyp_donate_host_mmio()
unconditionally idmaps the region to the host at the end of the function:

__pkvm_hyp_donate_host_mmio() {
	...
	WARN_ON(host_stage2_idmap_locked(addr, size, PKVM_HOST_MMIO_PROT));
	...
}

Since the failure path is triggered by the __hyp_va() issue mentioned above,
this rollback will execute and forcibly install a valid mapping in the host
stage-2 page tables for regions that were originally unmapped, breaking the
hypervisor-host isolation boundary.

> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807164322.2970=
811-2-sebastianene@google.com?part=3D2
