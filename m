From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v7 3/8] KVM: arm/arm64: Don't cache the timer IRQ level
Date: Tue, 12 Dec 2017 21:40:07 +0100
Message-ID: <20171212204007.GP910@cbox>
References: <20171207105418.22428-1-christoffer.dall@linaro.org>
 <20171207105418.22428-4-christoffer.dall@linaro.org>
 <24ae6f9e-8f83-6b95-a7a0-d900c37b4a7f@redhat.com>
 <1604e8d6-5f9a-f91d-c199-57f323c09374@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4EC149D46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 15:36:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WbORDpo9BRdC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Dec 2017 15:36:43 -0500 (EST)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E05E840D25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 15:36:42 -0500 (EST)
Received: by mail-wm0-f42.google.com with SMTP id 9so1099809wme.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Dec 2017 12:40:12 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1604e8d6-5f9a-f91d-c199-57f323c09374@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 12, 2017 at 09:40:10AM +0100, Auger Eric wrote:
> 
> 
> On 11/12/17 21:51, Auger Eric wrote:
> > Hi Christoffer,
> > On 07/12/17 11:54, Christoffer Dall wrote:
> >> The timer was modeled after a strict idea of modelling an interrupt line
> >> level in software, meaning that only transitions in the level needed to
> >> be reported to the VGIC.  This works well for the timer, because the
> >> arch timer code is in complete control of the device and can track the
> >> transitions of the line.
> >>
> >> However, as we are about to support using the HW bit in the VGIC not
> >> just for the timer, but also for VFIO which cannot track transitions of
> >> the interrupt line, we have to decide on an interface for level
> >> triggered mapped interrupts to the GIC, which both the timer and VFIO
> >> can use.
> >>
> >> VFIO only sees an asserting transition of the physical interrupt line,
> >> and tells the VGIC when that happens.  That means that part of the
> >> interrupt flow is offloaded to the hardware.
> >>
> >> To use the same interface for VFIO devices and the timer, we therefore
> >> have to change the timer (we cannot change VFIO because it doesn't know
> >> the details of the device it is assigning to a VM).
> >>
> >> Luckily, changing the timer is simple, we just need to stop 'caching'
> >> the line level, but instead let the VGIC know the state of the timer
> >> every time there is a potential change in the line level, and when the
> >> line level should be asserted from the timer ISR.  The VGIC can ignore
> >> extra notifications using its validate mechanism.
> > 
> > I was confused by the fact we say we stop caching the line level but
> > vtimer->irq.level still exists, is updated in the vtimer host ISR and
> > kvm_timer_update_state() and read in many places.
> > 
> > I feel difficult to figure out if each time we use the vtimer->irq.level
> > value it is safe to use it.
> > 
> > Also for the validate() to succeed we need the vgic irq->line_level to
> > to be 0. I understand this is properly handled for mapped level irqs in
> > next patch which does that on the populate_lr. However I currently fail
> > to understand why the timer level sensitive mapped IRQ does not require
> > the next patch to work.
> OK reading again "[PATCH v7 7/8] KVM: arm/arm64: Provide a
> get_input_level for the arch timer", I now understand it works because
> we had the
> kvm_timer_sync_hwstate toggling down the line on VM exit. After the
> changes of next patch this can be safely removed.

Yes, but also note that this patch in isolation doesn't break anything,
it just ensures that we notify the GIC of an asserted line more often.

> 
> Not related to this patch but I noticed
> Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt now is outdated.

Good point, I have updated the docs and will include that in v8.

Thanks,
-Christoffer
