From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH v5 6/9] irqchip/gic-v3: Parse and export virtual GIC
 information
Date: Mon, 11 Apr 2016 10:25:33 -0500
Message-ID: <570BC1ED.9080200@codeaurora.org>
References: <1459769860-6629-1-git-send-email-julien.grall@arm.com>
 <1459769860-6629-7-git-send-email-julien.grall@arm.com>
 <570B35DA.5050600@linaro.org> <570BB461.4040704@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1761140B40
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 11:24:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fy0u+otervGl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2016 11:24:04 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E412D4011D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 11:24:02 -0400 (EDT)
In-Reply-To: <570BB461.4040704@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, fu.wei@linaro.org, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Julien,

On 04/11/2016 09:27 AM, Julien Grall wrote:
> Hello Hanjun,
>
> On 11/04/16 06:27, Hanjun Guo wrote:
>> On 2016/4/4 19:37, Julien Grall wrote:
>>> +static void __init gic_acpi_setup_kvm_info(void)
>>> +{
>>> +    int irq;
>>> +
>>> +    if (!gic_acpi_collect_virt_info()) {
>>> +        pr_warn("Unable to get hardware information used for
>>> virtualization\n");
>>> +        return;
>>> +    }
>>> +
>>> +    gic_v3_kvm_info.type = GIC_V3;
>>> +
>>> +    irq = acpi_register_gsi(NULL, acpi_data.maint_irq,
>>> +                acpi_data.maint_irq_mode,
>>> +                ACPI_ACTIVE_HIGH);
>>> +    if (irq <= 0)
>>> +        return;
>>> +
>>> +    gic_v3_kvm_info.maint_irq = irq;
>>> +
>>> +    if (acpi_data.vcpu_base) {
>>
>> Sorry, I'm not familiar with KVM, but I got a question here, will
>> KVM works without valid vcpu_base in GICv3 mode?
>
Yes, KVM works without vcpu_base in GICv3 mode. The vcpu_base will be used
for emulatingvGICv2 feature. The vGICv3 emulation isdone through the
system registers.

> vcpu_base is only required for supporting GICv2 on GICv3.
>
Yes, you are right,

> Regards,
>

-- 
Shanker Donthineni
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
