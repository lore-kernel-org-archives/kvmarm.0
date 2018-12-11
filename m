From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v7 2/5] arm64: KVM: encapsulate kvm_cpu_context in
 kvm_host_data
Date: Tue, 11 Dec 2018 13:11:50 +0000
Message-ID: <20181211131149.GF13393@e119886-lin.cambridge.arm.com>
References: <1544530420-1477-1-git-send-email-andrew.murray@arm.com>
 <1544530420-1477-3-git-send-email-andrew.murray@arm.com>
 <525c5c2f-5d09-6e36-8802-457791f93ac5@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04D3B4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 08:11:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Dz+lpKQVuKy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 08:11:53 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC6854A1DE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 08:11:52 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <525c5c2f-5d09-6e36-8802-457791f93ac5@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 11, 2018 at 12:40:51PM +0000, Suzuki K Poulose wrote:
> 
> 
> On 11/12/2018 12:13, Andrew Murray wrote:
> > The virt/arm core allocates a percpu structure as per the kvm_cpu_context_t
> > type, at present this is typedef'd to kvm_cpu_context and used to store
> > host cpu context. The kvm_cpu_context structure is also used elsewhere to
> > hold vcpu context. In order to use the percpu to hold additional future
> > host information we encapsulate kvm_cpu_context in a new structure.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >   arch/arm64/include/asm/kvm_host.h | 8 ++++++--
> >   arch/arm64/kernel/asm-offsets.c   | 3 ++-
> >   virt/kvm/arm/arm.c                | 4 +++-
> >   3 files changed, 11 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 1550192..bcf9d60 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -205,7 +205,11 @@ struct kvm_cpu_context {
> >   	struct kvm_vcpu *__hyp_running_vcpu;
> >   };
> > -typedef struct kvm_cpu_context kvm_cpu_context_t;
> > +struct kvm_host_data {
> > +	struct kvm_cpu_context __kvm_cpu_state;
> > +};
> > +
> > +typedef struct kvm_host_data kvm_cpu_context_t;
> >   struct kvm_vcpu_arch {
> >   	struct kvm_cpu_context ctxt;
> > @@ -241,7 +245,7 @@ struct kvm_vcpu_arch {
> >   	struct kvm_guest_debug_arch external_debug_state;
> >   	/* Pointer to host CPU context */
> > -	kvm_cpu_context_t *host_cpu_context;
> > +	struct kvm_cpu_context *host_cpu_context;
> >   	struct thread_info *host_thread_info;	/* hyp VA */
> >   	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
> > diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> > index 323aeb5..da34022 100644
> > --- a/arch/arm64/kernel/asm-offsets.c
> > +++ b/arch/arm64/kernel/asm-offsets.c
> > @@ -142,7 +142,8 @@ int main(void)
> >     DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
> >     DEFINE(VCPU_FPEXC32_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[FPEXC32_EL2]));
> >     DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
> > -  DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
> > +  DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu)
> > +				+ offsetof(struct kvm_host_data, __kvm_cpu_state));
> 
> nit: You could fold the member field in the offsetof(). i.e,
>      DEFINE(HOST_CONTEXT_VCPU, offsetof(struct kvm_host_data,
> __kvm_cpu_state.__hyp_running_vcpu)
> 
> like the VCPU_HOST_CONTEXT above ?

Ah yes thanks for this.

Andrew Murray

> 
> Cheers
> Suzuki
