Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCB9306746;
	Fri,  3 Jul 2026 16:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096708; cv=none; b=SxoRiDgkcN65xM8F5TegUQOA8St5TKrx7k2F9Kb9oj0gc211UUsNtZ4zTeQrmXwkjFE0UsqOSXDpPoYUFdtmzt4KDFDJA5s0H8r+LvD5oRIgravBR1fOPSaCCAIE1ScKHGzTDmRED6rrMybcxIwaP953I1H+u/Gh09KVw/W34mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096708; c=relaxed/simple;
	bh=EPPVs2MesMyQAowQA+Gt+hll23DUTdZYNhw2ft9A1F8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PV4cGavcr7/Ih1pJnU/I6P2ZARNckLtfibsTMaoQLBhiE/Ckf0VJ8mm+bpSaKSh841lFro+YT7NUqwxdhAuMtyTTI2oAVJ3yWjKQla1DDSV3cne8mhuUehy++OkgTF9XXYUf09NuGL+eTiDTBaZ1Oe9G9khe+eZgtIu9F+0JQjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n2KgqEvQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n2KgqEvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCD01F000E9;
	Fri,  3 Jul 2026 16:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096706;
	bh=LN3wTkOOuqoEbEpm1K3BZPd2Tvm7mBqvToD4SDzJujs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n2KgqEvQPLx7pzOSrfeh88uk1Y03EK0gEA3zWhoKQDKyUdM8zlXqPjzac0YomWFYb
	 oVB8wf2cIVayIos5kuaN9kYlwgrZRrTmAvMpLjS1Zy+foW3mbUuk+sYtlzon9dQaRA
	 ha1vIze1pqOO782FreHwzchQsN/rF36YmTc/wGMy+u/ihAoELSM8XOLuXahjDR83u2
	 QjRim6pEHa2wHxYfU1q5uy8h2WWG42yTpoAVnoKwe8xh9KrVu5+XJqySexZSITuV/b
	 vnXd57UaQHDIg1l8RzH2LKFvWq0JhQ2HX0J91RKis2B6Fum1UIMhApZS5nd87DWRbq
	 926Ml5PR4Vs+A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 20/40] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and
 MMIO emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260703154811.3355680-21-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-21-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:38:25 +0000
Message-Id: <20260703163825.CDCD01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] A TOCTOU race on `IRS_IST_CFGR` allows a malicious guest to by=
pass bounds validation and trigger uncontrolled memory allocation, causing =
host DoS.
- [High] Malicious guests can trigger unratelimited `kvm_err()` logs, causi=
ng a host-side denial of service.
- [High] KVM exposes raw physical host capabilities (`max_vpes`) to the gue=
st in `GICV5_IRS_IDR1` and enforces strict matching during migration, break=
ing live migration across disparate hardware.
- [Medium] KVM's software state for the LPI IST becomes permanently desynce=
d from hardware if `vgic_v5_lpi_ist_free` fails.
- [Low] `vgic_v5_vmte_vpe_id_bits()` performs a lockless XArray lookup (`xa=
_load()`) without holding the RCU read lock.
--

commit 7a55e9989e1e13c78d23d68127bb230d5b8f4f16
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation

This commit introduces an IODEV for the GICv5 IRS along with its MMIO=20
emulation and initialization functions. It enables the guest to query=20
IRS registers, configure SPIs, and allocate host-backed LPI ISTs.

> diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic=
-irs-v5.c
> index 0000000000000..20c13c582f710
> --- /dev/null
> +++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
[ ... ]
> @@ -53,8 +53,8 @@ static unsigned long vgic_v5_mmio_read_irs_misc(struct =
kvm_vcpu *vcpu,
>  	case GICV5_IRS_IDR1:
>  		value =3D FIELD_PREP(GICV5_IRS_IDR1_PE_CNT,
>  				   atomic_read(&vcpu->kvm->online_vcpus));
>  		/*
>  		 * IRS_IDR1 encodes IAFFID_BITS as N - 1.
>  		 */
>  		vpe_id_bits =3D fls(kvm_vgic_global_state.vgic_v5_irs_caps.max_vpes) -=
 1;

[Severity: High]
Is it intentional to synthesize the IAFFID_BITS directly from the host's
physical capacity rather than using a stored, migratable VM state?

If the guest is migrated to a host with different hardware capabilities,
the destination's restore path in vgic_v5_mmio_uaccess_write_irs()
strictly rejects the migrated state because it doesn't match the new
physical capacity. Can this break live migration across disparate hardware?

>  		value |=3D FIELD_PREP(GICV5_IRS_IDR1_IAFFID_BITS, vpe_id_bits - 1);
>  		value |=3D FIELD_PREP(GICV5_IRS_IDR1_PRIORITY_BITS, irs->idr1.priority=
_bits);
>  		break;
[ ... ]
> @@ -245,8 +245,8 @@ static unsigned long vgic_v5_mmio_read_irs_spi(struct=
 kvm_vcpu *vcpu,
>  		irq =3D vgic_get_irq(vcpu->kvm, vgic_v5_make_spi(irs->spi_selr.id));
>  		if (!irq) {
>  			kvm_err("Guest trying to access SPI not backed by KVM\n");

[Severity: High]
Could a malicious guest use this to flood the host logs and cause a denial
of service?

If a guest exploits a TOCTOU race by modifying IRS_SPI_SELR between the
bounds check and this lookup, vgic_get_irq() will return NULL, triggering
this unratelimited print.=20

>  			value =3D 0;
>  			break;
>  		}
[ ... ]
> @@ -288,8 +288,8 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vcp=
u *vcpu, gpa_t addr,
>  		/*
>  		 * ... free the host IST if we successfully marked the
>  		 * IST as invalid. Frankly, if we failed to make the
>  		 * guest's IST as invalid, we're cooked because it means
>  		 * that the IRS may still be using the memory that we
>  		 * want to free. Hence, we leave it allocated and skip
>  		 * the clearing of valid bit in the baser.
>  		 */
>  		rc =3D vgic_v5_lpi_ist_free(vcpu->kvm);
>  		if (rc)
>  			return rc;

[Severity: Medium]
Does returning early here leave the KVM software state permanently
desynchronized from the hardware?

If vgic_v5_lpi_ist_free() fails, we've successfully invalidated the hardware
IST via irq_set_vcpu_affinity(), but we skip vgic_v5_update_irs_ist_baser().
Because KVM still considers the software state valid, any future guest
attempt to re-enable it might evaluate as a no-op.

>  	} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
>  		if (!vgic_v5_ist_cfgr_valid(irs)) {
>  			kvm_err("Guest programmed invalid IRS_IST_CFGR\n");

[Severity: High]
Can a guest trigger this error message repeatedly?

Since the guest can directly write an invalid configuration to IRS_IST_CFGR
and then write valid=3D1 to IRS_IST_BASER, this unratelimited kvm_err() can
be used to flood the host logs.

>  			return -EINVAL;
>  		}
> =20
>  		rc =3D vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits);

[Severity: Critical]
Can a concurrent guest write to IRS_IST_CFGR cause KVM to allocate an
oversized IST?

The ist_cfgr fields are validated under config_lock, but the MMIO write
handler for IRS_IST_CFGR (vgic_v5_mmio_write_irs_ist) updates them
locklessly.

A guest could write a valid configuration, pass the
vgic_v5_ist_cfgr_valid() check, and immediately race on another vCPU to
overwrite irs->ist_cfgr.lpi_id_bits with a maximum value.

vgic_v5_lpi_ist_alloc() would then re-read the maliciously enlarged value,
leading to an uncontrolled memory allocation regression.

>  		if (rc)
>  			return rc;
[ ... ]
> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> index ce269ae7ff6f7..a3f817b82c44c 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
[ ... ]
> @@ -582,6 +582,22 @@ int vgic_v5_vmte_release(struct kvm *kvm)
>  /*
>   * Provide a way for the IRS MMIO emulation to correctly populate the nu=
mber of
>   * IAFFID bits (which correspond to our vpe_id_bits.
>   */
>  u8 vgic_v5_vmte_vpe_id_bits(struct kvm_vcpu *vcpu)
>  {
>  	u32 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
>  	struct vgic_v5_vm_info *vmi;
> =20
>  	vmi =3D xa_load(&vm_info, vm_id);

[Severity: Low]
Does this xa_load() lookup require RCU read protection?

It looks like this function calls xa_load() without holding the
rcu_read_lock(). Although this appears to be unused code right now, a
lockless lookup here could trigger a lockdep warning or use-after-free if
it gets called in the future.

>  	if (!vmi)
>  		return 0;
> =20
>  	return vmi->vpe_id_bits;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D20
