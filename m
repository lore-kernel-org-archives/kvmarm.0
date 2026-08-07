Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AC62DECA8;
	Fri,  7 Aug 2026 14:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113267; cv=none; b=L/PV9qWE9VwFTFmYOlCAEo7KbgTDNaqSZpZuSryd+CTdOE/fC+PbZzSiXuR4lxBzgP1ZkEs6iLE04uCVi3qyISSyj3cbMba+gLtd8Pz23puFlshXJRvE5ZFIIvz/DTscXKWYlE9mqI9nGyf+DfXfAcgWqh4scEGG2abH05WB6JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113267; c=relaxed/simple;
	bh=8kcNWq1VTjZC8p6pufdQSE+3T+dtZEmsZypb0Ts2OTg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NYVdf3q44B8iOVQaeXvBl8EAsip0jsNEqqeQJS8nKf2GZLfR9o+LBMTvHSpWNC2Iv0NDvmnsdWk2Ah/zqBrJIhHYsrgDa88e+g6G//MGdz3QA2xlBI52alDYky0Okv7yhBk5PGc86K1nR375XJIioOmEd44k8a1BSwwzZibfLYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6hRRqMS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6hRRqMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88601F000E9;
	Fri,  7 Aug 2026 14:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786113266;
	bh=mg8jozuJ4mGuaqwdetZysxm1dFkPC+qt5GI6D66OP8Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S6hRRqMSjUYRmjXOX68GPPZn3Sc2cPFybCbdmADrQobZyJ3GCN9/gEQijMPb8XUUY
	 m7Qe5rvqFTDDTAGoQPR+GTxlHPG+Q0gXhSnefe+Io6k6AqrHsPQuY2bSlV9Y5Kqhv9
	 F1xxquMS9fwziCOQKaY7Ueqgvuf7Aul90OPMAC8/l/MoA64i35Ytelzm5mIwcfGCO9
	 hDpFm9c7JizrgBkDBrtTW8IHOsKVVdlXuahU08NoWWzpakHwFSqLwCTi5lWT+ikTcl
	 GAuDh+/Ii827lhof7SD/rPUA5pTN4L8TXa9AOSoj+abWWs2jpmVh75cQ4cBLFSIjHq
	 Q6VFk8glWPBfw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 20/49] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and
 MMIO emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807111159.429128-21-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-21-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 14:34:25 +0000
Message-Id: <20260807143425.E88601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] 64-bit IRS MMIO registers lack support for 32-bit accesses, leadin=
g to unhandled MMIO aborts and broken read-modify-write behavior.
- [Medium] Missing locking in the IRS IST MMIO read handler allows guests t=
o observe logically torn register states.
- [Medium] Lockless, sequential updates to GICV5_IRS_CR1 can result in a to=
rn MMIO write.
--

--- Patch [20]: [PATCH v5 20/49] KVM: arm64: gic-v5: Add GICv5 IRS IODEV an=
d MMIO emulation ---
commit e3d747ac0ec8b60b894092ad4f2dc0c7959423ef
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation
   =20
In order to properly support GICv5-based VMs in KVM, emulate the
CONFIG_FRAME for a virtual IRS. This emulation needs to handle guest
accesses to the MMIO region and mimic the behaviour of a real IRS.

> diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic=
-irs-v5.c
> new file mode 100644
> index 0000000000000..c6280795ab551
> --- /dev/null
> +++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c

[ ... ]

