From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v2 3/6] arm64: KVM: Avoid marking pages as XN in Stage-2
 if CTR_EL0.DIC is set
Date: Sat, 9 Jun 2018 11:29:05 +0200
Message-ID: <20180609092905.GE5097@C02W217FHV2R.local>
References: <20180530124706.25284-1-marc.zyngier@arm.com>
 <20180530124706.25284-4-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180530124706.25284-4-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 30, 2018 at 01:47:03PM +0100, Marc Zyngier wrote:
> On systems where CTR_EL0.DIC is set, we don't need to perform
> icache invalidation to guarantee that we'll fetch the right
> instruction stream.
> 
> This also means that taking a permission fault to invalidate the
> icache is an unnecessary overhead.
> 
> On such systems, we can safely leave the page as being executable.
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@arm.com>

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/pgtable-prot.h | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index c66c3047400e..78b942c1bea4 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -77,8 +77,18 @@
>  		__val;							\
>  	 })
>  
> -#define PAGE_S2			__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(NORMAL) | PTE_S2_RDONLY | PTE_S2_XN)
> -#define PAGE_S2_DEVICE		__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_S2_XN)
> +#define PAGE_S2_XN							\
> +	({								\
> +		u64 __val;						\
> +		if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))		\
> +			__val = 0;					\
> +		else							\
> +			__val = PTE_S2_XN;				\
> +		__val;							\
> +	})
> +
> +#define PAGE_S2			__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(NORMAL) | PTE_S2_RDONLY | PAGE_S2_XN)
> +#define PAGE_S2_DEVICE		__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(DEVICE_nGnRE) | PTE_S2_RDONLY | PAGE_S2_XN)
>  
>  #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_VALID) | PTE_PROT_NONE | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN)
>  #define PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN | PTE_UXN | PTE_WRITE)
> -- 
> 2.17.1
> 
