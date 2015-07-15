From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 4/7] KVM: arm/arm64: enable irqchip routing
Date: Wed, 15 Jul 2015 10:29:35 +0300
Message-ID: <00c801d0bed0$00db9550$0292bff0$@samsung.com>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
 <1436430137-24205-5-git-send-email-eric.auger@linaro.org>
 <55A05228.4030203@arm.com> <55A38BD4.50401@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55A38BD4.50401@linaro.org>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Eric Auger' <eric.auger@linaro.org>, 'Andre Przywara' <andre.przywara@arm.com>, eric.auger@st.com
Cc: linux-arm-kernel@lists.infradead.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> >> +	struct kvm_msi msi;
> >> +
> >> +	msi.address_lo = e->msi.address_lo;
> >> +	msi.address_hi = e->msi.address_hi;
> >> +	msi.data = e->msi.data;
> >> +	if (e->type == KVM_IRQ_ROUTING_EXTENDED_MSI) {
> >> +		msi.devid = e->devid;
> >> +		msi.flags = KVM_MSI_VALID_DEVID;
> >> +	}
> >
> > Can't we make the assignment unconditional?
> > The GICv2m MSI code does not care about the devid and the ITS code
> > requires it.
> > This simplifies quite something in the following patches.
> > (This refers to the idea of not using the extended type in the kernel).
> 
> How are we going to make sure the userspace provided a valid devid then?
> - we have this info at user struct level: kvm_irq_routing_msi
> - we wouldn't propagate the info at kernel struct level:
> kvm_kernel_irq_routing_entry
> - the only place where we could check the devid availability against the
> need is at kvm_set_routing_entry I think (routing adaptation on ARM).
> 
> What is going to happen if devid == 0 since unset?

> > +	if (msi->flags & KVM_MSI_VALID_DEVID) {
> > +		route.devid = msi->devid;
> > +		route.type = KVM_IRQ_ROUTING_EXTENDED_MSI;
> > +	} else if (!msi->flags)
> > +		return -EINVAL;
> 
> I think we get away without using the extended type on the kernel side.
> Within the kernel we don't have an ABI that we have to stick to forever,
> so we can simplify things by re-using the existing type (no need to
> check for both MSI types later).
> So we always set the device ID, the only code that looks at it later is
> the ITS emulation anyway, any other code path simply ignores that.

 Sorry for delayed reply, i'm a bit busy so cannot check all the emails in time...
 This is one more reason for using KVM_MSI_VALID_DEVID flag with KVM_IRQ_ROUTING_MSI. In this case
you don't have to bother about those conditions and just copy devid + flags pair between route and
MSI structures.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