> @@ -0,0 +1,765 @@
[ ... ]
> +static void vgic_v5_mmio_write_irs_misc(struct kvm_vcpu *vcpu, gpa_t add=
r,
> +					unsigned int len, unsigned long val)
> +{
> +	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
> +	struct vgic_dist *vgic =3D vgic_v5_get_vgic(vcpu);
> +	const size_t offset =3D addr & (SZ_64K - 1);
> +
> +	switch (offset) {
[ ... ]
> +	case GICV5_IRS_CR1:
> +		irs->cr1.sh =3D FIELD_GET(GICV5_IRS_CR1_SH, val);
> +		irs->cr1.oc =3D FIELD_GET(GICV5_IRS_CR1_OC, val);
> +		irs->cr1.ic =3D FIELD_GET(GICV5_IRS_CR1_IC, val);
> +		irs->cr1.ist_ra =3D !!(val & GICV5_IRS_CR1_IST_RA);
> +		irs->cr1.ist_wa =3D !!(val & GICV5_IRS_CR1_IST_WA);
> +		irs->cr1.vmt_ra =3D !!(val & GICV5_IRS_CR1_VMT_RA);
> +		irs->cr1.vpet_ra =3D !!(val & GICV5_IRS_CR1_VPET_RA);
> +		irs->cr1.vmd_ra =3D !!(val & GICV5_IRS_CR1_VMD_RA);
> +		irs->cr1.vmd_wa =3D !!(val & GICV5_IRS_CR1_VMD_WA);
> +		irs->cr1.vped_ra =3D !!(val & GICV5_IRS_CR1_VPED_RA);
> +		irs->cr1.vped_wa =3D !!(val & GICV5_IRS_CR1_VPED_WA);
> +		return;

[Severity: Medium]
Since these sequential writes are performed without holding config_lock,
is there a risk of data races? If multiple vCPUs concurrently write
different values to GICV5_IRS_CR1, it seems like the internal KVM state
for irs->cr1 could end up in a torn state combining the concurrent writes.

[ ... ]

> +static unsigned long vgic_v5_mmio_read_irs_ist(struct kvm_vcpu *vcpu,
> +					       gpa_t addr, unsigned int len)
> +{
> +	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
> +	const size_t offset =3D addr & (SZ_64K - 1);
> +	u64 value =3D 0;
> +
> +	switch (offset) {
[ ... ]
> +	case GICV5_IRS_IST_BASER:
> +		value =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
> +				   irs->ist_baser.addr >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
> +		if (irs->ist_baser.valid)
> +			value |=3D GICV5_IRS_IST_BASER_VALID;
> +		break;

[Severity: Medium]
Can guests observe logically torn register states here? The write handler
vgic_v5_mmio_write_irs_ist() correctly holds config_lock to sequentially
update irs->ist_baser.valid and irs->ist_baser.addr, but this read
handler accesses them locklessly. If a vCPU reads GICV5_IRS_IST_BASER
concurrently with a write, it could see an impossible state combining the
old address with the new valid bit or vice-versa.

[ ... ]

> +static void vgic_v5_mmio_write_irs_ist(struct kvm_vcpu *vcpu, gpa_t addr,
> +				       unsigned int len, unsigned long val)
> +{
> +	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
> +	const size_t offset =3D addr & (SZ_64K - 1);
> +	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
> +
> +	switch (offset) {
[ ... ]
> +	case GICV5_IRS_IST_BASER: {

[Severity: High]
Does this strict matching on exact offsets break read-modify-write for
32-bit accesses to the high half of the register? If a guest performs a
32-bit write to offset + 4, it looks like this switch statement drops it.
Also, interpreting a 32-bit payload as a full 64-bit value without
adjusting for the offset would corrupt the register state.

[ ... ]

> +static const struct vgic_register_region vgic_v5_irs_registers[] =3D {
[ ... ]
> +	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_is=
t,
> +				  vgic_v5_mmio_write_irs_ist, 8,
> +				  VGIC_ACCESS_64bit),

[Severity: High]
Could omitting VGIC_ACCESS_32bit for this 64-bit register cause the KVM
IO bus to reject valid 32-bit guest accesses? If KVM's mmio dispatcher
rejects a 32-bit access, the request will fall back to userspace IO. Since
userspace does not emulate the in-kernel IRS, this usually results in an
unhandled data abort injected into the guest.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D20
