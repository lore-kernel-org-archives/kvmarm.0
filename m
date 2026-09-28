Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22D028686;
	Mon, 28 Sep 2026 15:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609549; cv=none; b=eQQEi+eM3G75v7R67jBQvimciCs1qGGF1vnNZuYhdpTD2354MdQMjA2e8k1RpQYOQl3WGN99j50l+r9yvHmKgOeNxvHv/9ya6IzGOSaBeQr9fCrDp2lEMLJf8RFZ4fvM8QZW9Z9XddUu+oU4QLqvN7mv5Z/WJK4rsru6SA97uIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609549; c=relaxed/simple;
	bh=nMN/ZfJZ5/x4lLlM6Mzl72k/Q/UmYS7ja+KXiOahhrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jPsS64gHMWnXrGJomddSWtrhBp0olRp2A1JxyJ9DLGrbHyQLhqhYeJtwbyjBrJLz+N3Rk6igCYCRrDWVsSwrtS2f55mfwrYDEXZmOIApsTQa4I0HjJHvgNtElmmVOxOf4rp+IOqd2fz/fXGUv+465UIVcllLtpdm4hkzjEcYW4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fs3Ja8i4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fs3Ja8i4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD021F000FF;
	Mon, 28 Sep 2026 15:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790609547;
	bh=llUYIUStfKzWGEiUSq/kXf7+E7RUJ4s4Q/3ArTaa+qQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fs3Ja8i4qjApR6LthEA15//qePnT7LSflp7EONKutl5hrr9xCeZ8nsvtDgcdUlQYd
	 2OAqBnjB24xD37WhSPvFTEpmcuFv47XN3UK1uqxvGwEHhFBpia9a5/vEjBJQvLMrDi
	 MpIIDwY3XxdIOp3KU6m75l2KurbE+OqRO26B/cFd2Q10kPRvPAwie0AFQlTbSerfQt
	 KDao/gDp7DUADjZ/d2aCwh9D2+FtJTym2pXP3EoPVqh/YOFNt71HplBziQqjN6ex21
	 0qtsbvj8eW/mAJlcC1X9qppGIMhmWkaxXVxjt+w/+VHQIsHKKQw1XsW6e+bKJXbblH
	 4dOjXJr9QdMwg==
Date: Mon, 28 Sep 2026 16:32:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/3] KVM: selftests: arm64: Report register reset
 tests individually
Message-ID: <arqHe5v75qT2AJwd@gremlin>
References: <20260901-kvm-arm64-set-id-regs-aarch64-v7-0-7b065b0bda9a@kernel.org>
 <20260901-kvm-arm64-set-id-regs-aarch64-v7-2-7b065b0bda9a@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-kvm-arm64-set-id-regs-aarch64-v7-2-7b065b0bda9a@kernel.org>

On Tue, Sep 01, 2026 at 07:50:02PM +0100, Mark Brown wrote:
> set_id_regs tests that registers have their values preserved over reset.
> Currently it reports all registers in a single test with an instantly fatal
> assert which isn't great for diagnostics, it's hard to tell which register
> failed or if it's just one register. Change this to report each register as
> a separate test so that it's clear from the program output which registers
> have problems.

Sounds reasonable.

>
> Reviewed-by: Ben Horgan <ben.horgan@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

All LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index db6414a93ad3..3aa8886e8b70 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -819,13 +819,21 @@ static void test_vcpu_non_ftr_id_regs(struct kvm_vcpu *vcpu)
>  static void test_assert_id_reg_unchanged(struct kvm_vcpu *vcpu, u32 encoding)
>  {
>  	size_t idx = encoding_to_range_idx(encoding);
> -	u64 observed;
> +	u64 observed, expected;
> +	bool pass;
>
>  	observed = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(encoding));
> -	TEST_ASSERT_EQ(reset_mutable_bits(encoding, test_reg_vals[idx]),
> -		       reset_mutable_bits(encoding, observed));
> +	observed = reset_mutable_bits(encoding, observed);
> +	expected = reset_mutable_bits(encoding, test_reg_vals[idx]);
> +	pass = expected == observed;
> +	if (!pass)
> +		ksft_print_msg("%lx != %lx\n", expected, observed);
> +	ksft_test_result(pass, "%s unchanged by reset\n",
> +			 get_reg_name(encoding));

Ah yeah -> individual tests.

>  }
>
> +#define ID_REG_RESET_UNCHANGED_TEST (ARRAY_SIZE(test_regs) + NUM_EXTRA_REGS)

Yeah can see from original test_reset_preserves_id_regs() that this is correct.

> +
>  static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
>  {
>  	/*
> @@ -843,8 +851,6 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
>  	test_assert_id_reg_unchanged(vcpu, SYS_MIDR_EL1);
>  	test_assert_id_reg_unchanged(vcpu, SYS_REVIDR_EL1);
>  	test_assert_id_reg_unchanged(vcpu, SYS_AIDR_EL1);
> -
> -	ksft_test_result_pass("%s\n", __func__);
>  }
>
>  int main(void)
> @@ -872,7 +878,8 @@ int main(void)
>
>  	ksft_print_header();
>
> -	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST + GUEST_READ_TEST;
> +	test_cnt = 2 + MPAM_IDREG_TEST + MTE_IDREG_TEST + GUEST_READ_TEST +
> +		ID_REG_RESET_UNCHANGED_TEST;
>  	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
>  		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
>  			test_cnt++;
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo
