Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49945678DB
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 16:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788972928; cv=none; b=Dyio6f4d1vL95aMaZ84trYYzlA+Q1Xw2zER9BACH9nS7jq+LHvxAZlxCQ+EVJ5xdcKhT4jU8OuFxcNCMCsbt/CbW4mQaWcdinw5Z6pfe1ngcpVeqb9WaBN93YPrTTQVaAV0Q9mmnKw8aeCPyEVQjiKvycvafi8kIcHETuhZP5hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788972928; c=relaxed/simple;
	bh=0ZZI/KQsrsxir9xpZ2e67XFkv+lIjYBkixLNLg+JqcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=NJxu+VY8FTe8iYbB/o7mSZMKTkjJ+vukYl4/Zxj9GoLC/BILAsvLmM2SR1EQv2OjvHvT0QzinTZu6MKlUnPZy8HfHIYzetYg/uf1o+LZjxOfZ6EJrTXB7+PegkuYz2EweNXapEZDNIBx8FdV/nu38XR7OfKHS8r30fmdG18WKX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=p7E4Iz8A; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="p7E4Iz8A"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 987061576;
	Wed,  9 Sep 2026 09:55:22 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24FB73F7B4;
	Wed,  9 Sep 2026 09:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788972926; bh=0ZZI/KQsrsxir9xpZ2e67XFkv+lIjYBkixLNLg+JqcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7E4Iz8AEmwE9eJUybEYpXA9pQPs+YN2nE6ETxwxK8uhWohpguGgbsJ11vYrUCiVF
	 oRqlb18xdfzpoDUW/sRj7s7zRMJSUlXUwINHO3u8NJ97dOFg8YgNtWvAahNwrYX2Qp
	 eKi8URD5ojwhccTUcvGBZKwjXsK8MtkPlsklYUzM=
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
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 11/14] KVM: selftests: arm64: Add GCS to set_id_regs
Date: Wed,  9 Sep 2026 17:55:22 +0100
Message-ID: <aqGPeT8sKx3Lh_Mx@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901-arm64-gcs-v20-11-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-11-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 01, 2026 at 10:47:09PM +0100, Mark Brown wrote:
> Now that GCS is configurable via the ID registers update set_id_regs to
> cover ID_AA64PFR1_EL1.GCS.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index 7429a1055df5..34e59fbbbe89 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -154,6 +154,7 @@ static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
>  
>  static const struct reg_ftr_bits ftr_id_aa64pfr1_el1[] = {
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, DF2, 0),
> +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, GCS, 0),
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, CSV2_frac, 0),
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, SSBS, ID_AA64PFR1_EL1_SSBS_NI),
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, BT, 0),

Check this register for this GCS field, any value >= 0 is safe.
Used to test setting id_regs IIUC.

If that's correct, then:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks,
Leo
