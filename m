Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794848934;
	b=cGtd8KZLGzp/ThQSAs3Hxjr95IeUpRP2pVF9hQN39HCPfQaB2hYiGQ1AoSuKUPWw+u0v
	 FtITIruTxlFXPp6kFizLHOa4C6y15HlLW4JgNWvMe/G5mKI9JacF6osGs/NGYBKoiMtU1
	 dmvwEqHLmewTzM6FLGfT5XEQJcUonlBUBMhtoe1YvZTXfv6+6DArxU7Or1Jsom+7vGT02
	 GWdoKrhPxGD4wUggEnuf+nEcMHXoq0XwrrvpD8X83/bnWVjMTApRCOvd+RKqMb94WrHYK
	 9J5AJixv6039inq7UqzUpMnxBy8rVgwOKsGpITpy5w7IY72Z7bDnEEIgMQfMm26DojA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794848934;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=q42OkKb4bgPRqVKAk9ZgiGB7sUxY3YG8JGtLgs56q8g=;
	b=0maNkTGnmMdX47osHTc7c/bXnyJbNYyyrefMNGoMUWnHNl/SKvZbVkWYCYVgKPzX4AP1
	 Ja7rEc0fJpQM52+liKhDmdXvTvWw2IX18HpTBJCfOcL7CyFAvEsGUUsfZjFHx4t9X6U+E
	 Be/pre/gcCSeZFVs4Xixyoj+tQbsd0SUDc5S8p4mPM0Igj+xMCNAwYyVl/KU5+118rLMu
	 VKHARDBBwPRB5o5aGpBEKB2urOzJSg1Vz25gBgXGjlnH06ltRGx+7CibIn4BgCrMtG1uc
	 YRCM3KpWKe0C7nvY2KMSTNhPxSHzGN/ql1ru50+bejovE6Mj7djpyfaw88GtTpi4TqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PlDGmRZq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67CB606A31C;
	Mon, 16 Nov 2026 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PlDGmRZq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8591F000CA;
	Mon, 16 Nov 2026 17:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794848934;
	bh=q42OkKb4bgPRqVKAk9ZgiGB7sUxY3YG8JGtLgs56q8g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PlDGmRZqo0pcsqcmjVWE2yH+0fLzm0ZR5ZgTTGwHsswwiJMeE8GbLWIV5zVnOZ3SC
	 g0ZfvenyNc5L7Okn7mXOjmxiLhuWIcxblIbAEKi4ClndOAf7hL8GhmAbZQfWV0bdUK
	 16PSdonCdDYG1lyerVpAOart9vII5SqN2k7dC0p1uq1+AIAVZqVRZ5ze8e8K/ZOmvG
	 YuEs8vwflQbVIzR7yDzwzoAxZf984k8A7/Hs3e+F7KpnlTSG37dm79Ph9GtPOVUPhR
	 hlMux1uItMkUli6A2FHs18xnXPHWVcGxXdaRldYv9w++1VlykhRN+vmqSoFUp4/DWg
	 fvUaqjcvUF2qA==
Message-ID: <sashiko-outbox-217410@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/11] KVM: arm64: CCA: Tear down RTTs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261116164358.142785-6-steven.price@arm.com>
References: <20261116164358.142785-1-steven.price@arm.com>
 <20261116164358.142785-6-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 17:08:53 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] KVM: arm64: unclamped stage-2 levels in get_start_level() on
  64K pages
- [Medium] KVM: arm64: CCA: unlocked kvm_realm_is_created() check in
  kvm_uninit_stage2_mmu()
- [Low] KVM: arm64: mix of guard() and goto cleanup in
  kvm_destroy_realm()
- [Low] KVM: arm64: possible skipped parent retry in
  realm_tear_down_rtt_level()
--

commit 80a462fb8b46e04c72060d069b1296caf72d83ff
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Tear down RTTs

