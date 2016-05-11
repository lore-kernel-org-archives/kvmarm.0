From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PULL 00/29] KVM/ARM Changes for v4.7
Date: Wed, 11 May 2016 16:37:53 +0100
Message-ID: <573351D1.4060303@arm.com>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
 <57334E72.9010109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 013B549B35
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 11:35:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zpvaWjTjENqx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 11:34:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55FFA49B34
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 11:34:58 -0400 (EDT)
In-Reply-To: <57334E72.9010109@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 11/05/16 16:23, Paolo Bonzini wrote:
> 
> 
> On 11/05/2016 15:29, Christoffer Dall wrote:
>> Hi Paolo and Radim,
>>
>> Here is the initial set of changes for KVM/ARM for v4.7.
>>
>> Sorry I'm a bit late with these, but we were trying to get the new vgic
>> implementation in as part of this, but I have decided to send this pull
>> request now, and we can follow up with another for the new VGIC,
>> assuming we feel like we have that in place in a few days.
> 
> Don't worry, you're not late at all.  I've pulled this to kvm/queue.
> 
>> There are a few changes in this pull request touching things outside
>> KVM, but they should all carry the necessary acks and it made the
>> merge process much easier to do it this way.
> 
> The following are properly acked:
> 
>     arm64: Reuse TCR field definitions for EL1 and EL2
>     arm64: Introduce pmd_thp_or_huge
> 
> I wouldn't have minded more explicit Acked-bys for the following:
> 
>     irqchip/gic-v2: Gather ACPI specific data in a single structure
>     irqchip/gic-v2: Parse and export virtual GIC information
>     irqchip/gic-v3: Prefix all pr_* messages by "GICv3: "
>     irqchip/gic-v3: Gather all ACPI specific data in a single structure
>     irqchip/gic-v3: Parse and export virtual GIC information
> 
> I guess it's fine since Marc Zyngier is maintainer for both KVM and
> irqchip, still it's never wrong to get more acks. :)

Ah, I really thought I acked them. The email must have been stuck in my
head...

So more formally and for documentation purposes:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
