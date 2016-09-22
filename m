From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v4 2/2] KVM: arm/arm64: Route vtimer events to user space
Date: Thu, 22 Sep 2016 14:32:26 +0200
Message-ID: <57E3CF5A.3050608@suse.de>
References: <1474283695-212421-1-git-send-email-agraf@suse.de>
 <1474283695-212421-3-git-send-email-agraf@suse.de> <57DFFAD3.3080009@arm.com>
 <0960d2a7-6100-3212-c544-d5377df34d57@suse.de> <57E0FF95.7040305@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DDD049B3D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 08:23:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VkT2yuJU0trn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2016 08:23:20 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E53849B2C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 08:23:19 -0400 (EDT)
In-Reply-To: <57E0FF95.7040305@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 09/20/2016 11:21 AM, Marc Zyngier wrote:
> On 19/09/16 18:39, Alexander Graf wrote:
>>
>> On 19.09.16 16:48, Marc Zyngier wrote:
>>
>>>> +
>>>> +		/*
>>>> +		 * So we can just explicitly mask or unmask the IRQ, gaining
>>>> +		 * more compatibility with oddball irq controllers.
>>>> +		 */
>>>> +		if (phys_active)
>>>> +			disable_percpu_irq(host_vtimer_irq);
>>>> +		else
>>>> +			enable_percpu_irq(host_vtimer_irq, 0);
>>> Since you are now targeting random irqchips (as opposed to a GIC
>>> specifically), what guarantees that the timer is a per-cpu IRQ?
>> This is the host interrupt controller - and we're already using percpu
>> irqs on it :). Also as it happens the RPi has them percpu (anything else
>> wouldn't make sense...).
> Not really. The RPi is faking percpu interrupts just to have some level
> of compatibility with the host arch timer driver. But nonetheless, if
> you're opening the code to something else than a GIC, then you should
> check that the interrupt you're getting is percpu.

This should already be covered by request_percpu_irq() in 
kvm_timer_hyp_init(), no?


Alex
