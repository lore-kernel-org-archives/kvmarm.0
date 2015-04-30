From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: provide irq_unsafe kvm_guest_{enter|exit}
Date: Thu, 30 Apr 2015 13:50:04 +0200
Message-ID: <554216EC.6070406@redhat.com>
References: <1430394211-25209-1-git-send-email-borntraeger@de.ibm.com> <1430394211-25209-2-git-send-email-borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-ppc-owner@vger.kernel.org>
In-Reply-To: <1430394211-25209-2-git-send-email-borntraeger@de.ibm.com>
Sender: kvm-ppc-owner@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mips@linux-mips.org, Cornelia Huck <cornelia.huck@de.ibm.com>, Alexander Graf <agraf@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu



On 30/04/2015 13:43, Christian Borntraeger wrote:
> +/* must be called with irqs disabled */
> +static inline void __kvm_guest_enter(void)
>  {
> -	unsigned long flags;
> -
> -	BUG_ON(preemptible());

Please keep the BUG_ON() in kvm_guest_enter.  Otherwise looks good, thanks!

Paolo

> -	local_irq_save(flags);
>  	guest_enter();
> -	local_irq_restore(flags);
> -
>  	/* KVM does not hold any references to rcu protected data when it
>  	 * switches CPU into a guest mode. In fact switching to a guest mode
>  	 * is very similar to exiting to userspace from rcu point of view. In
> @@ -769,12 +763,27 @@ static inline void kvm_guest_enter(void)
>  	rcu_virt_note_context_switch(smp_processor_id());
>  }
>  
> +/* must be called with irqs disabled */
> +static inline void __kvm_guest_exit(void)
> +{
> +	guest_exit();
> +}
> +
> +static inline void kvm_guest_enter(void)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	__kvm_guest_enter();
> +	local_irq_restore(flags);
> +}
> +
