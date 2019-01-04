From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 6/11] KVM/MMU: Flush tlb with range list in sync_page()
Date: Fri, 4 Jan 2019 08:30:35 -0800
Message-ID: <20190104163035.GC11288@linux.intel.com>
References: <20190104085405.40356-1-Tianyu.Lan@microsoft.com>
 <20190104085405.40356-7-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190104085405.40356-7-Tianyu.Lan@microsoft.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: lantianyu1986@gmail.com
Cc: kvm@vger.kernel.org, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, benh@kernel.crashing.org, jhogan@kernel.org, linux-mips@vger.kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, christoffer.dall@arm.com, ralf@linux-mips.org, paul.burton@mips.com, pbonzini@redhat.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 04, 2019 at 04:54:00PM +0800, lantianyu1986@gmail.com wrote:
> From: Lan Tianyu <Tianyu.Lan@microsoft.com>
> 
> This patch is to flush tlb via flush list function.

More explanation of why this is beneficial would be nice.  Without the
context of the overall series it's not immediately obvious what
kvm_flush_remote_tlbs_with_list() does without a bit of digging.

> 
> Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
> ---
>  arch/x86/kvm/paging_tmpl.h | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 833e8855bbc9..866ccdea762e 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -973,6 +973,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  	bool host_writable;
>  	gpa_t first_pte_gpa;
>  	int set_spte_ret = 0;
> +	LIST_HEAD(flush_list);
>  
>  	/* direct kvm_mmu_page can not be unsync. */
>  	BUG_ON(sp->role.direct);
> @@ -980,6 +981,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
>  
>  	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> +		int tmp_spte_ret = 0;
>  		unsigned pte_access;
>  		pt_element_t gpte;
>  		gpa_t pte_gpa;
> @@ -1029,14 +1031,24 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  
>  		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;
>  
> -		set_spte_ret |= set_spte(vcpu, &sp->spt[i],
> +		tmp_spte_ret = set_spte(vcpu, &sp->spt[i],
>  					 pte_access, PT_PAGE_TABLE_LEVEL,
>  					 gfn, spte_to_pfn(sp->spt[i]),
>  					 true, false, host_writable);
> +
> +		if (kvm_available_flush_tlb_with_range()
> +		    && (tmp_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH)) {
> +			struct kvm_mmu_page *leaf_sp = page_header(sp->spt[i]
> +					& PT64_BASE_ADDR_MASK);
> +			list_add(&leaf_sp->flush_link, &flush_list);
> +		}
> +
> +		set_spte_ret |= tmp_spte_ret;
> +
>  	}
>  
>  	if (set_spte_ret & SET_SPTE_NEED_REMOTE_TLB_FLUSH)
> -		kvm_flush_remote_tlbs(vcpu->kvm);
> +		kvm_flush_remote_tlbs_with_list(vcpu->kvm, &flush_list);

This is a bit confusing and potentially fragile.  It's not obvious that
kvm_flush_remote_tlbs_with_list() is guaranteed to call
kvm_flush_remote_tlbs() when kvm_available_flush_tlb_with_range() is
false, and you're relying on the kvm_flush_remote_tlbs_with_list() call
chain to never optimize away the empty list case.  Rechecking
kvm_available_flush_tlb_with_range() isn't expensive.

>  
>  	return nr_present;
>  }
> -- 
> 2.14.4
> 
