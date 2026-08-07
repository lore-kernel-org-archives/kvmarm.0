Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E850C3FCB2F;
	Fri,  7 Aug 2026 12:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786107028; cv=none; b=u9pSRxEMvNXUDoLJOmOc4+9G0kPtUtpZsPockRr+ifukIsxo1TQgsO8yZw38haXmW5d/WT3Sa/WZbAvotvQXFzHzi0fte82pfhWbKMlQ/pe2sVpvyKW/7Q3W7dl/z52mxFmfERIeXyC7aHacL5ZnuEPuSuqxvfbwPJ9+Ed8bQ3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786107028; c=relaxed/simple;
	bh=uSb4yeeUipa98u037eDbDXTpoWOu7eCGb73rHfA/Iek=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cFbC5ZUdSBIMsLiMHcobdC7oY5IJyWD37fG2jaU9x8ebzKVkLYw3ypW8lpZWqirFlV7F2VfjNOtMbv/yTd0cvKI3s9Kvs83Um/YCt/9doUxCFCCLwq0qu9AM3U7G9+01mOERIUGg2NWsWnIqrujtxicc/iSetqR7flw6XRNQSNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=akVwZSk1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="akVwZSk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E7C1F000E9;
	Fri,  7 Aug 2026 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786107017;
	bh=PNproMWlQb5EO55KbZbH29rf4+cDzGlI+pu3jG6Zmrw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=akVwZSk1bTiFeoar5tT6Wa7byMbqwWpCDxUaZpz/COhEh6U5sgqI4GfclKhWKf+JV
	 9LJ7hCyxTKXI7tMk8BTr0VK/pSRRiZApVb0KxNJiSc/5s65hyzJTNFl+RDIEHba1iQ
	 jxuKtQdgsQ6TPUqBzETOKX9Ev/R4nLBfYg3hR3qrHCSc2JMTifUreaZWwvhTzS+Qi3
	 YCMMj9dqAR9IjyyY7kN0oC5UfUW1Q75GFlWLeV4TuQNaa/k4Ze58hoOuASjGe7Qjou
	 MbYWBTHkAjA5lLisRdxaxyzGtn3AtEY7SiOLidFHKDTNo97BJ4bYAQrgAXi3NL1HgR
	 whOik8j7jJ55w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/49] KVM: arm64: gic-v5: Create and manage VM and
 VPE tables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260807111159.429128-10-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-10-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 12:50:15 +0000
Message-Id: <20260807125016.D0E7C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Critical] Initializing the VGICv5 with 0 vCPUs triggers a NULL pointer d=
ereference and a cache maintenance fault on ZERO_SIZE_PTR.
- [High] VMT tables and associated structures allocated via kzalloc lack re=
quired cacheline and hardware alignment, risking memory corruption and addr=
ess truncation.
- [High] vgic_v5_db_set_vcpu_affinity intercepts and drops all IRS commands=
, breaking L2 VMT allocation.
- [High] VPET and L1 VMT entries are populated in memory without setting th=
eir architecturally required Valid bits.
- [High] The VM info structure (`vmi`) is inserted into the global `vm_info=
` XArray before it is fully initialized, creating a TOCTOU race.
- [High] Lockless XArray lookups of `vmi` lack `rcu_read_lock()` protection=
 and race with synchronous `kfree()`.
--

--- Patch [9]: [PATCH v5 09/49] KVM: arm64: gic-v5: Create and manage VM an=
d VPE tables ---
commit dc3f99568625ef5a0f577860cb4099269b170ef2
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Date:   Fri Aug 7 11:17:11 2026 +0000

    KVM: arm64: gic-v5: Create and manage VM and VPE tables
   =20
    GICv5 uses a set of in-memory tables to track and manage VM state.
    These must be allocated by the hypervisor and provided to the IRS.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> new file mode 100644
