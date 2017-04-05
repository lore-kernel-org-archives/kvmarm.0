From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/9] KVM: Add documentation for VCPU requests
Date: Wed, 5 Apr 2017 20:29:12 +0200
Message-ID: <45234347-1773-3359-81e3-e1ffe2ae560b@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-3-drjones@redhat.com> <20170404152403.GK11752@cbox>
 <20170404170600.w6snnecqoi4aqv4d@kamzik.brq.redhat.com>
 <20170404172340.GQ11752@cbox> <20170405141139.GA13944@potion>
 <20170405174538.GB27123@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170405174538.GB27123@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu



On 05/04/2017 19:45, Christoffer Dall wrote:
>>> But the problem is that kvm_make_all_cpus_request() only sends IPIs to
>>> CPUs where the mode was different from OUTSIDE_GUEST_MODE, so there it's
>>> about !OUTSIDE_GUEST_MODE rather than !IN_GUEST_MODE, so there's some
>>> subtlety here which I feel like it's dangerous to paper over.
>> Right, that needs fixing in the code.
> Really?  I thought Paolo said that this is the intended behavior and
> semantics; non-urgent requests that should just be serviced before the
> next guest entry.

Indeed, that's right...

>> guest_mode is just an optimization that allows us to skip sending the
>> IPI when the VCPU is known to handle the request as soon as possible.
>>
>>   IN_GUEST_MODE: we must force VM exit or the request could never be
>>     handled
>>   EXITING_GUEST_MODE: another request already forces the VM exit and
>>     we're just waiting for the VCPU to notice our request
>>   OUTSIDE_GUEST_MODE: KVM is going to notice our request without any
>>     intervention
>>   READING_SHADOW_PAGE_TABLES: same as OUTSIDE_GUEST_MODE -- rename to
>>     unwieldly OUTSIDE_GUEST_MODE_READING_SHADOW_PAGE_TABLES?
> Again, I thought Paolo was arguing that EXITING_GUEST_MODE makes the
> whole thing work because you check that after checking requests?

... but apparently I was wrong here, see my email from this morning.

>> The kick is needed only in IN_GUEST_MODE and a wake up is needed in case
>> where the guest is halted OUTSIDE_GUEST_MODE ...
>> Hm, maybe we should add a halt state too?
> Wouldn't that be swait_active(&vcpu->wq) ?   You could add a wrapper
> though.

Yes.  I think the wrapper is probably unnecessary.

> What I think you need is a way to distinguish the semantics of calling
> kvm_make_all_cpus_request(), perhaps by adding a 'bool wake_up'
> parameter.

That would be fine.

Paolo
