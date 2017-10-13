From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH 05/37] KVM: Record the executing ioctl number on the vcpu
 struct
Date: Fri, 13 Oct 2017 19:13:07 +0200
Message-ID: <20171013171307.GA16116@flask>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-6-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171012104141.26902-6-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

2017-10-12 12:41+0200, Christoffer Dall:
> Some architectures may decide to do different things during
> kvm_arch_vcpu_load depending on the ioctl being executed.  For example,
> arm64 is about to do significant work in vcpu load/put when running a
> vcpu, but not when doing things like KVM_SET_ONE_REG or
> KVM_SET_MP_STATE.
> 
> Therefore, store the ioctl number that we are executing on the VCPU
> during the first vcpu_load() which succeeds in getting the vcpu->mutex
> and set the ioctl number to 0 when exiting kvm_vcpu_ioctl() after
> successfully loading the vcpu.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> @@ -147,12 +147,13 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
>  /*
>   * Switches to specified vcpu, until a matching vcpu_put()
>   */
> -int vcpu_load(struct kvm_vcpu *vcpu)
> +int vcpu_load(struct kvm_vcpu *vcpu, unsigned int ioctl)
>  {
>  	int cpu;
>  
>  	if (mutex_lock_killable(&vcpu->mutex))
>  		return -EINTR;
> +	vcpu->ioctl = ioctl;

This seems to prevent races by protecting the store by a mutex, but

>  	cpu = get_cpu();
>  	preempt_notifier_register(&vcpu->preempt_notifier);
>  	kvm_arch_vcpu_load(vcpu, cpu);
> @@ -2529,7 +2530,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  #endif
>  
>  
> -	r = vcpu_load(vcpu);
> +	r = vcpu_load(vcpu, ioctl);
>  	if (r)
>  		return r;
>  	switch (ioctl) {
> @@ -2704,6 +2705,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  	}
>  out:
>  	vcpu_put(vcpu);
> +	vcpu->ioctl = 0;

we should still have a race as we clear ioctl only after releasing the
lock.  For example malicious userspace could break KVM terms of use and
issue !KVM_RUN followed by KVM_RUN, so we would have these races:

   !KVM_RUN                             |   KVM_RUN

   mutex_lock_killable(&vcpu->mutex);   |
   vcpu->ioctl = !KVM_RUN;              |
   ...                                  | mutex_lock_killable(&vcpu->mutex);
   mutex_unlock(&vcpu->mutex);          |
                                        | vcpu->ioctl = KVM_RUN;
                                        | kvm_arch_vcpu_load() // variant 1
   vcpu->ioctl = 0;                     | ...
                                        | kvm_arch_vcpu_load() // variant 2
                                        | vcpu_put()

where the observed value of vcpu->ioctl in vcpu_put() would not
correctly pair with vcpu_load() or worse, kvm_arch_arch_load() in
KVM_RUN would execute with vcpu->ioctl = 0.

I think that other (special) callsites of vcpu_load()/vcpu_put() have a
well defined IOCTL that can be used instead of vcpu->ioctl, so we could
just pass the ioctl value all the way to arch code and never save it
anywhere,

thanks.

>  	kfree(fpu);
>  	kfree(kvm_sregs);
>  	return r;
