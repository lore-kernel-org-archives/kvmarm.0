From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/3] arm/arm64: speed up spinlocks and atomic ops
Date: Thu, 25 Jun 2015 18:55:52 +0200
Message-ID: <20150625165552.GC6535@hawk.localdomain>
References: <1435248739-25425-1-git-send-email-drjones@redhat.com>
 <1435248739-25425-3-git-send-email-drjones@redhat.com>
 <558C2B14.7060807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <558C2B14.7060807@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 25, 2015 at 06:23:48PM +0200, Paolo Bonzini wrote:
> 
> 
> On 25/06/2015 18:12, Andrew Jones wrote:
> > spinlock torture tests made it clear that checking mmu_enabled()
> > every time we call spin_lock is a bad idea. As most tests will
> > want the MMU enabled the entire time, then just hard code
> > mmu_enabled() to true. Tests that want to play with the MMU can
> > be compiled with CONFIG_MAY_DISABLE_MMU to get the actual check
> > back.
> 
> This doesn't work if you compile mmu.o just once.  Can you make
> something like
> 
> static inline bool mmu_enabled(void)
> {
> 	return disabled_mmu_cpu_count == 0 || __mmu_enabled();
> }
> 
> ...
> 
> bool __mmu_enabled(void)
> {
> 	struct thread_info *ti = current_thread_info();
> 	return cpumask_test_cpu(ti->cpu, &mmu_enabled_cpumask);
> }
> 
> ?

Agreed. But I might as well actually add the support for disabling
the mmu, if I'm going to add yet another variable dependant on it.
We should drop this patch from this series, and I'll submit another
series of a few patches that
  - introduce mmu_disable
  - switch to assuming the mmu is enabled, and then manage disabled
    state instead
  - optimize mmu_enabled()

Thanks,
drew

> 
> Paolo
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
