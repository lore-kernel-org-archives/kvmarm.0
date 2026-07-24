Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53D3411F9C;
	Fri, 24 Jul 2026 12:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784894562; cv=none; b=U2EO8sdwidD3+wfpd/O6zZvs5nSFU8YTA9sj1k0EPjqDnJP7TVbLQkuHHXdN7DoiOIKv9gNuxAE50vCNTUybCmz5YFjfbz4e49elbWa8T1E9u8C6MMZQpgoPe0DYuZXCS+37j2mtKrBArbcYbr4taNB5nloW6L6uQ+E+ZYQGlwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784894562; c=relaxed/simple;
	bh=aNkgTPi9X3+8Qvg724hHI/wKIhDT/dTP0J9GY2Q2shA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iHQo3NIsyTlo1BRLw6xi38pLXwegA+5HabksLYnYQyF18HlGImgCmaTZ9jnf89FS8af9Xh0j8DN3cSEqdaHVuU1/fO47Xgvot/+FK0zXXz90jrn67GzljMTFx/ygyPCDl6cQy0Lf5mun9kIZ52ddOBCOnR+RMjj/lmFI8Xs/Xrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iG4x7Kkw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iG4x7Kkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB1B1F000E9;
	Fri, 24 Jul 2026 12:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784894560;
	bh=XYU2P498Ax8YeDgTEHhvjeNOJsU1e9OjMZh7d4FiH+k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iG4x7Kkwp5GbZmBtL/X03g/UxKyCfXjg5SBWlZfswK2BtdiTclOIzypEVVTd1lIDX
	 Uns0TvDZzosmOz8nWuKzkVK2W9IEcGxZs1vMGMmQje3lOPL652K1ZJbAPLPuL2AS1W
	 cXCbmw0/iTXSMYGClHcViD7a6xh4jIQ8cRRBRXMyetRu1UoN8ayixh1A042x6OHXH5
	 dqw0NOF0fF8D823ZXO8c0aonBIbmSQLSq8VYgQqj6Nnoy7XlX0MZZPwQ+gzy8fT1ut
	 5+/+R75zUxQH/NcUbPRQJjdvaV9DzZ1m0qi84YzGQi1qXhxsg8IHd1642xXDm9LYjz
	 hVWPLyJ0XFVpQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 35/48] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260724104819.1296803-36-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-36-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 12:02:39 +0000
Message-Id: <20260724120239.CEB1B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:
- [Critical] Retrieving `vcpu0` without verifying it exists leads to a NULL=
 pointer dereference.
- [Critical] Inverted lock check with `kvm_trylock_all_vcpus` leaks vCPU lo=
cks and runs lockless.
- [High] Incomplete cleanup on IST restore failure leaves a dangling pointe=
r in `vmi->h_lpi_ist`, leading to a double free.
- [High] Missing validation of LPI INTIDs during IST restore allows userspa=
ce to inject invalid INTIDs.
- [High] SPI IST restore incorrectly uses the array index directly as the a=
bsolute INTID, causing wrong interrupts to be injected.
- [High] Quiescence check masks lost quiescence state and causes silent dat=
a corruption.
- [Medium] KVM_DEV_ARM_VGIC_GRP_IST unconditionally fails for VMs configure=
d with 0 SPIs, breaking live migration.
- [Medium] The failure path in `vgic_v5_irs_restore_ists` incorrectly issue=
s a redundant `VMTE_MAKE_INVALID` command, risking a memory leak.
--

--- Patch [35]: [PATCH v4 35/48] KVM: arm64: gic-v5: Implement save/restore=
 mechanisms for ISTs ---
commit 5c47453f1884c74d1478029039189ee4ba68421a
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs

This patch introduces save and restore mechanisms for GICv5 Interrupt State
Tables (ISTs). It provides userspace migration storage for SPI and LPI
buffers via KVM_DEV_ARM_VGIC_GRP_IST and ensures the VM is quiesced and
validated during operations.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> index 718410e8c9f3b..f220267266c29 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c

[ ... ]

