From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 6/8] ARM: Change MPIDR_AFFINITY_LEVEL to ignore Aff3
Date: Fri, 9 Sep 2016 17:59:43 +0100
Message-ID: <57D2EA7F.9030705@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
 <1473350810-10857-7-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AB1040FA2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 12:51:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5qGZccrdms09 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2016 12:51:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 236F149AFA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 12:51:12 -0400 (EDT)
In-Reply-To: <1473350810-10857-7-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/09/16 17:06, Vladimir Murzin wrote:
> vgic-v3 driver queries CPU affinity level up to Aff3, which is valid
> for arm64.  However, for arm up to Aff2 levels are supported, so
> querying for third level ends with upper bits of MPIDR are treated as
> valid affinity level which is not true. Make sure we report zero for
> any affinity level above two.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arch/arm/include/asm/cputype.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
> index 1ee94c7..f08fac4 100644
> --- a/arch/arm/include/asm/cputype.h
> +++ b/arch/arm/include/asm/cputype.h
> @@ -55,9 +55,10 @@
>  
>  #define MPIDR_LEVEL_BITS 8
>  #define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
> +#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
>  
>  #define MPIDR_AFFINITY_LEVEL(mpidr, level) \
> -	((mpidr >> (MPIDR_LEVEL_BITS * level)) & MPIDR_LEVEL_MASK)
> +	(((mpidr & MPIDR_HWID_BITMASK) >> MPIDR_LEVEL_SHIFT(level)) & MPIDR_LEVEL_MASK)
>  
>  #define ARM_CPU_IMP_ARM			0x41
>  #define ARM_CPU_IMP_INTEL		0x69
> 

There is something I don't quite get. Is this patch really necessary?
Are there cases where we construct a MPIDR that can have Aff3 set on 32bit?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
