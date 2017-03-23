From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 00/28] arm/arm64: KVM: Rework the hyp-stub API
Date: Thu, 23 Mar 2017 15:16:49 +0000
Message-ID: <e424e00c-e649-8e6a-7f73-ffbd37046779@arm.com>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
 <20170322133724.GA10969@cbox> <3dab2f39-88c2-e10b-942c-58a1d8053b71@arm.com>
 <20170322172708.GA17329@cbox> <10524c84-1e1e-05f8-97b9-436c8649ffa8@arm.com>
 <20170323143916.GA27715@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5145B40A66
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Mar 2017 11:15:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hnh226AZvxA1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Mar 2017 11:15:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3361340962
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Mar 2017 11:15:01 -0400 (EDT)
In-Reply-To: <20170323143916.GA27715@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, Keerthy <j-keerthy@ti.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 23/03/17 14:39, Christoffer Dall wrote:
> On Thu, Mar 23, 2017 at 10:53:04AM +0000, Marc Zyngier wrote:
>> On 22/03/17 17:27, Christoffer Dall wrote:
>>>
>>> I don't think there is a great use case beyond what we already do, it
>>> would just be to have one set of hyp vectors fewer, so that either the
>>> hyp stub is in place, or a hypervisor is in place, not kvm-init vectors.
>>>
>>> So instead of doing:
>>>   __hyp_set_vectors(kvm_get_idmap_vector());
>>>   hvc(); /* via the misused kvm_call_hyp thing */
>>>
>>> you would do:
>>>
>>>   __hyp_call_function(__kvm_hyp_init, arg1, arg2);
>>>
>>> which would change the vector and initialize anything.
>>>
>>> Not sure if that can work though, or if there are any downsides that I
>>> haven't thought about?
>>
>> I've given it a go, and that seems to work, at least on arm64. We may 
>> have to set the vectors in a slightly different way on 32bit because 
>> we're going to run out of registers (we only have two left once we 
>> reach the function being called).
> 
> Right, that's a challenge I clearly didn't foresee.
> 
>>
>> Another thing is that the function called is not really a function. It 
>> is an exception handler, as it has to end with an eret (or we may need 
>> to save LR in funky ways).
> 
> Shouldn't it have the same semantics as the KVM calling function thing
> where it pushes the LR on the stack?  But of course, that requires
> having a stack for each runtime that owns hyp mode at any given time.
> Potentially not great.

Indeed, and that's the point where I'm starting to think that we may be
trying to beautify something that may not be worth it.

> If possible, the idea would be that you'd call functions, just like you
> normally do, but the functions you call can choose to never return -
> again just like a C function can do if it messes with your machine
> configuration.
> 
> But maybe the idea is fundamentally flawed, if the only function
> you'd ever call from the hyp stub is one that takes over the hyp world,
> and then the original design was just based on using set_vectors.  Hmmm.

That's my point above. The only use case we have so far for this method
is to take over EL2. On the other have, I've noticed that the more I
rework this area, the more old stuff surfaces, ready to be nuked. Maybe
I should keep digging.

> 
>>  The potential blocker for this is that the
>> 32bit decompressor does use set_vectors in funky ways to deal with
>> relocation. If we get rid of set_vectors like I just did on 64bit,
>> we'll need to mess with that as well.
> 
> Interesting.  I didn't think that we'd necessarily get rid of
> set_vectors, but I agree with you that if we wanted to do this, it
> should probably go.
> 
>>
>> Anyway, here's the hack, 64bit only, quickly tested on Mustang. I'm not
>> completely sure this is any prettier, but it is certainly manageable.
> 
> There are two things I like about it.  First, it gets rid of the
> 'additional runtime' in hyp and second the changes to
> cpu_init_hyp_mode() are quite nice, imho.
> 
> Thanks being said, this series is pretty nice as it is, so I don't want
> to impose more work on you at the moment, so maybe we save your patch
> snipped below for later if we want to consider looking at it some other
> time?

What I can do is prepare an extra series that would include the
corresponding 32bit changes, and we then evaluate that separately. I
don't mind spending a bit of time on it.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
