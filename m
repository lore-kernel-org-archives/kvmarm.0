From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 15/15] KVM: arm64: enable ITS emulation as a virtual
 MSI controller
Date: Wed, 15 Jul 2015 10:52:16 +0100
Message-ID: <55A62D50.9080101@arm.com>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-16-git-send-email-andre.przywara@arm.com>
 <00fa01d0bede$098f5570$1cae0050$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EBBE58961
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2015 05:40:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BJlYAzSSeqiR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2015 05:40:20 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 854B05895F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2015 05:40:20 -0400 (EDT)
In-Reply-To: <00fa01d0bede$098f5570$1cae0050$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 15/07/15 10:10, Pavel Fedin wrote:
>> -----Original Message-----
>> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Andre Przywara
>> Sent: Friday, July 10, 2015 5:22 PM
>> To: marc.zyngier@arm.com; christoffer.dall@linaro.org; kvmarm@lists.cs.columbia.edu
>> Cc: eric.auger@linaro.org; Pavel Fedin; linux-arm-kernel@lists.infradead.org; kvm@vger.kernel.org
>> Subject: [PATCH v2 15/15] KVM: arm64: enable ITS emulation as a virtual MSI controller
>>
>> If userspace has provided a base address for the ITS register frame,
>> we enable the bits that advertise LPIs in the GICv3.
>> When the guest has enabled LPIs and the ITS, we enable the emulation
>> part by initializing the ITS data structures and trapping on ITS
>> register frame accesses by the guest.
>> Also we enable the KVM_SIGNAL_MSI feature to allow userland to inject
>> MSIs into the guest. Not having enabled the ITS emulation will lead
>> to a -ENODEV when trying to inject a MSI.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  Documentation/virtual/kvm/api.txt |  2 +-
>>  arch/arm64/kvm/Kconfig            |  1 +
>>  arch/arm64/kvm/reset.c            |  6 ++++++
>>  include/kvm/arm_vgic.h            |  6 ++++++
>>  virt/kvm/arm/its-emul.c           | 10 +++++++++-
>>  virt/kvm/arm/vgic-v3-emul.c       | 20 ++++++++++++++------
>>  virt/kvm/arm/vgic.c               |  8 ++++++++
>>  7 files changed, 45 insertions(+), 8 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index cb04095..1b53155 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -2134,7 +2134,7 @@ after pausing the vcpu, but before it is resumed.
>>  4.71 KVM_SIGNAL_MSI
>>
>>  Capability: KVM_CAP_SIGNAL_MSI
>> -Architectures: x86
>> +Architectures: x86 arm64
>>  Type: vm ioctl
>>  Parameters: struct kvm_msi (in)
>>  Returns: >0 on delivery, 0 if guest blocked the MSI, and -1 on error
>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index bfffe8f..ff9722f 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -31,6 +31,7 @@ config KVM
>>  	select KVM_VFIO
>>  	select HAVE_KVM_EVENTFD
>>  	select HAVE_KVM_IRQFD
>> +	select HAVE_KVM_MSI
>>  	---help---
>>  	  Support hosting virtualized guest machines.
>>
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 866502b..aff209e 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -64,6 +64,12 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_ARM_EL1_32BIT:
>>  		r = cpu_has_32bit_el1();
>>  		break;
>> +	case KVM_CAP_MSI_DEVID:
>> +		if (!kvm)
>> +			r = -EINVAL;
>> +		else
>> +			r = kvm->arch.vgic.msis_require_devid;
>> +		break;
>>  	default:
>>  		r = 0;
>>  	}
> 
>  This can be very inconvenient to use IMHO. The problem here is that capability is set to TRUE only
> after everything has been instantiated, and the VM is about to run. And, for example, qemu first
> queries for capabilities, then creates models.

But why would it need the capability to create models? The idea is to
check the capability before the actual KVM_SIGNAL_MSI or
KVM_SET_GSI_ROUTING ioctl (and cache that result). I have a function
with a static variable to do that, so it looks like:

+  if (check_for_msi_devid(kvm)) {
+    irq_routing->entries[irq_routing->nr].flags = KVM_MSI_VALID_DEVID;
+    irq_routing->entries[irq_routing->nr].u.msi.devid = device_id;
+  }

> May be we should just set the capability to TRUE for
> ARM architecture in general, and make GICv2m MSIs simply ignoring this flag and device ID?

Possibly, but it would be saner to tell userland that it's a per VM
decision for ARM. Since you need extra support bits in the userland
anyway (to set up GICv2M or ITS emulation), I think it is acceptable to
require a late, per-VM capability check in userland in that case.

>  Of course, we can explicitly check for the capability after vGICv3 + ITS instantiation, however in
> this case it IMHO simply loses sense, because since we are using ITS, we already know for sure that
> device IDs are required, because ITS requires them by design.

Yeah, that is true to some degree.
But the idea is that the userland code that sets up GSI routing or
triggers MSIs via KVM_SIGNAL_MSI is architecture agnostic (or it could
be), so you don't want to introduce #ifdef ARM in there.
But for the rest of the code I agree there is no real need to
differentiate between requiring a device ID or not. Reworking Eric's and
my patches proved that - at least on the kernel side: propagating the
device ID unconditionally does not harm even if the value in there is
garbage. Also there is no real choice - either you require the device ID
(ITS emulation) or you ignore it (GICv2M and other archs).

Cheers,
Andre.
