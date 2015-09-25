From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: BUG FIX: Do not inject spurious interrupts
Date: Fri, 25 Sep 2015 17:01:45 +0300
Message-ID: <012f01d0f79a$b6fc59c0$24f50d40$@samsung.com>
References: <1440676282-2152-1-git-send-email-p.fedin@samsung.com>
 <20150827124442.GD29439@cbox> <00ca01d0e171$7ff1c710$7fd55530$@samsung.com>
 <20150914112932.GH15712@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150914112932.GH15712@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> The alternative is to just call compute_pending which does nothing more
> than a few bitwise and/or operations plus a couple of handfuls of
> load/stores on this IRQ injection path, so I don't see the problem doing
> this.

 I looked at it, convinced. After all, resetting pending_on_cpu saves from unnecessary wakeups IIRC.
Posting v2...

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

