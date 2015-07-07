From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 1/7] KVM: api: add kvm_irq_routing_extended_msi
Date: Tue, 7 Jul 2015 11:02:37 +0100
Message-ID: <559BA3BD.60404@arm.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-2-git-send-email-eric.auger@linaro.org>
 <011f01d0b498$6a17aeb0$3e470c10$@samsung.com> <5596503E.6040902@arm.com>
 <00fd01d0b7b6$f6cf3550$e46d9ff0$@samsung.com> <559A3C9C.6050302@arm.com>
 <20150706093026.GA11590@cbox> <559A52E6.5050402@arm.com>
 <20150706103755.GC11590@cbox> <559A6164.1000401@redhat.com>
 <559A6527.1040107@arm.com> <559A6BBC.2040901@redhat.com>
 <024301d0b7f0$2b13b410$813b1c30$@samsung.com> <559AA0D6.7070703@arm.com>
 <014c01d0b884$deff46d0$9cfdd470$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92DE157DC0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 05:51:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 848KFyZjFJk8 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2015 05:51:11 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDDCE57DBD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 05:51:10 -0400 (EDT)
In-Reply-To: <014c01d0b884$deff46d0$9cfdd470$@samsung.com>
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

Good morning Pavel,

On 07/07/15 08:16, Pavel Fedin wrote:
>  Hello!
> 
>> Wouldn't:
>>     if (kvm_vm_check_extension(s, KVM_CAP_MSI_DEVID)) {
>>         kroute.flags = KVM_MSI_VALID_DEVID;
>>         kroute.u.msi.devid = (pci_bus_num(dev->bus) << 8) | dev->devfn;
>>     }
>>
>> be saner (without a global variable)?
> 
>  No it would not, because:
> a) kvm_vm_check_extension() calls ioctl every time, therefore it's slow. But, well, doesn't really
> matter because it's possible to check for the capability once in generic code, and cache it.

Indeed, as mentioned before I have it in a wrapper function with a
static variable.

> b) Capability is a global thing as far as i understand. The kernel either has it, or doesn't have.

There are two flavours of capabilities: global and per-VM ones,
depending on which fd you are issuing the ioctl. The per-VM ones are
just not very widely used yet (I only found PowerPC doing so).

> However, whether we want this flag or not, depends also on what GIC model we use. GICv2(m) doesn't
> want it, GICv3 does. qemu actually has two sets of flags: one set actually specifies capabilities,
> another set enables use of these capabilities.

That's why I do a per-VM capability check and I do it as late as
possible to let the GIC initialize first (hence the wrapper function).

>  But, well, you can make GICv2 kernel code simply ignoring it instead of bailing out if flags != 0.
> And add the capability for ARM64 architecture (ARM32 can't use GICv3, can it?). And this will work
> and it'll be OK. So, i'm not against it, and if you want it, you can do it. I just want to point
> that it is not strictly necessary to add new APIs, because existing ones are pretty much enough.

As said before I don't like the idea of inferring the validity of a flag
by some hard-coded dependencies like "GICv3 on ARM64". I guess ARM(32)
will get GICv3 support sooner or later (I think I saw patches to do so
already). So as soon as a kernel supports it, we automatically get the
support from userland without changing a single line there. Also what
tells you that no other architecture or IRQ controller will ever need a
device ID? I just don't want to end up with something like:
(GICV3 && ARM64) || (GICV3 && ARM && KERNEL>4.4) || (SuperIRQC && i986)
or
(ARM || ARM64) && HAS_IRQ_ROUTING

Instead: If the kernel needs it, it tells you. Full stop.

> But, you are the architects here, so you of course can do it if you want.
> It's just me being not a
> big fan of adding APIs without which it's completely possible to live.
> 
>  Below i'm answering to Eric's comment, because my reply is tightly coupled with this one.
> 
>> So not sure whether we eventually concluded;-)
>> - introduce a KVM_CAP_MSI_DEVID capability? All OK except Pavel not
>>  convinced?
> 
>  See above. I'm not against it, i just don't think it's necessary. You can do it if you want, it
> actually won't change things much.
> 
>> - userspaces puts the devid in struct kvm_irq_routing_msi pad field:
>> consensus (we do not intrduce a new kvm_irq_routing_ext_msi)
> 
>  Yes.
> 
>> - userspace tells it conveyed a devid by setting
>> A) the kvm_irq_routing_entry's field?
>> B) the kvm_irq_routing_entry's type
>> no consensus. If there is a cap, does it really matter?
> 
>  It has absolutely nothing to do with the cap. My argument here is the same as above again - why
> adding new API's / definitions? We already have KVM_MSI_VALID_DEVID and we already have 'flags'
> field. Using them would just make the API more consistent because KVM_SIGNAL_MSI already uses them
> in absolutely the same manner. That's my point and nothing more.

To be honest it's me to blame here to not having introduced the
capability earlier. At the moment ARM has a different code path for
KVM_SIGNAL_MSI, which does not bail out if the flag field is set. With
Eric's patches this changes and we use the irqchip.c generic code, which
returns -EINVAL atm. So I plan to introduce this capability already with
the ITS emulation series, so we can just pick it up in the IRQ routing
series.
So we now have already two users of this, if that makes more sense.

Cheers,
Andre.
