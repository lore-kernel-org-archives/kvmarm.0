From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v5 2/2] KVM: Make KVM_CAP_IRQFD dependent on KVM_CAP_IRQCHIP
Date: Mon, 30 Nov 2015 17:45:18 +0300
Message-ID: <019e01d12b7d$bc084520$3418cf60$@samsung.com>
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

 Of course it would. At least it should, but perhaps will need some minor tweaks.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


