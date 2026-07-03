Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9422330AAA6;
	Fri,  3 Jul 2026 16:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096997; cv=none; b=JFfWDLwMP6vb1m6833JG+Eo6aFUGWwsxhT37Odh36e4LCrgkioIm7tPyEXpgiscHDh5gtYsH/R7LsfF/6Z5gi+Fdmx1cWCYsdfiXerrpqPQ9eG4LNlm5ozUwjRj/aDFPeY8JqiFvesKhMaOT48Uj5DO1dX5naPyxMPwFo44D/vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096997; c=relaxed/simple;
	bh=kXXXJncf3EzfgeIfDHwNHs9n0kdixSi5OghbcoxpFT0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=b9kh2OVghix/oq0uIzimOHzlZbUW22Qe+CHc9hZe7sIwNc/LEneWMEpuNIQLam/+2gihGepvvSHas9ddyji3/9SwhdjbPNzmHWCxBAaVY/KEA/71nhnviYazy9n4tzldxKaS48H9oEJ+vJ473pzwZkwICRaxfyuA2Jspa5MMq+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mRaBZF1o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRaBZF1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50471F000E9;
	Fri,  3 Jul 2026 16:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096995;
	bh=JqWTnfWBxYRnDPcPkXCp1RqD9i7JJdMx/tqwzDSH3dM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mRaBZF1oW+r4NjNjogyiJmBk+vu9Iqwm63np7ZYfEhCAwM5QlkKd0PA5w+XcrrNSY
	 BglEDoD3qh8LWZnMvpNQCOW0rG7m3hvdamEDtdYfynnYK6gb4vfnJZVoJsm9Y8Wylg
	 rR4+xgU3QjxrQ4NSaPbkF+s37FL2qXo1hjY9bKyj3xJ7M1nA9X2Hpgz2fQQjmuMz3F
	 gi8FgKbpFqAxbd181yObu7MUYspsSqaKnSCWFzrE/+PgZT4ApNMjlb1H5TGNznBTkK
	 4GTwKh7e6Nf/IqFJval6iyfimiKGWH2yJhLk/frAuAI+p7M7H01y4a1TGrw71ClMqT
	 EmEj+YqcJZj3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 36/40] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260703154811.3355680-37-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-37-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:43:14 +0000
Message-Id: <20260703164314.C50471F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] Blindly freeing LPI IST pages and directly modifying active VMTE m=
emory on a failed restore cleanup.
- [High] No mechanism to un-quiesce the VM after a cancelled migration, per=
manently bricking the guest.
- [High] Restoring LPI IST processes INTIDs < 8192, injecting invalid inter=
rupts into the hardware.
- [High] Unprivileged userspace can trigger WARN_ON_ONCE kernel warnings by=
 calling IST save/restore ioctls at unexpected lifecycle states.
- [Medium] Truncation of 64-bit VMTE bitwise AND result into 32-bit `int` i=
ncorrectly flags valid ISTs as invalid.
--

commit b7ddc5cb1b3a60a4389e44b1be34dab0a54a57d5
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs

This patch implements save and restore mechanisms for the GICv5 Interrupt
State Tables (ISTs). It allocates and synchronizes hypervisor memory for the
SPI IST and guest memory for the LPI IST during migration. It also handles
quiescing the VM and managing pending interrupts during the transition.

> diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic=
-irs-v5.c
> --- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
[ ... ]
> @@ -1027,6 +1027,26 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned=
 int nr_spis)