This commit adds stage-2 unmapping and Realm Translation Table (RTT)
teardown for Arm CCA Realms during stage-2 MMU uninitialization and final
Realm destruction.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ac72db3d4505f..9baf2352d2a8f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1145,9 +1145,25 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kv=
m_s2_mmu *mmu, unsigned long t
>  	return err;
>  }
> =20
> +static void kvm_realm_uninit_stage2(struct kvm_s2_mmu *mmu)
> +{
> +	struct kvm *kvm =3D kvm_s2_mmu_to_kvm(mmu);
> +
> +	mutex_lock(&kvm->arch.config_lock);
> +	if (kvm_realm_state(kvm) =3D=3D REALM_STATE_NEW ||
> +	    kvm_realm_state(kvm) =3D=3D REALM_STATE_ACTIVE) {
> +		kvm_set_realm_state(kvm, REALM_STATE_DYING);
> +		WARN_ON(kvm_realm_teardown_stage2(kvm));
> +	}
> +	mutex_unlock(&kvm->arch.config_lock);
> +}
> +
>  void kvm_uninit_stage2_mmu(struct kvm *kvm)
>  {
> -	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +	if (kvm_realm_is_created(kvm))
> +		kvm_realm_uninit_stage2(&kvm->arch.mmu);
> +	else
> +		kvm_free_stage2_pgd(&kvm->arch.mmu);
>  	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>  }

[Severity: Medium]
Can kvm_uninit_stage2_mmu() race with Realm creation by checking
kvm_realm_is_created() outside kvm->arch.config_lock?

If kvm_mmu_notifier_release() -> kvm_arch_flush_shadow_all() runs before
or concurrently with Realm creation, kvm_uninit_stage2_mmu() takes the
else branch without holding config_lock, freeing mmu->pgt and clearing
mmu->pgd_phys while leaving realm.state at REALM_STATE_NONE.  Checking
kvm_vm_is_realm(kvm) here and handling all realm.state transitions inside
kvm_realm_uninit_stage2() under config_lock (including moving
REALM_STATE_NONE to REALM_STATE_DEAD and freeing the PGD) would avoid the
race.

> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 57f59b618a96e..74b89da4e8015 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -16,22 +16,213 @@ u32 kvm_rmm_ipa_limit(void)
>  	return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
>  }
> =20
> +static int get_start_level(struct realm *realm)
> +{
> +	/*
> +	 * kvm_init_ipa_range() enforces a minimum of 32 IPA bits
> +	 * (ARM64_MIN_PARANGE_BITS).
> +	 */
> +	return 4 - stage2_pgtable_levels(realm->ia_bits);
> +}

[Severity: High]
Does get_start_level() return 3 instead of 2 for a 32-bit or 33-bit IPA
Realm on CONFIG_ARM64_64K_PAGES?

stage2_pgtable_levels(ipa) evaluates ARM64_HW_PGTABLE_LEVELS((ipa) - 4),
which is 1 for 32 or 33 IPA bits with 64K pages, whereas kvm_get_vtcr()
clamps the stage-2 levels to at least 2:

arch/arm64/kvm/hyp/pgtable.c:kvm_get_vtcr() {
    ...
	lvls =3D stage2_pgtable_levels(phys_shift);
	if (lvls < 2)
		lvls =3D 2;
    ...
}

When get_start_level() returns 3, realm_tear_down_rtt_range() calls
realm_tear_down_rtt_level() with level =3D 4 (> KVM_PGTABLE_LAST_LEVEL),
triggering WARN_ON() and returning -EINVAL, which causes
kvm_destroy_realm() to abort and leak the Realm Descriptor, RTT granules
and stage-2 PGD pages.

[ ... ]

