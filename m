Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D921FECCD
	for <kvmarm@lists.linux.dev>; Thu, 16 Apr 2026 22:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776377772; cv=none; b=DxqpOxRZyf9Oxr031aOctgWxbIGSe39WTe60EJU9WbYkf5O840C3/Q8Fwtg11gUbpSZ70+7G5XDJF1LUM2tCo2WTCEZxhWawTe5jQ7XbcSj3Wpvx/n+sbJu3r/RTX0z6Jh8P+qKY5xq2+Z0U3wU1dC7T3FQWj07VTQkBQfEusMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776377772; c=relaxed/simple;
	bh=V8ec0TpsIUgqsbX+KSePjrEUrQK13ZrEMxo9eEDXamg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ORVK/risaj61gGRaIgSAILBR+ONNgezpx8ai+tFfb9GjcB8CJVEQUumu3BEwN38i5PO0awNA3Ur/e3uNcFwLw+OQjEGxmSM93ANeibdYQ46H7rf/WeqBVEhWODDNaUMUklWu4fVJxS/KMuK1rGw81+jhkANHS/NAHXIS51NFQhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AqBWiK7j; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AqBWiK7j"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 616BB244C;
	Thu, 16 Apr 2026 15:16:03 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FFBD3F7B4;
	Thu, 16 Apr 2026 15:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776377769; bh=V8ec0TpsIUgqsbX+KSePjrEUrQK13ZrEMxo9eEDXamg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AqBWiK7jYMpMWOTFv77VS5U+6k5kJHBT6GdTe//HY5cihe9/pVBCJsGAWC2ycvJDN
	 R5AUaYZ+2H2I0EbLDIes8OGryXdeEoeg20yuOd/mZN8HzB9Q1K7B1Z06u3olwzbv1H
	 wsguujqQW5AGTmGsyl1/98eCNv6IiHcU5PzZtwxc=
Date: Thu, 16 Apr 2026 23:15:57 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v2 2/4] KVM: arm64: sefltests: Add helpers for guest
 hypervisors
Message-ID: <2grav6nkabbab3e4gm4vtca63kqrpaegq4xqlhdhwc4l32v65i@x5ksiimtk4er>
References: <20260412142216.3806482-1-weilin.chang@arm.com>
 <20260412142216.3806482-3-weilin.chang@arm.com>
 <ad68VjnGQ3trs7AN@sm-arm-grace07>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad68VjnGQ3trs7AN@sm-arm-grace07>

