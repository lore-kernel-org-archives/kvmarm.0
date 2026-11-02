Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793650994;
	b=2b+RtAFj53doftKJjkkq7vs0h7K17qPcVdWnO+wkNfEHfTHoQ2G/+c7ED0TolVjHMwZz
	 pDFAsSLhsATej1ByXouktob2ACZARfcMDGF6DdO/5nbaKoZaZW/KYfCy0msYNehyv6D7j
	 ShLDyQeM+jLzBCh3j6nTiX94lFUqhB99e3x61hcbdMjMGBIWl5D0pSxMwcQ1jHcCa5rCR
	 nolzoOzESJpK1EDBjJJEChy9UPIiaB7FkCHkqIdn8P4/oICiQ4VwX6pygtDtAhe6wOVxA
	 vvbovSY8ItUw2cP2Md8xf/2rlKsEAXS8SQGJNpOSu3+d9w6Z/QrFR9zADNo4hGZctFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793650994;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Hpvg0OIDIp+QrQZ1vdkITYgeyn4m69nTA45GpchRF1A=;
	b=1B4xx8EsWS8/quWsBNZ9lJjM6FAR4Di3PcWbbZ6YNyRBz6667xFQjEYK8lWo3/2Kv1Pn
	 e0sw/aXGPwzMoECXG9ljzkbVSDFzpP3M6rzJF4xY99JkGYSHX1ULg9DzlfDxL6iAwb/D9
	 IVemlP6xoB3nUu8Kdje9JtIAD0NjCUlAksnbCfCq7VZE5+U4udBmDtAdPzRNajtEsdoUp
	 wmqsBKyP38fRSx0nKMvIzhP6OElID3MpNAjP+7R4p7Zh8byIMC+T+gBguJZISJj21Jn7f
	 zhVILxqLaYCrO/KkMQgvp2Zl5OO+lzgEFtqJ1qSznECKHVawjcVKBuDzHWTw72A/lZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eNrDoPuf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5649C606D815;
	Mon,  2 Nov 2026 20:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eNrDoPuf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6311F00A1E;
	Mon,  2 Nov 2026 20:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793650993;
	bh=Hpvg0OIDIp+QrQZ1vdkITYgeyn4m69nTA45GpchRF1A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eNrDoPufnAkpNkp1KiXVeS9LpQd8u4Woeeqzzk+oC+8t/Eis3hT6Bx8pxJi+9S9ku
	 kiaJ7lnbLyP79//RT/5U3RqZ0GlZZFwe0c/JNf9EnmPOT/tNnqewBMK8yZM2ygVq8F
	 ykIbCIL762P210wfdO2ezoyTbAvb+VmBk9576986GE1ssdfu8rPCQFyHKk2ncbVmy6
	 9J7WKB5fxEMnYyHY8Xnvm+4sVEETlA//x8kIfmyhGXh4n47s400Jp/BcqeOGurAVE0
	 jUxyOqOGbYPILYlcuzaXhMd2Z0OctC2yJhf1O/3p0len2IHAnZkJXZBKpDllBInB6v
	 Lf4nEfOQq/kFQ==
Message-ID: <sashiko-outbox-194102@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/16] KVM: arm64: gic-v5: Add ITS guest table
 translation emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102194454.4086911-8-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-8-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 20:23:13 +0000
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
- [Critical] KVM: arm64: gic-v5: missing vgic init check in __vgic_v5_its_r=
esolve_lpi()
- [Low] KVM: arm64: gic-v5: unclamped event_id_bits in __vgic_v5_its_resolv=
e_lpi()
- [Low] KVM: arm64: gic-v5: duplicated L2SZ decoding in parse_two_level_itt=
()
--

commit 48d54735882d147618fe3ac1bc65671388c7716f
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: gic-v5: Add ITS guest table translation emulation

This commit adds helpers to walk linear and two-level guest Device Tables
and Interrupt Translation Tables for GICv5 ITS emulation, resolving
DeviceID/EventID pairs to LPIs and wiring up the READ_EVENTR and
GEN_EVENTR MMIO handlers.

> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic=
-its-v5.c
> index f04161c315b78..caa68c4680d02 100644
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
> @@ -19,6 +19,302 @@
>  #define VITS_V5_DEVICE_ID_BITS		16
>  #define VITS_V5_EVENT_ID_BITS		16
> =20
> +static int parse_linear_dt(struct kvm *kvm, gpa_t dt_base, u32 device_id,
> +			   gpa_t *itt_base, bool *two_level_itt,
> +			   unsigned int *event_id_bits, unsigned int *itt_l2sz)
> +{
> +	__le64 dt_l2_entry;
> +	gpa_t entry_addr;
> +	u64 val;
> +	int ret;
> +
> +	entry_addr =3D dt_base + device_id * sizeof(__le64);
> +	ret =3D kvm_read_guest_lock(kvm, entry_addr, &dt_l2_entry,
> +				  sizeof(dt_l2_entry));
> +	if (ret) {
> +		kvm_debug("Failed to read guest memory for L2 DT\n");
> +		return ret;
> +	}
> +
> +	val =3D le64_to_cpu(dt_l2_entry);
> +	if (!FIELD_GET(GICV5_DTL2E_VALID, val)) {
> +		kvm_debug("Guest DT entry is invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	*itt_base =3D FIELD_GET(GICV5_DTL2E_ITT_ADDR_MASK, val) << 3;
> +	*two_level_itt =3D FIELD_GET(GICV5_DTL2E_ITT_STRUCTURE, val);
> +	*event_id_bits =3D FIELD_GET(GICV5_DTL2E_EVENT_ID_BITS, val);
> +	*itt_l2sz =3D FIELD_GET(GICV5_DTL2E_ITT_L2SZ, val);
> +
> +	return 0;
> +}
> +
> +static int parse_two_level_dt(struct kvm *kvm, gpa_t dt_base,
> +			      unsigned int dt_l2sz, u32 device_id,
> +			      gpa_t *itt_base, bool *two_level_itt,
> +			      unsigned int *event_id_bits,
> +			      unsigned int *itt_l2sz)
> +{
> +	unsigned int device_id_l1_shift, l2_device_id;
> +	__le64 dt_l1_entry;
> +	gpa_t dt_l2_base;
> +	gpa_t entry_addr;
> +	u64 val;
> +	int ret;
> +
> +	switch (dt_l2sz) {
> +	case 0:
> +		device_id_l1_shift =3D 9;
> +		break;
> +	case 1:
> +		device_id_l1_shift =3D 11;
> +		break;
> +	case 2:
> +		device_id_l1_shift =3D 13;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	entry_addr =3D dt_base +
> +		     (device_id >> device_id_l1_shift) * sizeof(__le64);
> +
> +	ret =3D kvm_read_guest_lock(kvm, entry_addr, &dt_l1_entry,
> +				  sizeof(dt_l1_entry));
> +	if (ret) {
> +		kvm_debug("Failed to read guest memory for L1 DT\n");
> +		return ret;
> +	}
> +
> +	val =3D le64_to_cpu(dt_l1_entry);
> +	if (!FIELD_GET(GICV5_DTL1E_VALID, val)) {
> +		kvm_debug("Guest DT L1 entry is invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	dt_l2_base =3D FIELD_GET(GICV5_DTL1E_L2_ADDR_MASK, val) << 3;
> +	l2_device_id =3D device_id % (1UL << device_id_l1_shift);
> +	if (l2_device_id >=3D (1UL << FIELD_GET(GICV5_DTL1E_SPAN, val))) {
> +		kvm_debug("DeviceID 0x%x out of range of guest DT\n",
> +			  device_id);
> +		return -ENXIO;
> +	}
> +
> +	return parse_linear_dt(kvm, dt_l2_base, l2_device_id, itt_base,
> +			       two_level_itt, event_id_bits, itt_l2sz);
> +}

[ ... ]

> +static int parse_two_level_itt(struct kvm *kvm, u32 event_id, gpa_t itt_=
base,
> +			       unsigned int itt_l2sz, __le64 *itt_l2_entry)
> +{
> +	unsigned int itt_split_bits, l2_event_id_bits;
> +	gpa_t itt_l2_base, entry_addr;
> +	u32 l1_event_id, l2_event_id;
> +	__le64 itt_l1_entry;
> +	u64 val;
> +	int ret;
> +
> +	switch (itt_l2sz) {
> +	case 0:
> +		itt_split_bits =3D 9;
> +		break;
> +	case 1:
> +		itt_split_bits =3D 11;
> +		break;
> +	case 2:
> +		itt_split_bits =3D 13;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	l1_event_id =3D event_id >> itt_split_bits;
> +	entry_addr =3D itt_base + l1_event_id * sizeof(itt_l1_entry);
> +	ret =3D kvm_read_guest_lock(kvm, entry_addr, &itt_l1_entry,
> +				  sizeof(itt_l1_entry));
> +	if (ret) {
> +		kvm_debug("Failed to read guest memory for L1 ITT\n");
> +		return ret;
> +	}
> +
> +	val =3D le64_to_cpu(itt_l1_entry);
> +	if (!FIELD_GET(GICV5_ITTL1E_VALID, val)) {
> +		kvm_debug("Guest ITT L1 entry is invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	itt_l2_base =3D FIELD_GET(GICV5_ITTL1E_L2_ADDR_MASK, val) << 3;
> +	l2_event_id_bits =3D
> +		min(FIELD_GET(GICV5_ITTL1E_SPAN, val), itt_split_bits);
> +	l2_event_id =3D event_id % (1UL << l2_event_id_bits);
> +
> +	if ((itt_split_bits !=3D l2_event_id_bits) &&
> +	    (event_id & ((1UL << itt_split_bits) - 1)) !=3D l2_event_id) {
> +		kvm_debug("EventID is out of range of L2 ITT\n");
> +		return -ENXIO;
> +	}
> +
> +	return parse_linear_itt(kvm, l2_event_id, itt_l2_base, itt_l2_entry);
> +}

[Severity: Low]
This isn't a bug, but both parse_two_level_dt() and parse_two_level_itt()
duplicate the same switch statement mapping L2SZ encodings (0, 1, 2) to bit
shifts (9, 11, 13).

For validating the L2 index against the L1 entry's SPAN field,
parse_two_level_dt() computes l2_device_id =3D device_id % (1UL <<
device_id_l1_shift) and directly checks l2_device_id >=3D (1UL <<
FIELD_GET(GICV5_DTL1E_SPAN, val)), whereas parse_two_level_itt() clamps
l2_event_id_bits with min() and compares (event_id & ((1UL << itt_split_bit=
s)
- 1)) against l2_event_id.

Could the L2SZ-to-shift conversion be factored into a small helper, and cou=
ld
parse_two_level_itt() use the same direct SPAN bounds check as
parse_two_level_dt()?

[ ... ]

> +static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its=
 *its,
> +				     u32 device_id, u16 event_id,
> +				     struct vgic_irq **irq)
> +{
> +	unsigned int itt_l2sz, event_id_bits;
> +	__le64 itt_l2_entry;
> +	bool two_level_itt;
> +	gpa_t itt_base;
> +	u32 lpi;
> +	u64 val;
> +	int ret;
> +
> +	lockdep_assert_held(&its->its_lock);
> +
> +	if (!its->enabled) {
> +		kvm_debug("Cannot look up LPI; vITS is disabled\n");
> +		return -ENXIO;
> +	}
> +
> +	if (WARN_ON_ONCE(kvm->mm !=3D get_current()->mm))
> +		return -EWOULDBLOCK;
> +
> +	ret =3D get_itt(kvm, its, device_id, &itt_base, &two_level_itt,
> +		      &event_id_bits, &itt_l2sz);
> +	if (ret) {
> +		kvm_debug("Error parsing guest's DT\n");
> +		return ret;
> +	}
> +
> +	if (event_id >=3D 1UL << event_id_bits) {
> +		kvm_debug("Event ID out of range\n");
> +		return -E2BIG;
> +	}

[Severity: Low]
In get_itt(), the guest-configured DeviceID width is clamped to the maximum
supported by the ITS in IDR1 via min(its->dt_cfgr.device_id_bits,
its->idr1.device_id_bits).

In parse_linear_dt(), *event_id_bits =3D FIELD_GET(GICV5_DTL2E_EVENT_ID_BIT=
S,
val) extracts the 5-bit EVENT_ID_BITS field (0..31) from the guest DTL2E, a=
nd
__vgic_v5_its_resolve_lpi() checks event_id >=3D 1UL << event_id_bits witho=
ut
clamping event_id_bits to or validating it against its->idr2.event_id_bits.

This rests on a GICv5 architectural detail that could not be confirmed from
the kernel source: when GICV5_DTL2E_EVENT_ID_BITS exceeds
GICV5_ITS_IDR2_EVENTID_BITS, does the architecture require clamping the
effective EventID width to ITS_IDR2.EVENTID_BITS or treating the DTL2E as
invalid? If yes, parse_linear_dt() and __vgic_v5_its_resolve_lpi() will acc=
ept
an oversized DTL2E.EVENT_ID_BITS without capping or rejecting it when
its->idr2.event_id_bits is smaller than DTL2E.EVENT_ID_BITS.

> +
> +	ret =3D get_itte(kvm, event_id, itt_base, two_level_itt, itt_l2sz,
> +		       &itt_l2_entry);
> +	if (ret)
> +		return ret;
> +
> +	val =3D le64_to_cpu(itt_l2_entry);
> +	if (!FIELD_GET(GICV5_ITTL2E_VALID, val)) {
> +		kvm_debug("ITTE is not valid\n");
> +		return -EINVAL;
> +	}
> +
> +	lpi =3D FIELD_GET(GICV5_ITTL2E_LPI_ID, val);
> +
> +	*irq =3D vgic_add_lpi(kvm, vgic_v5_make_lpi(lpi), NULL);
> +	if (IS_ERR(*irq))
> +		return PTR_ERR(*irq);
> +
> +	return 0;
> +}
> +
> +static void vgic_v5_its_inject_lpi(struct kvm *kvm, struct vgic_irq *irq)
> +{
> +	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, true,
> +		     kvm->arch.vgic.gicv5_vm.vm_id);
> +}

[Severity: Critical]
What happens if userspace creates a KVM_DEV_TYPE_ARM_VGIC_V5_ITS device, se=
ts
KVM_VGIC_V5_ADDR_TYPE_ITS, and runs a vCPU without ever creating a
KVM_DEV_TYPE_ARM_VGIC_V5 irqchip device?

In vgic_v5_its_create(), creating the ITS device is permitted when
irqchip_in_kernel(dev->kvm) is false:

arch/arm64/kvm/vgic/vgic-its-v5.c:vgic_v5_its_create() {
	...
	if ((irqchip_in_kernel(dev->kvm) && !vgic_is_v5(dev->kvm)) ||
	    (dev->kvm->arch.vgic.its_model &&
	     dev->kvm->arch.vgic.its_model !=3D KVM_DEV_TYPE_ARM_VGIC_V5)) {
		kfree(its);
		return -ENODEV;
	}
	...
}

Setting KVM_VGIC_V5_ADDR_TYPE_ITS via vgic_v5_its_set_attr() immediately
registers the ITS MMIO device on KVM_MMIO_BUS via
vgic_v5_register_its_iodev(). When userspace runs a vCPU via KVM_RUN,
kvm_arch_vcpu_run_pid_change() only calls kvm_vgic_map_resources(kvm) when
irqchip_in_kernel(kvm) is true:

arch/arm64/kvm/arm.c:kvm_arch_vcpu_run_pid_change() {
	...
	if (likely(irqchip_in_kernel(kvm))) {
		/*
		 * Map the VGIC hardware resources before running a vcpu the
		 * first time on this VM.
		 */
		ret =3D kvm_vgic_map_resources(kvm);
		if (ret)
			return ret;
	}
	...
}

Because kvm_vgic_create() was never called to initialize
kvm->arch.vgic.gicv5_vm.vm_id to VGIC_V5_VM_ID_INVAL (and
vgic_v5_allocate_vm_id() was never called), kvm->arch.vgic.gicv5_vm.vm_id
remains 0 from the zero-initialized struct kvm allocation.

When the guest enables the vITS via GICV5_ITS_CR0 and writes
GICV5_ITS_GEN_EVENTR_R to GICV5_ITS_GEN_EVENTR,
vgic_v5_its_handle_gen_event() calls __vgic_v5_its_resolve_lpi() and
vgic_v5_its_inject_lpi(). Neither function checks vgic_initialized(kvm) or
vgic_has_its(kvm), so __vgic_v5_its_resolve_lpi() allocates LPIs in lpi_xa =
and
vgic_v5_its_inject_lpi() executes kvm_call_hyp(__vgic_v5_vdpend, irq->intid,
true, kvm->arch.vgic.gicv5_vm.vm_id) with vm_id =3D=3D 0.

Since vgic_v5_allocate_vm_id() allocates valid hardware VM IDs from
vmt_info->vm_id_ida starting at 0, won't the EL2 VDPEND instruction inject
guest-controlled LPIs directly into whichever active GICv5 VM on the host o=
wns
hardware VM ID 0? Should __vgic_v5_its_resolve_lpi() (or vgic_v5_its_create=
())
verify that the in-kernel GICv5 irqchip is initialized before resolving and
injecting LPIs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102194454.4086=
911-1-sascha.bischoff@arm.com?part=3D7
