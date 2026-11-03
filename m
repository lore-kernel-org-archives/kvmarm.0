Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793703343;
	b=Ir6qZaTRbGSpHKXLOnUic3FcCF2i8EqLFyb3BpFfgh8MiOt1APrFBkKNaskFGO858t2O
	 aciqON9XjP9Po2gmfr5xMIzFI5BbxCcgxNmwKdeJ31Z/1yIwQ3SMMAdhXXlyYLY5lO5Ac
	 /hzUZcPEZYQWa0eud+FzgUlRdd3qBHT/cCHZ1FLHmCKwKpZU9SHBdzjfzy2glE6nN1VFy
	 qazP88f7USDJqBsJF09fBoArwpw4iQG8P2hdwEU6MA4ltCD6gB3NsUqS4FHDq3o6jhT80
	 vVGTNqmRP1kOKI4MrTHKYou6L1uWpHJnj2H6t/gUnBjHHujAliFoYNOI10LOCqJKbNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703343;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/POWlM0GRpx4by4A+mZs06Eliu0uH08P6RSwRZcfMkY=;
	b=3qzMvQWdpbcXkJ2py2QkVtVCftLcEkEZ6B/0JU0onysXCvNiIFGsM+QqiqhIWRUf0qLV
	 /RRSVFwTfC/EBa493fbbjpZYmQLu5PS8SIvUSmipZdBgmi8px4CSGKbTPdWVdkHePGuz/
	 tCiTzwnI0HfscZ41Uo/kGVHaAFsTyX5aSRHLu2QR/rBHYlNy4YP/269litbbsMwoW31Zw
	 g6XnVDDjpSTPYQEagAuCP7IDSM8cVAf8aQNg0IlzYKzd5wxgDLHlZ104FO9djUNnmPhvq
	 bJ9ojIolyrjoZQkrWEjUQcwW97lzzDtIj9nlBVMW356ejdm+tgaZW6E6re3kRNGffeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fdZMR4Pe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BB760775D6
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 10:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fdZMR4Pe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB641F00A24;
	Tue,  3 Nov 2026 10:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793703342;
	bh=/POWlM0GRpx4by4A+mZs06Eliu0uH08P6RSwRZcfMkY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fdZMR4Pe+zrGp0ADQ0tCJIVn3y53b4N9XbJIKKf6Rh92FN3OHCvC4/XIJRYv8xiC8
	 4xVJa7RI0xAVfMkNRXGcQ39nlKuWefQ3euUi6/T04+8BfkyMaGO/zJ8f3msEGJ0Ugl
	 yJ3wNw3VTaWM0Rc3ngjOG7I4z8PUlARYOx974JbPC7P39BIrwMqCjRqb+OMaH/Yq0u
	 Ra6A+URT8His0zoJdZfukaBcHVT1wSrXe6W6/wDdkX/qJ/1Ph+NiJsfxvDVVc31po3
	 R4dYETWDUU6eeF+tBXYQzIyArVx6fGeqIG+X1e77M8WqOL/PoY3UdkdO7gRIwkgnJw
	 nRGTIIp/vP75g==
Message-ID: <sashiko-outbox-195084@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] KVM: arm64: nv: Size nested stage-2 MMUs by the NV
 PARange cap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261103102436.1605347-1-fuad.tabba@linux.dev>
References: <20261103102436.1605347-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 10:55:42 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] KVM: arm64: broken S1 fault injection in kvm_inject_size_fault() f=
or NV
- [Medium] KVM: arm64: nv: pre_fault_s2() maps GPAs above kvm_get_pa_bits()=
 cap
- [Low] KVM: arm64: nv: possible 48-bit PA cap bypass in __kvm_at_s1e01() f=
ast path
--

commit 03d1e6396b6b0768e2d16c9dde20baf00e0866c3
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: nv: Size nested stage-2 MMUs by the NV PARange cap

This commit caps kvm_get_pa_bits() at 48 bits for NV guests so that nested
stage-2 MMUs and stage-1/stage-2 software walks are bounded by the guest's
48-bit PARange cap rather than the host's IPA limit. It also updates
kvm_handle_guest_abort() to inject an address size fault when a stage-2
translation fault occurs at or above kvm_get_pa_bits().

> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 30d8f062b2c29..69bc621226cc2 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -383,7 +383,7 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struc=
t s1_walk_info *wi,
>  	ps =3D (wi->regime =3D=3D TR_EL2 ?
>  	      FIELD_GET(TCR_EL2_PS_MASK, tcr) : FIELD_GET(TCR_IPS_MASK, tcr));
> =20
> -	wi->max_oa_bits =3D min(get_kvm_ipa_limit(), ps_to_output_size(ps, wi->=
pa52bit));
> +	wi->max_oa_bits =3D min(kvm_get_pa_bits(vcpu->kvm), ps_to_output_size(p=
s, wi->pa52bit));

[Severity: Low]
This question rests on an architecture detail that could not be confirmed
from the kernel source. When __kvm_at_s1e01_fast() or __kvm_at_s1e2()
executes a hardware AT S1E1* or AT S1E0* instruction on a 52-bit host CPU
with stage-2 enabled, does hardware AT check the final stage-1 output
address (either an unmapped VA when the stage-1 MMU is disabled via
SCTLR_ELx.M =3D=3D 0 or HCR_EL2.DC =3D=3D 1, or a leaf descriptor OA when s=
tage-1
LPA2 is enabled via TCR_ELx.DS =3D=3D 1 and IPS/PS =3D=3D 0b110, given that
limit_nv_id_reg() caps ID_AA64MMFR0_EL1.PARange at 48 bits but leaves
TGRAN4/TGRAN16 at 52_BIT and TCR_EL1/TCR_EL2 unsanitised) only against
TCR_EL1.{DS,IPS} and the physical CPU's 52-bit PARange rather than bounding
it by VTCR_EL2?

If the answer is yes, then on a 52-bit host hardware AT in
__kvm_at_s1e01_fast() and __kvm_at_s1e2() will succeed with
SYS_PAR_EL1_F =3D=3D 0 (or fail with a stage-1 permission or access flag fa=
ult)
for a stage-1 output address in [2^48, 2^52). Because __kvm_at_s1e01() and
__kvm_at_s1e2() only fall back to handle_at_slow() -> setup_s1_walk() when
SYS_PAR_EL1_F is set and the fault is neither a stage-1 permission nor an
access flag fault:

arch/arm64/kvm/at.c:__kvm_at_s1e01() {
	if ((par & SYS_PAR_EL1_F) &&
	    !par_check_s1_perm_fault(par) &&
	    !par_check_s1_access_fault(par)) {
		ret =3D handle_at_slow(vcpu, op, vaddr, &par);
		if (ret)
			return ret;
	}
}

they will skip setup_s1_walk() and write the 52-bit PA (or permission/access
fault instead of a higher-priority address size fault) to PAR_EL1. In
__kvm_at_s12(), ipa =3D (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(=
11, 0))
will then strip bits [51:48] of par and walk the nested stage-2 page tables
with a truncated 48-bit IPA instead of reporting a stage-1 address size
fault.

> =20
>  	/* Compute minimal alignment */
>  	x =3D 3 + ia_bits - ((3 - wi->sl) * stride + wi->pgshift);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1db10d8d6db73..620fc6d1674bc 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2440,8 +2440,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	is_iabt =3D esr_trap_is_iabt(esr);
> =20
>  	if (esr_fsc_is_translation_fault(esr)) {
> -		/* Beyond sanitised PARange (which is the IPA limit) */
> -		if (fault_ipa >=3D BIT_ULL(get_kvm_ipa_limit())) {
> +		/* Beyond the VM's PA limit */
> +		if (fault_ipa >=3D BIT_ULL(kvm_get_pa_bits(kvm))) {
>  			kvm_inject_size_fault(vcpu);
>  			return 1;
>  		}

[Severity: High]
Can this trap an NV vCPU in an infinite fault loop and corrupt its guest
ESR_ELx register when a stage-2 translation fault at fault_ipa >=3D BIT_ULL=
(48)
occurs during a stage-1 page table walk (ESR_EL2.S1PTW =3D=3D 1) on a 52-bit
host?

On a 52-bit host, limit_nv_id_reg() caps ID_AA64MMFR0_EL1.PARange to 48 bits
while leaving TGRAN4/TGRAN16 at 52_BIT, and guest TCR_EL1/TCR_EL2 IPS/PS/DS
are loaded into hardware without masking. If an NV guest (L1 or L2) places
an address in [2^48, 2^52) in TTBRx_ELx or a stage-1 table descriptor, the
hardware stage-1 walker attempts to fetch the descriptor at
fault_ipa >=3D BIT_ULL(48), trapping to EL2 with a stage-2 translation fault
and S1PTW =3D=3D 1.

kvm_handle_guest_abort() now calls kvm_inject_size_fault(vcpu), which does:

arch/arm64/kvm/inject_fault.c:kvm_inject_size_fault() {
	addr  =3D kvm_vcpu_get_fault_ipa(vcpu);
	addr |=3D FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));

	__kvm_inject_sea(vcpu, kvm_vcpu_trap_is_iabt(vcpu), addr);
	...
	esr =3D vcpu_read_sys_reg(vcpu, exception_esr_elx(vcpu));
	esr &=3D ~GENMASK_ULL(5, 0);
	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
}

