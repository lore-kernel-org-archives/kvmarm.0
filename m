Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C4343B49E
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568506; cv=none; b=l5PdseJ/bqclSb7+Deu+6ecDRg5EzS4x00+GVk97QrVr+6XWb90IUYytkOddmJEbdSnMfiAPIcpPHKtQmdY00uIUT9ua4DUs/4w7HpLr0umhe9nQC1vH4bAhKYiS4zhbE7Im3YN/D3y+LG10HsgwvLL4QeURx7CIAprdJDZTRJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568506; c=relaxed/simple;
	bh=3l8nHEmbODKOm+y7/qDK2NkgijA8fLNV/hYtCZzp/RE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JT32UBo1nxIWAVDScjaWpoIe6HBO1v5WJ2d3ZPe7b8P2zGnmOwSL1M/Zb7X6sOZBvt4urL++Z9pRSzIYUCK0L/gZZd2tdxcs9+ziYaxbtCtl3OmDct3Wkn7sA5uCkrZBELWQ9YsG4jRnftqO3zDSO9JJYizHnZ+Od7vHOXYbtVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4+tjgaw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4+tjgaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5021F000E9;
	Mon, 20 Jul 2026 17:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784568504;
	bh=hDI6xoW6U//MVGZ5iEam14TU1xu/BVMhnwSYrX3bvcY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T4+tjgawEANB+27HWKHVZ6E4KpFalZ1vmBOwb7c9oNNGVRUQChtmp+5SWc/Jll2YO
	 k7rrvxiVqnsqeUtTBLkR91dutjo92oVskwCc0c16/MtXjwXjmaD5cGqOCanJshc8XY
	 v0UPw4hsyi32cGJE+sKOSzpc1r2DAQ0FZjK23orfjdqcUIhOZynf5rxS7+bFEft2//
	 jw7twJJwOxdvHx6RQOvTUx2RgVMD/zXSmXnRjE9wibcTLtxE2nQCjv5Psa4WqufmKT
	 rzN0e1a7PRjw7s1dM588XeW3sKguGo+8lZZGT9yha7F1mZpeXYjl/CdxByGMLt9qoJ
	 gbgmhBQqe37ig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/17] KVM: arm64: Filter out non-kernel addresses in
 kern_hyp_va
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260720171513.1415357-12-vdonnefort@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-12-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:28:23 +0000
Message-Id: <20260720172824.2E5021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Short-circuiting `kern_hyp_va()` for addresses below `PAGE_OFF=
SET` allows a malicious untrusted host to bypass EL2 address translation an=
d access hypervisor-private memory.
--

--- Patch [11]: [PATCH v3 11/17] KVM: arm64: Filter out non-kernel addresse=
s in kern_hyp_va ---
commit 9a2b59e70629aff87b63154ca5dea88e30d5381e
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Filter out non-kernel addresses in kern_hyp_va

This commit attempts to make kern_hyp_va() idempotent for non-TTBR1
addresses by short-circuiting the mask-and-tag operation if the address
is below PAGE_OFFSET. The intention is to handle hypervisor linear space
pointers correctly without mangling hypervisor private range addresses.

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kv=
m_mmu.h
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -126,6 +126,9 @@ static __always_inline unsigned long __kern_hyp_va(un=
signed long v)
>   * replace the instructions with `nop`s.
>   */
>  #ifndef __KVM_VHE_HYPERVISOR__
> +	if (!is_ttbr1_addr(v))
> +		return v;
> +
[Severity: Critical]
Does this short-circuit allow an untrusted host to bypass address translati=
on
and access hypervisor-private memory?

In a pKVM environment, if the host issues a hypercall in the always-on band
and passes a forged pointer corresponding to an EL2 private virtual address,
is_ttbr1_addr() will evaluate to false because the forged address is below
PAGE_OFFSET.

As a result, kern_hyp_va() returns the forged address unmodified, completely
bypassing the mask-and-tag translation. Could this allow the host to trick
the hypervisor into reading or writing EL2 private structures by directly
dereferencing the returned pointer?

>  	asm volatile(ALTERNATIVE_CB("and %0, %0, #1\n"         /* mask with va_=
mask */
>  				    "ror %0, %0, #1\n"         /* rotate to the first tag bit */
>  				    "add %0, %0, #0\n"         /* insert the low 12 bits of the tag =
*/

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720171513.1415=
357-1-vdonnefort@google.com?part=3D11