> @@ -1630,6 +1630,28 @@ static int vgic_v5_restore_linear_ist(struct kvm *=
kvm,
>  				      const struct vgic_v5_ist_desc *ist,
>  				      u32 __user *uaddr, size_t nr_entries,
>  				      u32 intid_type)
>  {
>  	__le32 h_iste;
>  	size_t index;
>  	int ret;
> =20
>  	for (index =3D 0; index < nr_entries; index++) {
>  		void *h_iste_addr =3D ist->base + index * ist->iste_size;
> =20
>  		ret =3D get_user(h_iste, uaddr);
>  		if (ret)
>  			return ret;
> =20
>  		ret =3D vgic_v5_restore_ist_entry(kvm, ist, h_iste_addr,
>  					h_iste, index, intid_type);

[Severity: High]
Should the SPI base offset be added to the index here?

When restoring SPIs, passing the raw array index as the intid will track and
inject interrupts starting at 0. Since hardware SPIs start at INTID 32, does
this incorrectly inject SGIs and PPIs instead of the intended SPIs?

>  		if (ret)
>  			return ret;
> =20
>  		uaddr++;
>  	}
> =20
>  	return 0;
>  }

[ ... ]

> @@ -1662,6 +1684,41 @@ static int vgic_v5_restore_two_level_ist(struct kv=
m *kvm,
>  					 const struct vgic_v5_ist_desc *ist,
>  					 u32 __user *uaddr, u32 intid_type)
>  {

[ ... ]

>  		for (h_l2_index =3D 0; h_l2_index < shape.l2_entries; h_l2_index++) {
>  			void *h_iste_addr =3D h_l2_ist_base +
>  					    h_l2_index * ist->iste_size;
>  			u32 intid =3D h_l1_index * shape.l2_entries + h_l2_index;
> =20
>  			ret =3D get_user(h_iste, uaddr);
>  			if (ret)
>  				return ret;
> =20
>  			ret =3D vgic_v5_restore_ist_entry(kvm, ist, h_iste_addr,
>  							h_iste, intid,
>  							intid_type);

[Severity: High]
Is there any validation missing for the generated LPI INTIDs?

The iteration calculates intid starting from 0. If userspace sets pending
bits for these lower indices, KVM would track them and inject them via the
VDPEND instruction at EL2.

Since valid LPI INTIDs must be >=3D 8192, could injecting lower IDs result =
in
architecturally unpredictable hardware behavior?

>  			if (ret)
>  				return ret;
> =20
>  			uaddr++;
>  		}
>  	}
> =20
>  	return 0;
>  }

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 6af1264ed2371..153a8fcd4db7c 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c

[ ... ]

