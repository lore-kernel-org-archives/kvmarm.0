Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730402D0292;
	Tue, 14 Jul 2026 04:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784003960; cv=none; b=gKLolkFASKrB4lj28W0mo7dn5+AJy8HlV75sKXeOY8tzn/vyNaGPmXsqNOucedZhGyjwOUDQycJCJTl9r+hxXbV+X8xYaOhPAuaPjNZxMV4p3P63JLFeaJ8a2NCN7RGvJBf0k35HxEKebDRB6lfQGvLEeKKXTPQrG1wgf3wzN8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784003960; c=relaxed/simple;
	bh=BPU73LTHJbaq71XFkCqH3AwjSkNrNo1hdXLT5odg614=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMKMoNZe1fxaecoAk8MUfRJBOyVJ23l2auOfsSAjMMnu8uQzWG/wk3UOmpAbG9VYFUc6o2BqCeHFAkOxFo1v4UEzXllKPfrKi39pkf6li5qQExP9yUwBqoKmjOOK7+RifkDgRmHYaimRS/nM3a2rhvV4TZPWiEWZoLnRFFo07KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=YLBcQvAp; arc=none smtp.client-ip=68.232.139.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="YLBcQvAp"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1784003958; x=1815539958;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BPU73LTHJbaq71XFkCqH3AwjSkNrNo1hdXLT5odg614=;
  b=YLBcQvApRtg0g1QG1eUA/rr9h/sCv5PzYVSzhYG/xO3ljc9en9pr7Rnz
   fHcNMHwd+g/9jS/Amz1f5eBxj3QTVcr61l+kz3EdSxzSz33o3Hcv9GBNb
   sInkpamQqNnwLvJ98vT7/FW+QUkab4DTK/xwbEqEWydf1fvpmNIh/aBbJ
   UWLl0gAJacPoqlXT/eJ2a7AI/+4F0AND4cg1l+NIAnBWbKoyz2DKeqe31
   b1yypymjJWkHCXCkZEaLLKBTPyOYKDFbcwq7sSnpDcm5kO+yNWDYi3SQ6
   elzcs+ScaT3EG5DyKGu98quKMbsNvfJlIu5v74DXQybZ0lOp0UYk713gJ
   A==;
X-CSE-ConnectionGUID: oBm/wRA2SS6Zz34cU94YfA==
X-CSE-MsgGUID: qOuLjlcMTMisoOZbllHnvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="246775333"
X-IronPort-AV: E=Sophos;i="6.25,163,1779116400"; 
   d="scan'208";a="246775333"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 13:38:03 +0900
Received: from az2nlsmgm4.fujitsu.com (unknown [10.150.26.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 981421000374;
	Tue, 14 Jul 2026 04:38:03 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm4.fujitsu.com (Postfix) with ESMTPS id 498661000262;
	Tue, 14 Jul 2026 04:38:03 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.86.149])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with SMTP id EE48E1800B39;
	Tue, 14 Jul 2026 04:37:54 +0000 (UTC)
Date: Tue, 14 Jul 2026 13:37:52 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
Subject: Re: [PATCH v14 26/44] arm64: RMI: Allow populating initial contents
Message-ID: <alWzvLK1RRotK1LL@FCCLS0092175.localdomain>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-27-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260513131757.116630-27-steven.price@arm.com>

