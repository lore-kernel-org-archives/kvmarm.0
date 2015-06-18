From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC 4/6] KVM: arm/arm64: enable irqchip routing
Date: Thu, 18 Jun 2015 20:00:39 +0200
Message-ID: <55830747.7070101@linaro.org>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org> <1434649258-27065-5-git-send-email-eric.auger@linaro.org> <558305A2.8020206@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <558305A2.8020206@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, "eric.auger@st.com" <eric.auger@st.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>, "p.fedin@samsung.com" <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "patches@linaro.org" <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,
On 06/18/2015 07:53 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On 18/06/15 18:40, Eric Auger wrote:
>> This patch adds compilation and link against irqchip.
>>
>> On ARM, irqchip routing is not really useful since there is
>> a single irqchip. However main motivation behind using irqchip
>> code is to enable MSI routing code. With the support of in-kernel
>> GICv3 ITS emulation, it now seems to be a MUST HAVE requirement.
>>
>> Functions previously implemented in vgic.c and substitute
>> to more complex irqchip implementation are removed:
>>
>> - kvm_send_userspace_msi
>> - kvm_irq_map_chip_pin
>> - kvm_set_irq
>> - kvm_irq_map_gsi.
>>
>> They implemented a kernel default identity GSI routing. This is now
>> replaced by user-side provided routing.
>>
>> Routing standard hooks are now implemented in vgic:
>> - kvm_set_routing_entry
>> - kvm_set_irq
>> - kvm_set_msi
>>
>> Both HAVE_KVM_IRQCHIP and HAVE_KVM_IRQ_ROUTING are defined.
>> KVM_CAP_IRQ_ROUTING is advertised and KVM_SET_GSI_ROUTING is allowed.
>>
>> MSI routing is not yet allowed.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  Documentation/virtual/kvm/api.txt | 11 ++++--
>>  arch/arm/include/asm/kvm_host.h   |  2 +
>>  arch/arm/kvm/Kconfig              |  2 +
>>  arch/arm/kvm/Makefile             |  2 +-
>>  arch/arm64/include/asm/kvm_host.h |  1 +
>>  arch/arm64/kvm/Kconfig            |  2 +
>>  arch/arm64/kvm/Makefile           |  2 +-
>>  include/kvm/arm_vgic.h            |  9 -----
>>  virt/kvm/arm/vgic.c               | 78 ++++++++++++++++++++++++---------------
>>  virt/kvm/irqchip.c                |  2 +
>>  10 files changed, 67 insertions(+), 44 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index bcec91e..2bc96e1 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -1395,7 +1395,7 @@ KVM_ASSIGN_DEV_IRQ. Partial deassignment of host or guest IRQ is allowed.
>>  4.52 KVM_SET_GSI_ROUTING
>>  
>>  Capability: KVM_CAP_IRQ_ROUTING
>> -Architectures: x86 s390
>> +Architectures: x86 s390 arm arm64
>>  Type: vm ioctl
>>  Parameters: struct kvm_irq_routing (in)
>>  Returns: 0 on success, -1 on error
>> @@ -2310,9 +2310,12 @@ Note that closing the resamplefd is not sufficient to disable the
>>  irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
>>  and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
>>  
>> -On ARM/ARM64, the gsi field in the kvm_irqfd struct specifies the Shared
>> -Peripheral Interrupt (SPI) index, such that the GIC interrupt ID is
>> -given by gsi + 32.
>> +On ARM/ARM64, when GSI routing is not used, the gsi field in the
>> +kvm_irqfd struct specifies the Shared Peripheral Interrupt (SPI) index,
>> +such that the GIC interrupt ID is given by gsi + 32. When GSI routing is
>> +setup:
>> +- if irqchip routing: irqchip.pin + 32 is the SPI ID that is injected
>> +- if MSI routing: the MSI data is used as interrupt ID (SPI or LPI).
> 
> This feels just wrong. With GICv3, the MSI data is not the LPI at all.
> It is an opaque value that gets translated into an LPI when combined
> with the DeviceID.
I agree with you. I need to rephrase that. In practice this is what
should happen in the code since I use Andre's MSI injection routine
which does the translation; except for GICv2 where last patch attempts
to do direct gsi mapping from msi msg data!

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 

