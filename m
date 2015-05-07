From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC v2 0/4] chip/vgic adaptations for forwarded irq
Date: Thu, 7 May 2015 11:17:48 +0200
Message-ID: <20150507091748.GA25885@cbox>
References: <1423642857-24240-1-git-send-email-eric.auger@linaro.org>
 <20150506142748.GC6796@cbox>
 <554A3425.7070909@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <554A3425.7070909@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com, andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, patches@linaro.org, a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com, b.reynal@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 06, 2015 at 05:32:53PM +0200, Eric Auger wrote:
> On 05/06/2015 04:27 PM, Christoffer Dall wrote:
> > Hi Eric,
> > 
> > On Wed, Feb 11, 2015 at 09:20:53AM +0100, Eric Auger wrote:
> >> This series proposes some fixes that appeared to be necessary
> >> to integrate IRQ forwarding in KVM/VFIO.
> >>
> >> - deactivation of the forwarded IRQ in irq_disabled case
> >> - a specific handling of forwarded IRQ into the VGIC state machine.
> >> - deactivation of physical IRQ and unforwarding on vgic destruction
> >> - rb_tree lock in vgic.c
> >>
> >> Integrated pieces can be found at
> >> ssh://git.linaro.org/people/eric.auger/linux.git
> >> on branch irqfd_integ_v9
> >>
> > What are the dependencies for this at this point?
> > 
> > I assume it relies at least on the split EOI/priority drop changes?
> 
> Yes it now only depends on split EOI/priority drop changes since
> "genirq: Saving/restoring the irqchip state of an irq line" now is
> upstreamed.
> 
> > 
> > Are you going to respin this when there are newer versions of the
> > dependencies out, or what are the plans?
> 
> Yes I will respin according to new versions. I am currently using a
> rebased version of Marc's original RFC "ARM: Forwarding physical
> interrupts to a guest VM" (http://lwn.net/Articles/603514/) which is a
> superset of [PATCH] genirq: Add support for priority-drop/deactivate
> interrupt controllers.
> 

ok, once there's movement on the dependency and you respin, I'll review
the rest of this in detail.

-Christoffer
