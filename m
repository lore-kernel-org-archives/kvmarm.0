Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89DEC3E5595
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 12:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789130593; cv=none; b=ngykL1xRwWGF8RPDm9GhrGpyE+8u4AxMBXpNPGQrkZSwQPibVZVhuqpm7avpYIyW30tUo4KVzMEIKf37D6LrrmdT1B6CVzmS6mE8G4KUskOG2puG0QQfzPOBQgn+nStHHFVtXQuV8Vwn0nKI42nHfAG8aHd09xaI43zl18T2MRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789130593; c=relaxed/simple;
	bh=AYEkP013J/2d/muDFR6I2PEvoL5OJnQHcQnfIXL8Gdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q6Q0N8Tr4EMlrpRH5CH5F5tlW3eBKAOBzTa7cTb1PDeOeJPCVtch4Z1nv/DEGNSSXEOU+Hyi0J0VK7OBT+y+w4H3H/gEgDov52H6MQLUwtr5g4nsUUlRQLZQyNKXlRZqw4Y50W1bCkR0ZPzCVO1zh657FtIIVUc2pdSoCdiToY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Y7t2/5La; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Y7t2/5La"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4485B1655;
	Fri, 11 Sep 2026 05:43:06 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17A4F3F7B4;
	Fri, 11 Sep 2026 05:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789130589; bh=AYEkP013J/2d/muDFR6I2PEvoL5OJnQHcQnfIXL8Gdw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y7t2/5Lam2g8qRhPXwbiismNNJmPzYkbs1njyR8gmpp7Vck5F0dEP+USPHwGkVj4y
	 zyEVPrSL46la0hde1suMA5O66hKqdPYQmIy0jLuQtj8JZiZhItI8liJqlOlZKutbU7
	 R7cp0KjoRS0TqixmTVP9fKudIHZb6fIM75NhVQfI=
Date: Fri, 11 Sep 2026 13:42:57 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, 
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
Message-ID: <g45xmukndzivuxowpjxlajrjzx2ljevliroenbx4h4wgrnpoi6@eozuucl3usi3>
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
 <20260825-kvm-arm-prefault-v1-8-befe8947702e@kernel.org>
 <aqOgEQKBGH-YqGr3@sm-arm-grace07>
 <aqPIUtNTJFwUvJME@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqPIUtNTJFwUvJME@gremlin>

On Fri, Sep 11, 2026 at 10:32:17AM +0100, Lorenzo Stoakes (ARM) wrote:
> +cc Wei-Lin
> 
> On Fri, Sep 11, 2026 at 03:30:41PM +0900, Itaru Kitayama wrote:
> > Hi Lorenzo,
> >
> > On Tue, Aug 25, 2026 at 05:00:42PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > From: Jack Thomson <jackabt@amazon.com>
> > >
> > > Add an arm64 nested-virt selftest for KVM_PRE_FAULT_MEMORY. The guest
> > > enters vEL1 and exits to userspace with a nested/shadow stage-2 MMU as
> > > the vCPU's last-run context.
> > >
> > > Before prefaulting, userspace enables HCR_EL2.VM and points VTTBR_EL2 at
> > > an empty nested stage-2 root. A prefault implementation that incorrectly
> > > treats the userspace GPA as an L2 IPA will fail the ioctl; the correct
> > > path targets the canonical stage-2 and succeeds.
> > >
> > > Restore the original nested state before resuming the guest, then touch
> > > the prefaulted range to check that vEL1 still runs correctly.
> > >
> > > Signed-off-by: Jack Thomson <jackabt@amazon.com>
> > > [ljs: partial progress, >4 KiB pgsize, commit msg, comment fixups]
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > ---
> > >  tools/testing/selftests/kvm/Makefile.kvm           |   1 +
> > >  .../selftests/kvm/arm64/nv_pre_fault_memory_test.c | 206 +++++++++++++++++++++
> > >  2 files changed, 207 insertions(+)
> >
> > I wonder whether this selftest can use functions Wei-Lin proposed
> > some time ago [1]: 20260325003620.2214766-1-weilin.chang@arm.com
> > or would you prefer this test as propose, since it is clear as
> > to what needs to be done to enter L2.
> 
> I think if these aren't merged yet then that could be a follow up?

This selftest doesn't require setting up L1's stage-2 for L2, so to me
the current approach is okay.

[...]

