From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/3] arm/arm64: speed up spinlocks and atomic ops
Date: Mon, 29 Jun 2015 12:28:32 +0200
Message-ID: <20150629102832.GJ11332@cbox>
References: <1435248739-25425-1-git-send-email-drjones@redhat.com>
 <1435248739-25425-3-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435248739-25425-3-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 25, 2015 at 06:12:18PM +0200, Andrew Jones wrote:
> spinlock torture tests made it clear that checking mmu_enabled()
> every time we call spin_lock is a bad idea.

why a bad idea?  Does it break, is it slow?

> As most tests will
> want the MMU enabled the entire time, then just hard code
> mmu_enabled() to true. Tests that want to play with the MMU can
> be compiled with CONFIG_MAY_DISABLE_MMU to get the actual check
> back.

If we don't care about performance, why this added complexity?

> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/arm/asm/mmu-api.h | 4 ++++
>  lib/arm/mmu.c         | 3 +++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> index 68dc707d67241..1a4d91163c398 100644
> --- a/lib/arm/asm/mmu-api.h
> +++ b/lib/arm/asm/mmu-api.h
> @@ -1,7 +1,11 @@
>  #ifndef __ASMARM_MMU_API_H_
>  #define __ASMARM_MMU_API_H_
>  extern pgd_t *mmu_idmap;
> +#ifdef CONFIG_MAY_DISABLE_MMU
>  extern bool mmu_enabled(void);
> +#else
> +#define mmu_enabled() (1)
> +#endif
>  extern void mmu_set_enabled(void);
>  extern void mmu_enable(pgd_t *pgtable);
>  extern void mmu_enable_idmap(void);
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 732000a8eb088..405717b6332bf 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -15,11 +15,14 @@ extern unsigned long etext;
>  pgd_t *mmu_idmap;
>  
>  static cpumask_t mmu_enabled_cpumask;
> +
> +#ifdef CONFIG_MAY_DISABLE_MMU
>  bool mmu_enabled(void)
>  {
>  	struct thread_info *ti = current_thread_info();
>  	return cpumask_test_cpu(ti->cpu, &mmu_enabled_cpumask);
>  }
> +#endif
>  
>  void mmu_set_enabled(void)
>  {
> -- 
> 2.4.3
> 
