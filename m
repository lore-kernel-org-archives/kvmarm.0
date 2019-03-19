From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Enable direct irqfd MSI injection
Date: Tue, 19 Mar 2019 10:01:41 +0000
Message-ID: <20190319100141.69821f8b@why.wild-wind.fr.eu.org>
References: <1552833373-19828-1-git-send-email-yuzenghui@huawei.com>
 <86o969z42z.wl-marc.zyngier@arm.com>
 <428b2aac-5a0f-e9da-8d74-8045f99a8c74@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE90A4A41E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 06:01:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k8oQw5j9eyZU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Mar 2019 06:01:53 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54BE94A41B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 06:01:53 -0400 (EDT)
In-Reply-To: <428b2aac-5a0f-e9da-8d74-8045f99a8c74@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: mst@redhat.com, kvm@vger.kernel.org, "Raslan,
 KarimAllah" <karahmed@amazon.de>, andre.przywara@arm.com, linux-kernel@vger.kernel.org, guoheyi@huawei.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 19 Mar 2019 09:09:43 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> Hi all,
> 
> On 2019/3/18 3:35, Marc Zyngier wrote:
> > On Sun, 17 Mar 2019 14:36:13 +0000,
> > Zenghui Yu <yuzenghui@huawei.com> wrote:  
> >>
> >> Currently, IRQFD on arm still uses the deferred workqueue mechanism
> >> to inject interrupts into guest, which will likely lead to a busy
> >> context-switching from/to the kworker thread. This overhead is for
> >> no purpose (only in my view ...) and will result in an interrupt
> >> performance degradation.
> >>
> >> Implement kvm_arch_set_irq_inatomic() for arm/arm64 to support direct
> >> irqfd MSI injection, by which we can get rid of the annoying latency.
> >> As a result, irqfd MSI intensive scenarios (e.g., DPDK with high packet
> >> processing workloads) will benefit from it.
> >>
> >> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> >> ---
> >>
> >> It seems that only MSI will follow the IRQFD path, did I miss something?
> >>
> >> This patch is still under test and sent out for early feedback. If I have
> >> any mis-understanding, please fix me up and let me know. Thanks!  
> > 
> > As mentioned by other folks in the thread, this is clearly wrong. The
> > first thing kvm_inject_msi does is to lock the corresponding ITS using
> > a mutex. So the "no purpose" bit was a bit too quick.
> > 
> > When doing this kind of work, I suggest you enable lockdep and all the
> > related checkers. Also, for any optimisation, please post actual
> > numbers for the relevant benchmarks. Saying "application X will
> > benefit from it" is meaningless without any actual data.
> >   
> >>
> >> ---
> >>   virt/kvm/arm/vgic/trace.h      | 22 ++++++++++++++++++++++
> >>   virt/kvm/arm/vgic/vgic-irqfd.c | 21 +++++++++++++++++++++
> >>   2 files changed, 43 insertions(+)
> >>
> >> diff --git a/virt/kvm/arm/vgic/trace.h b/virt/kvm/arm/vgic/trace.h
> >> index 55fed77..bc1f4db 100644
> >> --- a/virt/kvm/arm/vgic/trace.h
> >> +++ b/virt/kvm/arm/vgic/trace.h
> >> @@ -27,6 +27,28 @@
> >>   		  __entry->vcpu_id, __entry->irq, __entry->level)
> >>   );  
> >>   >> +TRACE_EVENT(kvm_arch_set_irq_inatomic,  
> >> +	TP_PROTO(u32 gsi, u32 type, int level, int irq_source_id),
> >> +	TP_ARGS(gsi, type, level, irq_source_id),
> >> +
> >> +	TP_STRUCT__entry(
> >> +		__field(	u32,	gsi		)
> >> +		__field(	u32,	type		)
> >> +		__field(	int,	level		)
> >> +		__field(	int,	irq_source_id	)
> >> +	),
> >> +
> >> +	TP_fast_assign(
> >> +		__entry->gsi		= gsi;
> >> +		__entry->type		= type;
> >> +		__entry->level		= level;
> >> +		__entry->irq_source_id	= irq_source_id;
> >> +	),
> >> +
> >> +	TP_printk("gsi %u type %u level %d source %d", __entry->gsi,
> >> +		  __entry->type, __entry->level, __entry->irq_source_id)
> >> +);
> >> +
> >>   #endif /* _TRACE_VGIC_H */  
> >>   >>   #undef TRACE_INCLUDE_PATH  
> >> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
> >> index 99e026d..4cfc3f4 100644
> >> --- a/virt/kvm/arm/vgic/vgic-irqfd.c
> >> +++ b/virt/kvm/arm/vgic/vgic-irqfd.c
> >> @@ -19,6 +19,7 @@
> >>   #include <trace/events/kvm.h>
> >>   #include <kvm/arm_vgic.h>
> >>   #include "vgic.h"
> >> +#include "trace.h"  
> >>   >>   /**  
> >>    * vgic_irqfd_set_irq: inject the IRQ corresponding to the
> >> @@ -105,6 +106,26 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> >>   	return vgic_its_inject_msi(kvm, &msi);
> >>   }  
> >>   >> +/**  
> >> + * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
> >> + *
> >> + * Currently only direct MSI injecton is supported.
> >> + */
> >> +int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
> >> +			      struct kvm *kvm, int irq_source_id, int level,
> >> +			      bool line_status)
> >> +{
> >> +	int ret;
> >> +
> >> +	trace_kvm_arch_set_irq_inatomic(e->gsi, e->type, level, irq_source_id);
> >> +
> >> +	if (unlikely(e->type != KVM_IRQ_ROUTING_MSI))
> >> +		return -EWOULDBLOCK;
> >> +
> >> +	ret = kvm_set_msi(e, kvm, irq_source_id, level, line_status);
> >> +	return ret;
> >> +}
> >> +  
> > 
> > Although we've established that the approach is wrong, maybe we can
> > look at improving this aspect.
> > 
> > A first approach would be to keep a small cache of the last few
> > successful translations for this ITS, cache that could be looked-up by
> > holding a spinlock instead. A hit in this cache could directly be
> > injected. Any command that invalidates or changes anything (DISCARD,
> > INV, INVALL, MAPC with V=0, MAPD with V=0, MOVALL, MOVI) should nuke
> > the cache altogether.
> > 
> > Of course, all of that needs to be quantified.  
> 
> Thanks for all of your explanations, especially for Marc's suggestions!
> It took me long time to figure out my mistakes, since I am not very
> familiar with the locking stuff. Now I have to apologize for my noise.

No need to apologize. The whole point of this list is to have
discussions. Although your approach wasn't working, you did
identify potential room for improvement.

> As for the its-translation-cache code (a really good news to us), we
> have a rough look at it and start testing now!

Please let me know about your findings. My initial test doesn't show
any improvement, but that could easily be attributed to the system I
running this on (a tiny and slightly broken dual A53 system). The sizing
of the cache is also important: too small, and you have the overhead of
the lookup for no benefit; too big, and you waste memory.

Having thought about it a bit more, I think we can drop the
invalidation on MOVI/MOVALL, as the LPI is still perfectly valid, and
we don't cache the target vcpu. On the other hand, the cache must be
nuked when the ITS is turned off.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
