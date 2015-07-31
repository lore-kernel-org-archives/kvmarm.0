From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 7/7] KVM: arm: implement kvm_set_msi by gsi direct
 mapping
Date: Fri, 31 Jul 2015 14:59:54 +0200
Message-ID: <55BB714A.8030307@linaro.org>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org> <1436430137-24205-8-git-send-email-eric.auger@linaro.org> <55A05282.6020105@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55A05282.6020105@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, "eric.auger@st.com" <eric.auger@st.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "p.fedin@samsung.com" <p.fedin@samsung.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,
On 07/11/2015 01:17 AM, Andre Przywara wrote:
> On 09/07/15 09:22, Eric Auger wrote:
>> If the ITS modality is not available, let's simply support MSI
>> injection by transforming the MSI.data into an SPI ID.
>>
>> This becomes possible to use KVM_SIGNAL_MSI ioctl for arm too.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>>
>> v1 -> v2:
>> - introduce vgic_v2m_inject_msi in vgic-v2-emul.c following Andre's
>>   advice
>> ---
>>  arch/arm/kvm/Kconfig        |  1 +
>>  virt/kvm/arm/vgic-v2-emul.c | 12 ++++++++++++
>>  2 files changed, 13 insertions(+)
>>
>> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
>> index 151e710..0f58baf 100644
>> --- a/arch/arm/kvm/Kconfig
>> +++ b/arch/arm/kvm/Kconfig
>> @@ -31,6 +31,7 @@ config KVM
>>  	select KVM_VFIO
>>  	select HAVE_KVM_EVENTFD
>>  	select HAVE_KVM_IRQFD
>> +	select HAVE_KVM_MSI
> 
> I wonder if this requires some more code to only advertise
> KVM_CAP_SIGNAL_MSI if userland actually sets up a GICv2M?
> Otherwise userland could get the idea of being able to inectj MSIs
> without the guest actually being prepared for that (because the GICv2M
> driver did not initialize).
Not sure I get what you mean here. By directly transforming the user
provided MSI msg into an SPI ID, do we really have to care about GICv2M?

Best Regards

Eric
> 
> Cheers,
> Andre.
> 
>>  	select HAVE_KVM_IRQCHIP
>>  	select HAVE_KVM_IRQ_ROUTING
>>  	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
>> diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
>> index 1390797..43013cc 100644
>> --- a/virt/kvm/arm/vgic-v2-emul.c
>> +++ b/virt/kvm/arm/vgic-v2-emul.c
>> @@ -478,6 +478,17 @@ static bool vgic_v2_queue_sgi(struct kvm_vcpu *vcpu, int irq)
>>  }
>>  
>>  /**
>> + * Emulates GICv2M MSI injection by injecting the SPI ID matching
>> + * the msi data
>> + * @kvm: pointer to the kvm struct
>> + * @msi: the msi struct handle
>> + */
>> +static int vgic_v2m_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
>> +{
>> +	return kvm_vgic_inject_irq(kvm, 0, msi->data, 1);
>> +}
>> +
>> +/**
>>   * kvm_vgic_map_resources - Configure global VGIC state before running any VCPUs
>>   * @kvm: pointer to the kvm struct
>>   *
>> @@ -566,6 +577,7 @@ void vgic_v2_init_emulation(struct kvm *kvm)
>>  	dist->vm_ops.add_sgi_source = vgic_v2_add_sgi_source;
>>  	dist->vm_ops.init_model = vgic_v2_init_model;
>>  	dist->vm_ops.map_resources = vgic_v2_map_resources;
>> +	dist->vm_ops.inject_msi = vgic_v2m_inject_msi;
>>  
>>  	kvm->arch.max_vcpus = VGIC_V2_MAX_CPUS;
>>  }
>>
> 

