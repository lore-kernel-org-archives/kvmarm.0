From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC v2 0/4] chip/vgic adaptations for forwarded irq
Date: Wed, 6 May 2015 16:27:48 +0200
Message-ID: <20150506142748.GC6796@cbox>
References: <1423642857-24240-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1423642857-24240-1-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com, andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, patches@linaro.org, a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com, b.reynal@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On Wed, Feb 11, 2015 at 09:20:53AM +0100, Eric Auger wrote:
> This series proposes some fixes that appeared to be necessary
> to integrate IRQ forwarding in KVM/VFIO.
> 
> - deactivation of the forwarded IRQ in irq_disabled case
> - a specific handling of forwarded IRQ into the VGIC state machine.
> - deactivation of physical IRQ and unforwarding on vgic destruction
> - rb_tree lock in vgic.c
> 
> Integrated pieces can be found at
> ssh://git.linaro.org/people/eric.auger/linux.git
> on branch irqfd_integ_v9
> 
What are the dependencies for this at this point?

I assume it relies at least on the split EOI/priority drop changes?

Are you going to respin this when there are newer versions of the
dependencies out, or what are the plans?

Thanks,
-Christoffer
