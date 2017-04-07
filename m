From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Fri, 7 Apr 2017 19:47:29 +0800
Message-ID: <b435db93-9d46-52d6-7aa7-458dbbc2b7ef@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com> <20170404160417.GN11752@cbox>
 <20170404175718.su4tjx3psyez3qee@kamzik.brq.redhat.com>
 <20170404190438.GF31208@cbox>
 <63209d09-0c45-0bb2-322b-e422f1360df7@redhat.com>
 <20170405070959.GA1526@cbox>
 <91ab3b0b-c30e-7a19-f60f-882d26388ef5@redhat.com>
 <20170406141443.GC27123@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170406141443.GC27123@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 06/04/2017 22:14, Christoffer Dall wrote:
>> So it seems like there are no races after all in KVM/ARM code
>
> No races after Drew's fix has been applied to set vcpu->mode =
> IN_GUEST_MODE, before checking the pause flag, correct?  (I think that's
> what the spin model below is modeling).

Yes.  All of them include the vcpu->mode = IN_GUEST_MODE assignment and
(implicitly because spin is sequentially consistent) the memory barrier.

>> After this experiment, I think I like Drew's KVM_REQ_PAUSE more than I did
>> yesterday.  However, yet another alternative is to leave pause/power_off as
>> they are, while taking some inspiration from his patch to do some cleanups:
>>
>> 1) change the "if"
>>
>>                 if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
>>                         vcpu->arch.power_off || vcpu->arch.pause) {
>>
>> to test kvm_requests_pending instead of pause/power_off
>>
>> 2) clear KVM_REQ_VCPU_EXIT before the other "if":
>>
>>                 if (vcpu->arch.power_off || vcpu->arch.pause)
>>                         vcpu_sleep(vcpu);
>
> I like using requests as only requests from one thread to the VCPU
> thread, and not to maintain specific state about a VCPU.
> 
> The benefit of Drew's approach is that since these pieces of state are
> boolean, you can have just a single check in the critical path in the
> run loop instead of having to access multiple fields.

I think you'd still need two checks for KVM_REQ_PAUSE/KVM_REQ_POWEROFF:
one to check whether to sleep, and one to check whether to abort the
vmentry.

Pause and power_off could be merged into a single bitmask if necessary, too.

Paolo
