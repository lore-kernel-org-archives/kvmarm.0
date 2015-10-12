From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 12/16] KVM: arm64: handle pending bit for LPIs in ITS
 emulation
Date: Mon, 12 Oct 2015 14:39:26 +0300
Message-ID: <004801d104e2$a6966850$f3c338f0$@samsung.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <1444229726-31559-13-git-send-email-andre.przywara@arm.com>
 <016d01d104c1$47a41570$d6ec4050$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <016d01d104c1$47a41570$d6ec4050$@samsung.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Andre Przywara' <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: eric.auger@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

>  Shouldn't we also have 'break' here? If vgic_queue_irq() returns false, this means we have no
> more
> LRs to use, therefore it makes no sense to keep iterating.

 No, don't listen to me. :) Because of piggyback, we indeed have to recheck all the interrupts.

 P.S. I still sometimes lose LPIs, and this is not related to spurious injection fix, because i
tried to omit resetting irq_pending_on_cpu bit, and still lost some LPIs. Will try to compare with
v2, because with v2 i don't remember this problem.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


