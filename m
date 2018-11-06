From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: Timekeeping on ARM guests/hosts
Date: Tue, 6 Nov 2018 08:45:23 +0100
Message-ID: <20181106074523.GC12057@e113682-lin.lund.arm.com>
References: <cd4eeb25-50c6-329d-d6e8-26caf478a041@arm.com>
 <CAHSjozBtan6L7eWypnB_aACqHSrBAykjU8LcxfM3Pv3QMSZnJw@mail.gmail.com>
 <86lg74ude3.wl-marc.zyngier@arm.com>
 <8088f91a-1a56-065d-1c8e-f9eccbb1b342@redhat.com>
 <CAHSjozB1jQp4L==jx8pn222T7O991-d0H3Cd-5JPtJqQ8zQHAA@mail.gmail.com>
 <59a6562e-ad8d-3bf3-cde8-4ff9c8997c95@arm.com>
 <CAHSjozCGbjAfEuhKtJyCSqw5ByTgY3b9r=5smXGv_v0PBLerOQ@mail.gmail.com>
 <20181102143431.GZ12057@e113682-lin.lund.arm.com>
 <CAHSjozAJ0_W0o3865HsCVndgfr209h9uqeuUK1=Lx1+9m18eUw@mail.gmail.com>
 <CAHSjozD-5K3SgL8hxFh+hU3rUOZ9s=duFpj56jQ39VEBUdeXSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A15EA4A32B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 02:45:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sg00esMkKwk3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Nov 2018 02:45:27 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 341A44A32A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Nov 2018 02:45:27 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CAHSjozD-5K3SgL8hxFh+hU3rUOZ9s=duFpj56jQ39VEBUdeXSQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Miriam Zimmerman <mutexlox@google.com>
Cc: marc.zyngier@arm.com, lersek@redhat.com, steven.price@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 02, 2018 at 02:23:45PM -0700, Miriam Zimmerman wrote:
> In researching KVM_REG_ARM_TIMER_CNT, I discovered your commit 4b7a6bf
> ("target-arm: kvm: Differentiate registers based on write-back
> levels"), which seems to limit when the KVM_REG_ARM_TIMER_CNT is used
> to save time. Under what circumstances should this be saved in order
> to provide a consistent view of wall clock time (as given by `date` in
> the VM)? 

In general, and not specific to QEMU, I think that the virtual
counter value should stop counting when the entirety of the VM is not
running, for example when the host machine is suspended, or when the
entire VM is stopped/suspended, either as part of a suspend/resume
operation, debug operation, or as part of migration of some sort.

Supporting these timekeeping semantics is not something anyone has tried
up until now with KVM/Arm, as far as I'm aware, and as such is 'new'
work.


> The commit refers to 'machine initialization or on vmload
> operations', but I'm having difficulty figuring out what a vmload
> operation is on ARM. Does this include resume-from-sleep/suspend?

I believe vmload is qemu-speak for loading in VM state from a stored
migration stream, but you'd have to ask the QEMU folks or study the code
more carefully to figure out when a vmload really happens.

Thanks,

    Christoffer

> On Fri, Nov 2, 2018 at 11:28 AM Miriam Zimmerman <mutexlox@google.com> wrote:
> >
> > On Fri, Nov 2, 2018 at 7:34 AM Christoffer Dall
> > <christoffer.dall@arm.com> wrote:
> > >
> > > On Wed, Oct 31, 2018 at 11:49:05AM -0700, Miriam Zimmerman wrote:
> > >
> > > [...]
> > >
> > > >
> > > > > CONFIG_KVM_GUEST fixes this by providing the guest with information on
> > > > > the host time and informs it when the guest is paused (see
> > > > > MSR_KVM_SYSTEM_TIME_NEW). Arm doesn't (yet) have para-virtualised time.
> > > > >
> > > > > On Arm, as far as I know, the guest's view of time is purely from the
> > > > > virtual counter. Since nothing saves/restores this during the pause, the
> > > > > counter continues to increment and the jump in time is visible to the guest.
> > > > What is this virtual counter? How can one configure or enable it?
> > >
> > > The 'virtual counter' is an architectural concept in the Arm
> > > architecture, not a virtual (in the software VM sense) counter.
> > >
> > > The Arm Generic Timer Architecture defines two counters:
> > >  - The physical counter, accessed via CNTPCT_EL0
> > >  - The virtual counter, accessed via CNTVCT_EL0
> > >
> > > And a number of timers.  All timers are associated with the physical
> > > counter, except the 'EL1 Virtual Timer' which uses the count in the
> > > virtual counter for its comparison.
> > >
> > > The virtual counter yields the value of the physical counter minus an
> > > offset.
> > >
> > > That offset is controlled by a hypervisor running at EL2 which can
> > > program the offset value in CNTVOFF_EL2.
> > >
> > > The basic idea is that a VM can use the virtual timer/counter to keep
> > > track of some notion of virtual time, and the physical timer/counter to
> > > keep track of something that always relates to wall-clock time.
> > >
> > > This all breaks quite horribly with migration where the physical counter
> > > is not meaningful across physical systems, and where the counter
> > > frequencies can vary.
> > >
> > > But we can use the offset for the virtual counter to communicate some
> > > other measure of time to VMs.
> >
> > That makes sense. Thanks for the primer! I haven't done any ARM kernel
> > work before, so this is all great to know.
> >
> > > > My understanding of what's going on now is that the guest kernel right
> > > > now has roughly no awareness that it's inside of a VM, so it just
> > > > tracks time using the assumption that it is native and is unaware that
> > > > the host ever suspends. (It just doesn't see any CPU time then.)
> > > >
> > > > >
> > > > > Whether the guest sees time progress depends on what happens to that
> > > > > counter during suspend. kvmtool pause/resume simply prevents the vCPU
> > > > > threads from continuing, but the system counter is still running.
> > > > >
> > > > > If you save the state of a VM to a file then the counter value is
> > > > > saved/restored so the guest won't see any change in time.
> > > > I don't believe that we're explicitly saving any state to a file on
> > > > suspend right now, though I could be wrong; I haven't looked into that
> > > > codepath yet.
> > >
> > > The key is whether the userspace program that controls the KVM VM
> > > (kvmtool, QEMU, crosvm) uses the KVM_REG_ARM_TIMER_CNT ioctl to save the
> > > VM view of virtual time, and to retore that at a later time.
> > >
> > > KVM adjusts the CNTVOFF_EL2 for the VM on which the ioctl is executed to
> > > represent the value written by userspace to the VM when the VM reads
> > > CNTVCT_EL0.
> > >
> >
> > Ah hah. I haven't looked yet, but I bet this is the missing piece.
> > Thanks very much, Christoffer!
> >
> > >
> > > Thanks,
> > >
> > >     Christoffer
