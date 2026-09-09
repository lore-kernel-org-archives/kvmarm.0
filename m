Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E171746D56E
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 16:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788972410; cv=none; b=Tpecl8YvxAbF6hOCVcytwIRvvKrYUmO81zc4oQoGSILXdOTlqJrk74g6SViRat3xz8iTIlRifG0ladOTTTc8BEEsEfG2UzEJ09JEcHcOo2ANPGv8A1T6zEK0jmBJdLzZUO1Gg+FuNQhpIDlzQmVvZ3Q8FI3Ffr6UYpNkQir3uqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788972410; c=relaxed/simple;
	bh=4TndDloq+AItaLXnNBU8qh1Mw2UhLyfnZXaiWE4jPS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=OyKAWHXC964qjYzr9yiBUD62tiXqq8IqB0KkBzcAuvQWSRDofHDIo6n+g8waxkCcww/zvBWDxIoJLsaR8hqFAHVUKPysuiTp7VO5zCktTMExSGjEFSnkuYv/ROvatDCdEDZAU/1gZ4yNi+DWXOJP+JZa5CCk8qgdk64ykwzHN4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V1AFUPNb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V1AFUPNb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93B001576;
	Wed,  9 Sep 2026 09:46:44 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B4E13F7B4;
	Wed,  9 Sep 2026 09:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788972408; bh=4TndDloq+AItaLXnNBU8qh1Mw2UhLyfnZXaiWE4jPS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1AFUPNbuhEBKiobjWPCp0b95i41n6A+WoUJXxXvM++FWfL4/j3EOHDrJGD+SPn3c
	 20IMLCfCHD+cyIdQz7CdP9HkJfcWRYNjApsYOoa8Xt0TTcnmYISnSwqro8mN85mAdJ
	 QC80g7Yd0j9M/g9UPcA6bRQiiAJ/2suPHIZKPp34=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Subject: Re: [PATCH v20 10/14] KVM: selftests: arm64: Add GCS registers to get-reg-list
Date: Wed,  9 Sep 2026 17:46:43 +0100
Message-ID: <aqGNc5zg0iRWNU_j@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901-arm64-gcs-v20-10-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-10-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 01, 2026 at 10:47:08PM +0100, Mark Brown wrote:
> GCS adds new registers GCSCR_ELx, GCSCRE0_EL1 and GCSPR_ELx. Add
> these to those validated by get-reg-list.
> 
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/kvm/arm64/get-reg-list.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
> index 533994687b5d..5c1469153b6c 100644
> --- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
> @@ -42,6 +42,12 @@ struct feature_id_reg {
>  static struct feature_id_reg feat_id_regs[] = {
>  	REG_FEAT(TCR2_EL1,	ID_AA64MMFR3_EL1, TCRX, IMP),
>  	REG_FEAT(TCR2_EL2,	ID_AA64MMFR3_EL1, TCRX, IMP),
> +	REG_FEAT(GCSPR_EL0,	ID_AA64PFR1_EL1, GCS, IMP),
> +	REG_FEAT(GCSPR_EL1,	ID_AA64PFR1_EL1, GCS, IMP),
> +	REG_FEAT(GCSPR_EL2,	ID_AA64PFR1_EL1, GCS, IMP),
> +	REG_FEAT(GCSCRE0_EL1,	ID_AA64PFR1_EL1, GCS, IMP),
> +	REG_FEAT(GCSCR_EL1,	ID_AA64PFR1_EL1, GCS, IMP),
> +	REG_FEAT(GCSCR_EL2,	ID_AA64PFR1_EL1, GCS, IMP),
>  	REG_FEAT(PIRE0_EL1,	ID_AA64MMFR3_EL1, S1PIE, IMP),
>  	REG_FEAT(PIRE0_EL2,	ID_AA64MMFR3_EL1, S1PIE, IMP),
>  	REG_FEAT(PIR_EL1,	ID_AA64MMFR3_EL1, S1PIE, IMP),
> @@ -503,6 +509,9 @@ static __u64 base_regs[] = {
>  	ARM64_SYS_REG(3, 0, 2, 0, 1),	/* TTBR1_EL1 */
>  	ARM64_SYS_REG(3, 0, 2, 0, 2),	/* TCR_EL1 */
>  	ARM64_SYS_REG(3, 0, 2, 0, 3),	/* TCR2_EL1 */
> +	ARM64_SYS_REG(3, 0, 2, 5, 0),	/* GCSCR_EL1 */
> +	ARM64_SYS_REG(3, 0, 2, 5, 1),	/* GCSPR_EL1 */
> +	ARM64_SYS_REG(3, 0, 2, 5, 2),	/* GCSCRE0_EL1 */
>  	ARM64_SYS_REG(3, 0, 5, 1, 0),	/* AFSR0_EL1 */
>  	ARM64_SYS_REG(3, 0, 5, 1, 1),	/* AFSR1_EL1 */
>  	ARM64_SYS_REG(3, 0, 5, 2, 0),	/* ESR_EL1 */
> @@ -519,6 +528,7 @@ static __u64 base_regs[] = {
>  	ARM64_SYS_REG(3, 0, 13, 0, 4),	/* TPIDR_EL1 */
>  	ARM64_SYS_REG(3, 0, 14, 1, 0),	/* CNTKCTL_EL1 */
>  	ARM64_SYS_REG(3, 2, 0, 0, 0),	/* CSSELR_EL1 */
> +	ARM64_SYS_REG(3, 3, 2, 5, 1),	/* GCSPR_EL0 */
>  	ARM64_SYS_REG(3, 3, 10, 2, 4),	/* POR_EL0 */
>  	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
>  	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
> @@ -740,6 +750,8 @@ static __u64 el2_regs[] = {
>  	SYS_REG(VTTBR_EL2),
>  	SYS_REG(VTCR_EL2),
>  	SYS_REG(VNCR_EL2),
> +	SYS_REG(GCSPR_EL2),
> +	SYS_REG(GCSCR_EL2),
>  	SYS_REG(HDFGRTR2_EL2),
>  	SYS_REG(HDFGWTR2_EL2),
>  	SYS_REG(HFGRTR2_EL2),
> 

Checked the IDs, everything seems correct.

Thanks!
Leo
