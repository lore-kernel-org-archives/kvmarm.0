From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/3] arm/arm64: drop mmu_set_enabled
Date: Mon, 6 Jul 2015 14:41:55 +0200
Message-ID: <20150706124155.GB17217@hawk.localdomain>
References: <1435257911-9715-1-git-send-email-drjones@redhat.com>
 <1435257911-9715-3-git-send-email-drjones@redhat.com>
 <5596C8C1.7060809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5596C8C1.7060809@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 03, 2015 at 07:39:13PM +0200, Paolo Bonzini wrote:
> 
> 
> On 25/06/2015 20:45, Andrew Jones wrote:
> > The mmu is enabled automatically for all cpus, they must disable it
> > themselves if they don't want it on. Switch from managing a cpumask
> > of enabled cpus to one of disabled cpus. This allows us to remove
> > the mmu_set_enabled call from secondary_cinit, and the function all
> > together.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  lib/arm/asm/mmu-api.h |  1 -
> >  lib/arm/mmu.c         | 21 ++++++++++-----------
> >  lib/arm/smp.c         |  1 -
> >  3 files changed, 10 insertions(+), 13 deletions(-)
> > 
> > diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> > index c46c4b08b14cc..12fdc57918c27 100644
> > --- a/lib/arm/asm/mmu-api.h
> > +++ b/lib/arm/asm/mmu-api.h
> > @@ -2,7 +2,6 @@
> >  #define __ASMARM_MMU_API_H_
> >  extern pgd_t *mmu_idmap;
> >  extern bool mmu_enabled(void);
> > -extern void mmu_set_enabled(void);
> >  extern void mmu_enable(pgd_t *pgtable);
> >  extern void mmu_disable(void);
> >  extern void mmu_enable_idmap(void);
> > diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> > index 5966b408cb455..ad558e177dd1c 100644
> > --- a/lib/arm/mmu.c
> > +++ b/lib/arm/mmu.c
> > @@ -14,32 +14,31 @@ extern unsigned long etext;
> >  
> >  pgd_t *mmu_idmap;
> >  
> > -static cpumask_t mmu_enabled_cpumask;
> > +static cpumask_t mmu_disabled_cpumask;
> > +
> >  bool mmu_enabled(void)
> >  {
> > -	struct thread_info *ti = current_thread_info();
> > -	return cpumask_test_cpu(ti->cpu, &mmu_enabled_cpumask);
> > -}
> > +	int cpu = current_thread_info()->cpu;
> >  
> > -void mmu_set_enabled(void)
> > -{
> > -	struct thread_info *ti = current_thread_info();
> > -	cpumask_set_cpu(ti->cpu, &mmu_enabled_cpumask);
> > +	return !cpumask_test_cpu(cpu, &mmu_disabled_cpumask);
> >  }
> >  
> >  extern void asm_mmu_enable(phys_addr_t pgtable);
> >  void mmu_enable(pgd_t *pgtable)
> >  {
> > +	int cpu = current_thread_info()->cpu;
> > +
> >  	asm_mmu_enable(__pa(pgtable));
> >  	flush_tlb_all();
> > -	mmu_set_enabled();
> > +	cpumask_clear_cpu(cpu, &mmu_disabled_cpumask);
> >  }
> >  
> >  extern void asm_mmu_disable(void);
> >  void mmu_disable(void)
> >  {
> > -	struct thread_info *ti = current_thread_info();
> > -	cpumask_clear_cpu(ti->cpu, &mmu_enabled_cpumask);
> > +	int cpu = current_thread_info()->cpu;
> > +
> > +	cpumask_set_cpu(cpu, &mmu_disabled_cpumask);
> >  	asm_mmu_disable();
> >  }
> >  
> > diff --git a/lib/arm/smp.c b/lib/arm/smp.c
> > index f389ba6598faa..ca435dcd5f4a2 100644
> > --- a/lib/arm/smp.c
> > +++ b/lib/arm/smp.c
> > @@ -23,7 +23,6 @@ secondary_entry_fn secondary_cinit(void)
> >  	secondary_entry_fn entry;
> >  
> >  	thread_info_init(ti, 0);
> > -	mmu_set_enabled();
> >  
> >  	/*
> >  	 * Save secondary_data.entry locally to avoid opening a race
> > 
> 
> This is needed too on a Cubietruck:

Oh right! We definitely need to return false from mmu_enabled
for cubietruck on early boot (that was the whole reason to
introduce mmu_enabled()). Thanks for fixing it up!

> 
> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> index 12fdc57..73bac70 100644
> --- a/lib/arm/asm/mmu-api.h
> +++ b/lib/arm/asm/mmu-api.h
> @@ -3,6 +3,7 @@
>  extern pgd_t *mmu_idmap;
>  extern bool mmu_enabled(void);
>  extern void mmu_enable(pgd_t *pgtable);
> +extern void mmu_mark_disabled(int cpu);
>  extern void mmu_disable(void);
>  extern void mmu_enable_idmap(void);
>  extern void mmu_init_io_sect(pgd_t *pgtable, unsigned long virt_offset);
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index ad558e1..8ff659b 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -14,7 +14,8 @@ extern unsigned long etext;
> 
>  pgd_t *mmu_idmap;
> 
> -static cpumask_t mmu_disabled_cpumask;
> +/* CPU 0 starts with disabled MMU */
> +static cpumask_t mmu_disabled_cpumask = { {1} };
> 
>  bool mmu_enabled(void)
>  {
> @@ -33,6 +34,11 @@ void mmu_enable(pgd_t *pgtable)
>  	cpumask_clear_cpu(cpu, &mmu_disabled_cpumask);
>  }
> 
> +void mmu_mark_disabled(int cpu)
> +{
> +	cpumask_set_cpu(cpu, &mmu_disabled_cpumask);
> +}
> +
>  extern void asm_mmu_disable(void);
>  void mmu_disable(void)
>  {
> diff --git a/lib/arm/psci.c b/lib/arm/psci.c
> index aca8885..c4469c9 100644
> --- a/lib/arm/psci.c
> +++ b/lib/arm/psci.c
> @@ -9,6 +9,7 @@
>  #include <asm/psci.h>
>  #include <asm/setup.h>
>  #include <asm/page.h>
> +#include <asm/mmu-api.h>
> 
>  #define T PSCI_INVOKE_ARG_TYPE
>  __attribute__((noinline))
> @@ -29,6 +30,7 @@ int psci_cpu_on(unsigned long cpuid, unsigned long
> entry_point)
>  extern void secondary_entry(void);
>  int cpu_psci_cpu_boot(unsigned int cpu)
>  {
> +	mmu_mark_disabled(cpu);
>  	int err = psci_cpu_on(cpus[cpu], __pa(secondary_entry));
>  	if (err)
>  		printf("failed to boot CPU%d (%d)\n", cpu, err);
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
