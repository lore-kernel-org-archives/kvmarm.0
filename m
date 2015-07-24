From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 0/3] KVM: arm/arm64: Allow to use KVM without in-kernel
 irqchip
Date: Fri, 24 Jul 2015 18:27:37 +0300
Message-ID: <008f01d0c625$45d91a90$d18b4fb0$@samsung.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
 <55A93488.9060408@arm.com> <00df01d0c22b$fcaef0d0$f60cd270$@samsung.com>
 <55ACAC73.9090500@arm.com> <03d901d0c44e$beadaa90$3c08ffb0$@samsung.com>
 <55B11AEC.4050804@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55B11AEC.4050804@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: 'Christoffer Dall' <christoffer.dall@linaro.org>, 'Eric Auger' <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

> >  Ok, let's leave this API alone then for now...
> >  Will then be a concensus if i tweak the thing a little bit and we just enable KVM without both
vGIC
> > and vTimer ? It will be an emulator's problem how to handle them then.
> 
> Well, let's see the patches first, and how invasive they are.

 Please, i've just posted an RFC and cc'ed you.
 I would say the implementation is very small. However, perhaps, it's not going to work with active
state switching patch, because as far as i understand the whole thing depends on manipulations with
ARCH_TIMER_CTRL_IT_MASK. Without it i'm going to get multiple interrupts instead of only one. It
would be possible to signal the interrupt as real level-sensitive (since we will be tracking active
state), but... it's not possible to know when to deactivate the line, hardware doesn't report that.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

