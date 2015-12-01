From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v5 2/2] KVM: Make KVM_CAP_IRQFD dependent on KVM_CAP_IRQCHIP
Date: Tue, 01 Dec 2015 14:07:58 +0300
Message-ID: <014901d12c28$89c18490$9d448db0$@samsung.com>
References: <cover.1448874023.git.p.fedin@samsung.com>
 <57888eef1c5c21337ddad384250bc5f55829ac67.1448874023.git.p.fedin@samsung.com>
 <20151130122627.12ceb244.cornelia.huck@de.ibm.com>
 <017101d12b66$2c8cf970$85a6ec50$@samsung.com>
 <20151130131331.78d98df5.cornelia.huck@de.ibm.com>
 <017801d12b6c$6a7c2c00$3f748400$@samsung.com>
 <20151130153807.1a2668e5.cornelia.huck@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20151130153807.1a2668e5.cornelia.huck@de.ibm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Cornelia Huck' <cornelia.huck@de.ibm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>, 'Gleb Natapov' <gleb@kernel.org>, 'Paolo Bonzini' <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> >  b) I simply drop it as it is, because current qemu knows about the dependency and does not
> try to use irqfd without irqchip,
> > because there's simply no use for them. But, well, perhaps there would be an exception in
> vhost, i don't remember testing it.
> 
> Wouldn't an irqfd emulation cover vhost?

 I've just tested, and no, it does not cause any problems with qemu. It happens to correctly detect that the whole thing is not
running and falls back to not using vhost. This is output from my qemu:
--- cut ---
2015-12-01T11:03:16.135724Z qemu-system-arm: Error binding guest notifier: 11
2015-12-01T11:03:16.135849Z qemu-system-arm: unable to start vhost net: 11: falling back on userspace virtio
--- cut ---

 So, the resume is: we just drop this patch and only N1 remains.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Cornelia Huck
> Sent: Monday, November 30, 2015 5:38 PM
> To: Pavel Fedin
> Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; 'Marc Zyngier'; 'Christoffer Dall';
> 'Gleb Natapov'; 'Paolo Bonzini'
> Subject: Re: [PATCH v5 2/2] KVM: Make KVM_CAP_IRQFD dependent on KVM_CAP_IRQCHIP
> 
> On Mon, 30 Nov 2015 15:41:20 +0300
> Pavel Fedin <p.fedin@samsung.com> wrote:
> 
> >  Hello!
> >
> > > >  Thank you for the note, i didn't know about irqchip-specific capability codes. There's
> the
> > > > same issue with PowerPC, now i
> > > > understand why there's no KVM_CAP_IRQCHIP for them. Because they have KVM_CAP_IRQ_MPIC
> and
> > > > KVM_CAP_IRQ_XICS, similar to S390.
> > > >  But isn't it just weird? I understand that perhaps we have some real need to
> distinguish
> > > > between different irqchip types, but
> > > > shouldn't the kernel also publish KVM_CAP_IRQCHIP, which stands just for "we support
> some
> > > > irqchip virtualization"?
> > > >  May be we should just add this for PowerPC and S390, to make things less ambiguous?
> > >
> > > Note that we explicitly need to _enable_ the s390 cap (for
> > > compatibility). I'd need to recall the exact details but I came to the
> > > conclusion back than that I could not simply enable KVM_CAP_IRQCHIP for
> > > s390 (and current qemu would fail to enable the s390 cap if we started
> > > advertising KVM_CAP_IRQCHIP now).
> >
> >  OMG... I've looked at the code, what a mess...
> >  If i was implementing this, i'd simply introduce kvm_vm_enable_cap(s, KVM_CAP_IRQCHIP, 0),
> > which would be allowed to fail with -ENOSYS, so that backwards compatibility is kept and an
> existing API is reused... But, well,
> > it's already impossible to unscramble an egg... :)
> >  Ok, i think in current situation we could choose one of these ways (both are based on the
> fact that it's obvious that irqfd require
> > IRQCHIP).
> >  a) I look for an alternate way to report KVM_CAP_IRQFD dynamically, and maybe PowerPC and
> S390 follow this way.
> 
> The thing is: _when_ can you report KVM_CAP_IRQFD? It obviously
> requires an irqchip; but if you need some configuration/enablement
> beforehand, you'll get different values depending on when you retrieve
> the cap. So does KVM_CAP_IRQFD mean "irqfds are available in principle"
> or "everything has been setup for usage of irqfds"? I'd assume the
> former.
> 
> >  b) I simply drop it as it is, because current qemu knows about the dependency and does not
> try to use irqfd without irqchip,
> > because there's simply no use for them. But, well, perhaps there would be an exception in
> vhost, i don't remember testing it.
> 
> Wouldn't an irqfd emulation cover vhost?
> 
> >  So what shall we do?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

