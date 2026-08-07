Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6EC4734C5;
	Fri,  7 Aug 2026 13:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786108410; cv=none; b=kzeYPnWT92ii92vwsWhGOH79LHFJAnhpefrDsP39AFhKK94kTcrahiWO+l4AUBL0UkSPol+5C6fKxQgTh2ZimWRHMDCoy6ym0XXRckZIaF2TLlRmOybpukyE1j9JfERCGkOSQsDEgz1t5RAfsO3SsHq9UaBUZ29T9L34ECFLUMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786108410; c=relaxed/simple;
	bh=ABKfoMGHYY2A3zwIioqvBrECwauWhaNUA24Fw74y5qk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f3LM57c6cYwaVeKkZvJb8OAudTF9Y2A2SV6gXEv6p3Tn3A6i1SUrJVW2sm2pZG72Xd3tQM0Gd8LzKpST5r2ayjUY69hF1oWHPq8p4N0HcyMoxtOEcN/fpGB15SNYrNTiXlw+/Fk4trW2RGLTbRXs26VN3CMh4EQk6zZBMaUGIk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bLZ7blmQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bLZ7blmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7401F01559;
	Fri,  7 Aug 2026 13:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786108400;
	bh=RW7CrKTWFtA3nwTA78/d7gEtgW+9ytCXxzOkrIZTYIU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bLZ7blmQ//JDSVFwXnJoiSZ5rlC0JO4lhsIzn7IkQhD9C/3nHHECPC8AhYpMJekcc
	 cNl4vZQpWvtWl1bV6roazw7NOrlfet90R82qJkJQ+YfHBB3rb3V7/+95UJL2Pk6gkF
	 XAl39w59JBXKQBYmK4aBEoaQfhF47f6ZlwZ0u+7ZDPfJpmL2kjE5RKNMdDFVTPUGan
	 F2Wvh9/6/E7NS8u0Hp20rrDdlMLyy69exs8kkE/zhRzTJkYyY1e2nGgB41J7Nr1Jbp
	 BtVcr6XUA8w74Z0khmMSMS3JWB/tesgoj+qofpC3b8YScVPv+vylP/Is8UC2u8m5cN
	 q4pOc9gznGKbA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 11/49] KVM: arm64: gic-v5: Implement VMT/vIST IRS
 MMIO Ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260807111159.429128-12-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-12-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 13:13:19 +0000
Message-Id: <20260807131320.7B7401F01559@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Unconditional NULL pointer dereference in `vgic_v5_alloc_l2_vmt` w=
hen the VM has zero vCPUs.
- [High] Hardware Use-After-Free (UAF) when IST validation times out.
- [High] GICv5 probe permanently aborts on kexec if the previous kernel lef=
t the VMT_BASER register valid.
- [High] Missing bounds check on `max_vpe_id` allows userspace to program o=
ut-of-bounds `vpe_id_bits` into hardware.
- [Low] Mixing goto-based error handling with scoped_guard() violates the c=
leanup subsystem guidelines.
--

--- Patch [11]: [PATCH v5 11/49] KVM: arm64: gic-v5: Implement VMT/vIST IRS=
 MMIO Ops ---
commit 47ef012a3a648a37c053cce44ccc9973a562fddf
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
   =20
This commit adds support for making GICv5 VM and IST tables valid via
the IRS MMIO interface. It introduces functions to interact with IRS
hardware and manage VM/IST validity.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
[ ... ]
> @@ -785,8 +793,16 @@ static int vgic_v5_vmte_assign_ist(struct kvm *kvm, =
phys_addr_t ist_base,
>  	/* Finally, mark the entry as valid */
>  	cmd =3D spi_ist ? SPI_VIST_MAKE_VALID : LPI_VIST_MAKE_VALID;
>  	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);

[Severity: High]
Can this result in a null pointer dereference if the VM has zero vCPUs?

The vcpu0 pointer is retrieved via kvm_get_vcpu(kvm, 0), which can return
null if kvm->online_vcpus =3D=3D 0. Unconditionally passing vcpu0 to
vgic_v5_vpe_db() here, and similarly in vgic_v5_alloc_l2_vmt(), seems like
it could trigger a host crash if invoked by KVM initialization ioctls before
any vCPUs are created.

> +	if (ret) {
> +		scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
> +			WRITE_ONCE(vmte->val[section], 0ULL);
> +			vgic_v5_clean_inval(vmte, sizeof(*vmte));
> +		}
> =20
> -	return ret;
> +		return ret;

