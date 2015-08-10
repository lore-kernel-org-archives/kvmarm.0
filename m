From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 0/7] KVM: arm/arm64: gsi routing support
Date: Mon, 10 Aug 2015 15:39:02 +0200
Message-ID: <55C8A976.1090303@linaro.org>
References: <1438615889-10892-1-git-send-email-eric.auger@linaro.org> <002401d0d040$5667c530$03374f90$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <002401d0d040$5667c530$03374f90$@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, pbonzini@redhat.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,
On 08/06/2015 02:06 PM, Pavel Fedin wrote:
> Tested-by: Pavel Fedin <p.fedin@samsung.com>

Many thanks for testing!

Best Regards

Eric
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
>> -----Original Message-----
>> From: Eric Auger [mailto:eric.auger@linaro.org]
>> Sent: Monday, August 03, 2015 6:31 PM
>> To: eric.auger@st.com; eric.auger@linaro.org; linux-arm-kernel@lists.infradead.org;
>> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; christoffer.dall@linaro.org;
>> marc.zyngier@arm.com
>> Cc: linux-kernel@vger.kernel.org; patches@linaro.org; pbonzini@redhat.com;
>> andre.przywara@arm.com; p.fedin@samsung.com
>> Subject: [PATCH v3 0/7] KVM: arm/arm64: gsi routing support
>>
>> With the advent of GICv3 ITS in-kernel emulation, KVM GSI routing
>> appears to be requested. More specifically MSI routing is needed.
>> irqchip routing does not sound to be really useful on arm but usage of
>> MSI routing also mandates to integrate irqchip routing. The initial
>> implementation of irqfd on arm must be upgraded with the integration
>> of kvm irqchip.c code and the implementation of its standard hooks
>> in the architecture specific part.
>>
>> In case KVM_SET_GSI_ROUTING ioctl is not called, a default routing
>> table with flat irqchip routing entries is built enabling to inject gsi
>> corresponding to the SPI indexes seen by the guest.
>>
>> As soon as KVM_SET_GSI_ROUTING is called, user-space overwrites this
>> default routing table and is responsible for building the whole routing
>> table.
>>
>> for arm/arm64 KVM_SET_GSI_ROUTING has a limited support:
>> - only applies to KVM_IRQFD and not to KVM_IRQ_LINE
>>
>> - irqchip routing was tested on Calxeda midway (VFIO with irqfd)
>>   with and without explicit routing
>> - MSI routing without GICv3 ITS was tested using APM Xgene-I
>>   (qemu VIRTIO-PCI vhost-net without gsi_direct_mapping).
>> - MSI routing with GICv3 ITS is *NOT* tested.
>>
>> Code can be found at
> https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.2-rc4-
>> gsi-routing-v3
>>
>> It applies on Andre's [PATCH v2 00/15] KVM: arm64: GICv3 ITS emulation
>> (http://lists.infradead.org/pipermail/linux-arm-kernel/2015-July/355727.html)
>>
>> History:
>> v2 -> v3:
>> - eventually got rid of KVM_IRQ_ROUTING_EXTENDED_MSI new type at user
>>   api level and use KVM_MSI_VALID_DEVID flag instead
>> - remove usage of KVM_IRQ_ROUTING_EXTENDED_MSI type at kernel level too.
>> - propagate user flags downto the kernel to make sure the userspace
>>   correctly set devid in GICv3 ITS case (still under discussion)
>>
>> v1 -> v2:
>> - user API changed:
>>   x devid id passed in kvm_irq_routing_msi
>>   x kept the new routing entry type: KVM_IRQ_ROUTING_EXTENDED_MSI
>> - kvm_host.h: adopt Andre's proposal to replace the msi_msg by a struct
>>   composed of the msi_msg and devid in kvm_kernel_irq_routing_entry
>> - Fix bug reported by Pavel: Added KVM_IRQ_ROUTING_EXTENDED_MSI handling
>>   in eventfd.c
>> - added vgic_v2m_inject_msi in vgic-v2-emul.c as suggested by Andre
>> - fix bug reported by Andre: bad setting of msi.flags and msi.devid
>>   in kvm_send_userspace_msi
>> - avoid injecting reserved IRQ numbers in vgic_irqfd_set_irq
>>
>> RFC -> PATCH:
>> - clearly state limited support on arm/arm64:
>>   KVM_IRQ_LINE not impacted by GSI routing
>> - add default routing table feature (new patch file)
>> - changed uapi to use padding field area
>> - reword api.txt
>>
>> Eric Auger (7):
>>   KVM: api: pass the devid in the msi routing entry
>>   KVM: kvm_host: add devid in kvm_kernel_irq_routing_entry
>>   KVM: irqchip: convey devid to kvm_set_msi
>>   KVM: arm/arm64: enable irqchip routing
>>   KVM: arm/arm64: build a default routing table
>>   KVM: arm/arm64: enable MSI routing
>>   KVM: arm: enable KVM_SIGNAL_MSI and MSI routing
>>
>>  Documentation/virtual/kvm/api.txt |  35 ++++++++++---
>>  arch/arm/include/asm/kvm_host.h   |   2 +
>>  arch/arm/kvm/Kconfig              |   3 ++
>>  arch/arm/kvm/Makefile             |   2 +-
>>  arch/arm64/include/asm/kvm_host.h |   1 +
>>  arch/arm64/kvm/Kconfig            |   2 +
>>  arch/arm64/kvm/Makefile           |   2 +-
>>  include/kvm/arm_vgic.h            |   2 -
>>  include/linux/kvm_host.h          |   8 ++-
>>  include/uapi/linux/kvm.h          |   5 +-
>>  virt/kvm/arm/vgic-v2-emul.c       |  16 ++++++
>>  virt/kvm/arm/vgic.c               | 107 ++++++++++++++++++++++++++++++--------
>>  virt/kvm/irqchip.c                |   8 ++-
>>  13 files changed, 158 insertions(+), 35 deletions(-)
>>
>> --
>> 1.9.1
> 
