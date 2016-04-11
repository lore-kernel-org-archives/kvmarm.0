From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v5 6/9] irqchip/gic-v3: Parse and export virtual GIC
 information
Date: Mon, 11 Apr 2016 15:03:15 +0100
Message-ID: <570BAEA3.5090007@arm.com>
References: <1459769860-6629-1-git-send-email-julien.grall@arm.com>
 <1459769860-6629-7-git-send-email-julien.grall@arm.com>
 <570868EE.9090200@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE7B24053F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 10:01:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KeRpb7ekoFoz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2016 10:01:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 129DE4011D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 10:01:44 -0400 (EDT)
In-Reply-To: <570868EE.9090200@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>, kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, fu.wei@linaro.org, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/04/16 03:29, Shanker Donthineni wrote:
> Hi Julien,

Hello Shanker,

> On 04/04/2016 06:37 AM, Julien Grall wrote:
>> +static int __init gic_acpi_parse_virt_madt_gicc(struct
>> acpi_subtable_header *header,
>> +						const unsigned long end)
>> +{
>> +	struct acpi_madt_generic_interrupt *gicc =
>> +		(struct acpi_madt_generic_interrupt *)header;
>> +	int maint_irq_mode;
>> +	static int first_madt = true;
>> +
>> +	maint_irq_mode = (gicc->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
>> +		ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
>> +
> Do you think GICC parameters are valid for an unusable processor?

Good point. We don't know if the value will be valid when the processor 
is unusable.

> If not we need a validation check here, some thing like this to skip
> GICC subtable entry.
>
>              if (!(gicc->flags & ACPI_MADT_ENABLED))
>                  return 0;

I will add this check.

Regards,

-- 
Julien Grall
