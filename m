Received: from out-124.mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C4E15AF1
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 17:28:05 +0000 (UTC)
Date: Wed, 2 Aug 2023 17:27:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690997283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f+Nw5GQIIve/XJLFBpfVcTqN1pidVBAPz+k1m9s7r00=;
	b=j6TGlJDP/CJ9su+qOKufEOtT5GZXC+H6MzWmrWIlsm1karYrRCpcH7/K1ldqEGP+/9+LwS
	o4E2yWY5sw50JL7k/cvdLZmBfoIcL0+zbzrFSbBoc7ZMl/LT65d+fPYBr4k2bcI6ETNMOi
	gyo0hm66sXoGfVpuXgrM3PLKyGbSakg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Suraj Jitindar Singh <surajjs@amazon.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v7 10/10] KVM: arm64: selftests: Test for setting ID
 register from usersapce
Message-ID: <ZMqSHhFe/4nSN4US@linux.dev>
References: <20230801152007.337272-1-jingzhangos@google.com>
 <20230801152007.337272-11-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230801152007.337272-11-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Jing,

On Tue, Aug 01, 2023 at 08:20:06AM -0700, Jing Zhang wrote:
> Add tests to verify setting ID registers from userapce is handled
> correctly by KVM. Also add a test case to use ioctl
> KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS to get writable masks.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  tools/arch/arm64/include/uapi/asm/kvm.h       |  25 +++
>  tools/include/uapi/linux/kvm.h                |   2 +

Why is this diff needed? I thought we wound up using the latest headers
from the kernel.

>  tools/testing/selftests/kvm/Makefile          |   1 +

Need to add your file to .gitignore too.

>  .../selftests/kvm/aarch64/set_id_regs.c       | 191 ++++++++++++++++++
>  4 files changed, 219 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c

[...]

> diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> new file mode 100644
> index 000000000000..9c8f439ac7b3
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> @@ -0,0 +1,191 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * set_id_regs - Test for setting ID register from usersapce.
> + *
> + * Copyright (c) 2023 Google LLC.
> + *
> + *
> + * Test that KVM supports setting ID registers from userspace and handles the
> + * feature set correctly.
> + */
> +
> +#include <stdint.h>
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "test_util.h"
> +#include <linux/bitfield.h>
> +
> +#define field_get(_mask, _reg) (((_reg) & (_mask)) >> (ffsl(_mask) - 1))
> +#define field_prep(_mask, _val) (((_val) << (ffsl(_mask) - 1)) & (_mask))
> +

Shadowing the naming of the kernel's own FIELD_{GET,PREP}() is a bit
awkward. I'm guessing that you're working around @_mask not being a
compile-time constant?

> +struct reg_feature {
> +	uint64_t reg;
> +	uint64_t ftr_mask;
> +};
> +
> +static void guest_code(void)
> +{
> +	for (;;)
> +		GUEST_SYNC(0);
> +}

The test should check that the written values are visible both from the
guest as well as userspace.

> +static struct reg_feature lower_safe_reg_ftrs[] = {
> +	{ KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), ARM64_FEATURE_MASK(ID_AA64DFR0_WRPS) },
> +	{ KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), ARM64_FEATURE_MASK(ID_AA64PFR0_EL3) },
> +	{ KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1), ARM64_FEATURE_MASK(ID_AA64MMFR0_FGT) },
> +	{ KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR1_EL1), ARM64_FEATURE_MASK(ID_AA64MMFR1_PAN) },
> +	{ KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR2_EL1), ARM64_FEATURE_MASK(ID_AA64MMFR2_FWB) },
> +};

My preference would be to organize the field descriptors by register
rather than the policy. This matches what the kernel does in cpufeature.c
quite closely and allows us to easily reason about which fields are/aren't
tested.

