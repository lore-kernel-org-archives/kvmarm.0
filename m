Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27BEA3C3448
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 15:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391724; cv=none; b=sgLsDF7HTmmGnNlmXVv7zXqh0dmCmMB7En4KQiZ1e2wI21PUCAHFnvuK05+WHTG/gq4cWv/RDaaecqx1Wz2qBEVIA4kJzKO40rRbCRh5fuIwyvqzJBfDqt/CquiAqlmSKhUJXyz3CY7dFbzzsTnr2vJaio+siG5oIomir0WSU+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391724; c=relaxed/simple;
	bh=0MrlCeQkWta6GQGWNw4br42If1RV8a1J63vs2z+KL24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLQ5IJnhzI9/0b3gctdXHJ5vpXiZUeUvoe9bU+FsD3fXaDghIZLZ6o9OV8f6ab4G4PB92HwrLS8oHkzw0fhdAdwnWiY+O/c69Drt0TeD7dRxnZLNL2qgAbhpth0A59hdfEwOdWS3anAa+wsBNfjmQ7kBtw9sgEFnG3jf8Jk42CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=q1RBuTxY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="q1RBuTxY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E23A1655;
	Tue, 28 Apr 2026 08:55:15 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EEC323F7B4;
	Tue, 28 Apr 2026 08:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777391720; bh=0MrlCeQkWta6GQGWNw4br42If1RV8a1J63vs2z+KL24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q1RBuTxYCunbL6a7rte99MM/FGPUmOTanaK943G5zog1HBsgKHRIkjtlbaJkJs8vW
	 R53FpJhnHlJtyEk5OqA5DF3Thf8KDGw9mSG+XqaPzfGbsQ93HuUPBOqgmbsbZ5sVtD
	 DMPao+bv69FBV2IQ9jUh960bueqQ3Z1SgqmgePd0=
Date: Tue, 28 Apr 2026 16:55:13 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: Re: [PATCH 07/43] KVM: arm64: gic-v5: Create & manage VM and VPE
 tables
Message-ID: <20260428155513.GA708848@e124191.cambridge.arm.com>
References: <20260427160547.3129448-1-sascha.bischoff@arm.com>
 <20260427160547.3129448-8-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427160547.3129448-8-sascha.bischoff@arm.com>

A lot to look into here, just some first read through nits.

