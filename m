From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 26/26] KVM: arm/arm64: GICv4: Theory of operations
Date: Wed, 8 Nov 2017 15:19:36 +0000
Message-ID: <39032d1d-3371-1751-6981-f30811db19a8@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-27-marc.zyngier@arm.com>
 <98265bff-57ca-a31e-f41c-75b41a4e34f7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E58C49D2B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Nov 2017 10:17:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id evcT7QB+h8tB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Nov 2017 10:17:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 412EB49D28
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Nov 2017 10:17:42 -0500 (EST)
In-Reply-To: <98265bff-57ca-a31e-f41c-75b41a4e34f7@redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/11/17 09:13, Auger Eric wrote:
> Hi Marc,
> 
> On 27/10/2017 16:28, Marc Zyngier wrote:
>> Yet another braindump so I can free some cells...
>>
>> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-v4.c | 67 +++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 67 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>> index d10e18eabd3b..e367d65a0ebe 100644
>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>> @@ -23,6 +23,73 @@
>>  
>>  #include "vgic.h"
>>  
>> +/*
>> + * How KVM uses GICv4 (insert rude comments here):
>> + *
>> + * The vgic-v4 layer acts as a bridge between several entities:
>> + * - The GICv4 ITS representation offered by the ITS driver
>> + * - VFIO, which is in charge of the PCI endpoint
>> + * - The virtual ITS, which is the only thing the guest sees
>> + *
>> + * The configuration of VLPIs is triggered by a callback from VFIO,
>> + * instructing KVM that a PCI device has been configured to deliver
>> + * MSIs to a vITS.
> We actually have a negotiation protocol between VFIO PCI (irq bypass
> producer) and KVM irqfd (IRQ bypass consumer). When both recognize they
> are tied together, handling an MSI tunneling, they initiate the
> forwarding setup.
>> + *
>> + * kvm_vgic_v4_set_forwarding() is thus called with the routing entry,
>> + * and this is used to find the corresponding vITS data structures
>> + * (ITS instance, device, event and irq) using a process that is
>> + * extremely similar to the injection of an MSI.
> 
> Is it correct to say we replace the following injection chain:
> 
> pEventID|										
> (pITS)	|-> pLPIID -> VFIO PCI IRQ handler -> KVM irqfd ...
> pDevID	|
> 
> 		vEventID|
> ... inject	(vITS)	| -> vLPIID
> 		vDevID	|
> 
> by
> 
> pEventID|
> (pITS)	| -> vLPIID
> pDevID	|

That's indeed a pretty accurate description of what happens, with a side
messaging (doorbells).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
