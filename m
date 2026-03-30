Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7DA937E30A
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 11:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774870305; cv=none; b=kRgpPJcS+2lUOYLHwMl37VfNGgspdggDdXVaouYFlVBz0kpeR16mVOAV3HD10cta+nt1fIQFi0B2zgtXzbiQfeDyWpuqAiXmu0MBye76aKDeFl3gUPsx3pf7x+WPoofeKlCby//8Af1vPVomBghTqvg8Hpciu7D27Aqg1PbcrWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774870305; c=relaxed/simple;
	bh=C6E2u2EYQzV1OTemdup1wPEl7RpgccKycIkd4Xf8Fx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=cIs/ryK3DzUmpSZuhpfLU+/gKJ1bHXMgVEqWvmnKPMZqIhsYSwag1k8BozK0vHLBmluJ73G8Co6y5YjYHwQK1MQqeOE0JMj3Yevy6W9J9dAmtYTy5oPV47GvFCHJ1sioi93TjJO71eXmtja+6NLAAEPYctTSgEufJiWQhIW8wPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qcnkoLAS; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qcnkoLAS"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 654771BF3;
	Mon, 30 Mar 2026 04:31:36 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC7173F641;
	Mon, 30 Mar 2026 04:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774870302; bh=C6E2u2EYQzV1OTemdup1wPEl7RpgccKycIkd4Xf8Fx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcnkoLASCpeMtXaVcYa2QFxy4sTjJfFduW9pp5F9uWBUY87Ko3MbXc0IYTLFT8hmc
	 Cyf8G0i79x9dA6BpzqeazOlGAFWDfmeqXYuznzhVUIfjhf3oOBoZwJT79xvLCDy4Sj
	 0rqwsXynvF2K8U0bpg6uYbu46K3r7Urwsfj/43zU=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	corbet@lwn.net,
	pbonzini@redhat.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	liuyonglong@huawei.com,
	Jonathan.Cameron@huawei.com,
	yezhenyu2@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v3 4/5] KVM: arm64: Enable HDBSS support and handle HDBSSF events
