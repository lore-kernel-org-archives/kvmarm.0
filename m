Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9745E33032C
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 09:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767779704; cv=none; b=U2YCsjCvbBjRK/Z4ZSOkNyi4IRyDLlRLnMajvGjNpvKzYFd62PSL2avA792nWW/JegwCAOCPrFqk1V80bIYmivt8OIuiTT2/6bEwTJUNqsP1xwiJ1kJ7zNqycyVhcI77yFof3ySzonx4wjTx2WiijbYSgSLYXx528nQRioVS7V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767779704; c=relaxed/simple;
	bh=vrkv7GDpiRHLHqapN5GYUcOnVs6hQ6GL4tGQ1fm+LNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f4EwVs71qNcfHF/buz87ELZVuMjivet3IKRYuSGHhw54VUnfFnJrO2QwdSScQCI+jTf4btIbCKiIc6O7dm4nBe9nQzwx1cmfmGJXO7DyddDJEtGV8JGe4vXrsIC05yF3Yf3SXGbhgz9hewE+dJNNQdDi+tgB+Pi/5ZKLh1x9Fkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 398DB497;
	Wed,  7 Jan 2026 01:54:55 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 25C213F6A8;
	Wed,  7 Jan 2026 01:55:00 -0800 (PST)
Message-ID: <4cb1ad60-f8cc-4efd-9c9d-9ae52001e547@arm.com>
Date: Wed, 7 Jan 2026 09:54:58 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] KVM: selftests: arm64: Skip all 32 bit IDs when
 set_id_regs is aarch64 only
To: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260106-kvm-arm64-set-id-regs-aarch64-v4-0-c7ef4551afb3@kernel.org>
 <20260106-kvm-arm64-set-id-regs-aarch64-v4-4-c7ef4551afb3@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260106-kvm-arm64-set-id-regs-aarch64-v4-4-c7ef4551afb3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark,

On 1/6/26 16:35, Mark Brown wrote:
> On an aarch64 only system the 32 bit ID registers have UNDEFINED values.
> As a result set_id_regs skips tests for setting fields in these registers
> when testing an aarch64 only guest. This has the side effect of meaning
> that we don't record an expected value for these registers, meaning that
> when the subsequent tests for values being visible in guests and preserved
> over reset check the value they can spuriously fail. This can be seen by
> running on an emulated system with both NV and 32 bit enabled, NV will
> result in the guests created by the test program being 64 bit only but
> the 32 bit ID registers will have values.
> 
> Also skip those tests that use the values set in the field setting tests
> for aarch64 only guests in order to avoid these spurious failures.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 49 ++++++++++++++++++-------
>  1 file changed, 36 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index 5837da63e9b9..908b3c8947d9 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -295,6 +295,13 @@ static const char *get_reg_name(u64 id)
>  	}
>  }
>  
> +static inline bool is_aarch32_id_reg(u64 id)
> +{
> +	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
> +		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
> +		sys_reg_CRm(id) <= 3);
> +}
> +

This check looks correct to me now.

Not touched in this patch but the check for aarch64_only looks suspect to me.

From main()
val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
el0 = FIELD_GET(ID_AA64PFR0_EL1_EL0, val);
aarch64_only = (el0 == ID_AA64PFR0_EL1_EL0_IMP);

As we are concerned with system registers that are accessible from EL1 and higher
should this not be checking ID_AA64PFR0_EL1_EL1 rather than ID_AA64PFR0_EL1_EL0?
Not sure if it makes sense for the two to be different though.

Thanks,

Ben