[Severity: High]
Could this lead to a hardware use-after-free if the validation command times
out?
   =20
If the MMIO command sent in vgic_v5_vmte_assign_ist() times out, it returns
an error here. Callers like vgic_v5_spi_ist_alloc() and
vgic_v5_lpi_ist_alloc() will react by freeing the IST memory:

arch/arm64/kvm/vgic/vgic-v5-tables.c:vgic_v5_spi_ist_alloc() {
    ...
    if (ret) {
        vgic_v5_free_allocated_spi_ist(kvm);
        return ret;
    }
    ...
}
   =20
Since there is no SPI_VIST_MAKE_INVALID command, freeing this memory while
the hardware is still processing the command (or caching the memory pointer)
might corrupt host memory. Should KVM intentionally leak the memory on
timeout instead?

> +	}
> +
> +	return 0;
>  }
> =20
>  /*
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> @@ -83,13 +102,52 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
>  	vgic_v5_irs_cache_id_regs(info);
>  	vgic_v5_get_implemented_ppis();
> =20
[ ... ]
> +	ret =3D vgic_v5_irs_assign_vmt(vgic_v5_irs_two_level_vmt_support(&irs_c=
aps),
> +				     ilog2(vgic_v5_irs_max_vms(&irs_caps)),
> +				     vgic_v5_get_vmt_base());
> +	if (ret) {
> +		kvm_err("Failed to assign the GICv5 VM tables to the IRS; no GICv5 sup=
port\n");
> +		if (!vgic_v5_irs_clear_vmt())
> +			vgic_v5_vmt_free();
> +		return -ENODEV;
> +	}

[Severity: High]
Will this permanently abort the GICv5 probe across kexec?

If booting via kexec while a VM was running in the previous kernel, the
hardware VMT_BASER register retains its valid state. When this occurs,
vgic_v5_irs_assign_vmt() unconditionally returns -EBUSY:

arch/arm64/kvm/vgic/vgic-v5.c:vgic_v5_irs_assign_vmt() {
    ...
    vmt_baser =3D irs_readq_relaxed(GICV5_IRS_VMT_BASER);
    if (!!FIELD_GET(GICV5_IRS_VMT_BASER_VALID, vmt_baser))
        return -EBUSY;
    ...
}

This error path clears the stale state using vgic_v5_irs_clear_vmt(), but
then returns -ENODEV. Should the probe retry the assignment instead of
failing entirely?

[ ... ]

While reviewing the VM table setup, I also noticed a few potential regressi=
ons
in vgic_v5_vmte_init():

arch/arm64/kvm/vgic/vgic-v5-tables.c:vgic_v5_vmte_init() {
    ...
    kvm_for_each_vcpu(i, vcpu, kvm) {
        u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
        if (vpe_id > max_vpe_id)
            max_vpe_id =3D vpe_id;
    }

    nr_cpus =3D max(2UL, roundup_pow_of_two(max_vpe_id + 1));
    vmi->vpe_id_bits =3D fls(nr_cpus) - 1;
    ...
    tmp |=3D FIELD_PREP(GICV5_VMTEL2E_VPE_ID_BITS, vmi->vpe_id_bits);
    vmte_val1 =3D tmp;
    ...
}

[Severity: High]
Is there a missing bounds check on max_vpe_id here?

The function verifies the total number of online vCPUs against hardware
limits, but calculates the hardware configuration based on the maximum spar=
se
vcpu_id. Since KVM allows sparse IDs up to KVM_MAX_VCPU_IDS, an unprivileged
userspace could create a single vCPU with a large ID.

This allows calculating an oversized vpe_id_bits and writing it directly to
the VMTE, exposing a configuration to the hardware that exceeds its support=
ed
capabilities. Should max_vpe_id be checked against vmt_info->max_vpes?

Additionally, in the same function:

arch/arm64/kvm/vgic/vgic-v5-tables.c:vgic_v5_vmte_init() {
    ...
    scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
        WRITE_ONCE(vmte->val[0], cpu_to_le64(vmte_val0));
        ...
    }
    ...
out_fail:
    kfree(vmd);
    ...
}

[Severity: Low]
Does this mix goto-based error handling with scoped_guard()?

According to the cleanup subsystem guidelines, if a function uses guard() or
scoped_guard(), all resources should be converted to scope-based cleanup,
avoiding mixed usage with goto-based cleanup labels.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D11
