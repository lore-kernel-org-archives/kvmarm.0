From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [RFC PATCH 6/7] arm64: KVM: Handle trappable TLB instructions
Date: Thu, 01 Sep 2016 19:29:37 +0100
Message-ID: <878tvblbhq.fsf@e105922-lin.cambridge.arm.com>
References: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
 <1471344312-26685-7-git-send-email-punit.agrawal@arm.com>
 <20160819151846.GE9893@arm.com>
 <87a8g2sb4o.fsf@e105922-lin.cambridge.arm.com>
 <87h9a7rhvf.fsf@e105922-lin.cambridge.arm.com>
 <20160901145525.GM6721@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B6E840FA6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 14:21:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UMnpRihlJC8l for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2016 14:21:33 -0400 (EDT)
Received: from cam-smtp0.cambridge.arm.com (fw-tnat.cambridge.arm.com
 [217.140.96.140])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D3D5E407AD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 14:21:32 -0400 (EDT)
In-Reply-To: <20160901145525.GM6721@arm.com> (Will Deacon's message of "Thu, 1
 Sep 2016 15:55:25 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Will Deacon <will.deacon@arm.com> writes:

> On Fri, Aug 26, 2016 at 10:37:08AM +0100, Punit Agrawal wrote:
>> > Will Deacon <will.deacon@arm.com> writes:
>> >> The easiest thing to do is just TLBI VMALLE1IS for all trapped operations,
>> >> but you might want to see how that performs.
>> >
>> > That sounds reasonable for correctness. But I suspect we'll have to do
>> > more to claw back some performance. Let me run a few tests and come back
>> > on this.
>> 
>> Assuming I've correctly switched in TCR and replacing the various TLB
>> operations in this patch with TLBI VMALLE1IS, there is a drop in kernel
>> build times of ~5% (384s vs 363s).
>
> What do you mean by "switched in TCR"? Why is that necessary if you just
> nuke the whole thing?

You're right. it's not necessary. I'd misunderstood how TCR affects
things and was switching it in the above tests.

> Is the ~5% relative to no trapping at all, or
> trapping, but being selective about the operation?

The reported number was relative to trapping and being selective about
the operation. But I hadn't been careful in ensuring identical
conditions (page caches, etc.) when running the numbers.

So I've done a fresh set of identical measurements by running "time make
-j 7" in a VM booted with 7 vcpus and see the following results

1. no trapping ~ 365s
2. traps using selective tlb operations ~ 371s
3. traps that nuke all stage 1 (tlbi vmalle1is) ~ 393s

So based on these measurements there is ~1% and ~7.5% drop in comparison
between 2. and 3. compared to the base case of no trapping at all.

Thanks,
Punit

>
> Will
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
