From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH V2] mm: Introduce GFP_PGTABLE
Date: Wed, 16 Jan 2019 18:23:42 +0530
Message-ID: <ddac2cef-43af-cda3-fe03-3fc070084731@arm.com>
References: <1547619692-7946-1-git-send-email-anshuman.khandual@arm.com>
 <20190116065521.GC6643@rapoport-lnx>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 261634A3AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jan 2019 07:53:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nsd8+dsisFKY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Jan 2019 07:53:53 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8005B4A3A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jan 2019 07:53:53 -0500 (EST)
In-Reply-To: <20190116065521.GC6643@rapoport-lnx>
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
To: Mike Rapoport <rppt@linux.ibm.com>
Cc: mhocko@suse.com, linux-sh@vger.kernel.org, peterz@infradead.org, catalin.marinas@arm.com, dave.hansen@linux.intel.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, linux@armlinux.org.uk, mingo@redhat.com, vbabka@suse.cz, rientjes@google.com, palmer@sifive.com, greentime@andestech.com, marc.zyngier@arm.com, rppt@linux.vnet.ibm.com, shakeelb@google.com, kirill@shutemov.name, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, robin.murphy@arm.com, aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu



On 01/16/2019 12:25 PM, Mike Rapoport wrote:
> On Wed, Jan 16, 2019 at 11:51:32AM +0530, Anshuman Khandual wrote:
>> All architectures have been defining their own PGALLOC_GFP as (GFP_KERNEL |
>> __GFP_ZERO) and using it for allocating page table pages. This causes some
>> code duplication which can be easily avoided. GFP_KERNEL allocated and
>> cleared out pages (__GFP_ZERO) are required for page tables on any given
>> architecture. This creates a new generic GFP flag flag which can be used
>> for any page table page allocation. Does not cause any functional change.
>>
>> GFP_PGTABLE is being added into include/asm-generic/pgtable.h which is the
>> generic page tabe header just to prevent it's potential misuse as a general
>> allocation flag if included in include/linux/gfp.h.
>>
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> Build tested on arm, arm64, powerpc, powerpc64le and x86.
>> Boot tested on arm64 and x86.
>>
>> Changes in V2:
>>
>> - Moved GFP_PGTABLE into include/asm-generic/pgtable.h
>> - On X86 added __GFP_ACCOUNT into GFP_PGTABLE at various places
>> - Replaced possible flags on riscv and nds32 with GFP_PGTABLE
>>
>> Original V1: https://lkml.org/lkml/2019/1/12/54 
>>
>>  arch/arm/include/asm/pgalloc.h               |  8 +++-----
>>  arch/arm/mm/mmu.c                            |  2 +-
>>  arch/arm64/include/asm/pgalloc.h             |  9 ++++-----
>>  arch/arm64/mm/mmu.c                          |  2 +-
>>  arch/arm64/mm/pgd.c                          |  4 ++--
>>  arch/nds32/include/asm/pgalloc.h             |  3 +--
>>  arch/powerpc/include/asm/book3s/64/pgalloc.h |  6 +++---
>>  arch/powerpc/include/asm/pgalloc.h           |  2 --
>>  arch/powerpc/kvm/book3s_64_mmu_hv.c          |  2 +-
>>  arch/powerpc/mm/pgtable-frag.c               |  4 ++--
>>  arch/riscv/include/asm/pgalloc.h             |  8 +++-----
>>  arch/sh/mm/pgtable.c                         |  6 ++----
>>  arch/unicore32/include/asm/pgalloc.h         |  6 ++----
>>  arch/x86/kernel/espfix_64.c                  |  6 ++----
>>  arch/x86/mm/pgtable.c                        | 15 +++++++--------
>>  include/asm-generic/pgtable.h                |  2 ++
>>  virt/kvm/arm/mmu.c                           |  2 +-
>>  17 files changed, 37 insertions(+), 50 deletions(-)
> I wonder, what about the other arches? Do they use different GFP flags?
>  

Some of them as listed below use (GFP_KERNEL | __GFP_ZERO) which I will fix
next time around. Some how was focused on removing PGALLOC_GFP that missed
the other ones.

arch/powerpc/include/asm/nohash/64/pgalloc.h
arch/alpha/include/asm/pgalloc.h
arch/alpha/mm/init.c
arch/csky/include/asm/pgalloc.h
arch/arc/include/asm/pgalloc.h
........
........

But then there are those which use GFP_KERNEL alone without __GFP_ZERO like
pmd_alloc_one() in arch/sparc/include/asm/pgalloc_64.h cannot be replaced
with this patch as it does not intend to change functionality.
