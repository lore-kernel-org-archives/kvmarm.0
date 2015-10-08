From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 3/7] KVM: arm/arm64: Fix the documentation
Date: Thu, 8 Oct 2015 10:24:25 +0200
Message-ID: <20151008082425.GF14315@cbox>
References: <cover.1443451687.git.p.fedin@samsung.com>
 <5b6b8e9e002bc6a9cc5e6a881032d6b930830e74.1443451687.git.p.fedin@samsung.com>
 <20151007200439.GC14315@cbox>
 <002f01d10195$d6961550$83c23ff0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AEA841338
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 04:22:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YndReESFWvfM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Oct 2015 04:22:14 -0400 (EDT)
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
 [209.85.217.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC0AE4130B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 04:22:13 -0400 (EDT)
Received: by lbcao8 with SMTP id ao8so38726996lbc.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Oct 2015 01:24:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <002f01d10195$d6961550$83c23ff0$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Andre Przywara' <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 08, 2015 at 09:52:02AM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > > --- a/Documentation/virtual/kvm/devices/arm-vgic.txt
> > > +++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
> > > @@ -44,28 +44,29 @@ Groups:
> > >    Attributes:
> > >      The attr field of kvm_device_attr encodes two values:
> > >      bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
> > > -    values:   |    reserved   |   cpu id   |      offset     |
> > > +    values:   |    reserved   |  cpu idx   |      offset     |
> > 
> > why should this be changed to cpu idx?
> 
>  Because it's index (from 0 to N - 1), and "cpu id" may confuse readers that it should be MPIDR
> affinity value. In register access function we do "vcpu = kvm_get_vcpu(dev->kvm, cpuid);" (see here:
> http://lxr.free-electrons.com/source/virt/kvm/arm/vgic-v2-emul.c#L664), and kvm_get_vcpu just
> indexes the array: http://lxr.free-electrons.com/source/include/linux/kvm_host.h#L427
>  I decided to change this after http://www.spinics.net/lists/kvm-arm/msg16359.html, Andre clearly
> mistook this ID for being affinity value.
>  Before GICv3 nobody saw the difference because we had only up to 16 CPUs, with IDs from 0 to 15, i.
> e. corresponding to indexes.
> 
ok, fair enough.  This kind of rationale is helpful to put in the commit
text though.

-Christoffer
