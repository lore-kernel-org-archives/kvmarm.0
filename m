From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v6 06/13] arm64: kernel: Prepare for a DISR user
Date: Tue, 16 Jan 2018 11:11:17 +0000
Message-ID: <c314c0e3-6956-b359-7592-69bec107f282@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-7-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EAC049DFD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 06:06:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id As5Rv0eMsYTH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jan 2018 06:06:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18E0849DE4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 06:06:23 -0500 (EST)
In-Reply-To: <20180115193906.30053-7-james.morse@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 15/01/18 19:38, James Morse wrote:
> KVM would like to consume any pending SError (or RAS error) after guest
> exit. Today it has to unmask SError and use dsb+isb to synchronise the
> CPU. With the RAS extensions we can use ESB to synchronise any pending
> SError.
> 
> Add the necessary macros to allow DISR to be read and converted to an
> ESR.
> 
> We clear the DISR register when we enable the RAS cpufeature, and the
> kernel has not executed any ESB instructions. Any value we find in DISR
> must have belonged to firmware. Executing an ESB instruction is the
> only way to update DISR, so we can expect firmware to have handled
> any deferred SError. By the same logic we clear DISR in the idle path.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>


James,

Looks fine to me. minor nit below

>   #endif	/* __ASM_EXCEPTION_H */
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 023cacb946c3..cee4ae25a5d1 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -216,6 +216,7 @@ static inline void spin_lock_prefetch(const void *ptr)
>   
>   int cpu_enable_pan(void *__unused);
>   int cpu_enable_cache_maint_trap(void *__unused);
> +int cpu_clear_disr(void *__unused);
>   
>   /* Userspace interface for PR_SVE_{SET,GET}_VL prctl()s: */
>   #define SVE_SET_VL(arg)	sve_set_current_vl(arg)
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 1281bc8263c2..115b89aeec00 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -279,6 +279,7 @@
>   #define SYS_AMAIR_EL1			sys_reg(3, 0, 10, 3, 0)
>   
>   #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
> +#define SYS_DISR_EL1			sys_reg(3, 0, 12, 1,  1)

minor nit: additional white space	                   ^^^

With that fixed,

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
