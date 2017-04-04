From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Tue, 4 Apr 2017 20:15:09 +0200
Message-ID: <b49156ee-ca97-5d43-15a6-ed6ec8116535@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com> <20170404160417.GN11752@cbox>
 <06b2a225-192c-9c96-c092-6e0575dd9410@redhat.com>
 <20170404171953.GP11752@cbox>
 <e3977a97-a240-58a6-288d-09f3c12de56c@redhat.com>
 <20170404175750.GD31208@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170404175750.GD31208@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 04/04/2017 19:57, Christoffer Dall wrote:
>> Right.  That code does
>>
>>                 tmp->arch.power_off = true;
>>                 kvm_vcpu_kick(tmp);
>>
>> and I think what's really missing in arm.c is the "if (vcpu->mode ==
>> EXITING_GUEST_MODE)" check that is found in x86.c.  Then pausing can
>> also simply use kvm_vcpu_kick.
> I see, that's why the cmpxchg() works the way it does.  We just still
> need to move the vcpu->mode = IN_GUEST_MODE before our
> with-interrupts-disabled check.
> 
> What I'm not sure is why you can get away without using a memory barrier
> or WRITE_ONCE on x86, but is this simply because x86 is a strongly
> ordered architecture?

x86 does have a memory barrier:

        vcpu->mode = IN_GUEST_MODE;

        srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
        smp_mb__after_srcu_read_unlock();

        /*
         * This handles the case where a posted interrupt was
         * notified with kvm_vcpu_kick.
         */
        if (kvm_lapic_enabled(vcpu)) {
                if (kvm_x86_ops->sync_pir_to_irr && vcpu->arch.apicv_active)
                        kvm_x86_ops->sync_pir_to_irr(vcpu);
        }

        if (vcpu->mode == EXITING_GUEST_MODE || vcpu->requests

and WRITE_ONCE is not needed if you have a memory barrier (though I find it
more self-documenting to use it anyway).

Paolo
