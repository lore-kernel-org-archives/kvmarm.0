From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 2/9] KVM: Add documentation for VCPU requests
Date: Wed, 5 Apr 2017 22:46:07 +0200
Message-ID: <20170405204606.GH6369@potion>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-3-drjones@redhat.com>
 <20170404152403.GK11752@cbox>
 <20170404170600.w6snnecqoi4aqv4d@kamzik.brq.redhat.com>
 <20170404172340.GQ11752@cbox> <20170405141139.GA13944@potion>
 <20170405174538.GB27123@cbox>
 <45234347-1773-3359-81e3-e1ffe2ae560b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE04940C56
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 16:43:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WR-aVrGD4mpk for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Apr 2017 16:43:57 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BDBD140C55
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 16:43:57 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <45234347-1773-3359-81e3-e1ffe2ae560b@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: marc.zyngier@arm.com, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

2017-04-05 20:29+0200, Paolo Bonzini:
> On 05/04/2017 19:45, Christoffer Dall wrote:
>>>> But the problem is that kvm_make_all_cpus_request() only sends IPIs to
>>>> CPUs where the mode was different from OUTSIDE_GUEST_MODE, so there it's
>>>> about !OUTSIDE_GUEST_MODE rather than !IN_GUEST_MODE, so there's some
>>>> subtlety here which I feel like it's dangerous to paper over.
>>> Right, that needs fixing in the code.
>> Really?  I thought Paolo said that this is the intended behavior and
>> semantics; non-urgent requests that should just be serviced before the
>> next guest entry.
> 
> Indeed, that's right...
> 
>>> guest_mode is just an optimization that allows us to skip sending the
>>> IPI when the VCPU is known to handle the request as soon as possible.
>>>
>>>   IN_GUEST_MODE: we must force VM exit or the request could never be
>>>     handled
>>>   EXITING_GUEST_MODE: another request already forces the VM exit and
>>>     we're just waiting for the VCPU to notice our request
>>>   OUTSIDE_GUEST_MODE: KVM is going to notice our request without any
>>>     intervention
>>>   READING_SHADOW_PAGE_TABLES: same as OUTSIDE_GUEST_MODE -- rename to
>>>     unwieldly OUTSIDE_GUEST_MODE_READING_SHADOW_PAGE_TABLES?
>> Again, I thought Paolo was arguing that EXITING_GUEST_MODE makes the
>> whole thing work because you check that after checking requests?
> 
> ... but apparently I was wrong here, see my email from this morning.

Ok, I'll prepare a patch that uses kvm_arch_vcpu_should_kick() in
kvm_make_all_cpus_request().

>>> The kick is needed only in IN_GUEST_MODE and a wake up is needed in case
>>> where the guest is halted OUTSIDE_GUEST_MODE ...
>>> Hm, maybe we should add a halt state too?
>> Wouldn't that be swait_active(&vcpu->wq) ?   You could add a wrapper
>> though.
> 
> Yes.  I think the wrapper is probably unnecessary.

The state would only make sense if it were different -- there is a time
when the VCPU is halted, but swait_active(&vcpu->wq) returns false.
Probably doesn't have any good use now, though.

>> What I think you need is a way to distinguish the semantics of calling
>> kvm_make_all_cpus_request(), perhaps by adding a 'bool wake_up'
>> parameter.
> 
> That would be fine.

I think the wakeup is more tied to the request type than to the place
calling it, so we could say which requests are "lazy" and don't do
wakeup and have kvm_make_all_cpus_request() without an extra argument.

In the end, I would like if kvm_make_all_cpus_request() was an optimized
variant of

  kvm_for_each_vcpu(i, vcpu, kvm) {
    kvm_make_request(vcpu, request);
    kvm_vcpu_kick(vcpu);
  }
