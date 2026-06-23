Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ED3208D0
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 19:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782241569; cv=none; b=Ed3wbMCygD72+goSRjeSlLoQ78LM6Sym/5DuWSEZA70aSPWfHiuE841eOc6whC7coxlAByviGKzga0FNWShKoiEsGpiwew1vRU5EDj5Kn9vXwALEpdD6fqWTABlEZjtOK8q6DjiyYjmJoOXA7kz8i8XowbEAeiPVIEEydEHNVBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782241569; c=relaxed/simple;
	bh=dFNwQj+cenFZoJbKHd6i8UtcstO8ZSQXq0tLCSrpm2Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nYkUZLSHm1RaV8EUNhtYLhjmo6NsKLZ2VRy8hvXZKGc49QTzakz6vHm29sRx5bIVcONbblhp0yw72XOS4qXo9dZZDgGWCKwFhuZbKF4ihpF6zoNzZxsNdoDfw99FJdXTC2X8dzbmdSi7TgtK7zqLa613mHRZNpliJt6MnBzA0kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJQCb/W3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJQCb/W3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7106B1F000E9;
	Tue, 23 Jun 2026 19:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782241567;
	bh=rQhDPfzt6tLQi6pXEZBocW85b0/bUiTRy6QCIqIix34=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XJQCb/W3j/wloG7NFPs69N609uycLb1fx2FLj83RbaHmqFdfOwXRuuPtBiYVcol6Q
	 WODZLCS6P71JtTn+j/+30Hun6fluK7eJxfy7eUo+YaCriBSAbRPvx+Ou7Nyj5XT/j5
	 1WLOaXO6hwgvoH4XmR35x8LXRls3vLsBfm6BLaOKv2gdfhZ4cs1i2wMz9x+k2mbFjT
	 hTf7AfbjydzT1TL8U9CSBvNSBhcgfGiJxFdVKb7pcBv8wj+mNOr8V2lL2BAJiPWAm0
	 qSjfK6pp0hwQB5tkjqlX3luao/WDyiSlXGOMm7ZDmOBA0aCvBwWc+W9TEIpt1ZQum2
	 8S8A/+m4oG86w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/22] KVM: arm64: nv: Pass an access descriptor for
 stage-2 walks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260623184201.1518871-6-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-6-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 19:06:07 +0000
Message-Id: <20260623190607.7106B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] __kvm_at_s12 invokes a nested stage-2 page table walk without =
holding the KVM SRCU read lock, causing a Use-After-Free.
- [Critical] Missing SRCU read lock in Synchronous External Abort (SEA) han=
dling causes a Use-After-Free on memslots during __kvm_find_s1_desc_level.
- [High] kvm_s2_handle_perm_fault incorrectly checks execute permissions in=
stead of read/write permissions for a stage-1 PTW triggered by an instructi=
on fetch.
- [High] __kvm_at_s12 corrupts the intermediate physical address (IPA) for =
guests using 16KB or 64KB translation granules.
- [High] __kvm_at_s12 silently truncates 52-bit intermediate physical addre=
sses when reading the stage-1 translation result from PAR_EL1.
--

commit 2325baae11b7348a33c6e1cec8c8a1a565d36558
Author: Oliver Upton <oupton@kernel.org>
Subject: KVM: arm64: nv: Pass an access descriptor for stage-2 walks

This commit modifies the stage-2 page table walk API to take an access
descriptor instead of just the IPA. This provides sufficient context to the
PTW to determine the correct behavior for access-dependent features like
FEAT_HAFDBS.

> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 7a84495a2e6d4..083014e9d86a3 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -1642,9 +1655,11 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u6=
4 vaddr)
>  		return 0;
> =20
>  	/* Do the stage-2 translation */
> -	ipa =3D (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
> +	access.type =3D WALK_ACCESS_AT;
> +	access.ia =3D (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0)=
);

[Severity: High]
This is a pre-existing issue, but does this bitwise AND operation silently
truncate 52-bit intermediate physical addresses?

If the CPU and guest support 52-bit physical addresses (FEAT_LPA or
FEAT_LPA2), the physical address occupies bits up to 51. The
GENMASK_ULL(47, 12) truncates bits [51:48], feeding a 48-bit address into
kvm_walk_nested_s2() which breaks nested guests utilizing memory addresses
beyond the 48-bit boundary.

[Severity: High]
This isn't a bug introduced by this patch, but does this assume a 4KB granu=
le
and corrupt the IPA for guests using 16KB or 64KB translation granules?

For 16KB and 64KB translation granules, the page offset spans 14 bits and
16 bits respectively. The hardware returns a PAR_EL1 where bits [15:12] are
RES0 for a 64KB granule. Because the offset is extracted exclusively from
vaddr & GENMASK_ULL(11, 0), bits [15:12] of the reconstructed IPA will be
zeroed out, causing the stage-2 walk to use the wrong address.

