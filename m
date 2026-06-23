Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C00327C09
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 16:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782233797; cv=none; b=YbAdP3KqMYeaHvuoDGHGkIs3l+C5vgDecBJTEOHH3PjNxf9uVhE96UNgbkzWxd9NLjED1G2WgR/Pk1IHTSBCePe9sZj1JtOmqw/8VQ/HqlxF9CgspFZcjMrqJMzk9R0DIs8AvtJGcWcn9aXyLxpsIAARkjQzWGa9w26BVAEk8M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782233797; c=relaxed/simple;
	bh=rodWr4F6XK3Ym238B0VAZCXqgEThHwS96PzD4g10Zi4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fIgoINQegjDhqnGelkJ15QKIvqk1XY7GIwG1+49T9pt4bLMQks9yeiULAPkDlvR7RxRCcl16WZBgqk07tuOM8Jd9+oOqyJyndm3tF665SSuB7whVgI5FJu3e5xkqOPpXBEvAWtmoGOA+g9jEsIAYnYkdou1wXz0qO2gG2qcQKXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUyiVxyu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUyiVxyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699011F000E9;
	Tue, 23 Jun 2026 16:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782233795;
	bh=DUjAksgbPHVw9svhMYGkk7zgETjt/j0YjSz5LSX2Bxw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BUyiVxyuZfHLw4htCjw/0PFp1WUTuGeDsSBDrK5NllRmSl3xmsI76K+pjIJ1MV8Sd
	 AY8J4pIUDhw498/U4ghBzG17dbsJjLWBf1dmUgvn4gdochMX9Of9RyFO86gC9IyYDs
	 oeM/3Kse49hFkBbbqHLHEzt/tsaFBJ3HOWqU9QHmerwjBo/kwsoJrVV5uZOQXHODto
	 PG79f6/bkfRSbD9OAzil7K9ege8B0Be3Tuo7KJ7A6OowOb1OSHM1zBF2jndhMSovMX
	 06aL+f+dUSy3uaEDfHZ51rDd3i71OHdE3X0adm8jgKf8zHLyx9Y5IR5Ma5eRvzt152
	 waQwXpmIn6Wog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: top up pKVM mapping cache for
 permission faults
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bradley Morgan" <include@grrlz.net>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260623163756.4591-2-include@grrlz.net>
References: <20260623160339.15143-1-include@grrlz.net>
 <20260623163756.4591-1-include@grrlz.net>
 <20260623163756.4591-2-include@grrlz.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 16:56:33 +0000
Message-Id: <20260623165634.699011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Permission faults on a PMD during dirty logging skip page table me=
mcache topup but still trigger block-to-page splits, causing an -ENOMEM gue=
st abort.
--

commit 26c4caa3c15677862ff91c344811bed70a7dead2
Author: Bradley Morgan <include@grrlz.net>

KVM: arm64: top up pKVM mapping cache for permission faults

This commit allocates a fresh pkvm_mapping object for pKVM permission
faults, as they may replace page entries with a block entry. It adds a
topup_hyp_memcache_mapping() call in user_mem_abort() for this case.

Link: https://lore.kernel.org/all/20260623161545.EA08E1F000E9@smtp.kernel.o=
rg/

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 445d6cf035c91..bb855f1d6ab47 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c

[ ... ]

> @@ -2073,7 +2082,9 @@ static int user_mem_abort(const struct kvm_s2_fault=
_desc *s2fd)
>  	 * Permission faults just need to update the existing leaf entry,
>  	 * and so normally don't require allocations from the memcache. The
>  	 * only exception to this is when dirty logging is enabled at runtime
> -	 * and a write fault needs to collapse a block entry into a table.
> +	 * and a write fault needs to collapse a block entry into a table. With
> +	 * pKVM, they may still need a fresh mapping object if the fault turns
> +	 * page entries into a block entry.
>  	 */
>  	memcache =3D get_mmu_memcache(s2fd->vcpu);
>  	if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
> -			    kvm_is_write_fault(s2fd->vcpu))) {
> +			    kvm_is_write_fault(s2fd->vcpu))) {

[Severity: High]
This is a pre-existing issue, but can this condition lead to an -ENOMEM
guest abort during dirty logging?

If a guest triggers an instruction permission fault (IABT) on a PMD while
dirty logging is enabled, kvm_is_write_fault() evaluates to false. This
skips topup_mmu_memcache().

Later in kvm_s2_fault_map(), dirty logging forces mapping_size to PAGE_SIZE,
which mismatches the PMD_SIZE perm_fault_granule. This forces a call to
kvm_pgtable_stage2_map() to split the PMD:

arch/arm64/kvm/mmu.c:kvm_s2_fault_map() {
    ...
    } else {
        ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn),
                                                 mapping_size,
                                                 __pfn_to_phys(pfn), prot,
                                                 memcache, flags);
    }
}

The split requires a page table allocation from the empty memcache, which
fails with -ENOMEM and fatally aborts the guest.

>  		ret =3D topup_mmu_memcache(s2fd->vcpu, memcache);
>  		if (ret)
>  			return ret;
> +	} else if (is_protected_kvm_enabled()) {
> +		ret =3D topup_hyp_memcache_mapping(memcache);
> +		if (ret)
> +			return ret;
>  	}
> =20
>  	/*

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623163756.4591=
-1-include@grrlz.net?part=3D2
