From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH] arm64: KVM: remove fpsimd save/restore from the world
 switch
Date: Fri, 10 Apr 2015 10:40:16 +0100
Message-ID: <55279A80.5030709@arm.com>
References: <1428598439-5217-1-git-send-email-marc.zyngier@arm.com>
 <55278CAD.70302@redhat.com> <552793CF.8050904@arm.com>
 <5527943C.3030400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A2A44C050
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 05:32:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E-QramxjrdGW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2015 05:32:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C9D84C04F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2015 05:32:40 -0400 (EDT)
In-Reply-To: <5527943C.3030400@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/04/15 10:13, Paolo Bonzini wrote:
> 
> 
> On 10/04/2015 11:11, Marc Zyngier wrote:
>>> Good idea!  Does ARM have a way to do "lazy" save/restore?  On x86 we
>>> know if the FP/SIMD state was in use on the host, and we can force an
>>> exit the first time the guest uses the FP/SIMD.
>>>
>>> On ARM, it wouldn't be a problem to handle this kind of exit straight in
>>> EL2 (similar to the hack Ard used when playing with memory attributes).
>>
>> We already do this on the 32bit port, and it works fine.
>>
>> I did some experimentations on arm64 a long while ago (see the
>> kvm-arm64/lazy-fp branch in my tree), and it wasn't that great,
>> apparently because aarch64 userspace tends to be much more FP happy than
>> aarch32, but I'm not completely sure about it. Also this is from a time
>> when I didn't have much HW to play with...
>>
>> Maybe I should resurrect it and compare it to what this patch does, just
>> as a comparison point.
> 
> This patch looks like very nice low-hanging fruit anyway.  Would you
> like to have it in 4.1?

It is a bit "fresh off the compiler", hence the RFC tag. I'm going to
run some tests on it during the day, using slightly less braindead
hardware (the HiKey board is nice because of its form factor, but that's
the only nice thing about it...).

Once I'm confident it doesn't introduce any regression, it will be worth
considering.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
