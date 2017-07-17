From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: Handle hva aging while destroying the
 vm
Date: Mon, 17 Jul 2017 20:23:31 +0200
Message-ID: <20170717182331.GA14069@cbox>
References: <20170705085700.GA16881@e107814-lin.cambridge.arm.com>
 <f8794311-ddec-fdb4-9ef2-2e2c05ca7467@suse.de>
 <20170706074513.GC18106@cbox>
 <18e7012c-a095-ecfa-470c-cf81177698a1@arm.com>
 <20170706094205.GE18106@cbox>
 <5cb34cc0-27c1-c011-a8d4-c991e47141c3@arm.com>
 <20170716195658.GA31432@cbox>
 <e77266ae-6695-a1a2-f96a-b92c97a900c7@arm.com>
 <CAMJs5B-RVCTYOF6wb6A4Qt21cdcf+hLJLBbK5G9iMYbCven0SA@mail.gmail.com>
 <20170717151617.GC6344@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170717151617.GC6344@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>, Alexander Graf <agraf@suse.de>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stable <stable@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 17, 2017 at 05:16:17PM +0200, Andrea Arcangeli wrote:
> On Mon, Jul 17, 2017 at 04:45:10PM +0200, Christoffer Dall wrote:
> > I would also very much like to get to the bottom of this, and at the
> > very least try to get a valid explanation as to how a thread can be
> > *running* for a process where there are zero references to the struct
> > mm?
> 
> A thread shouldn't be possibly be running if mm->mm_users is zero.
> 

ok, good, then I don't have to re-take OS 101.

> > I guess I am asking where this mmput() can happen for a perfectly
> > running thread, which hasn't processes signals or exited itself yet.
> 
> mmput runs during exit(), after that point the vcpu can't run the KVM
> ioctl anymore.
> 

also very comforting that we agree on this.

> > The dump you reference above seems to indicate that it's happening
> > under memory pressure and trying to unmap memory from the VM to
> > allocate memory to the VM, but all seems to be happening within a VCPU
> > thread, or am I reading this wrong?
> 
> In the oops the pgd was none while KVM vcpu ioctl was running, the
> most likely explanation is there were two VM running in parallel in
> the host, and the other one was quitting (mm_count of the other VM was
> zero, while mm_count of the VM that oopsed within the vcpu ioctl was >
> 0). The oops information itself can't tell if there was one or two VM
> running in the host so > 1 VM running is the most plausible
> explanation that doesn't break the above in invariants.

That's very keenly observed, and a really good explanation.


> It'd be nice
> if Alexander can confirm it, if he remembers about that specific setup
> after a couple of months since it happened.

My guess is that this was observed on the suse build machines with
arm64, and Alex ususally explains that these machines run *lots* of VMs
at the same time, so this sounds very likely.

Alex, can you confirm this was the type of workload?

> 
> Even if there was just one VM running in the host, it would more
> likely mean something inside KVM ARM code is clearing the pgd before
> mm_users reaches zero, i.e. before the last mmput.

I don't think we have this.

> 
> It's very unlikely mm_users could have been > 0 while the vcpu thread
> was running as many more things would fall apart in such case, not
> just the needed pgd check during mmu notifier post process exit.
> 

That was my rationale exactly.  Thanks for confirming!

-Christoffer
