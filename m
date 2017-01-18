From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v3 6/9] kvm: arm/arm64: Add host pmu to support VM
 introspection
Date: Wed, 18 Jan 2017 16:17:18 +0000
Message-ID: <877f5smjg1.fsf@e105922-lin.cambridge.arm.com>
References: <20170110113856.7183-1-punit.agrawal@arm.com>
 <20170110113856.7183-7-punit.agrawal@arm.com>
 <1a6b8d71-58a5-b29b-3f01-e945deb2baf6@arm.com>
 <20170118113523.GB3231@leverpostej>
 <87o9z4msi3.fsf@e105922-lin.cambridge.arm.com>
 <c2382140-b7ac-11d8-89f0-bf421e38f844@arm.com>
 <87fukgmnf0.fsf@e105922-lin.cambridge.arm.com>
 <20170118151729.GI3231@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 713C4407D1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Jan 2017 11:15:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HYV1lDLWL+-L for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Jan 2017 11:15:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22E124066C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Jan 2017 11:15:26 -0500 (EST)
In-Reply-To: <20170118151729.GI3231@leverpostej> (Mark Rutland's message of
 "Wed, 18 Jan 2017 15:17:29 +0000")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Mark Rutland <mark.rutland@arm.com> writes:

> On Wed, Jan 18, 2017 at 02:51:31PM +0000, Punit Agrawal wrote:
>> I should've clarified in my reply that I wasn't looking to support the
>> third instance from Mark's examples above - "monitor all vCPUs on a
>> pCPU". I think it'll be quite expensive to figure out which threads from
>> a given pool are vCPUs.
>
> I'm not sure I follow why you would need to do that?
>
> In that case, we'd open a CPU-bound perf event for the pCPU, which would
> get installed in the CPU context immediately. It would be present for
> all tasks.
>
> Given it's present for all tasks, we don't need to figure out which
> happen to have vCPUs. The !vCPU tasks simply shouldn't trigger events.
>
> Am I missing something?

When enabling a CPU-bound event for pCPU, we'd have to enable trapping
of TLB operations for the vCPUs running on pCPU. Have a look at Patch
7/9.

Also, we'd have to enable/disable trapping when tasks are migrated
between pCPUs.

>
>> For the other instances, we only need to find the vCPU for a given
>> pid. Userspace will hand us a pid that needs to be checked against vCPUs
>> to establish that it is a valid vCPU pid (here I was looking to use
>> kvm_vcpu->pid and kvm->pid introduced in Patch 2).
>
> Thinking about this further, a pid is not a unique identifier for either
> a vCPU or a VM.
>
> A single task (which has a single pid), could own multiple VMs, each
> with multiple vCPUs. A thread pool (with several pids) could share those
> arbitrarily. So we need VM and vCPU IDs which are distinct from pids or
> tids.
>
> I see that struct kvm_vcpu has a vcpu_id (which from a glance appears to
> be local to the kvm instance). It's not clear to me if a kvm instance
> could be shared by multiple processes, or if we can get away with a
> process-local ID.

So far I've assumed that a VM pid is immutable. If that doesn't hold
then we need to think of another mechanism to refer to a VM from
userspace.

>
> Thanks, Mark.  _______________________________________________ kvmarm
>mailing list kvmarm@lists.cs.columbia.edu
>https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
