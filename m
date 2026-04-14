Received: from esa8.hc1455-7.c3s2.iphmx.com (esa8.hc1455-7.c3s2.iphmx.com [139.138.61.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47E829D260
	for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 22:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.61.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776204399; cv=none; b=kC3vTnSBGgbzKP30uq9cJBPHKKq1aLf+wIvmKn3hXJt8ugwEOwYzRO9p4mDQOPAWKFTvzyGlAe7QE8AQmjGpxSLSmFgNl1wcx1P7lOsvv3FVDC5MGCaGUc+llrsBuxKEs9GE93pO7ohdOX8b+hBo9YF60+OfdATexrJKcBCSNVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776204399; c=relaxed/simple;
	bh=HxWGAfBXvCwu/JrM4wgJOC5/Am3iL5DWNbwqy3PHKCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/2QNfUXcRwbp8DgV9hDgatuD+NSpaw6xdIVzizNA0DnBdQuOGftWtvk8o/bZQlLUiKEI0z+LWDqE8eGGFDBSPKaaq5X3mldOFJ8vxg1Xp7uOyLF5Sj6EMhDpoKElLb6SIngbIuC3YiojVSHEcghoD2suK9c3bQ2FN2umduiKVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=U4/3SeAA; arc=none smtp.client-ip=139.138.61.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="U4/3SeAA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1776204397; x=1807740397;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HxWGAfBXvCwu/JrM4wgJOC5/Am3iL5DWNbwqy3PHKCE=;
  b=U4/3SeAA4sTqXZk9tCYNQvDLEMCruUHuHp+NN5KTZdQtgYj+fdz328db
   qNxgb6sTsHswI6lGveZCJbfxK5s+upxpy4BvHQR/dCK7Ce+Fjc0VIdFy+
   ldp/7Bj6j7hVl0nYfG27DNZFLZT7M6T+imhBgilm+zAMxyAQUpT0m9+3r
   VDwGPt3g3vEw/c0XuOCe0cC7yWB6WjFgKUF2+Pbib0VM0ed++3oES9SB4
   5QukbF1E4hR3fjn7qebtgHv2mjEt+MouHlSJbwIT1mUByOChZkbboyUZd
   ycH/hrswRtFxCZDC/9g4RFbWCSTslx2voP9DKBM7mmL6c+yJCNaH1AVqT
   Q==;
X-CSE-ConnectionGUID: gy1ef0kFQI20KciZBbvicA==
X-CSE-MsgGUID: Z7IenLH7QLy/qqrvLVuiMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11759"; a="224875361"
X-IronPort-AV: E=Sophos;i="6.23,179,1770562800"; 
   d="scan'208";a="224875361"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa8.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 07:05:27 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 338515C21
	for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 22:05:27 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (az2uksmom4.o.css.fujitsu.com [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id D41121C10095
	for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 22:05:26 +0000 (UTC)
Received: from sm-arm-grace07 (sm-x86-stp01.soft.fujitsu.com [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id 407924045EE;
	Tue, 14 Apr 2026 22:05:21 +0000 (UTC)
Date: Wed, 15 Apr 2026 07:05:17 +0900
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
Subject: Re: [PATCH v2 3/4] KVM: arm64: sefltests: Add basic NV selftest
Message-ID: <ad66HasXI2AkEjgK@sm-arm-grace07>
References: <20260412142216.3806482-1-weilin.chang@arm.com>
 <20260412142216.3806482-4-weilin.chang@arm.com>
 <adwofV7yf71OdMFk@sm-arm-grace07>
 <ddr6exocupk6mzshjwvu6sqt57aeqiyxqss3rpgcxxyh54cw4g@rxvm5zh3ybrw>
 <ad1gqsqqOXyYmJoG@sm-arm-grace07>
 <xsdf2k2u4g6n7nmxcgwhiraqodwtteuxqqtnj2dx5sxgu74a7j@yjijkyohkq4i>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xsdf2k2u4g6n7nmxcgwhiraqodwtteuxqqtnj2dx5sxgu74a7j@yjijkyohkq4i>

On Tue, Apr 14, 2026 at 11:16:47AM +0100, Wei-Lin Chang wrote:
> On Tue, Apr 14, 2026 at 06:31:22AM +0900, Itaru Kitayama wrote:
> > On Mon, Apr 13, 2026 at 10:18:42AM +0100, Wei-Lin Chang wrote:
> > > Hi Itaru,
> > > 
> > > On Mon, Apr 13, 2026 at 08:19:25AM +0900, Itaru Kitayama wrote:
> > > > On Sun, Apr 12, 2026 at 03:22:15PM +0100, Wei-Lin Chang wrote:
> > > > > This selftest simply starts an L1, which starts its own guest (L2). L2
> > > > > runs without stage-1 and 2 translations, it calls an HVC to jump back
> > > > > to L1.
> > > > 
> > > > How do you disable both the nested guest (L2)'s MMU and stage 2
> > > > translations?
> > > 
> > > Guest stage-2 is disabled by not setting HCR_EL2.VM in prepare_hyp(),
> > > and stage-1 is disabled by not writing to SCTLR_EL12 in init_vcpu(),
> > > effectively using the default value set by L0. However since SCTLR_EL1
> > > has many architecturally UNKNOWN bits (including SCTLR_EL1.M), it should
> > > be better to write a value before running L2 I suppose...
> > 
> > Thanks. What do you think of using copy_el2_to_el1() macro in at.c, so we
> > can prepare in guest_code() to manipulate the SCTLR_EL12 System register 
> > with the sensible programmed values?
> 
> Yes, using copy_el2_to_el1() can give us an L2 stage-1 that is identical
> to the L1's stage-1. But what I was considering was if guest stage-2 is
> enabled (which we plan to implement), then those stage-1 page tables
> will have to be mapped for L2, and its base address translated to L2IPA.
> It's doable but seems like extra complexity when stage-1 is not so
> interesting for KVM (except for AT?), it lets the guest do whatever it
> likes and let the hardware do the translation.
> 
> Let me know if you have reasons to want stage-1 for L2, there could be
> something I should consider but did not.

By keeping nested guest's MMU enabled, we can exercise the shadow stage
2 on the host. But I am fine with you starting nested guest's IPA and I
hope Marc and Oliver approve this seris and merge upstream.

Thanks,
Itaru.

> 
> Thanks,
> Wei-Lin Chang
> 
> > 
> > Itaru.
> > 
> > > 
> > > Thanks,
> > > Wei-Lin Chang
> > > 
> > > > 
> > > > Itaru.
> > > > 
> > > > > 
> > > > > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > > > > ---
> > > > >  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
> > > > >  .../selftests/kvm/arm64/hello_nested.c        | 103 ++++++++++++++++++
> > > > >  2 files changed, 104 insertions(+)
> > > > >  create mode 100644 tools/testing/selftests/kvm/arm64/hello_nested.c
> > > > > 
> > > > > diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> > > > > index 3dc3e39f7025..e8c108e0c487 100644
> > > > > --- a/tools/testing/selftests/kvm/Makefile.kvm
> > > > > +++ b/tools/testing/selftests/kvm/Makefile.kvm
> > > > > @@ -168,6 +168,7 @@ TEST_GEN_PROGS_arm64 += arm64/arch_timer_edge_cases
> > > > >  TEST_GEN_PROGS_arm64 += arm64/at
> > > > >  TEST_GEN_PROGS_arm64 += arm64/debug-exceptions
> > > > >  TEST_GEN_PROGS_arm64 += arm64/hello_el2
> > > > > +TEST_GEN_PROGS_arm64 += arm64/hello_nested
> > > > >  TEST_GEN_PROGS_arm64 += arm64/host_sve
> > > > >  TEST_GEN_PROGS_arm64 += arm64/hypercalls
> > > > >  TEST_GEN_PROGS_arm64 += arm64/external_aborts
> > > > > diff --git a/tools/testing/selftests/kvm/arm64/hello_nested.c b/tools/testing/selftests/kvm/arm64/hello_nested.c
> > > > > new file mode 100644
> > > > > index 000000000000..97387e4697b3
> > > > > --- /dev/null
> > > > > +++ b/tools/testing/selftests/kvm/arm64/hello_nested.c
> > > > > @@ -0,0 +1,103 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > > +/*
> > > > > + * hello_nested - Go from vEL2 to EL1 then back
> > > > > + */
> > > > > +
> > > > > +#include "nested.h"
> > > > > +#include "processor.h"
> > > > > +#include "test_util.h"
> > > > > +#include "ucall.h"
> > > > > +
> > > > > +#define XLATE2GPA	(0xABCD)
> > > > > +#define L2STACKSZ	(0x100)
> > > > > +
> > > > > +/*
> > > > > + * TPIDR_EL2 is used to store vcpu id, so save and restore it.
> > > > > + */
> > > > > +static vm_paddr_t ucall_translate_to_gpa(void *gva)
> > > > > +{
> > > > > +	vm_paddr_t gpa;
> > > > > +	u64 vcpu_id = read_sysreg(tpidr_el2);
> > > > > +
> > > > > +	GUEST_SYNC2(XLATE2GPA, gva);
> > > > > +
> > > > > +	/* get the result from userspace */
> > > > > +	gpa = read_sysreg(tpidr_el2);
> > > > > +
> > > > > +	write_sysreg(vcpu_id, tpidr_el2);
> > > > > +
> > > > > +	return gpa;
> > > > > +}
> > > > > +
> > > > > +static void l2_guest_code(void)
> > > > > +{
> > > > > +	do_hvc();
> > > > > +}
> > > > > +
> > > > > +static void guest_code(void)
> > > > > +{
> > > > > +	struct vcpu vcpu;
> > > > > +	struct hyp_data hyp_data;
> > > > > +	int ret;
> > > > > +	vm_paddr_t l2_pc, l2_stack_top;
> > > > > +	/* force 16-byte alignment for the stack pointer */
> > > > > +	u8 l2_stack[L2STACKSZ] __attribute__((aligned(16)));
> > > > > +
> > > > > +	GUEST_ASSERT_EQ(get_current_el(), 2);
> > > > > +	GUEST_PRINTF("vEL2 entry\n");
> > > > > +
> > > > > +	l2_pc = ucall_translate_to_gpa(l2_guest_code);
> > > > > +	l2_stack_top = ucall_translate_to_gpa(&l2_stack[L2STACKSZ]);
> > > > > +
> > > > > +	init_vcpu(&vcpu, l2_pc, l2_stack_top);
> > > > > +	prepare_hyp();
> > > > > +
> > > > > +	ret = run_l2(&vcpu, &hyp_data);
> > > > > +	GUEST_ASSERT_EQ(ret, ARM_EXCEPTION_TRAP);
> > > > > +	GUEST_DONE();
> > > > > +}
> > > > > +
> > > > > +int main(void)
> > > > > +{
> > > > > +	struct kvm_vcpu_init init;
> > > > > +	struct kvm_vcpu *vcpu;
> > > > > +	struct kvm_vm *vm;
> > > > > +	struct ucall uc;
> > > > > +	vm_paddr_t gpa;
> > > > > +
> > > > > +	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
> > > > > +	vm = vm_create(1);
> > > > > +
> > > > > +	kvm_get_default_vcpu_target(vm, &init);
> > > > > +	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
> > > > > +	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
> > > > > +	kvm_arch_vm_finalize_vcpus(vm);
> > > > > +
> > > > > +	while (true) {
> > > > > +		vcpu_run(vcpu);
> > > > > +
> > > > > +		switch (get_ucall(vcpu, &uc)) {
> > > > > +		case UCALL_SYNC:
> > > > > +			if (uc.args[0] == XLATE2GPA) {
> > > > > +				gpa = addr_gva2gpa(vm, (vm_vaddr_t)uc.args[1]);
> > > > > +				vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TPIDR_EL2), gpa);
> > > > > +			}
> > > > > +			break;
> > > > > +		case UCALL_PRINTF:
> > > > > +			pr_info("%s", uc.buffer);
> > > > > +			break;
> > > > > +		case UCALL_DONE:
> > > > > +			pr_info("DONE!\n");
> > > > > +			goto end;
> > > > > +		case UCALL_ABORT:
> > > > > +			REPORT_GUEST_ASSERT(uc);
> > > > > +			fallthrough;
> > > > > +		default:
> > > > > +			TEST_FAIL("Unhandled ucall: %ld\n", uc.cmd);
> > > > > +		}
> > > > > +	}
> > > > > +
> > > > > +end:
> > > > > +	kvm_vm_free(vm);
> > > > > +	return 0;
> > > > > +}
> > > > > -- 
> > > > > 2.43.0
> > > > > 
