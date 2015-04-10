From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH] arm64: KVM: remove fpsimd save/restore from the world
 switch
Date: Fri, 10 Apr 2015 11:13:32 +0200
Message-ID: <5527943C.3030400@redhat.com>
References: <1428598439-5217-1-git-send-email-marc.zyngier@arm.com> <55278CAD.70302@redhat.com> <552793CF.8050904@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <552793CF.8050904@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 10/04/2015 11:11, Marc Zyngier wrote:
>> Good idea!  Does ARM have a way to do "lazy" save/restore?  On x86 we
>> know if the FP/SIMD state was in use on the host, and we can force an
>> exit the first time the guest uses the FP/SIMD.
>>
>> On ARM, it wouldn't be a problem to handle this kind of exit straight in
>> EL2 (similar to the hack Ard used when playing with memory attributes).
> 
> We already do this on the 32bit port, and it works fine.
> 
> I did some experimentations on arm64 a long while ago (see the
> kvm-arm64/lazy-fp branch in my tree), and it wasn't that great,
> apparently because aarch64 userspace tends to be much more FP happy than
> aarch32, but I'm not completely sure about it. Also this is from a time
> when I didn't have much HW to play with...
> 
> Maybe I should resurrect it and compare it to what this patch does, just
> as a comparison point.

This patch looks like very nice low-hanging fruit anyway.  Would you
like to have it in 4.1?

Paolo
