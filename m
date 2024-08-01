Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD201140E5C
	for <kvmarm@lists.linux.dev>; Thu,  1 Aug 2024 09:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504630; cv=none; b=KPs6inBKs/IeXtA5mHyWkGMJL1qrwiwLngKQ28Tlp+YHNwcUtEIK/MhkvY//6YTPz78ag+hmCQuwzK95lY2avl3Zfv3CsmL1XIYrR7iXLC/TVAmgymnxXjuCgHMxrc0Q6OGaQLGXFgkB7XS47/ASt5VxNRz03dD4kRtUt1hF+/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504630; c=relaxed/simple;
	bh=/OTW+2gYWzzGtg5eh5Ri6h4zgQIrGeCZb7gtCGgQcJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OucnHRfHrp23lKLC+N2EK34RRZJOyRg1uIq2/EyprNyrg7RYUxoD1d9woUn80ue8LYvmcxPMN3xZ5VaE1/pwE0oI5bdapAr+9nld4t3bhTMbQRZQBAVdEBHHZmCOZpzsddcFrPEizCEv5/wiIle2f/fRhXDV3qZ9fSsgfzsl1iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A013EDA7;
	Thu,  1 Aug 2024 02:30:52 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 681BB3F5A1;
	Thu,  1 Aug 2024 02:30:25 -0700 (PDT)
Date: Thu, 1 Aug 2024 10:30:20 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: arm64: Correct feature test for S1PIE in
 get-reg-list
Message-ID: <20240801093020.GA841418@e124191.cambridge.arm.com>
References: <20240731-kvm-arm64-fix-s1pie-test-v1-1-a9253f3b7db4@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240731-kvm-arm64-fix-s1pie-test-v1-1-a9253f3b7db4@kernel.org>

On Wed, Jul 31, 2024 at 05:21:13PM +0100, Mark Brown wrote:
> The ID register for S1PIE is ID_AA64MMFR3_EL1.S1PIE which is bits 11:8 but
> get-reg-list uses a shift of 4, checking SCTLRX instead. Use a shift of 8
> instead.
> 
> Fixes: 5f0419a0083b ("KVM: selftests: get-reg-list: add Permission Indirection registers")
> Signed-off-by: Mark Brown <broonie@kernel.org>

Argh!

Thanks for spotting that.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index 709d7d721760..4abebde78187 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -32,13 +32,13 @@ static struct feature_id_reg feat_id_regs[] = {
>  	{
>  		ARM64_SYS_REG(3, 0, 10, 2, 2),	/* PIRE0_EL1 */
>  		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
> -		4,
> +		8,
>  		1
>  	},
>  	{
>  		ARM64_SYS_REG(3, 0, 10, 2, 3),	/* PIR_EL1 */
>  		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
> -		4,
> +		8,
>  		1
>  	}
>  };
> 
> ---
> base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
> change-id: 20240731-kvm-arm64-fix-s1pie-test-a40b6be58d7b
> 
> Best regards,
> -- 
> Mark Brown <broonie@kernel.org>
> 
