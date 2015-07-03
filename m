From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] arm/arm64: speed up spinlocks and atomic ops
Date: Fri, 3 Jul 2015 19:43:07 +0200
Message-ID: <5596C9AB.3030404@redhat.com>
References: <1435257911-9715-1-git-send-email-drjones@redhat.com>
 <1435257911-9715-4-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62E24579F4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 13:31:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yipJSo+TkzMj for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 13:31:49 -0400 (EDT)
Received: from mail-wg0-f47.google.com (mail-wg0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A3FB579F2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 13:31:49 -0400 (EDT)
Received: by wgck11 with SMTP id k11so93594547wgc.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Jul 2015 10:43:09 -0700 (PDT)
In-Reply-To: <1435257911-9715-4-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 25/06/2015 20:45, Andrew Jones wrote:
> spinlock torture tests made it clear that checking mmu_enabled()
> every time we call spin_lock is a bad idea. As most tests will
> want the MMU enabled the entire time, then we can inline a light
> weight "nobody disabled the mmu" check, and bail out early.
> 
> Adding a light weight inlined check vs. a compile-time flag
> suggested by Paolo.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/arm/asm/mmu-api.h | 7 ++++++-
>  lib/arm/mmu.c         | 9 +++++++--
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> index 12fdc57918c27..b2fc900a30add 100644
> --- a/lib/arm/asm/mmu-api.h
> +++ b/lib/arm/asm/mmu-api.h
> @@ -1,7 +1,12 @@
>  #ifndef __ASMARM_MMU_API_H_
>  #define __ASMARM_MMU_API_H_
>  extern pgd_t *mmu_idmap;
> -extern bool mmu_enabled(void);
> +extern unsigned int mmu_disabled_cpu_count;
> +extern bool __mmu_enabled(void);
> +static inline bool mmu_enabled(void)
> +{
> +	return mmu_disabled_cpu_count == 0 || __mmu_enabled();
> +}
>  extern void mmu_enable(pgd_t *pgtable);
>  extern void mmu_disable(void);
>  extern void mmu_enable_idmap(void);
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index ad558e177dd1c..e661d4f26e4b7 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -15,8 +15,9 @@ extern unsigned long etext;
>  pgd_t *mmu_idmap;
>  
>  static cpumask_t mmu_disabled_cpumask;
> +unsigned int mmu_disabled_cpu_count;
>  
> -bool mmu_enabled(void)
> +bool __mmu_enabled(void)
>  {
>  	int cpu = current_thread_info()->cpu;
>  
> @@ -30,7 +31,9 @@ void mmu_enable(pgd_t *pgtable)
>  
>  	asm_mmu_enable(__pa(pgtable));
>  	flush_tlb_all();
> -	cpumask_clear_cpu(cpu, &mmu_disabled_cpumask);
> +
> +	if (cpumask_test_and_clear_cpu(cpu, &mmu_disabled_cpumask))
> +		--mmu_disabled_cpu_count;
>  }
>  
>  extern void asm_mmu_disable(void);
> @@ -39,6 +42,8 @@ void mmu_disable(void)
>  	int cpu = current_thread_info()->cpu;
>  
>  	cpumask_set_cpu(cpu, &mmu_disabled_cpumask);
> +	++mmu_disabled_cpu_count;
> +
>  	asm_mmu_disable();
>  }
>  
> 

Applied, thanks.

Paolo
