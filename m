Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F05303DD879
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 13:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781271743; cv=none; b=o53C6BfFHiypTnvNhAx+6VaJi08soKxzPCIqtr+e/Jz69RyCqerjC2dl0awGJplKsuKTxu1fbvIhM/6QUICEfKKpWgrejU7qs0nTBqeojRrpgWxICRH2NxLg+u5LusOKMYjY2H0DusAmsDQdC9IU0xt0CPeKADlDsm5gzs8s6OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781271743; c=relaxed/simple;
	bh=eua9MmlsAPXk7l/PzmixtKYHLsF1xQ8UDUBR4GoTHd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sLcyUb3upi8v3SXH2K6QgcadK0nh9Spcec+ROJRy6JloMr1aWK20mPfSmGK89hVf0r8lyTt4pl6jLMm8b0FPsS0IrAgwCsgq1OSi94KFZAIEH36kxBbRLm/lrlQbM0n61tII0wkGP4c+SXCogb8taPLOmNJ239sxE2vgO+C8noc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Khe+2Z2f; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Khe+2Z2f"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30B272C42;
	Fri, 12 Jun 2026 06:42:07 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 54D693FBB1;
	Fri, 12 Jun 2026 06:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781271731; bh=eua9MmlsAPXk7l/PzmixtKYHLsF1xQ8UDUBR4GoTHd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Khe+2Z2fsukSNEUHG5rT5+g5dmxqOYQJNKluIlN0/UQsXFyUsYe0BFDBeWEIPMz49
	 D1qB5JthIFBbxs33MzDr/uolLGNNilkIq99MEJKExQ+zjwkc73VRPEosI76r7qw6Vk
	 n8Dt97aAMVTSQ64P9brFnMZvQR61XLqVZkBYG4oM=
Date: Fri, 12 Jun 2026 14:41:59 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: arm64: nv: Expose shadow page tables in
 debugfs
Message-ID: <5djyymfv4a2anfo4gf2uk5xdscrlyjnmznsucmubmouz4qs6fp@m2emhgb2kivp>
References: <20260317182638.1592507-1-weilin.chang@arm.com>
 <20260317182638.1592507-3-weilin.chang@arm.com>
 <aiuF0KSvvv-ZozI1@sm-arm-grace07>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiuF0KSvvv-ZozI1@sm-arm-grace07>

Hi Itaru,

