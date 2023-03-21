Received: from out-8.mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA0CD2ED
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 17:36:44 +0000 (UTC)
Date: Tue, 21 Mar 2023 17:36:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679420202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LazWz1Vw/uB7//kNP7GFhquaDyzwYXYWJ3Fvk5AWcIs=;
	b=VPk3Ir8QwggAFg5oclA7XnOmICUS4Y7y1Qp67P5Y5qR5GE0cvy262QdZbM7iFnHap6Dh56
	P7D9RfRo9eFg9a7HLakk0W1Pt9qICNM1rjOKK0oFhX3RuSDbap+oBGdx/FiVb0dfCiKqWH
	ToiibwIo+KP66ZKscRX+oK404ge4e2A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH 01/11] KVM: x86: Redefine 'longmode' as a flag for
 KVM_EXIT_HYPERCALL
Message-ID: <ZBnrJU0V/fP53k7a@linux.dev>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
 <20230320221002.4191007-2-oliver.upton@linux.dev>
 <ZBnTE5hCGUOSK3BW@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBnTE5hCGUOSK3BW@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 21, 2023 at 08:53:55AM -0700, Sean Christopherson wrote:
> On Mon, Mar 20, 2023, Oliver Upton wrote:
> > The 'longmode' field is a bit annoying as it blows an entire __u32 to
> > represent a boolean value. Since other architectures are looking to add
> > support for KVM_EXIT_HYPERCALL, now is probably a good time to clean it
> > up.
> > 
> > Redefine the field (and the remaining padding) as a set of flags.
> > Preserve the existing ABI by using the lower 32 bits of the field to
> > indicate if the guest was in long mode at the time of the hypercall.
> 
> Setting all of bits 31:0 doesn't strictly preserve the ABI, e.g. will be a
> breaking change if userspace does something truly silly like
> 
> 	if (vcpu->run->hypercall.longmode == true)
> 		...
> 
> It's likely unnecessary paranoia, but at the same time it's easy to avoid.

Argh, yeah. My route was just lazy.

> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/x86/include/uapi/asm/kvm.h | 9 +++++++++
> >  arch/x86/kvm/x86.c              | 5 ++++-
> >  include/uapi/linux/kvm.h        | 9 +++++++--
> >  3 files changed, 20 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 7f467fe05d42..ab7b7b1d7c9d 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -559,4 +559,13 @@ struct kvm_pmu_event_filter {
> >  #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
> >  #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
> >  
> > +/*
> > + * x86-specific KVM_EXIT_HYPERCALL flags.
> > + *
> > + * KVM previously used a u32 field to indicate the hypercall was initiated from
> > + * long mode. As such, the lower 32 bits of the flags are used for long mode to
> > + * preserve ABI.
> > + */
> > +#define KVM_EXIT_HYPERCALL_LONG_MODE	GENMASK_ULL(31, 0)
> 
> For the uapi, I think it makes sense to do:
> 
>   #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
> 
> and then somewhere internally do:
> 
>   /* Snarky comment goes here. */
>   #define KVM_EXIT_HYPERCALL_MBZ	GENMASK_ULL(31, 1)
> 
> >  #endif /* _ASM_X86_KVM_H */
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 7713420abab0..c61c2b0c73bd 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9803,7 +9803,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  		vcpu->run->hypercall.args[0]  = gpa;
> >  		vcpu->run->hypercall.args[1]  = npages;
> >  		vcpu->run->hypercall.args[2]  = attrs;
> > -		vcpu->run->hypercall.longmode = op_64_bit;
> > +		vcpu->run->hypercall.flags    = 0;
> > +		if (op_64_bit)
> > +			vcpu->run->hypercall.flags |= KVM_EXIT_HYPERCALL_LONG_MODE;
> > +
> 
> And add a runtime assertion to make sure we don't botch this in the future:
> 
> 		WARN_ON_ONCE(vcpu->run->hypercall.flags & KVM_EXIT_HYPERCALL_MBZ);
> 

LGTM, I'll get something like this incorporated for v2.

-- 
Thanks,
Oliver
