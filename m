From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/3] KVM: Unify mmu_memory_cache functionality across
 architectures
Date: Fri, 15 Mar 2019 18:37:00 +0100
Message-ID: <5e57d972-5f7c-0c44-286d-fe401a3594c1@redhat.com>
References: <20190131095244.7480-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E84504A481
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 13:37:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SubuIEzfoqmL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Mar 2019 13:37:07 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 035164A430
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 13:37:07 -0400 (EDT)
In-Reply-To: <20190131095244.7480-1-christoffer.dall@arm.com>
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
To: Christoffer Dall <christoffer.dall@arm.com>, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>, Anshuman Khandual <anshuman.khandual@arm.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Paul Mackerras <paulus@ozlabs.org>, Christian Borntraeger <borntraeger@de.ibm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 31/01/19 10:52, Christoffer Dall wrote:
> We currently have duplicated functionality for the mmu_memory_cache used
> to pre-allocate memory for the page table manipulation code which cannot
> allocate memory while holding spinlocks.  This functionality is
> duplicated across x86, arm/arm64, and mips.
> 
> There were recently a debate of modifying the arm code to be more in
> line with the x86 code and some discussions around changing the page
> flags used for allocation.  This series should make it easier to take a
> uniform approach across architectures.
> 
> While there's not a huge amount of code sharing, we come out with a net
> gain.
> 
> Only tested on arm/arm64, and only compile-tested on x86 and mips.
> 
> Changes since v1:
>  - Split out rename from initial x86 patch to have separate patches to
>    move the logic to common code and to rename.
>  - Introduce KVM_ARCH_WANT_MMU_MEMCACHE to avoid compile breakage on
>    architectures that don't use this functionality.
>  - Rename KVM_NR_MEM_OBJS to KVM_MMU_NR_MEMCACHE_OBJS
> 
> ---
> 
> Christoffer Dall (4):
>   KVM: x86: Move mmu_memory_cache functions to common code
>   KVM: x86: Rename mmu_memory_cache to kvm_mmu_memcache
>   KVM: arm/arm64: Move to common kvm_mmu_memcache infrastructure
>   KVM: mips: Move to common kvm_mmu_memcache infrastructure
> 
>  arch/arm/include/asm/kvm_host.h      | 13 +---
>  arch/arm/include/asm/kvm_mmu.h       |  2 +-
>  arch/arm/include/asm/kvm_types.h     | 12 ++++
>  arch/arm64/include/asm/kvm_host.h    | 13 +---
>  arch/arm64/include/asm/kvm_mmu.h     |  2 +-
>  arch/arm64/include/asm/kvm_types.h   | 13 ++++
>  arch/mips/include/asm/kvm_host.h     | 15 +----
>  arch/mips/include/asm/kvm_types.h    | 12 ++++
>  arch/mips/kvm/mips.c                 |  2 +-
>  arch/mips/kvm/mmu.c                  | 54 +++-------------
>  arch/powerpc/include/asm/kvm_types.h |  5 ++
>  arch/s390/include/asm/kvm_types.h    |  5 ++
>  arch/x86/include/asm/kvm_host.h      | 17 +----
>  arch/x86/include/asm/kvm_types.h     | 12 ++++
>  arch/x86/kvm/mmu.c                   | 97 ++++++----------------------
>  arch/x86/kvm/paging_tmpl.h           |  4 +-
>  include/linux/kvm_host.h             | 11 ++++
>  include/linux/kvm_types.h            | 13 ++++
>  virt/kvm/arm/arm.c                   |  2 +-
>  virt/kvm/arm/mmu.c                   | 68 +++++--------------
>  virt/kvm/kvm_main.c                  | 60 +++++++++++++++++
>  21 files changed, 202 insertions(+), 230 deletions(-)
>  create mode 100644 arch/arm/include/asm/kvm_types.h
>  create mode 100644 arch/arm64/include/asm/kvm_types.h
>  create mode 100644 arch/mips/include/asm/kvm_types.h
>  create mode 100644 arch/powerpc/include/asm/kvm_types.h
>  create mode 100644 arch/s390/include/asm/kvm_types.h
>  create mode 100644 arch/x86/include/asm/kvm_types.h
> 

Sorry for the belated review, this is a good idea and I would like to
include it at the beginning of the 5.2 cycle.

Paolo
