From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: Live migration sequence
Date: Tue, 13 Oct 2015 12:05:27 +0100
Message-ID: <20151013110527.GB2555@work-vm>
References: <008b01d101be$0228d720$067a8560$@samsung.com>
	<20151009152942.GF2702@work-vm>
	<00b801d1059e$d6d4ffb0$847eff10$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <00b801d1059e$d6d4ffb0$847eff10$@samsung.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: peter.maydell@linaro.org, quintela@redhat.com, marc.zyngier@arm.com, 'QEMU' <qemu-devel@nongnu.org>, amit.shah@redhat.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

* Pavel Fedin (p.fedin@samsung.com) wrote:
>  Hello!
> 
>  Sorry for the delayed reply.

> > What's an ITS ?
> 
>  Interrupt Translation Service. In a short, it's a thing responsible for handling PCIe MSI-X
> interrupts on ARM64 architecture.

OK; I asked Peter (cc'd) to explain a bit more about the ITS to me.

> > With a related question, how big are the tables and can it change during the iterated part
> > of the migrate?
> 
>  Tables are something like 64K each. They hold mappings between device/event IDs and actual IRQ
> numbers.
>
>  Unfortunately i don't know how to answer the second part of the question, about iterated part. Can
> you explain in details, what is it and how does it work?

QEMU migrates stuff in two different ways:
   a) Like a device where at the end of the migration it transmits all the information
   b) Like RAM, (iterated) - in this it sends the contents across but does this while the guest
     is still running, changes that are made to the RAM are then transmitted over and over again
     until the amount of changed RAM is small; then we stop the guest, transmit those last few
     changes and then do (a).

>  Or, well, we could put the question the other way: imagine that in pre_save i tell my emulated
> device to flush its cached state into RAM-based tables. In post_load i could tell the device to
> re-read data from RAM into its cache. So, what do i need in order to make these tables in RAM to
> migrate correctly?

At 64k that's pretty small; however Peter explained to me that's per-cpu so that potentially
could be huge.  If it was only small I'd do it just like a device which is nice
and simple; but since it can get big then it's going to be more interesting, and
since it's part of guest RAM you need to be careful.

The pre_load/post_load are all relative to a particular device; they're
not hooked around when other stuff (RAM) gets migrated; it sounds like you
need another hook.

If I understand correctly what you need is to find a hook to dump the state
into guest ram, but then you also need to keep the state updated in guest
RAM during the migration.

Some thoughts:
  a) There is a migration state notifier list - see add_migration_state_change_notifier (spice calls it)
     - but I don't think it's called in the right places for your needs;  we
     could add some more places that gets called.

  b) Once you're in the device state saving (a above) you must not change guest RAM,
     because at that point the migration code won't send any new changes across
     to the destination. So any sync's you're going to do have to happen before/at
     the time we stop the CPU and do the final RAM sync.  On the plus side, when
     you're loading the device state in (a) you can be sure the RAM contents are there.

  c) Watch out for the size of that final sync; if you have lots of these ITS
     and they all update their 64k page at the point we stop the CPU then you're
     going to generate a lot of RAM that needs syncing.

Dave

> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
