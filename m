Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C6823AB88;
	Sat,  1 Aug 2026 13:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785589358; cv=none; b=ouMudxsg3yA3BAwYgDgZMIL5Snjwdx7oS4VHR2EVnKkr0R+AGU0/kBE6tBjsZygmhPHAXggVPilMQE6IjwsZ0phXmM9aITPtqa87X2nUAYx0JqYRdw6A4uKnDkqZU/G3QTltb6r3fjOccyW/8u6D51Cz2juTJ6jx6ethvM7Otx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785589358; c=relaxed/simple;
	bh=rb/l4sr8IbiL7U1G0r4URAm4tqtGnZ78xsCMc0KTVlI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u12rvgyfCisPk5x7CVonmd0R0u5NQRlUJygigJrQGZ5ehe+ftlYCuSXW8wI+Mo01nppyiu35IXgp6/PP3qs61V4uMEO4S7HCLA3V2fYn0yv2dNqB/vN9JeCSN3yawi5et4juAsy/Mw7U3jcvsCW1aN49fh7FBwFpkZdHWGeP+Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DnH9HpzK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DnH9HpzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD8F1F00ACA;
	Sat,  1 Aug 2026 13:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785589357;
	bh=4H6dOJpViP0mjVmGPcT0m0UnCaw8prEj+8ocvDLWkoU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DnH9HpzKm+pS4J15PhlZ5R7XGChnpujfAt3/nqAKACyU8VFHGYa8QWyaqy69fSrwN
	 2cRnI31xY4bwbRPuS1wlNKkGjy29oLUvySh2LVT0qSs/2r1cBFDOC8QDOSzD7uOEwx
	 bJ+JGueKd1JxmVjwyxWcbC2l9HbSIRT9fDlq1+f0+dq3gxiTzUWRZztn7iNkZju8NH
	 YmGKAmfD5VpK6PqQ7rbp9ytAB7qkEqpfsM7ZwnaY+y0g6JA1zGCeE33rUrzW9U//kb
	 4q7628bdRevbbwP37aClLIN6NlPstZU+ci0xqQnZtkhilbyoAGn/z6QVCyvretEC6F
	 hqKzmovh/Rf6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/6] KVM: arm64: Couple VNCR fixmap clearing and CPU
 number invalidation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260801124818.366274-6-maz@kernel.org>
References: <20260801124818.366274-1-maz@kernel.org>
 <20260801124818.366274-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 13:02:36 +0000
Message-Id: <20260801130237.0FD8F1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Critical] By modifying `invalidate_vncr()` to call the new `unmap_l1_vnc=
r()` helper, this patch asynchronously sets `vt->cpu =3D -1` when invalidat=
ing a remote vCPU's VNCR TLB. However, the host CPU's `L1_VNCR_MAPPED` flag=
 remains set on the remote CPU. When the remote vCPU is eventually schedule=
d out and executes the lockless `this_cpu_reset_vncr_fixmap()`, it observes=
 `L1_VNCR_MAPPED` is true but finds `vt->cpu` has been changed to `-1`. Thi=
s triggers a deterministic host kernel panic via `BUG_ON(vcpu->arch.vncr_tl=
b->cpu !=3D smp_processor_id())`. A guest can trivially exploit this by iss=
uing a TLBI from one vCPU while another is running.

Pre-existing issues:
- [Critical] In `kvm_map_l1_vncr()`, `vt->cpu` is unconditionally set to `s=
mp_processor_id()`. If the mapping has no read permissions (`prot =3D=3D PA=
GE_NONE`), the function returns without mapping the fixmap or setting the `=
L1_VNCR_MAPPED` flag. When the vCPU is scheduled out, `this_cpu_reset_vncr_=
fixmap()` checks `L1_VNCR_MAPPED` and returns early, failing to reset `vt->=
cpu` to `-1`. This leaves a stale CPU ID in `vt->cpu`. If the host later in=
validates this vCPU's VNCR TLB, `invalidate_vncr()` reads the stale CPU ID =
and maliciously clears the fixmap for that CPU. If another vCPU is running =
on that CPU and using the fixmap slot, its VNCR mapping is unexpectedly des=
troyed, leading to a host Data Abort kernel panic when accessed. This probl=
em wasn't introduced by this patch, but remains a critical vulnerability.
- [Critical] A Time-of-Check to Time-of-Use (TOCTOU) race exists on `vt->cp=
u` between `invalidate_vncr()` and the lockless `this_cpu_reset_vncr_fixmap=
()`. `invalidate_vncr()` executes `if (vt->cpu !=3D -1)` and then calls `un=
map_l1_vncr()`, which evaluates `vncr_fixmap(vt->cpu)`. Because `this_cpu_r=
eset_vncr_fixmap()` is called from `kvm_arch_vcpu_put` without holding `kvm=
->mmu_lock`, it can run concurrently on the target vCPU's host CPU and set =
`vt->cpu =3D -1` exactly between the check and the use. `unmap_l1_vncr()` t=
hen evaluates `vncr_fixmap(-1)`, triggering `BUG_ON(__c >=3D NR_CPUS)` and =
panicking the host. This problem wasn't introduced by this patch, but remai=
ns a critical vulnerability.
--

