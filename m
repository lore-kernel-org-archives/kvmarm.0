From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Tue, 07 Jul 2015 10:16:39 +0300
Message-ID: <014c01d0b884$deff46d0$9cfdd470$@samsung.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com> <5596503E.6040902@arm.com>
 <00fd01d0b7b6$f6cf3550$e46d9ff0$@samsung.com> <559A3C9C.6050302@arm.com>
 <20150706093026.GA11590@cbox> <559A52E6.5050402@arm.com>
 <20150706103755.GC11590@cbox> <559A6164.1000401@redhat.com>
 <559A6527.1040107@arm.com> <559A6BBC.2040901@redhat.com>
 <024301d0b7f0$2b13b410$813b1c30$@samsung.com> <559AA0D6.7070703@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE7C357D65
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 03:05:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TqUtorxA5gnC for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2015 03:05:14 -0400 (EDT)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF48A57D62
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 03:05:14 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NR300D37W7TS230@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 07 Jul 2015 08:16:41 +0100 (BST)
In-reply-to: <559AA0D6.7070703@arm.com>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Andre Przywara' <andre.przywara@arm.com>, 'Paolo Bonzini' <pbonzini@redhat.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: eric.auger@st.com, kvm@vger.kernel.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Wouldn't:
>     if (kvm_vm_check_extension(s, KVM_CAP_MSI_DEVID)) {
>         kroute.flags = KVM_MSI_VALID_DEVID;
>         kroute.u.msi.devid = (pci_bus_num(dev->bus) << 8) | dev->devfn;
>     }
> 
> be saner (without a global variable)?

 No it would not, because:
a) kvm_vm_check_extension() calls ioctl every time, therefore it's slow. But, well, doesn't really
matter because it's possible to check for the capability once in generic code, and cache it.
b) Capability is a global thing as far as i understand. The kernel either has it, or doesn't have.
However, whether we want this flag or not, depends also on what GIC model we use. GICv2(m) doesn't
want it, GICv3 does. qemu actually has two sets of flags: one set actually specifies capabilities,
another set enables use of these capabilities.
 But, well, you can make GICv2 kernel code simply ignoring it instead of bailing out if flags != 0.
And add the capability for ARM64 architecture (ARM32 can't use GICv3, can it?). And this will work
and it'll be OK. So, i'm not against it, and if you want it, you can do it. I just want to point
that it is not strictly necessary to add new APIs, because existing ones are pretty much enough.
But, you are the architects here, so you of course can do it if you want. It's just me being not a
big fan of adding APIs without which it's completely possible to live.

 Below i'm answering to Eric's comment, because my reply is tightly coupled with this one.

> So not sure whether we eventually concluded;-)
> - introduce a KVM_CAP_MSI_DEVID capability? All OK except Pavel not
>  convinced?

 See above. I'm not against it, i just don't think it's necessary. You can do it if you want, it
actually won't change things much.

> - userspaces puts the devid in struct kvm_irq_routing_msi pad field:
> consensus (we do not intrduce a new kvm_irq_routing_ext_msi)

 Yes.

> - userspace tells it conveyed a devid by setting
> A) the kvm_irq_routing_entry's field?
> B) the kvm_irq_routing_entry's type
> no consensus. If there is a cap, does it really matter?

 It has absolutely nothing to do with the cap. My argument here is the same as above again - why
adding new API's / definitions? We already have KVM_MSI_VALID_DEVID and we already have 'flags'
field. Using them would just make the API more consistent because KVM_SIGNAL_MSI already uses them
in absolutely the same manner. That's my point and nothing more.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