> index 0000000000000..7252d48431a5a
> --- /dev/null
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
[ ... ]
> +static void vgic_v5_clean_inval(void *va, size_t size)
> +{
> +	unsigned long base =3D (unsigned long)va;
> +
> +	dsb(ishst);
> +
> +	if (kvm_vgic_global_state.vgic_v5_irs_caps.non_coherent)
> +		dcache_clean_inval_poc(base, base + size);
> +}

[Severity: High]
Does dcache_clean_inval_poc() operate on cacheline-aligned base pointers he=
re?

While vpet and vped_base allocations round their size up to
dma_get_cache_alignment(), kzalloc() does not guarantee that the base point=
er
itself will be cacheline-aligned.

Performing cacheline-granular invalidation on unaligned buffers evicts shar=
ed
cachelines, which could corrupt unrelated slab objects sharing the cachelin=
e.

[ ... ]
> +static int vgic_v5_alloc_l2_vmt(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
> +	u32 vm_id =3D vgic_v5_vm_id(kvm);
> +	enum gicv5_vcpu_cmd cmd =3D VMT_L2_MAP;
> +	struct vmtl2_entry *l2_table;
> +	unsigned int l1_index;
> +	int ret;
> +
> +	/* Nothing to do if we have linear tables! */
> +	if (!vmt_info->two_level)
> +		return 0;
> +
> +	if (vm_id =3D=3D VGIC_V5_VM_ID_INVAL)
> +		return -EINVAL;
> +
> +	/*
> +	 * We have 4k-sized L2 tables - this is mandated by the spec for
> +	 * two-level VMTs (GICv5 EAC0 Specification rule D_LSPBK). This means
> +	 * that we have 128 entries per L1 VMTE.
> +	 */
> +	l1_index =3D vm_id / GICV5_VMT_L2_TABLE_ENTRIES;
> +
> +	guard(mutex)(&vmt_l2_lock);
> +
> +	/* Already valid? Great! */
> +	if (vmt_info->l2.l2ptrs[l1_index])
> +		return 0;
> +
> +	l2_table =3D kzalloc_objs(*l2_table, GICV5_VMT_L2_TABLE_ENTRIES);

[Severity: High]
Does the L2 table allocation meet the hardware's 4K alignment requirement?

l2_table is allocated using kzalloc_objs(). Hardware extracts the L2 physic=
al
address using GICV5_VMTEL1E_L2_ADDR (bits 51:12), which requires 4K alignme=
nt.

SLUB does not guarantee 4K base alignment for kmalloc allocations, which co=
uld
cause silent address truncation when the physical address is written to the=
 L1
entry.

> +	if (!l2_table)
> +		return -ENOMEM;
> +
> +	/* The VMT is shared between all VMs. */
> +	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
> +		vgic_v5_clean_inval(l2_table, GICV5_VMT_L2_TABLE_SIZE);
> +		vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
> +				    sizeof(vmtl1_entry));
> +
> +		WRITE_ONCE(vmt_info->l2.vmt_base[l1_index],
> +			   cpu_to_le64(virt_to_phys(l2_table)));

[Severity: High]
Is the GICV5_VMTEL1E_VALID bit missing here?

The L1 VMT entry is populated with the physical address of the L2 table, bu=
t it
doesn't look like the GICV5_VMTEL1E_VALID bit is ever set, which might cause
the hardware to treat the table as invalid.

> +
> +		vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
> +				    sizeof(vmtl1_entry));
> +
> +	}
> +
> +	/*
> +	 * VMAP in the L2 VMT via the IRS. We use any of the VM's CPUs as a
> +	 * conduit for interacting with the host's IRS. In the current case,
> +	 * this lets us resolve the VM ID to pass to the hardware.
> +	 */
> +	ret =3D irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd);

[Severity: Critical]
What happens if this is called when no vCPUs have been created yet?

If atomic_read(&kvm->online_vcpus) is 0 during vgic_v5_vmte_init(),
kvm_get_vcpu(kvm, 0) returns NULL, which would cause a NULL pointer
dereference when it is passed to vgic_v5_vpe_db() here.

