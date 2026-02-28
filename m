Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C1720D4E9
	for <kvmarm@lists.linux.dev>; Sat, 28 Feb 2026 09:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772271849; cv=none; b=WZNzDSqhV4EonUcFCKkpe4yj+MN1z1jAG3QsCHDSfO+9YD0btN620Z4XUYdGawI0KBCSTaCnT4TpeZUEgwoEXQSZAGhM3EKhrwOZxQDqlYFaTIBccteS1sFlHTe3/XIB1ceQHyevm3p78YQiqvj/b8e5i/mBBmQEUacIXslovQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772271849; c=relaxed/simple;
	bh=U5WRADLgmsNiwrDG4dFU/aUg/dShHBO37b4zDOyearE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=boaX+oqFW9RYbJsdF3YJAbFWatHsE13hU0zemR5NQ7IVZjB0CFpBY1mFHZ9jy7JaUK+693aXfcyIBKXMKg6omWlvuGMMeWUoccqG91dpex4/Qqz+GVbBVvBo1Xt7Ti2Ssf00fSjEcFc+Ql7Dgml68E8PMHapyFszlhD0UcfvSLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SLgKRjeR; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SLgKRjeR"
Message-ID: <b951dcfb-0ad1-4d7b-b6ce-d54b272dd9be@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772271845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OCLMWkVsU+ulkeuAdY5/iYGTKPWnzE1irJxnFoArRrY=;
	b=SLgKRjeRmkCEQPqdKloaJQQuXtxuB7sCArvh+NjE1z49mC6LKoYl1NVOnnPcBLCwOwJtNH
	L+87+eKqogVpu1LXXUyURWngobWmZbxt9c6iTfyrPYHAslZ5JFKeVCANwhfIcm51ZpA2N0
	1meiiaPRTzOBWUmJyF1DR/GgDcZ6kyE=
Date: Sat, 28 Feb 2026 17:43:59 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH v3 15/15] KVM: arm64: selftests: Add test for AT emulation
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20251124190158.177318-1-oupton@kernel.org>
 <20251124190158.177318-16-oupton@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20251124190158.177318-16-oupton@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Oliver,