> +static void test_user_set_lower_safe(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(lower_safe_reg_ftrs); i++) {
> +		struct reg_feature *reg_ftr = lower_safe_reg_ftrs + i;
> +		uint64_t val, new_val, ftr;
> +
> +		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> +		ftr = field_get(reg_ftr->ftr_mask, val);
> +
> +		/* Set a safe value for the feature */
> +		if (ftr > 0)
> +			ftr--;
> +
> +		val &= ~reg_ftr->ftr_mask;
> +		val |= field_prep(reg_ftr->ftr_mask, ftr);
> +
> +		vcpu_set_reg(vcpu, reg_ftr->reg, val);
> +		vcpu_get_reg(vcpu, reg_ftr->reg, &new_val);
> +		ASSERT_EQ(new_val, val);
> +	}
> +}
> +
> +static void test_user_set_fail(struct kvm_vcpu *vcpu)
> +{
> +	int i, r;
> +
> +	for (i = 0; i < ARRAY_SIZE(lower_safe_reg_ftrs); i++) {
> +		struct reg_feature *reg_ftr = lower_safe_reg_ftrs + i;
> +		uint64_t val, old_val, ftr;
> +
> +		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> +		ftr = field_get(reg_ftr->ftr_mask, val);
> +
> +		/* Set a invalid value (too big) for the feature */
> +		if (ftr >= GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0))
> +			continue;

This assumes that the fields in the register are unsigned, but there are
several which are not.

> +		ftr++;
> +
> +		old_val = val;
> +		val &= ~reg_ftr->ftr_mask;
> +		val |= field_prep(reg_ftr->ftr_mask, ftr);
> +
> +		r = __vcpu_set_reg(vcpu, reg_ftr->reg, val);
> +		TEST_ASSERT(r < 0 && errno == EINVAL,
> +			    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
> +
> +		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> +		ASSERT_EQ(val, old_val);
> +	}
> +}
> +
> +static struct reg_feature exact_reg_ftrs[] = {
> +	/* Items will be added when there is appropriate field of type
> +	 * FTR_EXACT enabled writing from userspace later.
> +	 */
> +};
> +
> +static void test_user_set_exact(struct kvm_vcpu *vcpu)
> +{
> +	int i, r;
> +
> +	for (i = 0; i < ARRAY_SIZE(exact_reg_ftrs); i++) {
> +		struct reg_feature *reg_ftr = exact_reg_ftrs + i;
> +		uint64_t val, old_val, ftr;
> +
> +		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> +		ftr = field_get(reg_ftr->ftr_mask, val);
> +		old_val = val;
> +
> +		/* Exact match */
> +		vcpu_set_reg(vcpu, reg_ftr->reg, val);
> +		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> +		ASSERT_EQ(val, old_val);
> +
> +		/* Smaller value */
> +		if (ftr > 0) {
> +			ftr--;
> +			val &= ~reg_ftr->ftr_mask;
> +			val |= field_prep(reg_ftr->ftr_mask, ftr);
> +			r = __vcpu_set_reg(vcpu, reg_ftr->reg, val);
> +			TEST_ASSERT(r < 0 && errno == EINVAL,
> +				    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
> +			vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> +			ASSERT_EQ(val, old_val);
> +			ftr++;
> +		}
> +
> +		/* Bigger value */
> +		ftr++;
> +		val &= ~reg_ftr->ftr_mask;
> +		val |= field_prep(reg_ftr->ftr_mask, ftr);
> +		r = __vcpu_set_reg(vcpu, reg_ftr->reg, val);
> +		TEST_ASSERT(r < 0 && errno == EINVAL,
> +			    "Unexpected KVM_SET_ONE_REG error: r=%d, errno=%d", r, errno);
> +		vcpu_get_reg(vcpu, reg_ftr->reg, &val);
> +		ASSERT_EQ(val, old_val);
> +	}
> +}

Don't add dead code, this can be added when we actually test FTR_EXACT
fields. Are there not any in the registers exposed by this series?

> +static uint32_t writable_regs[] = {
> +	SYS_ID_DFR0_EL1,
> +	SYS_ID_AA64DFR0_EL1,
> +	SYS_ID_AA64PFR0_EL1,
> +	SYS_ID_AA64MMFR0_EL1,
> +	SYS_ID_AA64MMFR1_EL1,
> +	SYS_ID_AA64MMFR2_EL1,
> +};
> +
> +void test_user_get_writable_masks(struct kvm_vm *vm)
> +{
> +	struct feature_id_writable_masks masks;
> +
> +	vm_ioctl(vm, KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS, &masks);
> +
> +	for (int i = 0; i < ARRAY_SIZE(writable_regs); i++) {
> +		uint32_t reg = writable_regs[i];
> +		int idx = ARM64_FEATURE_ID_SPACE_IDX(sys_reg_Op0(reg),
> +				sys_reg_Op1(reg), sys_reg_CRn(reg),
> +				sys_reg_CRm(reg), sys_reg_Op2(reg));
> +
> +		ASSERT_EQ(masks.mask[idx], GENMASK_ULL(63, 0));
> +	}
> +}

The more robust test would be to check that every field this test knows
is writable is actually advertised as such in the ioctl. So you could
fetch this array at the start of the entire test and pass it through to
the routines that do granular checks against the fields of every
register.

It'd also be good to see basic sanity tests on the ioctl (i.e. call
fails if ::rsvd is nonzero), since KVM has screwed that up on several
occasions in past.

> +int main(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +
> +	ksft_print_header();
> +	ksft_set_plan(4);
> +
> +	test_user_get_writable_masks(vm);
> +	ksft_test_result_pass("test_user_get_writable_masks\n");
> +
> +	test_user_set_exact(vcpu);
> +	ksft_test_result_pass("test_user_set_exact\n");
> +
> +	test_user_set_fail(vcpu);
> +	ksft_test_result_pass("test_user_set_fail\n");
> +
> +	test_user_set_lower_safe(vcpu);
> +	ksft_test_result_pass("test_user_set_lower_safe\n");
> +
> +	kvm_vm_free(vm);
> +
> +	ksft_finished();
> +}
> -- 
> 2.41.0.585.gd2178a4bd4-goog
> 

-- 
Thanks,
Oliver
