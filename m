From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH 5/7] arm64/kvm: hyp: tlb: use __tlbi() helper
Date: Thu, 06 Oct 2016 10:43:14 +0100
Message-ID: <87eg3tyfrh.fsf@e105922-lin.cambridge.arm.com>
References: <1473761769-30572-1-git-send-email-punit.agrawal@arm.com>
 <1473761769-30572-6-git-send-email-punit.agrawal@arm.com>
 <07921948-8692-67c1-8ae9-a68f0cc387c8@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B85A49B7F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2016 05:33:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id keMhkErT0f7b for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Oct 2016 05:33:34 -0400 (EDT)
Received: from cam-smtp0.cambridge.arm.com (fw-tnat.cambridge.arm.com
 [217.140.96.140])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE54149B76
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2016 05:33:32 -0400 (EDT)
In-Reply-To: <07921948-8692-67c1-8ae9-a68f0cc387c8@suse.com> (Matthias
 Brugger's message of "Wed, 5 Oct 2016 18:41:02 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Matthias Brugger <mbrugger@suse.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Matthias Brugger <mbrugger@suse.com> writes:

> On 13/09/16 12:16, Punit Agrawal wrote:
>> From: Mark Rutland <mark.rutland@arm.com>
>>
>> Now that we have a __tlbi() helper, make use of this in the arm64 KVM hyp
>> code to get rid of asm() boilerplate. At the same time, we simplify
>> __tlb_flush_vm_context by using __flush_icache_all(), as this has the
>> appropriate instruction cache maintenance and barrier.
>>
>> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> [ rename tlbi -> __tlbi, convert additional sites, update commit log ]
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>> ---
>
> Reviewed-by: Matthias Brugger <mbrugger@suse.com>

Thanks for reviewing the patch. I'll re-spin a new version with the tag
after the merge window.

Punit


[...]
