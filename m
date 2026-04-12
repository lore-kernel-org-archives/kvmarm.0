Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B7231B838
	for <kvmarm@lists.linux.dev>; Sun, 12 Apr 2026 23:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776036046; cv=none; b=JWJ58/wwYLGTKKDCV14lvUabPlU1L4IgaYqQmbC7b05XWyoo8xY/PCZ26TBrEqrDR+QNdkqTFlFUy05OOhp09tZUx05B/HORI1YRo2b8yMjptWZ9x9Q2cXzhHO+/7IVNgTJ5j1in4v1Blrm8/99vu5o+e1o3yVGb4qNxJhe1UL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776036046; c=relaxed/simple;
	bh=dSiGV4THsNldWCR0gdH7gTTx/gc3SmssWzHxsLk2kPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sDVslk3Qpx8pl4c557phBxMiKK66d7AR717b7KhC2TP48H2CedhYkHMjNV84F7Y9jZPisQ7G5XzYa2OGIb1pOJziQ5n6geHhOy1atvWWT/kHKIPzhrC1HLaA/KyvDMT7pspL1B3AQw5yF1FzqF32PU0nlMRjF1Vak/RG5hVsrgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=Y+q/tAEv; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="Y+q/tAEv"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1776036043; x=1807572043;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dSiGV4THsNldWCR0gdH7gTTx/gc3SmssWzHxsLk2kPg=;
  b=Y+q/tAEvoCXuWczblY6pZFpeL+bFvXV2/6g8OUbFRwT7riELx54vA5VK
   RNKpqjh0p0KXtz3DMKwTm/SRjdCjQe+zaL2L9fdl+eD42wrR1L487815X
   pQyvLydKvs5M+kzg4HF49Ydu94FOkdlztQTNuxSNOCEJMxTktvqQjSTEq
   z4rtWUv4J6S1xd9vNN4bwaiweqkwMT1M5uXG/zVeM1tfjmDjJvb06V2J2
   tzaYKpsrZLWEyqERyYjrlpYlqGMA3HMVZKMHAg8AbN6nWymfwRXeYV+34
   PPTLeW6j97Wx4VG1LMErkkUEYFUrIzQhlTwqMuLYWWhzRGriCzC4eATvt
   w==;
