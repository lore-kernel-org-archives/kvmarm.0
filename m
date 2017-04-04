From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Tue, 4 Apr 2017 19:35:11 +0200
Message-ID: <e3977a97-a240-58a6-288d-09f3c12de56c@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com> <20170404160417.GN11752@cbox>
 <06b2a225-192c-9c96-c092-6e0575dd9410@redhat.com>
 <20170404171953.GP11752@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170404171953.GP11752@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu



On 04/04/2017 19:19, Christoffer Dall wrote:
> On Tue, Apr 04, 2017 at 06:24:36PM +0200, Paolo Bonzini wrote:
>>
>>
>> On 04/04/2017 18:04, Christoffer Dall wrote:
>>>> For pause, only the requester should do the clearing.
>>
>> This suggests that maybe this should not be a request.  The request
>> would be just the need to act on a GIC command, exactly as before this patch.
> 
> Maybe the semantics should be:
> 
> requester:                                vcpu:
> ----------                                -----
> make_requet(vcpu, KVM_REQ_PAUSE);
>                                           handles the request by
> 					  clearing it and setting
> 					  vcpu->pause = true;
> wait until vcpu->pause == true
> make_request(vcpu, KVM_REQ_UNPAUSE);
>                                           vcpus 'wake up' clear the
> 					  UNPAUSE request and set
> 					  vcpu->pause = false;
> 
> The benefit would be that we get to re-use the complicated "figure out
> the VCPU mode and whether or not we should send an IPI and get the
> barriers right" stuff.

I don't think that's necessary.  As long as the complicated stuff avoids
that you enter the VCPU, the next run through the loop will
find that 'vcpu->arch.power_off || vcpu->arch.pause' is true and
go to sleep.

>> What I don't understand is:
>>
>>>> With this patch, while the vcpu will still initially enter
>>>> the guest, it will exit immediately due to the IPI sent by the vcpu
>>>> kick issued after making the vcpu request.
>>
>> Isn't this also true of KVM_REQ_VCPU_EXIT that was used before?
>>
>> So this:
>>
>> +			vcpu->arch.power_off || kvm_request_pending(vcpu)) {
>> +			WRITE_ONCE(vcpu->mode, OUTSIDE_GUEST_MODE);
>>
>> is the crux of the fix, you can keep using vcpu->arch.pause.
> 
> Probably; I feel like there's a fix here which should be a separate
> patch from using a different requests instead of the KVM_REQ_VCPU_EXIT +
> the pause flag.

Yeah, and then the pause flag can stay.

>> By the way, vcpu->arch.power_off can go away from this "if" too because
>> KVM_RUN and KVM_SET_MP_STATE are mutually exclusive through the vcpu mutex.
> 
> But we also allow setting the power_off flag from the in-kernel PSCI
> emulation in the context of another VCPU thread.

Right.  That code does

                tmp->arch.power_off = true;
                kvm_vcpu_kick(tmp);

and I think what's really missing in arm.c is the "if (vcpu->mode ==
EXITING_GUEST_MODE)" check that is found in x86.c.  Then pausing can
also simply use kvm_vcpu_kick.

My understanding is that KVM-ARM is using KVM_REQ_VCPU_EXIT simply to
reuse the smp_call_function_many code in kvm_make_all_cpus_request.
Once you add EXITING_GUEST_MODE, ARM can just add a new function
kvm_kick_all_cpus and use it for both pause and power_off.

Paolo
