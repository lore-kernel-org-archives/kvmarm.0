From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: Re: [PATCHv4 06/10] arm64: add basic pointer authentication support
Date: Fri, 8 Jun 2018 14:11:32 +0100
Message-ID: <e4630a08-db4e-7c4d-5d92-393ad99a629e@arm.com>
References: <20180503132031.25705-1-mark.rutland@arm.com>
 <20180503132031.25705-7-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180503132031.25705-7-mark.rutland@arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: drjones@redhat.com, suzuki.poulose@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, awallis@codeaurora.org, will.deacon@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, ramana.radhakrishnan@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mark,

On 03/05/18 14:20, Mark Rutland wrote:
> This patch adds basic support for pointer authentication, allowing
> userspace to make use of APIAKey. The kernel maintains an APIAKey value
> for each process (shared by all threads within), which is initialised to
> a random value at exec() time.
> 
> To describe that address authentication instructions are available, the
> ID_AA64ISAR0.{APA,API} fields are exposed to userspace. A new hwcap,
> APIA, is added to describe that the kernel manages APIAKey.
> 
> Instructions using other keys (APIBKey, APDAKey, APDBKey) are disabled,
> and will behave as NOPs. These may be made use of in future patches.
> 
> No support is added for the generic key (APGAKey), though this cannot be
> trapped or made to behave as a NOP. Its presence is not advertised with
> a hwcap.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/asm/mmu.h          |  5 +++
>  arch/arm64/include/asm/mmu_context.h  | 11 ++++-
>  arch/arm64/include/asm/pointer_auth.h | 75 +++++++++++++++++++++++++++++++++++
>  arch/arm64/include/uapi/asm/hwcap.h   |  1 +
>  arch/arm64/kernel/cpufeature.c        |  9 +++++
>  arch/arm64/kernel/cpuinfo.c           |  1 +
>  6 files changed, 101 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/pointer_auth.h
> 
> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
> index dd320df0d026..f6480ea7b0d5 100644
> --- a/arch/arm64/include/asm/mmu.h
> +++ b/arch/arm64/include/asm/mmu.h
> @@ -25,10 +25,15 @@
>  
>  #ifndef __ASSEMBLY__
>  
> +#include <asm/pointer_auth.h>
> +
>  typedef struct {
>  	atomic64_t	id;
>  	void		*vdso;
>  	unsigned long	flags;
> +#ifdef CONFIG_ARM64_PTR_AUTH
> +	struct ptrauth_keys	ptrauth_keys;
> +#endif
>  } mm_context_t;
>  
>  /*
> diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
> index 39ec0b8a689e..83eadbc6b946 100644
> --- a/arch/arm64/include/asm/mmu_context.h
> +++ b/arch/arm64/include/asm/mmu_context.h
> @@ -168,7 +168,14 @@ static inline void cpu_replace_ttbr1(pgd_t *pgdp)
>  #define destroy_context(mm)		do { } while(0)
>  void check_and_switch_context(struct mm_struct *mm, unsigned int cpu);
>  
> -#define init_new_context(tsk,mm)	({ atomic64_set(&(mm)->context.id, 0); 0; })
> +static inline int init_new_context(struct task_struct *tsk,
> +				   struct mm_struct *mm)
> +{
> +	atomic64_set(&mm->context.id, 0);
> +	mm_ctx_ptrauth_init(&mm->context);
> +
> +	return 0;
> +}>
>  #ifdef CONFIG_ARM64_SW_TTBR0_PAN
>  static inline void update_saved_ttbr0(struct task_struct *tsk,
> @@ -216,6 +223,8 @@ static inline void __switch_mm(struct mm_struct *next)
>  		return;
>  	}
>  
> +	mm_ctx_ptrauth_switch(&next->context);
> +
>  	check_and_switch_context(next, cpu);
>  }

It seems you've removed arch_dup_mmap here (as Catalin suggested [1]),
but forgotten to move the key initialization from init_new_context to
arch_bprm_mm_init. In my tests I'm seeing child processes get different
keys than the parent after a fork().

Kristina

[1] https://lkml.org/lkml/2018/4/25/506
