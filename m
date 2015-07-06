From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Mon, 6 Jul 2015 16:37:58 +0100
Message-ID: <559AA0D6.7070703@arm.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com> <5596503E.6040902@arm.com>
 <00fd01d0b7b6$f6cf3550$e46d9ff0$@samsung.com> <559A3C9C.6050302@arm.com>
 <20150706093026.GA11590@cbox> <559A52E6.5050402@arm.com>
 <20150706103755.GC11590@cbox> <559A6164.1000401@redhat.com>
 <559A6527.1040107@arm.com> <559A6BBC.2040901@redhat.com>
 <024301d0b7f0$2b13b410$813b1c30$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4C6A57C98
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 11:26:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TWDgL0dEPbEe for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 11:26:30 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5042657C73
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 11:26:29 -0400 (EDT)
In-Reply-To: <024301d0b7f0$2b13b410$813b1c30$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, 'Paolo Bonzini' <pbonzini@redhat.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: "eric.auger@st.com" <eric.auger@st.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

On 06/07/15 14:32, Pavel Fedin wrote:
>  Hi!
> 
>>> Well, as we are about to implement this: yes. But the issue is that MSI
>>> injection and GSI routing code is generic PCI code in userland (at least
>>> in kvmtool, guess in QEMU, too), so I don't want to pull in any kind of
>>> ARM specific code in there. The idea is to always provide the device ID
>>> from the PCI code (for PCI devices it's just the B/D/F triplet), but
>>> only send it to the kernel if needed. Querying a KVM capability is
>>> perfectly fine for this IMO.
>>
>> Yes, I agree.
> 
>  Actually, we already have this capability, it's KVM_CAP_IRQ_ROUTING. If we have this capability,
> and want to use irqfds with GICv3, we need to set KVM_MSI_VALID_DEVID.

This is the connection that I don't like: We make the decision to
support a flag on a generic KVM interface dependent on some particular
device emulation (for some very specific architecture, also).

> And there is no other way to
> use irqfds with GICv3.

For now: yes, but I fail to see why the GICv3 is so special that is
justifies an extra handling in the KVM interrupt routing code. If it is
special, lets name it explicitly why: we need a device ID.

>  Just for example, this is what i have done in qemu:
> --- cut ---
> int kvm_irqchip_add_msi_route(KVMState *s, MSIMessage msg, PCIDevice *dev)
> {
>     struct kvm_irq_routing_entry kroute = {};
>     int virq;
> 
>     if (kvm_gsi_direct_mapping()) {
>         return kvm_arch_msi_data_to_gsi(msg.data);
>     }
> 
>     if (!kvm_gsi_routing_enabled()) {
>         return -ENOSYS;
>     }
> 
>     virq = kvm_irqchip_get_virq(s);
>     if (virq < 0) {
>         return virq;
>     }
> 
>     kroute.gsi = virq;
>     kroute.type = KVM_IRQ_ROUTING_MSI;
>     kroute.u.msi.address_lo = (uint32_t)msg.address;
>     kroute.u.msi.address_hi = msg.address >> 32;
>     kroute.u.msi.data = le32_to_cpu(msg.data);
>     kroute.flags = kvm_msi_flags;
>     if (kroute.flags & KVM_MSI_VALID_DEVID) {
>         kroute.u.msi.devid = (pci_bus_num(dev->bus) << 8) | dev->devfn;
>     }

Wouldn't:
    if (kvm_vm_check_extension(s, KVM_CAP_MSI_DEVID)) {
        kroute.flags = KVM_MSI_VALID_DEVID;
        kroute.u.msi.devid = (pci_bus_num(dev->bus) << 8) | dev->devfn;
    }

be saner (without a global variable)?
That would make the interface more consistent, with a new flag being
protected by a new capability.

Cheers,
Andre.

>     if (kvm_arch_fixup_msi_route(&kroute, msg.address, msg.data)) {
>         kvm_irqchip_release_virq(s, virq);
>         return -EINVAL;
>     }
> 
>     kvm_add_routing_entry(s, &kroute);
>     kvm_irqchip_commit_routes(s);
> 
>     return virq;
> }
