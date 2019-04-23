From: Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH] KVM: Directly return result from
 kvm_arch_check_processor_compat()
Date: Tue, 23 Apr 2019 10:57:25 +0200
Message-ID: <20190423105725.73f5680e.cohuck@redhat.com>
References: <20190420051817.5644-1-sean.j.christopherson@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41D454A476
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Apr 2019 04:57:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YIki2F6D7LvK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Apr 2019 04:57:35 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 233414A36C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Apr 2019 04:57:35 -0400 (EDT)
In-Reply-To: <20190420051817.5644-1-sean.j.christopherson@intel.com>
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
Cc: linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>, David Hildenbrand <david@redhat.com>, kvm-ppc@vger.kernel.org, linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 19 Apr 2019 22:18:17 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Add a wrapper to invoke kvm_arch_check_processor_compat() so that the
> boilerplate ugliness of checking virtualization support on all CPUs is
> hidden from the arch specific code.  x86's implementation in particular
> is quite heinous, as it unnecessarily propagates the out-param pattern
> into kvm_x86_ops.
> 
> While the x86 specific issue could be resolved solely by changing
> kvm_x86_ops, make the change for all architectures as returning a value
> directly is prettier and technically more robust, e.g. s390 doesn't set
> the out param, which could lead to subtle breakage in the (highly
> unlikely) scenario where the out-param was not pre-initialized by the
> caller.
> 
> Opportunistically annotate svm_check_processor_compat() with __init.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> Tested on VMX only.
> 
>  arch/mips/kvm/mips.c             | 4 ++--
>  arch/powerpc/kvm/powerpc.c       | 4 ++--
>  arch/s390/include/asm/kvm_host.h | 1 -
>  arch/s390/kvm/kvm-s390.c         | 5 +++++
>  arch/x86/include/asm/kvm_host.h  | 2 +-
>  arch/x86/kvm/svm.c               | 4 ++--
>  arch/x86/kvm/vmx/vmx.c           | 8 ++++----
>  arch/x86/kvm/x86.c               | 4 ++--
>  include/linux/kvm_host.h         | 2 +-
>  virt/kvm/arm/arm.c               | 4 ++--
>  virt/kvm/kvm_main.c              | 9 ++++++---
>  11 files changed, 27 insertions(+), 20 deletions(-)

Yes, this does look nicer.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