In __kvm_inject_sea() -> inject_abt64(), because kvm_vcpu_abt_iss1tw(vcpu)
is true, it calls __kvm_find_s1_desc_level(vcpu, addr, hpfar, &level):

arch/arm64/kvm/inject_fault.c:inject_abt64() {
	if (kvm_vcpu_abt_iss1tw(vcpu)) {
		u64 hpfar =3D kvm_vcpu_get_fault_ipa(vcpu);
		int ret;

		if (hpfar =3D=3D INVALID_GPA)
			return;

		ret =3D __kvm_find_s1_desc_level(vcpu, addr, hpfar, &level);
		if (ret)
			return;
}

First, addr passed to __kvm_find_s1_desc_level() is the reconstructed fault
IPA rather than the faulting guest VA (kvm_vcpu_get_hfar(vcpu)). Second,
because setup_s1_walk() now caps wi->max_oa_bits at kvm_get_pa_bits(vcpu->k=
vm)
(48 bits), check_output_size() in setup_s1_walk() (for TTBR, returning
-EFAULT) or walk_s1() (for a table descriptor, returning -EINVAL before
advancing level++ to the iteration where match_s1_desc() is called) rejects
the >=3D 2^48 descriptor address and aborts the walk.

When __kvm_find_s1_desc_level() returns an error, inject_abt64() returns
early without pending an exception or updating FAR_ELx/ESR_ELx.
kvm_inject_size_fault() then unconditionally clears bits [5:0] of the guest=
's
existing exception_esr_elx(vcpu), and kvm_handle_guest_abort() returns 1,
re-entering the guest at the same instruction in an infinite loop.

Also, when S1PTW =3D=3D 0 with stage-1 translation enabled (a stage-1 leaf
descriptor outputs an OA in [2^48, 2^52)), doesn't kvm_inject_size_fault()
write the reconstructed fault IPA into exception_far_elx(vcpu) instead of
kvm_vcpu_get_hfar(vcpu) and report level 0 instead of the leaf level?

[Severity: Medium]
The commit message states:

"If userspace gave the NV VM an IPA size above 48 bits, an L1 access above
48 bits then also gets the address size fault, instead of normal stage-2
handling."

If an NV VM is created with an IPA size above 48 bits on a 52-bit host,
kvm_arch_init_vm() initializes the canonical kvm->arch.mmu with that >48-bit
IPA range before KVM_ARM_VCPU_HAS_EL2 is set on any vCPU, and memslots can
be registered at GPAs >=3D BIT_ULL(48). If userspace then calls
KVM_PRE_FAULT_MEMORY, kvm_arch_vcpu_pre_fault_memory() faults the GPA into
the canonical kvm->arch.mmu via pre_fault_s2() without checking
kvm_get_pa_bits(kvm):

arch/arm64/kvm/mmu.c:kvm_arch_vcpu_pre_fault_memory() {
	struct kvm_s2_mmu *mmu =3D &kvm->arch.mmu; /* Canonical. */
	...
	do {
		ret =3D pre_fault_s2(mmu, vcpu, gpa, memslot);
	} while (ret =3D=3D -EAGAIN && num_retries++ < MAX_PRE_FAULT_RETRIES);
}

Once valid stage-2 PTEs are installed above 48 bits in kvm->arch.mmu.pgt,
wouldn't L1 accesses to those GPAs succeed directly in hardware (or take
stage-2 permission or access flag faults that bypass the
esr_fsc_is_translation_fault(esr) check in kvm_handle_guest_abort()) instead
of getting an address size fault?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103102436.1605=
347-1-fuad.tabba@linux.dev?part=3D1