On Fri, Jun 12, 2026 at 01:06:40PM +0900, Itaru Kitayama wrote:
> Hi Wei Lin,
> On Tue, Mar 17, 2026 at 06:26:38PM +0000, Wei-Lin Chang wrote:
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
> 
> This function can sleep, so I get while running your shadow stage 2 KVM
> selftest a messge:
> 
> [ 4408.411009] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1624
> [ 4408.411075] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 164, name: shadow_stage2
> [ 4408.411136] preempt_count: 2, expected: 0
> [ 4408.411172] RCU nest depth: 0, expected: 0
> [ 4408.411228] CPU: 1 UID: 0 PID: 164 Comm: shadow_stage2 Tainted: G        W           7.1.0-rc2+ #48 PREEMPT(full)
> [ 4408.411336] Tainted: [W]=WARN
> [ 4408.411368] Hardware name:  , BIOS
> [ 4408.411403] Call trace:
> [ 4408.411427]  show_stack+0x24/0x50 (C)
> [ 4408.411524]  dump_stack_lvl+0x90/0x158
> [ 4408.411633]  dump_stack+0x1c/0x38
> [ 4408.411741]  __might_resched+0x168/0x208
> [ 4408.411839]  __might_sleep+0x54/0xb0
> [ 4408.411936]  down_write+0x30/0xe8
> [ 4408.412048]  start_dirop+0x3c/0xc0
> [ 4408.412149]  simple_start_creating+0xb8/0xc8
> [ 4408.412241]  debugfs_start_creating.part.0+0x68/0x180
> [ 4408.412375]  __debugfs_create_file+0x80/0x1f8
> [ 4408.412505]  debugfs_create_file_full+0x28/0x68
> [ 4408.412637]  kvm_nested_s2_ptdump_create_debugfs+0xa0/0x108
> [ 4408.412734]  kvm_vcpu_load_hw_mmu+0x27c/0x320
> [ 4408.412839]  kvm_arch_vcpu_load+0x318/0x5a0
> [ 4408.412971]  kvm_emulate_nested_eret+0x148/0x3d8
> [ 4408.413072]  kvm_handle_eret+0x110/0x138
> [ 4408.413190]  handle_exit+0x6c/0x1e8
> [ 4408.413306]  kvm_arch_vcpu_ioctl_run+0x3c4/0xc90
> [ 4408.413396]  kvm_vcpu_ioctl+0x1a0/0xa68
> [ 4408.413508]  __arm64_sys_ioctl+0xd0/0x160
> [L1] L2 exit[ 4408.413631]  invoke_syscall+0xa8/0x138
> [ 4408.413723]  el0_svc_common.constprop.0+0x4c/0x140
> [ 4408.413821]  do_el0_svc+0x28/0x58
> [ 4408.413911]  el0_svc+0x48/0x230
> [ 4408.414035]  el0t_64_sync_handler+0xc0/0x108
> [ 4408.414166]  el0t_64_sync+0x1b4/0x1b8
> 
> I tried to move this function out under the KVM MMU lock, but then I see
> a debug entry is duplicated error. I am not sure where exactly this 
> nested stage 2 debugfs entry create function should go, your help is
> much appreciated.

Thanks for your report!

I think this is a real problem, and it's not trivial to solve..
As per the backtrace, debugfs_create_file() can sleep, and our context
is not only holding the mmu_lock, but also non-preemptable.

Moving the file creation out of the mmu_lock triggers debug entry
duplication because multiple vCPUs can be using the same s2 context.
Originally in get_s2_mmu_nested() creation is triggered for the case of
first use (refcnt 0 -> 1).

Adding a check for first use (refcnt == 1) outside of the mmu_lock also
doesn't help. Once outside the lock there is no guarantee what the
refcnt of the s2 mmu is, other than it will be >= 1, because we just got
one reference. As an example both vCPU threads can believe they are the
second user, and none creates the file. Additionally,
kvm_vcpu_load_hw_mmu() is still non-preemptable.

After analyzing the above, I think we have to change how this works.
I am thinking instead of dynamic debugfs files, we move to a static "all
shadow stage-2 ptdump" file (thanks to AI for pointing out this
possibility), whose lifetime is tied to the VM, same as the other KVM
ptdump files. When the file needs to read the shadow stage-2s, we take
the lock.

Let me know if you find this bad or wrong! In the mean time I'll try
this out.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Itaru.
> 
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
> > +
> > +	dent = debugfs_create_file(file_name, 0400,
> > +				   mmu->arch->debugfs_nv_dentry, mmu,
> > +				   &kvm_ptdump_guest_fops);
> > +
> > +	mmu->shadow_pt_debugfs_dentry = dent;
> > +}
> > +
> > +void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu)
> > +{
> > +	debugfs_remove(mmu->shadow_pt_debugfs_dentry);
> > +}
> > +
> >  void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
> >  {
> >  	debugfs_create_file("stage2_page_tables", 0400, kvm->debugfs_dentry,
> > @@ -285,4 +309,7 @@ void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
> >  			    &kvm->arch.mmu, &kvm_pgtable_range_fops);
> >  	debugfs_create_file("stage2_levels", 0400, kvm->debugfs_dentry,
> >  			    &kvm->arch.mmu, &kvm_pgtable_levels_fops);
> > +	if (cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
> > +		kvm->arch.debugfs_nv_dentry =
> > +			debugfs_create_dir("nested", kvm->debugfs_dentry);
> >  }
> > -- 
> > 2.43.0
> > 
