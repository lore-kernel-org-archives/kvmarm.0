Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FE048F84F;
	Fri, 11 Sep 2026 15:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789141471; cv=none; b=MwHGk/Lg1cNo+nuuH7UWZuAdHG+5L924cNWB8qr1GYnDx6CRHSr0HJEjn2wjiFMF+egRXZu7GWaFzx33UMwjN+N2qZRg7SNfEHlkR6uKMY53ipDZcnaAkNC0C4aTQpsiRVGFcYh4ohzCpxMhBAnbZwZzL4prxSXuIR9vyUE2X8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789141471; c=relaxed/simple;
	bh=YBrLuGD7ByRGIeP3Inf6j+uxYxUO9BpxRTDxfwAjpX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=loP+7/1bSJUaNunO3UIVR8yNmocX+pL69KnJsT9EXriWZ5hXsqZWO4E4PWdUr+/FFoA/4C0hP/NQ7+mq5Lvr0CyKwVkQNZeYZsiApG2mQn/bsYFDHzPSdxj2SQ10QVPknso8KFJb3Eh+gBAMgSztrYSu7mMpV/NiKgY1zHpHagM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dxm0z51C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dxm0z51C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D6F1F000FF;
	Fri, 11 Sep 2026 15:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789141467;
	bh=cL+TWIh8McU1el0I5QKVmS3YEVxoYM3L1I89qeoIYbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dxm0z51CRwUX8kBrMIAg+NJKOu6WsCMVN2UF19UryrBXBBaqjofY81m1lG1Y0wu17
	 w/T3p3/Wm5i3eHOL1frCXdHpeZvTcoB/qrTaz6ubhviGxKUt+6XuR24heedgWPukvP
	 dSqs2GzV3Dgv1uCH0SjK7ebL7LngGIO24hRupNFrza5rQ05pxETL+Aj2Y3DXfl/XkX
	 /k42ZhyMvtGGuQuMvadlyLHeZMYTqbmjrsdIsHbeU4J3oT638lIf4qyXOjdnWendq4
	 T05sJioV6cR3GOzoOurkf0F0U3xUSL9v8+6TC4EKfOGuIyDmp+uefhMYpFuZmVt85n
	 R8f/ybKIPLVrg==
Date: Fri, 11 Sep 2026 16:44:19 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>
Subject: Re: [PATCH 8/8] KVM: selftests: Add nested pre-fault test for arm64
Message-ID: <aqQY5iKMgh23Hi7p@gremlin>
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
 <20260825-kvm-arm-prefault-v1-8-befe8947702e@kernel.org>
 <aqOgEQKBGH-YqGr3@sm-arm-grace07>
 <aqPIUtNTJFwUvJME@gremlin>
 <g45xmukndzivuxowpjxlajrjzx2ljevliroenbx4h4wgrnpoi6@eozuucl3usi3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g45xmukndzivuxowpjxlajrjzx2ljevliroenbx4h4wgrnpoi6@eozuucl3usi3>

