Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19792E2DD2
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 01:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786669579; cv=none; b=EV3w8f/O9mMyb3859EkPzJpfwacTCqo8dhuKrCzrVtQFRtXbPTDibHGiLgELmPydWCLkp+pJdawgjbwaoKUrJ6BoeJmoNH9EjCHR8g2b3sjsVpgLJSLNrs9tDQL9b2CTy8tbutt/yx3HLZDMCvaCr2GIP1lKk0Cwj8ehkYV+kwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786669579; c=relaxed/simple;
	bh=sffRl33pdGL49NgPZjdmSfcZBvI4FnHLaHvcv+SvHnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tC8KKR1EiPK5T5DIf5QVuu1M75iXi/5+VpZfmtIJFxmQK6f39NtbQCDZ07iWQs2XQ/Jh31C+w+/OZ+R21OSz1QbEr8Gt8GO/TUlu0Tg+SOoa9VJ4XxtS2W9JojAM3h3rD8xL7BPVN2u2x495k7wYnf/Afr1IkbBOkGqQSxX5AHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=D9oF68rO; arc=none smtp.client-ip=207.54.90.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="D9oF68rO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1786669576; x=1818205576;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sffRl33pdGL49NgPZjdmSfcZBvI4FnHLaHvcv+SvHnw=;
  b=D9oF68rOjgBtONwVeuvg8gc4mN4LHA8WUq6y1jld9g2m/VhaMkS3j1bD
   azg7PGFxVc977wFuETC/vnCxRBqgb0Eqhz9EPONrQamEZTrVCWKZ7Xw64
   SNpcK+/b0u4q1JF4+pB9PCFZJDd8LSw3hE/MK+bdZNjyUy5ne1yPQy1uE
   EFq+QAcED0BeyfWMvHoAOoc//HpaZwkL7c792TaSsfZ//DAgQ2EVKBoad
   j4d9Z5N9zEmr53Put+76XYmeJDG/buTKOR/b2j1uRgV4+9NIZ6WToOiy+
   Uw1l8JxHIV63j94oJa4UmtnpwWs/Xo2r6ZeFWPf7sKbkgSWSTRMyoo3XJ
   w==;
