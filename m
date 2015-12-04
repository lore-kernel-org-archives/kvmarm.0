From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: Revert to old way of checking for device
 mapping in stage2_flush_ptes().
Date: Fri, 04 Dec 2015 09:39:10 +0300
Message-ID: <009501d12e5e$7c101f90$74305eb0$@samsung.com>
References: <1448975032-7156-1-git-send-email-p.fedin@samsung.com>
 <CAKv+Gu-WhtTZoPEmRSa8Ypcc9SZ-d6NABDSfZ6tTx14Tyt+AdQ@mail.gmail.com>
 <1449194337.30642.69.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-reply-to: <1449194337.30642.69.camel@decadent.org.uk>
Content-language: ru
Sender: stable-owner@vger.kernel.org
To: 'Ben Hutchings' <ben@decadent.org.uk>, 'Ard Biesheuvel' <ard.biesheuvel@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, 'KVM devel mailing list' <kvm@vger.kernel.org>, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > > Cc: stable@vger.kernel.org
> > > Fixes: e6fab5442345 ("ARM/arm64: KVM: test properly for a PTE's uncachedness")
> > >
> >
> > That commit is not in a release yet, so no need for cc stable
> [...]
> 
> But it is cc'd to stable, so unless it is going to be nacked at review
> stage, any subsequent fixes should also be cc'd.

 Sorry guys for messing things up a bit, but the affected commit actually is in stable branch (4.4-rc3), so i decided to Cc: stable, just in case, because the breakage is quite big IMHO.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
