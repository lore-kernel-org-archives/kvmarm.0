Received: from esa7.hc1455-7.c3s2.iphmx.com (esa7.hc1455-7.c3s2.iphmx.com [139.138.61.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6BC38657C
	for <kvmarm@lists.linux.dev>; Thu, 16 Apr 2026 23:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.61.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776382871; cv=none; b=ciN4yxnqWaXsSJQYaiMJLDNYqe2vV1gwCMhd9EAo75xms32XK2v3hgfAkAqpyk567EdDgFoHw1TM3z1sg4PUeJ5eLIoIb3J7o5qNFbZzMCJAy/Wqc7CAss2aQer1My2rjKcjM+hJjebjxuV9HV1c5RzHLYK/IarCdL6FdrC4WbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776382871; c=relaxed/simple;
	bh=nY5mGUtsHm/DH8Clav1C2yzxZNNNZ0YPXwIDnOkmLx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AH5r/NcxkOS77B36jhXqqvksx6HoJyodAfVDSfOQXmkeBmJVLlVDrclSbplPMLXwhB7B6DFDKGH1AFROBbNUJMUv8vEOWPOyfe7sd8PU/zAVmcGAt7KxgGHgm1qoY+qRUhlYH0/cklbQljom4M4dvdcY6AgmAmywpsmB6QcgcII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=GuDbFOoZ; arc=none smtp.client-ip=139.138.61.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="GuDbFOoZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1776382869; x=1807918869;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nY5mGUtsHm/DH8Clav1C2yzxZNNNZ0YPXwIDnOkmLx8=;
  b=GuDbFOoZPM00ke1Qu/M2fis2ggt9OqYdkcYZ2xieBjUyp453TBL+63a7
   CTlhQf3Fs3vju2k7loHrHOZj45JfYbx2QAZFKHAPGFBYUHoZUkIHMJs94
   olinnU5xqz+Ti/8Tu0TpXQOMQm8BxiCUf9Jmn7mt/9DJzHFCMjLAtQazI
   /NXO/CSyQUm8Vm3oDgfi5HpMHgVB1K24r/VDmJBwPVIn3mV1EGVrergpu
   gPiPE2F53fyYDxI5o4uoCgn4yl6rXx1K3JiUbJzuci/c7Xva4DPbkWDz8
   vnrDYfgl+EcGQml21YN7pVRFoA2OMQ3xoOz2+3Q2segb1e63eNpJrT3fM
   A==;
X-CSE-ConnectionGUID: tzae88kEQsGaPa4xYEJAXw==
X-CSE-MsgGUID: dsw3XEQ2RduxNAZCpUTeLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11761"; a="216036417"
X-IronPort-AV: E=Sophos;i="6.23,183,1770562800"; 
   d="scan'208";a="216036417"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa7.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2026 08:39:58 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id E921D1C000CE
	for <kvmarm@lists.linux.dev>; Thu, 16 Apr 2026 23:39:58 +0000 (UTC)
Received: from az2uksmom2.o.css.fujitsu.com (az2uksmom2.o.css.fujitsu.com [10.151.22.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 97CF3C020B7
	for <kvmarm@lists.linux.dev>; Thu, 16 Apr 2026 23:39:58 +0000 (UTC)
Received: from sm-arm-grace07 (sm-x86-stp01.soft.fujitsu.com [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom2.o.css.fujitsu.com (Postfix) with ESMTPS id 017BC14005BB;
	Thu, 16 Apr 2026 23:39:52 +0000 (UTC)
Date: Fri, 17 Apr 2026 08:39:49 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v2 2/4] KVM: arm64: sefltests: Add helpers for guest
 hypervisors
Message-ID: <aeFzRfEMGlMGFvX7@sm-arm-grace07>
References: <20260412142216.3806482-1-weilin.chang@arm.com>
 <20260412142216.3806482-3-weilin.chang@arm.com>
 <ad68VjnGQ3trs7AN@sm-arm-grace07>
 <2grav6nkabbab3e4gm4vtca63kqrpaegq4xqlhdhwc4l32v65i@x5ksiimtk4er>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2grav6nkabbab3e4gm4vtca63kqrpaegq4xqlhdhwc4l32v65i@x5ksiimtk4er>

On Thu, Apr 16, 2026 at 11:15:57PM +0100, Wei-Lin Chang wrote:
> On Wed, Apr 15, 2026 at 07:14:46AM +0900, Itaru Kitayama wrote:
> > On Sun, Apr 12, 2026 at 03:22:14PM +0100, Wei-Lin Chang wrote:
> > > Add helpers so that guest hypervisors can run nested guests. SP_EL1
> > > save/restore is added to allow nested guests to use a stack.
> > > 
> > > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > > ---
> > >  .../selftests/kvm/include/arm64/nested.h      | 17 +++++++
> > >  tools/testing/selftests/kvm/lib/arm64/entry.S |  5 ++
> > >  .../testing/selftests/kvm/lib/arm64/nested.c  | 46 +++++++++++++++++++
> > >  3 files changed, 68 insertions(+)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/include/arm64/nested.h b/tools/testing/selftests/kvm/include/arm64/nested.h
> > > index 86d931facacb..7928ef89494a 100644
> > > --- a/tools/testing/selftests/kvm/include/arm64/nested.h
> > > +++ b/tools/testing/selftests/kvm/include/arm64/nested.h
> > > @@ -21,8 +21,17 @@
> > >  
> > >  extern char hyp_vectors[];
> > >  
> > > +enum vcpu_sysreg {
> > > +	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
> > > +
> > > +	SP_EL1,
> > > +
> > > +	NR_SYS_REGS
> > > +};
> > > +
> > >  struct cpu_context {
> > >  	struct user_pt_regs regs;	/* sp = sp_el0 */
> > > +	u64 sys_regs[NR_SYS_REGS];
> > >  };
> > >  
> > >  struct vcpu {
> > > @@ -37,9 +46,17 @@ struct hyp_data {
> > >  	struct cpu_context hyp_context;
> > >  };
> > 
> > I am not sure of these structs you introduced only for nested guest feature
> > testing, as the KVM arm64 code they are quite complex and involved, 
> > extracring part of those and add members as hello_nested or simliar
> > tests evolve, then add test cases to me seems fragile. 
> > But if you have strong reason to add these would you mind explaining a bit?
> 
> Sorry, I don't quite get all of your points. I understand your argument
> being evolving these structs as time goes is fragile. For this didn't
> KVM itself evolve like this?
> 
> As for having these structs, how can we make L1 a small hypervisor
> without them?

You're correct and I was wrong. We will just have to change the structs for 
nested virtualization selftests as we add more test cases.

Itaru.

> 
> Thanks,
> Wei-Lin Chang
> 
> > 
> > Thanks,
> > Itaru.
> > 
> > >  
> > > +void prepare_hyp(void);
> > > +void init_vcpu(struct vcpu *vcpu, vm_paddr_t l2_pc, vm_paddr_t l2_stack_top);
> > > +int run_l2(struct vcpu *vcpu, struct hyp_data *hyp_data);
> > > +
> > > +void do_hvc(void);
> > >  u64 __guest_enter(struct vcpu *vcpu, struct cpu_context *hyp_context);
> > >  void __hyp_exception(u64 type);
> > >  
> > > +void __sysreg_save_el1_state(struct cpu_context *ctxt);
> > > +void __sysreg_restore_el1_state(struct cpu_context *ctxt);
> > > +
> > >  #endif /* !__ASSEMBLER__ */
> > >  
> > >  #endif /* SELFTEST_KVM_NESTED_H */
> > > diff --git a/tools/testing/selftests/kvm/lib/arm64/entry.S b/tools/testing/selftests/kvm/lib/arm64/entry.S
> > > index 33bedf5e7fb2..df3af3463c6c 100644
> > > --- a/tools/testing/selftests/kvm/lib/arm64/entry.S
> > > +++ b/tools/testing/selftests/kvm/lib/arm64/entry.S
> > > @@ -3,6 +3,11 @@
> > >   * adapted from arch/arm64/kvm/hyp/entry.S
> > >   */
> > >  
> > > + .globl do_hvc
> > > + do_hvc:
> > > +	hvc	#0
> > > +	ret
> > > +
> > >  /*
> > >   * Manually define these for now
> > >   */
> > > diff --git a/tools/testing/selftests/kvm/lib/arm64/nested.c b/tools/testing/selftests/kvm/lib/arm64/nested.c
> > > index 06ddaab2436f..b30d20b101c4 100644
> > > --- a/tools/testing/selftests/kvm/lib/arm64/nested.c
> > > +++ b/tools/testing/selftests/kvm/lib/arm64/nested.c
> > > @@ -4,7 +4,53 @@
> > >   */
> > >  
> > >  #include "nested.h"
> > > +#include "processor.h"
> > >  #include "test_util.h"
> > > +#include <asm/sysreg.h>
> > > +
> > > +void prepare_hyp(void)
> > > +{
> > > +	write_sysreg(HCR_EL2_E2H | HCR_EL2_RW, hcr_el2);
> > > +	write_sysreg(hyp_vectors, vbar_el2);
> > > +	isb();
> > > +}
> > > +
> > > +void init_vcpu(struct vcpu *vcpu, vm_paddr_t l2_pc, vm_paddr_t l2_stack_top)
> > > +{
> > > +	memset(vcpu, 0, sizeof(*vcpu));
> > > +	vcpu->context.regs.pc = l2_pc;
> > > +	vcpu->context.regs.pstate = PSR_MODE_EL1h | PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
> > > +	vcpu->context.sys_regs[SP_EL1] = l2_stack_top;
> > > +}
> > > +
> > > +void __sysreg_save_el1_state(struct cpu_context *ctxt)
> > > +{
> > > +	ctxt->sys_regs[SP_EL1] = read_sysreg(sp_el1);
> > > +}
> > > +
> > > +void __sysreg_restore_el1_state(struct cpu_context *ctxt)
> > > +{
> > > +	write_sysreg(ctxt->sys_regs[SP_EL1], sp_el1);
> > > +}
> > > +
> > > +int run_l2(struct vcpu *vcpu, struct hyp_data *hyp_data)
> > > +{
> > > +	u64 ret;
> > > +
> > > +	__sysreg_restore_el1_state(&vcpu->context);
> > > +
> > > +	write_sysreg(vcpu->context.regs.pstate, spsr_el2);
> > > +	write_sysreg(vcpu->context.regs.pc, elr_el2);
> > > +
> > > +	ret =  __guest_enter(vcpu, &hyp_data->hyp_context);
> > > +
> > > +	vcpu->context.regs.pc = read_sysreg(elr_el2);
> > > +	vcpu->context.regs.pstate = read_sysreg(spsr_el2);
> > > +
> > > +	__sysreg_save_el1_state(&vcpu->context);
> > > +
> > > +	return ret;
> > > +}
> > >  
> > >  void __hyp_exception(u64 type)
> > >  {
> > > -- 
> > > 2.43.0
> > > 