[ ... ]
> +int vgic_v5_vmte_init(struct kvm *kvm)
> +{
> +	size_t vmd_alloc_size, vpet_alloc_size, vped_alloc_size;
> +	void *vped_base =3D NULL, *vmd =3D NULL;
> +	struct vgic_v5_vm_info *vmi =3D NULL;
> +	u64 tmp, vmte_val0 =3D 0, vmte_val1;
> +	u32 vm_id =3D vgic_v5_vm_id(kvm);
> +	int ret, nr_cpus, nr_vcpus;
> +	bool vmi_inserted =3D false;
> +	struct vmtl2_entry *vmte;
> +	vpe_entry *vpet =3D NULL;
> +	struct kvm_vcpu *vcpu;
> +	u16 max_vpe_id =3D 0;
> +	unsigned long i;
> +
> +	nr_vcpus =3D atomic_read(&kvm->online_vcpus);
> +	if (nr_vcpus > vmt_info->max_vpes)
> +		return -E2BIG;
> +
> +	/*
> +	 * If we're using two-level VMTs, L2 is allocated on demand. For linear
> +	 * VMTs, this is a NOP.
> +	 */
> +	ret =3D vgic_v5_alloc_l2_vmt(kvm);
> +	if (ret)
> +		return ret;
> +
> +	vmte =3D vgic_v5_get_l2_vmte(vm_id);
> +	if (IS_ERR(vmte))
> +		return PTR_ERR(vmte);
> +
> +	/* If the entry is already valid, something went wrong */
> +	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
> +		vgic_v5_clean_inval(vmte, sizeof(*vmte));
> +		if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
> +			return -EINVAL;
> +	}
> +
> +	ret =3D vgic_v5_reset_vmte(kvm);
> +	if (ret)
> +		return ret;
> +
> +	vmi =3D kzalloc_obj(*vmi);
> +	if (!vmi) {
> +		ret =3D -ENOMEM;
> +		goto out_fail;
> +	}
> +
> +	ret =3D xa_insert(&vm_info, vm_id, vmi, GFP_KERNEL);

[Severity: High]
Is it safe to publish vmi before its fields are initialized?

vmi is published to the global vm_info XArray here, but sleepable allocatio=
ns
for vmi->vmd_base, vmi->vpet_base, and vmi->vped_base occur after this poin=
t.

Could a concurrent thread executing vgic_v5_vmte_alloc_vpe() retrieve the
partially constructed vmi and dereference its NULL pointers?

