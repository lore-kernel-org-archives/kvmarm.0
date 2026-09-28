Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54801A6835;
	Mon, 28 Sep 2026 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790606822; cv=none; b=ZdyfshZxBiRnWF3oAwRjeI7N3u9yAvNvi0/79kQagg+zC3lDRHUetmauSnuElEj7FOzl20kXRW7KWWYVHuRYZZ2SWUlriUkjQYDTGwaK4JEmZ/3EUhIYVzi0HZJKTbJno7yU19BQeQz+a+SYCsosJV4t2T822N2f3FFoEAguvQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790606822; c=relaxed/simple;
	bh=zbCPH1gp8E37CKzqvu7k6g1mdsc56Fqts1Xhj5f47ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CFPfM0PC3+QSAn8oNp3wuxyru2DaxixXDIAZUy/yGMEQ5QfusCrAdlBSQt9NWgjOA1K063PMyqhsDHEJBJgUkiqXK10tDiAiC0aE3fIYyK25a/Inv3cBmMWaa+PZaEFiW/B3Y6K7spP0XCG5DW6f4i1KEU9h0uwHy09/O9X2XR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dI22Ru21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dI22Ru21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB391F000FF;
	Mon, 28 Sep 2026 14:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790606817;
	bh=j0t2Y/8RoScbs1ozWBH/tUK6/SLvoQ34K92T2DbWczM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dI22Ru21oM811VNVARN7RQXH51/GaOm1Ypk1BOKqqCxjAYWNh5qSnrzXOSbRpw6SS
	 kzVhJyGtP4a4C4Q6P/H6Oi/RypTbfuEmh8PChk3AIVBazqyvBBaYrgzpBINtUHNM7K
	 3lWDpto1USFeK9JbulsBN1RFz1/kCumKwjPcswUM0I5X2aCpKM60kw1nL3TI/ay7PZ
	 i6lZugu1+jMCRicstAVOIN5qgjJZ7DHUHq2qnQe8x5imeiuvcpSvBCPSBuzBsorDkg
	 WZJAY9H/RdSRlGJcbSyc+ude+et38WUD2DaWcqffjwGVmvCFzgFeVetvscqmKNtB/w
	 K1knt0vp45XSA==
Date: Mon, 28 Sep 2026 15:46:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] KVM: arm64: selftests: Check ID regs are
 immutable after a failed run
Message-ID: <arp7mig_PrD9Jbc7@gremlin>
References: <20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org>
 <20260901-kvm-arm64-idreg-final-v3-3-a0ffa06fa872@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-kvm-arm64-idreg-final-v3-3-a0ffa06fa872@kernel.org>

On Tue, Sep 01, 2026 at 07:18:50PM +0100, Mark Brown wrote:
> From: Fuad Tabba <fuad.tabba@linux.dev>
>
> Add a set_id_regs case covering ID register immutability when a vCPU's
> first KVM_RUN fails after finalization but before
> KVM_ARCH_FLAG_HAS_RAN_ONCE is set. The test provokes such a failure with
> a PMUv3-enabled vCPU whose PMU is left uninitialized, then checks that
> KVM_SET_ONE_REG on the feature and implementation ID registers, and
> KVM_CREATE_DEVICE for a vGIC, are all rejected with -EBUSY.
>
> Assisted-by: Antigravity:gemini-3.1-pro

NIT: we changed the rules for the Assisted-by tag, it only needs to be
'Assisted-by: LLM' now. Not a huge big deal but FYI :>)

https://docs.kernel.org/process/coding-assistants.html

> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Link: https://patch.msgid.link/20260805064740.3013538-1-fuad.tabba@linux.dev

LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 106 +++++++++++++++++++++++-
>  1 file changed, 105 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index 7429a1055df5..10849d21c0dd 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -13,6 +13,7 @@
>  #include "kvm_util.h"
>  #include "processor.h"
>  #include "test_util.h"
> +#include "vgic.h"
>  #include <linux/bitfield.h>
>
>  enum ftr_type {
> @@ -803,6 +804,107 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
>  	ksft_test_result_pass("%s\n", __func__);
>  }
>
> +/*
> + * ID registers must stay immutable even when a vCPU's first KVM_RUN fails
> + * after finalization but before KVM_ARCH_FLAG_HAS_RAN_ONCE is set.
> + */
> +static void test_idreg_frozen_after_failed_run(void)
> +{
> +	static const u32 imp_id_regs[] = {
> +		SYS_MIDR_EL1,
> +		SYS_REVIDR_EL1,
> +		SYS_AIDR_EL1,
> +	};
> +	struct kvm_vcpu_init init;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	int r;
> +
> +	if (!kvm_has_cap(KVM_CAP_ARM_PMU_V3)) {
> +		ksft_print_msg("PMUv3 unsupported, cannot fail the first run\n");
> +		ksft_test_result_skip("%s\n", __func__);
> +		return;
> +	}
> +
> +	/* Skip the default vGIC so the KVM_CREATE_DEVICE gate is reachable. */
> +	test_disable_default_vgic();
> +
> +	vm = vm_create(1);
> +	vm_enable_cap(vm, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0);
> +	kvm_get_default_vcpu_target(vm, &init);
> +	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
> +	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
> +	kvm_arch_vm_finalize_vcpus(vm);
> +
> +	/*
> +	 * A PMUv3 vCPU left without PMU init is rejected by
> +	 * kvm_arm_pmu_v3_enable(), which runs after sysreg finalization.
> +	 */
> +	r = _vcpu_run(vcpu);
> +	TEST_ASSERT(r < 0 && errno == EINVAL,
> +		    "first KVM_RUN should fail post-finalization: r=%d errno=%d",
> +		    r, errno);

Ah nice determinate way of triggering the issue.

> +
> +	/*
> +	 * Feature ID registers: use values that would have been accepted before
> +	 * finalization, so that a rejection means the registers are final
> +	 * rather than the value being invalid.
> +	 */
> +	for (int i = 0; i < ARRAY_SIZE(test_regs); i++) {
> +		const struct reg_ftr_bits *ftr_bits = test_regs[i].ftr_bits;
> +		u64 reg = KVM_ARM64_SYS_REG(test_regs[i].reg);
> +		u64 val = vcpu_get_reg(vcpu, reg);
> +
> +		for (int j = 0; ftr_bits[j].type != FTR_END; j++) {
> +			u64 ftr = (val & ftr_bits[j].mask) >> ftr_bits[j].shift;
> +			u64 safe = get_safe_value(&ftr_bits[j], ftr);
> +			u64 new_val;
> +
> +			if (safe == ftr)
> +				continue;
> +
> +			new_val = (val & ~ftr_bits[j].mask) |
> +				  (safe << ftr_bits[j].shift);
> +
> +			r = __vcpu_set_reg(vcpu, reg, new_val);
> +			TEST_ASSERT(r < 0 && errno == EBUSY,
> +				    "%s write after failed first run: r=%d errno=%d",
> +				    ftr_bits[j].name, r, errno);
> +			TEST_ASSERT_EQ(vcpu_get_reg(vcpu, reg), val);
> +		}
> +
> +		/* A write matching the finalized value is still accepted. */
> +		vcpu_set_reg(vcpu, reg, val);
> +	}
> +
> +	/*
> +	 * The VM-wide implementation ID registers are gated separately. Bit 0
> +	 * is within the writable mask of all three, so flipping it is a change
> +	 * KVM would otherwise accept.
> +	 */

Nice.

> +	for (int i = 0; i < ARRAY_SIZE(imp_id_regs); i++) {
> +		u64 reg = KVM_ARM64_SYS_REG(imp_id_regs[i]);
> +		u64 val = vcpu_get_reg(vcpu, reg);
> +
> +		r = __vcpu_set_reg(vcpu, reg, val ^ 1);

Ah literally a flip.

> +		TEST_ASSERT(r < 0 && errno == EBUSY,
> +			    "implementation ID reg write after failed first run: r=%d errno=%d",
> +			    r, errno);
> +		TEST_ASSERT_EQ(vcpu_get_reg(vcpu, reg), val);
> +	}
> +
> +	/* Creating an in-kernel irqchip would change the ID registers too. */
> +	if (kvm_supports_vgic_v3()) {
> +		r = __kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3);
> +		TEST_ASSERT(r < 0 && errno == EBUSY,
> +			    "vGIC creation after failed first run: r=%d errno=%d",
> +			    r, errno);

I guess in general it's making sure - where there should now be finalisation on
reg setting that this is actually enforced?

> +	}
> +
> +	kvm_vm_free(vm);
> +	ksft_test_result_pass("%s\n", __func__);
> +}
> +
>  int main(void)
>  {
>  	struct kvm_vcpu *vcpu;
> @@ -828,7 +930,7 @@ int main(void)
>
>  	ksft_print_header();
>
> -	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
> +	test_cnt = 4 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
>  	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
>  		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
>  			test_cnt++;
> @@ -847,5 +949,7 @@ int main(void)
>
>  	kvm_vm_free(vm);
>
> +	test_idreg_frozen_after_failed_run();
> +
>  	ksft_finished();
>  }
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo
