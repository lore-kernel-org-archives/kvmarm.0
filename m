From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v5 6/9] irqchip/gic-v3: Parse and export virtual GIC
 information
Date: Mon, 11 Apr 2016 15:27:45 +0100
Message-ID: <570BB461.4040704@arm.com>
References: <1459769860-6629-1-git-send-email-julien.grall@arm.com>
 <1459769860-6629-7-git-send-email-julien.grall@arm.com>
 <570B35DA.5050600@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8DD34053F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 10:26:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Z8FDlKwi3at for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2016 10:26:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD1CC4011D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 10:26:14 -0400 (EDT)
In-Reply-To: <570B35DA.5050600@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Hanjun Guo <hanjun.guo@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

Hello Hanjun,

On 11/04/16 06:27, Hanjun Guo wrote:
> On 2016/4/4 19:37, Julien Grall wrote:
>> +static void __init gic_acpi_setup_kvm_info(void)
>> +{
>> +    int irq;
>> +
>> +    if (!gic_acpi_collect_virt_info()) {
>> +        pr_warn("Unable to get hardware information used for
>> virtualization\n");
>> +        return;
>> +    }
>> +
>> +    gic_v3_kvm_info.type = GIC_V3;
>> +
>> +    irq = acpi_register_gsi(NULL, acpi_data.maint_irq,
>> +                acpi_data.maint_irq_mode,
>> +                ACPI_ACTIVE_HIGH);
>> +    if (irq <= 0)
>> +        return;
>> +
>> +    gic_v3_kvm_info.maint_irq = irq;
>> +
>> +    if (acpi_data.vcpu_base) {
>
> Sorry, I'm not familiar with KVM, but I got a question here, will
> KVM works without valid vcpu_base in GICv3 mode?

vcpu_base is only required for supporting GICv2 on GICv3.

Regards,

-- 
Julien Grall