> +	if (ret)
> +		goto out_fail;
> +	vmi_inserted =3D true;
> +
> +	/* Allocate and assign the VM Descriptor, if required. */
> +	if (vmt_info->vmd_size !=3D 0) {
> +		vmd_alloc_size =3D round_up(vmt_info->vmd_size,
> +					  dma_get_cache_alignment());
> +		vmd =3D kzalloc(vmd_alloc_size, GFP_KERNEL);
> +		if (!vmd) {
> +			ret =3D -ENOMEM;
> +			goto out_fail;
> +		}
> +
> +		/* Stash the VA so we can free it later */
> +		vmi->vmd_base =3D vmd;
> +
> +		tmp =3D FIELD_PREP(GICV5_VMTEL2E_VMD_ADDR,
> +				 virt_to_phys(vmd) >> GICV5_VMTEL2E_VMD_ADDR_SHIFT);
> +		vmte_val0 =3D tmp;
> +	}
> +
> +	/*
> +	 * Allocate and assign the VPE Table.
> +	 *
> +	 * First of all, iterate over all vcpus to find the highest VPE ID we
> +	 * require - we need to ensure that we have enough storage for all
> +	 * vcpu_id values that userspace has picked and not just the total
> +	 * number of vcpus. This gives us the number of VPEs required for the
> +	 * VM.
> +	 *
> +	 * Round up the number of VPEs to a whole power of two as we cannot
> +	 * describe non-powers-of-two in the VMTE field as it conveys the number
> +	 * of ID bits used and not the number of vPEs. IRS_IDR1.IAFFID_BITS is
> +	 * encoded as N - 1, so expose at least one VPE ID bit even for a
> +	 * single-vCPU VM to keep the views consistent.
> +	 */
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
> +
> +		if (vpe_id > max_vpe_id)
> +			max_vpe_id =3D vpe_id;
> +	}
> +
> +	nr_cpus =3D max(2UL, roundup_pow_of_two(max_vpe_id + 1));
> +	vmi->vpe_id_bits =3D fls(nr_cpus) - 1;
> +
> +	vpet_alloc_size =3D round_up((size_t)nr_cpus * sizeof(*vpet),
> +				   dma_get_cache_alignment());
> +	vpet =3D kzalloc(vpet_alloc_size, GFP_KERNEL);
> +	if (!vpet) {
> +		ret =3D -ENOMEM;
> +		goto out_fail;
> +	}
> +
> +	/* Stash the VA so we can free it later */
> +	vmi->vpet_base =3D vpet;
> +
> +	tmp =3D FIELD_PREP(GICV5_VMTEL2E_VPET_ADDR,
> +			 virt_to_phys(vpet) >> GICV5_VMTEL2E_VPET_ADDR_SHIFT);
> +	tmp |=3D FIELD_PREP(GICV5_VMTEL2E_VPE_ID_BITS, vmi->vpe_id_bits);
> +	vmte_val1 =3D tmp;
> +
> +	/*
> +	 * Allocate a dense VPED array indexed by vcpu_idx. The VPET is indexed
> +	 * by the potentially sparse vcpu_id, but using that ID here would waste
> +	 * memory. Given that this is not userspace visible, we can cheat a bit
> +	 * and use the dense index instead. This is the ONLY place that we do
> +	 * this.
> +	 *
> +	 * Round the requested size up to a whole cacheline. kzalloc() gurantees
> +	 * natural alignment, so we ensure that the cachelines cannot be shared
> +	 * with unrelated slab objects. VPED and cacheline sizes are powers of
> +	 * two, so this also preserves the required VPED alignment when a VPED
> +	 * is larger than a cacheline.
> +	 */
> +	vped_alloc_size =3D round_up((size_t)nr_vcpus * vmt_info->vped_size,
> +				   dma_get_cache_alignment());
> +	vped_base =3D kzalloc(vped_alloc_size, GFP_KERNEL);

[Severity: Critical]
Can nr_vcpus be 0 here?

If no vCPUs are online, vped_alloc_size evaluates to 0. Calling
kzalloc(0, GFP_KERNEL) returns the ZERO_SIZE_PTR (0x10).

> +	if (!vped_base) {
> +		ret =3D -ENOMEM;
> +		goto out_fail;
> +	}
> +	vmi->vped_base =3D vped_base;
> +
> +	if (vmd)
> +		vgic_v5_clean_inval(vmd, vmd_alloc_size);
> +	vgic_v5_clean_inval(vpet, vpet_alloc_size);
> +	vgic_v5_clean_inval(vped_base, vped_alloc_size);

Passing the ZERO_SIZE_PTR to vgic_v5_clean_inval() will execute a cache
invalidation on address 0x10, which would cause a fatal translation fault
and crash the kernel.

[ ... ]
> +int vgic_v5_vmte_release(struct kvm *kvm)
> +{
> +	u32 vm_id =3D vgic_v5_vm_id(kvm);
> +	struct vgic_v5_vm_info *vmi;
> +	struct vmtl2_entry *vmte;
> +	int ret;
> +
> +	vmte =3D vgic_v5_get_l2_vmte(vm_id);
> +	if (IS_ERR(vmte))
> +		return PTR_ERR(vmte);
> +
> +	/* Reject if the VMTE has not been marked as invalid! */
> +	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
> +		vgic_v5_clean_inval(vmte, sizeof(*vmte));
> +		if (le64_to_cpu(READ_ONCE(vmte->val[0])) & GICV5_VMTEL2E_VALID)
> +			return -EINVAL;
> +	}
> +
> +	vmi =3D xa_load(&vm_info, vm_id);
> +	if (!vmi)
> +		goto no_vmi;
> +
> +	kfree(vmi->vped_base);
> +	kfree(vmi->vpet_base);
> +	kfree(vmi->vmd_base);
> +
> +	xa_erase(&vm_info, vm_id);
> +	kfree(vmi);

[Severity: High]
Could this synchronously free a vmi object that is currently in use?

This path synchronously calls kfree(vmi) after erasing it from the XArray,
but readers like vgic_v5_vmte_alloc_vpe() load from the XArray without RCU
protection.

Will this cause a use-after-free for any lockless readers that have preempt=
ed?

[ ... ]
> +int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
> +{
> +	u32 vm_id =3D vgic_v5_vm_id(vcpu->kvm);
> +	u16 vpe_id =3D vgic_v5_vpe_id(vcpu);
> +	struct vgic_v5_vm_info *vmi;
> +	vpe_entry tmp, *vpet_base;
> +	void *vped;
> +
> +	/* Make sure we're not over what the hardware supports */
> +	if (vpe_id >=3D vmt_info->max_vpes)
> +		return -E2BIG;
> +
> +	vmi =3D xa_load(&vm_info, vm_id);

[Severity: High]
Does this xa_load() need rcu_read_lock() protection?

The vmi object is retrieved without RCU read-side protection, and
vgic_v5_vmte_release() synchronously calls kfree(vmi).

Could a preempted reader here dereference a freed vmi object?

> +	if (!vmi)
> +		return -EINVAL;
> +
> +	if (vpe_id >=3D 1 << vmi->vpe_id_bits)
> +		return -E2BIG;
> +
> +	vpet_base =3D vmi->vpet_base;
> +
> +	/* If the VPETE for this CPU is already valid we've gone wrong */
> +	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
> +		vgic_v5_clean_inval(&vpet_base[vpe_id], sizeof(*vpet_base));
> +		if (le64_to_cpu(READ_ONCE(vpet_base[vpe_id])) & GICV5_VPE_VALID)
> +			return -EBUSY;
> +	}
> +
> +	vped =3D (u8 *)vmi->vped_base +
> +		(size_t)vcpu->vcpu_idx * vmt_info->vped_size;
> +
> +	tmp =3D FIELD_PREP(GICV5_VPED_ADDR, virt_to_phys(vped) >> GICV5_VPED_AD=
DR_SHIFT);
> +
> +	scoped_guard(raw_spinlock_irqsave, &vgic_v5_irs_lock) {
> +		WRITE_ONCE(vpet_base[vpe_id], cpu_to_le64(tmp));

[Severity: High]
Is the GICV5_VPE_VALID bit missing here?

The VPET entry is written to memory, but the GICV5_VPE_VALID bit is not set,
which might cause the hardware to treat the entry as invalid.

> +		vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry));
> +	}
> +
> +	return 0;
> +}

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 752329fc3d566..4d1d7701ef71d 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> +static int vgic_v5_db_set_vcpu_affinity(struct irq_data *data, void *vcp=
u_info)
> +{
> +	enum gicv5_vcpu_cmd *cmd =3D vcpu_info;
> +
> +	guard(raw_spinlock_irqsave)(&vgic_v5_irs_lock);
> +
> +	switch (*cmd) {
> +	case VMT_L2_MAP:
> +	case VMTE_MAKE_VALID:
> +	case VMTE_MAKE_INVALID:
> +		/* Not yet implemented */
> +	default:
> +		return -EINVAL;
> +	}
> +}

[Severity: High]
Should this function forward valid commands to the parent irqchip?

By returning -EINVAL for commands like VMT_L2_MAP, it intercepts and drops
them without calling irq_chip_set_vcpu_affinity_parent().

This causes the VMT_L2_MAP command issued by vgic_v5_alloc_l2_vmt() to alwa=
ys
fail, preventing VMs from booting.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D9
