From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 1/9] KVM: add kvm_request_pending
Date: Tue, 4 Apr 2017 17:30:14 +0200
Message-ID: <20170404153014.GL11752@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-2-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170331160658.4331-2-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 31, 2017 at 06:06:50PM +0200, Andrew Jones wrote:
> From: Radim Krčmář <rkrcmar@redhat.com>
> 
> A first step in vcpu->requests encapsulation.

Could we have a note here on why we need to access vcpu->requests using
READ_ONCE now?

Thanks,
-Christoffer

> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/mips/kvm/trap_emul.c  | 2 +-
>  arch/powerpc/kvm/booke.c   | 2 +-
>  arch/powerpc/kvm/powerpc.c | 5 ++---
>  arch/s390/kvm/kvm-s390.c   | 2 +-
>  arch/x86/kvm/x86.c         | 4 ++--
>  include/linux/kvm_host.h   | 5 +++++
>  6 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/mips/kvm/trap_emul.c b/arch/mips/kvm/trap_emul.c
> index b1fa53b252ea..9ac8b1d62643 100644
> --- a/arch/mips/kvm/trap_emul.c
> +++ b/arch/mips/kvm/trap_emul.c
> @@ -1029,7 +1029,7 @@ static void kvm_trap_emul_check_requests(struct kvm_vcpu *vcpu, int cpu,
>  	struct mm_struct *mm;
>  	int i;
>  
> -	if (likely(!vcpu->requests))
> +	if (likely(!kvm_request_pending(vcpu)))
>  		return;
>  
>  	if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index 0514cbd4e533..65ed6595c9c2 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -682,7 +682,7 @@ int kvmppc_core_prepare_to_enter(struct kvm_vcpu *vcpu)
>  
>  	kvmppc_core_check_exceptions(vcpu);
>  
> -	if (vcpu->requests) {
> +	if (kvm_request_pending(vcpu)) {
>  		/* Exception delivery raised request; start over */
>  		return 1;
>  	}
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 95c91a9de351..714674ea5be6 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -52,8 +52,7 @@ EXPORT_SYMBOL_GPL(kvmppc_pr_ops);
>  
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
>  {
> -	return !!(v->arch.pending_exceptions) ||
> -	       v->requests;
> +	return !!(v->arch.pending_exceptions) || kvm_request_pending(v);
>  }
>  
>  int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
> @@ -105,7 +104,7 @@ int kvmppc_prepare_to_enter(struct kvm_vcpu *vcpu)
>  		 */
>  		smp_mb();
>  
> -		if (vcpu->requests) {
> +		if (kvm_request_pending(vcpu)) {
>  			/* Make sure we process requests preemptable */
>  			local_irq_enable();
>  			trace_kvm_check_requests(vcpu);
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index fd6cd05bb6a7..40ad6c8d082f 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2396,7 +2396,7 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
>  {
>  retry:
>  	kvm_s390_vcpu_request_handled(vcpu);
> -	if (!vcpu->requests)
> +	if (!kvm_request_pending(vcpu))
>  		return 0;
>  	/*
>  	 * We use MMU_RELOAD just to re-arm the ipte notifier for the
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1faf620a6fdc..9714bb230524 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6726,7 +6726,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	bool req_immediate_exit = false;
>  
> -	if (vcpu->requests) {
> +	if (kvm_request_pending(vcpu)) {
>  		if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
>  			kvm_mmu_unload(vcpu);
>  		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
> @@ -6890,7 +6890,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			kvm_x86_ops->sync_pir_to_irr(vcpu);
>  	}
>  
> -	if (vcpu->mode == EXITING_GUEST_MODE || vcpu->requests
> +	if (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
>  	    || need_resched() || signal_pending(current)) {
>  		vcpu->mode = OUTSIDE_GUEST_MODE;
>  		smp_wmb();
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 2c14ad9809da..946bf0b3c43c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1085,6 +1085,11 @@ static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
>  
>  #endif /* CONFIG_HAVE_KVM_EVENTFD */
>  
> +static inline bool kvm_request_pending(struct kvm_vcpu *vcpu)
> +{
> +	return READ_ONCE(vcpu->requests);
> +}
> +
>  static inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
>  {
>  	/*
> -- 
> 2.9.3
> 