>  	out.esr =3D 0;
> -	ret =3D kvm_walk_nested_s2(vcpu, ipa, &out);
> +
> +	ret =3D kvm_walk_nested_s2(vcpu, &access, &out);

[Severity: Critical]
This is a pre-existing issue, but does this invoke a nested stage-2 page
table walk without holding the KVM SRCU read lock?

kvm_walk_nested_s2() reads from guest memory using kvm_read_guest(), which
dereferences the RCU-protected memslots array. If host userspace unmaps or
modifies the VM's memslots concurrently while the nested hypervisor executes
an AT S12 instruction, can this result in a use-after-free condition leading
to host kernel memory corruption?

[ ... ]
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f35c4ce954731..88998195274b9 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2313,9 +2313,23 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	 */
>  	if (kvm_is_nested_s2_mmu(vcpu->kvm,vcpu->arch.hw_mmu) &&
>  	    vcpu->arch.hw_mmu->nested_stage2_enabled) {
> +		struct kvm_walk_access access =3D {
> +			.ia	=3D fault_ipa,
> +		};
>  		u32 esr;
> =20
> -		ret =3D kvm_walk_nested_s2(vcpu, fault_ipa, &nested_trans);
> +		if (kvm_vcpu_abt_iss1tw(vcpu))
> +			access.type =3D WALK_ACCESS_S1PTW;
> +		else if (is_iabt)
> +			access.type =3D WALK_ACCESS_IFETCH;
> +		else if (kvm_vcpu_dabt_is_cm(vcpu))
> +			access.type =3D WALK_ACCESS_CMO;
> +		else
> +			access.type =3D WALK_ACCESS_LDST;
> +
> +		access.write =3D kvm_is_write_fault(vcpu);
> +
> +		ret =3D kvm_walk_nested_s2(vcpu, &access, &nested_trans);
>  		if (ret =3D=3D -EAGAIN) {
>  			ret =3D 1;
>  			goto out_unlock;

[Severity: High]
This isn't a bug introduced by this patch, but does kvm_s2_handle_perm_faul=
t()
incorrectly check execute permissions instead of read/write permissions for=
 a
stage-1 PTW triggered by an instruction fetch?

When an instruction fetch triggers a stage-1 page table walk (S1PTW) that
causes a stage-2 permission fault, the resulting exception is reported as an
instruction abort (IABT) with the S1PTW bit set. A page table walk is a data
read, so the hardware checks stage-2 read/write permissions.

However, kvm_s2_handle_perm_fault() evaluates this as an instruction fetch:

arch/arm64/kvm/nested.c:kvm_s2_handle_perm_fault() {
    ...
	if (kvm_vcpu_trap_is_iabt(vcpu)) {
		if (vcpu_mode_priv(vcpu))
			forward_fault =3D !trans->px;
		else
			forward_fault =3D !trans->ux;
	} else {
    ...
}

Because stage-2 page tables mapping the stage-1 page tables are typically
marked Execute-Never (XN), will KVM spuriously inject a stage-2 permission
fault into the nested hypervisor?

[Severity: Critical]
This is a pre-existing issue, but does handling a Synchronous External Abort
(SEA) without the SRCU read lock cause a use-after-free during
__kvm_find_s1_desc_level()?

When KVM handles an SEA fault, kvm_handle_guest_abort() delegates to
kvm_inject_sea() before acquiring the SRCU read lock:

arch/arm64/kvm/mmu.c:kvm_handle_guest_abort() {
    ...
	if (esr_fsc_is_translation_fault(esr)) {
		/* Beyond sanitised PARange (which is the IPA limit) */
		if (fault_ipa >=3D BIT_ULL(get_kvm_ipa_limit())) {
			kvm_inject_size_fault(vcpu);
			return 1;
		}

		/* Falls between the IPA range and the PARange? */
		if (fault_ipa >=3D BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
			fault_ipa |=3D FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));

			return kvm_inject_sea(vcpu, is_iabt, fault_ipa);
		}
	}
    ...
}

If the SEA occurred during a stage-1 page table walk (S1PTW), it cascades
to inject_abt64(), which calls __kvm_find_s1_desc_level():

arch/arm64/kvm/inject_fault.c:inject_abt64() {
    ...
		ret =3D __kvm_find_s1_desc_level(vcpu, addr, hpfar, &level);
    ...
}

This ultimately calls walk_s1() which relies on kvm_read_guest() to read the
descriptors. Because the SRCU read lock is not held, can the memslot lookup
race with concurrent host userspace memslot modifications, causing a
use-after-free?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623184201.1518=
871-1-oupton@kernel.org?part=3D5