>  	return 0;
>  }
> =20
> +int vgic_v5_irs_lpi_ist_id_bits(struct kvm *kvm, unsigned int *id_bits)
> +{
> +	struct vgic_v5_irs *irs =3D kvm->arch.vgic.vgic_v5_irs_data;
> +
> +	if (WARN_ON_ONCE(!irs))
> +		return -ENXIO;

[Severity: High]
Could unprivileged userspace intentionally trigger this warning?

If a process calls the IST restore ioctl without properly configuring an IRS
address first, the pointer will be missing. This might allow a malicious
guest to trigger host kernel panics if panic_on_warn is enabled.

[ ... ]
> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
[ ... ]
> +static int vgic_v5_read_vm_ist_desc(struct kvm *kvm, unsigned int sectio=
n,
> +				    struct vgic_v5_ist_desc *ist)
> +{
> +	u32 vm_id =3D vgic_v5_vm_id(kvm);
> +	struct vmtl2_entry *vmte;
> +	u64 vmte_ist_section;
> +
> +	vmte =3D vgic_v5_get_l2_vmte(vm_id);
> +	if (IS_ERR(vmte))
> +		return PTR_ERR(vmte);
> +
> +	vgic_v5_clean_inval(vmte, sizeof(*vmte));
> +	vmte_ist_section =3D le64_to_cpu(READ_ONCE(vmte->val[section]));
> +
> +	ist->id_bits =3D FIELD_GET(GICV5_VMTEL2E_IST_ID_BITS, vmte_ist_section);
> +	ist->istsz =3D FIELD_GET(GICV5_VMTEL2E_IST_ISTSZ, vmte_ist_section);
> +	ist->l2sz =3D FIELD_GET(GICV5_VMTEL2E_IST_L2SZ, vmte_ist_section);
> +	ist->iste_size =3D GICV5_ISTE_SIZE(ist->istsz);
> +
> +	return vmte_ist_section & GICV5_VMTEL2E_IST_VALID;
> +}

[Severity: Medium]
Does the return type here truncate the result?

The function returns an int, but evaluates a bitwise AND on a 64-bit value.
If GICV5_VMTEL2E_IST_VALID is at bit 32 or higher, the cast to a 32-bit
signed integer would truncate it to 0, incorrectly marking valid ISTs as
invalid.

> +static int vgic_v5_get_spi_ist_desc(struct kvm *kvm, bool userspace_buf,
> +				    struct vgic_v5_ist_desc *ist)
> +{
> +	u32 vm_id =3D vgic_v5_vm_id(kvm);
> +	int ret;
> +
> +	memset(ist, 0, sizeof(*ist));
> +
> +	ist->vmi =3D xa_load(&vm_info, vm_id);
> +	if (WARN_ON_ONCE(!ist->vmi))
> +		return -ENXIO;

[Severity: High]
Is there a similar risk of userspace triggering this warning as seen in
vgic_v5_irs_lpi_ist_id_bits()?

If the save/restore ioctls are called before the VM runs and vm_info is
populated, ist->vmi will be unpopulated.

[ ... ]
> +static int vgic_v5_restore_linear_lpi_ist(struct kvm *kvm,
> +					  const struct vgic_v5_ist_desc *ist,
> +					  gpa_t g_entry_addr)
> +{
> +	size_t h_l2_index, h_l2_entries;
> +	__le32 h_iste;
> +	int ret;
> +
> +	h_l2_entries =3D BIT(ist->id_bits);
> +
> +	for (h_l2_index =3D 0; h_l2_index < h_l2_entries; h_l2_index++) {
> +		void *h_iste_addr =3D ist->base + h_l2_index * ist->iste_size;
> +
> +		ret =3D kvm_read_guest(kvm, g_entry_addr, &h_iste,
> +				     sizeof(h_iste));
> +		if (ret)
> +			return ret;
> +
> +		/*
> +		 * Sanitise the IST, clearing HWU & pending fields. Pending
> +		 * state is later replayed via GIC VDPEND.
> +		 */
> +		ret =3D vgic_v5_process_iste(&h_iste, &ist->vmi->pending_irqs,
> +					   h_l2_index, GICV5_HWIRQ_TYPE_LPI);

[Severity: High]
Could this inject invalid interrupts into the hardware?

The loop iterates from index 0 and processes all pending bits in the guest
provided LPI IST. Since LPI IDs must be 8192 or greater, queuing indices
0-8191 as pending LPIs and injecting them via VDPEND violates the
architecture and could cause unpredictable hardware behavior.

[ ... ]
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> @@ -405,6 +417,27 @@ static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe=
_id,
>  	return 0;
>  }
> =20
> +static int vgic_v5_irs_save_vm_op(u16 vm_id, bool save, u32 *statusr)
> +{
> +	u64 save_vmr;
> +	int ret;
> +
> +	save_vmr =3D FIELD_PREP(GICV5_IRS_SAVE_VMR_VM_ID, vm_id);
> +	save_vmr |=3D GICV5_IRS_SAVE_VMR_Q;
> +	save_vmr |=3D FIELD_PREP(GICV5_IRS_SAVE_VMR_S, save);

[Severity: High]
Is there a path to un-quiesce the VM after this operation completes?

The save operation unconditionally sets GICV5_IRS_SAVE_VMR_Q, but there
does not seem to be a corresponding mechanism anywhere to write the bit as
0. If a save is performed to checkpoint state and the VM continues executio=
n,
will it be permanently prevented from receiving interrupts?

[ ... ]
> +static void vgic_v5_restore_cleanup(struct kvm *kvm,
> +				    struct kvm_vcpu *vcpu,
> +				    bool lpi_ist_allocated)
> +{
> +	/*
> +	 * We are on the restore failure path, so we do a best-effort
> +	 * cleanup. These commands might fail, but at this stage this is the
> +	 * best we can realistically do.
> +	 */
> +	if (lpi_ist_allocated) {
> +		vgic_v5_send_command(vcpu, VMTE_MAKE_INVALID);
> +		vgic_v5_lpi_ist_free(kvm);
> +	}

[Severity: High]
Are we risking memory corruption if VMTE_MAKE_INVALID fails here?

If the invalidation command fails, the hardware might still consider the VM=
TE
valid. Calling vgic_v5_lpi_ist_free() immediately afterward frees the IST
pages and zeroes the active VMTE in memory while the hardware is still
using it.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D36
