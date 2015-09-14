From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 07/10] KVM: arm/arm64: vgic: Allow HW interrupts for
 non-shared devices
Date: Mon, 14 Sep 2015 13:11:38 +0200
Message-ID: <20150914111138.GF15712@cbox>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
 <1439212864-12954-8-git-send-email-eric.auger@linaro.org>
 <20150902194246.GV10991@cbox> <55EFF0BC.8090200@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AE18412EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 07:09:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G6pYWjlUMaTr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2015 07:09:03 -0400 (EDT)
Received: from mail-la0-f41.google.com (mail-la0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3532D41291
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 07:09:02 -0400 (EDT)
Received: by lahg1 with SMTP id g1so54399760lah.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 04:09:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55EFF0BC.8090200@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, feng.wu@intel.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On Wed, Sep 09, 2015 at 10:41:32AM +0200, Eric Auger wrote:

[...]

> I tried to integrate into the updated state machine for non shared
> mapped IRQ but I fail.

What exactly do you mean when you refer to 'updated state machine' ?

> 
> 1) The first problem encountered is how to reset the level of the IRQ
> (since its completion is not trapped). I added this reset in
> process_queued_irq. I think this was the most natural place since at
> sink time we get aware the IRQ is deactivated at physical distributor
> level. However I observe  failures in vgic_validate_injection. I think
> there is due to a race between update_irq_pending and sync. As soon as
> the guest EOI's the virtual IRQ (and also the pIRQ), a new physical IRQ
> hits and gets injected by irqfd. This injection can happen before the
> sync. So I would be tempted to keep my current strategy of ignoring the
> validate_injection in case of non-shared mapped IRQ and not model the
> level state. The vIRQ directly comes from the HW so it must be valid
> (guest deactivated the previous occurence).

I'm a bit confused about what we are talking about here?

Are you asking about how we should deal with forwarded, level-triggered,
non-shared interrupts?

If that's the case, here are my high-level thoughts:
 - We should not maintain a virtual line state, because this is
   maintained in hardware
 - Ideally we sample the physical distributor pending state at the
   important points (sync/flush).
 - Sampling the physical state may be slow/difficult, so we may
   choose an optimization, for example cache the pending state when the
   host ISR runs and clear the pending state when the interrupt is
   injected and not care about spurious interrupts if the signal is
   lowered after it's raised.

> 
> 2) can_sample.
> once the above problem fixed, next issue is the can_sample failure.
> Queued state also is reset in process_queued_irq and can_sample fails.
> Same punishment. So currently the only manner I found to make this work
> and sample the IRQ only once is to use the pending state which I reset
> when I queue the IRQ.

So queued means that we don't sample the virtual line state, yes?  If
so, then it would make sense to always set the state as queued for
injected forwarded non-shared level-triggered interrupts.

Does this help?

-Christoffer