> > > +static void guest_code(void)
> > > +{
> > > +	u64 sp;
> > > +
> > > +	GUEST_ASSERT_EQ(get_current_el(), 2);
> > > +
> > > +	/*
> > > +	 * Mirror the EL2 translation regime into the real EL1 registers so
> > > +	 * that vEL1 runs on the test's stage-1 page tables. With E2H=1, the
> > > +	 * _EL1 accessors read the EL2 registers, and the _EL12 accessors
> > > +	 * write the real EL1 registers.
> > > +	 */
> > > +	write_sysreg_s(read_sysreg(sctlr_el1), SYS_SCTLR_EL12);
> > > +	write_sysreg_s(read_sysreg(tcr_el1), SYS_TCR_EL12);
> > > +	write_sysreg_s(read_sysreg(ttbr0_el1), SYS_TTBR0_EL12);
> > > +	write_sysreg_s(read_sysreg(mair_el1), SYS_MAIR_EL12);
> > > +	write_sysreg_s(read_sysreg(cpacr_el1), SYS_CPACR_EL12);

Just FYI, the at.c selftest uses a macro for these.

> > > +
> > > +	/* Run vEL1 on the same stack. */
> > > +	asm volatile("mov %0, sp" : "=r"(sp));
> > > +	write_sysreg(sp, sp_el1);
> > > +
> > > +	/*
> > > +	 * Drop TGE so that vEL1 is a nested context rather than host EL0.
> > > +	 * KVM backs it with a shadow stage-2 MMU even though vstage-2 is
> > > +	 * disabled (HCR_EL2.VM=0).
> > > +	 */
> > > +	write_sysreg(read_sysreg(hcr_el2) & ~HCR_EL2_TGE, hcr_el2);
> > > +	isb();
> > > +
> > > +	write_sysreg(PSR_MODE_EL1h | PSR_F_BIT | PSR_I_BIT | PSR_A_BIT |
> > > +		     PSR_D_BIT, spsr_el2);
> > > +	write_sysreg((u64)guest_el1_code, elr_el2);
> > > +	asm volatile("eret");
> > > +
> > > +	GUEST_ASSERT(false);
> > > +}
> > > +

[...]

> > > +
> > > +static struct nested_s2_state enable_empty_nested_s2(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct nested_s2_state state = {
> > > +		.hcr_el2 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2)),
> > > +		.vttbr_el2 = vcpu_get_reg(vcpu,
> > > +					   KVM_ARM64_SYS_REG(SYS_VTTBR_EL2)),
> > > +	};
> > > +
> > > +	TEST_ASSERT(!(state.hcr_el2 & HCR_EL2_TGE),
> > > +		    "vCPU should be in nested/vEL1 context");
> > > +
> > > +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTTBR_EL2),
> > > +		     NESTED_S2_ROOT_GPA);
> > > +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2),
> > > +		     state.hcr_el2 | HCR_EL2_VM);
> > > +
> > > +	return state;
> > > +}
> > > +
> > > +static void restore_nested_s2(struct kvm_vcpu *vcpu,
> > > +			      struct nested_s2_state *state)
> > > +{
> > > +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2), state->hcr_el2);
> > > +	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VTTBR_EL2),
> > > +		     state->vttbr_el2);
> > > +}
> > > +
> > > +int main(void)
> > > +{
> > > +	struct nested_s2_state s2;
> > > +	struct kvm_vcpu_init init;
> > > +	struct kvm_vcpu *vcpu;
> > > +	struct kvm_vm *vm;
> > > +	struct ucall uc;
> > > +	u64 npages;
> > > +

[...]

> > > +
> > > +	/*
> > > +	 * The vCPU's last-run context is vEL1, backed by a shadow stage-2
> > > +	 * MMU. Enable nested stage-2 with an empty root so that the ioctl
> > > +	 * fails if it tries to interpret the userspace GPA as an L2 IPA.
> > > +	 *
> > > +	 * Prefault in two halves so that the second ioctl exercises a
> > > +	 * repeated shadow-MMU attach and canonical stage-2 swap.
> > > +	 *
> > > +	 * (Note that an implementation that wrongly populates shadow
> > > +	 * stage-2 page tables would not be caught as userland can't
> > > +	 * inspect these.)
> > > +	 */
> > > +	s2 = enable_empty_nested_s2(vcpu);
> > > +	pre_fault(vcpu, TEST_MEM_GPA, TEST_MEM_SIZE / 2);
> > > +	pre_fault(vcpu, TEST_MEM_GPA + TEST_MEM_SIZE / 2, TEST_MEM_SIZE / 2);
> > > +	restore_nested_s2(vcpu, &s2);

Sorry I don't get what enable_empty_nested_s2(), restore_nested_s2()
brings to the test?

After quickly going through the prefault implementation there isn't
anything about it that is nested related, how would giving L2 an empty
stage-2 translation affect the outcome if it misinterprets the GPA as an
L2 IPA?

In other words would there be potential false positives if we don't call
these functions?

Thanks,
Wei-Lin Chang

> > > +
> > > +	/* Resume at vEL1 and touch the prefaulted range. */
> > > +	vcpu_run(vcpu);
> > > +	switch (get_ucall(vcpu, &uc)) {
> > > +	case UCALL_DONE:
> > > +		break;
> > > +	case UCALL_ABORT:
> > > +		REPORT_GUEST_ASSERT(uc);
> > > +		break;
> > > +	default:
> > > +		TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
> > > +	}
> > > +
> > > +	kvm_vm_free(vm);
> > > +	return 0;
> > > +}
> > >
> > > --
> > > 2.55.0
> > >
> 
> --
> Cheers, Lorenzo
