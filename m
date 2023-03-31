Received: from out-20.mta1.migadu.com (out-20.mta1.migadu.com [95.215.58.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6CF8C10
	for <kvmarm@lists.linux.dev>; Fri, 31 Mar 2023 18:00:44 +0000 (UTC)
Date: Fri, 31 Mar 2023 18:00:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680285642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/6CRlTFnqHgwjCW87ghqewT6ez8OGgstbNG24iNeuCs=;
	b=NzC6wZu64DAaMhq5EG92pJVp+S8s4EIqFe1kQ1v1bxfTLhvVYhi1KBcJd9q+OgduzuW+Yh
	Jo7t3qsFsFNXRcCGrgNoLEgFFHiH4ptjCKQzZR1rPKytYYywXX3TvGBxZkQqZVV+tlzptg
	vrlS4sv27BCNVtlMkwbiDwsVzJAf5ik=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH v2 08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Message-ID: <ZCcfxu/2dqoBd9XA@linux.dev>
References: <20230330154918.4014761-1-oliver.upton@linux.dev>
 <20230330154918.4014761-9-oliver.upton@linux.dev>
 <865yagx2w3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865yagx2w3.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 31, 2023 at 06:10:52PM +0100, Marc Zyngier wrote:
> On Thu, 30 Mar 2023 16:49:13 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > In anticipation of user hypercall filters, add the necessary plumbing to
> > get SMCCC calls out to userspace. Even though the exit structure has
> > space for KVM to pass register arguments, let's just avoid it altogether
> > and let userspace poke at the registers via KVM_GET_ONE_REG.
> > 
> > This deliberately stretches the definition of a 'hypercall' to cover
> > SMCs from EL1 in addition to the HVCs we know and love. KVM doesn't
> > support EL1 calls into secure services, but now we can paint that as a
> > userspace problem and be done with it.
> > 
> > Finally, we need a flag to let userspace know what conduit instruction
> > was used (i.e. SMC vs. HVC).
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  Documentation/virt/kvm/api.rst    | 22 ++++++++++++++++++++--
> >  arch/arm64/include/uapi/asm/kvm.h |  4 ++++
> >  arch/arm64/kvm/handle_exit.c      |  4 +++-
> >  arch/arm64/kvm/hypercalls.c       | 17 +++++++++++++++++
> >  4 files changed, 44 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 9b01e3d0e757..c8ab2f730945 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6221,11 +6221,29 @@ to the byte array.
> >  			__u64 flags;
> >  		} hypercall;
> >  
> > -Unused.  This was once used for 'hypercall to userspace'.  To implement
> > -such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO (all except s390).
> > +
> > +It is strongly recommended that userspace use ``KVM_EXIT_IO`` (x86) or
> > +``KVM_EXIT_MMIO`` (all except s390) to implement functionality that
> > +requires a guest to interact with host userpace.
> >  
> >  .. note:: KVM_EXIT_IO is significantly faster than KVM_EXIT_MMIO.
> >  
> > +For arm64:
> > +----------
> > +
> > +SMCCC exits can be enabled depending on the configuration of the SMCCC
> > +filter. See the Documentation/virt/kvm/devices/vm.rst
> > +``KVM_ARM_SMCCC_FILTER`` for more details.
> 
> Maybe this hunk should come with the following patch which actually
> adds that doc.

Heh, you caught me being lazy :) Can do.

> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 73b218ddd1a5..7e8c850847c1 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -180,6 +180,19 @@ static u8 kvm_smccc_get_action(struct kvm_vcpu *vcpu, u32 func_id)
> >  	return KVM_SMCCC_FILTER_DENY;
> >  }
> >  
> > +static void kvm_prepare_hypercall_exit(struct kvm_vcpu *vcpu, u32 func_id)
> > +{
> > +	u8 ec = ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
> > +	struct kvm_run *run = vcpu->run;
> > +
> > +	run->exit_reason = KVM_EXIT_HYPERCALL;
> > +	run->hypercall.nr = func_id;
> > +	run->hypercall.flags = 0;
> > +
> > +	if (ec == ESR_ELx_EC_SMC32 || ec == ESR_ELx_EC_SMC64)
> > +		run->hypercall.flags |= KVM_HYPERCALL_EXIT_SMC;
> > +}
> > +
> >  int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
> >  {
> >  	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
> > @@ -192,6 +205,10 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
> >  	action = kvm_smccc_get_action(vcpu, func_id);
> >  	if (action == KVM_SMCCC_FILTER_DENY)
> >  		goto out;
> > +	if (action == KVM_SMCCC_FILTER_FWD_TO_USER) {
> > +		kvm_prepare_hypercall_exit(vcpu, func_id);
> > +		return 0;
> > +	}
> 
> nit: maybe write this as a switch statement?

Sure thing. I'll get a new spin on the list sometime in the next day or
two that addresses your feedback. Appreciate the review

-- 
Thanks,
Oliver
