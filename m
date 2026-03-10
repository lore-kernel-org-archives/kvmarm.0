Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 962213101C0
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773156374; cv=none; b=qtkXq/oThCjvIRwJIWQJWanwjNvAhlTMNTvM2jmYOcasvrJEFwwyO93ngUys4fAlpTo2ucnJes7k75vWp89ZyWnYHYsnfnNXILrlc0s2RbAj3vebYf+HOWY3D00aaerO/Aq9a92Y3BTg3c7BSlBY8xGaX51rMwQMKiTimZPlb5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773156374; c=relaxed/simple;
	bh=O/w5+Ec7zu1oz0PbidxunqJu737rfkJdYkNOGO2oN44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rInhJUmFcedLvErKPLMousg5JbptI4EpBoxW+K8PW/5NbGTSQG0zTYXL/CWg1PRyjtw8RfP+Gn/9Welg7er0IVU1jH30rNpbQpUWFAjU6GONZmGKZQVonVv1P6h/Qeg6QJynOvCkEpXuZrXUJq+j6fZBLmRUc64Exy7yYe5itBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF302169C;
	Tue, 10 Mar 2026 08:26:04 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 780B33F7BD;
	Tue, 10 Mar 2026 08:26:09 -0700 (PDT)
Date: Tue, 10 Mar 2026 15:26:04 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH RESEND 2/2] KVM: arm64: nv: Expose shadow page tables in
 debugfs
Message-ID: <20260310152604.GA3093715@e124191.cambridge.arm.com>
References: <20260308231829.864983-1-weilin.chang@arm.com>
 <20260308231829.864983-3-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308231829.864983-3-weilin.chang@arm.com>

On Sun, Mar 08, 2026 at 11:18:29PM +0000, Wei-Lin Chang wrote:
> Exposing shadow page tables in debugfs improves the debugability and
> testability of NV. With this patch a new directory "nested" is created
> for each VM created if the host is NV capable. Within the directory each
> valid s2 mmu will have its shadow page table exposed as a readable file
> with the file name formatted as 0x<vttbr>-0x<vtcr>-s2-{en,dis}abled. The
> creation and removal of the files happen at the points when an s2 mmu
> becomes valid, or the context it represents change. In the future the
> "nested" directory can also hold other NV related information.
> 
> This is gated behind CONFIG_PTDUMP_STAGE2_DEBUGFS.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  7 +++++++
>  arch/arm64/include/asm/kvm_mmu.h  |  4 ++++
>  arch/arm64/kvm/nested.c           |  6 +++++-
>  arch/arm64/kvm/ptdump.c           | 27 +++++++++++++++++++++++++++
>  4 files changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5d5a3bbdb95e..f88f6c4d646e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -217,6 +217,10 @@ struct kvm_s2_mmu {
>  	 */
>  	bool	nested_stage2_enabled;
>  
> +#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> +	struct dentry *shadow_pt_debugfs_dentry;
> +#endif
> +
>  	/*
>  	 * true when this MMU needs to be unmapped before being used for a new
>  	 * purpose.
> @@ -405,6 +409,9 @@ struct kvm_arch {
>  	 * the associated pKVM instance in the hypervisor.
>  	 */
>  	struct kvm_protected_vm pkvm;
> +
> +	/* Nested virtualization info */
> +	struct dentry *debugfs_nv_dentry;

Seems like this could be guarded with CONFIG_PTDUMP_STAGE2_DEBUGFS too, or is
there a reason you didn't?

Thanks,
Joey

>  };
>  
>  struct kvm_vcpu_fault_info {
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index d968aca0461a..01e9c72d6aa7 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -393,8 +393,12 @@ static inline bool kvm_supports_cacheable_pfnmap(void)
>  
>  #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
>  void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
> +void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu);
> +void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu);
>  #else
>  static inline void kvm_s2_ptdump_create_debugfs(struct kvm *kvm) {}
> +static inline void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu) {}
> +static inline void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu) {}
>  #endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
>  
>  #endif /* __ASSEMBLER__ */
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index eeea5e692370..31d74ed8449e 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -730,8 +730,10 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
>  	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
>  
>  	/* Make sure we don't forget to do the laundry */
> -	if (kvm_s2_mmu_valid(s2_mmu))
> +	if (kvm_s2_mmu_valid(s2_mmu)) {
> +		kvm_nested_s2_ptdump_remove_debugfs(s2_mmu);
>  		s2_mmu->pending_unmap = true;
> +	}
>  
>  	/*
>  	 * The virtual VMID (modulo CnP) will be used as a key when matching
> @@ -745,6 +747,8 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
>  	s2_mmu->tlb_vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
>  	s2_mmu->nested_stage2_enabled = vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_VM;
>  
> +	kvm_nested_s2_ptdump_create_debugfs(s2_mmu);
> +
>  out:
>  	atomic_inc(&s2_mmu->refcnt);
>  
> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index 98763b291956..3a70f633fc8b 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -10,6 +10,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/seq_file.h>
>  
> +#include <asm/cpufeature.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_pgtable.h>
>  #include <asm/ptdump.h>
> @@ -277,6 +278,29 @@ static const struct file_operations kvm_pgtable_levels_fops = {
>  	.release	= kvm_pgtable_debugfs_close,
>  };
>  
> +void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu)
> +{
> +	struct dentry *dent;
> +	/* format: 0x<vttbr>-0x<vtcr>-s2-{en, dis}abled\0 */
> +	char file_name[2 + 16 + 1 + 2 + 16 + 4 + 3 + 6];
> +
> +	snprintf(file_name, sizeof(file_name), "0x%llx-0x%llx-s2-%sabled",
> +		 mmu->tlb_vttbr,
> +		 mmu->tlb_vtcr,
> +		 mmu->nested_stage2_enabled ? "en" : "dis");
> +
> +	dent = debugfs_create_file(file_name, 0400,
> +				   mmu->arch->debugfs_nv_dentry, mmu,
> +				   &kvm_ptdump_guest_fops);
> +
> +	mmu->shadow_pt_debugfs_dentry = dent;
> +}
> +
> +void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu)
> +{
> +	debugfs_remove(mmu->shadow_pt_debugfs_dentry);
> +}
> +
>  void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
>  {
>  	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
> @@ -285,4 +309,7 @@ void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
>  			    &kvm->arch.mmu, &kvm_pgtable_range_fops);
>  	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
>  			    &kvm->arch.mmu, &kvm_pgtable_levels_fops);
> +	if (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
> +		kvm->arch.debugfs_nv_dentry =
> +			debugfs_create_dir("nested", kvm->debugfs_dentry);
>  }
> -- 
> 2.43.0
> 
