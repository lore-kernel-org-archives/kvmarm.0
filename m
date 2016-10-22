From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 4/8] irqchip/gicv3-its: specialise readq and writeq
 accesses
Date: Sat, 22 Oct 2016 16:43:49 +0100
Message-ID: <20161022164349.18fe5d5a@arm.com>
References: <1477042601-15227-1-git-send-email-vladimir.murzin@arm.com>
 <1477042601-15227-5-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1477042601-15227-5-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: christoffer.dall@linaro.org, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kbuild-all@01.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 21 Oct 2016 10:36:37 +0100
Vladimir Murzin <vladimir.murzin@arm.com> wrote:

Hi Vladimir,

> readq and writeq type of assessors are not supported in AArch32, so we
> need to specialise them and glue later with series of 32-bit accesses
> on AArch32 side.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arch/arm64/include/asm/arch_gicv3.h |   16 ++++++++++++++++
>  drivers/irqchip/irq-gic-v3-its.c    |   30 +++++++++++++++---------------
>  2 files changed, 31 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
> index 4f0402a..e0ada98 100644
> --- a/arch/arm64/include/asm/arch_gicv3.h
> +++ b/arch/arm64/include/asm/arch_gicv3.h
> @@ -190,5 +190,21 @@ static inline void gic_write_bpr1(u32 val)
>  
>  #define gic_flush_dcache_to_poc(a,l)	__flush_dcache_area((a), (l))
>  
> +#define gits_read_typer(c)		readq_relaxed(c)
> +
> +#define gits_read_baser(c)		readq_relaxed(c)
> +#define gits_write_baser(v, c)		writeq_relaxed(v, c)
> +
> +#define gits_read_cbaser(c)		readq_relaxed(c)
> +#define gits_write_cbaser(v, c)		writeq_relaxed(v, c)
> +
> +#define gits_write_cwriter(v, c)	writeq_relaxed(v, c)
> +
> +#define gicr_read_propbaser(c)		readq_relaxed(c)
> +#define gicr_write_propbaser(v, c)	writeq_relaxed(v, c)
> +
> +#define gicr_write_pendbaser(v, c)	writeq_relaxed(v, c)
> +#define gicr_read_pendbaser(c)		readq_relaxed(c)
> +
>  #endif /* __ASSEMBLY__ */
>  #endif /* __ASM_ARCH_GICV3_H */
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 86efa6e..9f74abc 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -835,7 +835,7 @@ static u64 its_read_baser(struct its_node *its, struct its_baser *baser)
>  {
>  	u32 idx = baser - its->tables;
>  
> -	return readq_relaxed(its->base + GITS_BASER + (idx << 3));
> +	return gits_read_baser(its->base + GITS_BASER + (idx << 3));
>  }
>  
>  static void its_write_baser(struct its_node *its, struct its_baser *baser,
> @@ -843,7 +843,7 @@ static void its_write_baser(struct its_node *its, struct its_baser *baser,
>  {
>  	u32 idx = baser - its->tables;
>  
> -	writeq_relaxed(val, its->base + GITS_BASER + (idx << 3));
> +	gits_write_baser(val, its->base + GITS_BASER + (idx << 3));
>  	baser->val = its_read_baser(its, baser);
>  }
>  
> @@ -1022,7 +1022,7 @@ static void its_free_tables(struct its_node *its)
>  
>  static int its_alloc_tables(struct its_node *its)
>  {
> -	u64 typer = readq_relaxed(its->base + GITS_TYPER);
> +	u64 typer = gits_read_typer(its->base + GITS_TYPER);

This is going to conflict with the irq/irq-fixes-4.9 branch, which is
already on its way to mainline (and will hopefully hit -rc2) Could you
please rebase it once these patches are in mainline?

You'll notice that I didn't bother distinguishing between the various
GI*_TYPER registers, as they all have the same behaviour.

Otherwise looks good to me.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
