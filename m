Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5473291E
	for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 17:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737999490; cv=none; b=K7C+jc+lXsIn4tTSYWj+U7LMId2Pc+CsmPs5+LW5oTWVfG7pmriwPoWxJQ8ZUiMeyOUo6CXLyHwWUw4poOKBV2n8Qn/DS4MFUw0kndy2BEH19FJoxyxwE4eMtJ0tVyyK0HibeUKL9qXBhuvKKvVgF3N6ZHey/VNH658Zdt4tqZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737999490; c=relaxed/simple;
	bh=nvwYdv2EUzfDuqAVEisBFI1jffQBjiHrQhhE1/XOCv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXimulbE1HBnXyi88C/VukqZtaUSzADYQopEsGGQ5pSYNis9p64ylQiOdKcBEgrvGI+0tIvjcrpIzCco7O9bhIXtVI9Y4zZX8f5JZiyYmmztT/pj+2gWoF6Zkz/0Bn8wKooZYSTeXwOmJdC2HP9pclfvq6KSsFjZP/8/nZswmBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sGqjcCx/; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sGqjcCx/"
Date: Mon, 27 Jan 2025 09:37:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737999480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rQNGWTk0C38Hs1u5kVIgIbQF9al0zYxSfDbukQVEcl0=;
	b=sGqjcCx/rEzKDe5DeIUDRMPSt6ed1g3q6YQE/9pKA/MTD41Dv6zozl5UKdkfHE9lB2hLIu
	EoIxFOOjBtDQSeEjpyGSLz9UP+LJiTEzu3Hxu+AEjT3Zx0C4nY3y307nuX0K9LUVp8hBtv
	ZVXeKWO+nslNdL+8xi3W7Menn80S3zU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	will@kernel.org, mark.rutland@arm.com, cohuck@redhat.com,
	eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
	wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
	jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v5 4/4] arm64: paravirt: Enable errata based on
 implementation CPUs
Message-ID: <Z5fEcqVDrPP_7pXp@linux.dev>
References: <20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com>
 <20250124151732.6072-5-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250124151732.6072-5-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 24, 2025 at 03:17:32PM +0000, Shameer Kolothum wrote:
> +void  __init pv_target_impl_cpu_init(void)

I get the sense that this implementation should actually be part of the
KVM guest services driver in drivers/firmware/smccc/kvm_guest.c

> +{
> +	int i;
> +	unsigned long max_cpus;
> +	struct arm_smccc_res res;
> +	const u32 funcs[] = {
> +		ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_VER,
> +		ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_CPUS,
> +	};
> +
> +	/* Check we have already set targets */
> +	if (target_impl_cpu_num)
> +		return;
> +
> +	for (i = 0; i < ARRAY_SIZE(funcs); ++i) {
> +		if (!kvm_arm_hyp_service_available(funcs[i]))
> +			return;
> +	}

nit: drop the for loop and just use the literal values.

> +	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_VER_FUNC_ID,
> +			     0, &res);
> +	if (res.a0 != SMCCC_RET_SUCCESS)
> +		return;
> +
> +	if (res.a1 != ARM_SMCCC_KVM_DISCOVER_IMPL_VER_1_0 || !res.a2) {

This is brittle. The versioning scheme really should match that of PSCI
/ SMCCC, where minor revisions within the same major are backwards
compatible with older clients.

So consider just checking that the major version is 1.

> +		pr_warn("Unsupported target impl version or CPU implementations\n");

This would be more useful if you provide context (i.e. the detected
version).

-- 
Thanks,
Oliver
