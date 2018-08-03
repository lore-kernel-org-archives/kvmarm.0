From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/4] arm/arm64: GICv2: add
 GICD_IPRIORITYR testing
Date: Fri, 3 Aug 2018 15:12:33 +0200
Message-ID: <20180803131233.7wt7skawns3wdzqc@kamzik.brq.redhat.com>
References: <20180720153942.26821-1-andre.przywara@arm.com>
 <20180720153942.26821-4-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CFA649E3E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Aug 2018 09:12:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rHZH2mT6pGrq for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Aug 2018 09:12:40 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3ED454005D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Aug 2018 09:12:40 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180720153942.26821-4-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 20, 2018 at 04:39:41PM +0100, Andre Przywara wrote:
> Some tests for the IPRIORITY registers. The significant number of bits
> is IMPLEMENTATION DEFINED, but should be the same for every IRQ.
> Also these registers must be byte-accessible.
> Check that accesses beyond the implemented IRQ limit are actually
> read-as-zero/write-ignore.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 79 insertions(+)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 23cb9a4..57a2995 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -354,6 +354,83 @@ static void test_typer_v2(uint32_t reg)
>  	       nr_gic_cpus);
>  }
>  
> +#define BYTE(reg32, byte) (((reg32) >> ((byte) * 8)) & 0xff)
> +#define REPLACE_BYTE(reg32, byte, new) (((reg32) & ~(0xff << ((byte) * 8))) |\
> +					((new) << ((byte) * 8)))
> +
> +/*
> + * Some registers are byte accessible, do a byte-wide read and write of known
> + * content to check for this.
> + * Apply a @mask to cater for special register properties.
> + * @pattern contains the value already in the register.
> + */
> +static void test_byte_access(void *base_addr, u32 pattern, u32 mask)
> +{
> +	u32 reg = readb(base_addr + 1);
> +
> +	report("byte reads successful (0x%08x => 0x%02x)",
> +	       reg == (BYTE(pattern, 1) & (mask >> 8)),
> +	       pattern & mask, reg);
> +
> +	pattern = REPLACE_BYTE(pattern, 2, 0x1f);
> +	writeb(BYTE(pattern, 2), base_addr + 2);
> +	reg = readl(base_addr);
> +	report("byte writes successful (0x%02x => 0x%08x)",
> +	       reg == (pattern & mask), BYTE(pattern, 2), reg);
> +}

Hmm, should the above test prepare itself for a potential alignment fault?

Thanks,
drew