On Fri, Sep 11, 2026 at 01:42:57PM +0100, Wei-Lin Chang wrote:
> On Fri, Sep 11, 2026 at 10:32:17AM +0100, Lorenzo Stoakes (ARM) wrote:
> > +cc Wei-Lin
> >
> > On Fri, Sep 11, 2026 at 03:30:41PM +0900, Itaru Kitayama wrote:
> > > Hi Lorenzo,
> > >
> > > On Tue, Aug 25, 2026 at 05:00:42PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > From: Jack Thomson <jackabt@amazon.com>
> > > >
> > > > Add an arm64 nested-virt selftest for KVM_PRE_FAULT_MEMORY. The guest
> > > > enters vEL1 and exits to userspace with a nested/shadow stage-2 MMU as
> > > > the vCPU's last-run context.
> > > >
> > > > Before prefaulting, userspace enables HCR_EL2.VM and points VTTBR_EL2 at
> > > > an empty nested stage-2 root. A prefault implementation that incorrectly
> > > > treats the userspace GPA as an L2 IPA will fail the ioctl; the correct
> > > > path targets the canonical stage-2 and succeeds.
> > > >
> > > > Restore the original nested state before resuming the guest, then touch
> > > > the prefaulted range to check that vEL1 still runs correctly.
> > > >
> > > > Signed-off-by: Jack Thomson <jackabt@amazon.com>
> > > > [ljs: partial progress, >4 KiB pgsize, commit msg, comment fixups]
> > > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > > ---
> > > >  tools/testing/selftests/kvm/Makefile.kvm           |   1 +
> > > >  .../selftests/kvm/arm64/nv_pre_fault_memory_test.c | 206 +++++++++++++++++++++
> > > >  2 files changed, 207 insertions(+)
> > >
> > > I wonder whether this selftest can use functions Wei-Lin proposed
> > > some time ago [1]: 20260325003620.2214766-1-weilin.chang@arm.com
> > > or would you prefer this test as propose, since it is clear as
> > > to what needs to be done to enter L2.
> >
> > I think if these aren't merged yet then that could be a follow up?
>
> This selftest doesn't require setting up L1's stage-2 for L2, so to me
> the current approach is okay.