Date: Mon, 30 Mar 2026 12:31:28 +0100
Message-ID: <acpfD3YjMpEdL5KZ@devkitleo>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <4e800c1e-25db-4aa2-b100-63434973de93@huawei.com>
References: <20260225040421.2683931-1-zhengtian10@huawei.com> <20260225040421.2683931-5-zhengtian10@huawei.com> <acQj5grOdZT8LUGp@devkitleo> <e3253959-0340-4c13-a980-a599e090a6de@huawei.com> <acabezCO4B5BE40Q@devkitleo> <4e800c1e-25db-4aa2-b100-63434973de93@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Mar 28, 2026 at 02:05:25PM +0800, Tian Zheng wrote:
> 
> On 3/27/2026 11:00 PM, Leonardo Bras wrote:
> > On Fri, Mar 27, 2026 at 03:35:29PM +0800, Tian Zheng wrote:
> > > On 3/26/2026 2:05 AM, Leonardo Bras wrote:
> > > > Hello Tian,
> > > > 
> > > > I am currently working on HACDBS enablement(which will be rebased on top of
> > > > this patchset) and due to the fact HACDBS and HDBSS are kind of
> > > > complementary I will sometimes come with some questions for issues I have
> > > > faced myself on that part. :)
> > > > 
> > > > (see below)
> > > 
> > > Of course! Happy to exchange ideas and learn together.
> > :)
> > 
> > > 
> > > > On Wed, Feb 25, 2026 at 12:04:20PM +0800, Tian Zheng wrote:
> > > > > From: eillon <yezhenyu2@huawei.com>
> > > > > 
> > > > > HDBSS is enabled via an ioctl from userspace (e.g. QEMU) at the start of
> > > > > migration. This feature is only supported in VHE mode.
> > > > > 
> > > > > Initially, S2 PTEs doesn't contain the DBM attribute. During migration,
> > > > > write faults are handled by user_mem_abort, which relaxes permissions
> > > > > and adds the DBM bit when HDBSS is active. Once DBM is set, subsequent
> > > > > writes no longer trap, as the hardware automatically transitions the page
> > > > > from writable-clean to writable-dirty.
> > > > > 
> > > > > KVM does not scan S2 page tables to consume DBM. Instead, when HDBSS is
> > > > > enabled, the hardware observes the clean->dirty transition and records
> > > > > the corresponding page into the HDBSS buffer.
> > > > > 
> > > > > During sync_dirty_log, KVM kicks all vCPUs to force VM-Exit, ensuring
> > > > > that check_vcpu_requests flushes the HDBSS buffer and propagates the
> > > > > accumulated dirty information into the userspace-visible dirty bitmap.
> > > > > 
> > > > > Add fault handling for HDBSS including buffer full, external abort, and
> > > > > general protection fault (GPF).
> > > > > 
> > > > > Signed-off-by: eillon <yezhenyu2@huawei.com>
> > > > > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > > > > ---
> > > > >    arch/arm64/include/asm/esr.h      |   5 ++
> > > > >    arch/arm64/include/asm/kvm_host.h |  17 +++++
> > > > >    arch/arm64/include/asm/kvm_mmu.h  |   1 +
> > > > >    arch/arm64/include/asm/sysreg.h   |  11 ++++
> > > > >    arch/arm64/kvm/arm.c              | 102 ++++++++++++++++++++++++++++++
> > > > >    arch/arm64/kvm/hyp/vhe/switch.c   |  19 ++++++
> > > > >    arch/arm64/kvm/mmu.c              |  70 ++++++++++++++++++++
> > > > >    arch/arm64/kvm/reset.c            |   3 +
> > > > >    8 files changed, 228 insertions(+)
> > > > > 
> > > > > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > > > > index 81c17320a588..2e6b679b5908 100644
> > > > > --- a/arch/arm64/include/asm/esr.h
> > > > > +++ b/arch/arm64/include/asm/esr.h
> > > > > @@ -437,6 +437,11 @@
> > > > >    #ifndef __ASSEMBLER__
> > > > >    #include <asm/types.h>
> > > > > 
> > > > > +static inline bool esr_iss2_is_hdbssf(unsigned long esr)
> > > > > +{
> > > > > +	return ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF;
> > > > > +}
> > > > > +
> > > > >    static inline unsigned long esr_brk_comment(unsigned long esr)
> > > > >    {
> > > > >    	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
> > > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > > index 5d5a3bbdb95e..57ee6b53e061 100644
> > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > @@ -55,12 +55,17 @@
> > > > >    #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
> > > > >    #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
> > > > >    #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
> > > > > +#define KVM_REQ_FLUSH_HDBSS			KVM_ARCH_REQ(12)
> > > > > 
> > > > >    #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
> > > > >    				     KVM_DIRTY_LOG_INITIALLY_SET)
> > > > > 
> > > > >    #define KVM_HAVE_MMU_RWLOCK
> > > > > 
> > > > > +/* HDBSS entry field definitions */
> > > > > +#define HDBSS_ENTRY_VALID BIT(0)
> > > > > +#define HDBSS_ENTRY_IPA GENMASK_ULL(55, 12)
> > > > > +
> > > > >    /*
> > > > >     * Mode of operation configurable with kvm-arm.mode early param.
> > > > >     * See Documentation/admin-guide/kernel-parameters.txt for more information.
> > > > > @@ -84,6 +89,7 @@ int __init kvm_arm_init_sve(void);
> > > > >    u32 __attribute_const__ kvm_target_cpu(void);
> > > > >    void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> > > > >    void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
> > > > > +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
> > > > > 
> > > > >    struct kvm_hyp_memcache {
> > > > >    	phys_addr_t head;
> > > > > @@ -405,6 +411,8 @@ struct kvm_arch {
> > > > >    	 * the associated pKVM instance in the hypervisor.
> > > > >    	 */
> > > > >    	struct kvm_protected_vm pkvm;
> > > > > +
> > > > > +	bool enable_hdbss;
> > > > >    };
> > > > > 
> > > > >    struct kvm_vcpu_fault_info {
> > > > > @@ -816,6 +824,12 @@ struct vcpu_reset_state {
> > > > >    	bool		reset;
> > > > >    };
> > > > > 
> > > > > +struct vcpu_hdbss_state {
> > > > > +	phys_addr_t base_phys;
> > > > > +	u32 size;
> > > > > +	u32 next_index;
> > > > > +};
> > > > > +
> > > > >    struct vncr_tlb;
> > > > > 
> > > > >    struct kvm_vcpu_arch {
> > > > > @@ -920,6 +934,9 @@ struct kvm_vcpu_arch {
> > > > > 
> > > > >    	/* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
> > > > >    	struct vncr_tlb	*vncr_tlb;
> > > > > +
> > > > > +	/* HDBSS registers info */
> > > > > +	struct vcpu_hdbss_state hdbss;
> > > > >    };
> > > > > 
> > > > >    /*
> > > > > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > > > > index d968aca0461a..3fea8cfe8869 100644
> > > > > --- a/arch/arm64/include/asm/kvm_mmu.h
> > > > > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > > > > @@ -183,6 +183,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> > > > > 
> > > > >    int kvm_handle_guest_sea(struct kvm_vcpu *vcpu);
> > > > >    int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
> > > > > +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
> > > > > 
> > > > >    phys_addr_t kvm_mmu_get_httbr(void);
> > > > >    phys_addr_t kvm_get_idmap_vector(void);
> > > > > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > > > > index f4436ecc630c..d11f4d0dd4e7 100644
> > > > > --- a/arch/arm64/include/asm/sysreg.h
> > > > > +++ b/arch/arm64/include/asm/sysreg.h
> > > > > @@ -1039,6 +1039,17 @@
> > > > > 
> > > > >    #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
> > > > >    					       GCS_CAP_VALID_TOKEN)
> > > > > +
> > > > > +/*
> > > > > + * Definitions for the HDBSS feature
> > > > > + */
> > > > > +#define HDBSS_MAX_SIZE		HDBSSBR_EL2_SZ_2MB
> > > > > +
> > > > > +#define HDBSSBR_EL2(baddr, sz)	(((baddr) & GENMASK(55, 12 + sz)) | \
> > > > > +				 FIELD_PREP(HDBSSBR_EL2_SZ_MASK, sz))
> > > > > +
> > > > > +#define HDBSSPROD_IDX(prod)	FIELD_GET(HDBSSPROD_EL2_INDEX_MASK, prod)
> > > > > +
> > > > >    /*
> > > > >     * Definitions for GICv5 instructions]
> > > > >     */
> > > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > > index 29f0326f7e00..d64da05e25c4 100644
> > > > > --- a/arch/arm64/kvm/arm.c
> > > > > +++ b/arch/arm64/kvm/arm.c
> > > > > @@ -125,6 +125,87 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
> > > > >    	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
> > > > >    }
> > > > > 
> > > > > +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +	struct page *hdbss_pg;
> > > > > +
> > > > > +	hdbss_pg = phys_to_page(vcpu->arch.hdbss.base_phys);
> > > > > +	if (hdbss_pg)
> > > > > +		__free_pages(hdbss_pg, vcpu->arch.hdbss.size);
> > > > > +
> > > > > +	vcpu->arch.hdbss.size = 0;
> > > > > +}
> > > > > +
> > > > > +static int kvm_cap_arm_enable_hdbss(struct kvm *kvm,
> > > > > +				    struct kvm_enable_cap *cap)
> > > > > +{
> > > > > +	unsigned long i;
> > > > > +	struct kvm_vcpu *vcpu;
> > > > > +	struct page *hdbss_pg = NULL;
> > > > > +	__u64 size = cap->args[0];
> > > > > +	bool enable = cap->args[1] ? true : false;
> > > > > +
> > > > > +	if (!system_supports_hdbss())
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	if (size > HDBSS_MAX_SIZE)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	if (!enable && !kvm->arch.enable_hdbss) /* Already Off */
> > > > > +		return 0;
> > > > > +
> > > > > +	if (enable && kvm->arch.enable_hdbss) /* Already On, can't set size */
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	if (!enable) { /* Turn it off */
> > > > > +		kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA);
> > > > > +
> > > > > +		kvm_for_each_vcpu(i, vcpu, kvm) {
> > > > > +			/* Kick vcpus to flush hdbss buffer. */
> > > > > +			kvm_vcpu_kick(vcpu);
> > > > > +
> > > > > +			kvm_arm_vcpu_free_hdbss(vcpu);
> > > > > +		}
> > > > > +
> > > > > +		kvm->arch.enable_hdbss = false;
> > > > > +
> > > > > +		return 0;
> > > > > +	}
> > > > > +
> > > > > +	/* Turn it on */
> > > > > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > > > > +		hdbss_pg = alloc_pages(GFP_KERNEL_ACCOUNT, size);
> > > > > +		if (!hdbss_pg)
> > > > > +			goto error_alloc;
> > > > > +
> > > > > +		vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
> > > > > +			.base_phys = page_to_phys(hdbss_pg),
> > > > > +			.size = size,
> > > > > +			.next_index = 0,
> > > > > +		};
> > > > > +	}
> > > > > +
> > > > > +	kvm->arch.enable_hdbss = true;
> > > > > +	kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS | VTCR_EL2_HA;
> > > > > +
> > > > > +	/*
> > > > > +	 * We should kick vcpus out of guest mode here to load new
> > > > > +	 * vtcr value to vtcr_el2 register when re-enter guest mode.
> > > > > +	 */
> > > > > +	kvm_for_each_vcpu(i, vcpu, kvm)
> > > > > +		kvm_vcpu_kick(vcpu);
> > > > > +
> > > > > +	return 0;
> > > > > +
> > > > > +error_alloc:
> > > > > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > > > > +		if (vcpu->arch.hdbss.base_phys)
> > > > > +			kvm_arm_vcpu_free_hdbss(vcpu);
> > > > > +	}
> > > > > +
> > > > > +	return -ENOMEM;
> > > > > +}
> > > > > +
> > > > >    int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > > > >    			    struct kvm_enable_cap *cap)
> > > > >    {
> > > > > @@ -182,6 +263,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > > > >    		r = 0;
> > > > >    		set_bit(KVM_ARCH_FLAG_EXIT_SEA, &kvm->arch.flags);
> > > > >    		break;
> > > > > +	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
> > > > > +		mutex_lock(&kvm->lock);
> > > > > +		r = kvm_cap_arm_enable_hdbss(kvm, cap);
> > > > > +		mutex_unlock(&kvm->lock);
> > > > > +		break;
> > > > >    	default:
> > > > >    		break;
> > > > >    	}
> > > > > @@ -471,6 +557,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> > > > >    			r = kvm_supports_cacheable_pfnmap();
> > > > >    		break;
> > > > > 
> > > > > +	case KVM_CAP_ARM_HW_DIRTY_STATE_TRACK:
> > > > > +		r = system_supports_hdbss();
> > > > > +		break;
> > > > >    	default:
> > > > >    		r = 0;
> > > > >    	}
> > > > > @@ -1120,6 +1209,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
> > > > >    		if (kvm_dirty_ring_check_request(vcpu))
> > > > >    			return 0;
> > > > > 
> > > > > +		if (kvm_check_request(KVM_REQ_FLUSH_HDBSS, vcpu))
> > > > > +			kvm_flush_hdbss_buffer(vcpu);
> > > > > +
> > > > >    		check_nested_vcpu_requests(vcpu);
> > > > >    	}
> > > > > 
> > > > > @@ -1898,7 +1990,17 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
> > > > > 
> > > > >    void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
> > > > >    {
> > > > > +	/*
> > > > > +	 * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
> > > > > +	 * before reporting dirty_bitmap to userspace. Send a request with
> > > > > +	 * KVM_REQUEST_WAIT to flush buffer synchronously.
> > > > > +	 */
> > > > > +	struct kvm_vcpu *vcpu;
> > > > > +
> > > > > +	if (!kvm->arch.enable_hdbss)
> > > > > +		return;
> > > > > 
> > > > > +	kvm_make_all_cpus_request(kvm, KVM_REQ_FLUSH_HDBSS);
> > > > >    }
> > > > > 
> > > > >    static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> > > > > diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> > > > > index 9db3f11a4754..600cbc4f8ae9 100644
> > > > > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > > > > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > > > > @@ -213,6 +213,23 @@ static void __vcpu_put_deactivate_traps(struct kvm_vcpu *vcpu)
> > > > >    	local_irq_restore(flags);
> > > > >    }
> > > > > 
> > > > > +static void __load_hdbss(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +	struct kvm *kvm = vcpu->kvm;
> > > > > +	u64 br_el2, prod_el2;
> > > > > +
> > > > > +	if (!kvm->arch.enable_hdbss)
> > > > > +		return;
> > > > > +
> > > > > +	br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu->arch.hdbss.size);
> > > > > +	prod_el2 = vcpu->arch.hdbss.next_index;
> > > > > +
> > > > > +	write_sysreg_s(br_el2, SYS_HDBSSBR_EL2);
> > > > > +	write_sysreg_s(prod_el2, SYS_HDBSSPROD_EL2);
> > > > > +
> > > > > +	isb();
> > > > > +}
> > > > > +
> > > > I see in the code below you trust that the tracking will happen with
> > > > PAGE_SIZE granularity (you track with PAGE_SHIFT).
> > > > 
> > > > That may be a problem when we have guest memory backed by hugepages or
> > > > transparent huge pages.
> > > > 
> > > > When we are using HDBSS, there is no fault happening, so we have no way of
> > > > doing on-demand block splitting, so we need to make use of eager block
> > > > splitting, _before_ we start to track anything, or else we may have
> > > > different-sized pages in the HDBSS buffer, which is harder to deal with.
> > > > 
> > > > Suggestion: do the eager splitting before we enable HDBSS.
> > > > 
> > > > For this to happen, we have to enable the EAGER_SPLIT_CHUNK_SIZE
> > > > capability, which can only be enabled when all memslots are empty.
> > > > 
> > > > I suggest doing that at kvm_init_stage2_mmu(), and checking if HDBSS is
> > > > in which case we set mmu->split_page_chunk_size to PAGESIZE.
> > > > 
> > > > I will send a patch you can put before this one to make sure it works :)
> > > > 
> > > > Thanks!
> > > > Leo
> > > Hi Leo,
> > > 
> > > Thanks for the helpful suggestion. I had previously traced the
> > > hugepage-splitting path
> > > 
> > > during live migration and found that when migration starts, enabling dirty
> > > logging
> > > 
> > > triggers the splitting path. I also tested HDBSS with traditional hugepages
> > > and haven't
> > > 
> > > observed any issues yet.
> > > 
> > > 
> > > However, your concern is valid — there may be cases not covered, especially
> > > when the
> > > 
> > > VMM uses transparent hugepages. I'll integrate your patch into the next
> > > version and
> > > 
> > > run some tests.
> > > 
> > > 
> > > For reference, here's the path I traced:
> > > 
> > > ```
> > > 
> > > - userspace, e.g., QEMU
> > > 
> > > kvm_log_start
> > > +-> kvm_section_update_flags
> > >      +-> kvm_slot_update_flags
> > >          |
> > >          | // For each memory region, QEMU issues a
> > > KVM_SET_USER_MEMORY_REGION ioctl.
> > >          | // Before issuing it, flags are updated to include
> > > KVM_MEM_LOG_DIRTY_PAGES.
> > >          +-> kvm_mem_flags
> > >          +-> kvm_set_user_memory_region   // ioctl that enables dirty logging
> > > on the memslot
> > > 
> > > - KVM
> > > 
> > > KVM_SET_USER_MEMORY_REGION
> > > +-> kvm_vm_ioctl_set_memory_region
> > >      +-> kvm_set_memory_region / __kvm_set_memory_region
> > >          +-> kvm_set_memslot
> > >              +-> kvm_commit_memory_region
> > >                  +-> kvm_arch_commit_memory_region
> > >                      +-> kvm_mmu_split_memory_region
> > >                          // Splits Stage-2 hugepages/contiguous mappings into
> > > 4KB PTEs.
> > Right, except on a case we have dirty_log_manual_protect and init_set, when
> > it returns before splitting pages:
> > 
> > ```
> > if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> > 	return;
> > ```
> > 
> > IIUC, that's desired to avoid holding the lock for a long time while it
> > cleans every page in the beginning, and instead do it in a per dirty-page
> > basis. I guess it may benefit guests with very little dirty pages, as it
> > does not have to split/dirty everything at the start.
> > (Its a pain for my HACDBS routines, though)
> > 
> > >                          +-> kvm_mmu_split_huge_pages
> > Other important point here:
> > You can see in this function it skips splitting if chunk_size == 0.
> > This value is set by a capability that configures EAGER_SPLIT, meaning
> > splitting before the guest have write faults, which is nice as the
> > write-fault is faster.
> > 
> > Two points in this capability:
> > - It's optional, if it's not set, only on-demand splitting (on fault) will
> >    happen, and since HDBSS removes the write-fault, we have no splitting
> > - It can be set to any valid block size, not only 4K, nor PAGE_SIZE, it can
> >    be set to PMD_SIZE, PUD_SIZE, and so on, which will depend on the
> >    PAGE_SIZE the kernel was compiled to.
> > That's only some points to keep in mind :)
> > 
> > 		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> > 			return;
> > 
> > >                              +-> kvm_pgtable_stage2_split
> > > 
> > > ```
> > > 
> > > Thanks again for the detailed explanation and for sending the patch.
> > > 
> > Thank you for the collaboration on this!
> > Leo
> 
> 
> Thanks for the detailed explanation — very helpful. My earlier tests missed
> cases like lazy splitting
> 
> and manual‑protect mode, and your patch addresses them perfectly.
> 
> I'll adopt it in the next version and test the corner cases you mentioned.

Awesome, thanks!
Leo 

