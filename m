From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v4 3/7] KVM: arm/arm64: Fix the documentation
Date: Thu, 08 Oct 2015 09:52:02 +0300
Message-ID: <002f01d10195$d6961550$83c23ff0$@samsung.com>
References: <cover.1443451687.git.p.fedin@samsung.com>
 <5b6b8e9e002bc6a9cc5e6a881032d6b930830e74.1443451687.git.p.fedin@samsung.com>
 <20151007200439.GC14315@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20151007200439.GC14315@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Peter Maydell' <peter.maydell@linaro.org>, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> > --- a/Documentation/virtual/kvm/devices/arm-vgic.txt
> > +++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
> > @@ -44,28 +44,29 @@ Groups:
> >    Attributes:
> >      The attr field of kvm_device_attr encodes two values:
> >      bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
> > -    values:   |    reserved   |   cpu id   |      offset     |
> > +    values:   |    reserved   |  cpu idx   |      offset     |
> 
> why should this be changed to cpu idx?

 Because it's index (from 0 to N - 1), and "cpu id" may confuse readers that it should be MPIDR
affinity value. In register access function we do "vcpu = kvm_get_vcpu(dev->kvm, cpuid);" (see here:
http://lxr.free-electrons.com/source/virt/kvm/arm/vgic-v2-emul.c#L664), and kvm_get_vcpu just
indexes the array: http://lxr.free-electrons.com/source/include/linux/kvm_host.h#L427
 I decided to change this after http://www.spinics.net/lists/kvm-arm/msg16359.html, Andre clearly
mistook this ID for being affinity value.
 Before GICv3 nobody saw the difference because we had only up to 16 CPUs, with IDs from 0 to 15, i.
e. corresponding to indexes.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


