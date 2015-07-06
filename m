From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Mon, 6 Jul 2015 11:30:26 +0200
Message-ID: <20150706093026.GA11590@cbox>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com>
 <5596503E.6040902@arm.com>
 <00fd01d0b7b6$f6cf3550$e46d9ff0$@samsung.com>
 <559A3C9C.6050302@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A844F57B61
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 05:19:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QLPQwpnk-lLF for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 05:18:59 -0400 (EDT)
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A7CC5760D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 05:18:59 -0400 (EDT)
Received: by lazt12 with SMTP id t12so2098251laz.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2015 02:30:25 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <559A3C9C.6050302@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: "eric.auger@st.com" <eric.auger@st.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 06, 2015 at 09:30:20AM +0100, Andre Przywara wrote:
> Hi Pavel,
> 
> On 06/07/15 07:42, Pavel Fedin wrote:
> >  Hello!
> > 
> >> I like this approach, but it runs into problems:
> >> As you read above the current documentation says that the flags field
> >> must be zero and the current KVM_SET_GSI_ROUTING handler bails out if it
> >> isn't. So userland would need to know whether it's safe to set that
> >> field.
> > 
> >  This problem does not exist because:
> > a) Older platforms do not need this flag, so they expect to get zero.
> > b) ARM64 + GICv3 platform cannot work without this flag.
> > 
> >  This is perfectly OK combination IMO. Userland just knows, whether it needs to supply device ID or
> > not. For example, my modified qemu now has kvm_msi_flags global variable which defaults to 0. ITS
> > code, then, if activated, changes it to KVM_MSI_VALID_DEVID, and qemu starts supplying device IDs to
> > the related calls.
> 
> Well, I had this solution before in kvmtool: If ARM && ITS then set the
> flag. But I wasn't really happy with this, as the IRQ routing, setup and
> injection code is rather architecture agnostic (implementing the generic
> KVM interface), so spraying in some architecture hacks sounded not very
> elegant.
> Also as the flag describes a rather generic feature (provide an unique
> device ID), I'd rather avoid to make this an ARM hack.
> 
> That being said this is not a show stopper for me, so if the others are
> happy with this, I will go down your road.
> 
There must be some way for userspace to discover if it's valid to set
the flag or not; either through a well-defined error-code probing
mechanism for KVM_SET_GSI_ROUTING or through advertising a capability.

-Christoffer
