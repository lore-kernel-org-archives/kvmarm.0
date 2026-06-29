Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F8534A773;
	Mon, 29 Jun 2026 11:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782733007; cv=none; b=axaNokav1m2RbTivUH4+fbRPzT+bmq85SdZ148jfoFDlglwvn0TPILk2aAkG92yDIIX71775v0GbvDHqPvkiX+FeWOY/IrI1EcWDQ1h71VVWefmgNWQM8ABZV1kiH98N831BVkgGeqC0JL/IvBPWIZ/o5aaAOgLpR9FjwVeRzhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782733007; c=relaxed/simple;
	bh=JbnoyNfNT+PVDzeYVWrXdtFtgFLPvXibaqOOIM3XGbs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dH9XaNiGejgnJ2NVfZ6Angx5NoAaH9XCR3NC/mozN7Z7vuKoTaNnY6hHvdmNiY74dUmhRp4KyjNTAggmGKg9iN9xNSmLDvSmuVy6+tWQTC0e53BF7I3u0fBlCy1BSDXC8GRx3LIlX4tdpgLCACbHSlFN/p2mFgXEV9wSnur03kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oxz3zwOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oxz3zwOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6801F000E9;
	Mon, 29 Jun 2026 11:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782733006;
	bh=JMNsMGHAr5ufY7gpP7dG2XfXCxxVhA1Fl8xTS+E6llw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Oxz3zwOsnIG/PBGGqYS7ltHEZQEhA/JbeYFsqwEDl+QodWpWx+YsLizgQiZO31fJC
	 rQrHF+08y7I038x/kg6Ud7dz10tuS939qIxj/ujZ9eHPvuj1tL1v7ndCaelINWw4Ou
	 3oWB2PNo5kvjRqRcIReLayPpO4u0gVaw+lK439f4192fdEWb9mlpmc0iLJDtr9KxM+
	 Piyux3Ugwsx9beRPab1HTQtcfNhyOUNZUILS1rY7lrRzfzz6kXQwogatnxmYZXOFRh
	 ccb6Ei92CUtzDkFgrzb88d3JeIoHHbHeGhZ51djbp52rlgkIvxF+C+EQabNmV3745I
	 2Hl8Yx7B1LJZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/13] KVM: arm64: Enable eager hugepage splitting if
 HDBSS is available
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260629111820.1873540-3-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-3-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 11:36:45 +0000
Message-Id: <20260629113645.BE6801F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The default eager page splitting chunk size violates the KVM_CAP_A=
RM_EAGER_SPLIT_CHUNK_SIZE UAPI contract by using a value that is not a vali=
d block size for 16KB and 64KB page kernels.

Pre-existing issues:
- [Critical] Dropping mmu_lock between primary and nested stage-2 write-pro=
tection creates a window where nested guests can bypass dirty logging.
--

commit 09e1d250ed331b9dc20b42b7f9315892a86a5d50
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: Enable eager hugepage splitting if HDBSS is available

This commit enables eager hugepage splitting by default for systems
supporting HDBSS, setting the default chunk size to 256K pages at
stage2 initialization.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6c941aaa10c63..e086c01a9325e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1027,8 +1027,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kv=
m_s2_mmu *mmu, unsigned long t
>  	for_each_possible_cpu(cpu)
>  		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) =3D -1;
> =20
> -	 /* The eager page splitting is disabled by default */
> -	mmu->split_page_chunk_size =3D KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +	 /* The eager page splitting is disabled by default if system has no HD=
BSS */
> +	if (system_supports_hdbss())
> +		mmu->split_page_chunk_size =3D 256 * 1024 * PAGE_SIZE;

[Severity: High]
Does this hardcoded chunk size violate the KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SI=
ZE
UAPI contract on kernels with 16KB or 64KB pages?

By setting the default chunk size to 256 * 1024 * PAGE_SIZE, this evaluates=
 to
4GB on 16KB page systems and 16GB on 64KB page systems.

However, in arch/arm64/kvm/arm.c:kvm_vm_ioctl_enable_cap(), the chunk size =
is
validated against valid architectural block sizes:

    if (!new_cap || kvm_is_block_size_supported(new_cap)) {
    ...

Since 4GB and 16GB are not valid block sizes on those configurations, a VMM
like QEMU attempting to read the default capability via KVM_CHECK_EXTENSION
and set it back via KVM_ENABLE_CAP will be rejected with -EINVAL.

[Severity: Critical]
This is a pre-existing issue, but by enabling eager hugepage splitting by
default for HDBSS, does this exacerbate a race condition with nested guests
bypassing dirty logging?

In arch/arm64/kvm/mmu.c:kvm_arch_mmu_enable_log_dirty_pt_masked(), KVM enab=
les
dirty logging by write-protecting the primary stage-2 and then calling
kvm_mmu_split_huge_pages():

    if (kvm_dirty_log_manual_protect_and_init_set(kvm))
        kvm_mmu_split_huge_pages(kvm, start, end);

    kvm_nested_s2_wp(kvm);

Because kvm_mmu_split_huge_pages() can drop the mmu_lock to top-up the memo=
ry
cache or reschedule, a race window is created before kvm_nested_s2_wp()
protects the nested stage-2 tables.

While the lock is dropped, a nested VCPU can fault, map the page via its
separate shadow stage-2 (which hasn't been write-protected yet), and write =
to
the page without setting the dirty bitmap, leading to silent memory corrupt=
ion
after live migration.

> +	else
> +		mmu->split_page_chunk_size =3D KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +
>  	mmu->split_page_cache.gfp_zero =3D __GFP_ZERO;
> =20
>  	mmu->pgd_phys =3D __pa(pgt->pgd);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629111820.1873=
540-1-leo.bras@arm.com?part=3D2
