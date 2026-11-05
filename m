Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900106;
	b=Z+mv0586bWPAWTl+lJCNPi/AB5G6iKbFCd2pIn0fUinXkwCYuZ6yamMu7F7r/kuZfrOh
	 iU/yaBOZwdBvuCGzsT5GFVmY/T75pbQCrExM/wUcOa6bv2GTyfz1fLLQpPSe+WA1/mXm0
	 b9IkcxyijrrMLTD/AJEXt+rVcnHM0TxfEk0+fjLfGWZfZhp0Xx0jOzFXE6qihHgpoCvT+
	 K8mHQeKvHa8W6D/u91fYJ+mF1REwBJLgKg5Rmlf0r4HyLOKr3Q79A6OQ3GZwl5YrcqTMt
	 lN5NoCWQ4flhqIImVrdJX6Us1Ws0Hh/KlafKwNJFOOASBorFf5rh3snSReuF4EUW7Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900106;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/26YBXWFWm1froW1+cYU1+1Lh2ctGusWN3pq79/bkJ0=;
	b=qWsZDUqgGxD1yHNWA2g2QBA6wFIR//bjPERTPchVg0iGa9zGmg/JghUWfLE5TdfwJ5Br
	 BF8m21w6utEtNWVh+7GrTPbIoKXeeaTXCb6nBxookMmuwDsyYHQIxEjtIJb8p9ukNHFXh
	 tIYFcnB0esLT68/Sx+rkcEAF92cRTqcxMhoQGln/gbTLxYoIkwCSkTMQoa+fF9/+OLRk9
	 fQ+0WttkbHlXK5IcI9uT8Q9Ddu216jWUNouJpbBhAQBIRw4/Q7owuW8Tmi5EddiCSxh4J
	 ejJFoHfWwGP3OPIY0iYtGJgOWyFO0+hXFBqGsl7iaFEErd4CSvBf6xqc9LiNn0Y5MiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UYICIcj0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DB7606A330;
	Thu,  5 Nov 2026 17:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UYICIcj0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152571F000C1;
	Thu,  5 Nov 2026 17:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793900105;
	bh=/26YBXWFWm1froW1+cYU1+1Lh2ctGusWN3pq79/bkJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UYICIcj0LVugcMgewI3mOPp3ew18+fQR2h3F3rZBbcqXqXjpvQ7ZMYAmgEXeZL7BC
	 PIAumspvrqVLUylU/VzS1S89RUavAZfQ8ar0f5AYViAESWy0Yr7fshRXY40P5ks2kn
	 Uso+/G4J4UcdJXhIMUeOHLVe85inNt/ccs8kP/zJu9iickKkTp7mRyqW1SwHhHfcW3
	 5r8s9zuQyE7gT4sTTUd4dHDWUXwPZ8NpIfYbg2CmdXDQWnpO+0pRkQwhY1gp56wN9F
	 MBdmB0cBWH1OmCJNj4Mlp9Wz/wUHLWoUuFfVowniFxlEYCz0+0bVN0T2qdX3Adtly6
	 jIvIG/NVi0Zlg==
Date: Thu, 5 Nov 2026 17:35:00 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 27/28] KVM: arm64: Handle dirty page logging when
 SPE feature is set
Message-ID: <auy4l2VD4ot18sED@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-28-alexandru.elisei@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-28-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:22PM +0100, Alexandru Elisei wrote:
> Dirty page logging requires that memory is marked as read-only at stage 2,
> to track when a guest writes to memory.
>
> For SPE, this will cause a stage 2 fault when a record is written to
> memory, and a profiling blackout window. Avoid it by refusing to run a VCPU
> with the buffer enabled when at least one memslot is logging dirty pages.
>
> Though not prohibited by KVM, to avoid the aforementioned blackout window,
> when the VCPU exits with KVM_EXIT_FAIL_ENTRY and
> hardware_entry_failure_reason set to KVM_EXIT_FAIL_ENTRY_SPE_DIRTY_LOGGING,
> userspace should not run that VCPU until dirty page logging is disabled.

