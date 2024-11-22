Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF93712E4A
	for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 22:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732313235; cv=none; b=e2LBVoj7rnXA3QZoO2uczZ5Cf3KrXQcsJT7HAPIh8VKXbLCDlQhHGIOHPlc+uaElu4BtlQQkQde5i3FsJyRzPdvFwpBlwJNEDp9FGOEE4j+00DedqxoBtBTEPPws3pZJU3dOlsv6QtcynIUsT6omL7BJUOrDn2HqJBLS9zcDFCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732313235; c=relaxed/simple;
	bh=PIN+jRJHphsVkVPazk7FABfbX5MCNhJGD6UExaxzGFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jKKS+346x9oKLoSEwfZDTlrFyjGYD/C9z7m403ahVD29pkPoK63EgQ/l7qeH/IxXmvXqj9mCwMrQuvSFGgZlQujdNR06w/DY0Yu4pydrB7AeNAKZaPd2VS95koRUYSsFea49KfCCws9Q/YEapobQrKQxLEeu8qAbl1As7FM5PkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XsRd9Cxv; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XsRd9Cxv"
Date: Fri, 22 Nov 2024 14:07:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732313230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bfY0Pf/J5wwf39xKb8ImS4WjQmELRZS9FkgRQ+eWYnk=;
	b=XsRd9CxvGwRA/R7tFTAPja+AHc49dwSaSCQfS4/qfNLc0xp0zLqF29aVLuwnLBhtmMOc8A
	KEBEL1VXtEbRCnu9YEjzzkD2M22Xyypcc/DNWZOyO04ATG0OUhzecpwEVQ5Zou1seFbLfk
	zVwvSjtSC9/2YOZ/N0rfUAq3aSsXqXk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Clark <james.clark@linaro.org>
Cc: will@kernel.org, maz@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>, linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] arm64: Fix usage of new shifted MDCR_EL2 values
Message-ID: <Z0EAhCbhM1B_4vW9@linux.dev>
References: <20241122164636.2944180-1-james.clark@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241122164636.2944180-1-james.clark@linaro.org>
X-Migadu-Flow: FLOW_OUT

+cc Paolo

Ugh, sorry for the mess + thanks for the fix James.

Paolo -- would you be able to apply this patch directly to your tree?
This really should go in ASAP.

Otherwise, I'll grab it + send another pull.

On Fri, Nov 22, 2024 at 04:46:35PM +0000, James Clark wrote:
> Since the linked fixes commit, these masks are already shifted so remove
> the shifts. One issue that this fixes is SPE and TRBE not being
> available anymore:
> 
>  arm_spe_pmu arm,spe-v1: profiling buffer owned by higher exception level
> 
> Fixes: 641630313e9c ("arm64: sysreg: Migrate MDCR_EL2 definition to table")
> Signed-off-by: James Clark <james.clark@linaro.org>

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
