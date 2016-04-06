From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v5 6/9] irqchip/gic-v3: Parse and export virtual GIC
 information
Date: Wed, 6 Apr 2016 18:45:19 +0100
Message-ID: <57054B2F.8040907@arm.com>
References: <1459769860-6629-1-git-send-email-julien.grall@arm.com>
 <1459769860-6629-7-git-send-email-julien.grall@arm.com>
 <20160406172228.GE8961@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 327C540BDA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 13:44:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KUuVBdob5QHE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2016 13:44:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DC2140B58
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 13:44:02 -0400 (EDT)
In-Reply-To: <20160406172228.GE8961@cbox>
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
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 06/04/2016 18:22, Christoffer Dall wrote:
> On Mon, Apr 04, 2016 at 12:37:37PM +0100, Julien Grall wrote:
>> +static void __init gic_acpi_setup_kvm_info(void)
>> +{
>> +	int irq;
>> +
>> +	if (!gic_acpi_collect_virt_info()) {
>> +		pr_warn("Unable to get hardware information used for virtualization\n");
>
> perhaps this should say something about gicv3 as well?

Actually, none of the pr_* call contain GICv3 and there is no pr_fmt.

I'm thinking to send a patch to add pr_fmt in the GICv3 driver.

>
> Otherwise (with my extremely limited acpi understanding):
>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thank you!

Regards,

-- 
Julien Grall
