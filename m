From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 04/13] arm64: alternatives: use tpidr_el2 on VHE hosts
Date: Mon, 16 Oct 2017 11:17:37 +0100
Message-ID: <20171016101736.fkaikxflyc46zczf@armageddon.cambridge.arm.com>
References: <20170922182614.27885-1-james.morse@arm.com>
 <20170922182614.27885-5-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E590549D29
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 06:16:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RBPxaTkU-pW8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 06:16:47 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB4B040017
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 06:16:47 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170922182614.27885-5-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: devicetree@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, Loc Ho <lho@apm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 22, 2017 at 07:26:05PM +0100, James Morse wrote:
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 29adab8138c3..8f2d0f7d193b 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -193,5 +193,6 @@ static inline void spin_lock_prefetch(const void *ptr)
>  
>  int cpu_enable_pan(void *__unused);
>  int cpu_enable_cache_maint_trap(void *__unused);
> +int cpu_copy_el2regs(void *__unused);
>  
>  #endif /* __ASM_PROCESSOR_H */
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index cd52d365d1f0..8e4c7da2b126 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
[...]
> +int cpu_copy_el2regs(void *__unused)

Can this be static? I couldn't find it used anywhere else apart from
cpufeature.c

-- 
Catalin
