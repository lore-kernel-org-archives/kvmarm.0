Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D06446079
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568369; cv=none; b=OmA3LXEoI25tX1u5rEyp5BHcmPcWpOTE2mnPKvBXVT8bBqOKuZVhqxtVNJG5X3Z+glvHiQPy762uHcn0b9P1stWOe8oQZbFrC87yTZrQ/w5buVo+dlqo6DaW+XgKa+iqosz/FHfZ1kUet21KfyKn6zv5wQOdsEMk4i7rRzwMkPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568369; c=relaxed/simple;
	bh=t0PSH10NxTcMvHWO7tc9m6kQoEwNMn+oes/rcfq2m0k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f9veftcvu+c1HCUnK+/SaOzqUxzOpaIoa2RuGWg/GKepP87IQ3XnL8awQ4Got3olcJ9yctE829S3A3mF/vgV0FhNROnEi27SHB7C4M+I5XZuPhaCxj3pQHvW32k0e0PwguBMjpIIlrRPd48n6WfjdLqKt3Bxz5e5h3JGep1bCi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lQypijig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQypijig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DBB1F000E9;
	Mon, 20 Jul 2026 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784568360;
	bh=OVPpG9pm+Q9DamBiM1I4vjsCyM+y9aboVphNhY7VcJc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lQypijigyWJIFl0X+vhg8HakwsDEWZOzx5DzvBQxPzSGf1SUtMgr2lIMVGoByhSjP
	 1tW5C0ouxtLOSrPjklqv4hfXEFGPc5QqR6wEuNnPimPPMv2bYg+ck6Rp1x3U6Wmo98
	 oZ+SWBv9KUF14vXBVCTZsWnXgNyE4AYXB/jaA0uOgV4fsVCs9qkjNcn9yGQotpSZHm
	 jCdXBGN29L3LX3eGdaVh5xKq/raJs/GQbUd4yYTCCfyyp6RTgU4goCuLW9goTSYZGE
	 0L6AA87OFRdu/GaiAl/VefO6Yk4aRRWkmaqw9fkgngEyN3fA9y8Svv40HxQBxgeaym
	 8684x3bL5YIhA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/17] KVM: arm64: Add pkvm_private_va_range_pa
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260720171513.1415357-2-vdonnefort@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-2-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:25:59 +0000
Message-Id: <20260720172559.B2DBB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Incorrect physical address calculation for block mappings in pkvm_=
private_va_range_pa()
--

--- Patch [1]: [PATCH v3 01/17] KVM: arm64: Add pkvm_private_va_range_pa ---
commit 81aa726ac7516be8619c0cb2674493e48b6fca16
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add pkvm_private_va_range_pa

This commit introduces pkvm_private_va_range_pa() to resolve physical
addresses for the pKVM private range by walking the hypervisor page-table.
This prepares for the upcoming pKVM heap allocator.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
[ ... ]
> +phys_addr_t pkvm_private_va_range_pa(void *va)
> +{
> +	kvm_pte_t pte =3D 0;
> +
> +	guard(hyp_spinlock)(&pkvm_pgd_lock);
> +	WARN_ON(kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)va, &pte, NULL));
> +	WARN_ON(!kvm_pte_valid(pte));
> +
> +	return kvm_pte_to_phys(pte) + offset_in_page(va);

[Severity: High]
Does this calculation handle block mappings correctly?

If the virtual address is mapped via a block descriptor (such as a 2MB
large page), kvm_pte_to_phys(pte) returns the base physical address of
the block. Adding offset_in_page(va) will only preserve the lowest 12
bits, discarding the intermediate offset bits between the page size and
the block size.

Could this cause multiple virtual pages within the block mapping to
incorrectly resolve to the same physical base page plus a small offset?
Perhaps this should retrieve the mapping level from kvm_pgtable_get_leaf()
and mask the virtual address with the corresponding granule size?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720171513.1415=
357-1-vdonnefort@google.com?part=3D1
