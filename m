From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 7/7] KVM: arm: implement kvm_set_msi by gsi direct
 mapping
Date: Sun, 2 Aug 2015 21:23:14 +0100
Message-ID: <55BE7C32.8070707@arm.com>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
 <1436430137-24205-8-git-send-email-eric.auger@linaro.org>
 <55A05282.6020105@arm.com> <55BB714A.8030307@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F45659D39
 for <kvmarm@lists.cs.columbia.edu>; Sun,  2 Aug 2015 16:14:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d7bmFDkNl0Or for <kvmarm@lists.cs.columbia.edu>;
 Sun,  2 Aug 2015 16:14:30 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6896459D29
 for <kvmarm@lists.cs.columbia.edu>; Sun,  2 Aug 2015 16:14:30 -0400 (EDT)
In-Reply-To: <55BB714A.8030307@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 31/07/15 13:59, Eric Auger wrote:
> Hi Andre,
> On 07/11/2015 01:17 AM, Andre Przywara wrote:
>> On 09/07/15 09:22, Eric Auger wrote:
>>> If the ITS modality is not available, let's simply support MSI
>>> injection by transforming the MSI.data into an SPI ID.
>>>
>>> This becomes possible to use KVM_SIGNAL_MSI ioctl for arm too.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>>
>>> ---
>>>
>>> v1 -> v2:
>>> - introduce vgic_v2m_inject_msi in vgic-v2-emul.c following Andre's
>>>   advice
>>> ---
>>>  arch/arm/kvm/Kconfig        |  1 +
>>>  virt/kvm/arm/vgic-v2-emul.c | 12 ++++++++++++
>>>  2 files changed, 13 insertions(+)
>>>
>>> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
>>> index 151e710..0f58baf 100644
>>> --- a/arch/arm/kvm/Kconfig
>>> +++ b/arch/arm/kvm/Kconfig
>>> @@ -31,6 +31,7 @@ config KVM
>>>  	select KVM_VFIO
>>>  	select HAVE_KVM_EVENTFD
>>>  	select HAVE_KVM_IRQFD
>>> +	select HAVE_KVM_MSI
>>
>> I wonder if this requires some more code to only advertise
>> KVM_CAP_SIGNAL_MSI if userland actually sets up a GICv2M?
>> Otherwise userland could get the idea of being able to inectj MSIs
>> without the guest actually being prepared for that (because the GICv2M
>> driver did not initialize).
> Not sure I get what you mean here. By directly transforming the user
> provided MSI msg into an SPI ID, do we really have to care about GICv2M?

By user provided message you mean from user space? So this is an
emulated device, which the guest programs with an MSI payload and a
doorbell address at least? So how would a guest know these things
without having a MSI capable interrupt controller?

Or are we talking about different things here?

Cheers,
Andre.

> 
> Best Regards
> 
> Eric
>>
>> Cheers,
>> Andre.
>>
>>>  	select HAVE_KVM_IRQCHIP
>>>  	select HAVE_KVM_IRQ_ROUTING
>>>  	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
>>> diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
>>> index 1390797..43013cc 100644
>>> --- a/virt/kvm/arm/vgic-v2-emul.c
>>> +++ b/virt/kvm/arm/vgic-v2-emul.c
>>> @@ -478,6 +478,17 @@ static bool vgic_v2_queue_sgi(struct kvm_vcpu *vcpu, int irq)
>>>  }
>>>  
>>>  /**
>>> + * Emulates GICv2M MSI injection by injecting the SPI ID matching
>>> + * the msi data
>>> + * @kvm: pointer to the kvm struct
>>> + * @msi: the msi struct handle
>>> + */
>>> +static int vgic_v2m_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
>>> +{
>>> +	return kvm_vgic_inject_irq(kvm, 0, msi->data, 1);
>>> +}
>>> +
>>> +/**
>>>   * kvm_vgic_map_resources - Configure global VGIC state before running any VCPUs
>>>   * @kvm: pointer to the kvm struct
>>>   *
>>> @@ -566,6 +577,7 @@ void vgic_v2_init_emulation(struct kvm *kvm)
>>>  	dist->vm_ops.add_sgi_source = vgic_v2_add_sgi_source;
>>>  	dist->vm_ops.init_model = vgic_v2_init_model;
>>>  	dist->vm_ops.map_resources = vgic_v2_map_resources;
>>> +	dist->vm_ops.inject_msi = vgic_v2m_inject_msi;
>>>  
>>>  	kvm->arch.max_vcpus = VGIC_V2_MAX_CPUS;
>>>  }
>>>
>>
> 
