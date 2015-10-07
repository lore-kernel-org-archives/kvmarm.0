From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 12/16] KVM: arm64: handle pending bit for LPIs in ITS
 emulation
Date: Wed, 07 Oct 2015 18:10:28 +0300
Message-ID: <026901d10112$4dea39d0$e9bead70$@samsung.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <1444229726-31559-13-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1444229726-31559-13-git-send-email-andre.przywara@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Andre Przywara' <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: eric.auger@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> As the actual LPI number in a guest can be quite high, but is mostly
> assigned using a very sparse allocation scheme, bitmaps and arrays
> for storing the virtual interrupt status are a waste of memory.
> We use our equivalent of the "Interrupt Translation Table Entry"
> (ITTE) to hold this extra status information for a virtual LPI.

 You know, not that i'm strongly against current approach and want you to redo everything once
again, but... Is it architecturally correct to intertwine LPIs and ITS so much? As far as i
understand arch manual, it is possible to have LPIs without ITS (triggered by something else?).
Shouldn't we do the same, and just add LPI support to our redistributors, and then proceed with the
ITS?
 As to memory consumption, do we really need to store own copy of tables? After all, it's just a
memory. What if we map a pointer directly into guest's memory (which it writes to
PROPBASER/PENDBASER), and just keep it? There will be no issues with caching and synchronization at
all.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


