From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v5 22/23] arm64: KVM: Allow mapping of vectors outside of
 the RAM region
Date: Tue, 13 Mar 2018 12:14:04 +0100
Message-ID: <20180313111404.d35xpe7h24rzpsg5@kamzik.brq.redhat.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-23-marc.zyngier@arm.com>
 <20180308175412.rd63nkceqjg2yrcv@kamzik.brq.redhat.com>
 <c795eca8-7a4f-b209-608d-1428c6dbda33@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B065A40478
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Mar 2018 07:06:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c6DTB-0hna1h for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Mar 2018 07:06:37 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96C09402E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Mar 2018 07:06:37 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <c795eca8-7a4f-b209-608d-1428c6dbda33@arm.com>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 13, 2018 at 10:30:12AM +0000, Marc Zyngier wrote:
> >> +
> >> +    if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR)) {
> > 
> > Moving the create_hyp_mappings() under this cap check looks like a fix
> > that could be posted separately?
> 
> We could. Not sure that's a big deal though.

Nah, it isn't worth the fuss.

> >> +
> >> +	if (cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS)) {
> >> +		__kvm_harden_el2_vector_slot = atomic_inc_return(&arm64_el2_vector_last_slot);
> > 
> > If I understood the logic in the above function correctly, then we won't
> > be using this slot when we have the ARM64_HARDEN_BRANCH_PREDICTOR cap.
> > Should we even bother allocating it when we don't intend to use it?
> 
> You could be on a system with a mix of affected and non-affected CPUs,
> and the capability only tells you that at least one of the CPUs is
> affected. For the non affected CPUs, we won't have a slot (since there
> is no workaround to provide), unless we actually allocated one.
>

Ah yes, the heterogeneous considerations that I always forget to consider.

Thanks,
drew
