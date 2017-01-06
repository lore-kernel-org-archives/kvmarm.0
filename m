From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 0/7] KVM: arm/arm64: Optimize arch timer register
 handling
Date: Fri, 6 Jan 2017 11:01:47 +0100
Message-ID: <20170106100147.GC21089@cbox>
References: <20161210204712.21830-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27E6C404E4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jan 2017 05:00:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uXSCSkG8ne77 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jan 2017 05:00:13 -0500 (EST)
Received: from mail-lf0-f53.google.com (mail-lf0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FFA24048E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jan 2017 05:00:11 -0500 (EST)
Received: by mail-lf0-f53.google.com with SMTP id d16so49474035lfb.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Jan 2017 02:01:49 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161210204712.21830-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Dec 10, 2016 at 09:47:05PM +0100, Christoffer Dall wrote:
> We currently spend around ~400 cycles on each entry/exit to the guest
> dealing with arch timer registers, even when the timer is not pending
> and not doing anything.
> 
> We can do much better by moving the arch timer save/restore to the
> vcpu_load and vcpu_put functions, but this means that if we don't read
> back the timer state on every exit from the guest, then we have to be
> able to start taking timer interrupts for the virtual timer in KVM and
> handle that properly.
> 
> That has a number of funny consequences, such as having to make sure we
> don't deadlock between any of the vgic code and interrupt injection
> happening from an ISR.  On the plus side, being able to inject
> virtual interrupts corresponding to a physical interrupt directly from
> an ISR is probably a good system design change.
> 
> We also have to change the use of the physical vs. virtual counter in
> the arm64 kernel to avoid having to save/restore the CNTVOFF_EL2
> register on every return to the hypervisor.  The only reason I could
> find for using the virtual counter for the kernel on systems with access
> to the physical counter is to detect if firmware did not properly clear
> CNTVOFF_EL2, and this change has to weighed against the existing check
> (assuming I got this right).
> 
> On a non-VHE system (AMD Seattle) I have measured this to improve the
> world-switch time by about ~100 cycles, but on an EL2 kernel (emulating
> VHE behavior on the same hardware) this gives us around ~250 cycles
> worth of improvement, because we can avoid the extra configuration of
> trapping accesses to the physical timer from EL1 on every switch.
> 
> I'm not sure if the benefits outweigh the complexity of this patch set,
> nor am I sure if I'm missing an overall better approach, hence the RFC
> tag on the series.
> 
> I'm looking forward to overall comments on the approach.
> 

FYI for anyone looking at these patches, I found some issues with the
series and will respin shortly.  Patch 5 has also been split to
hopefully simplify the review, as I realized it is horrible to look at
in its current form.

Thanks,
-Christoffer