So it seems this change is predicated on the guestmemfd dirty page logging
series [0] which is also RFC atm, and without it being merged, this patch
isn't necessary AFAICT.

I think probably we need to figure out if SPE VM migration is useful - as I
understand it, the entire VM needs to be pinned, pre-faulted guestmemfd
memory, so I'd argue that, at least for a v1 implementation, that should be
deferred.

Which then means you don't this patch nor [0] AFAICT and that is a simpler
road to SPE.

But in any case, if you did want to go ahead with this you could send that
as a follow up series, both the pre-requisite and this patch?

I think probably this is the right way to go.

[0]:https://lore.kernel.org/kvmarm/20260702142912.6395-1-alexandru.elisei@arm.com/

>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  Documentation/virt/kvm/api.rst                |  7 +-
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/include/asm/kvm_host.h             | 24 +++---
>  arch/arm64/include/asm/kvm_mmu.h              |  1 +
>  arch/arm64/include/asm/kvm_pgtable.h          | 19 +++++
>  arch/arm64/include/asm/kvm_pkvm.h             |  1 +
>  arch/arm64/include/asm/kvm_spe.h              | 16 ++++
>  arch/arm64/include/uapi/asm/kvm.h             |  1 +
>  arch/arm64/kvm/arm.c                          | 27 ++++++-
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 34 +++++---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  7 +-
>  arch/arm64/kvm/hyp/pgtable.c                  |  8 ++
>  arch/arm64/kvm/mmu.c                          | 19 +++++
>  arch/arm64/kvm/pkvm.c                         | 27 +++++++
>  arch/arm64/kvm/spe.c                          | 79 +++++++++++++++++++
>  16 files changed, 246 insertions(+), 27 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 654736fac78c..00e85e79e145 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1422,7 +1422,12 @@ pages in the host.
>  The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
>  KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
>  writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
> -use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
> +use it. For arm64, setting and then clearing KVM_MEM_LOG_DIRTY_PAGES before
> +creating a VCPU with the KVM_ARM_VCPU_SPE feature can lead to profiling
> +blackout windows in the guest, caused by SPE encountering stage 2 faults when
> +attempting to write to memory.
> +
> +KVM_MEM_READONLY can be set if KVM_CAP_READONLY_MEM capability allows it,
>  to make a new slot read-only.  In this case, writes to this memory will be
>  posted to userspace as KVM_EXIT_MMIO exits.
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index e5b92ac09e69..6251cbc6b105 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -100,6 +100,7 @@ enum __kvm_host_smccc_func {
>  	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
> +	__KVM_HOST_SMCCC_FUNC___pkvm_host_write_enable_guest,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_host_mkyoung_guest,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_reserve_vm,
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 31be131c8486..ff77f6ac3adf 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -45,17 +45,19 @@
>
>  #define KVM_REQ_SLEEP \
>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> -#define KVM_REQ_IRQ_PENDING		KVM_ARCH_REQ(1)
> -#define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(2)
> -#define KVM_REQ_RECORD_STEAL		KVM_ARCH_REQ(3)
> -#define KVM_REQ_RELOAD_GICv4		KVM_ARCH_REQ(4)
> -#define KVM_REQ_RELOAD_PMU		KVM_ARCH_REQ(5)
> -#define KVM_REQ_SUSPEND			KVM_ARCH_REQ(6)
> -#define KVM_REQ_RESYNC_PMU_EL0		KVM_ARCH_REQ(7)
> -#define KVM_REQ_NESTED_S2_UNMAP		KVM_ARCH_REQ(8)
> -#define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
> -#define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
> -#define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
> +#define KVM_REQ_IRQ_PENDING			KVM_ARCH_REQ(1)
> +#define KVM_REQ_VCPU_RESET			KVM_ARCH_REQ(2)
> +#define KVM_REQ_RECORD_STEAL			KVM_ARCH_REQ(3)
> +#define KVM_REQ_RELOAD_GICv4			KVM_ARCH_REQ(4)
> +#define KVM_REQ_RELOAD_PMU			KVM_ARCH_REQ(5)
> +#define KVM_REQ_SUSPEND				KVM_ARCH_REQ(6)
> +#define KVM_REQ_RESYNC_PMU_EL0			KVM_ARCH_REQ(7)
> +#define KVM_REQ_NESTED_S2_UNMAP			KVM_ARCH_REQ(8)
> +#define KVM_REQ_GUEST_HYP_IRQ_PENDING		KVM_ARCH_REQ(9)
> +#define KVM_REQ_MAP_L1_VNCR_EL2			KVM_ARCH_REQ(10)
> +#define KVM_REQ_VGIC_PROCESS_UPDATE		KVM_ARCH_REQ(11)
> +#define KVM_REQ_SPE_HANDLE_DIRTY_LOGGING	KVM_ARCH_REQ(12)
> +#define KVM_REQ_SPE_EXIT_DIRTY_LOGGING		KVM_ARCH_REQ(13)
>
>  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>  				     KVM_DIRTY_LOG_INITIALLY_SET)
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 6eae7e7e2a68..5509e3e64abc 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -173,6 +173,7 @@ void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>  			    u64 size, bool may_block);
>  void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
>  void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
> +void kvm_stage2_write_enable_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end);
>
>  void stage2_unmap_vm(struct kvm *kvm);
>  int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 41a8687938eb..53c8dd62dcd5 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -735,6 +735,25 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
>   */
>  int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
>
> +/**
> + * kvm_pgtable_stage2_write_enable() - Grant write permission to the stage-2
> + * 				       address range without TLB invalidation.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> + * @addr:	Intermediate physical address from which to write-enable.
> + * @size:	Size of the range.
> + *
> + * The offset of @addr within a page is ignored and @size is rounded-up to
> + * the next page boundary.
> + *
> + * Note that it is the caller's responsibility to invalidate the TLB after
> + * calling this function to ensure that the updated permissions are visible
> + * to the CPUs.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_stage2_write_enable(struct kvm_pgtable *pgt, u64 addr,
> +				    u64 size);
> +
>  /**
>   * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
>   * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index beea00e693a0..a1aa03d13937 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -215,6 +215,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phy
>  			    enum kvm_pgtable_walk_flags flags);
>  int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
>  int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
> +int pkvm_pgtable_stage2_write_enable(struct kvm_pgtable *pgt, u64 addr, u64 size);
>  int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
>  bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64 size, bool mkold);
>  int pkvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr, enum kvm_pgtable_prot prot,
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> index 88f8b1bb6864..d710f64e00be 100644
> --- a/arch/arm64/include/asm/kvm_spe.h
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -9,6 +9,7 @@
>  struct kvm;
>  struct kvm_vcpu;
>  struct kvm_device_attr;
> +struct kvm_memory_slot;
>
>  #ifdef CONFIG_KVM_ARM_SPE
>  struct arm_spe_pmu;
> @@ -39,6 +40,10 @@ void kvm_spe_destroy_vm(struct kvm *kvm);
>
>  void kvm_spe_finalize_idregs(struct kvm *kvm);
>
> +void kvm_spe_add_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *slot);
> +void kvm_spe_remove_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *slot);
> +void kvm_spe_handle_dirty_logging_request(struct kvm_vcpu *vcpu);
> +
>  int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
> @@ -86,6 +91,17 @@ static inline void kvm_spe_destroy_vm(struct kvm *kvm)
>  static inline void kvm_spe_finalize_idregs(struct kvm *kvm)
>  {
>  }
> +static inline void kvm_spe_add_dirty_logging(struct kvm *kvm,
> +					     const struct kvm_memory_slot *slot)
> +{
> +}
> +static inline void kvm_spe_remove_dirty_logging(struct kvm *kvm,
> +						const struct kvm_memory_slot *slot)
> +{
> +}
> +static inline void kvm_spe_handle_dirty_logging_request(struct kvm_vcpu *vcpu)
> +{
> +}
>  static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>  	return -ENXIO;
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index c695aae484d3..a86fa4f9d9e4 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -511,6 +511,7 @@ enum {
>
>  /* run->fail_entry.hardware_entry_failure_reason codes. */
>  #define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
> +#define KVM_EXIT_FAIL_ENTRY_SPE_DIRTY_LOGGING	(1ULL << 1)
>
>  enum kvm_smccc_filter_action {
>  	KVM_SMCCC_FILTER_HANDLE = 0,
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 7c7d0616db53..73f321b3ed2d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1172,6 +1172,15 @@ static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>
> +static void kvm_vcpu_prepare_exit_fail_entry(struct kvm_vcpu *vcpu, u64 reason)
> +{
> +	struct kvm_run *run = vcpu->run;
> +
> +	run->exit_reason = KVM_EXIT_FAIL_ENTRY;
> +	run->fail_entry.hardware_entry_failure_reason = reason;
> +	run->fail_entry.cpu = smp_processor_id();
> +}
> +
>  /**
>   * check_vcpu_requests - check and handle pending vCPU requests
>   * @vcpu:	the VCPU pointer
> @@ -1223,6 +1232,20 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>  		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
>  			return kvm_vcpu_suspend(vcpu);
>
> +		if (kvm_check_request(KVM_REQ_SPE_HANDLE_DIRTY_LOGGING, vcpu))
> +			kvm_spe_handle_dirty_logging_request(vcpu);
> +
> +		/*
> +		 * The request is consumed on purpose, to allow userspace to
> +		 * resume the VCPU at the expense of profiling blackout windows
> +		 * if it so wishes.
> +		 */
> +		if (kvm_check_request(KVM_REQ_SPE_EXIT_DIRTY_LOGGING, vcpu)) {
> +			kvm_vcpu_prepare_exit_fail_entry(vcpu,
> +					KVM_EXIT_FAIL_ENTRY_SPE_DIRTY_LOGGING);
> +			return 0;
> +		}
> +
>  		if (kvm_dirty_ring_check_request(vcpu))
>  			return 0;
>
> @@ -1285,9 +1308,7 @@ static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu, int *ret)
>  	}
>
>  	if (unlikely(vcpu_on_unsupported_cpu(vcpu))) {
> -		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
> -		run->fail_entry.hardware_entry_failure_reason = KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED;
> -		run->fail_entry.cpu = smp_processor_id();
> +		kvm_vcpu_prepare_exit_fail_entry(vcpu, KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED);
>  		*ret = 0;
>  		return true;
>  	}
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 29935c7da1de..dadb56d62820 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -47,7 +47,7 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
>  			    enum kvm_pgtable_prot prot);
>  int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
>  int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
> -int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
> +int __pkvm_host_toggle_wp_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm, bool wp);
>  int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct pkvm_hyp_vm *vm);
>  int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 9a3b92e626ad..34c442f1529b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -487,22 +487,37 @@ static void handle___pkvm_host_relax_perms_guest(struct kvm_cpu_context *host_ct
>  	cpu_reg(host_ctxt, 1) = ret;
>  }
>
> -static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt)
> +static int host_toggle_wp_guest(pkvm_handle_t handle, u64 gfn, u64 nr_pages, bool wp)
>  {
> -	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> -	DECLARE_REG(u64, gfn, host_ctxt, 2);
> -	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
>  	struct pkvm_hyp_vm *hyp_vm;
> -	int ret = -EINVAL;
> +	int ret;
>
>  	hyp_vm = get_np_pkvm_hyp_vm(handle);
>  	if (!hyp_vm)
> -		goto out;
> +		return -EINVAL;
>
> -	ret = __pkvm_host_wrprotect_guest(gfn, nr_pages, hyp_vm);
> +	ret = __pkvm_host_toggle_wp_guest(gfn, nr_pages, hyp_vm, wp);
>  	put_pkvm_hyp_vm(hyp_vm);
> -out:
> -	cpu_reg(host_ctxt, 1) = ret;
> +
> +	return ret;
> +}
> +
> +static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> +	DECLARE_REG(u64, gfn, host_ctxt, 2);
> +	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
> +
> +	cpu_reg(host_ctxt, 1) = host_toggle_wp_guest(handle, gfn, nr_pages, true);
> +}
> +
> +static void handle___pkvm_host_write_enable_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> +	DECLARE_REG(u64, gfn, host_ctxt, 2);
> +	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
> +
> +	cpu_reg(host_ctxt, 1) = host_toggle_wp_guest(handle, gfn, nr_pages, false);
>  }
>
>  static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *host_ctxt)
> @@ -942,6 +957,7 @@ static const hcall_t host_hcall[] = {
>  	HANDLE_FUNC(__pkvm_host_unshare_guest),
>  	HANDLE_FUNC(__pkvm_host_relax_perms_guest),
>  	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
> +	HANDLE_FUNC(__pkvm_host_write_enable_guest),
>  	HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
>  	HANDLE_FUNC(__pkvm_host_mkyoung_guest),
>  	HANDLE_FUNC(__pkvm_reserve_vm),
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 39aa8911f62c..8e5405280c9d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1650,7 +1650,7 @@ int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_
>  	return ret;
>  }
>
> -int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
> +int __pkvm_host_toggle_wp_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm, bool wp)
>  {
>  	u64 size, ipa = hyp_pfn_to_phys(gfn);
>  	int ret;
> @@ -1664,7 +1664,10 @@ int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
>
>  	assert_host_shared_guest(vm, ipa, size);
>  	guest_lock_component(vm);
> -	ret = kvm_pgtable_stage2_wrprotect(&vm->pgt, ipa, size);
> +	if (wp)
> +		ret = kvm_pgtable_stage2_wrprotect(&vm->pgt, ipa, size);
> +	else
> +		ret = kvm_pgtable_stage2_write_enable(&vm->pgt, ipa, size);
>  	guest_unlock_component(vm);
>
>  	return ret;
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b74dd5ce1efd..07e43f607eae 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1293,6 +1293,14 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
>  }
>
> +int kvm_pgtable_stage2_write_enable(struct kvm_pgtable *pgt, u64 addr, u64 size)
> +{
> +	return stage2_update_leaf_attrs(pgt, addr, size,
> +					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W, 0,
> +					NULL, NULL,
> +					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
> +}
> +
>  void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
>  				enum kvm_pgtable_walk_flags flags)
>  {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d7e7365c5c5a..e1dfc7d5db3e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1240,6 +1240,17 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  	return ret;
>  }
>
> +/**
> + * kvm_stage2_write_enable_range() - grant write permision for the memory range
> + * @mmu:        The KVM stage-2 MMU pointer
> + * @addr:	Start address of range
> + * @end:	End address of range
> + */
> +void kvm_stage2_write_enable_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
> +{
> +	stage2_apply_range_resched(mmu, addr, end, KVM_PGT_FN(kvm_pgtable_stage2_write_enable));
> +}
> +
>  /**
>   * kvm_stage2_wp_range() - write protect stage2 memory region range
>   * @mmu:        The KVM stage-2 MMU pointer
> @@ -2578,6 +2589,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  				   enum kvm_mr_change change)
>  {
>  	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> +	bool had_dirty_logging = old && old->flags & KVM_MEM_LOG_DIRTY_PAGES;
> +
> +	if (change != KVM_MR_DELETE && had_dirty_logging != log_dirty_pages) {
> +		if (log_dirty_pages)
> +			kvm_spe_add_dirty_logging(kvm, new);
> +		else
> +			kvm_spe_remove_dirty_logging(kvm, new);
> +	}
>
>  	/*
>  	 * At this point memslot has been committed and there is an
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8e4c6e4bec12..5ba2fa8010cc 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -488,6 +488,33 @@ int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  	return __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
>  }
>
> +int pkvm_pgtable_stage2_write_enable(struct kvm_pgtable *pgt, u64 addr, u64 size)
> +{
> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> +	pkvm_handle_t handle = kvm->arch.pkvm.handle;
> +	struct pkvm_mapping *mapping;
> +	u64 gfn, end_gfn, nr_pages;
> +	int ret = 0;
> +
> +	if (WARN_ON(kvm_vm_is_protected(kvm)))
> +		return -EPERM;
> +
> +	end_gfn = (addr + size) >> PAGE_SHIFT;
> +
> +	lockdep_assert_held(&kvm->mmu_lock);
> +	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> +		gfn = max(addr >> PAGE_SHIFT, mapping->gfn);
> +		nr_pages = min_t(u64, end_gfn - gfn, mapping->nr_pages);
> +		ret = kvm_call_hyp_nvhe(__pkvm_host_write_enable_guest, handle, gfn,
> +					nr_pages);
> +		if (WARN_ON(ret))
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +
>  int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index e5f3d0dea7c5..f3310465f40e 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -10,6 +10,7 @@
>  #include <linux/perf_event.h>
>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>  #include <asm/kvm_nested.h>
>  #include <asm/kvm_spe.h>
>  #include <asm/sysreg.h>
> @@ -141,6 +142,81 @@ void kvm_spe_destroy_vm(struct kvm *kvm)
>  	module_put(spe_pmu->pmu.module);
>  }
>
> +void kvm_spe_add_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *slot)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	/*
> +	 * No point in handling a regular memslot, because they cannot guarantee
> +	 * that memory remains mapped at stage 2.
> +	 *
> +	 * Memory described by a read-only memslot is always read-only, so SPE
> +	 * cannot write to it anyway.
> +	 */
> +	if (!kvm_slot_has_gmem(slot) || (slot->flags & KVM_MEM_READONLY))
> +		return;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!vcpu_has_spe(vcpu))
> +			continue;
> +		kvm_make_request(KVM_REQ_SPE_HANDLE_DIRTY_LOGGING, vcpu);
> +		if (vcpu_has_run_once(vcpu))
> +			__kvm_vcpu_kick(vcpu, true);
> +	}
> +}
> +
> +void kvm_spe_remove_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *slot)
> +{
> +	phys_addr_t start, end;
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	if (!kvm_slot_has_gmem(slot) || (slot->flags & KVM_MEM_READONLY))
> +		return;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		/*
> +		 * Write-enabling an entire memslot can be expensive, do it only
> +		 * if the VM has SPE.
> +		 */
> +		if (vcpu_has_spe(vcpu)) {
> +			start = slot->base_gfn << PAGE_SHIFT;
> +			end = (slot->base_gfn + slot->npages) << PAGE_SHIFT;
> +
> +			write_lock(&kvm->mmu_lock);
> +			kvm_stage2_write_enable_range(&kvm->arch.mmu, start, end);
> +			write_unlock(&kvm->mmu_lock);
> +			kvm_flush_remote_tlbs_memslot(kvm, slot);
> +			return;
> +		}
> +	}
> +}
> +
> +static bool kvm_spe_should_exit_dirty_logging(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 pmblimitr, pmbsr;
> +
> +	if (!atomic_read(&kvm->nr_memslots_dirty_logging))
> +		return false;
> +
> +	pmblimitr = __vcpu_sys_reg(vcpu, PMBLIMITR_EL1);
> +	pmbsr = __vcpu_sys_reg(vcpu, PMBSR_EL1);
> +
> +	return FIELD_GET(PMBLIMITR_EL1_E, pmblimitr) && !FIELD_GET(PMBSR_EL1_S, pmbsr);
> +}
> +
> +void kvm_spe_handle_dirty_logging_request(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_spe_should_exit_dirty_logging(vcpu))
> +		kvm_make_request(KVM_REQ_SPE_EXIT_DIRTY_LOGGING, vcpu);
> +}
> +
>  bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
>  {
>  	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.spe_pmu;
> @@ -214,6 +290,9 @@ bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>  		kvm_spe_update_irq_level(vcpu, FIELD_GET(PMBSR_EL1_S, val));
>  	}
>
> +	if (kvm_spe_should_exit_dirty_logging(vcpu))
> +		kvm_make_request(KVM_REQ_SPE_EXIT_DIRTY_LOGGING, vcpu);
> +
>  	return true;
>  }
>
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
