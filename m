Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B05145B26
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 17:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723139758; cv=none; b=XgnNq0AHX23XT1vJfY0JlRmrJNbGTuztfCB7Lo38Bmp/WG3pIhvmD58DoJ1jE1YaRrm4UMFlUMd5CRpdqlnb1pnXyvieQ+PBgZEHf7wT3BGbtGJhCsFGmHQOEVy5E2d60CY7Qd3zuUD/n7cI3eFVsoQipnoq6u3YRBRy/xmuef4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723139758; c=relaxed/simple;
	bh=8cBJ/OUasyDlaDm+uV6M4jjd+cY/+LKS0yu/8qagYyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WM0Io9M/OvAY9b3N0+5h2uhN4SSnwo1q41ISZ/sjsSEsgLSoNDjvXgf8K5AFpmxpiE+Af1lUbbwhQjv6v6cG3WgL5K8mPo5gf41NagXbWrIGhI9C+D+BsLSWriYLccuNAeJ+I1jwwOBgVWZfv0p7ajkAjarnUTb1rWP9dxmNolM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lHymnHH+; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lHymnHH+"
Date: Thu, 8 Aug 2024 17:55:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723139754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DHyamLELFxFvqyuXfn2/colLtUh6a7qi/U4t10FKUEY=;
	b=lHymnHH+dqyrt+owmksdWDKCRhPs0AE+y6sFwQXdVtonO8WOAhxZzK5l2z3DN5R5n7UC37
	k/ISQkrwhrvMooAe4gpq4IR3bmVLYto3Klkn80e7zjgbAdbsHSa9dY7mA4NQAnLYt8VmFd
	l1eSM9M6ectq/stI5676oH8yYrIhk8s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Ricardo Koller <ricarkol@google.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Move data barrier to end of split walk
Message-ID: <ZrUGpZVnUN1NaVga@linux.dev>
References: <20240808174243.2836363-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808174243.2836363-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Colton,

On Thu, Aug 08, 2024 at 05:42:43PM +0000, Colton Lewis wrote:
> This DSB guarantees page table updates have been made visible to the
> hardware table walker. Moving the DSB from stage2_split_walker() to
> after the walk is finished in kvm_pgtable_stage2_split() results in a
> roughly 70% reduction in Clear Dirty Log Time in
> dirty_log_perf_test (modified to use eager page splitting) when using
> huge pages. This gain holds steady through a range of vcpus
> used (tested 1-64) and memory used (tested 1-64GB).

Would you have time to put together a patch for the dirty_log_perf_test
changes you've made? This would be quite valuable for testing future
improvements to eager page splitting.

> This is safe to do because nothing else is using the page tables while
> they are still being mapped and this is how other page table walkers
> already function. None of them have a data barrier in the walker
> itself because relative ordering of table PTEs to table contents comes
> from the release semantics of stage2_make_pte().
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

The diff itself looks good to me, so:

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
