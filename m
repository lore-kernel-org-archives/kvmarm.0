Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D0E1802AB
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 12:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399915; cv=none; b=LAoC4qLrkCMHXEycmfJhE+HG0FFN6t3aYdPsCyU1b9lZ9BoVKK14BnYrRN12lG8wHADP5qIrZn4QIPbN+pE1xpClFfkVoggb/YcLmsstkgWZRI6WgYW7pHQLdNNia2TXjZ0/HNF6SOnoKq3VdGNEP5WJhUu1dF2DdF99L8sLRLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399915; c=relaxed/simple;
	bh=5zHGTUn4fkkasmwO6qty3ScPi7UAKOnweB9YZ7sD3Eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fu0BcerUz3jjxnY1HPVYTJ9D9CRyayTZmO60gqKi7YrqFKiZHmPpJTkClyNp9yhyXx84yZ/4CIYslBGQi+p+CSXllqN6SYcI0/b95JHAeUGCHX80BQgaM7iPPXm9/VFxXPFcJ8PLwIhx0ncHaydANA27etUsGoP28VnJVfMCjgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE2BC497;
	Mon, 24 Feb 2025 04:25:29 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A35A43F6A8;
	Mon, 24 Feb 2025 04:25:12 -0800 (PST)
Date: Mon, 24 Feb 2025 12:25:07 +0000
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
Subject: Re: [PATCH v20 11/11] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
Message-ID: <20250224122507.GE8144@e132581.arm.com>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
 <20250218-arm-brbe-v19-v20-11-4e9922fc2e8e@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218-arm-brbe-v19-v20-11-4e9922fc2e8e@kernel.org>

On Tue, Feb 18, 2025 at 02:40:06PM -0600, Rob Herring (Arm) wrote:
> 
> From: Anshuman Khandual <anshuman.khandual@arm.com>

[...]

> BRBE records are invalidated whenever events are reconfigured, a new
> task is scheduled in, or after recording is paused (and the records
> have been recorded for the event). The architecture allows branch
> records to be invalidated by the PE under implementation defined
> conditions. It is expected that these conditions are rare.

[...]

> +static void armv8pmu_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in)
> +{
> +       struct arm_pmu *armpmu = *this_cpu_ptr(&cpu_armpmu);
> +       struct pmu_hw_events *hw_events = this_cpu_ptr(armpmu->hw_events);
> +
> +       if (!hw_events->branch_users)
> +               return;
> +
> +       if (sched_in)
> +               brbe_invalidate();
> +}

Just a minor concern.  I don't see any handling for task migration.
E.g., for a task is migrated from one CPU to another CPU, I expect we
need to save and restore branch records based on BRBE injection.  So
far, the driver simply invalidates all records.

I think this topic is very likely discussed before.  If this is the
case, please ignore my comment.  Except this, the code looks good
to me.

Thanks,
Leo
