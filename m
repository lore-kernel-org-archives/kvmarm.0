From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 0/7] Add support for monitoring guest TLB operations
Date: Wed, 17 Aug 2016 19:02:32 +0200
Message-ID: <a553745d-a527-b2ba-7cfa-f688786d5dc3@redhat.com>
References: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
 <ed9ce98d-67d2-f01b-6bb0-5c5c842129a5@redhat.com>
 <87fuq3tjmv.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87fuq3tjmv.fsf@e105922-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 17/08/2016 19:01, Punit Agrawal wrote:
>> Can you explain what this is used for?  In other words, why would this
>> be used instead of just running perf in the guest?
> 
> As TLB maintenance operations are synchronised in hardware, they can
> impact performance beyond the guest. The operations generate traffic on
> the interconnect and depending on the implementation, they can also
> affect the remote TLB's translation bandwidth.
> 
> These patches are useful on systems where the host and guest are
> controlled by different users - the guest could be running arbitrary
> software. 
> 
> Having the ability to monitor the usage of guest TLB invalidations in
> the host can be useful to diagnose performance issues on such systems.

Are there hardware performance counters for these operations?

Paolo