On 05/13 14:17, Steven Price wrote:
> The VMM needs to populate the realm with some data before starting (e.g.
> a kernel and initrd). This is measured by the RMM and used as part of
> the attestation later on.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v13:
>  * Rename realm_create_protected_data_page() to realm_data_map_init().
> Changes since v12:
>  * The ioctl now updates the structure with the amount populated rather
>    than returning this through the ioctl return code.
>  * Use the new RMM v2.0 range based RMI calls.
>  * Adapt to upstream changes in kvm_gmem_populate().
> Changes since v11:
>  * The multiplex CAP is gone and there's a new ioctl which makes use of
>    the generic kvm_gmem_populate() functionality.
> Changes since v7:
>  * Improve the error codes.
>  * Other minor changes from review.
> Changes since v6:
>  * Handle host potentially having a larger page size than the RMM
>    granule.
>  * Drop historic "par" (protected address range) from
>    populate_par_region() - it doesn't exist within the current
>    architecture.
>  * Add a cond_resched() call in kvm_populate_realm().
> Changes since v5:
>  * Refactor to use PFNs rather than tracking struct page in
>    realm_create_protected_data_page().
>  * Pull changes from a later patch (in the v5 series) for accessing
>    pages from a guest memfd.
>  * Do the populate in chunks to avoid holding locks for too long and
>    triggering RCU stall warnings.
> ---
>  arch/arm64/include/asm/kvm_rmi.h |   4 ++
>  arch/arm64/kvm/Kconfig           |   1 +
>  arch/arm64/kvm/arm.c             |  13 ++++
>  arch/arm64/kvm/rmi.c             | 106 +++++++++++++++++++++++++++++++
>  4 files changed, 124 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 007249a13dbc..a2b6bc412a22 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -88,6 +88,10 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu);
>  int kvm_rec_pre_enter(struct kvm_vcpu *vcpu);
>  int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>  
> +struct kvm_arm_rmi_populate;
> +
> +int kvm_arm_rmi_populate(struct kvm *kvm,
> +			 struct kvm_arm_rmi_populate *arg);
>  void kvm_realm_unmap_range(struct kvm *kvm,
>  			   unsigned long ipa,
>  			   unsigned long size,
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 4e16719fda22..d0cd011cf672 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -38,6 +38,7 @@ menuconfig KVM
>  	select GUEST_PERF_EVENTS if PERF_EVENTS
>  	select KVM_GUEST_MEMFD
>  	select KVM_GENERIC_MEMORY_ATTRIBUTES
> +	select HAVE_KVM_ARCH_GMEM_POPULATE
>  	help
>  	  Support hosting virtualized guest machines.
>  
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index ed88a203b892..073ba9181da9 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2131,6 +2131,19 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  			return -EFAULT;
>  		return kvm_vm_ioctl_get_reg_writable_masks(kvm, &range);
>  	}
> +	case KVM_ARM_RMI_POPULATE: {
> +		struct kvm_arm_rmi_populate req;
> +		int ret;
> +
> +		if (!kvm_is_realm(kvm))
> +			return -ENXIO;
> +		if (copy_from_user(&req, argp, sizeof(req)))
> +			return -EFAULT;
> +		ret = kvm_arm_rmi_populate(kvm, &req);
> +		if (copy_to_user(argp, &req, sizeof(req)))
> +			return -EFAULT;
> +		return ret;
> +	}
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index a89873a5eb77..209087bcf399 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -486,6 +486,75 @@ void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>  		realm_unmap_private_range(kvm, start, end, may_block);
>  }
>  
> +static int realm_data_map_init(struct kvm *kvm, unsigned long ipa,
> +			       kvm_pfn_t dst_pfn, kvm_pfn_t src_pfn,
> +			       unsigned long flags)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	phys_addr_t dst_phys, src_phys;
> +	int ret;
> +
> +	dst_phys = __pfn_to_phys(dst_pfn);
> +	src_phys = __pfn_to_phys(src_pfn);
> +
> +	if (rmi_delegate_page(dst_phys))
> +		return -ENXIO;
> +
> +	ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys, flags);
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		/* Create missing RTTs and retry */
> +		int level = RMI_RETURN_INDEX(ret);
> +
> +		KVM_BUG_ON(level == KVM_PGTABLE_LAST_LEVEL, kvm);
> +
> +		ret = realm_create_rtt_levels(realm, ipa, level,
> +					      KVM_PGTABLE_LAST_LEVEL, NULL);
> +		if (!ret) {
> +			ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys,
> +						    flags);

I think rmi_rtt_data_map_init() returns a raw RMI return value which is
positive on failure. Shouldn't it be converted to -ENXIO or another
Linux errno before returning it?

Otherwise, the positive error value can propagate through
kvm_gmem_populate() and populate_region() to kvm_arm_rmi_populate().
There, it would be treated as the number of pages populated, even though
the operation did not populate any pages.

