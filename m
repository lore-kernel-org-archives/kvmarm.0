From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 0/7] KVM: arm/arm64: gsi routing support
Date: Thu, 09 Jul 2015 18:52:30 +0300
Message-ID: <026801d0ba5f$43a79520$caf6bf60$@samsung.com>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
 <023601d0ba54$c4d6e020$4e84a060$@samsung.com> <559E927E.8040403@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85EE658466
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 11:41:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bSBNESl-PPIJ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 11:40:58 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 975CE58464
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 11:40:58 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NR800HGC9FJ6A90@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 09 Jul 2015 16:52:31 +0100 (BST)
In-reply-to: <559E927E.8040403@arm.com>
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
To: 'Andre Przywara' <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: eric.auger@st.com, kvm@vger.kernel.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

 Hi!

> > 3. KVM_SET_GSI_ROUTING - we use KVM_IRQ_ROUTING_EXTENDED_MSI plus devid
> 
> Here we already have a type field with some users, so lets piggy-back on
> this.

 We already have 'flags' there too.

> Both ioctl extensions are coupled with a per-VM capability to let
> userland know that it needs to provide a device ID.

> Using flags on its own (without an explicit capability) is what I
> opposed against, not flags in general.

 Ok, and in your next respin you'll add the capability, correct? So that we will finally have all
pieces in place.

> In case of KVM_SET_GSI_ROUTING it just seems awkward
> to me to use a flag when a different type would do as well.

 Well, MSI vs "Extended MSI" are even not different types really. It's just MSI which has devid. And
we *ALREADY* have VALID_DEVID flag.

> But after all, I don't have a strong opinion on that matter, so if
> others prefer using a flag I am also fine with that.

 So, ok, to be short... My vote is for flag, because it's already there and it keeps up with the
style we already have. Eric, this is my final statement about it. It's up to you to accept or
ignore. In qemu code flag is a little bit nicer because it's just stored in a variable and helps to
avoid several if-else's (however small ones). Compare:
--- cut ---
    kroute.gsi = virq;
    kroute.type = KVM_IRQ_ROUTING_MSI;
    kroute.u.msi.address_lo = (uint32_t)msg.address;
    kroute.u.msi.address_hi = msg.address >> 32;
    kroute.u.msi.data = le32_to_cpu(msg.data);
    kroute.flags = kvm_msi_flags;
    if (kroute.flags & KVM_MSI_VALID_DEVID) {
        kroute.u.msi.devid = (pci_bus_num(dev->bus) << 8) | dev->devfn;
    }
--- cut ---
and:
--- cut ---
    kroute.gsi = virq;
    if (use_extended_msi) {
        kroute.u.msi.devid = (pci_bus_num(dev->bus) << 8) | dev->devfn;
        kroute.type = KVM_IRQ_ROUTING_EXTENDED_MSI;
    } else {
        kroute.type = KVM_IRQ_ROUTING_MSI;
    }
    kroute.u.msi.address_lo = (uint32_t)msg.address;
    kroute.u.msi.address_hi = msg.address >> 32;
    kroute.u.msi.data = le32_to_cpu(msg.data);
    kroute.flags = kvm_msi_flags;
--- cut ---

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
