From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 13/13] KVM: arm64: enable ITS emulation as a virtual MSI
 controller
Date: Thu, 18 Jun 2015 15:22:08 +0100
Message-ID: <5582D410.60708@arm.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
 <1432893209-27313-14-git-send-email-andre.przywara@arm.com>
 <558284B4.104@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F08055EAB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 10:11:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id thWWih96Ipud for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2015 10:11:12 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E96F555EA9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 10:11:11 -0400 (EDT)
In-Reply-To: <558284B4.104@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 06/18/2015 09:43 AM, Eric Auger wrote:
> On 05/29/2015 11:53 AM, Andre Przywara wrote:
>> If userspace has provided a base address for the ITS register frame,
>> we enable the bits that advertise LPIs in the GICv3.
>> When the guest has enabled LPIs and the ITS, we enable the emulation
>> part by initializing the ITS data structures and trapping on ITS
>> register frame accesses by the guest.
>> Also we enable the KVM_SIGNAL_MSI feature to allow userland to inject
>> MSIs into the guest. Not having enabled the ITS emulation will lead
>> to a -ENODEV when trying to inject a MSI.
>>

....

>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index 9f7b05f..09b1f46 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -2254,3 +2254,13 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>>  {
>>  	return 0;
>>  }
>> +
>> +#ifdef CONFIG_HAVE_KVM_MSI
> I don't think the if#def is requested since the entry is already
> prevented in kvm_main.c in, case KVM_SIGNAL_MSI.

But that fails compilation on ARM (which uses this file as well),
because we have a dummy fail function in the header if
CONFIG_HAVE_KVM_MSI is not defined.
So you get: error: redefinition of 'kvm_send_userspace_msi'

Cheers,
Andre.

>> +int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
>> +{
>> +	if (kvm->arch.vgic.vm_ops.inject_msi)
>> +		return kvm->arch.vgic.vm_ops.inject_msi(kvm, msi);
>> +	else
>> +		return -ENODEV;
>> +}
>> +#endif
>>
> 
