From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/3] arm/arm64: KVM: Fix arch timer behavior for disabled
 interrupts
Date: Sat, 17 Oct 2015 23:50:42 +0200
Message-ID: <20151017215042.GA1348@cbox>
References: <1445113822-7831-1-git-send-email-christoffer.dall@linaro.org>
 <1445113822-7831-2-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 301BF4141D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Oct 2015 17:47:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4iFEYrHKlV0v for <kvmarm@lists.cs.columbia.edu>;
 Sat, 17 Oct 2015 17:47:51 -0400 (EDT)
Received: from mail-lb0-f182.google.com (mail-lb0-f182.google.com
 [209.85.217.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CEDD412ED
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Oct 2015 17:47:50 -0400 (EDT)
Received: by lbcao8 with SMTP id ao8so119802368lbc.3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Oct 2015 14:50:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1445113822-7831-2-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Oct 17, 2015 at 10:30:20PM +0200, Christoffer Dall wrote:
> We have an interesting issue when the guest disables the timer interrupt
> on the VGIC, which happens when turning VCPUs off using PSCI, for
> example.
> 
> The problem is that because the guest disables the virtual interrupt at
> the VGIC level, we never inject interrupts to the guest and therefore
> never mark the interrupt as active on the physical distributor.  The
> host also never takes the timer interrupt (we only use the timer device
> to trigger a guest exit and everything else is done in software), so the
> interrupt does not become active through normal means.
> 
> The result is that we keep entering the guest with a programmed timer
> that will always fire as soon as we context switch the hardware timer
> state and run the guest, preventing forward progress for the VCPU.
> 
> Since the active state on the physical distributor is really part of the
> timer logic, it is the job of our virtual arch timer driver to manage
> this state.
> 
> The timer->map->active boolean field indicates whether we have signalled
> this interrupt to the vgic and if that interrupt is still pending or
> active.  As long as that is the case, the hardware doesn't have to
> generate physical interrupts and therefore we mark the interrupt as
> active on the physical distributor.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Reported-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
Marc was worried about the performance implications of this fix on
Mustang given the potentially slow MMIO path to the GIC on that system,
so I ran some before and after applying this series:

BM	Hackbench	Kernbench	PbZip C		PbZip D
--	---------	---------	-------		-------
Before	17.94		51.66		17.69		10.59
After	18.14		51.62		17.82		10.62

The slight increase on hackbench is well within the variability (1.409
for the 8 runs behind these numbers) so I don't think this will be
noticable.  That said, there's room for optimizations here by only
touching the GIC on vcpu load/put and when the value changes, but I
think this is premature.

-Christoffer
