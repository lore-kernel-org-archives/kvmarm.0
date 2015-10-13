From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: Optimize away redundant LR tracking
Date: Tue, 13 Oct 2015 17:41:22 +0200
Message-ID: <20151013154122.GD21861@cbox>
References: <cover.1443796321.git.p.fedin@samsung.com>
 <34d659eff6cda85488561ccd2382b82377b44784.1443796321.git.p.fedin@samsung.com>
 <561BE62E.5050103@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <561BE62E.5050103@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 12, 2015 at 05:56:14PM +0100, Andre Przywara wrote:
> Hi,
> 
> On 02/10/15 15:44, Pavel Fedin wrote:
> > Currently we use vgic_irq_lr_map in order to track which LRs hold which
> > IRQs, and lr_used bitmap in order to track which LRs are used or free.
> > 
> > vgic_irq_lr_map is actually used only for piggy-back optimization, and
> > can be easily replaced by iteration over lr_used. This is good because in
> > future, when LPI support is introduced, number of IRQs will grow up to at
> > least 16384, while numbers from 1024 to 8192 are never going to be used.
> > This would be a huge memory waste.
> > 
> > In its turn, lr_used is also completely redundant since
> > ae705930fca6322600690df9dc1c7d0516145a93 ("arm/arm64: KVM: Keep elrsr/aisr
> > in sync with software model"), because together with lr_used we also update
> > elrsr. This allows to easily replace lr_used with elrsr, inverting all
> > conditions (because in elrsr '1' means 'free').
> 
> So this looks pretty good to me, probably a better (because less
> intrusive) solution than my first two patches of the ITS emulation,
> which have a very similar scope.
> I will give this some testing on my boxes here to spot any regressions,
> but I guess I will use these two patches as the base for my next version
> of the ITS emulation series.
> 
> Christoffer, Marc, do you consider these for 4.4 (since they are an
> independent cleanup) or do you want them to be part of the ITS emulation
> series since they make more sense in there?
> 
I'll try to have a look at these tomorrow and I'll think about how to
merge this after I've looked at them.

Did you review these to the point where you can give your r-b tag here?

Thanks,
-Christoffer
