From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 3/3] arm64/sve: KVM: Avoid dereference of dead task
 during guest entry
Date: Tue, 5 Dec 2017 12:40:28 +0000
Message-ID: <20171205124028.GY22781@e103592.cambridge.arm.com>
References: <1512141582-17474-1-git-send-email-Dave.Martin@arm.com>
 <1512141582-17474-4-git-send-email-Dave.Martin@arm.com>
 <CAKv+Gu_e3SKsreYHrZEBUMEME-pYtxTXW1P6xLUR6YMQfj0cZw@mail.gmail.com>
 <20171204153648.GV22781@e103592.cambridge.arm.com>
 <20171205094350.GJ32397@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1482849D1F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Dec 2017 07:37:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T6RTHMRJdbmf for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Dec 2017 07:37:22 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EB0B406D0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Dec 2017 07:37:22 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171205094350.GJ32397@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 05, 2017 at 10:43:50AM +0100, Christoffer Dall wrote:
> Hi Dave,
> 
> On Mon, Dec 04, 2017 at 03:36:50PM +0000, Dave Martin wrote:
> > On Mon, Dec 04, 2017 at 01:53:21PM +0000, Ard Biesheuvel wrote:
> > > On 1 December 2017 at 15:19, Dave Martin <Dave.Martin@arm.com> wrote:
> > > > When deciding whether to invalidate FPSIMD state cached in the cpu,
> > > > the backend function sve_flush_cpu_state() attempts to dereference
> > > > __this_cpu_read(fpsimd_last_state).  However, this is not safe:
> > > > there is no guarantee that the pointer is still valid, because the
> > > > task could have exited in the meantime.  For this reason, this
> > > > percpu pointer should only be assigned or compared, never
> > > > dereferenced.
> > > >
> > > 
> > > Doesn't that mean the pointer could also be pointing to the
> > > fpsimd_state of a newly created task that is completely unrelated?
> > > IOW, are you sure comparison is safe?
> > 
> > There are more conditions: the only place the determination is
> > made is for next, in fpsimd_thread_switch(next).
> > 
> > 
> > However, I can see your concern and I'm not sure how/if it is
> > resolved.
> > 
> > For the worst case, let's assume that some child forks off but
> > doesn't enter userspace yet, while another task round-robins
> > across all CPUs, interspersed with tasks that don't enter userspace.
> > 
> > So, we end up with
> > 
> > All cpu < NR_CPUS . per_cpu(fpsimd_last_state, cpu) == T.
> > 
> > Now, if T dies and a new task is allocated the same task_struct pointer,
> > then the _new_ T is guaranteed to get scheduled in on a CPU whose
> > per_cpu(fpsmid_last_state) == T.
> > 
> > Thus, new T can pick up old T's regs _unless_ new T's fpsimd_state.cpu
> > is invalid (i.e., NR_CPUS).
> > 
> > This is a separate bug from the one addressed by this patch though.
> > We can't go and harvest the bad pointers when old T exits, because
> > this might race new T being scheduled for real -- in any case it
> > would involve iterating over all CPUs which sounds racy and
> > inefficient.
> > 
> > 
> > So, I'd say we _must_ call fpsimd_flush_task_state() for every new
> > task.  This may result in a redundant reload of the state, but this
> > is what would happen anyway if the pointers did not alias.
> > 
> > Does this sound real to you?  If so, I'll try to write something.
> > 
> > And does this patch look reasonable to fix what it's trying to fix?
> > 
> > 
> > I wonder whether arch/arm has the same bug actually, since the kernel-
> > mode NEON logic was modelled from there IIUC (?)
> > 
> Isn't this the common kernel problem of pid reuse?

It's a problem of <task identifier> reuse, so sort of.

> It seems holding a reference to a struct pid would solve your problems.
> See include/linux/pid.h.
> 
> That might also make the code more intuitive and prevent future attempts
> of dereferencing potentially dead data structures.

If we want use the same mechanism to track fpsimd contexts that are not
user task contexts in the future, then that wouldn't work.

In particular, I'd like to track vcpu fpsimd contexts in the same way
as task fpsimd contexts in the future: having two different mechanisms
adds cruft and inefficiency and/or bugs.


I'll look at the struct pid thing and have a think.

Cheers
---Dave
