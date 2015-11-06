From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm: Fix crash in free_hyp_pgds() if timer
 initialization fails
Date: Fri, 06 Nov 2015 17:06:07 +0300
Message-ID: <008801d1189c$48dbe370$da93aa50$@samsung.com>
References: <1445931608-8824-1-git-send-email-p.fedin@samsung.com>
 <20151105152440.GF5819@cbox> <002601d11876$1bc3cf40$534b6dc0$@samsung.com>
 <20151106114223.GI5819@cbox> <006d01d11899$2f7932f0$8e6b98d0$@samsung.com>
 <563CB012.3090705@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <563CB012.3090705@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> >> The thing I want to avoid is PAGE_HYP_DEVICE covering some normal S2
> >> mapping, which we *should* flush but that we now end up ignoring?  That
> >> doesn't sound like it can be the case because the device bit is the same
> >> bit for both types of page tables, correct?
> >
> >  Yes, this is exactly what i think. If DEVICE bit is set, then it's somehow
> > device memory and it doesn't need flashing.
> >
> >  Or, in order to be 200% sure, we could modify the whole unmapping logic to carry
> > over a flag, telling whether we are removing normal or HYP mappings. But wouldn't
> > this be much more complicated?
> 
> We could do without that complexity. Also, the test itself is wrong (see
> Ard's patch that was posted this morning for the real fix).

 Good. Saw it, will test it on monday. Indeed, this is better than my approach, and
this is what i actually wanted to do but didn't study the thing deeply enough to
implement.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


