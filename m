Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1773D398900
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 16:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773420230; cv=none; b=lQi3ubVznNdPP16XpV3tW/KKoWJwgMPf2DywlzHHn0AUqyMNmCuJm6GZSZk+hkbVwiVZ+l8FzHUiBnvGFOhOiFyE2cIeHU8Epsxzoy0odCB6dNd7QUTUd0gPnpAOkKMRNSc3gvOvcHj3P4sCKLAU/RSftzB8OJBWfM5QogK9EdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773420230; c=relaxed/simple;
	bh=eWSdCDRVfCTPMs2Uu7aaWJhyEyCXxLt3ODYZVQCkCn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I9zGQml4FUKycme17sXQ2D+Pt3hztQXqLrCfHvy4JOXINyPuXksQk6saMJSZQkdcCTNJikqL49L0qJ7MUkAYnDXON35UjRDIOXIDt5WJRHoIaBh/tsS3ljIqhODtK9nncwdXwt/GTubmTwCETXgADdVfePxFOoHCEcZYWBm85f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6ED9A176A;
	Fri, 13 Mar 2026 09:43:42 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7CBC73F7BD;
	Fri, 13 Mar 2026 09:43:46 -0700 (PDT)
Date: Fri, 13 Mar 2026 16:43:44 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	oupton@kernel.org, miko.lenczewski@arm.com, kevin.brodsky@arm.com,
	broonie@kernel.org, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, joey.gouly@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v15 5/8] arm64: futex: support futex with FEAT_LSUI
Message-ID: <abQ-wLJj8MZfe5tS@arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
 <20260227151705.1275328-6-yeoreum.yun@arm.com>
 <abMDOC5DYEm74And@arm.com>
 <abPXrvl9tC+nv6q9@e129823.arm.com>
 <abQiSiX_xxjSY96-@arm.com>
 <abQlhhSDkmzUugMW@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abQlhhSDkmzUugMW@e129823.arm.com>

On Fri, Mar 13, 2026 at 02:56:06PM +0000, Yeoreum Yun wrote:
> Thanks for confirmation, I've changed them as we discussed.
> But let me sent it on v7.0-rc4 based with v17.

No need to rebase to -rc4 unless there are some features you depend on.
The arm64 for-next/core branch is based on -rc3.

> (Unfortunately, I sent v16 yesterday with missing of those review in
> this thread).

No worries.

Thanks.

-- 
Catalin
