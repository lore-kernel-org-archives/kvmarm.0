Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EA417BBE
	for <kvmarm@lists.linux.dev>; Fri,  2 Feb 2024 07:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859905; cv=none; b=R32YCn7BX/BJCwgZ2LxBaUEBfOgMu8OomMt9fE+xI0w4KqMRy17v1jvCTG6dqszbJWo33X2Pz9gu7bKUefMV3dcJphvtEbQlhaWmCJg4KA0KI+Z4jY8PWRAfBryKo+nlTlatz1zGWworRR6orLvz5H3sF590gReTEd5ntXlWHo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859905; c=relaxed/simple;
	bh=zuxEjjnkyCiU2jxBsKwIXFDFrYt5ZXuz0QMOj8jPOOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WlCKAFGhEBEgm0PXd7v94bW1nxcYkmdfYgyWkXnaVyKi0JcnG1/rJhH/0F59py3zlMo0Hq9HNJLDAa1sSaQJ67Q3UnMyx0sQ8zu43KSnKHf5e8rp1smwElNqMt6YyKm0G4PCVQnZum0s29VYj3zXvuWGJGDdH+fAUesUrmndVVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YNFcnHtJ; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YNFcnHtJ"
Date: Fri, 2 Feb 2024 07:44:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706859901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yXYgbL9pawqCQfLD7tUkx2pUHhN7+ydoo6Ga24ca9gc=;
	b=YNFcnHtJlTgzMTxTop4NnZqSpbhk46tadJrsfBw04VBy206G8dAEJZT/TRYNnaYmxIeuDJ
	wV0/PJI96jbkEktFxfACqS8W3T45QyFRKLqLdXk9SMTRvcTMC6cg5tfsdY1d7MwyFFWlbt
	QLoXJAxqqHDaY1x/HuSN02rLDJu26Cc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Eric Auger <eauger@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/5] KVM: selftests: aarch64: Move pmu helper
 functions into vpmu.h
Message-ID: <ZbydeB5MEJIhxaw6@linux.dev>
References: <20240202025659.5065-1-shahuang@redhat.com>
 <20240202025659.5065-3-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240202025659.5065-3-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 01, 2024 at 09:56:51PM -0500, Shaoqin Huang wrote:
> -static uint64_t get_pmcr_n(uint64_t pmcr)
> -{
> -	return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
> -}
> -
> -static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
> -{
> -	u64p_replace_bits((__u64 *) pmcr, pmcr_n, ARMV8_PMU_PMCR_N);
> -}
> -
> -static uint64_t get_counters_mask(uint64_t n)
> -{
> -	uint64_t mask = BIT(ARMV8_PMU_CYCLE_IDX);
> -
> -	if (n)
> -		mask |= GENMASK(n - 1, 0);
> -	return mask;
> -}

I don't see these helpers being used by your test, and they seem rather
specific to what the original test was trying to accomplish. Let's not
move this unnecessarily.

-- 
Thanks,
Oliver
