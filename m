From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH/RFC 2/2] KVM: push down irq_save from kvm_guest_exit
Date: Tue, 28 Apr 2015 16:10:23 +0200
Message-ID: <553F94CF.2080409@de.ibm.com>
References: <1430217168-25504-1-git-send-email-borntraeger@de.ibm.com> <1430217168-25504-3-git-send-email-borntraeger@de.ibm.com> <553F70E9.50907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-ppc-owner@vger.kernel.org>
In-Reply-To: <553F70E9.50907@redhat.com>
Sender: kvm-ppc-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mips@linux-mips.org, Cornelia Huck <cornelia.huck@de.ibm.com>, Alexander Graf <agraf@suse.de>
List-Id: kvmarm@lists.cs.columbia.edu

Am 28.04.2015 um 13:37 schrieb Paolo Bonzini:
>> --- a/arch/powerpc/kvm/book3s_pr.c
>> +++ b/arch/powerpc/kvm/book3s_pr.c
>> @@ -891,7 +891,9 @@ int kvmppc_handle_exit_pr(struct kvm_run *run, struct kvm_vcpu *vcpu,
>>  
>>  	/* We get here with MSR.EE=1 */
>>  
>> +	local_irq_disable();
>>  	trace_kvm_exit(exit_nr, vcpu);
>> +	local_irq_enable();
>>  	kvm_guest_exit();
> 
> This looks wrong.
> 
Yes it is.

>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -773,11 +773,7 @@ static inline void kvm_guest_enter(void)
>>  
>>  static inline void kvm_guest_exit(void)
>>  {
>> -	unsigned long flags;
>> -
>> -	local_irq_save(flags);
> 
> Why no WARN_ON here?

Yes,WARN_ON makes sense.
Hmm, on the other hand the  irqs_disabled call might be somewhat expensive again
(would boil down on s390 to call stnsm (store and and system mask) once for 
query and once for setting.

so...
> 
> I think the patches are sensible, especially since you can add warnings.
>  This kind of code definitely knows if it has interrupts disabled or enabled
> 
> Alternatively, the irq-disabled versions could be called
> __kvm_guest_{enter,exit}.  Then you can use those directly when it makes
> sense.

..having a special  __kvm_guest_{enter,exit} without the WARN_ON might be even
the cheapest way. In that way I could leave everything besides s390 alone and
arch maintainers can do a followup patch if appropriate.
