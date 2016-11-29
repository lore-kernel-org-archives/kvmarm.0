From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Access CNTHCTL_EL2 bit fields correctly
Date: Tue, 29 Nov 2016 09:36:58 +0000
Message-ID: <0a475329-6f50-42ae-3244-f0767c56ce09@arm.com>
References: <1480351570-11648-1-git-send-email-jintack@cs.columbia.edu>
 <d04fd17e-9157-07fe-4daa-9dbab149b5e6@arm.com>
 <799d03f5-a929-9547-1ae7-94026b76f116@arm.com>
 <CAHyh4xhXoFWsbnNNePthWp2-ZAOtCuUVmLn-JKRe4sc=nqrYNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 789F240796
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 04:36:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6to7qFfMFPiO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2016 04:36:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31811405C4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 04:36:14 -0500 (EST)
In-Reply-To: <CAHyh4xhXoFWsbnNNePthWp2-ZAOtCuUVmLn-JKRe4sc=nqrYNw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: KVM General <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 29/11/16 03:28, Jintack Lim wrote:
> On Mon, Nov 28, 2016 at 1:39 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> On 28/11/16 17:43, Marc Zyngier wrote:
>>> Hi Jintack,
> 
> Hi Marc,
> 
>>>
>>> On 28/11/16 16:46, Jintack Lim wrote:
>>>> Bit positions of CNTHCTL_EL2 are changing depending on HCR_EL2.E2H bit.
>>>> EL1PCEN and EL1PCTEN are 1st and 0th bits when E2H is not set, but they
>>>> are 11th and 10th bits respectively when E2H is set.  Current code is
>>>> unintentionally setting wrong bits to CNTHCTL_EL2 with E2H set, which
>>>> may allow guest OS to access physical timer. So, fix it.
>>>>
>>>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>>>> ---
>>>>  arch/arm/include/asm/kvm_timer.h     | 33 +++++++++++++++++++
>>>>  arch/arm64/include/asm/kvm_timer.h   | 62 ++++++++++++++++++++++++++++++++++++
>>>>  include/clocksource/arm_arch_timer.h |  6 ++--
>>>>  virt/kvm/arm/hyp/timer-sr.c          |  8 ++---
>>>>  4 files changed, 103 insertions(+), 6 deletions(-)
>>>>  create mode 100644 arch/arm/include/asm/kvm_timer.h
>>>>  create mode 100644 arch/arm64/include/asm/kvm_timer.h
>>>>
>>
>> [...]
>>
>>> We could make it nicer (read "faster") by introducing a
>>> hyp_alternate_select construct that only returns a value instead
>>> of calling a function. I remember writing something like that
>>> at some point, and dropping it...
>>
>> So here's what this could look like (warning, wacky code ahead,
>> though I fixed a stupid bug that was present in the previous patch).
>> The generated code is quite nice (no branch, only an extra mov
>> instruction on the default path)... Of course, completely untested!
> 
> This looks much cleaner than my patch.
> While we are at it, is it worth to consider that we just need to set
> those bits once for VHE case, not for every world switch as an
> optimization?

Ah! That's a much better idea indeed! And we could stop messing with
cntvoff_el2 as well, as it doesn't need to be restored to zero on exit.
Could you try and respin something along those lines?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
