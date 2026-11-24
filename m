Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795539190;
	b=NgwStRfu0Jd9BbJrAksCCbxgjzue+KLqoqpQY9HtAU0+rlXpxtGsJqxqg0EvR3rsjoXh
	 qjrHIMqZ78AaZpXVab7+qfQZdSyCZxjlyVBjfDc7SFUeitxmzTu/hzRhb1huRBD52fgEU
	 kolTZHFd8ZDx+BvPfKCNfqFey97TdOimHjMz2/2B3wbiiEba9OLeh+324SCrgAcDXDo6s
	 DO46g4jqnGAXxz9mz8DdM3MlmTcFmk/jwx8W9k+8QkJ/0AZhnOulwDxqTBPVt57HSoMXJ
	 5y4sUJ615nnVwEX2j+63UV3JM30HG//Kyuqt3b1tlApUxRAfQ5fqXZUEQVu2iTK81Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795539190;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=x/uzChQMb312nOxPDZxs+qjo+ZN0ijU/g8Mc3JJQonU=;
	b=kJmg+wwQsdgjhmeBdTNZnrLOVAFcqKs+THtoHGY7PSUGewpIzNA3Y/+7XOuMGkjF/xCG
	 ORItpHSVxawjiXCpfTp26aZsYM2rda1M3nHON5MmKs9Tc4PHRtT8YfdvCYz12FjokNtAV
	 Z17SKWijI3ZiIc92R4HeYUyB5EGAB0C+FfZGsyE7lfDZx+dmwfZezC3nNb69Qc3Eko7o2
	 rgPqUwwp+v38PKDwwlIVWz5P1+jVb9iXyEHgwzEaUe0cUkJyDt22kKfPR7s/Dk06heLUL
	 A1eVuuvWxNXTj3agAeuZeuQS+moT3VNxMLKmCp8Jf2Erb1qeaUUYUKzvrtXKHATWZqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OOMLAS+X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501D2606A33D;
	Tue, 24 Nov 2026 16:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OOMLAS+X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE8E1F000CA;
	Tue, 24 Nov 2026 16:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795539189;
	bh=x/uzChQMb312nOxPDZxs+qjo+ZN0ijU/g8Mc3JJQonU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OOMLAS+XbhdnRS7DFxO90ypKtA8PGcVdJZbFI8gljDKch9WCYldkuqZ0kVwuUPZ+6
	 DJ+PTxVWWPKOiF2iDRt9r3OeLjBPpdenXE1GXapKuoJRyr6FpYRvufwl+XROSY9yho
	 jTkO8I/BbuB2Mkrtl3WoqPT+Xs9IYfiNc7ya8gNP9Dsm9gZcXM2/h8MvhRFX5GC6r+
	 fRqG6Z3nr0a1Jpuy2CUXl8X+fANf3mDC+7/YbBfvSpwDRDyqgtrkhl2KY8WxIVvPH2
	 qZNW4e5PmXeu/A1b+1ldGiTLSLO6MI3VOERij/AB6KsjOvpZThacNm0hGusbxOvNzs
	 iXZmwZ+SG1Z0g==
Date: Tue, 24 Nov 2026 16:53:01 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Justin He <Justin.He@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <Catalin.Marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Shuah Khan <shuah@kernel.org>, Sascha Bischoff <Sascha.Bischoff@arm.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, Dan Carpenter <dan@pereq.eu>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't load hardware vCPU state before
 first run
Message-ID: <awW1Q2Y9vCdxpjtG@gremlin>
References: <20261123150917.2679600-1-justin.he@arm.com>
 <20261123150917.2679600-2-justin.he@arm.com>
 <86eccbzcqh.wl-maz@kernel.org>
 <AS2PR08MB978600ED2150F773D3E1631DF7442@AS2PR08MB9786.eurprd08.prod.outlook.com>
 <868q2iz94w.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868q2iz94w.wl-maz@kernel.org>

