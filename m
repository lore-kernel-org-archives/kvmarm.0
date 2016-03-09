From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v3 3/9] irqchip/gic-v2: Gather ACPI specific data in a
 single structure
Date: Wed, 9 Mar 2016 13:18:14 +0700
Message-ID: <56DFC026.5020909@arm.com>
References: <1457436573-6180-1-git-send-email-julien.grall@arm.com>
 <1457436573-6180-4-git-send-email-julien.grall@arm.com>
 <20160309054710.GI26583@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5548548529
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 01:18:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lWoQFV26a8wS for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 01:18:19 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 264C6412A2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 01:18:18 -0500 (EST)
In-Reply-To: <20160309054710.GI26583@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 09/03/2016 12:47, Christoffer Dall wrote:
> On Tue, Mar 08, 2016 at 11:29:27AM +0000, Julien Grall wrote:
>> For now, there is only one member. More member will be added later.
>
> questionable commit message

What about:

"The ACPI code requires to use global variables in order to collect 
information from the tables.

For now only a single global variable is used, but more will be added in 
a subsequent patch. To make clear they are ACPI specific, gather all the 
information in a single structure."

[...]

>> @@ -1316,7 +1319,7 @@ static int __init gic_v2_acpi_init(struct acpi_subtable_header *header,
>>   		return -EINVAL;
>>   	}
>>
>> -	cpu_base = ioremap(cpu_phy_base, ACPI_GIC_CPU_IF_MEM_SIZE);
>> +	cpu_base = ioremap(acpi_data.cpu_phy_base, ACPI_GIC_CPU_IF_MEM_SIZE);
>>   	if (!cpu_base) {
>>   		pr_err("Unable to map GICC registers\n");
>>   		return -ENOMEM;
>> --
>> 1.9.1
>>
> super nit: I would use cpu_phys_base instead of cpu_phy_base, but I'll
> leave it up to you.

I will update the commit message, so I will rename the variable too.

>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Cheers,

-- 
Julien Grall
