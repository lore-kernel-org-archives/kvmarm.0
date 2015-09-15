From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 6/8] arm/arm64: KVM: Add forwarded physical interrupts
 documentation
Date: Tue, 15 Sep 2015 16:16:07 +0100
Message-ID: <55F83637.3060400@arm.com>
References: <1441395650-19663-1-git-send-email-christoffer.dall@linaro.org>
 <1441395650-19663-7-git-send-email-christoffer.dall@linaro.org>
 <55ED7427.1020901@arm.com> <55EE9FA4.3060204@linaro.org>
 <55EF1389.10802@arm.com>
 <CAMJs5B_Qxkfu=KSA0oUm386_mgZ73_NQEqS6e+gBGxwBMJVezg@mail.gmail.com>
 <55F2B932.2030901@arm.com> <20150914114219.GJ15712@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0196412C2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2015 11:13:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yHAdA5gzWcUS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2015 11:13:53 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DCB940FB3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2015 11:13:52 -0400 (EDT)
In-Reply-To: <20150914114219.GJ15712@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 14/09/15 12:42, Christoffer Dall wrote:
....
>>>> Where is this done? I see that the physical dist state is altered on the
>>>> actual IRQ forwarding, but not on later exits/entries? Do you mean
>>>> kvm_vgic_flush_hwstate() with "flush"?
>>>
>>> this is a bug and should be fixed in the 'fixes' patches I sent last
>>> week.  We should set active state on every entry to the guest for IRQs
>>> with the HW bit set in either pending or active state.
>>
>> OK, sorry, I missed that one patch, I was looking at what should become
>> -rc1 soon (because that's what I want to rebase my ITS emulation patches
>> on). That patch wasn't in queue at the time I started looking at it.
>>
>> So I updated to the latest queue containing those two fixes and also
>> applied your v2 series. Indeed this series addresses some of the things
>> I was wondering about the last time, but the main thing still persists:
>> - Every time the physical dist state is active we have the virtual state
>> still at pending or active.
> 
> For the arch timer, yes.
> 
> For a passthrough device, there should be a situation where the physical
> dist state is active but we didn't see the virtual state updated at the
> vgic yet (after physical IRQ fires and before the VFIO ISR calls
> kvm_set_irq).

But then we wouldn't get into vgic_sync_hwirq(), because we wouldn't
inject a mapped IRQ before kvm_set_irq() is called, would we?

>> - If the physical dist state is non-active, the virtual state is
>> inactive (LR.state==8: HW bit) as well. The associated ELRSR bit is 1
>> (LR empty).
>> (I was tracing every HW mapped LR in vgic_sync_hwirq() for this)
>>
>> So that contradicts:
>>
>> +  - On guest EOI, the *physical distributor* active bit gets cleared,
>> +    but the LR.Active is left untouched (set).
>>
>> This is the main point I was actually wondering about: I cannot confirm
>> this statement. In my tests the LR state and the physical dist state
>> always correspond, as excepted by reading the spec.
>>
>> I reckon that these observations are mostly independent from the actual
>> KVM code, as I try to observe hardware state (physical distributor and
>> LRs) before KVM tinkers with them.
> 
> ok, I got this paragraph from Marc, so we really need to ask him?  Which
> hardware are you seeing this behavior on?  Perhaps implementations vary
> on this point?

I checked this on Midway and Juno. Both have a GIC-400, but I don't have
access to any other GIC implementations.
I added the two BUG_ONs shown below to prove that assumption.

Eric, I've been told you observed the behaviour with the GIC not syncing
LR and phys state for a mapped HWIRQ which was not the timer.
Can you reproduce this? Does it complain with the patch below?

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 5942ce9..7fac16e 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1459,9 +1459,12 @@ static bool vgic_sync_hwirq(struct kvm_vcpu
 					     IRQCHIP_STATE_ACTIVE,
 					     false);
 		WARN_ON(ret);
+		BUG_ON(!(vlr.state & 3));
 		return false;
 	}

+	BUG_ON(vlr.state & 3);
+
 	return process_queued_irq(vcpu, lr, vlr);
 }

> 
> I have no objections removing this point from the doc though, I'm just
> relaying information on this one.

I see, I talked with Marc and I am about to gather more data with the
above patch to prove that this never happens.

>>
>> ...
>>
>>>
>>>> Is this an observation, an implementation bug or is this mentioned in
>>>> the spec? Needing to spoon-feed the VGIC by doing it's job sounds a bit
>>>> awkward to me.
>>>
>>> What do you mean?  How are we spoon-feeding the VGIC?
>>
>> By looking at the physical dist state and all LRs and clearing the LR we
>> do what the GIC is actually supposed to do for us - and what it actually
>> does according to my observations.
>>
>> The point is that patch 1 in my ITS emulation series is reworking the LR
>> handling and this patch was based on assumptions that seem to be no
>> longer true (i.e. we don't care about inactive LRs except for our LR
>> mapping code). So I want to be sure that I fully get what is going on
>> here and I struggle at this at the moment due to the above statement.
>>
>> What are the plans regarding your "v2: Rework architected timer..."
>> series? Will this be queued for 4.4? I want to do the
>> rebasing^Wrewriting of my series only once if possible ;-)
>>
> I think we should settle on this series ASAP and base your ITS stuff on
> top of it.  What do you think?

Yeah, that's what I was thinking too. So I will be working against
4.3-rc1 with your timer-rework-v2 branch plus the other fixes from the
kvm-arm queue merged.

Cheers,
Andre.
