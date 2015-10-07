From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Wed, 07 Oct 2015 19:05:38 +0300
Message-ID: <029601d1011a$026e1000$074a3000$@samsung.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Andre Przywara' <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: eric.auger@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

 One more concern about the whole thing. I already replied to the previous series, but looks like my
reply was missed.
 Your implementation does not care about live migration at all. And there's one fundamental issue
with it. In the redistributor LPIs can be only pending, but in the CPU interface they still can be
active. And they have priorities, therefore they can be preempted, so we can have even more than one
active LPI at once. How to migrate this state?
 Here i am trying to prototype this by leaving active interrupts in LRs and allowing the userland to
read/write them. This looks a bit stupid, additionally this will create problems if we are e. g.
migrating from host with 8 LRs to host with 4 LRs, while having 6 active LPIs. Can anybody suggest
better solution?
 Technically LPI pending table has unused bits from 0 to 8191, and we have 8192 LPIs, so we could
push active state there, just for migration. Would this be a big violation of specification? It says
nothing about these bits at all.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


