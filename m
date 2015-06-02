From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] arm/arm64: KVM: Properly account for guest CPU time
Date: Tue, 2 Jun 2015 11:28:56 +0200
Message-ID: <20150602092856.GB7783@cbox>
References: <1432838950-28774-1-git-send-email-christoffer.dall@linaro.org>
 <556C0E22.9090401@de.ibm.com> <20150601090817.GA18722@cbox>
 <556C240F.5070501@de.ibm.com> <20150601133558.GA20286@cbox>
 <556C601C.4000501@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1397952C57
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jun 2015 05:18:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hQwixzOiAi20 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Jun 2015 05:18:20 -0400 (EDT)
Received: from mail-la0-f50.google.com (mail-la0-f50.google.com
 [209.85.215.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E0BA52C51
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jun 2015 05:18:19 -0400 (EDT)
Received: by laei3 with SMTP id i3so33006187lae.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Jun 2015 02:28:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <556C601C.4000501@de.ibm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 01, 2015 at 03:37:32PM +0200, Christian Borntraeger wrote:
> Am 01.06.2015 um 15:35 schrieb Christoffer Dall:
> > On Mon, Jun 01, 2015 at 11:21:19AM +0200, Christian Borntraeger wrote:
> >> Am 01.06.2015 um 11:08 schrieb Christoffer Dall:
> >>
> >>>>>
> >>>>> Second, looking at the ppc and mips code, they seem to also call
> >>>>> kvm_guest_exit() before enabling interrupts, so I don't understand how
> >>>>> guest CPU time accounting works on those architectures.
> >>>>
> >>>> Not an expert here, but I assume mips has the same logic as arm so if your
> >>>> patch is right for arm its probably also for mips.
> >>>>
> >>>> powerpc looks similar to what s390 does (not using the tick, instead it uses
> >>>> a hw-timer) so this should be fine.
> >>>>
> >>> I wonder if we can simply enable HAVE_VIRT_CPU_ACCOUNTING_GEN and get
> >>> this for free which would avoid the need for this patch?
> >>
> >> Asssuming that HAVE_VIRT_CPU_ACCOUNTING_GEN behaves similar to 
> >> HAVE_VIRT_CPU_ACCOUNTING on s390/power in respect to not rely on ticks
> >> - yes it might work out. Can you give it a try?
> >>
> > Adding HAVE_VIRT_CPU_ACCOUNTING_GEN to arch/arm64/Kconfig works, but has
> > no effect unless you also enable CONFIG_NO_HZ_FULL, so that hardly feels
> > like a fix since it would be a shame to force users to use this config
> > option to report CPU usage correctly.
> > 
> > I'm not entirely sure what the history and meaning behind these configs
> > are, so maybe there is an entirely different rework needed here.  It
> > seems logical that you could simply sample the counter at entry/exit of
> > the guest, but if there is nowhere to store this data without
> > NO_HZ_FULL+VIRT_CPU_ACCOUNTING_GEN then I guess that would be why?
> 
> Given Paolos response that irq_disable/enable is faster than save/restore
> at least on x86 your v2 patch might actually be the right thing to do.
> 
Thanks, I think so too, but we should enable
HAVE_VIRT_CPU_ACCOUNTING_GEN for arm64 as well, assuming there are no
mysterious side affects of doing so.

-Christoffer