On 11/25/25 3:01 AM, Oliver Upton wrote:
> Add a basic test for AT emulation in the EL2&0 and EL1&0 translation
> regimes.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>  tools/testing/selftests/kvm/arm64/at.c        | 166 ++++++++++++++++++
>  .../testing/selftests/kvm/include/kvm_util.h  |   1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  10 ++
>  4 files changed, 178 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/arm64/at.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 148d427ff24b..81b3aa54678a 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -156,6 +156,7 @@ TEST_GEN_PROGS_EXTENDED_x86 += x86/nx_huge_pages_test
>  TEST_GEN_PROGS_arm64 = $(TEST_GEN_PROGS_COMMON)
>  TEST_GEN_PROGS_arm64 += arm64/aarch32_id_regs
>  TEST_GEN_PROGS_arm64 += arm64/arch_timer_edge_cases
> +TEST_GEN_PROGS_arm64 += arm64/at
>  TEST_GEN_PROGS_arm64 += arm64/debug-exceptions
>  TEST_GEN_PROGS_arm64 += arm64/hello_el2
>  TEST_GEN_PROGS_arm64 += arm64/host_sve
> diff --git a/tools/testing/selftests/kvm/arm64/at.c b/tools/testing/selftests/kvm/arm64/at.c
> new file mode 100644
> index 000000000000..acecb6ab5071
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/at.c
> @@ -0,0 +1,166 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * at - Test for KVM's AT emulation in the EL2&0 and EL1&0 translation regimes.
> + */
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "test_util.h"
> +#include "ucall.h"
> +
> +#include <asm/sysreg.h>
> +
> +#define TEST_ADDR	0x80000000
> +
> +enum {
> +	CLEAR_ACCESS_FLAG,
> +	TEST_ACCESS_FLAG,
> +};
> +
> +static u64 *ptep_hva;
> +
> +#define copy_el2_to_el1(reg)						\
> +	write_sysreg_s(read_sysreg_s(SYS_##reg##_EL1), SYS_##reg##_EL12)
> +
> +/* Yes, this is an ugly hack */
> +#define __at(op, addr)	write_sysreg_s(addr, op)
> +
> +#define test_at_insn(op, expect_fault)							\
> +do {											\
> +	u64 par, fsc;									\
> +	bool fault;									\
> +											\
> +	GUEST_SYNC(CLEAR_ACCESS_FLAG);							\
> +											\
> +	__at(OP_AT_##op, TEST_ADDR);							\
> +	isb();										\
> +	par = read_sysreg(par_el1);							\
> +											\
> +	fault = par & SYS_PAR_EL1_F;							\
> +	fsc = FIELD_GET(SYS_PAR_EL1_FST, par);						\
> +											\
> +	__GUEST_ASSERT((expect_fault) == fault,						\
> +		       "AT "#op": %sexpected fault (par: %lx)1",			\
> +		       (expect_fault) ? "" : "un", par);				\
> +	if ((expect_fault)) {								\
> +		__GUEST_ASSERT(fsc == ESR_ELx_FSC_ACCESS_L(3),				\
> +			       "AT "#op": expected access flag fault (par: %lx)",	\
> +			       par);							\
> +	} else {									\
> +		GUEST_ASSERT_EQ(FIELD_GET(SYS_PAR_EL1_ATTR, par), MAIR_ATTR_NORMAL);	\
> +		GUEST_ASSERT_EQ(FIELD_GET(SYS_PAR_EL1_SH, par), PTE_SHARED >> 8);	\
> +		GUEST_ASSERT_EQ(par & SYS_PAR_EL1_PA, TEST_ADDR);			\
> +		GUEST_SYNC(TEST_ACCESS_FLAG);						\
> +	}										\
> +} while (0)
> +
> +static void test_at(bool expect_fault)
> +{
> +	test_at_insn(S1E2R, expect_fault);
> +	test_at_insn(S1E2W, expect_fault);
> +
> +	/* Reuse the stage-1 MMU context from EL2 at EL1 */
> +	copy_el2_to_el1(SCTLR);
> +	copy_el2_to_el1(MAIR);
> +	copy_el2_to_el1(TCR);
> +	copy_el2_to_el1(TTBR0);
> +	copy_el2_to_el1(TTBR1);
> +
> +	/* Disable stage-2 translation and enter a non-host context */
> +	write_sysreg(0, vtcr_el2);
> +	write_sysreg(0, vttbr_el2);
> +	sysreg_clear_set(hcr_el2, HCR_EL2_TGE | HCR_EL2_VM, 0);
> +	isb();
> +
> +	test_at_insn(S1E1R, expect_fault);
> +	test_at_insn(S1E1W, expect_fault);
> +}
> +
> +static void guest_code(void)
> +{
> +	sysreg_clear_set(tcr_el1, TCR_HA, 0);
> +	isb();
> +
> +	test_at(true);
> +
> +	if (!SYS_FIELD_GET(ID_AA64MMFR1_EL1, HAFDBS, read_sysreg(id_aa64mmfr1_el1)))
> +		GUEST_DONE();
> +
> +	/*
> +	 * KVM's software PTW makes the implementation choice that the AT
> +	 * instruction sets the access flag.
> +	 */
> +	sysreg_clear_set(tcr_el1, 0, TCR_HA);
> +	isb();
> +	test_at(false);
> +
> +	GUEST_DONE();
> +}
> +
> +static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
> +{
> +	switch (uc->args[1]) {
> +	case CLEAR_ACCESS_FLAG:
> +		/*
> +		 * Delete + reinstall the memslot to invalidate stage-2
> +		 * mappings of the stage-1 page tables, forcing KVM to
> +		 * use the 'slow' AT emulation path.

Once the guest continues executing instructions, we would get a stage 2
translation fault (on a S1 PTW) immediately and re-build the stage 2
mappings for the S1 page tables. Depends on how much we have re-built
for S1 page tables, the "forcing KVM to use the 'slow' AT emulation
path" may not always be true.

I tested it in a QEMU guest (with "-machine virt,virtualization=on \
-cpu max -accel tcg", so it's essentially a NV2 capable HW!) and it
failed at the first test_at_insn(S1E2R, expect_fault):

[root@localhost arm64]# getconf PAGESIZE
65536
[root@localhost arm64]# ./at
Random seed: 0x6b8b4567
__vm_create: mode='PA-bits:40,  VA-bits:48,  4K pages' type='0', pages='672'
==== Test Assertion Failure ====
  arm64/at.c:58: (expect_fault) == fault
  pid=824 tid=824 errno=4 - Interrupted system call
     1	0x0000000000402d8f: run_test at at.c:137
     2	0x00000000004020e3: main at at.c:162
     3	0x0000ffffb07daf3b: ?? ??:0
     4	0x0000ffffb07db007: ?? ??:0
     5	0x000000000040222f: _start at ??:?
  AT S1E2R: expected fault (par: ff00000080000b80)1

because in my test, the S1 page tables used to translate TEST_ADDR are
located at

	level 0: 0x180000
	level 1: 0x181000
	level 2: 0x187000
	level 3: 0x188000

All of them had already been re-mapped in stage 2 [*] (in the same 64KB
physical page) before KVM started to emulate AT S1E2R. The AT_S1E1R
(fast path) will successfully get the translation result and it's IMP
DEF that whether an access flag fault will be triggered (QEMU chooses to
not fault). Whatever, [*] is out of expect and result in the failure.

I have no idea that if we can actually force the slow emulation path.

Thanks,
Zenghui

> +		 *
> +		 * This and clearing the access flag from host userspace
> +		 * ensures that the access flag cannot be set speculatively
> +		 * and is reliably cleared at the time of the AT instruction.
> +		 */
> +		clear_bit(__ffs(PTE_AF), ptep_hva);
> +		vm_mem_region_reload(vcpu->vm, vcpu->vm->memslots[MEM_REGION_PT]);
> +		break;
> +	case TEST_ACCESS_FLAG:
> +		TEST_ASSERT(test_bit(__ffs(PTE_AF), ptep_hva),
> +			    "Expected access flag to be set (desc: %lu)", *ptep_hva);
> +		break;
> +	default:
> +		TEST_FAIL("Unexpected SYNC arg: %lu", uc->args[1]);
> +	}
> +}
> +
> +static void run_test(struct kvm_vcpu *vcpu)
> +{
> +	struct ucall uc;
> +
> +	while (true) {
> +		vcpu_run(vcpu);
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_DONE:
> +			return;
> +		case UCALL_SYNC:
> +			handle_sync(vcpu, &uc);
> +			continue;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			return;
> +		default:
> +			TEST_FAIL("Unexpeced ucall: %lu", uc.cmd);
> +		}
> +	}
> +}
> +
> +int main(void)
> +{
> +	struct kvm_vcpu_init init;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +
> +	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
> +
> +	vm = vm_create(1);
> +
> +	kvm_get_default_vcpu_target(vm, &init);
> +	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
> +	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
> +	kvm_arch_vm_finalize_vcpus(vm);
> +
> +	virt_map(vm, TEST_ADDR, TEST_ADDR, 1);
> +	ptep_hva = virt_get_pte_hva_at_level(vm, TEST_ADDR, 3);
> +	run_test(vcpu);
> +
> +	kvm_vm_free(vm);
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index d3f3e455c031..41467dad9178 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -715,6 +715,7 @@ static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
>  #endif
>  
>  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
> +void vm_mem_region_reload(struct kvm_vm *vm, uint32_t slot);
>  void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
>  void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
>  struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 1a93d6361671..d6538bb17740 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1201,6 +1201,16 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
>  		ret, errno, slot, flags);
>  }
>  
> +void vm_mem_region_reload(struct kvm_vm *vm, uint32_t slot)
> +{
> +	struct userspace_mem_region *region = memslot2region(vm, slot);
> +	struct kvm_userspace_memory_region2 tmp = region->region;
> +
> +	tmp.memory_size = 0;
> +	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &tmp);
> +	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
> +}
> +
>  /*
>   * VM Memory Region Move
>   *
