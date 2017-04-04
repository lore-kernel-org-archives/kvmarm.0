From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Tue, 4 Apr 2017 18:24:36 +0200
Message-ID: <06b2a225-192c-9c96-c092-6e0575dd9410@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com> <20170404160417.GN11752@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170404160417.GN11752@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu



On 04/04/2017 18:04, Christoffer Dall wrote:
>> For pause, only the requester should do the clearing.

This suggests that maybe this should not be a request.  The request
would be just the need to act on a GIC command, exactly as before this patch.

What I don't understand is:

>> With this patch, while the vcpu will still initially enter
>> the guest, it will exit immediately due to the IPI sent by the vcpu
>> kick issued after making the vcpu request.

Isn't this also true of KVM_REQ_VCPU_EXIT that was used before?

So this:

+			vcpu->arch.power_off || kvm_request_pending(vcpu)) {
+			WRITE_ONCE(vcpu->mode, OUTSIDE_GUEST_MODE);

is the crux of the fix, you can keep using vcpu->arch.pause.

By the way, vcpu->arch.power_off can go away from this "if" too because
KVM_RUN and KVM_SET_MP_STATE are mutually exclusive through the vcpu mutex.
The earlier check is enough:

                 if (vcpu->arch.power_off || vcpu->arch.pause)
                         vcpu_sleep(vcpu);


>> +		/*
>> +		 * Indicate we're in guest mode now, before doing a final
>> +		 * check for pending vcpu requests. The general barrier
>> +		 * pairs with the one in kvm_arch_vcpu_should_kick().
>> +		 * Please see the comment there for more details.
>> +		 */
>> +		WRITE_ONCE(vcpu->mode, IN_GUEST_MODE);
>> +		smp_mb();
> 
> There are two changes here:
> 
> there's a change from a normal write to a WRITE_ONCE and there's also a
> change to that adds a memory barrier.  I feel like I'd like to know if
> these are tied together or two separate cleanups.  I also wonder if we
> could split out more general changes from the pause thing to have a
> better log of why we changed the run loop?

You probably should just use smp_store_mb here.

Paolo
