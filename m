From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 0/3] KVM: arm/arm64: Allow to use KVM without in-kernel
 irqchip
Date: Fri, 17 Jul 2015 17:59:52 +0100
Message-ID: <55A93488.9060408@arm.com>
References: <cover.1436874248.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EDC658D96
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 12:47:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4ZOjFU7xvikX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 12:47:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A068D58D8A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 12:47:57 -0400 (EDT)
In-Reply-To: <cover.1436874248.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 14/07/15 13:06, Pavel Fedin wrote:
> This patch set brings back functionality which was broken in v4.1. The
> overall goal is to eventually enable using virtual timer too, but for now
> changes affect only a possibility to run KVM itself. The guest currently
> has to use another timer because there's no API to propagate interrupts
> from in-kernel virtual timer to the interrupt controller emulated in
> userspace.
> 
> v1=>v2:
> - Do not use defensive approach in patch 0001. Use correct conditions in
>   callers instead
> - Added ARM64-specific code, without which attempt to run a VM ends in a
>   HYP crash because of unset vGIC save/restore function pointers
> 
> Christoffer Dall: I decided to leave original approach of 0002 as it is,
> because:
> - It is much simpler to implement than doing changes inside both probe
>   functions.
> - These are all use cases for vgic_present flag. Nothing else is going to
>   rely on it. IMHO this switch is very short and stylish :) If you don't
>   like two error codes, we could change -ENXIO to -ENODEV where appropriate,
>   this change would be small enough.
> Actually i tried to discuss some things with you, but you stopped replying,
> therefore i respin in order to revive the thing. On top of this i have

I'm not Christoffer, but I'm going to take that one for the team.

Believe it or not, we're not only patch reviewing machines, and if you
count the number of pending patches, you'll quickly notice that yours
are basically noise in the grand scheme of things.

So please cut us some slack.

> complete implementation of API which allows to emulate GIC in userspace by
> qemu, and now i can run any virtual machine, including generic timer, on
> vGIC-less machine. RasPI-2 is expected to benefit too.

Do you mean feeding interrupts back to userspace? How is that going to
work with the active-timer series that really mandates a full blown GIC?
Your pet platform might cope with it, but I can't see that happening on
the RPi.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