X-CSE-ConnectionGUID: 9SYmdZ1wTO2gMnTeYJQZvg==
X-CSE-MsgGUID: u9Uzn6TZTwOecYTPCdiXJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="250940380"
X-IronPort-AV: E=Sophos;i="6.25,222,1779116400"; 
   d="scan'208";a="250940380"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 10:05:05 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 4B58F100037B
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 01:05:05 +0000 (UTC)
Received: from az2nlsmom1.o.css.fujitsu.com (unknown [10.150.26.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id EF96C1C00951
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 01:05:04 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom1.o.css.fujitsu.com (Postfix) with ESMTPS id 39E82826FD3;
	Fri, 14 Aug 2026 01:04:59 +0000 (UTC)
Date: Fri, 14 Aug 2026 10:04:57 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [PATCH v5 2/6] KVM: arm64: nv: Introduce guest stage-2 tracking
 structures
Message-ID: <an5puT6fe3lOMY4Q@sm-arm-grace07>
References: <20260810205038.118843-1-weilin.chang@arm.com>
 <20260810205038.118843-3-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810205038.118843-3-weilin.chang@arm.com>

On Mon, Aug 10, 2026 at 09:50:34PM +0100, Wei-Lin Chang wrote:
> In order to avoid unmapping all shadow stage-2 mappings when KVM
> receives a MMU notifier unmap call, we have to keep track of the
> canonical IPA -> nested IPA relationship of the shadow mappings
> created. This essentially means tracking the guest's stage-2.
> 
> To do this, represent each mapping by struct kvm_guest_s2_mapping. It
> stores the mapping's canonical IPA range and the nested IPA range using
> two interval tree nodes. Both nodes will be inserted into their
> respective interval trees called guest_s2_mappings. The canonical IPA
> ranges will be stored in the tree within the canonical MMU, and the
> nested IPA ranges will be stored in the corresponding nested MMU's tree.
> 
> For example:
> 
> struct kvm_guest_s2_mapping mapping1, mapping2;
> 
>     ---------------------> mapping2.canonical
>     |                      mapping1.canonical
>     |                          ^   (both stored in canonical mmu's tree)
>     |                          |
> --*****-----------------------*****----------- CIPA
>    \\\\\                      |||||                  mapping1.nested_mmu
>     \\\\\                     \\\\\                            |
>      \\\\\                     \\\\\                           v
> ------\\\\\---------------------*****--------- NIPA #1 (nested mmu #1)
>        \\\\\                      |
>         \\\\\                     -> mapping1.nested
>          \\\\\                       (stored in nested mmu #1's tree)
>           \\\\\
> -----------*****------------------------------ NIPA #2 (nested mmu #2)
>              |                                                 ^
>              -> mapping2.nested                                |
>                 (stored in nested mmu #2's tree)   mapping2.nested_mmu
> 
> Using the trees we can look up nodes in either of the IPA spaces, and
> for each node, find the corresponding range in the other IPA space from
> the other node in the enclosing kvm_guest_s2_mapping.
> 
> Define kvm_guest_s2_mapping and the interval tree here. Guest stage-2
> mapping tracking will come in subsequent patches.
> 
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 17 +++++++++++++++++
>  arch/arm64/kvm/mmu.c              | 30 ++++++++++++++++++++++++++++++
>  arch/arm64/kvm/nested.c           |  1 +
>  3 files changed, 48 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index bae2c4f92ef5..0695c4ef93f1 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -14,6 +14,7 @@
>  #include <linux/arm-smccc.h>
>  #include <linux/bitmap.h>
>  #include <linux/types.h>
> +#include <linux/interval_tree.h>
>  #include <linux/jump_label.h>
>  #include <linux/kvm_types.h>
>  #include <linux/maple_tree.h>
> @@ -150,6 +151,16 @@ struct kvm_vmid {
>  	atomic64_t id;
>  };
>  
> +/*
> + * Record of a guest stage-2 mapping, storing canonical and nested IPA
> + * ranges. Both ranges have the same size.
> + */
> +struct kvm_guest_s2_mapping {
> +	struct interval_tree_node canonical;
> +	struct interval_tree_node nested;
> +	struct kvm_s2_mmu *nested_mmu;
> +};

Is this to be used for normal (L1) guests? I guess this series is for
shadow stage 2 unmapping optimization, so not sure.

Thanks,
Itaru.

> +
>  struct kvm_s2_mmu {
>  	struct kvm_vmid vmid;
>  
> @@ -227,6 +238,9 @@ struct kvm_s2_mmu {
>  	 */
>  	bool	pending_unmap;
>  
> +	/* Guest s2 mapping records indexed in this MMU's IPA space. */
> +	struct rb_root_cached guest_s2_mappings;
> +
>  	/*
>  	 *  0: Nobody is currently using this, check vttbr for validity
>  	 * >0: Somebody is actively using this.
> @@ -326,6 +340,9 @@ struct kvm_arch {
>  	size_t nested_mmus_size;
>  	int nested_mmus_next;
>  
> +	/* Guest s2 tracking trees access serialization. */
> +	spinlock_t guest_s2_tracking_lock;
> +
>  	/* Interrupt controller */
>  	struct vgic_dist	vgic;
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 336dd8f7e8ab..59b4f583240e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -7,6 +7,7 @@
>  #include <linux/acpi.h>
>  #include <linux/mman.h>
>  #include <linux/kvm_host.h>
> +#include <linux/interval_tree.h>
>  #include <linux/io.h>
>  #include <linux/hugetlb.h>
>  #include <linux/sched/signal.h>
> @@ -1033,6 +1034,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>  
>  	mmu->pgd_phys = __pa(pgt->pgd);
>  
> +	mmu->guest_s2_mappings = RB_ROOT_CACHED;
> +
>  	if (kvm_is_nested_s2_mmu(kvm, mmu))
>  		kvm_init_nested_s2_mmu(mmu);
>  
> @@ -1122,10 +1125,32 @@ void stage2_unmap_vm(struct kvm *kvm)
>  	srcu_read_unlock(&kvm->srcu, idx);
>  }
>  
> +static void guest_s2_tracking_destroy(struct kvm_s2_mmu *mmu,
> +				      struct rb_root_cached *tree)
> +{
> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> +	struct kvm_guest_s2_mapping *mapping;
> +	struct interval_tree_node *node;
> +
> +	while ((node = interval_tree_iter_first(tree, 0, ULONG_MAX))) {
> +		interval_tree_remove(node, tree);
> +
> +		if (!kvm_is_nested_s2_mmu(kvm, mmu)) {
> +			mapping = container_of(node, struct kvm_guest_s2_mapping,
> +					       canonical);
> +			/* The canonical MMU is destroyed after the nested MMUs. */
> +			kfree(mapping);
> +		}
> +
> +		cond_resched();
> +	}
> +}
> +
>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>  	struct kvm_pgtable *pgt = NULL;
> +	struct rb_root_cached mappings_tree;
>  
>  	write_lock(&kvm->mmu_lock);
>  	pgt = mmu->pgt;
> @@ -1138,12 +1163,17 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  	if (kvm_is_nested_s2_mmu(kvm, mmu))
>  		kvm_init_nested_s2_mmu(mmu);
>  
> +	mappings_tree = mmu->guest_s2_mappings;
> +	mmu->guest_s2_mappings = RB_ROOT_CACHED;
> +
>  	write_unlock(&kvm->mmu_lock);
>  
>  	if (pgt) {
>  		kvm_stage2_destroy(pgt);
>  		kfree(pgt);
>  	}
> +
> +	guest_s2_tracking_destroy(mmu, &mappings_tree);
>  }
>  
>  static void hyp_mc_free_fn(void *addr, void *mc)
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index dfb96edbdc43..744aacba61ae 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -49,6 +49,7 @@ void kvm_init_nested(struct kvm *kvm)
>  	kvm->arch.nested_mmus = NULL;
>  	kvm->arch.nested_mmus_size = 0;
>  	atomic_set(&kvm->arch.vncr_map_count, 0);
> +	spin_lock_init(&kvm->arch.guest_s2_tracking_lock);
>  }
>  
>  static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
> -- 
> 2.43.0
> 
