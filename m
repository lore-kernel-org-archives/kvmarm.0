From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v4 18/21] KVM: ARM64: Add PMU overflow interrupt routing
Date: Wed, 02 Dec 2015 00:26:12 +0800
Message-ID: <565DCA24.7000908@linaro.org>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>	<1446186123-11548-19-git-send-email-zhaoshenglong@huawei.com>
 <20151130182258.684c9df6@arm.com> <565DB021.3020901@huawei.com>
 <565DB3A5.3030701@arm.com> <565DB935.5040609@linaro.org>
 <565DBF8D.1070006@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CBBB49973
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 11:25:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 03QHHfcrp1+q for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2015 11:25:01 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C06704993E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 11:25:01 -0500 (EST)
Received: by wmec201 with SMTP id c201so213685076wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Dec 2015 08:26:25 -0800 (PST)
In-Reply-To: <565DBF8D.1070006@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/1 23:41, Marc Zyngier wrote:
>> The reason is that when guest clear the overflow register, it will trap
>> >to kvm and call kvm_pmu_sync_hwstate() as you see above. At this moment,
>> >the overflow register is still overflowed(that is some bit is still 1).
>> >So We need to use some flag to mark we already inject this interrupt.
>> >And if during guest handling the overflow, there is a new overflow
>> >happening, the pmu->irq_pending will be set ture by
>> >kvm_pmu_perf_overflow(), then it needs to inject this new interrupt, right?
> I don't think so. This is a level interrupt, so the level should stay
> high as long as the guest hasn't cleared all possible sources for that
> interrupt.
>
> For your example, the guest writes to PMOVSCLR to clear the overflow
> caused by a given counter. If the status is now 0, the interrupt line
> drops. If the status is still non zero, the line stays high. And I
> believe that writing a 1 to PMOVSSET would actually trigger an
> interrupt, or keep it high if it has already high.
>
Right, writing 1 to PMOVSSET will trigger an interrupt.

> In essence, do not try to maintain side state. I've been bitten.

So on VM entry, it check if PMOVSSET is zero. If not, call 
kvm_vgic_inject_irq to set the level high. If so, set the level low.
On VM exit, it seems there is nothing to do.

-- 
Shannon