> @@ -1301,6 +1301,292 @@ void vgic_v5_save_state(struct kvm_vcpu *vcpu)
>  	__vgic_v5_save_ppi_state(cpu_if);
>  	dsb(sy);
>  }
> +
> +static int vgic_v5_irs_status_is_quiesced(u32 statusr)
> +{
> +	if (statusr & GICV5_IRS_SAVE_VM_STATUSR_Q)
> +		return 0;
> +
> +	return -EBUSY;
> +}
> +
> +static int vgic_v5_irs_is_quiesced(u16 vm_id)
> +{
> +	u32 statusr;
> +	int ret;
> +
> +	ret =3D vgic_v5_irs_save_vm_op(vm_id, false, &statusr);

[Severity: High]
Does this quiescence check potentially lose hardware state?

By calling vgic_v5_irs_save_vm_op() with save=3Dfalse, it issues a SAVE_VMR
command with Q=3D1 and S=3D0 (Quiesce but don't save).

If the VM had unexpectedly unquiesced (e.g., interrupted by hardware),
forcing it to quiesce without saving would destroy its modified internal
state before it can be exported to userspace.

> +	if (ret)
> +		return ret;
> +
> +	return vgic_v5_irs_status_is_quiesced(statusr);
> +}
> +
> +static int vgic_v5_copy_ist_attr(struct kvm_device_attr *attr,
> +				 struct kvm_vgic_v5_ist *ist_attr)
> +{
> +	void __user *uaddr =3D (void __user *)(unsigned long)attr->addr;
> +
> +	if (!uaddr)
> +		return -EINVAL;
> +
> +	if (copy_from_user(ist_attr, uaddr, sizeof(*ist_attr)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int vgic_v5_validate_ist_user_buffer(__u64 addr, __u64 size,
> +					    size_t expected)
> +{
> +	if (!addr || size !=3D expected)
> +		return -EINVAL;

[Severity: Medium]
Is there an issue here when restoring a VM configured with 0 SPIs?

If userspace passes a size of 0 and an address of 0, the check if (!addr)
will reject it with -EINVAL.

If userspace passes a dummy non-zero address to bypass this, it fails later
in vgic_v5_get_spi_ist_desc():

arch/arm64/kvm/vgic/vgic-v5-tables.c:vgic_v5_get_spi_ist_desc() {
    ...
    if (!ist->base && userspace_buf)
        return -ENOENT;
    ...
}

Does this catch-22 prevent live migration for VMs without SPIs?

> +
> +	return 0;
> +}

[ ... ]

> +int vgic_v5_irs_save_ists(struct kvm *kvm, struct kvm_device_attr *attr)
> +{
> +	struct kvm_vgic_v5_ist ist_attr;
> +	u16 vm_id =3D vgic_v5_vm_id(kvm);
> +	u32 statusr;
> +	int ret =3D 0;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	if (kvm_trylock_all_vcpus(kvm)) {
> +		mutex_unlock(&kvm->lock);
> +		return -EBUSY;
> +	}

[Severity: Critical]
Is the return value of kvm_trylock_all_vcpus() handled correctly here?

The function returns true on successful lock acquisition and false on
failure. Returning -EBUSY when it is true means we leak the vCPU locks
and hang the VM.

Conversely, failing to acquire the locks lets us proceed lockless, and then
unlocking unowned mutexes in the out_unlock path would cause issues.

> +
> +	mutex_lock(&kvm->arch.config_lock);

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
> +		if (!vgic_v5_send_command(vcpu, VMTE_MAKE_INVALID))
> +			vgic_v5_lpi_ist_free(kvm);
> +	}

[Severity: High]
Could this leave a dangling pointer behind?

When vgic_v5_lpi_ist_free() is called on a failure path, it frees the memory
but does not set vmi->h_lpi_ist to NULL. If a subsequent teardown happens in
vgic_v5_vmte_release(), it might observe the populated pointer and attempt
to free it again, causing a double-free.

[Severity: Medium]
Are we risking a memory leak by issuing a redundant invalidate command?

If we reach the failure path from a point where the VMTE is already invalid,
this function will issue VMTE_MAKE_INVALID again because the vmte_invalid
state is not passed in. If the hardware driver returns an error when asked
to invalidate an already-invalid VMTE, vgic_v5_send_command() will fail.

This would skip the vgic_v5_lpi_ist_free() call and permanently leak the LPI
IST memory.

> +
> +	vgic_v5_send_command(vcpu, VMTE_MAKE_VALID);
> +}
> +
> +int vgic_v5_irs_restore_ists(struct kvm *kvm, struct kvm_device_attr *at=
tr)
> +{
> +	bool lpi_ist_allocated =3D false, vmte_invalid =3D false;
> +	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);

[Severity: Critical]
What happens if userspace invokes this ioctl before creating any vCPUs?

kvm_get_vcpu(kvm, 0) would return NULL. Later, this NULL vcpu0 is passed to
vgic_v5_send_command(), which dereferences it inside vgic_v5_vpe_db().

Should we verify vcpu0 exists before using it to prevent a potential NULL
pointer dereference?

> +	struct kvm_vgic_v5_ist ist_attr;
> +	int ret =3D 0;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	if (kvm_trylock_all_vcpus(kvm)) {
> +		mutex_unlock(&kvm->lock);
> +		return -EBUSY;
> +	}

[Severity: Critical]
As noted in vgic_v5_irs_save_ists(), does this correctly handle the boolean
return value of kvm_trylock_all_vcpus()? It looks like this behaves in the
exact opposite way as intended, leaking locks on success and running
lockless on failure.

> +
> +	mutex_lock(&kvm->arch.config_lock);
> +
> +	if (!vgic_initialized(kvm)) {

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D35
