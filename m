Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D84CF2BDC2A
	for <kvmarm@lists.linux.dev>; Sat, 21 Mar 2026 16:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774111022; cv=none; b=goucGMom/JYPOjpJVlVHXR7G4dT2YXfv3d92kDE8Hy1lmzpYHF/XbHZ3NNZP2LADctpoS/cMbKYRb70oE2bXGgQnryNbYNLCPsLXnNQpCr0S7iW56VXoc7Y8+Oe3tBK507Xt//Z/x7AHRP/nDyYDAShLAxb+z0yQeb71SBpazKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774111022; c=relaxed/simple;
	bh=smw3duiw3HLZnHVY1cSpk4wlobxyDP1aZsvgRk9KBBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RnAbLr5YFxjCjnWsTkAoNE2r29pyXj3Rl5yB4VLqGB9uPdy1mPgWDb6mqK7jPJTcqkQO/KzHiw/4h7o7XviX5AQvePjLOEKP00I7gtIZiwSdyazyU6noCNHmoA2Y8wFpB8HG9uXa6qQ3/T3vOtn/azGuuy/Uh3J9ZNUvEQDc5ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 499BA1595;
	Sat, 21 Mar 2026 09:36:52 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E96A3F73B;
	Sat, 21 Mar 2026 09:36:56 -0700 (PDT)
Date: Sat, 21 Mar 2026 16:36:46 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: arm64: nv: Expose shadow page tables in
 debugfs
Message-ID: <iqpnht3m3kjpndbqvolokdgtdek7rdfv3ronc6omrmwz5oxrfc@l464rbgvnjxe>
References: <20260317182638.1592507-1-weilin.chang@arm.com>
 <20260317182638.1592507-3-weilin.chang@arm.com>
 <86bjgj6c5s.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bjgj6c5s.wl-maz@kernel.org>

On Thu, Mar 19, 2026 at 04:01:51PM +0000, Marc Zyngier wrote:
> On Tue, 17 Mar 2026 18:26:38 +0000,
> Wei-Lin Chang <weilin.chang@arm.com> wrote:
> > 
> > Exposing shadow page tables in debugfs improves the debugability and
> > testability of NV. With this patch a new directory "nested" is created
> > for each VM created if the host is NV capable. Within the directory each
> > valid s2 mmu will have its shadow page table exposed as a readable file
> > with the file name formatted as 0x<vttbr>-0x<vtcr>-s2-{en,dis}abled. The
> > creation and removal of the files happen at the points when an s2 mmu
> > becomes valid, or the context it represents change. In the future the
> > "nested" directory can also hold other NV related information.
> > 
> > This is gated behind CONFIG_PTDUMP_STAGE2_DEBUGFS.
> > 
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Reviewed-by: Sebastian Ene <sebastianene@google.com>
> > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  9 +++++++++
> >  arch/arm64/include/asm/kvm_mmu.h  |  4 ++++
> >  arch/arm64/kvm/nested.c           |  6 +++++-
> >  arch/arm64/kvm/ptdump.c           | 27 +++++++++++++++++++++++++++
> >  4 files changed, 45 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 5d5a3bbdb95e..52977c9a11c3 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -217,6 +217,10 @@ struct kvm_s2_mmu {
> >  	 */
> >  	bool	nested_stage2_enabled;
> >  
> > +#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> > +	struct dentry *shadow_pt_debugfs_dentry;
> > +#endif
> > +
> >  	/*
> >  	 * true when this MMU needs to be unmapped before being used for a new
> >  	 * purpose.
> > @@ -405,6 +409,11 @@ struct kvm_arch {
> >  	 * the associated pKVM instance in the hypervisor.
> >  	 */
> >  	struct kvm_protected_vm pkvm;
> > +
> > +#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> > +	/* Nested virtualization info */
> > +	struct dentry *debugfs_nv_dentry;
> > +#endif
> >  };
> >  
> >  struct kvm_vcpu_fault_info {
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index d968aca0461a..01e9c72d6aa7 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -393,8 +393,12 @@ static inline bool kvm_supports_cacheable_pfnmap(void)
> >  
> >  #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> >  void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
> > +void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu);
> > +void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu);
> >  #else
> >  static inline void kvm_s2_ptdump_create_debugfs(struct kvm *kvm) {}
> > +static inline void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu) {}
> > +static inline void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu) {}
> >  #endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
> >  
> >  #endif /* __ASSEMBLER__ */
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index eeea5e692370..31d74ed8449e 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -730,8 +730,10 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
> >  	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
> >  
> >  	/* Make sure we don't forget to do the laundry */
> > -	if (kvm_s2_mmu_valid(s2_mmu))
> > +	if (kvm_s2_mmu_valid(s2_mmu)) {
> > +		kvm_nested_s2_ptdump_remove_debugfs(s2_mmu);
> >  		s2_mmu->pending_unmap = true;
> > +	}
> >  
> >  	/*
> >  	 * The virtual VMID (modulo CnP) will be used as a key when matching
> > @@ -745,6 +747,8 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
> >  	s2_mmu->tlb_vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
> >  	s2_mmu->nested_stage2_enabled = vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_VM;
> >  
> > +	kvm_nested_s2_ptdump_create_debugfs(s2_mmu);
> > +
> >  out:
> >  	atomic_inc(&s2_mmu->refcnt);
> >  
> > diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> > index 98763b291956..aebbbad85d38 100644
> > --- a/arch/arm64/kvm/ptdump.c
> > +++ b/arch/arm64/kvm/ptdump.c
> > @@ -10,12 +10,14 @@
> >  #include <linux/kvm_host.h>
> >  #include <linux/seq_file.h>
> >  
> > +#include <asm/cpufeature.h>
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/kvm_pgtable.h>
> >  #include <asm/ptdump.h>
> >  
> >  #define MARKERS_LEN		2
> >  #define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
> > +#define S2FNAMESZ	sizeof("0x0123456789abcdef-0x0123456789abcdef-s2-disabled")
> >  
> >  struct kvm_ptdump_guest_state {
> >  	struct kvm_s2_mmu	*mmu;
> > @@ -277,6 +279,28 @@ static const struct file_operations kvm_pgtable_levels_fops = {
> >  	.release	= kvm_pgtable_debugfs_close,
> >  };
> >  
> > +void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu)
> > +{
> > +	struct dentry *dent;
> > +	char file_name[S2FNAMESZ];
> > +
> > +	snprintf(file_name, sizeof(file_name), "0x%llx-0x%llx-s2-%sabled",
> > +		 mmu->tlb_vttbr,
> > +		 mmu->tlb_vtcr,
> > +		 mmu->nested_stage2_enabled ? "en" : "dis");
> 
> Here's an example of this code in action:
> 
> root@semi-fraudulent:/home/maz/vminstall# ls -l /sys/kernel/debug/kvm/932-4/nested/
> total 0
> -r-------- 1 root root 0 Mar 19 11:58 0x0-0x80000000-s2-disabled
> -r-------- 1 root root 0 Mar 19 12:01 0x100010124c000-0x800c3558-s2-enabled
> -r-------- 1 root root 0 Mar 19 15:06 0x200010d916000-0x800c3558-s2-enabled
> -r-------- 1 root root 0 Mar 19 15:16 0x30001027ec000-0x800c3558-s2-enabled
> 
> I think these hex values should always be padded with leading zeroes,
> making them more readable.
> 
> I can hack that in as I queue the patches.

Ack, thank you so much!

Thanks,
Wei-Lin Chang

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
