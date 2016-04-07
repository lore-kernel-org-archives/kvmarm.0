From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC PATCH 44/45] KVM: arm/arm64: vgic-new: Add dummy MSI
 implementation
Date: Thu, 7 Apr 2016 16:35:53 +0200
Message-ID: <57067049.2000800@linaro.org>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-45-git-send-email-andre.przywara@arm.com>
 <20160331181656.GH4126@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AE3141145
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2016 10:35:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6Fn5Ig8Ya+L2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2016 10:35:42 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 957014053F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2016 10:35:42 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id 191so94040693wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2016 07:37:06 -0700 (PDT)
In-Reply-To: <20160331181656.GH4126@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 03/31/2016 08:16 PM, Christoffer Dall wrote:
> On Fri, Mar 25, 2016 at 02:05:07AM +0000, Andre Przywara wrote:
>> Although we don't provide any virtual MSI functionality yet, we
>> need to implement the functions required by the KVM interface.
> 
> I don't feel like this commit text accurately describes what's happening
> in the code?
> 
> This seems to be about irqfds which work just fine on a GICv2m guest?

Yes those functions enable irqfd injection. gsi routing and msi routing
is not implemented yet.

Eric
> 
> Thanks,
> -Christoffer
> 
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic_irqfd.c | 51 ++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 51 insertions(+)
>>  create mode 100644 virt/kvm/arm/vgic/vgic_irqfd.c
>>
>> diff --git a/virt/kvm/arm/vgic/vgic_irqfd.c b/virt/kvm/arm/vgic/vgic_irqfd.c
>> new file mode 100644
>> index 0000000..3eee1bd
>> --- /dev/null
>> +++ b/virt/kvm/arm/vgic/vgic_irqfd.c
>> @@ -0,0 +1,51 @@
>> +/*
>> + * Copyright (C) 2015, 2016 ARM Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/kvm.h>
>> +#include <linux/kvm_host.h>
>> +#include <trace/events/kvm.h>
>> +
>> +int kvm_irq_map_gsi(struct kvm *kvm,
>> +		    struct kvm_kernel_irq_routing_entry *entries,
>> +		    int gsi)
>> +{
>> +	return 0;
>> +}
>> +
>> +int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
>> +{
>> +	return pin;
>> +}
>> +
>> +int kvm_set_irq(struct kvm *kvm, int irq_source_id,
>> +		u32 irq, int level, bool line_status)
>> +{
>> +	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
>> +
>> +	trace_kvm_set_irq(irq, level, irq_source_id);
>> +
>> +	BUG_ON(!vgic_initialized(kvm));
>> +
>> +	return kvm_vgic_inject_irq(kvm, 0, spi, level);
>> +}
>> +
>> +/* MSI not implemented yet */
>> +int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>> +		struct kvm *kvm, int irq_source_id,
>> +		int level, bool line_status)
>> +{
>> +	return 0;
>> +}
>> -- 
>> 2.7.3
>>
