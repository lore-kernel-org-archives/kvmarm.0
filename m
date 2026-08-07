Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EC7314A73
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121939; cv=none; b=b1RjmPhNbNpAAPj/cDS8CvFXbNIV7OQW+cLMbKgTGpVB+rr+tajzwagtua0XaUneYS5U6c7yAkibe/zsq6uOmEHxkCZQTnYuQdSP0p1HtPPCZunQ0nsV5g2/N84Zw87YNSTdgGev4x/GIMDZo4Twcn3JalE3Ihyk9SbI+Uw3hbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121939; c=relaxed/simple;
	bh=NhfFB+5JZXoZwUs3vFB97ZxXZ8hK1fYpZKHoOglkUX0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LCAV1FqsrmFyqIc7brRc03ApgyFtaX7ns5G8bjre64d7Xsl8FlVhUWWJbmQAzUNNoRmZnG6TQaBEiUB0vlgpXepy53/zNkILXKTBP40mTEuHmWgm1tSArOb5bmtvdIzWfFkjvNTIoPPPdLRZN4o3R6icBA8YKkFU7cZPkxFRk+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQFmF4Rm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQFmF4Rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B2C1F000E9;
	Fri,  7 Aug 2026 16:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786121938;
	bh=Idukyr3fwl5UNJaPwmaWxjrT6BikMnje7P3FzC4NQck=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NQFmF4Rmpnood3XGUmMdAt13ak/tgI7NHbvQUJa4IYISn8ggetJYTE05d12MmI4iR
	 /Zlo+Z9tKtUZL3cUfUsGgvWFiX5CDBjawnmqg8OLO9VGpi/vZBsaJJDls0nQSw2LmZ
	 LHmNEnPwpOqe9b0izrJfkGQ3nTEqkwthXrJ3oPnz0meuDdrhCc6KchEi705ZIsRwYq
	 c0mRs5TiydVw6bCc7K3EG5KLWPJIAK4W+PHLy1RVgj9AucpUeUnTo1iJ6zmoyKL3oZ
	 KOZ/qiVheVAreSF7nidbdw/i4AlPvXwUrx8zguwR1+f9R+q5hNNDcwwiCxkd43UJ73
	 nhdk/oUSP3Aqg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/13] KVM: arm64: Donate MMIO to the hypervisor
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807164322.2970811-3-sebastianene@google.com>
References: <20260807164322.2970811-2-sebastianene@google.com>
 <20260807164322.2970811-3-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 16:58:56 +0000
Message-Id: <20260807165857.83B2C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] In `__pkvm_hyp_donate_host_mmio`, if `kvm_pgtable_hyp_unmap` fails=
, the function jumps to the error path but fails to set `ret` to an error c=
ode, silently returning success (0).
--

--- Patch [1]: [PATCH v2 01/13] KVM: arm64: Donate MMIO to the hypervisor -=
--
commit 91906bfffc8e911901f2cb86959abcf8b184a527
Author: Mostafa Saleh <smostafa@google.com>

KVM: arm64: Donate MMIO to the hypervisor

This patch introduces the ability for the host to donate MMIO ranges to
the hypervisor's linear map in pKVM. It initializes the host stage-2 page
table with an invalid leaf containing the hypervisor's owner ID to prevent
host mapping faults.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> index 4e329e39a695a..5cf7c4a0ed208 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c

[ ... ]

> +int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size)
> +{
> +	kvm_pte_t pte;
> +	u64 offset;
> +	int ret =3D 0;
> +	void *virt;

[ ... ]

> +	for (offset =3D 0; offset < size; offset +=3D PAGE_SIZE) {
> +		if (addr_is_memory(addr + offset)) {
> +			ret =3D -EINVAL;
> +			goto err_with_unmap;
> +		}
> +		ret =3D kvm_pgtable_get_leaf(&host_mmu.pgt, addr + offset, &pte, NULL);
> +		if (ret)
> +			goto err_with_unmap;

[ ... ]

> +		virt =3D __hyp_va(addr + offset);
> +		if (kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)virt, PAGE_SIZE) !=3D PA=
GE_SIZE)
> +			goto err_with_unmap;

[Severity: High]
When kvm_pgtable_hyp_unmap() fails here, does the code return success?

Looking at __pkvm_hyp_donate_host_mmio() in mem_protect.c, the ret variable
would be 0 from the earlier successful kvm_pgtable_get_leaf() call. By
jumping to err_with_unmap without updating ret, the function silently retur=
ns
0 to the caller even though the unmap operation failed.

> +	}
> +	WARN_ON(host_stage2_idmap_locked(addr, size, PKVM_HOST_MMIO_PROT));
> +unlock:
> +	hyp_unlock_component();
> +	host_unlock_component();
> +	return ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807164322.2970=
811-2-sebastianene@google.com?part=3D1