> +		}
> +	}
> +
> +	if (ret) {
> +		if (WARN_ON(rmi_undelegate_page(dst_phys))) {
> +			/* Undelegate failed, so we leak the page */
> +			get_page(pfn_to_page(dst_pfn));

Since realm_create_rtt_levels() returns either 0 or a negative errno,
how about preserving that error and converting any raw RMI erorr to
-ENXIO here?

		return ret < 0 ? ret : -ENXIO;

> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int populate_region_cb(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> +			      struct page *src_page, void *opaque)
> +{
> +	unsigned long data_flags = *(unsigned long *)opaque;
> +	phys_addr_t ipa = gfn_to_gpa(gfn);
> +
> +	if (!src_page)
> +		return -EOPNOTSUPP;
> +
> +	return realm_data_map_init(kvm, ipa, pfn, page_to_pfn(src_page),
> +				   data_flags);
> +}
> +
> +static long populate_region(struct kvm *kvm,
> +			    gfn_t base_gfn,
> +			    unsigned long pages,
> +			    u64 uaddr,
> +			    unsigned long data_flags)
> +{
> +	long ret = 0;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	ret = kvm_gmem_populate(kvm, base_gfn, u64_to_user_ptr(uaddr), pages,
> +				populate_region_cb, &data_flags);
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return ret;
> +}
> +
>  enum ripas_action {
>  	RIPAS_INIT,
>  	RIPAS_SET,
> @@ -574,6 +643,43 @@ static int realm_ensure_created(struct kvm *kvm)
>  	return -ENXIO;
>  }
>  
> +int kvm_arm_rmi_populate(struct kvm *kvm,
> +			 struct kvm_arm_rmi_populate *args)
> +{
> +	unsigned long data_flags = 0;
> +	unsigned long ipa_start = args->base;
> +	unsigned long ipa_end = ipa_start + args->size;
> +	long pages_populated;
> +	int ret;
> +
> +	if (args->reserved ||
> +	    (args->flags & ~KVM_ARM_RMI_POPULATE_FLAGS_MEASURE) ||
> +	    !IS_ALIGNED(ipa_start, PAGE_SIZE) ||
> +	    !IS_ALIGNED(ipa_end, PAGE_SIZE) ||
> +	    !IS_ALIGNED(args->source_uaddr, PAGE_SIZE))
> +		return -EINVAL;
> +
> +	ret = realm_ensure_created(kvm);
> +	if (ret)
> +		return ret;

If I understand correctly, concurrent KVM_ARM_RMI_POPULATE calls can
race with each other in realm_ensure_created(). 

realm_ensure_created() calls realm_create_rd() when kvm_realm_state() ==
REALM_STATE_NONE. Since kvm->arch.config_lock is not held here, multiple
threads could enter realm_create_rd() concurrently.

KVM_ARM_RMI_POPULATE can also race with KVM_RUN through
kvm_activate_realm(). kvm_activate_realm() takes kvm->arch.config_lock
while checking the Realm state, calling realm_ensure_created(), and
updating the state, whereas KVM_ARM_RMI_POPULATE does not.

How about serializing Realm creation here as follows?
	scoped_guard(mutex, &kvm->arch.config_lock) {
		ret = realm_ensure_created(kvm);
		if (ret)
			return ret;
	}

Does that make sense?

> +
> +	if (args->flags & KVM_ARM_RMI_POPULATE_FLAGS_MEASURE)
> +		data_flags |= RMI_MEASURE_CONTENT;
> +
> +	pages_populated = populate_region(kvm, gpa_to_gfn(ipa_start),
> +					  args->size >> PAGE_SHIFT,
> +					  args->source_uaddr, data_flags);
> +
> +	if (pages_populated < 0)
> +		return pages_populated;
> +
> +	args->size -= pages_populated << PAGE_SHIFT;
> +	args->source_uaddr += pages_populated << PAGE_SHIFT;
> +	args->base += pages_populated << PAGE_SHIFT;
> +
> +	return 0;
> +}
> +
>  static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> -- 
> 2.43.0
> 
> 
