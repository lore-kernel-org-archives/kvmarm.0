From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/5] arm/arm64: KVM: Allow a VCPU to fully reset itself
Date: Thu, 31 Jan 2019 14:52:11 +0000
Message-ID: <b356cded-fc12-d996-a860-1ef94b6a8ffb@arm.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-3-christoffer.dall@arm.com>
 <20190129160347.fcbry76igwyatqzx@kamzik.brq.redhat.com>
 <20190130093431.GE13482@e113682-lin.lund.arm.com>
 <20190130152721.7fbiza3glifvzlqk@kamzik.brq.redhat.com>
 <20190131074353.GI13482@e113682-lin.lund.arm.com>
 <20190131101254.rh23ntvwxtq3yqsz@kamzik.brq.redhat.com>
 <20190131115156.GP13482@e113682-lin.lund.arm.com>
 <20190131125712.pwupvf4favbqi6hu@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C75904A320
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 09:52:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yPI-tkVi8nWh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 09:52:15 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A93A24A2E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 09:52:15 -0500 (EST)
In-Reply-To: <20190131125712.pwupvf4favbqi6hu@kamzik.brq.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 31/01/2019 12:57, Andrew Jones wrote:
> On Thu, Jan 31, 2019 at 12:51:56PM +0100, Christoffer Dall wrote:

[...]

>> I don't think there's anything very unconventional here.
> 
> Normally if a thread observes a change to vcpu->requests, then we ensure a
> change to some accompanying data is also observable. We're reversing that
> here, which adds a need for additional barriers and a strict request
> checking order.
> 
>>
>> Let's try this:  If you have a better way of implementing this, how
>> about you write a patch?
> 
> It would just be this patch minus the unnecessary barriers. I can send it
> if you like, but I wouldn't want to change the authorship for such a small
> change.

Having these barriers makes it explicit (at least to me) what data we
expect to be visible in other threads and in which order. You keep
saying that order doesn't matter and we disagree on this. Yes, you've
listed cases where we can survive things coming in out of order, but
that's not a proof that we don't need them.

So at the end of the day, and unless you can prove that the barriers are
not necessary by providing the same form of validation tool, I'm
inclined to go with the verified approach.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