X-CSE-ConnectionGUID: HZqCwSuUQK2zTOhmnYlI0A==
X-CSE-MsgGUID: DSui0ykSTQazCxGnobpEVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11757"; a="236686893"
X-IronPort-AV: E=Sophos;i="6.23,176,1770562800"; 
   d="scan'208";a="236686893"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2026 08:19:33 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 818212B98
	for <kvmarm@lists.linux.dev>; Sun, 12 Apr 2026 23:19:34 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (az2uksmom4.o.css.fujitsu.com [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 21664C01283
	for <kvmarm@lists.linux.dev>; Sun, 12 Apr 2026 23:19:34 +0000 (UTC)
Received: from sm-arm-grace07 (sm-x86-stp01.soft.fujitsu.com [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id 88C53404698;
	Sun, 12 Apr 2026 23:19:28 +0000 (UTC)
Date: Mon, 13 Apr 2026 08:19:25 +0900
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
Message-ID: <adwofV7yf71OdMFk@sm-arm-grace07>
References: <20260412142216.3806482-1-weilin.chang@arm.com>
 <20260412142216.3806482-4-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260412142216.3806482-4-weilin.chang@arm.com>

On Sun, Apr 12, 2026 at 03:22:15PM +0100, Wei-Lin Chang wrote:
> This selftest simply starts an L1, which starts its own guest (L2). L2
> runs without stage-1 and 2 translations, it calls an HVC to jump back
> to L1.

How do you disable both the nested guest (L2)'s MMU and stage 2
translations?

Itaru.

> 
> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>  .../selftests/kvm/arm64/hello_nested.c        | 103 ++++++++++++++++++
>  2 files changed, 104 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/arm64/hello_nested.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 3dc3e39f7025..e8c108e0c487 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -168,6 +168,7 @@ TEST_GEN_PROGS_arm64 += arm64/arch_timer_edge_cases
>  TEST_GEN_PROGS_arm64 += arm64/at
>  TEST_GEN_PROGS_arm64 += arm64/debug-exceptions
>  TEST_GEN_PROGS_arm64 += arm64/hello_el2
> +TEST_GEN_PROGS_arm64 += arm64/hello_nested
>  TEST_GEN_PROGS_arm64 += arm64/host_sve
>  TEST_GEN_PROGS_arm64 += arm64/hypercalls
>  TEST_GEN_PROGS_arm64 += arm64/external_aborts
> diff --git a/tools/testing/selftests/kvm/arm64/hello_nested.c b/tools/testing/selftests/kvm/arm64/hello_nested.c
> new file mode 100644
> index 000000000000..97387e4697b3
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/hello_nested.c
> @@ -0,0 +1,103 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * hello_nested - Go from vEL2 to EL1 then back
> + */
> +
> +#include "nested.h"
> +#include "processor.h"
> +#include "test_util.h"
> +#include "ucall.h"
> +
> +#define XLATE2GPA	(0xABCD)
> +#define L2STACKSZ	(0x100)
> +
> +/*
> + * TPIDR_EL2 is used to store vcpu id, so save and restore it.
> + */
> +static vm_paddr_t ucall_translate_to_gpa(void *gva)
> +{
> +	vm_paddr_t gpa;
> +	u64 vcpu_id = read_sysreg(tpidr_el2);
> +
> +	GUEST_SYNC2(XLATE2GPA, gva);
> +
> +	/* get the result from userspace */
> +	gpa = read_sysreg(tpidr_el2);
> +
> +	write_sysreg(vcpu_id, tpidr_el2);
> +
> +	return gpa;
> +}
> +
> +static void l2_guest_code(void)
> +{
> +	do_hvc();
> +}
> +
> +static void guest_code(void)
> +{
> +	struct vcpu vcpu;
> +	struct hyp_data hyp_data;
> +	int ret;
> +	vm_paddr_t l2_pc, l2_stack_top;
> +	/* force 16-byte alignment for the stack pointer */
> +	u8 l2_stack[L2STACKSZ] __attribute__((aligned(16)));
> +
> +	GUEST_ASSERT_EQ(get_current_el(), 2);
> +	GUEST_PRINTF("vEL2 entry\n");
> +
> +	l2_pc = ucall_translate_to_gpa(l2_guest_code);
> +	l2_stack_top = ucall_translate_to_gpa(&l2_stack[L2STACKSZ]);
> +
> +	init_vcpu(&vcpu, l2_pc, l2_stack_top);
> +	prepare_hyp();
> +
> +	ret = run_l2(&vcpu, &hyp_data);
> +	GUEST_ASSERT_EQ(ret, ARM_EXCEPTION_TRAP);
> +	GUEST_DONE();
> +}
> +
> +int main(void)
> +{
> +	struct kvm_vcpu_init init;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +	vm_paddr_t gpa;
> +
> +	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
> +	vm = vm_create(1);
> +
> +	kvm_get_default_vcpu_target(vm, &init);
> +	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
> +	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
> +	kvm_arch_vm_finalize_vcpus(vm);
> +
> +	while (true) {
> +		vcpu_run(vcpu);
> +
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_SYNC:
> +			if (uc.args[0] == XLATE2GPA) {
> +				gpa = addr_gva2gpa(vm, (vm_vaddr_t)uc.args[1]);
> +				vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TPIDR_EL2), gpa);
> +			}
> +			break;
> +		case UCALL_PRINTF:
> +			pr_info("%s", uc.buffer);
> +			break;
> +		case UCALL_DONE:
> +			pr_info("DONE!\n");
> +			goto end;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			fallthrough;
> +		default:
> +			TEST_FAIL("Unhandled ucall: %ld\n", uc.cmd);
> +		}
> +	}
> +
> +end:
> +	kvm_vm_free(vm);
> +	return 0;
> +}
> -- 
> 2.43.0
> 
