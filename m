From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [RFC PATCH 0/7] Add support for monitoring guest TLB operations
Date: Wed, 17 Aug 2016 18:20:14 +0100
Message-ID: <878tvvtir5.fsf@e105922-lin.cambridge.arm.com>
References: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
 <ed9ce98d-67d2-f01b-6bb0-5c5c842129a5@redhat.com>
 <87fuq3tjmv.fsf@e105922-lin.cambridge.arm.com>
 <a553745d-a527-b2ba-7cfa-f688786d5dc3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BF2440FA6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 13:12:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4rNZ+Ce5fbxq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2016 13:12:50 -0400 (EDT)
Received: from cam-smtp0.cambridge.arm.com (fw-tnat.cambridge.arm.com
 [217.140.96.140])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6568A40F90
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 13:12:49 -0400 (EDT)
In-Reply-To: <a553745d-a527-b2ba-7cfa-f688786d5dc3@redhat.com> (Paolo
 Bonzini's message of "Wed, 17 Aug 2016 19:02:32 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 17/08/2016 19:01, Punit Agrawal wrote:
>>> Can you explain what this is used for?  In other words, why would this
>>> be used instead of just running perf in the guest?
>> 
>> As TLB maintenance operations are synchronised in hardware, they can
>> impact performance beyond the guest. The operations generate traffic on
>> the interconnect and depending on the implementation, they can also
>> affect the remote TLB's translation bandwidth.
>> 
>> These patches are useful on systems where the host and guest are
>> controlled by different users - the guest could be running arbitrary
>> software. 
>> 
>> Having the ability to monitor the usage of guest TLB invalidations in
>> the host can be useful to diagnose performance issues on such systems.
>
> Are there hardware performance counters for these operations?

That would have been ideal! There are PMU events defined for TLB
accesses and refills but unhelpfully none of them track maintenance
operations.

>
> Paolo
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
