From: Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v2 01/27] KVM: Call kvm_arch_memslots_updated() before
 updating memslots
Date: Wed, 6 Feb 2019 10:12:11 +0100
Message-ID: <20190206101211.253cfbd9.cohuck@redhat.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
 <20190205205443.1059-2-sean.j.christopherson@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA55F4A427
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Feb 2019 04:12:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rH+NZPWdgINN for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Feb 2019 04:12:25 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF2924A380
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Feb 2019 04:12:24 -0500 (EST)
In-Reply-To: <20190205205443.1059-2-sean.j.christopherson@intel.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, James Hogan <jhogan@kernel.org>, David Hildenbrand <david@redhat.com>, kvm-ppc@vger.kernel.org, linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Xiao Guangrong <guangrong.xiao@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue,  5 Feb 2019 12:54:17 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> kvm_arch_memslots_updated() is at this point in time an x86-specific
> hook for handling MMIO generation wraparound.  x86 stashes 19 bits of
> the memslots generation number in its MMIO sptes in order to avoid
> full page fault walks for repeat faults on emulated MMIO addresses.
> Because only 19 bits are used, wrapping the MMIO generation number is
> possible, if unlikely.  kvm_arch_memslots_updated() alerts x86 that
> the generation has changed so that it can invalidate all MMIO sptes in
> case the effective MMIO generation has wrapped so as to avoid using a
> stale spte, e.g. a (very) old spte that was created with generation==0.
> 
> Given that the purpose of kvm_arch_memslots_updated() is to prevent
> consuming stale entries, it needs to be called before the new generation
> is propagated to memslots.  Invalidating the MMIO sptes after updating
> memslots means that there is a window where a vCPU could dereference
> the new memslots generation, e.g. 0, and incorrectly reuse an old MMIO
> spte that was created with (pre-wrap) generation==0.
> 
> Fixes: e59dbe09f8e6 ("KVM: Introduce kvm_arch_memslots_updated()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/include/asm/kvm_host.h    | 2 +-
>  arch/powerpc/include/asm/kvm_host.h | 2 +-
>  arch/s390/include/asm/kvm_host.h    | 2 +-
>  arch/x86/include/asm/kvm_host.h     | 2 +-
>  arch/x86/kvm/mmu.c                  | 4 ++--
>  arch/x86/kvm/x86.c                  | 4 ++--
>  include/linux/kvm_host.h            | 2 +-
>  virt/kvm/arm/mmu.c                  | 2 +-
>  virt/kvm/kvm_main.c                 | 7 +++++--
>  9 files changed, 15 insertions(+), 12 deletions(-)

Not an x86 person, but I think that makes sense.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
