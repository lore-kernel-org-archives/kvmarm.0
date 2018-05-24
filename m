From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 3/4] KVM: arm/arm64: Remove unnecessary CMOs when
 creating HYP page tables
Date: Thu, 24 May 2018 18:12:38 +0100
Message-ID: <20180524171238.ni2hclcmhcfv7dpb@lakrids.cambridge.arm.com>
References: <20180517103548.5622-1-marc.zyngier@arm.com>
 <20180517103548.5622-4-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180517103548.5622-4-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 17, 2018 at 11:35:47AM +0100, Marc Zyngier wrote:
> There is no need to perform cache maintenance operations when
> creating the HYP page tables if we have the multiprocessing
> extensions. ARMv7 mandates them with the virtualization support,
> and ARMv8 just mandates them unconditionally.
> 
> Let's remove these operations.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/mmu.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index ba66bf7ae299..acbfea09578c 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -578,7 +578,6 @@ static void create_hyp_pte_mappings(pmd_t *pmd, unsigned long start,
>  		pte = pte_offset_kernel(pmd, addr);
>  		kvm_set_pte(pte, pfn_pte(pfn, prot));
>  		get_page(virt_to_page(pte));
> -		kvm_flush_dcache_to_poc(pte, sizeof(*pte));
>  		pfn++;
>  	} while (addr += PAGE_SIZE, addr != end);
>  }
> @@ -605,7 +604,6 @@ static int create_hyp_pmd_mappings(pud_t *pud, unsigned long start,
>  			}
>  			pmd_populate_kernel(NULL, pmd, pte);
>  			get_page(virt_to_page(pmd));
> -			kvm_flush_dcache_to_poc(pmd, sizeof(*pmd));
>  		}
>  
>  		next = pmd_addr_end(addr, end);
> @@ -638,7 +636,6 @@ static int create_hyp_pud_mappings(pgd_t *pgd, unsigned long start,
>  			}
>  			pud_populate(NULL, pud, pmd);
>  			get_page(virt_to_page(pud));
> -			kvm_flush_dcache_to_poc(pud, sizeof(*pud));
>  		}
>  
>  		next = pud_addr_end(addr, end);
> @@ -675,7 +672,6 @@ static int __create_hyp_mappings(pgd_t *pgdp, unsigned long ptrs_per_pgd,
>  			}
>  			pgd_populate(NULL, pgd, pud);
>  			get_page(virt_to_page(pgd));
> -			kvm_flush_dcache_to_poc(pgd, sizeof(*pgd));
>  		}
>  
>  		next = pgd_addr_end(addr, end);
> @@ -685,6 +681,7 @@ static int __create_hyp_mappings(pgd_t *pgdp, unsigned long ptrs_per_pgd,
>  		pfn += (next - addr) >> PAGE_SHIFT;
>  	} while (addr = next, addr != end);
>  out:
> +	dsb(ishst);

I think you need a dsb(ishst) wherever you had a
kvm_flush_dcache_to_poc() previously.

Otherwise, the page table walker could see stale values. e.g. after you
update a bunch of PTE entries and point a PMD entry at those, the PTW
could see the updated PMD entry, but see stale PTE entries, which could
be garbage.

That said, I think for ensuring the *order* those become visible in, you
only need a dmb(ishst), and the ensure they *are visible* you need a
DSB(ISHST) at the end.

Thanks,
Mark.
