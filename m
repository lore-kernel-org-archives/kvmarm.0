From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC/WIP PATCH 6/6] memory: add clear_cache_to_poc
Date: Wed, 11 Mar 2015 20:21:15 +0100
Message-ID: <20150311192115.GA16496@hawk.usersys.redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
 <1425668018-3649-1-git-send-email-drjones@redhat.com>
 <1425668018-3649-7-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95C4A48834
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 15:15:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eM6Ztk3E5WBj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2015 15:15:08 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0E7448827
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2015 15:15:07 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1425668018-3649-7-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, lersek@redhat.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 06, 2015 at 01:53:38PM -0500, Andrew Jones wrote:
> Add a function that flushes the cache to PoC. We need a new
> function because __builtin___clear_cache only flushes to
> PoU. Call this function each time an address in a memory
> region that has been flagged as having an incoherent cache
> is written. For starters we only implement it for ARM. Most
> other architectures don't need it anyway.

I started looking for my missing flushes, and see I have stupidity
in this patch. I'm not flushing in the right place at all... My
testing was just [un]lucky, making me think it was on the right
track. I'll send an update to this tomorrow after I remove my head
from a dark hole near my chair.

drew


> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
> Currently only implemented for aarch64, doesn't completely work yet.
> 
>  exec.c                  | 16 ++++++++++------
>  include/exec/exec-all.h | 41 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+), 6 deletions(-)
> 
> diff --git a/exec.c b/exec.c
> index c85321a38ba69..68268a5961ff5 100644
> --- a/exec.c
> +++ b/exec.c
> @@ -2261,7 +2261,7 @@ int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
>  
>  #else
>  
> -static void invalidate_and_set_dirty(hwaddr addr,
> +static void invalidate_and_set_dirty(MemoryRegion *mr, hwaddr addr,
>                                       hwaddr length)
>  {
>      if (cpu_physical_memory_range_includes_clean(addr, length)) {
> @@ -2269,6 +2269,10 @@ static void invalidate_and_set_dirty(hwaddr addr,
>          cpu_physical_memory_set_dirty_range_nocode(addr, length);
>      }
>      xen_modified_memory(addr, length);
> +    if (memory_region_has_incoherent_cache(mr)) {
> +        char *start = qemu_get_ram_ptr(addr);
> +        clear_cache_to_poc(start, start + length);
> +    }
>  }
>  
>  static int memory_access_size(MemoryRegion *mr, unsigned l, hwaddr addr)
> @@ -2348,7 +2352,7 @@ bool address_space_rw(AddressSpace *as, hwaddr addr, uint8_t *buf,
>                  /* RAM case */
>                  ptr = qemu_get_ram_ptr(addr1);
>                  memcpy(ptr, buf, l);
> -                invalidate_and_set_dirty(addr1, l);
> +                invalidate_and_set_dirty(mr, addr1, l);
>              }
>          } else {
>              if (!memory_access_is_direct(mr, is_write)) {
> @@ -2437,7 +2441,7 @@ static inline void cpu_physical_memory_write_rom_internal(AddressSpace *as,
>              switch (type) {
>              case WRITE_DATA:
>                  memcpy(ptr, buf, l);
> -                invalidate_and_set_dirty(addr1, l);
> +                invalidate_and_set_dirty(mr, addr1, l);
>                  break;
>              case FLUSH_CACHE:
>                  flush_icache_range((uintptr_t)ptr, (uintptr_t)ptr + l);
> @@ -2622,7 +2626,7 @@ void address_space_unmap(AddressSpace *as, void *buffer, hwaddr len,
>          mr = qemu_ram_addr_from_host(buffer, &addr1);
>          assert(mr != NULL);
>          if (is_write) {
> -            invalidate_and_set_dirty(addr1, access_len);
> +            invalidate_and_set_dirty(mr, addr1, access_len);
>          }
>          if (xen_enabled()) {
>              xen_invalidate_map_cache_entry(buffer);
> @@ -2904,7 +2908,7 @@ static inline void stl_phys_internal(AddressSpace *as,
>              stl_p(ptr, val);
>              break;
>          }
> -        invalidate_and_set_dirty(addr1, 4);
> +        invalidate_and_set_dirty(mr, addr1, 4);
>      }
>  }
>  
> @@ -2967,7 +2971,7 @@ static inline void stw_phys_internal(AddressSpace *as,
>              stw_p(ptr, val);
>              break;
>          }
> -        invalidate_and_set_dirty(addr1, 2);
> +        invalidate_and_set_dirty(mr, addr1, 2);
>      }
>  }
>  
> diff --git a/include/exec/exec-all.h b/include/exec/exec-all.h
> index 8eb0db3910e86..9bf74e791f357 100644
> --- a/include/exec/exec-all.h
> +++ b/include/exec/exec-all.h
> @@ -106,6 +106,43 @@ void tlb_set_page(CPUState *cpu, target_ulong vaddr,
>                    hwaddr paddr, int prot,
>                    int mmu_idx, target_ulong size);
>  void tb_invalidate_phys_addr(AddressSpace *as, hwaddr addr);
> +#if defined(__aarch64__)
> +static inline void clear_cache_to_poc(char *begin, char *end)
> +{
> +    /* Unfortunately __builtin___clear_cache only flushes
> +     * to PoU, we need to implement this for PoC.
> +     */
> +    static unsigned long line_sz = 0;
> +    unsigned long start, stop, addr;
> +
> +    if (!line_sz) {
> +        unsigned int ctr_el0;
> +        asm volatile("mrs %0, ctr_el0" : "=&r" (ctr_el0));
> +        line_sz = (1UL << ((ctr_el0 >> 16) & 0xf)) * sizeof(int);
> +    }
> +
> +    start = (unsigned long)begin & ~(line_sz - 1);
> +    stop = ((unsigned long)(end + line_sz) & ~(line_sz - 1));
> +
> +    for (addr = start; addr < stop; addr += line_sz) {
> +        asm volatile("dc cvac, %0" : : "r" (addr));
> +    }
> +
> +    /* FIXME: Ideally, we'd also flush the icache now, just in
> +     * case this is for an executable region. But, AArch64 can't
> +     * flush it to PoC from userspace. We need a syscall.
> +     */
> +}
> +#elif defined(__arm__)
> +static inline void clear_cache_to_poc(char *begin, char *end)
> +{
> +/* TODO */
> +}
> +#else
> +static inline void clear_cache_to_poc(char *begin, char *end)
> +{
> +}
> +#endif
>  #else
>  static inline void tlb_flush_page(CPUState *cpu, target_ulong addr)
>  {
> @@ -114,6 +151,10 @@ static inline void tlb_flush_page(CPUState *cpu, target_ulong addr)
>  static inline void tlb_flush(CPUState *cpu, int flush_global)
>  {
>  }
> +
> +void clear_cache_to_poc(char *begin, char *end)
> +{
> +}
>  #endif
>  
>  #define CODE_GEN_ALIGN           16 /* must be >= of the size of a icache line */
> -- 
> 1.8.3.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
