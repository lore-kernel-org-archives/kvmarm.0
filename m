Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9881624E4C3
	for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 19:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386810; cv=none; b=hbaEnf+RJ8zFaoYFi1mDcD9yhd1vRmWKvIALj1TWk6+ME/VgyONoafVbrAlAQwk+5aCODT6uVGS2RUNRdNz/v4xz6CWZv2SR/hBZQkYgEVd2ed9mOcS1zc9LULg+a79+DRTxBYET8C1Ct4f4mJmNb4Gma8WLQ9T+iC2Ko1fvQxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386810; c=relaxed/simple;
	bh=jbZyenDy1ie9/HpamaTs6p37iRE24HZQMtK8SCh2RNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nU6asJx4cxXUtCC4ZYyKi26YDUhdSiAuNvwdczsYqsmWykKnI28CPLeMdoO6Lphuz6sc+SfFIPC5sD8EWpYN7OInU4lh/vIaFB6OwgSKxLW/nKRv7gua8rkUiXaxBzlMKtWczqFcoIdK5wA94Z9YR+5xgwc/aYzZev4MuWti1ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3CD812FC;
	Wed, 12 Feb 2025 11:00:28 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 732B63F58B;
	Wed, 12 Feb 2025 11:00:07 -0800 (PST)
Date: Wed, 12 Feb 2025 19:00:05 +0000
From: Leo Yan <leo.yan@arm.com>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v19 11/11] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
Message-ID: <20250212190005.GD235556@e132581.arm.com>
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-11-1c1300802385@kernel.org>
 <20250212185227.GC235556@e132581.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212185227.GC235556@e132581.arm.com>

On Wed, Feb 12, 2025 at 06:52:27PM +0000, Leo Yan wrote:

[...]

> > +static int brbinf_get_mispredict(u64 brbinf)
> > +{
> > +       return FIELD_GET(BRBINFx_EL1_MPRED_MASK, brbinf);
> > +}
> 
> I would expect the naming of brbinf_get_mispredict() will cause
> confusion.  When the function returns 1, it means "Branch was
> incorrectly predicted".
> 
> Maybe consider to use '!FIELD_GET(...)' for a reversed value?

Please ignore this comment. Sorry for my misreading and noise.
