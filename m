From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 0/3] KVM: arm/arm64: Allow to use KVM without in-kernel
 irqchip
Date: Wed, 22 Jul 2015 10:19:26 +0300
Message-ID: <03d901d0c44e$beadaa90$3c08ffb0$@samsung.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
 <55A93488.9060408@arm.com> <00df01d0c22b$fcaef0d0$f60cd270$@samsung.com>
 <55ACAC73.9090500@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55ACAC73.9090500@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: 'Christoffer Dall' <christoffer.dall@linaro.org>, 'Eric Auger' <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> It means that a pause in the discussion for a week (or even more) is not
> uncommon at all. It just means that the other party is busy with things
> of higher priority. In all cases, a gentle "ping" will be better
> received than this "you've stopped replying so I'm going to repost until
> you stop ignoring me" kind of behaviour.

 Ok, sorry for that.

> I don't care much for such an API, mostly because it will obviously
> bitrot very quickly (your "broken VGIC" platform is hopefully a one off
> that won't be repeated again, and the RPi is out of scope anyway).
> 
> It would have to be extremely non-intrusive and completely safe for this
> to be taken in...

 Ok, let's leave this API alone then for now...
 Will then be a concensus if i tweak the thing a little bit and we just enable KVM without both vGIC
and vTimer ? It will be an emulator's problem how to handle them then.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

