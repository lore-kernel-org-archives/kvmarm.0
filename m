From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC/RFT PATCH 3/3] arm64: KVM: keep trapping of VM sysreg writes
 enabled
Date: Thu, 19 Feb 2015 15:22:35 +0000
Message-ID: <CAKv+Gu_gToTmvBNKbHKVL+aV8cpTLy1c06ddK+a18HchoDh7ug@mail.gmail.com>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
 <1424343286-6792-4-git-send-email-ard.biesheuvel@linaro.org>
 <54E5E7B2.2080501@arm.com>
 <CAKv+Gu-vdntgb3TjzmNj6pA3nW-JKUOf+Xiut9BVHBnpR25iGg@mail.gmail.com>
 <54E5FF05.202@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 452274609E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 10:17:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P8JgYT2L5swV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Feb 2015 10:17:07 -0500 (EST)
Received: from mail-ig0-f178.google.com (mail-ig0-f178.google.com
 [209.85.213.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 035B745FC5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 10:17:06 -0500 (EST)
Received: by mail-ig0-f178.google.com with SMTP id hl2so9954071igb.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Feb 2015 07:22:35 -0800 (PST)
In-Reply-To: <54E5FF05.202@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "lersek@redhat.com" <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 19 February 2015 at 15:19, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 19/02/15 13:44, Ard Biesheuvel wrote:
>> On 19 February 2015 at 13:40, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> On 19/02/15 10:54, Ard Biesheuvel wrote:
>>>> ---
>>>>  arch/arm/kvm/mmu.c               | 2 +-
>>>>  arch/arm64/include/asm/kvm_arm.h | 2 +-
>>>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>>>> index 136662547ca6..fa8ec55220ea 100644
>>>> --- a/arch/arm/kvm/mmu.c
>>>> +++ b/arch/arm/kvm/mmu.c
>>>> @@ -1530,7 +1530,7 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
>>>>               stage2_flush_vm(vcpu->kvm);
>>>>
>>>>       /* Caches are now on, stop trapping VM ops (until a S/W op) */
>>>> -     if (now_enabled)
>>>> +     if (0)//now_enabled)
>>>>               vcpu_set_hcr(vcpu, vcpu_get_hcr(vcpu) & ~HCR_TVM);
>>>>
>>>>       trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
>>>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>>>> index 8afb863f5a9e..437e1ec17539 100644
>>>> --- a/arch/arm64/include/asm/kvm_arm.h
>>>> +++ b/arch/arm64/include/asm/kvm_arm.h
>>>> @@ -75,7 +75,7 @@
>>>>   * FMO:              Override CPSR.F and enable signaling with VF
>>>>   * SWIO:     Turn set/way invalidates into set/way clean+invalidate
>>>>   */
>>>> -#define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
>>>> +#define HCR_GUEST_FLAGS (HCR_TSC | /* HCR_TSW | */ HCR_TWE | HCR_TWI | HCR_VM | \
>>>
>>> Why do we stop to trap S/W ops here? We can't let the guest issue those
>>> without doing anything, as this will break anything that expects the
>>> data to make it to memory. Think of the 32bit kernel decompressor, for
>>> example.
>>>
>>
>> TBH patch #3 is just a q'n'd hack to ensure that the TVM bit remains
>> set in HCR. I was assuming that cleaning the entire cache on mmu
>> enable/disable would be sufficient to quantify the performance impact
>> and check whether patch #2 works as advertised.
>
> OK.
>
>> I was wondering: isn't calling stage2_flush_vm() for each set of each
>> way very costly?
>
> It's only called once, when TVM is not set. We then set TVM to make sure
> that this doesn't happen anymore, until we stop trapping.
>

Ah, right, of course.

> Of course, with your new approach, this doesn't work anymore and we'd
> need to find another approach.
>

Well, *if* this approach is feasible in the first place, I'm sure we
can find another bit to set to keep track of whether to perform the
s/w operations. For now, I just ripped it out because I was afraid it
might skew performance measurements done with the TVM kept set.

-- 
Ard.