>
> [...]
>
> > > > +static void guest_code(void)
> > > > +{
> > > > +	u64 sp;
> > > > +
> > > > +	GUEST_ASSERT_EQ(get_current_el(), 2);
> > > > +
> > > > +	/*
> > > > +	 * Mirror the EL2 translation regime into the real EL1 registers so
> > > > +	 * that vEL1 runs on the test's stage-1 page tables. With E2H=1, the
> > > > +	 * _EL1 accessors read the EL2 registers, and the _EL12 accessors
> > > > +	 * write the real EL1 registers.
> > > > +	 */
> > > > +	write_sysreg_s(read_sysreg(sctlr_el1), SYS_SCTLR_EL12);
> > > > +	write_sysreg_s(read_sysreg(tcr_el1), SYS_TCR_EL12);
> > > > +	write_sysreg_s(read_sysreg(ttbr0_el1), SYS_TTBR0_EL12);
> > > > +	write_sysreg_s(read_sysreg(mair_el1), SYS_MAIR_EL12);
> > > > +	write_sysreg_s(read_sysreg(cpacr_el1), SYS_CPACR_EL12);
>
> Just FYI, the at.c selftest uses a macro for these.

Ack will check and see if I can use same approach here.

>
> > > > +
> > > > +	/* Run vEL1 on the same stack. */
> > > > +	asm volatile("mov %0, sp" : "=r"(sp));
> > > > +	write_sysreg(sp, sp_el1);
> > > > +
> > > > +	/*
> > > > +	 * Drop TGE so that vEL1 is a nested context rather than host EL0.
> > > > +	 * KVM backs it with a shadow stage-2 MMU even though vstage-2 is
> > > > +	 * disabled (HCR_EL2.VM=0).
> > > > +	 */
> > > > +	write_sysreg(read_sysreg(hcr_el2) & ~HCR_EL2_TGE, hcr_el2);
> > > > +	isb();
> > > > +
> > > > +	write_sysreg(PSR_MODE_EL1h | PSR_F_BIT | PSR_I_BIT | PSR_A_BIT |
> > > > +		     PSR_D_BIT, spsr_el2);
> > > > +	write_sysreg((u64)guest_el1_code, elr_el2);
> > > > +	asm volatile("eret");
> > > > +
> > > > +	GUEST_ASSERT(false);
> > > > +}
> > > > +
>
> [...]
>
> > > > +
> > > > +static struct nested_s2_state enable_empty_nested_s2(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	struct nested_s2_state state = {
> > > > +		.hcr_el2 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2)),
> > > > +		.vttbr_el2 = vcpu_get_reg(vcpu,
> > > > +					   KVM_ARM64_SYS_REG(SYS_VTTBR_EL2)),
> > > > +	};
> > > > +
> > > > +	TEST_ASSERT(!(state.hcr_el2 & HCR_EL2_TGE),
> > > > +		    "vCPU should be in nested/vEL1 context");
> > > > +
> > > > +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTTBR_EL2),
> > > > +		     NESTED_S2_ROOT_GPA);
> > > > +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2),
> > > > +		     state.hcr_el2 | HCR_EL2_VM);
> > > > +
> > > > +	return state;
> > > > +}
> > > > +
> > > > +static void restore_nested_s2(struct kvm_vcpu *vcpu,
> > > > +			      struct nested_s2_state *state)
> > > > +{
> > > > +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2), state->hcr_el2);
> > > > +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTTBR_EL2),
> > > > +		     state->vttbr_el2);
> > > > +}
> > > > +
> > > > +int main(void)
> > > > +{
> > > > +	struct nested_s2_state s2;
> > > > +	struct kvm_vcpu_init init;
> > > > +	struct kvm_vcpu *vcpu;
> > > > +	struct kvm_vm *vm;
> > > > +	struct ucall uc;
> > > > +	u64 npages;
> > > > +
>
> [...]
>
> > > > +
> > > > +	/*
> > > > +	 * The vCPU's last-run context is vEL1, backed by a shadow stage-2
> > > > +	 * MMU. Enable nested stage-2 with an empty root so that the ioctl
> > > > +	 * fails if it tries to interpret the userspace GPA as an L2 IPA.
> > > > +	 *
> > > > +	 * Prefault in two halves so that the second ioctl exercises a
> > > > +	 * repeated shadow-MMU attach and canonical stage-2 swap.
> > > > +	 *
> > > > +	 * (Note that an implementation that wrongly populates shadow
> > > > +	 * stage-2 page tables would not be caught as userland can't
> > > > +	 * inspect these.)
> > > > +	 */
> > > > +	s2 = enable_empty_nested_s2(vcpu);
> > > > +	pre_fault(vcpu, TEST_MEM_GPA, TEST_MEM_SIZE / 2);
> > > > +	pre_fault(vcpu, TEST_MEM_GPA + TEST_MEM_SIZE / 2, TEST_MEM_SIZE / 2);
> > > > +	restore_nested_s2(vcpu, &s2);
>
> Sorry I don't get what enable_empty_nested_s2(), restore_nested_s2()
> brings to the test?
>
> After quickly going through the prefault implementation there isn't
> anything about it that is nested related, how would giving L2 an empty
> stage-2 translation affect the outcome if it misinterprets the GPA as an
> L2 IPA?

Well the prefaulting intentionally does not interact with nested and only
prefaults for the canonical s2 page tables.

I guess the intention here was to make sure that's the case.

But I think you're right in that it's a bit silly - the code doesn't try to
interpret anything in terms of a nested guest, and nobody's going to change it
to do so.

>
> In other words would there be potential false positives if we don't call
> these functions?

I think really think this is actually asserting anything meaningful.

I'll drop it and simplify - have it just assert that the last-run vCPU was a
stage2 vCPU and prefault doesn't do anything weird with that.

The only way it could be broken is if it set a non-canonical mmu in
__pre_fault_s2() or set s2fd->nested, neither of which, of course, it does.

>
> Thanks,
> Wei-Lin Chang
>
> > > > +
> > > > +	/* Resume at vEL1 and touch the prefaulted range. */
> > > > +	vcpu_run(vcpu);
> > > > +	switch (get_ucall(vcpu, &uc)) {
> > > > +	case UCALL_DONE:
> > > > +		break;
> > > > +	case UCALL_ABORT:
> > > > +		REPORT_GUEST_ASSERT(uc);
> > > > +		break;
> > > > +	default:
> > > > +		TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
> > > > +	}
> > > > +
> > > > +	kvm_vm_free(vm);
> > > > +	return 0;
> > > > +}
> > > >
> > > > --
> > > > 2.55.0
> > > >
> >
> > --
> > Cheers, Lorenzo

--
Cheers, Lorenzo