> +static int realm_tear_down_rtt_level(struct realm *realm, int level,
> +				     unsigned long start, unsigned long end)
> +{
> +	ssize_t map_size;
> +	unsigned long addr, next_addr;
> +
> +	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
> +		return -EINVAL;
> +
> +	map_size =3D kvm_granule_size(level - 1);
> +	if (WARN_ON(!IS_ALIGNED(start, map_size)))
> +		return -EINVAL;
> +
> +	for (addr =3D start; addr < end; addr =3D next_addr) {
> +		phys_addr_t rtt_granule;
> +		long ret;
> +		unsigned long align_addr =3D ALIGN(addr, map_size);
> +
> +		next_addr =3D ALIGN(addr + 1, map_size);
> +
> +		if (next_addr > end || align_addr !=3D addr) {
> +			/*
> +			 * The target range is smaller than what this level
> +			 * covers, recurse deeper.
> +			 */
> +			ret =3D realm_tear_down_rtt_level(realm,
> +							level + 1,
> +							addr,
> +							min(next_addr, end));
> +			if (ret)
> +				return ret;
> +			continue;
> +		}
> +
> +		ret =3D realm_rtt_destroy(realm, addr, level,
> +					&rtt_granule, &next_addr);
> +		if (ret < 0)
> +			return ret;
> +
> +		switch (RMI_RESULT_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			free_rtt(rtt_granule);
> +			break;
> +		case RMI_ERROR_RTT:
> +			if (next_addr > addr) {
> +				/* Missing RTT, skip */
> +				break;
> +			}
> +			/*
> +			 * We tear down the RTT range for the full IPA
> +			 * space, after everything is unmapped. Also we
> +			 * descend down only if we cannot tear down a
> +			 * top level RTT. Thus RMM must be able to walk
> +			 * to the requested level. e.g., a block mapping
> +			 * exists at L1 or L2.
> +			 */
> +			if (WARN_ON(RMI_RESULT_DATA_LEVEL(ret) !=3D level))
> +				return -EBUSY;

[Severity: Low]
This question rests on an Arm CCA RMM specification detail that could not
be confirmed from the kernel source: when SMC_RMI_RTT_DESTROY fails with
RMI_ERROR_RTT because the RTT at @level still has live child table
entries, can the RMM return out_top > addr (with addr < next_addr <
addr + map_size) if the initial entries in that RTT are non-live, or report
RMI_RESULT_DATA_LEVEL(ret) =3D=3D level - 1?

If out_top advances to the first live entry inside the RTT at @level, the
if (next_addr > addr) check treats the RTT as missing and advances addr to
that unaligned next_addr; the next iteration then sees align_addr !=3D addr,
destroys the remaining child RTTs at level + 1, and continues to the next
map_size boundary without retrying realm_rtt_destroy() on the parent RTT
at @level, leaving it live and causing rmi_realm_destroy() to fail.  If
instead the walk terminates at level - 1 with next_addr =3D=3D addr,
WARN_ON(RMI_RESULT_DATA_LEVEL(ret) !=3D level) fires and aborts teardown
with -EBUSY.

[ ... ]

>  void kvm_destroy_realm(struct kvm *kvm)
>  {
>  	struct realm *realm =3D &kvm->arch.realm;
>  	size_t pgd_size =3D kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
> =20
> +	/*
> +	 * Serialize final RMM teardown with Realm creation and stage-2 teardow=
n,
> +	 * which also access Realm state under config_lock.
> +	 */
> +	guard(mutex)(&kvm->arch.config_lock);
> +
>  	if (!kvm_realm_is_created(kvm))
>  		goto out_free_sro;
> =20
>  	kvm_set_realm_state(kvm, REALM_STATE_DYING);
> =20
> +	/*
> +	 * REALM_DESTROY requires the realm to be non-live: all RECs must have
> +	 * been destroyed and the root RTTs must be empty. Unmap the IPA space
> +	 * and destroy any non-root RTTs before tearing down the RD. The root
> +	 * RTT pages are still owned by the RMM at this point, so keep the KVM
> +	 * pgtable alive until after REALM_DESTROY and undelegation.
> +	 */
> +	realm_unmap_stage2(kvm);
> +
>  	if (realm->rd_phys) {
>  		phys_addr_t rd_phys =3D realm->rd_phys;
> =20
>  		if (WARN_ON(rmi_realm_terminate(rd_phys, realm->sro)))
>  			goto out_free_sro;
> =20
> +		if (WARN_ON(realm_destroy_rtts(kvm)))
> +			goto out_free_sro;
> +
>  		if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
>  			goto out_free_sro;
>  		rmi_free_delegated_page(rd_phys);
> @@ -44,6 +235,9 @@ void kvm_destroy_realm(struct kvm *kvm)
> =20
>  	kvm_set_realm_state(kvm, REALM_STATE_DEAD);
> =20
> +	/* Now that the realm is destroyed, free the entry-level RTTs. */
> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +
>  out_free_sro:
>  	kfree(realm->sro);
>  	realm->sro =3D NULL;

[Severity: Low]
This isn't a bug, but kvm_destroy_realm() mixes guard(mutex) with goto
out_free_sro cleanup.  Using __free(kfree) for realm->sro (or explicit
mutex_lock() and mutex_unlock()) would avoid mixing scope-based cleanup
and goto unwinding in the same function.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116164358.1427=
85-1-steven.price@arm.com?part=3D5
