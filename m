From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 6/6] KVM: arm/arm64: Remove unnecessary CMOs when
 creating HYP page tables
Date: Thu, 31 May 2018 13:01:41 +0100
Message-ID: <20180531120141.sx3ufjl3k2etwi3f@lakrids.cambridge.arm.com>
References: <20180530124706.25284-1-marc.zyngier@arm.com>
 <20180530124706.25284-7-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180530124706.25284-7-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 30, 2018 at 01:47:06PM +0100, Marc Zyngier wrote:
> There is no need to perform cache maintenance operations when
> creating the HYP page tables if we have the multiprocessing
> extensions. ARMv7 mandates them with the virtualization support,
> and ARMv8 just mandates them unconditionally.
> 
> Let's remove these operations.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  virt/kvm/arm/mmu.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index ad1980d2118a..ccdf544d44c0 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -607,7 +607,6 @@ static void create_hyp_pte_mappings(pmd_t *pmd, unsigned long start,
>  		pte = pte_offset_kernel(pmd, addr);
>  		kvm_set_pte(pte, pfn_pte(pfn, prot));
>  		get_page(virt_to_page(pte));
> -		kvm_flush_dcache_to_poc(pte, sizeof(*pte));
>  		pfn++;
>  	} while (addr += PAGE_SIZE, addr != end);
>  }
> @@ -634,7 +633,6 @@ static int create_hyp_pmd_mappings(pud_t *pud, unsigned long start,
>  			}
>  			kvm_pmd_populate(pmd, pte);
>  			get_page(virt_to_page(pmd));
> -			kvm_flush_dcache_to_poc(pmd, sizeof(*pmd));
>  		}
>  
>  		next = pmd_addr_end(addr, end);
> @@ -667,7 +665,6 @@ static int create_hyp_pud_mappings(pgd_t *pgd, unsigned long start,
>  			}
>  			kvm_pud_populate(pud, pmd);
>  			get_page(virt_to_page(pud));
> -			kvm_flush_dcache_to_poc(pud, sizeof(*pud));
>  		}
>  
>  		next = pud_addr_end(addr, end);
> @@ -704,7 +701,6 @@ static int __create_hyp_mappings(pgd_t *pgdp, unsigned long ptrs_per_pgd,
>  			}
>  			kvm_pgd_populate(pgd, pud);
>  			get_page(virt_to_page(pgd));
> -			kvm_flush_dcache_to_poc(pgd, sizeof(*pgd));
>  		}
>  
>  		next = pgd_addr_end(addr, end);
> -- 
> 2.17.1
> 
