From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Mon, 06 Jul 2015 16:32:12 +0300
Message-ID: <024301d0b7f0$2b13b410$813b1c30$@samsung.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com> <5596503E.6040902@arm.com>
 <00fd01d0b7b6$f6cf3550$e46d9ff0$@samsung.com> <559A3C9C.6050302@arm.com>
 <20150706093026.GA11590@cbox> <559A52E6.5050402@arm.com>
 <20150706103755.GC11590@cbox> <559A6164.1000401@redhat.com>
 <559A6527.1040107@arm.com> <559A6BBC.2040901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <559A6BBC.2040901@redhat.com>
Content-language: ru
Sender: linux-kernel-owner@vger.kernel.org
To: 'Paolo Bonzini' <pbonzini@redhat.com>, 'Andre Przywara' <andre.przywara@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: 'Eric Auger' <eric.auger@linaro.org>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, 'Marc Zyngier' <Marc.Zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hi!

> > Well, as we are about to implement this: yes. But the issue is that MSI
> > injection and GSI routing code is generic PCI code in userland (at least
> > in kvmtool, guess in QEMU, too), so I don't want to pull in any kind of
> > ARM specific code in there. The idea is to always provide the device ID
> > from the PCI code (for PCI devices it's just the B/D/F triplet), but
> > only send it to the kernel if needed. Querying a KVM capability is
> > perfectly fine for this IMO.
> 
> Yes, I agree.

 Actually, we already have this capability, it's KVM_CAP_IRQ_ROUTING. If we have this capability,
and want to use irqfds with GICv3, we need to set KVM_MSI_VALID_DEVID. And there is no other way to
use irqfds with GICv3.
 Just for example, this is what i have done in qemu:
--- cut ---
int kvm_irqchip_add_msi_route(KVMState *s, MSIMessage msg, PCIDevice *dev)
{
    struct kvm_irq_routing_entry kroute = {};
    int virq;

    if (kvm_gsi_direct_mapping()) {
        return kvm_arch_msi_data_to_gsi(msg.data);
    }

    if (!kvm_gsi_routing_enabled()) {
        return -ENOSYS;
    }

    virq = kvm_irqchip_get_virq(s);
    if (virq < 0) {
        return virq;
    }

    kroute.gsi = virq;
    kroute.type = KVM_IRQ_ROUTING_MSI;
    kroute.u.msi.address_lo = (uint32_t)msg.address;
    kroute.u.msi.address_hi = msg.address >> 32;
    kroute.u.msi.data = le32_to_cpu(msg.data);
    kroute.flags = kvm_msi_flags;
    if (kroute.flags & KVM_MSI_VALID_DEVID) {
        kroute.u.msi.devid = (pci_bus_num(dev->bus) << 8) | dev->devfn;
    }

    if (kvm_arch_fixup_msi_route(&kroute, msg.address, msg.data)) {
        kvm_irqchip_release_virq(s, virq);
        return -EINVAL;
    }

    kvm_add_routing_entry(s, &kroute);
    kvm_irqchip_commit_routes(s);

    return virq;
}
--- cut ---

 ITS code in qemu just does:

---cut ---
    msi_supported = true;
    kvm_msi_flags = KVM_MSI_VALID_DEVID;
    kvm_msi_via_irqfd_allowed = kvm_has_gsi_routing();
    kvm_gsi_routing_allowed = kvm_msi_via_irqfd_allowed;
--- cut ---

 I set KVM_MSI_VALID_DEVID unconditionally here just because it will never be checked if
kvm_msi_via_irqfd_allowed is false, it's just qemu specifics. The more canonical form would perhaps
be:
--- cut ---
if (kvm_has_gsi_routing()) {
    kvm_msi_flags = KVM_MSI_VALID_DEVID;
    kvm_gsi_routing_allowed = true;
    kvm_msi_via_irqfd_allowed = true;
}
--- cut ---

 I can post my sets as RFCs to qemu mailing list, if you want to take a look at the whole change
set.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
