From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 02/26] KVM: arm/arm64: vgic: restructure kvm_vgic_(un)map_phys_irq
Date: Thu, 26 Oct 2017 14:05:12 +0100
Message-ID: <86lgjyawl3.fsf@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
        <20171006153401.5481-3-marc.zyngier@arm.com>
        <20171025144443.GH91785@lvm>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171025144443.GH91785@lvm> (Christoffer Dall's message of "Wed,
        25 Oct 2017 16:44:43 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 25 2017 at  4:44:43 pm BST, Christoffer Dall <cdall@linaro.org> wrote:
> On Fri, Oct 06, 2017 at 04:33:37PM +0100, Marc Zyngier wrote:
>> From: Eric Auger <eric.auger@redhat.com>
>> 
>> We want to reuse the core of the map/unmap functions for IRQ
>> forwarding. Let's move the computation of the hwirq in
>> kvm_vgic_map_phys_irq and pass the linux IRQ as parameter.
>> the host_irq is added to struct vgic_irq.
>> 
>> We introduce kvm_vgic_map/unmap_irq which take a struct vgic_irq
>> handle as a parameter.
>> 
>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>
> Marc,
>   I need a signed-off-by from you on this patch.

Ah, my bad. I'll fix that for the next round (real soon now...)

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