On Mon, Apr 27, 2026 at 04:08:25PM +0000, Sascha Bischoff wrote:
> GICv5 uses a set of in-memory tables to track and manage VM
> state. These must be allocated by the hypervisor, and provided to the
> IRS to use.
> 
> The VMT (Virtual Machine Table) is a linear or two level table
> comprising VMT Entries (VMTE). Each VMTE describes the state for a
> single VM. This state includes things such as the SPI and LPI IST
> configuration (coming in a future commit), an implementation-defined
> VM Descriptor, and a VPE Table (VPET).
> 
> The VPET contains one entry per VPE belonging to a VM, and is used to
> mark a VPE as valid, as well as providing the address of an
> implementation-defined VPE Descriptor, which is used by the hardware
> to track and manage VPE state.
> 
> This commit adds support for allocating the VMT, and managing the
> VMTEs. The VMTEs can be initialised or released for re-use. Allocation
> and tracking of unused VMTEs is handled with an IDA.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/kvm/vgic/vgic-v5-tables.c | 628 +++++++++++++++++++++++++++
>  arch/arm64/kvm/vgic/vgic-v5-tables.h | 108 +++++
>  include/kvm/arm_vgic.h               |   2 +
>  include/linux/irqchip/arm-gic-v5.h   |  13 +
>  4 files changed, 751 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgic-v5-tables.c
> index 30e2b108b1aa3..502d05d46cccf 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
> @@ -3,6 +3,634 @@
>   * Copyright (C) 2025, 2026 Arm Ltd.
>   */
>  
> +#include <kvm/arm_vgic.h>
> +#include <linux/kernel.h>
> +#include <linux/mm.h>
> +#include <linux/sizes.h>
> +#include <linux/slab.h>
> +#include <linux/xarray.h>
> +#include <asm/kvm_mmu.h>
> +
> +#include "vgic.h"
>  #include "vgic-v5-tables.h"
>  
>  struct vgic_v5_host_ist_caps gicv5_host_ist_caps;
> +
> +static struct vgic_v5_vmt *vmt_info;
> +DEFINE_XARRAY(vm_info);
> +
> +static bool vgic_v5_vmt_allocated(void)
> +{
> +	return vmt_info != NULL;
> +}
> +
> +static int vgic_v5_check_vm_id(u16 vm_id)
> +{
> +	if (vm_id >= vmt_info->num_entries)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/*
> + * Our IRS might be coherent or non-coherent. If coherent, we can just emit a
> + * DSB to ensure that we're in sync. However, when non-coherent, we need to
> + * manage our cached data explicitly.
> + *
> + * This helper is used to handle both coherent and non-coherent IRSes, and
> + * handles all combinations of cleaning and invalidating to the PoC.
> + */
> +static void vgic_v5_clean_inval(void *va, size_t size, bool clean, bool inval)
> +{
> +	unsigned long base = (unsigned long)va;
> +
> +	/* Catch any accidental NOPs */
> +	BUILD_BUG_ON(!(clean || inval));
> +
> +	/* Coherent; emit DSB. */
> +	if (!gicv5_host_ist_caps.irs_non_coherent) {
> +		dsb(ishst);
> +		return;
> +	}
> +
> +	if (clean && inval)
> +		dcache_clean_inval_poc(base, base + size);
> +	else if (clean)
> +		dcache_clean_poc(base, base + size);
> +	else if (inval)
> +		dcache_inval_poc(base, base + size);
> +}
> +
> +/*
> + * Create a linear VM table, rounding up the number of entries to at least one
> + * whole page to give us nicer alignment.
> + *
> + * Note: We don't update the number of entries tracked in our tracking structure
> + * as this might be higher than the number of bits supported by the HW.
> + */
> +static int vgic_v5_alloc_vmt_linear(unsigned int num_entries)
> +{
> +	unsigned int l2_entries_per_page;
> +	size_t alloc_size;
> +
> +	/* Potentially throw away a bit of memory for the sake of alignment! */
> +	l2_entries_per_page = PAGE_SIZE / GICV5_VMTEL2E_SIZE;
> +	if (num_entries < l2_entries_per_page)
> +		num_entries = l2_entries_per_page;
> +
> +	alloc_size = num_entries * sizeof(struct vmtl2_entry);
> +
> +	vmt_info->linear.vmt_base = kzalloc(alloc_size, GFP_KERNEL);
> +	if (vmt_info->linear.vmt_base == NULL)
> +		return -ENOMEM;
> +
> +	vgic_v5_clean_inval(vmt_info->linear.vmt_base, alloc_size, true, true);
> +
> +	return 0;
> +}
> +
> +/*
> + * Allocate the first level of a two-level VM table. The second-level VM tables
> + * are allocated on demand (by vgic_v5_alloc_l2_vmt()).
> + *
> + * Note: If there are too few entries, these are rounded up to the size of an L2
> + * table (4k) to ensure sane alignment. As with the linear table, the tracked
> + * number of entries is not increased to avoid the case of going above what the
> + * hardware supports.
> + */
> +static int vgic_v5_alloc_vmt_two_level(unsigned int num_entries)
> +{
> +	size_t alloc_size;
> +
> +	/* Potentially throw away a bit of memory for the sake of alignment! */
> +	if (num_entries < GICV5_VMT_L2_TABLE_ENTRIES)
> +		num_entries = GICV5_VMT_L2_TABLE_ENTRIES;
> +
> +	/*
> +	 * Let's make sure that we always allocate a whole power of 2
> +	 * of entries. Note that we need to subtract 1 from the fls()
> +	 * result in order to give the correct number of bits as we
> +	 * are operating on a whole power of 2.

This fls() seems unrelated? There is an fls() - 1 in vgic_v5_vmte_init().

> +	 */
> +	num_entries = roundup_pow_of_two(num_entries);
> +
> +	vmt_info->l2.num_l1_ents = (num_entries / GICV5_VMT_L2_TABLE_ENTRIES);
> +	alloc_size = vmt_info->l2.num_l1_ents * sizeof(vmtl1_entry);
> +
> +	vmt_info->l2.vmt_base = kzalloc(alloc_size, GFP_KERNEL);
> +	if (vmt_info->l2.vmt_base == NULL)
> +		return -ENOMEM;
> +
> +	vgic_v5_clean_inval(vmt_info->l2.vmt_base, alloc_size, true, true);
> +
> +	vmt_info->l2.l2ptrs = kzalloc_objs(*vmt_info->l2.l2ptrs,
> +					   vmt_info->l2.num_l1_ents,
> +					   GFP_KERNEL);
> +	if (vmt_info->l2.l2ptrs == NULL) {
> +		kfree(vmt_info->l2.vmt_base);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +/*
> + * Allocate a second level VMT, if required. This can be called eagerly, and
> + * will only perform the allocation if required.
> + */
> +static int vgic_v5_alloc_l2_vmt(struct kvm *kvm)
> +{
> +	unsigned int l1_index;
> +	struct vmtl2_entry *l2_table;
> +	vmtl1_entry tmp;
> +	u16 vm_id = vgic_v5_vm_id(kvm);
> +	struct kvm_vcpu *vcpu0 = kvm_get_vcpu(kvm, 0);
> +	struct gicv5_cmd_info cmd_info;
> +	int ret;
> +
> +	if (!vgic_v5_vmt_allocated())
> +		return -ENXIO;
> +
> +	/* Nothing to do if we have linear tables! */
> +	if (!vmt_info->two_level)
> +		return 0;
> +
> +	ret = vgic_v5_check_vm_id(vm_id);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * We have 4k-sized L2 tables - this is mandated by the spec for
> +	 * two-level VMTs. This means that we have 128 entries per L1 VMTE.
> +	 */
> +	l1_index = vm_id / GICV5_VMT_L2_TABLE_ENTRIES;
> +
> +	if (l1_index > vmt_info->l2.num_l1_ents)
> +		return -E2BIG;
> +
> +	/* Already valid? Great! */
> +	if (vmt_info->l2.l2ptrs[l1_index] != NULL)
> +		return 0;
> +
> +	l2_table = kzalloc(GICV5_VMT_L2_TABLE_SIZE, GFP_KERNEL);
> +	if (l2_table == NULL)
> +		return -ENOMEM;
> +
> +	if (virt_to_phys(l2_table) & ~GICV5_VMTEL1E_L2_ADDR) {
> +		kfree(l2_table);
> +		return -EINVAL;
> +	}

Duplicated code below this. I guess move the comment up and delete the same checks below.
> +
> +	vmt_info->l2.l2ptrs[l1_index] = l2_table;
> +
> +	/* Alignment issue! */
> +	if (virt_to_phys(l2_table) & ~GICV5_VMTEL1E_L2_ADDR) {
> +		kfree(l2_table);
> +		return -EFAULT;
> +	}
> +
> +	tmp = virt_to_phys(l2_table) & GICV5_VMTEL1E_L2_ADDR;

Can we rename tmp to vmte_l2_addr or something? (Although reading on I see tmp
is used more often.. so maybe it's consistent here)

> +	WRITE_ONCE(vmt_info->l2.vmt_base[l1_index], cpu_to_le64(tmp));
> +
> +	vgic_v5_clean_inval(l2_table, GICV5_VMT_L2_TABLE_SIZE, true, true);
> +	/* Skip inval for now - wait until table is made valid by HW */
> +	vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
> +			    sizeof(vmtl1_entry), true, false);
> +
> +	/* VMAP in the L2 VMT via the IRS */
> +	cmd_info.cmd_type = VMT_L2_MAP;
> +	ret = irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu0), &cmd_info);
> +
> +	/* We've failed to make the L2 VMT valid - things are very broken! */
> +	if (ret) {
> +		/* Remove the pointer from L1 table */
> +		WRITE_ONCE(vmt_info->l2.vmt_base[l1_index], 0);
> +
> +		kfree(l2_table);
> +		vmt_info->l2.l2ptrs[l1_index] = NULL;
> +
> +		return ret;
> +	}
> +
> +	/* Table updated; inval our copy */
> +	vgic_v5_clean_inval(vmt_info->l2.vmt_base + l1_index,
> +			    sizeof(vmtl1_entry), false, true);
> +
> +	return ret;
> +}
> +
> +/*
> + * Allocate the top-level VMT. This can either be linear or two-level.
> + */
> +int vgic_v5_vmt_allocate(bool two_level, unsigned int num_entries,
> +			 size_t vmd_size, size_t vped_size,
> +			 unsigned int max_vpes)
> +{
> +	int ret = 0;
> +
> +	if (vgic_v5_vmt_allocated())
> +		return -EBUSY;
> +
> +	/* VMD is optional; using 0 to signal that it not needed. */
> +	if (vmd_size != 0 &&
> +	    (vmd_size < VMD_MIN_SIZE || vmd_size > VMD_MAX_SIZE))
> +		return -EINVAL;
> +
> +	if (vped_size < VPED_MIN_SIZE || vped_size > VPED_MAX_SIZE)
> +		return -EINVAL;
> +
> +	/* Allocate the tracking structure */
> +	vmt_info = kzalloc_obj(*vmt_info, GFP_KERNEL);
> +	if (vmt_info == NULL)
> +		return -ENOMEM;
> +
> +	ida_init(&vmt_info->vm_id_ida);
> +	vmt_info->max_vpes = max_vpes;
> +	vmt_info->vmd_size = vmd_size;
> +	vmt_info->vped_size = vped_size;
> +	vmt_info->two_level = two_level;
> +	vmt_info->num_entries = num_entries;
> +
> +	if (!two_level)
> +		ret = vgic_v5_alloc_vmt_linear(num_entries);
> +	else
> +		ret = vgic_v5_alloc_vmt_two_level(num_entries);
> +
> +	/* If anything failed, free our tracking structure before returning */
> +	if (ret) {
> +		kfree(vmt_info);
> +		vmt_info = NULL;
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * Free the VMT and associated tracking structures. This isn't strictly expected
> + * to be called in general operation, but instead exists for completeness.
> + */
> +int vgic_v5_vmt_free(void)
> +{
> +	if (!vgic_v5_vmt_allocated())
> +		return -EINVAL;
> +
> +	if (!vmt_info->two_level) {
> +		kfree(vmt_info->linear.vmt_base);
> +	} else {
> +		/* Free the L2 tables; kfree(NULL) is safe */
> +		for (int i = 0; i < vmt_info->l2.num_l1_ents; ++i)
> +			kfree(vmt_info->l2.l2ptrs[i]);
> +		kfree(vmt_info->l2.l2ptrs);
> +
> +		/* And now free the L1 table */
> +		kfree(vmt_info->l2.vmt_base);
> +	}
> +
> +	ida_destroy(&vmt_info->vm_id_ida);
> +	kfree(vmt_info);
> +	vmt_info = NULL;
> +
> +	return 0;
> +}
> +
> +/*
> + * Look up a VMT Entry by VM ID.
> + */
> +static int vgic_v5_get_l2_vmte(u16 vm_id, struct vmtl2_entry **vmte)
> +{
> +	unsigned int l1_index, l2_index;
> +	struct vmtl2_entry *l2_table;
> +	int ret;
> +
> +	ret = vgic_v5_check_vm_id(vm_id);
> +	if (ret)
> +		return ret;
> +
> +	if (!vmt_info->two_level) {
> +		/* All entries always valid for Linear table */
> +		*vmte = &vmt_info->linear.vmt_base[vm_id];
> +	} else {
> +		l1_index = vm_id / GICV5_VMT_L2_TABLE_ENTRIES;
> +		l2_index = vm_id % GICV5_VMT_L2_TABLE_ENTRIES;
> +
> +		if (l1_index > vmt_info->l2.num_l1_ents)
> +			return -E2BIG;
> +
> +		if (vmt_info->l2.l2ptrs[l1_index] == NULL)
> +			return -EINVAL;
> +
> +		l2_table = vmt_info->l2.l2ptrs[l1_index];
> +		*vmte = &l2_table[l2_index];
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Zero a VMT Entry, and flush & invalidate to the PoC, if required.
> + */
> +static int vgic_v5_reset_vmte(struct kvm *kvm)
> +{
> +	u16 vm_id = vgic_v5_vm_id(kvm);
> +	struct vmtl2_entry *vmte;
> +	int ret;
> +
> +	ret = vgic_v5_get_l2_vmte(vm_id, &vmte);
> +	if (ret)
> +		return ret;
> +
> +	WRITE_ONCE(vmte->val[0], 0ULL);
> +	WRITE_ONCE(vmte->val[1], 0ULL);
> +	WRITE_ONCE(vmte->val[2], 0ULL);
> +	WRITE_ONCE(vmte->val[3], 0ULL);
> +
> +	vgic_v5_clean_inval(vmte, sizeof(*vmte), true, true);
> +
> +	return 0;
> +}
> +
> +/*
> + * Use the IDA to allocate a new VM ID, and track it in the gicv5_vm data
> + * structure. If we're out of VM IDs, the IDA catches that, and we return the
> + * error (-ENOSPC).
> + */
> +int vgic_v5_allocate_vm_id(struct kvm *kvm)
> +{
> +	int id;
> +
> +	id = ida_alloc_max(&vmt_info->vm_id_ida, vmt_info->num_entries - 1u,
> +			   GFP_KERNEL);
> +	if (id < 0)
> +		return id;
> +
> +	kvm->arch.vgic.gicv5_vm.vm_id = id;
> +	kvm->arch.vgic.gicv5_vm.vm_id_valid = true;
> +
> +	return 0;
> +}
> +
> +/*
> + * Release the VM ID to allow it to be reallocated in the future.
> + */
> +void vgic_v5_release_vm_id(struct kvm *kvm)
> +{
> +	ida_free(&vmt_info->vm_id_ida, kvm->arch.vgic.gicv5_vm.vm_id);
> +	kvm->arch.vgic.gicv5_vm.vm_id_valid = false;
> +}
> +
> +/*
> + * Initialise an entry in the VMT based on the index of the VM.
> + *
> + * Note: We don't mark the VMTE as valid as this needs to be done by
> + * the hardware.
> + */
> +int vgic_v5_vmte_init(struct kvm *kvm)
> +{
> +	int nr_cpus = atomic_read(&kvm->online_vcpus);
> +	struct vgic_v5_vm_info *vmi = NULL;
> +	u16 vm_id = vgic_v5_vm_id(kvm);
> +	void *vmd = NULL, *vpet = NULL;
> +	struct vmtl2_entry *vmte;
> +	void **vped_ptrs = NULL;
> +	size_t vpet_alloc_size;
> +	int ret;
> +	u64 tmp;
> +
> +	if (nr_cpus > vmt_info->max_vpes)
> +		return -E2BIG;
> +
> +	/*
> +	 * If we're using two-level VMTs, L2 is allocated on demand. For linear
> +	 * VMTs, this is a NOP.
> +	 */
> +	if (vgic_v5_alloc_l2_vmt(kvm))
> +		return -EIO;
> +
> +	ret = vgic_v5_get_l2_vmte(vm_id, &vmte);
> +	if (ret)
> +		return ret;
> +
> +	/* If the entry is already valid, something went wrong */
> +	if (FIELD_GET(GICV5_VMTEL2E_VALID, le64_to_cpu(READ_ONCE(vmte->val[0])))) {
> +		vgic_v5_clean_inval(vmte, sizeof(*vmte), true, true);
> +		return -EINVAL;
> +	}
> +
> +	ret = vgic_v5_reset_vmte(kvm);
> +	if (ret)
> +		return ret;
> +
> +	vmi = kzalloc_objs(*vmi, GFP_KERNEL);
> +	if (vmi == NULL) {
> +		ret = -ENOMEM;
> +		goto out_fail;
> +	}
> +
> +	ret = xa_insert(&vm_info, vm_id, vmi, GFP_KERNEL);
> +	if (ret)
> +		goto out_fail;
> +
> +	/* Allocate and assign the VM Descriptor, if required. */
> +	if (vmt_info->vmd_size != 0) {
> +		vmd = kzalloc(vmt_info->vmd_size, GFP_KERNEL);
> +		if (!vmd) {
> +			ret = -ENOMEM;
> +			goto out_fail;
> +		}
> +
> +		/* Stash the VA so we can free it later */
> +		vmi->vmd_base = vmd;
> +
> +		tmp = FIELD_PREP(GICV5_VMTEL2E_VMD_ADDR,
> +				virt_to_phys(vmd) >>
> +				GICV5_VMTEL2E_VMD_ADDR_SHIFT);
> +		WRITE_ONCE(vmte->val[0], cpu_to_le64(tmp));
> +	}
> +
> +	/*
> +	 * Allocate and assign the VPE Table. We can only describe the number of
> +	 * VPE ID Bits in the VMTE, and therefore we round up the number of CPUs
> +	 * to a whole power of two.

This comment is a bit confusing, would try reword it somewhere along the lines of:

     Round up the number of CPUs to a whole power of two, as the VMTE describes the ID bits as log2()

Something like that. "We can only describe the number of VPE ID Bits in the
VMTE", the emphasis on 'Bits' is hard to make out.

> +	 */
> +	nr_cpus = roundup_pow_of_two(nr_cpus);
> +	vmi->vpe_id_bits = fls(nr_cpus) - 1;
> +
> +	vpet_alloc_size = sizeof(vpe_entry) * nr_cpus;
> +	vpet = kzalloc(vpet_alloc_size, GFP_KERNEL);

kzalloc_objs()? Or is there some alignment thing here?

> +	if (!vpet) {
> +		ret = -ENOMEM;
> +		goto out_fail;
> +	}
> +
> +	/* Stash the VA so we can free it later */
> +	vmi->vpet_base = vpet;
> +
> +	tmp = FIELD_PREP(GICV5_VMTEL2E_VPET_ADDR,
> +			virt_to_phys(vpet) >> GICV5_VMTEL2E_VPET_ADDR_SHIFT);
> +	tmp |= FIELD_PREP(GICV5_VMTEL2E_VPE_ID_BITS, vmi->vpe_id_bits);
> +	WRITE_ONCE(vmte->val[1], cpu_to_le64(tmp));
> +
> +	vped_ptrs = kzalloc_objs(*vped_ptrs, nr_cpus, GFP_KERNEL);
> +	if (vped_ptrs == NULL) {
> +		ret = -ENOMEM;
> +		goto out_fail;
> +	}
> +	vmi->vped_ptrs = vped_ptrs;
> +
> +	if (vmd)
> +		vgic_v5_clean_inval(vmd, vmt_info->vmd_size, true, true);
> +	vgic_v5_clean_inval(vpet, vpet_alloc_size, true, true);
> +	vgic_v5_clean_inval(vmte, sizeof(*vmte), true, true);
> +
> +	kvm->arch.vgic.gicv5_vm.vmte_allocated = true;
> +
> +	return 0;
> +
> +out_fail:
> +	/* kfree(NULL) is safe so we can just kfree() at leisure */
> +	kfree(vmd);
> +	kfree(vpet);
> +	kfree(vped_ptrs);
> +	if (vmi)
> +		xa_erase(&vm_info, vm_id);
> +	kfree(vmi);
> +
> +	vgic_v5_reset_vmte(kvm);
> +
> +	return ret;
> +}
> +
> +/*
> + * Release the VMT Entry, freeing up any allocated data structures before
> + * zeroing the VMTE.
> + *
> + * The VMTE must be marked as invalid before it is released.
> + */
> +int vgic_v5_vmte_release(struct kvm *kvm)
> +{
> +	u16 vm_id = vgic_v5_vm_id(kvm);
> +	struct vgic_v5_vm_info *vmi;
> +	struct vmtl2_entry *vmte;
> +	int ret;
> +
> +	ret = vgic_v5_get_l2_vmte(vm_id, &vmte);
> +	if (ret)
> +		return ret;
> +
> +	/* Reject if the VMTE has not been marked as invalid! */
> +	if (FIELD_GET(GICV5_VMTEL2E_VALID, le64_to_cpu(READ_ONCE(vmte->val[0])))) {
> +		vgic_v5_clean_inval(vmte, sizeof(*vmte), true, true);
> +		return -EINVAL;
> +	}
> +
> +	vmi = xa_load(&vm_info, vm_id);
> +	if (WARN_ON_ONCE(!vmi))
> +		goto no_vmi;
> +
> +	kfree(vmi->vmd_base);
> +	kfree(vmi->vpet_base);
> +
> +	xa_erase(&vm_info, vm_id);
> +	kfree(vmi);
> +
> +no_vmi:
> +	/*
> +	 * If we didn't get far enough into allocating a VMTE to create the VM
> +	 * info structure, then we just zero the VMTE and move on. There's
> +	 * nothing else we can realistically do here.
> +	 */
> +	ret = vgic_v5_reset_vmte(kvm);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +/*
> + * Allocate a VPE descriptor and provide it to the hardware via the VPE Table.
> + */
> +int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu)
> +{
> +	u16 vm_id = vgic_v5_vm_id(vcpu->kvm);
> +	u16 vpe_id = vgic_v5_vpe_id(vcpu);
> +	struct vgic_v5_vm_info *vmi;
> +	vpe_entry tmp, *vpet_base;
> +	void *vped;
> +
> +	/* Make sure we're not over what the hardware supports */
> +	if (vpe_id >= vmt_info->max_vpes)
> +		return -E2BIG;
> +
> +	vmi = xa_load(&vm_info, vm_id);
> +	if (WARN_ON_ONCE(!vmi))
> +		return -EINVAL;
> +
> +	if (vpe_id >= 1 << vmi->vpe_id_bits)
> +		return -E2BIG;
> +
> +	vpet_base = vmi->vpet_base;
> +
> +	/* If the VPETE for this CPU is already valid we've gone wrong */
> +	if (FIELD_GET(GICV5_VPE_VALID, le64_to_cpu(READ_ONCE(vpet_base[vpe_id])))) {
> +		vgic_v5_clean_inval(&vpet_base[vpe_id], sizeof(*vpet_base), true, true);
> +		return -EBUSY;
> +	}
> +
> +	/* Alloc VPE Descriptor. Only used by IRS. */
> +	vped = kzalloc(vmt_info->vped_size, GFP_KERNEL);
> +	if (vped == NULL)
> +		return -ENOMEM;
> +
> +	vmi->vped_ptrs[vpe_id] = vped;
> +
> +	tmp = FIELD_PREP(GICV5_VPED_ADDR, virt_to_phys(vped) >> GICV5_VPED_ADDR_SHIFT);
> +	WRITE_ONCE(vpet_base[vpe_id], cpu_to_le64(tmp));
> +
> +	vgic_v5_clean_inval(vped, vmt_info->vped_size, true, true);
> +	vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry), true, true);
> +
> +	return 0;
> +}
> +
> +/*
> + * Free the memory allocated for the VPE descriptor.
> + */
> +int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu)
> +{
> +	u16 vm_id = vgic_v5_vm_id(vcpu->kvm);
> +	u16 vpe_id = vgic_v5_vpe_id(vcpu);
> +	struct vgic_v5_vm_info *vmi;
> +	struct vmtl2_entry *vmte;
> +	vpe_entry *vpet_base;
> +	void *vped;
> +	int ret;
> +
> +	ret = vgic_v5_get_l2_vmte(vm_id, &vmte);
> +	if (ret)
> +		return ret;
> +
> +	if (FIELD_GET(GICV5_VMTEL2E_VALID, le64_to_cpu(READ_ONCE(vmte->val[0])))) {
> +		vgic_v5_clean_inval(vmte, sizeof(*vmte), true, true);
> +		return -EBUSY;
> +	}
> +
> +	vmi = xa_load(&vm_info, vm_id);
> +	if (!vmi)
> +		return -EINVAL;
> +
> +	if (vpe_id >= 1 << vmi->vpe_id_bits)
> +		return -E2BIG;
> +
> +	vpet_base = vmi->vpet_base;
> +	WRITE_ONCE(vpet_base[vpe_id], 0ULL);
> +
> +	vgic_v5_clean_inval(vpet_base + vpe_id, sizeof(vpe_entry), true, true);
> +
> +	/* Free VPE Descriptor. Only used by IRS. */
> +	vped = vmi->vped_ptrs[vpe_id];
> +	vmi->vped_ptrs[vpe_id] = NULL;
> +	kfree(vped);
> +
> +	return 0;
> +}
> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgic-v5-tables.h
> index cf00a248eabd5..5501a44308362 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
> @@ -8,6 +8,86 @@
>  
>  #include <linux/irqchip/arm-gic-v5.h>
>  
> +#define VM_ID_BITS_MIN	8
> +#define VM_ID_BITS_MAX	16
> +#define VMD_MIN_SIZE	8
> +#define VMD_MAX_SIZE	4096
> +#define VPED_MIN_SIZE	8
> +#define VPED_MAX_SIZE	4096
> +#define VPE_ID_BITS_MIN	8
> +#define VPE_ID_BITS_MAX	16
> +
> +/* Level 1 Virtual Machine Table Entry */
> +typedef __le64 vmtl1_entry;
> +#define GICV5_VMTEL1E_VALID		BIT_ULL(0)
> +/* Note that there is no shift for the address by design */
> +#define GICV5_VMTEL1E_L2_ADDR		GENMASK(51, 12)
> +
> +#define GICV5_VMTEL2E_SIZE		32ULL
> +/* An L2 table (two-level VMT) is ALWAYS 4kB! */
> +#define GICV5_VMT_L2_TABLE_SIZE		4096ULL
> +#define GICV5_VMT_L2_TABLE_ENTRIES	(GICV5_VMT_L2_TABLE_SIZE / GICV5_VMTEL2E_SIZE)
> +
> +/* Level 2 Virtual Machine Table Entry */
> +struct vmtl2_entry {
> +	__le64 val[4];
> +};
> +
> +/*
> + * As the L2 VMTE is a large data structure, we are splitting it into 4 parts.
> + * We only mask and shift WITHIN each part for simplicity.
> + */
> +/* First 64-bit chunk */
> +#define GICV5_VMTEL2E_VALID		BIT_ULL(0)
> +#define GICV5_VMTEL2E_VMD_ADDR_SHIFT	3ULL
> +#define GICV5_VMTEL2E_VMD_ADDR		GENMASK_ULL(55, 3)
> +/* Second 64-bit chunk */
> +#define GICV5_VMTEL2E_VPET_ADDR_SHIFT	3ULL
> +#define GICV5_VMTEL2E_VPET_ADDR		GENMASK_ULL(55, 3)
> +#define GICV5_VMTEL2E_VPE_ID_BITS	GENMASK_ULL(63, 59)
> +/* Third & fourth 64-bit chunks (the encodings are the same for each) */
> +#define GICV5_VMTEL2E_IST_VALID		BIT_ULL(0)
> +#define GICV5_VMTEL2E_IST_L2SZ		GENMASK_ULL(2, 1)
> +#define GICV5_VMTEL2E_IST_ADDR_SHIFT	6ULL
> +#define GICV5_VMTEL2E_IST_ADDR		GENMASK_ULL(55, 6)
> +#define GICV5_VMTEL2E_IST_ISTSZ		GENMASK_ULL(57, 56)
> +#define GICV5_VMTEL2E_IST_STRUCTURE	BIT_ULL(58)
> +#define GICV5_VMTEL2E_IST_ID_BITS	GENMASK_ULL(63, 59)
> +
> +/* Virtual PE Table Entry */
> +typedef __le64 vpe_entry;
> +#define GICV5_VPE_VALID			BIT_ULL(0)
> +/* Note that there is no shift for the address by design. */
> +#define GICV5_VPED_ADDR_SHIFT		3ULL
> +#define GICV5_VPED_ADDR			GENMASK_ULL(55, 3)
> +
> +struct vgic_v5_vm_info {
> +	void __iomem		*vmd_base;
> +	vpe_entry __iomem	*vpet_base;
> +	void __iomem		**vped_ptrs;
> +	u8			vpe_id_bits;
> +};
> +
> +struct vgic_v5_vmt {
> +	union {
> +		struct {
> +			struct vmtl2_entry *vmt_base;
> +			unsigned int num_ents;
> +		} linear;
> +		struct {
> +			vmtl1_entry *vmt_base;
> +			struct vmtl2_entry **l2ptrs;
> +			unsigned int num_l1_ents;
> +		} l2;
> +	};
> +	bool		two_level;
> +	unsigned int	num_entries;
> +	unsigned int	max_vpes;
> +	size_t		vmd_size;
> +	size_t		vped_size;
> +	struct ida	vm_id_ida;
> +};
> +
>  struct vgic_v5_host_ist_caps {
>  	/* IST Capabilities */
>  
> @@ -38,4 +118,32 @@ static inline struct vgic_v5_host_ist_caps *vgic_v5_host_caps(void)
>  	return &gicv5_host_ist_caps;
>  }
>  
> +static inline u16 vgic_v5_vm_id(struct kvm *kvm)
> +{
> +	return kvm->arch.vgic.gicv5_vm.vm_id;
> +}
> +
> +static inline u16 vgic_v5_vpe_id(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->vcpu_id;
> +}
> +
> +static inline int vgic_v5_vpe_db(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.vgic_cpu.vgic_v5.gicv5_vpe.db;
> +}
> +
> +int vgic_v5_vmt_allocate(bool two_level, unsigned int num_entries,
> +			 size_t vmd_size, size_t vped_size,
> +			 unsigned int vpe_id_bits);
> +int vgic_v5_vmt_free(void);
> +
> +int vgic_v5_allocate_vm_id(struct kvm *kvm);
> +void vgic_v5_release_vm_id(struct kvm *kvm);
> +
> +int vgic_v5_vmte_init(struct kvm *kvm);
> +int vgic_v5_vmte_release(struct kvm *kvm);
> +int vgic_v5_vmte_alloc_vpe(struct kvm_vcpu *vcpu);
> +int vgic_v5_vmte_free_vpe(struct kvm_vcpu *vcpu);
> +
>  #endif
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 05dbd01f6fd21..0bcbc751593cc 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -372,6 +372,8 @@ struct vgic_v5_vm {
>  	int			vpe_db_base;
>  	int			nr_vpes;
>  	u16			vm_id;
> +	bool			vm_id_valid;
> +	bool			vmte_allocated;
>  };
>  
>  struct vgic_dist {
> diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm-gic-v5.h
> index 087d94f739672..89579ee04f5d1 100644
> --- a/include/linux/irqchip/arm-gic-v5.h
> +++ b/include/linux/irqchip/arm-gic-v5.h
> @@ -182,6 +182,7 @@
>  #define GICV5_IRS_MAP_L2_ISTR_ID	GENMASK(23, 0)
>  
>  #define GICV5_ISTL1E_VALID		BIT_ULL(0)
> +#define GICV5_IRS_ISTL1E_SIZE		8UL
>  
>  #define GICV5_ISTL1E_L2_ADDR_MASK	GENMASK_ULL(55, 12)
>  
> @@ -444,4 +445,16 @@ void gicv5_free_lpi(u32 lpi);
>  
>  void __init gicv5_its_of_probe(struct device_node *parent);
>  void __init gicv5_its_acpi_probe(void);
> +
> +enum gicv5_vcpu_info_cmd_type {
> +	VMT_L2_MAP,		/* Map in a L2 VMT - *may* happen on VM init */
> +	VMTE_MAKE_VALID,	/* Make the VMTE valid */
> +	VMTE_MAKE_INVALID,	/* Make the VMTE (et al.) invalid */
> +};
> +
> +struct gicv5_cmd_info {
> +	enum gicv5_vcpu_info_cmd_type	cmd_type;
> +	u64				data;
> +};
> +
>  #endif

Thanks,
Joey
