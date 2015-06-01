From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] arm/arm64: KVM: Properly account for guest CPU time
Date: Mon, 1 Jun 2015 11:08:17 +0200
Message-ID: <20150601090817.GA18722@cbox>
References: <1432838950-28774-1-git-send-email-christoffer.dall@linaro.org>
 <556C0E22.9090401@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <556C0E22.9090401@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 01, 2015 at 09:47:46AM +0200, Christian Borntraeger wrote:
> Am 28.05.2015 um 20:49 schrieb Christoffer Dall:
> > Until now we have been calling kvm_guest_exit after re-enabling
> > interrupts when we come back from the guest, but this has the
> > unfortunate effect that CPU time accounting done in the context of timer
> > interrupts occurring while the guest is running doesn't properly notice
> > that the time since the last tick was spent in the guest.
> 
> Can you verify that a CPU bound guest has almost zero guest time?
> Assuming that your answer is "yes" your patch make sense as host
> timer interrupts should be the only reasons for guest exits then.
> 

Yes, 'cat /dev/urandom > /dev/null' in the guest shows up as 100% sys in
mpstat on the host, 0% guest.

> 
> > Inspired by the comment in the x86 code, move the kvm_guest_exit() call
> > below the local_irq_enable() call and change __kvm_guest_exit() to
> > kvm_guest_exit(), because we are now calling this function with
> > interrupts enabled.  We have to now explicitly disable preemption and
> > not enable preemption before we've called kvm_guest_exit(), since
> > otherwise we could be preempted and everything happening before we
> > eventually get scheduled again would be accounted for as guest time.
> > 
> > At the same time, move the trace_kvm_exit() call outside of the atomic
> > section, since there is no reason for us to do that with interrupts
> > disabled.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> > This patch is based on kvm/queue, because it has the kvm_guest_enter/exit
> > rework recently posted by Christian Borntraeger.  I hope I got the logic
> > of this right, there were 2 slightly worrying facts about this:
> > 
> > First, we now enable and disable and enable interrupts on each exit
> > path, but I couldn't see any performance overhead on hackbench - yes the
> > only benchmark we care about.
> 
> This should be somewhat similar to the situation before my patch.
> There it was
> 
> 1: "disable", "guest", "disable again and save", "restore to disable", "enable"
> and now it is
> 2: "disable", "guest", "enable"
> and with your patch it is
> 3: "disable", "guest", "enable", "disable, "enable"
> 
> I assume that 3 and 1 are similar in its costs, so this is probably ok.
> 
> 
> > 
> > Second, looking at the ppc and mips code, they seem to also call
> > kvm_guest_exit() before enabling interrupts, so I don't understand how
> > guest CPU time accounting works on those architectures.
> 
> Not an expert here, but I assume mips has the same logic as arm so if your
> patch is right for arm its probably also for mips.
> 
> powerpc looks similar to what s390 does (not using the tick, instead it uses
> a hw-timer) so this should be fine.
> 
I wonder if we can simply enable HAVE_VIRT_CPU_ACCOUNTING_GEN and get
this for free which would avoid the need for this patch?

Thanks,
-Christoffer
