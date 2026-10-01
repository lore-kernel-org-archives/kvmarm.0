Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22925470134;
	Thu,  1 Oct 2026 16:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790872551; cv=none; b=OGcXTFPd2JEw5vqe/s/X9JBTa6ALIoSjpgnK3yUUyTeHz8Qm301LxM98Ew20RihlQppZ7S1SyTBdJLAMNBpR8DaUYymBtuv8m0BIVAINO/o+vAuYZG4SNw9L8LCapWadYhUpBAc2yMkSOiy4LfpR2m6IcUnwSk5am0xbXAj57fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790872551; c=relaxed/simple;
	bh=MJNEyOZ8qYgtnDiZUqrJQxZoBIQwm2zkfC0tQotwqvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ov7T2jEfky6imww30tesRMmKj5F2blzGAIwhsscc3iPhK76oITnybRDRF1QBgWlr+LwqTCD1nrBaIf+hm8OJc38fVDpQKkRWfOqVZHjiWbRpfGeCobtGsTRM1Bbr7dux5410VpicDLYdg+SvfZvUFQ0j8Qe01rqeZa9/puQ7fkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTrcsHxL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTrcsHxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7932B1F000FF;
	Thu,  1 Oct 2026 16:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790872549;
	bh=IN28dDZAe3K3lZfF9l0NcUjkfaMwwyHxEzgGdlfdeXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QTrcsHxLZfdUzd6ODa3W8s7j3stVcwcHmwFTAYHF3VmC+oZmCppphB/aUNnA8p2sD
	 NF1a8gRKtWbGWw6QOC4C6eWmwR6FnhmXZudN5GOfcUg2THMXCT9FGQ+NH6NGSvVedU
	 J1Wb+cOAMN+ghusW1AuzeEpLmjzuG77iChkIXQrAIZolPZONjUa52XuNJmN6Z6gBMP
	 AQrsFWjWKANiuKw6uDKO0IrbtAIXNkvYN+lkcTJqOas84YO6eonrUwkIjOUYmDRusM
	 PG6X93IAIm54Uv8qvuNgLSukcuVKAYnizP42ticMm4jbrMSmHQbqBnv880IFBh1AMN
	 f6xzeYYMtkrLw==
Date: Thu, 1 Oct 2026 17:35:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 10/15] KVM: selftests: arm64: Check that invalid
 feature combinations are rejected
Message-ID: <ar6LVCUSUILd8K_d@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-10-3556644cd927@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-arm64-gcs-v21-10-3556644cd927@kernel.org>

On Wed, Sep 30, 2026 at 10:48:20PM +0100, Mark Brown wrote:
> In order to optimise fast paths KVM explicitly rejects configurations with
> S1PIE or S1POE but not TCR2, add coverage of this in the set_id_regs test.
> We have a list of invalid configurations, for each of them we try to run a
> VM and fail the test if it succeeds. We do feature detection by validating
> that we can write the fields with failing values.
>
> Since this misfiring can disrupt some of the other tests due to the kernel
> refusing to start guests we run the new tests first, improving diagnostics
> in the failing case.

Ah so this reflects the changes done to enforce the arch-valid s1pie/poe -> tcr
requirement it seems.

>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Everything seems sensible, so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 87 +++++++++++++++++++++++++
>  1 file changed, 87 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index 7429a1055df5..cb5e6358c59c 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -803,6 +803,89 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
>  	ksft_test_result_pass("%s\n", __func__);
>  }
>
> +struct reg_ftr_val {
> +	u64 reg;
> +	u64 mask;
> +	u64 val;
> +};
> +
> +#define REG_FTR_VAL(r, f, v)					\
> +	{ .reg = ARM64_SYS_REG(sys_reg_Op0(SYS_ ## r),		\
> +			       sys_reg_Op1(SYS_ ## r),		\
> +			       sys_reg_CRn(SYS_ ## r),		\
> +			       sys_reg_CRm(SYS_ ## r),		\
> +			       sys_reg_Op2(SYS_ ## r)),		\
> +	  .mask = r ## _ ## f ## _MASK,				\
> +	  .val = (r ## _ ## f ## _ ## v  << r ## _ ## f ## _SHIFT) }
> +
> +static const struct reg_ftr_val s1pie_no_tcr2[] = {
> +	REG_FTR_VAL(ID_AA64MMFR3_EL1, TCRX, NI),
> +	REG_FTR_VAL(ID_AA64MMFR3_EL1, S1PIE, IMP),
> +	{ }
> +};
> +
> +static const struct reg_ftr_val s1poe_no_tcr2[] = {
> +	REG_FTR_VAL(ID_AA64MMFR3_EL1, TCRX, NI),
> +	REG_FTR_VAL(ID_AA64MMFR3_EL1, S1POE, IMP),
> +	{ }
> +};
> +
> +struct ftr_config {
> +	const char *name;
> +	const struct reg_ftr_val *regs;
> +};
> +
> +static const struct ftr_config invalid_configs[] = {
> +	{ .name = "S1PIE without TCRX", .regs = s1pie_no_tcr2 },
> +	{ .name = "S1POE without TCRX", .regs = s1poe_no_tcr2 },
> +};
> +
> +static void test_invalid_config(const struct ftr_config *config)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	const struct reg_ftr_val *field;
> +	u64 val;
> +	int ret;
> +
> +	vm = vm_create(1);
> +	vm_enable_cap(vm, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0);
> +	vcpu = vm_vcpu_add(vm, 0, guest_code);
> +	kvm_arch_vm_finalize_vcpus(vm);
> +
> +	/*
> +	 * If we don't manage to set any of the fields assume the
> +	 * system does not support the feature and skip the test.
> +	 */
> +	for (field = config->regs; field->reg; field++) {
> +		val = vcpu_get_reg(vcpu, field->reg);
> +		val &= ~field->mask;
> +		val |= field->val;
> +		__vcpu_set_reg(vcpu, field->reg, val);
> +
> +		if (vcpu_get_reg(vcpu, field->reg) != val) {
> +			ksft_print_msg("Test setup not supported\n");
> +			ksft_test_result_skip("refuse %s\n", config->name);
> +			goto out;
> +		}
> +	}
> +
> +	ret = _vcpu_run(vcpu);
> +	ksft_test_result(ret < 0 && errno == EINVAL, "refuse %s\n",
> +			 config->name);
> +out:
> +	kvm_vm_free(vm);
> +}
> +
> +static void test_invalid_configs(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(invalid_configs); i++) {
> +		test_invalid_config(&invalid_configs[i]);
> +	}

VERY NITTY: This is insanely pedantic and I don't mind too much _really_
but in theory should be no {}'s :)

> +}
> +
>  int main(void)
>  {
>  	struct kvm_vcpu *vcpu;
> @@ -829,12 +912,16 @@ int main(void)
>  	ksft_print_header();
>
>  	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
> +	test_cnt += ARRAY_SIZE(invalid_configs);
>  	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
>  		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
>  			test_cnt++;
>
>  	ksft_set_plan(test_cnt);
>
> +	/* Do this first in case a break interferes with other tests */
> +	test_invalid_configs();
> +
>  	test_vm_ftr_id_regs(vcpu, aarch64_only);
>  	test_vcpu_ftr_id_regs(vcpu);
>  	test_vcpu_non_ftr_id_regs(vcpu);
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo
