From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] kvm/arm: return 0 when the number of objects is not
 lessthan min
Date: Mon, 10 Dec 2018 14:13:17 +0100
Message-ID: <20181210131317.GP30263@e113682-lin.lund.arm.com>
References: <20181205083236.5tzhnxfhi4h4nknn@kamzik.brq.redhat.com>
 <201812060956304771332@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201812060956304771332@zte.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
To: peng.hao2@zte.com.cn
Cc: drjones@redhat.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 06, 2018 at 09:56:30AM +0800, peng.hao2@zte.com.cn wrote:
> >On Wed, Dec 05, 2018 at 09:15:51AM +0800, Peng Hao wrote:
> >> Return 0 when there is enough kvm_mmu_memory_cache object.
> >>
> >> Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
> >> ---
> >>  virt/kvm/arm/mmu.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> >> index ed162a6..fcda0ce 100644
> >> --- a/virt/kvm/arm/mmu.c
> >> +++ b/virt/kvm/arm/mmu.c
> >> @@ -127,7 +127,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
> >>      while (cache->nobjs < max) {
> >>          page = (void *)__get_free_page(PGALLOC_GFP);
> >>          if (!page)
> >> -            return -ENOMEM;
> >> +            return cache->nobjs >= min ? 0 : -ENOMEM;
> >
> >This condition will never be true here, as the exact same condition is
> >already checked above, and if it had been true, then we wouldn't be here.
> >
> >What problem are you attempting to solve?
> >
> if (cache->nobjs >= min)                      ------here cache->nobjs<min,it can continue downward 
>      return 0;
> while (cache->nobjs < max) {
>     page = (void *)__get_free_page(PGALLOC_GFP);
>     if (!page)
>        return -ENOMEM;                         -----here it is possible that  (cache->nobjs >= min) and (cache->nobjs<max)
>     cache->objects[cache->nobjs++] = page; ---here cache->nobjs increasing
>   }
> 
> I just think the logic of this function is to return 0 as long as (cache->nobjs >= min).
> thanks.

That's not the intention, nor is it on any of the other architectures
implementing the same thing (this one goes on the list of stuff we
should be sharing between architectures).

The idea is that you fill up the cache when it goes below min, and you
are always able to fill up to max.

If you're not able to fill up to max, then your system is seriously low
on memory and continuing to run this VM is not likely to be a good idea,
so you might as well tell user space to do something now instead of
waiting until the situation is even worse.


Thanks,

    Christoffer
