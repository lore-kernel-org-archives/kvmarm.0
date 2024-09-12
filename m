Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D46018BBB5
	for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 10:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726136558; cv=none; b=B07mL81sR14XvMDYJD0Mwoc6eqrKAwSlgLN1LBQbqIpeXE6sWlS0Kdhgaluq1mxGF+lmyEZuwkSFl7dGq7QdGJGfbZeNYKF66VX2TAn4vIUFth/+m8YONsVBcfqTDyaeS52Xho+pNV5KgNd+WtBO323AwOXvItCyN/UVTC2IUqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726136558; c=relaxed/simple;
	bh=VMpDt884KdbpdP5L4n9jO2joLdam1JBNsqXA0BFh70U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C8CNPCVXAUlbRcUvAYVM2UV2WjzPYIKaer8/IUf3HJ2uOdwFVM2ESUQj0gpBmNvqJYpxVYkEobMLEziDGgadDZSIMz6RcdFl9Z7uOdidguC1DPcq4FLSpez+nH0NiSjAd9qZQXNY/7sq8S1SR/Su4d1m1Mlh4Dzap6WWAIKzV+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AB44DA7;
	Thu, 12 Sep 2024 03:23:06 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 431633F73B;
	Thu, 12 Sep 2024 03:22:35 -0700 (PDT)
Date: Thu, 12 Sep 2024 11:22:32 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 01/24] arm64: Drop SKL0/SKL1 from TCR2_EL2
Message-ID: <20240912102232.GB1162893@e124191.cambridge.arm.com>
References: <20240911135151.401193-1-maz@kernel.org>
 <20240911135151.401193-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911135151.401193-2-maz@kernel.org>

On Wed, Sep 11, 2024 at 02:51:28PM +0100, Marc Zyngier wrote:
> Despite what the documentation says, TCR2_EL2.{SKL0,SKL1} do not exist,
> and the corresponding information is in the respective TTBRx_EL2. This
> is a leftover from a development version of the architecture.
> 
> This change makes TCR2_EL2 similar to TCR2_EL1 in that respect.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Confirmed this should eventually be part of the Known Issues doc.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

>  arch/arm64/tools/sysreg | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 7ceaa1e0b4bc2..27c71fe3952f1 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2789,8 +2789,7 @@ Field	13	AMEC1
>  Field	12	AMEC0
>  Field	11	HAFT
>  Field	10	PTTWI
> -Field	9:8	SKL1
> -Field	7:6	SKL0
> +Res0	9:6
>  Field	5	D128
>  Field	4	AIE
>  Field	3	POE
> -- 
> 2.39.2
> 
