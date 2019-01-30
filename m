From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 1/5] KVM: arm/arm64: Reset the VCPU without preemption
 and vcpu state loaded
Date: Wed, 30 Jan 2019 10:22:12 +0100
Message-ID: <20190130092212.GD13482@e113682-lin.lund.arm.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-2-christoffer.dall@arm.com>
 <20190129154858.docsos3ncoyuld7m@kamzik.brq.redhat.com>
 <867eenv48q.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F9E4A32D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 04:22:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gwNg3MAZHQJb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Jan 2019 04:22:15 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B5F04A2E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Jan 2019 04:22:15 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <867eenv48q.wl-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 29, 2019 at 04:05:25PM +0000, Marc Zyngier wrote:
> Hi Drew,
> 
> On Tue, 29 Jan 2019 15:48:58 +0000,
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > Hi Christoffer,
> > 
> > On Fri, Jan 25, 2019 at 10:46:52AM +0100, Christoffer Dall wrote:
> > > Resetting the VCPU state modifies the system register state in memory,
> > > but this may interact with vcpu_load/vcpu_put if running with preemption
> > > disabled, which in turn may lead to corrupted system register state.
> >   ^ enabled
> > > 
> > > Address this by disabling preemption and doing put/load if required
> > > around the reset logic.
> > 
> > I'm having trouble understanding how disabling preemption helps here.
> > There shouldn't be an issue with the KVM_ARM_VCPU_INIT case, since the
> > target vcpu is guaranteed not to be loaded and therefore it doesn't
> > have preempt notifiers registered either. Also, KVM_ARM_VCPU_INIT holds
> > the vcpu mutex, so there's no chance for a load to occur until it's
> > complete.
> > 
> > For the PSCI case it makes sense to force a vcpu load after the reset,
> > otherwise the sleeping target vcpu won't have the correct state loaded.
> > The initial put also makes sense in case we're not resetting everything.
> > I don't understand how we're ensuring the target vcpu thread's preemption
> > is disabled though. This modified kvm_reset_vcpu would need to be run
> > from the target vcpu thread to work, but that's not how the PSCI code
> > currently does it.
> 
> And that's exactly where we're going with the following patch in the
> series. Ultimately, we need a vcpu to reset itself, as we otherwise
> have a window where a vcpu can be spuriously loaded whilst being
> reset.
> 
FWIW, I think the confusion here comes from having re-ordered the
patches compared to how the commit text was originally written.  We
should probably explain in the commit message that this is in
preparation for doing the reset from the VCPU itself.

Thanks,

    Christoffer