On Tue, Nov 24, 2026 at 12:50:07PM +0000, Marc Zyngier wrote:
> Adding Dan to this loop, as I reckon something else is amiss.
>
> On Tue, 24 Nov 2026 01:39:23 +0000,
> Justin He <Justin.He@arm.com> wrote:
> >
> > Hi, Marc
> >
> > > -----Original Message-----
> > [...]
> > > > KVM_PRE_FAULT_MEMORY calls vcpu_load() as soon as
> > > KVM_ARM_VCPU_INIT has
> > > > completed. On arm64, however, kvm->arch.sysreg_masks, the trap
> > > > configuration, vncr_tlb and nested vGIC state are only set up on the
> > > > first KVM_RUN in kvm_arch_vcpu_run_pid_change().
> > >
> > > I think I'm going to queue a patch disabling prefaulting immediately,
> > > and then we can fix this crap.
> > >
> > Fine with me. I'll rebase on top of it and have v2 re-enable
> > pre-faulting together with the load/put change.
>
> Don't worry about that. I can fix that myself when applying the
> patches.
>
>
> > > > Since kvm_running_vcpu can now be set without VHE state on the CPU, use
> > > > host_ctxt->__hyp_running_vcpu in VHE enter_vmid_context() (matching
> > > > nVHE)
> > >
> > > Can you clarify under which circumstances we end-up on the TLB
> > > invalidation path? Simply faulting things in should not result in
> > > invalidation. Unless we end-up with MMU notifiers firing?
> > >
> > I found this by code inspection, not from a failure. A TLBI from a stage-2
> > BBM or an MMU notifier can hit this path during pre-faulting, but before
> > the first run hw_mmu is canonical, so it makes no difference. As Lorenzo
> > said, I'll drop this hunk.
>
> vcpu->arch.hw_mmu being the canonical one before the first run doesn't
> hold anymore, since a7602ea542d4e ("KVM: arm64: nv: Initialize hw_mmu
> to NULL for nested vCPUs"), as userspace can configure things for an
> L2, before first run, and bad things happen otherwise.

Yeah sorry, didn't pull locally so missed that...!

>
> But the observation remains: if an MMU notifier occurs for any reason
> while pre-faulting (likely a concurrent reclaim), we get the "not
> quite loaded" vcpu in enter_vmid_context(). If vcpu->arch.hw_mmu is a
> valid (non-null) pointer, then we will restore whatever is in that
> structure when reaching exit_vmid_context(), and that's not what is
> intended.

We might also get not-concurrent MMU notifier fun with direct reclaim like:

kvm_vcpu_pre_fault_memory()
  -> vcpu_load()
    -> kvm_running_vcpu set
    -> kvm_arch_vcpu_load()
      [ skipped with this patch, !vcpu_has_run_once() ]
  -> kvm_arch_vcpu_pre_fault_memory()
    -> user_mem_abort()
      -> kvm_s2_fault_pin_pfn()
        ...
        -> get_user_pages_unlocked()
          -> < try to fault in >
            [ direct reclaim, tries to unmap a page from another VM ]
            -> [ mmu notifier ]
              -> kvm_unmap_gfn_range()
                -> kvm_stage2_unmap_range()
                  ...
                  -> enter_vmid_context()
                    [ assumes kvm_running_vcpu's hw_mmu is in VTTBR_EL2
		      so exit_vmid_context() 'restores' it ]

Yeah anyway in general this is clearly _wrong_ so right thing is to keep
that bit.

>
> So I think we need that sort of exclusion. Either we track what is
> actually properly loaded (using __hyp_running_vcpu as you did before,
> or by checking whether the vcpu is in a valid state).

Yup makes sense!

>
> I think we have a somewhat similar breakage with 5651590be08a6 ("KVM:
> arm64: Load the vcpu in KVM_SET_VCPU_EVENTS"): as vcpu_load() now
> becomes sensitive to vcpu_has_run_once() being true, we can't tell
> anything of the state that is going to be evaluated by the event
> injection helper.
>
> We could prevent the non-running injection in KVM_SET_VCPU_EVENTS, but
> that's also a change in the API...

OK so fear is Dan's vcpu load in kvm_arm_vcpu_set_events() now ends up
doing naff all before vcpu_has_run_once() and thus the bug he fixes might
be a thing again?

Or is the concern something else?

For the bug I think probably it's fine because the issue there was that you
had an unload without a load AFAICT, but Jia's change also updates
kvm_arch_vcpu_put() to be symmetrical, so that should be OK?

>
> 	M.
>
> --
> Without deviation from the norm, progress is not possible.

--
Cheers, Lorenzo
