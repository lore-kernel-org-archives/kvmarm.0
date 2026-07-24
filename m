Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B456372EEC;
	Fri, 24 Jul 2026 11:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784893269; cv=none; b=FG5RbumVu09EKodTAqSSPjUHMW+4dw6VzC2nHs4SZ2m7HZQn9oYlty0ctHQx+z0FMf8DdEICtXohdRmPTSO2bXmoc1n8IEwsD3LVqa3mQpGuVHq/R8g/8h0+Vxm7gphBdzwpyRiCl301ownB2L3aUUd9UWTwde7leJOBHrpoWks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784893269; c=relaxed/simple;
	bh=pqiViVBACM9MgotgcmY+oSdjVk0wc8P/9c716bReasE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aNfKkMHLkKopZgzMCS+BAXGNXqHoaX7i/HmxpxNCSzeSF8aYeOUcKXEXvconJVCpk9pFNC8PRL9BdeoeJNIpguWWNxEOLLUbpU18Po0EM68PsjbcIH+8/ReR0YTe51e50c53JmUZ6LADLckh/+XI3Bz+VtCV5uUX3N7lRKUwGYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SNEQ+4Wd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SNEQ+4Wd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0161F000E9;
	Fri, 24 Jul 2026 11:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784893261;
	bh=bNjetqvIcV5XDAJADKa0adeOIkCAQYbhegw7n30LjcY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SNEQ+4Wdqz/cZfxiF9PcBDk0gevRsKRmM4WWebK2BmmNOYGvlPv72PMibkUBe5Dcf
	 KbsYiyh+pzdBa3xtkodXpmirsBZ1+vEIrbK9d8g117X+jWU6g0S4ceZR91zU6yjz2t
	 G6+LTkvYueAqqcwNUsLEYnUr+MOvFxv+N7cup4T2HWMWfSzo93XEReXwUjf1ymT+Ej
	 DcK+FlunA3xTGu9t29vJM/evAhaW9B+9XyZr8nuXEifCm2tD2u4j/vlpzOsShTjsDI
	 MMo7dEgNP0+jCnniXOFKVGRq5NonuVdFF4A0DcT7BffjaLyHhBivEVdFtv5Ivi7+8N
	 Vd9nSprGyI0oA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 23/48] KVM: arm64: gic-v5: Set IRICHPPIDIS based on
 IRS enable state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260724104819.1296803-24-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-24-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:41:00 +0000
Message-Id: <20260724114100.EF0161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Spurious VPE doorbells and infinite wakeup loops due to unpreserve=
d IRICHPPIDIS state.
- [Low] Missing READ_ONCE() on vgic.enabled causes a data race.
--

--- Patch [23]: [PATCH v4 23/48] KVM: arm64: gic-v5: Set IRICHPPIDIS based =
on IRS enable state ---
commit 40fbad6b3a2b1617d4bc4b16c3a6b176e7be5146
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable state

The GICv5 ICH_CONTEXTR_EL2 has the IRICHPPIDIS field, which allows the
hypervisor to enable/disable the HPPI selection for SPIs and
LPIs. This can be used to emulate the guest enabling/disabling the
IRS. Therefore, make the state of this controlled by the IRS enable
state. Thus, SPIs and LPIs can't be delivered to the guest, until it
enables the emulated IRS, which matches the behaviour of the real
hardware.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 4042d468431b1..7957b9da95e7c 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -1066,6 +1066,7 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)
> =20
>  void vgic_v5_load(struct kvm_vcpu *vcpu)
>  {
> +	bool irichppidis =3D !vcpu->kvm->arch.vgic.enabled;

[Severity: Low]
Is a READ_ONCE() missing here?

The vgic.enabled flag is updated concurrently by the IRS MMIO handler using
WRITE_ONCE(), so reading it locklessly here might trigger KCSAN data race
warnings.

>  	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
>  	u16 vm =3D vgic_v5_vm_id(vcpu->kvm);
>  	u16 vpe =3D vgic_v5_vpe_id(vcpu);
> @@ -1082,6 +1083,7 @@ void vgic_v5_load(struct kvm_vcpu *vcpu)
>  	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
> =20
>  	cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_V, true) |
> +				FIELD_PREP(ICH_CONTEXTR_EL2_IRICHPPIDIS, irichppidis) |

[Severity: High]
Will this IRICHPPIDIS state get lost when the VCPU enters WFI?

When the guest executes WFI, KVM calls vgic_v5_put(). It currently clears
vgic_contextr before setting the doorbell bits:

void vgic_v5_put(struct kvm_vcpu *vcpu)
{
	...
	cpu_if->vgic_contextr =3D 0;
	if (vcpu_get_flag(vcpu, IN_WFI)) {
		...
		cpu_if->vgic_contextr =3D FIELD_PREP(ICH_CONTEXTR_EL2_DB, 1) |
					FIELD_PREP(ICH_CONTEXTR_EL2_DBPM, dbpm);
	...
}

If the guest disabled the IRS (so IRICHPPIDIS should be 1) and enters WFI
while an SPI or LPI is pending, the hardware will see IRICHPPIDIS=3D0 and D=
B=3D1.

Could this cause the hardware to inadvertently evaluate the interrupt and f=
ire
the doorbell, waking the guest?

If the guest then resumes from WFI, sees no pending interrupts, and executes
WFI again, wouldn't this result in an infinite wakeup loop?

>  				FIELD_PREP(ICH_CONTEXTR_EL2_VPE, vpe) |
>  				FIELD_PREP(ICH_CONTEXTR_EL2_VM, vm);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D23
