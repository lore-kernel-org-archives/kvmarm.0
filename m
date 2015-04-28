From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH/RFC 2/2] KVM: push down irq_save from kvm_guest_exit
Date: Tue, 28 Apr 2015 13:37:13 +0200
Message-ID: <553F70E9.50907@redhat.com>
References: <1430217168-25504-1-git-send-email-borntraeger@de.ibm.com> <1430217168-25504-3-git-send-email-borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <kvm-ppc-owner@vger.kernel.org>
In-Reply-To: <1430217168-25504-3-git-send-email-borntraeger@de.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mips@linux-mips.org, Cornelia Huck <cornelia.huck@de.ibm.com>, Alexander Graf <agraf@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu



On 28/04/2015 12:32, Christian Borntraeger wrote:
> Some architectures already have irq disabled when calling
> kvm_guest_exit. Push down the disabling into the architectures
> to avoid double disabling. This also allows to replace
> irq_save with irq_disable which might be cheaper.
> arm and mips already have interrupts disabled. s390/power/x86
> need adoptions.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 2 ++
>  arch/powerpc/kvm/book3s_pr.c | 2 ++
>  arch/powerpc/kvm/booke.c     | 4 ++--
>  arch/s390/kvm/kvm-s390.c     | 2 ++
>  arch/x86/kvm/x86.c           | 2 ++
>  include/linux/kvm_host.h     | 4 ----
>  6 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index a5f392d..63b35b1 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -1811,7 +1811,9 @@ static void kvmppc_run_core(struct kvmppc_vcore *vc)
>  
>  	/* make sure updates to secondary vcpu structs are visible now */
>  	smp_mb();
> +	local_irq_disable();
>  	kvm_guest_exit();
> +	local_irq_enable();
>  
>  	preempt_enable();
>  	cond_resched();
> diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
> index f573839..eafcb8c 100644
> --- a/arch/powerpc/kvm/book3s_pr.c
> +++ b/arch/powerpc/kvm/book3s_pr.c
> @@ -891,7 +891,9 @@ int kvmppc_handle_exit_pr(struct kvm_run *run, struct kvm_vcpu *vcpu,
>  
>  	/* We get here with MSR.EE=1 */
>  
> +	local_irq_disable();
>  	trace_kvm_exit(exit_nr, vcpu);
> +	local_irq_enable();
>  	kvm_guest_exit();

This looks wrong.

>  
>  	switch (exit_nr) {
> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index 6c1316a..f1d6af3 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -1004,11 +1004,11 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
>  		break;
>  	}
>  
> -	local_irq_enable();
> -
>  	trace_kvm_exit(exit_nr, vcpu);
>  	kvm_guest_exit();
>  
> +	local_irq_enable();
> +
>  	run->exit_reason = KVM_EXIT_UNKNOWN;
>  	run->ready_for_interrupt_injection = 1;
>  
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 9f4c954..0aa2534 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2015,7 +2015,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>  		local_irq_enable();
>  		exit_reason = sie64a(vcpu->arch.sie_block,
>  				     vcpu->run->s.regs.gprs);
> +		local_irq_disable();
>  		kvm_guest_exit();
> +		local_irq_enable();
>  		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
>  
>  		rc = vcpu_post_run(vcpu, exit_reason);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 32bf19e..a5fbd45 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6351,7 +6351,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	 */
>  	barrier();
>  
> +	local_irq_disable();
>  	kvm_guest_exit();
> +	local_irq_enable();
>  
>  	preempt_enable();
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a34bf6ed..fe699fb 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -773,11 +773,7 @@ static inline void kvm_guest_enter(void)
>  
>  static inline void kvm_guest_exit(void)
>  {
> -	unsigned long flags;
> -
> -	local_irq_save(flags);

Why no WARN_ON here?

I think the patches are sensible, especially since you can add warnings.
 This kind of code definitely knows if it has interrupts disabled or enabled

Alternatively, the irq-disabled versions could be called
__kvm_guest_{enter,exit}.  Then you can use those directly when it makes
sense.

Paolo

>  	guest_exit();
> -	local_irq_restore(flags);
>  }
>  
>  /*
> 
