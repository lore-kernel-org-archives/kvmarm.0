Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F5B341655;
	Tue,  9 Sep 2025 14:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757427801; cv=none; b=hiAsvYLV+wqWQw2Vi2CpbseY7AMEZqwa1482nDDG70Zxgz1WeBJcqoeqwVbBi8JYgSKdwZz8bTFBgy2QzrlVI/Dt/o5n1WX6BTZPc1ZbFMDFQ/aWpKybKRw8pzE5ZTdII5osjJAqFbkAms3kuiata3r88Ka/ZRA34Hv6fu6BAho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757427801; c=relaxed/simple;
	bh=fQ97+Dd40Jh9OqBAWXGx6hNnCravOj+hTJQ++rkJ3j8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bWs1sLPWjj46Fr1YtflUrGCNvnGMPJ42Ea1753VHu2MFPqM2ck72d1WFGFL7U498REylXlkZLyEZUDF/r5CI7nfRvWbyvtfhEhokj4cUGrlytlpUmG077kL0uQxLFzecoFpscdYZ1Qarchx4/h3iWqIZI+Up9yctXVbi6AmD5kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mxCjHBoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mxCjHBoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E472C4CEF7;
	Tue,  9 Sep 2025 14:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757427801;
	bh=fQ97+Dd40Jh9OqBAWXGx6hNnCravOj+hTJQ++rkJ3j8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mxCjHBoHfMm+cNL2zfObOh2HtjGIcDm2vdmciJn35H9XMf4qpLYftWD4UmFIGdGlS
	 I7NerNlwaG5f5iygJ8AhuFN9J4iyS50pbWi6CUnCss0G2KSGq1IOAGiee9nAY0BUmK
	 AGHvSvbHcruitvsn3RsFq6ESQioVk2w3nDA0XTIaa3mJV5vh/TdSUwZomlJNuAafmU
	 chjjKMN4SSR5k4brVFGPH26PhyDWGHXxUTL2pZTXyB/BJ+LOdiBG/45Ju1nWpfNHZ2
	 6SPfhbo1CCRGtuXWe0OQm7WXZEN9ZTmQ8uz66xRhm69sFTLBqyZRP2RWHbJxbND9IQ
	 glPUXXtgOeB4w==
Date: Tue, 9 Sep 2025 15:23:14 +0100
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 06/28] iommu/arm-smmu-v3: Split code with hyp
Message-ID: <aMA4UpDgLDuiGYf8@willie-the-truck>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-7-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819215156.2494305-7-smostafa@google.com>

On Tue, Aug 19, 2025 at 09:51:34PM +0000, Mostafa Saleh wrote:
> The KVM SMMUv3 driver would re-use some of the cmdq code inside
> the hypervisor, move these functions to a new common c file that
> is shared between the host kernel and the hypervisor.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +-
>  .../arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c  | 114 ++++++++++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 146 ------------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  44 ++++++
>  4 files changed, 159 insertions(+), 147 deletions(-)
>  create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
> index 493a659cc66b..1918b4a64cb0 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/Makefile
> +++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
> -arm_smmu_v3-y := arm-smmu-v3.o
> +arm_smmu_v3-y := arm-smmu-v3.o arm-smmu-v3-common-hyp.o
>  arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_IOMMUFD) += arm-smmu-v3-iommufd.o
>  arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
>  arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c
> new file mode 100644
> index 000000000000..62744c8548a8
> --- /dev/null
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-hyp.c
> @@ -0,0 +1,114 @@

Given that this thie is linked into both the kernel and the hypervisor
objects, I think I'd drop the '-hyp' part from the filename. Maybe
something like 'arm-smmu-v3-lib.c' instead?

Let the bike-shedding begin!

Will
