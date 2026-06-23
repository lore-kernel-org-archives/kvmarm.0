Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF70731E84E
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 14:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782225663; cv=none; b=iDygs4XrVIgw76yWxnz8uVKDHnPbwlGdB02/oso5izYDlewfLoAJfZ2f96IW16N4aBdpqcqcRlJ3GRLFobP2itsFtwxd2jYj7DOeuXZBax/pBsaP+TkEfmjpt7338SdQqjdAqeUcSgOHmJ7fSLAZyHD5I6bWfNm/TXCQLwKMiAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782225663; c=relaxed/simple;
	bh=BTaIBMzN05nC+LcZgD0X6/rA6eseqMjJj3YlQ96JkjU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UvVojFGGoh4nUzZGEwN6dus/LflPhuUZqDwD3ROyJO1GP9J1o12mCO87L/G01fJdonpj1Q17A13UXYyUtn/va8caYO2Nn1Rp9TjcMCpKsx9y+udp+YhMYvvcwkgrEx80GolDCZTlimoBUNyvTyF2iRfKz/d/gUcJauLf9PdGnsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DjOT6aDs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DjOT6aDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4C81F000E9;
	Tue, 23 Jun 2026 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782225662;
	bh=tiaFxAMvmH7/HbT/i19pwR6MKV/z/DLZOd75lXM6vHs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DjOT6aDss2qliGnor1Tvjyx27Rp5CWQdYshjewIu5RYbQbOwsk9kWZWuHzHq7ISL1
	 yqUyd6qB6KB+EjgYlrIi2YfjZSa/eSEQT/KzRgwCNw9lypA/Gr4H8F956sobOgynKy
	 VHYO/raIwF5g6PipmB7ul0WrsCpQDkwY1OjS14Rd8bJxthvgI+lmFmRHQV6JF4oDnl
	 H/O7UWhJ5JNmA3rdZiYr9L37cZjgUt7OULMWuSpmYH5Xdp0nbMszHBnN7/OrO6vGTs
	 owxasJXVhjuAECjZS18j5ut/IQBEiQYVSzhmtV/vqJcHv9BGpN5vP81c74yac+Vevx
	 Yl7lOIZbwRi/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Move to per nested mmu ptdump files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei-Lin Chang" <weilin.chang@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260623142443.648972-4-weilin.chang@arm.com>
References: <20260623142443.648972-1-weilin.chang@arm.com>
 <20260623142443.648972-4-weilin.chang@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 14:41:01 +0000
Message-Id: <20260623144102.4C4C81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Kernel panic on error path due to kvm_free_stage2_pgd() being call=
ed on uninitialized kvm_s2_mmu elements.
--

commit b126bbf9b1139c4e5f8f15f1b55bdfca981c84c3
Author: Wei-Lin Chang <weilin.chang@arm.com>

KVM: arm64: nv: Move to per nested mmu ptdump files

Move the creation of shadow page table debugfs files to be per-nested-mmu
instance instead of recreating them on context binding, avoiding sleeping
operations while holding the mmu_lock.

Link: https://lore.kernel.org/kvmarm/aiuF0KSvvv-ZozI1@sm-arm-grace07/

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index fb54f6dad995c..07f94b8b82365 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c

[ ... ]

> @@ -125,6 +130,9 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>  		return ret;
>  	}
> =20

[Severity: High]
This is a pre-existing issue, but does the error path cleanup loop just
above this return in kvm_vcpu_init_nested() cause a kernel panic if
init_nested_s2_mmu() fails?

The cleanup loop unconditionally calls kvm_free_stage2_pgd() on array
elements from kvm->arch.nested_mmus_size to num_mmus - 1:

	if (ret) {
		for (int i =3D kvm->arch.nested_mmus_size; i < num_mmus; i++)
			kvm_free_stage2_pgd(&kvm->arch.nested_mmus[i]);

For any element that failed initialization or wasn't visited yet, the
kvm_s2_mmu element remains zero-initialized, meaning mmu->arch is NULL.
Inside arch/arm64/kvm/mmu.c:kvm_free_stage2_pgd(), it calls
kvm_s2_mmu_to_kvm(mmu) which derives the kvm pointer via container_of()
on mmu->arch. This yields an invalid pointer, and the subsequent
write_lock(&kvm->mmu_lock) dereferences it, crashing the kernel.

> +	for (int i =3D kvm->arch.nested_mmus_size; i < num_mmus; i++)
> +		kvm_nested_s2_ptdump_create_debugfs(&kvm->arch.nested_mmus[i]);
> +
>  	kvm->arch.nested_mmus_size =3D num_mmus;
> =20
>  	return 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623142443.6489=
72-1-weilin.chang@arm.com?part=3D3
