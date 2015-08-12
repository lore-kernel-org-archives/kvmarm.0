From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 4/6] irqchip: GIC: Use chip_data instead of handler_data
 for cascaded interrupts
Date: Wed, 12 Aug 2015 14:41:42 +0100
Message-ID: <55CB4D16.9070608@arm.com>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
 <1436447951-22357-5-git-send-email-marc.zyngier@arm.com>
 <55C9C42E.8070602@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CCEA5AC26
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 09:28:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MrNQ9ClUWj6x for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Aug 2015 09:28:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE1F15AC23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 09:28:39 -0400 (EDT)
In-Reply-To: <55C9C42E.8070602@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/08/15 10:45, Eric Auger wrote:
> Hi Marc,
> On 07/09/2015 03:19 PM, Marc Zyngier wrote:
>> When used as a primary interrupt controller, the GIC driver uses
>> irq_data->chip_data to extract controller-specific information.
>>
>> When used as a secondary interrupt controller, it uses handler_data
>> instead. As this difference is relatively pointless and only creates
>> confusion, change the secondary path to match what the rest of the
>> driver does.
> not really related to this series' topic, is it?

It is. Or was. We use the handler_data field to hold the vcpu
information, but that's also used by the chained interrupt handler to
find out which secondary it is.

But this patch is wrong anyway, as it entirely breaks secondary GICs (I
found out when I merged this with a patch from Jon Hunter fixing some
other related stuff). Took me hours to get an EB up and running!

I have a working version now, which makes this patch irrelevant.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
