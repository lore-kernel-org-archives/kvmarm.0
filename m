Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56C2651AEDE;
	Tue, 29 Sep 2026 10:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790679069; cv=none; b=PsZ7BRA+MBUCae4OQzyWUH8NLTGKRTAUbfPSryLVaL9a/uRvwKpZtdQ5qyKJ5z8G3PCNi/sNOrgE/GsMZDLbLSWSWUC5uIL6cdYj/zvylwVfz4/VpsuiJd42i0cBWrafrMEDv/dcnLR+UnWDaHrl+yg/cJZiUbkXUh240rI38y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790679069; c=relaxed/simple;
	bh=x5DMhANbWDxXz6e9rKTqJx8Hdqk+thHnj9yygpRPhng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=skSsqduNg2OEO0Yk82rRBuiZXL9EiV6Z0qSOoqC0HefP6BBbKN2F+ZCgdJNCgAX6alv47o9Mxb9LjUzC5YE7P47bCQQuGzMEFvOz5wzqw72uWyS20VJD6fbGIxfAhwRhotQLBKSiROgM9yRVIK8/RHbkCTfcrnPrNmFzqnR07rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=I5ZrEQ9b; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="I5ZrEQ9b"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CA40143D;
	Tue, 29 Sep 2026 03:50:41 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 597E93F86F;
	Tue, 29 Sep 2026 03:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790679044; bh=x5DMhANbWDxXz6e9rKTqJx8Hdqk+thHnj9yygpRPhng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I5ZrEQ9bGn2rdwPFtyyjCXCgK1HyER2LL6tqrJSFRwFSiklCEegQIXEvBlESinUHx
	 wYQsdl8ukvfHurffs9W/WX3vmnMOzRI8JmdpoyUPY92+wjsLUqIklbr92nD/V5kIOs
	 R8FNSIB3TCWI36S0yj9nEaCqB9w4XHmSZmjIkPPg=
Date: Tue, 29 Sep 2026 11:50:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v19 0/7] firmware: arm_rmm: Add RMM v2.0 base RMI support
Message-ID: <aruWz-QkcdD9ETbC@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924135201.850038-1-suzuki.poulose@arm.com>

On Thu, Sep 24, 2026 at 02:51:54PM +0100, Suzuki K Poulose wrote:
>  arch/arm64/Kconfig                |    1 +
>  arch/arm64/kernel/cpufeature.c    |    1 +
>  drivers/firmware/Kconfig          |    1 +
>  drivers/firmware/Makefile         |    1 +
>  drivers/firmware/arm_rmm/Kconfig  |   25 +
>  drivers/firmware/arm_rmm/Makefile |    2 +
>  drivers/firmware/arm_rmm/rmi.c    | 1072 +++++++++++++++++++++++++++++
>  include/linux/arm-rmi-cmds.h      |  558 +++++++++++++++
>  include/linux/arm-smccc-rmi.h     |  505 ++++++++++++++

One more nit: patches 1 and 2 I think add new header files without a
MAINTAINERS entry. You can add them to arm64.

-- 
Catalin