On Wed, Apr 15, 2026 at 07:14:46AM +0900, Itaru Kitayama wrote:
> On Sun, Apr 12, 2026 at 03:22:14PM +0100, Wei-Lin Chang wrote:
> > Add helpers so that guest hypervisors can run nested guests. SP_EL1
> > save/restore is added to allow nested guests to use a stack.
> > 
> > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > ---
> >  .../selftests/kvm/include/arm64/nested.h      | 17 +++++++
> >  tools/testing/selftests/kvm/lib/arm64/entry.S |  5 ++
> >  .../testing/selftests/kvm/lib/arm64/nested.c  | 46 +++++++++++++++++++
> >  3 files changed, 68 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/arm64/nested.h b/tools/testing/selftests/kvm/include/arm64/nested.h
> > index 86d931facacb..7928ef89494a 100644
> > --- a/tools/testing/selftests/kvm/include/arm64/nested.h
> > +++ b/tools/testing/selftests/kvm/include/arm64/nested.h
> > @@ -21,8 +21,17 @@
> >  
> >  extern char hyp_vectors[];
> >  
> > +enum vcpu_sysreg {
> > +	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
> > +
> > +	SP_EL1,
> > +
> > +	NR_SYS_REGS
> > +};
> > +
> >  struct cpu_context {
> >  	struct user_pt_regs regs;	/* sp = sp_el0 */
> > +	u64 sys_regs[NR_SYS_REGS];
> >  };
> >  
> >  struct vcpu {
> > @@ -37,9 +46,17 @@ struct hyp_data {
> >  	struct cpu_context hyp_context;
> >  };
> 
> I am not sure of these structs you introduced only for nested guest feature
> testing, as the KVM arm64 code they are quite complex and involved, 
> extracring part of those and add members as hello_nested or simliar
> tests evolve, then add test cases to me seems fragile. 
> But if you have strong reason to add these would you mind explaining a bit?

Sorry, I don't quite get all of your points. I understand your argument
being evolving these structs as time goes is fragile. For this didn't
KVM itself evolve like this?

As for having these structs, how can we make L1 a small hypervisor
without them?

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Itaru.
> 
> >  
> > +void prepare_hyp(void);
> > +void init_vcpu(struct vcpu *vcpu, vm_paddr_t l2_pc, vm_paddr_t l2_stack_top);
> > +int run_l2(struct vcpu *vcpu, struct hyp_data *hyp_data);
> > +
> > +void do_hvc(void);
> >  u64 __guest_enter(struct vcpu *vcpu, struct cpu_context *hyp_context);
> >  void __hyp_exception(u64 type);
> >  
> > +void __sysreg_save_el1_state(struct cpu_context *ctxt);
> > +void __sysreg_restore_el1_state(struct cpu_context *ctxt);
> > +
> >  #endif /* !__ASSEMBLER__ */
> >  
> >  #endif /* SELFTEST_KVM_NESTED_H */
> > diff --git a/tools/testing/selftests/kvm/lib/arm64/entry.S b/tools/testing/selftests/kvm/lib/arm64/entry.S
> > index 33bedf5e7fb2..df3af3463c6c 100644
> > --- a/tools/testing/selftests/kvm/lib/arm64/entry.S
> > +++ b/tools/testing/selftests/kvm/lib/arm64/entry.S
> > @@ -3,6 +3,11 @@
> >   * adapted from arch/arm64/kvm/hyp/entry.S
> >   */
> >  
> > + .globl do_hvc
> > + do_hvc:
> > +	hvc	#0
> > +	ret
> > +
> >  /*
> >   * Manually define these for now
> >   */
> > diff --git a/tools/testing/selftests/kvm/lib/arm64/nested.c b/tools/testing/selftests/kvm/lib/arm64/nested.c
> > index 06ddaab2436f..b30d20b101c4 100644
> > --- a/tools/testing/selftests/kvm/lib/arm64/nested.c
> > +++ b/tools/testing/selftests/kvm/lib/arm64/nested.c
> > @@ -4,7 +4,53 @@
> >   */
> >  
> >  #include "nested.h"
> > +#include "processor.h"
> >  #include "test_util.h"
> > +#include <asm/sysreg.h>
> > +
> > +void prepare_hyp(void)
> > +{
> > +	write_sysreg(HCR_EL2_E2H | HCR_EL2_RW, hcr_el2);
> > +	write_sysreg(hyp_vectors, vbar_el2);
> > +	isb();
> > +}
> > +
> > +void init_vcpu(struct vcpu *vcpu, vm_paddr_t l2_pc, vm_paddr_t l2_stack_top)
> > +{
> > +	memset(vcpu, 0, sizeof(*vcpu));
> > +	vcpu->context.regs.pc = l2_pc;
> > +	vcpu->context.regs.pstate = PSR_MODE_EL1h | PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
> > +	vcpu->context.sys_regs[SP_EL1] = l2_stack_top;
> > +}
> > +
> > +void __sysreg_save_el1_state(struct cpu_context *ctxt)
> > +{
> > +	ctxt->sys_regs[SP_EL1] = read_sysreg(sp_el1);
> > +}
> > +
> > +void __sysreg_restore_el1_state(struct cpu_context *ctxt)
> > +{
> > +	write_sysreg(ctxt->sys_regs[SP_EL1], sp_el1);
> > +}
> > +
> > +int run_l2(struct vcpu *vcpu, struct hyp_data *hyp_data)
> > +{
> > +	u64 ret;
> > +
> > +	__sysreg_restore_el1_state(&vcpu->context);
> > +
> > +	write_sysreg(vcpu->context.regs.pstate, spsr_el2);
> > +	write_sysreg(vcpu->context.regs.pc, elr_el2);
> > +
> > +	ret =  __guest_enter(vcpu, &hyp_data->hyp_context);
> > +
> > +	vcpu->context.regs.pc = read_sysreg(elr_el2);
> > +	vcpu->context.regs.pstate = read_sysreg(spsr_el2);
> > +
> > +	__sysreg_save_el1_state(&vcpu->context);
> > +
> > +	return ret;
> > +}
> >  
> >  void __hyp_exception(u64 type)
> >  {
> > -- 
> > 2.43.0
> > 
