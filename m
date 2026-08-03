Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251C630F7FB
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785752807; cv=none; b=vEhchj+C0OeAkYrbfZlPuaDqcEnrfs7x4mUMIo6VpCl9b7hQuvkpZlk+1v5+uUYKRZhs20Sb3E2354JJWLcxjF4XJHpK6NfjvHsqMjaCCHujRf75ydzmcYLS6yErw4l/Fo3l0AsE9l4IQHWWVB2kmtD7xvMP7u3cF1z0Y+I1n4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785752807; c=relaxed/simple;
	bh=xkCVWs1mt6y/bknJTdUELd7PjtJUshFG9QmTDA3+ab8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kurx2P7bxO3Tea0GM2lzXX8f0r4iUFYfFqLTD3/75ONkMRhP6bb50BzEX73KcfANH8I+3BU+Amc80KquVy5+6cahrTvh4wPMUkOx9ZI3ixT3W1M1j04eiohvs+a7FombQC1I573r4YoV58RFxTpDEf0gjSDnTlRitj6mSdyYTfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ny33H/sk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ny33H/sk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628141F000E9;
	Mon,  3 Aug 2026 10:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785752805;
	bh=yRYuVgHnu1z25+3NI2J6D3cmYSyqv4cmDRrj4lh4Fm8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ny33H/skHucqmXUZx3FmFTxe3eXoAIq0Ymvr/hn5B70/w11KDZ4NVheMj90+8ro/q
	 4Az+/OmVLETVq9TkBlkLooKPATCnlqN+zlQQ9XB7wEYtcP6Wcgh5J2n4bRXeIaBN5A
	 Hcq5QESFCJAC5K0EvUpdVXc36OkXz1OAcY+QX2BQNwKIjp9THv6uldSOCVIp7zVFgQ
	 /jK3YOY6ht693FF79LbcFR5gLdICZjUCt33/mprh8oFRQC4IMCYvPatyjPUnvR5CPt
	 5RVXFP844QUMfSHxumvvcF45q2dXfLd3pMjjuNY5szs7sYXL/Sz6fbrA7QPbpL75o+
	 5bWrokVgMFb3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/20] KVM: arm64: Add a range to
 __pkvm_host_donate_guest()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260803100904.3563942-8-vdonnefort@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-8-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 10:26:44 +0000
Message-Id: <20260803102645.628141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Incomplete support for block mappings causes memory leaks and hype=
rvisor panics on guest teardown and page reclaim.
--

--- Patch [7]: [PATCH 07/20] KVM: arm64: Add a range to __pkvm_host_donate_=
guest() ---
commit f5b9f10172162184655bd754092954f6d293a934
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add a range to __pkvm_host_donate_guest()

This commit updates the __pkvm_host_donate_guest() hypercall to accept a
nr_pages argument, enabling it to map block-sized pages (e.g., PMD_SIZE) in
both the guest and host stage-2 page tables. It also updates various selfte=
st
and pkvm mappings to pass the new argument.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> index 3118941a11a7d..9ea448895c15e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
[ ... ]
> @@ -1422,22 +1422,30 @@ static int __guest_check_pgtable_memcache(struct =
pkvm_hyp_vcpu *vcpu)
>  	return 0;
>  }
> =20
> -int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcp=
u)
> +int __pkvm_host_donate_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm=
_hyp_vcpu *vcpu)
>  {
>  	struct pkvm_hyp_vm *vm =3D pkvm_hyp_vcpu_to_hyp_vm(vcpu);
>  	u64 phys =3D hyp_pfn_to_phys(pfn);
>  	u64 ipa =3D hyp_pfn_to_phys(gfn);
> +	u64 size;
>  	u64 meta;
>  	int ret;
> =20
> +	if (!pfn_range_is_valid(pfn, nr_pages))
> +		return -EINVAL;
> +
> +	ret =3D __guest_check_transition_size(phys, ipa, nr_pages, &size);

[Severity: High]
Does this code safely handle block mappings on reclaim?

If __pkvm_host_donate_guest() installs a block mapping (when nr_pages =3D 5=
12),
wouldn't __pkvm_host_reclaim_page_guest() fail to reclaim it because
get_valid_guest_pte() explicitly rejects block mappings?

arch/arm64/kvm/hyp/nvhe/mem_protect.c:get_valid_guest_pte() {
    ...
	if (level !=3D KVM_PGTABLE_LAST_LEVEL)
		return -E2BIG;
    ...
}

Similarly, wouldn't a hardware poison event calling
__pkvm_host_force_reclaim_page_guest() trigger a fatal hypervisor panic
when reading the block-level annotation, due to the WARN_ON in
host_stage2_get_guest_info()?

arch/arm64/kvm/hyp/nvhe/mem_protect.c:host_stage2_get_guest_info() {
    ...
	ret =3D kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, &level);
    ...
	if (WARN_ON(level !=3D KVM_PGTABLE_LAST_LEVEL))
		return -EINVAL;
    ...
}

> +	if (ret)
> +		return ret;
> +
>  	host_lock_component();
>  	guest_lock_component(vm);
> =20
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803100904.3563=
942-1-vdonnefort@google.com?part=3D7
