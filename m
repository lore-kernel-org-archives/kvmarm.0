From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v5 2/2] KVM: Make KVM_CAP_IRQFD dependent on KVM_CAP_IRQCHIP
Date: Mon, 30 Nov 2015 14:56:38 +0300
Message-ID: <017101d12b66$2c8cf970$85a6ec50$@samsung.com>
References: <cover.1448874023.git.p.fedin@samsung.com>
 <57888eef1c5c21337ddad384250bc5f55829ac67.1448874023.git.p.fedin@samsung.com>
 <20151130122627.12ceb244.cornelia.huck@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20151130122627.12ceb244.cornelia.huck@de.ibm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Cornelia Huck' <cornelia.huck@de.ibm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>, 'Gleb Natapov' <gleb@kernel.org>, 'Paolo Bonzini' <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> >  	case KVM_CAP_INTERNAL_ERROR_DATA:
> >  #ifdef CONFIG_HAVE_KVM_MSI
> >  	case KVM_CAP_SIGNAL_MSI:
> > +		/* Fallthrough */
> >  #endif
> > +	case KVM_CAP_CHECK_EXTENSION_VM:
> > +		return 1;
> >  #ifdef CONFIG_HAVE_KVM_IRQFD
> >  	case KVM_CAP_IRQFD:
> >  	case KVM_CAP_IRQFD_RESAMPLE:
> > +		return kvm_vm_ioctl_check_extension(kvm, KVM_CAP_IRQCHIP);
> 
> This won't work for s390, as it doesn't have KVM_CAP_IRQCHIP but
> KVM_CAP_S390_IRQCHIP (which needs to be enabled).

 Thank you for the note, i didn't know about irqchip-specific capability codes. There's the same issue with PowerPC, now i
understand why there's no KVM_CAP_IRQCHIP for them. Because they have KVM_CAP_IRQ_MPIC and KVM_CAP_IRQ_XICS, similar to S390.
 But isn't it just weird? I understand that perhaps we have some real need to distinguish between different irqchip types, but
shouldn't the kernel also publish KVM_CAP_IRQCHIP, which stands just for "we support some irqchip virtualization"?
 May be we should just add this for PowerPC and S390, to make things less ambiguous?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

