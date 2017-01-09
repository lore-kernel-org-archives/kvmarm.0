From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC] arm64: KVM: Honor guest device memory type mappings
Date: Mon, 9 Jan 2017 10:26:21 +0000
Message-ID: <742b9e8f-168d-81bf-368c-0f094d6cc124@arm.com>
References: <1481317164-2511-1-git-send-email-mike.caraman@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88DC640354
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 05:24:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BbvmYOq3Nhad for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 05:24:43 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 45095400F9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 05:24:43 -0500 (EST)
In-Reply-To: <1481317164-2511-1-git-send-email-mike.caraman@nxp.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Caraman Mihai Claudiu-B02008 <mike.caraman@nxp.com>, kvmarm@lists.cs.columbia.edu
Cc: david.lapp@nxp.com, Catalin Marinas <catalin.marinas@arm.com>, roy.pledge@nxp.com, Will Deacon <will.deacon@arm.com>, stuart.yoder@nxp.com
List-Id: kvmarm@lists.cs.columbia.edu

[+ Christoffer, Will, Catalin - In the future, please Cc the relevant
maintainers]

On 09/12/16 20:59, Caraman Mihai Claudiu-B02008 wrote:
> From: Mihai Caraman <mike.caraman@nxp.com>
> 
> Stage 2 non-Gathering and non-Reordering memory attributes have precedence over stage 1
> Gathering and Reordering attributes. Honor guest device memory type mappings using GRE
> memory type at stage 2.

This feels incredibly scary. One you start enabling gathering and
reordering, there is nothing that prevents a write to a device from a
given guest to be merged or reordered with a write from another guest to
the same device (think of the GIC). This would only require one of the
guests to use GRE attributes itself.

So as it stands, my feeling is that it is a big NO.

> This is a preamble for a bigger change that will honor guest normal memory mappings for
> targets connected to HN-F interfaces.

Normal memory mappings for devices? Unless you can prove that this is a
valid architectural configuration, this is unlikely to happen. And I'm
not keen on taking any such change before seeing the whole thing.

> 
> Signed-off-by: Mihai Caraman <mike.caraman@nxp.com>
> ---
>  arch/arm64/include/asm/memory.h       | 2 +-
>  arch/arm64/include/asm/pgtable-prot.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index b71086d..d4834ba 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -134,7 +134,7 @@
>   * Memory types for Stage-2 translation
>   */
>  #define MT_S2_NORMAL		0xf
> -#define MT_S2_DEVICE_nGnRE	0x1
> +#define MT_S2_DEVICE_GRE	0x3
>  
>  #ifdef CONFIG_ARM64_4K_PAGES
>  #define IOREMAP_MAX_ORDER	(PUD_SHIFT)
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index 2142c77..11b43f7 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -61,7 +61,7 @@
>  #define PAGE_HYP_DEVICE		__pgprot(PROT_DEVICE_nGnRE | PTE_HYP)
>  
>  #define PAGE_S2			__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_NORMAL) | PTE_S2_RDONLY)
> -#define PAGE_S2_DEVICE		__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_UXN)
> +#define PAGE_S2_DEVICE		__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_DEVICE_GRE) | PTE_S2_RDONLY | PTE_UXN)
>  
>  #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_VALID) | PTE_PROT_NONE | PTE_PXN | PTE_UXN)
>  #define PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN | PTE_UXN | PTE_WRITE)
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
