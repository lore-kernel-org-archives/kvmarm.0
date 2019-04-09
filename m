From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v12 2/8] arm64: KVM: encapsulate kvm_cpu_context in
 kvm_host_data
Date: Tue, 9 Apr 2019 11:52:29 +0100
Message-ID: <20190409105228.GA25919@e119886-lin.cambridge.arm.com>
References: <20190328103731.27264-1-andrew.murray@arm.com>
 <20190328103731.27264-3-andrew.murray@arm.com>
 <387fe2b5-683d-f5a4-9aec-f621292429ba@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41F044A3BF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 06:52:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2mR0KuXEnxH6 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Apr 2019 06:52:33 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E23E24A380
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 06:52:32 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <387fe2b5-683d-f5a4-9aec-f621292429ba@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 28, 2019 at 03:28:37PM +0000, Suzuki K Poulose wrote:
> On 03/28/2019 10:37 AM, Andrew Murray wrote:
> > The virt/arm core allocates a kvm_cpu_context_t percpu, at present this is
> > a typedef to kvm_cpu_context and is used to store host cpu context. The
> > kvm_cpu_context structure is also used elsewhere to hold vcpu context.
> > In order to use the percpu to hold additional future host information we
> > encapsulate kvm_cpu_context in a new structure and rename the typedef and
> > percpu to match.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >   arch/arm/include/asm/kvm_host.h   |  8 ++++++--
> >   arch/arm64/include/asm/kvm_asm.h  |  3 ++-
> >   arch/arm64/include/asm/kvm_host.h | 16 ++++++++++------
> >   arch/arm64/kernel/asm-offsets.c   |  1 +
> >   virt/kvm/arm/arm.c                | 14 ++++++++------
> >   5 files changed, 27 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index 770d73257ad9..427c28be6452 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -150,7 +150,11 @@ struct kvm_cpu_context {
> >   	u32 cp15[NR_CP15_REGS];
> >   };
> > -typedef struct kvm_cpu_context kvm_cpu_context_t;
> > +struct kvm_host_data {
> > +	struct kvm_cpu_context host_ctxt;
> > +};
> > +
> > +typedef struct kvm_host_data kvm_host_data_t;
> >   static inline void kvm_init_host_cpu_context(kvm_cpu_context_t *cpu_ctxt,
> >   					     int cpu)
> 
> We need to fix this function prototype to accept struct kvm_cpu_context,
> instead of the now removed kvm_cpu_context_t, to prevent a build break
> on arm32 ?

Yes this was a breakage, thanks for pointing this out.

Thanks,

Andrew Murray

> 
> With that :
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