--- Patch [5]: [PATCH 5/6] KVM: arm64: Couple VNCR fixmap clearing and CPU =
number invalidation ---
commit 9f716e0407bd9a5d530b0e1d1e94c5434eaeedb6
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Couple VNCR fixmap clearing and CPU number invalidation

A mapped VNCR translation must indicate which CPU it is resident.
Unmapping such a translation must make this CPU number -1. Couple the unmap
and the setting to -1 in a helper, so that we are always sure they are done
together.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 69a4652f39336..8d5b0208ad728 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c

[ ... ]

> @@ -895,6 +895,12 @@ void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>  	}
>  }
> =20
> +static void unmap_l1_vncr(struct vncr_tlb *vt)
> +{
> +	clear_fixmap(vncr_fixmap(vt->cpu));
> +	vt->cpu =3D -1;
> +}
> +
>  static void this_cpu_reset_vncr_fixmap(struct kvm_vcpu *vcpu)
>  {
>  	if (!host_data_test_flag(L1_VNCR_MAPPED))
>  		return;

[Severity: Critical]
This is a pre-existing issue, but can a stale CPU ID be left in vt->cpu if=
=20
we return early here?

In kvm_map_l1_vncr(), vt->cpu is unconditionally set to smp_processor_id().
If the mapping has no read permissions (prot =3D=3D PAGE_NONE), the function
returns without mapping the fixmap or setting the L1_VNCR_MAPPED flag.

When the vCPU is later scheduled out, this_cpu_reset_vncr_fixmap() returns
early at this check because L1_VNCR_MAPPED is unset, failing to reset
vt->cpu to -1.

If the host later invalidates this vCPU's VNCR TLB, invalidate_vncr() reads
the stale CPU ID and maliciously clears the fixmap for that CPU. If another
vCPU is running on that CPU and using the fixmap slot, its VNCR mapping is
unexpectedly destroyed, leading to a host Data Abort when accessed.

>  	BUG_ON(vcpu->arch.vncr_tlb->cpu !=3D smp_processor_id());
>  	BUG_ON(is_hyp_ctxt(vcpu));
> =20
> -	clear_fixmap(vncr_fixmap(vcpu->arch.vncr_tlb->cpu));
> -	vcpu->arch.vncr_tlb->cpu =3D -1;
> +	unmap_l1_vncr(vcpu->arch.vncr_tlb);
>  	host_data_clear_flag(L1_VNCR_MAPPED);
>  }
> =20
> @@ -997,7 +1002,7 @@ static void invalidate_vncr(struct vncr_tlb *vt)
>  {
>  	vt->valid =3D false;
>  	if (vt->cpu !=3D -1)

[Severity: Critical]
This is a pre-existing issue, but does this check have a time-of-check to
time-of-use race?

In invalidate_vncr(), we check if vt->cpu !=3D -1 and then call
unmap_l1_vncr(vt), which evaluates vncr_fixmap(vt->cpu) internally.

Because this_cpu_reset_vncr_fixmap() is called from kvm_arch_vcpu_put()
without holding kvm->mmu_lock, it can run concurrently on the target vCPU's
host CPU and set vt->cpu =3D -1 exactly between the check and the use.

If that happens, unmap_l1_vncr() evaluates vncr_fixmap(-1), which triggers
BUG_ON(__c >=3D NR_CPUS) and panics the host.

> -		clear_fixmap(vncr_fixmap(vt->cpu));
> +		unmap_l1_vncr(vt);

[Severity: Critical]
Can this trigger a BUG_ON() when a remote vCPU is scheduled out?

By modifying invalidate_vncr() to call unmap_l1_vncr(), this path now
asynchronously sets vt->cpu =3D -1 when invalidating a remote vCPU's
VNCR TLB. However, the host CPU's L1_VNCR_MAPPED flag remains set on
the remote CPU.

When the remote vCPU is eventually scheduled out, it will execute the
lockless this_cpu_reset_vncr_fixmap():

    if (!host_data_test_flag(L1_VNCR_MAPPED))
        return;

    BUG_ON(vcpu->arch.vncr_tlb->cpu !=3D smp_processor_id());

Since L1_VNCR_MAPPED is still true, the code reaches the BUG_ON(), but
vt->cpu has been changed to -1, which deterministicly panics the host
kernel. A guest could trivially trigger this by issuing a TLBI from one
vCPU while another is running.

>  }
> =20
>  static bool vncr_tlb_intersects(struct vncr_tlb *vt, u64 addr,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801124818.3662=
74-1-maz@kernel.org?part=3D5
