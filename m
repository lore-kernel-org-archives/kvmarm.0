From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: Live migration sequence
Date: Fri, 16 Oct 2015 18:11:00 +0100
Message-ID: <20151016171100.GJ2622@work-vm>
References: <008b01d101be$0228d720$067a8560$@samsung.com>
	<20151009152942.GF2702@work-vm>
	<00b801d1059e$d6d4ffb0$847eff10$@samsung.com>
	<20151013110527.GB2555@work-vm>
	<00b201d107e3$ac36acd0$04a40670$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <00b201d107e3$ac36acd0$04a40670$@samsung.com>
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
> > Some thoughts:
> >   a) There is a migration state notifier list - see add_migration_state_change_notifier (spice
> > calls it)
> >      - but I don't think it's called in the right places for your needs;  we
> >      could add some more places that gets called.
> 
>  I am now trying to add one more state, something like MIGRATION_STATUS_FINISHING. It would mean that CPUs are stopped.
>  Can you explain me migration code a bit? Where is iteration loop, and where are CPUs stopped? I am looking at migration.c but
> cannot say that i understand some good portion of it. :)

The outgoing side of migration comes into migrate_fd_connect which does
all the setup and then starts 'migration_thread'.  The big while loop in there does
most of the work, and on each loop normally ends up calling either
   qemu_savevm_state_iterate
or
  migration_completion

migration_completion calls vm_stop_force_state to stop the CPU,
and then qemu_savevm_state_complete to save all the remaining devices
out.

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
