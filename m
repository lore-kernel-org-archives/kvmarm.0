From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 9/9] KVM: arm/arm64: Update timer and forwarded irq
 documentation
Date: Tue, 19 Dec 2017 20:35:04 +0000
Message-ID: <20171219203504.1dbb9226@why.wild-wind.fr.eu.org>
References: <20171213104602.16383-1-christoffer.dall@linaro.org>
        <20171213104602.16383-10-christoffer.dall@linaro.org>
        <86efnywfjl.wl-marc.zyngier@arm.com>
        <20171219202954.GC5380@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171219202954.GC5380@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 19 Dec 2017 21:29:54 +0100
Christoffer Dall <christoffer.dall@linaro.org> wrote:

> On Wed, Dec 13, 2017 at 08:15:10PM +0000, Marc Zyngier wrote:
> > On Wed, 13 Dec 2017 10:46:02 +0000,
> > Christoffer Dall wrote:  
> > > 
> > > Now when we've reworked how mapped level-triggered interrupts are
> > > processed for the timer interrupts, we update the documentation
> > > correspondingly.  
> > 
> > Seems like the documentation is more out of date than we thought, see
> > below.
> >   
> 
> Indeed.  And I wondered if we should just nuke this file.  The reason I
> added it originally was that the concept of "never taking the interrupt"
> was confusing to most, and we had to explain it several times over, but
> perhaps it's really not needed anymore and we should let people read the
> code instead?

Suits me (maintaining documentation is hard). I suggest we delete it
and write the perfect explanation once KVM is completely done...

	M.
-- 
Without deviation from the norm, progress is not possible.
