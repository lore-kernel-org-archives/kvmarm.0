Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6FC3FA5FE;
	Thu,  1 Oct 2026 10:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790851852; cv=none; b=guQogw4NRl+wD1cNbn9yVcZcPSjVTZ+TatHSOxVsdCarzRY8slw4oq4jExz7pxXSDI0zjjLUNUAjjUOZCrHTucjh2Dpn3K3b2z09FTNR7UGFdiEyQIQyGRyi7bzavtza1rGQl9zkVuVQUXqLqKiKEuLtljwvdFLvbH4P5xhr1Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790851852; c=relaxed/simple;
	bh=JVrOeTdxXGig0DbeyzW4m4jIDq1ilZ1bvTg/w5OMrsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpON6Wjgi+oHXZQo0J2m5wJ/EcLSQCzMPL2/n2H5NVcnVcVw0BTkW2PSRyaSPo4tGBvXHmfEcNAgch2woHlgI3CYkDrOm8PX4CwUd/ZDZJilDqyLoS4UOWXRS2yK04jkscnti0RYB1RAQmai4jGRtA3tJKvpsq+Ynlgllk6uMog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=C/qAfLAZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="C/qAfLAZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED7D6497;
	Thu,  1 Oct 2026 03:50:46 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 05D7B3F85F;
	Thu,  1 Oct 2026 03:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790851850; bh=JVrOeTdxXGig0DbeyzW4m4jIDq1ilZ1bvTg/w5OMrsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C/qAfLAZHct4UPoOg6LrBocfrvBKURODMiArS+zGamTfcjlMA/mpEnGC6brYdwr6V
	 mIrkEpqMXt3kcjIlQrYiQ2m1VUgKTws4JlauIHOfbWmzjCyKm8w/rL1MJ4nve/RR/f
	 Q2U+pjuMYwFnVqZyx5V87W2K4gSUFNKRc6Y5JRJA=
Date: Thu, 1 Oct 2026 11:50:44 +0100
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
Subject: Re: [PATCH v21 2/9] firmware: arm_rmm: Check for RMI support at init
Message-ID: <ar47BLk-l4-4VyVl@arm.com>
References: <20261001084555.1456543-1-suzuki.poulose@arm.com>
 <20261001084555.1456543-3-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001084555.1456543-3-suzuki.poulose@arm.com>

On Thu, Oct 01, 2026 at 09:45:48AM +0100, Suzuki K Poulose wrote:
> +#define RMM_BLOCKED_RETRY_COUNT		2
> +/*
> + * rmi_smccc_invoke: Invoke the RMI call and return the results, retrying the
> + * command when status is RMI_BUSY. If we encounter RMI_BLOCKED, we retry
> + * it one more time before we give up. The caller is supposed to handle the
> + * result and reissue if required.
> + *
> + * We don't expect to see RMI_BLOCKED on a practical system, except when
> + * there are parallel requests that results in long standing operation,
> + * with one blocking the other.
> + *
> + * @regs: Input parameters filled in. Updated with the ouptput results
> + * after the call.
> + */
> +static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
> +{
> +	struct arm_smccc_1_2_regs args = *regs;
> +	long status;
> +	int i = 0;
> +
> +	while (i < RMM_BLOCKED_RETRY_COUNT) {
> +		arm_smccc_1_2_invoke(&args, regs);
> +
> +		status = RMI_RESULT_STATUS(regs->a0);
> +		if (status != RMI_BUSY && status != RMI_BLOCKED)
> +			break;
> +		if (status == RMI_BLOCKED)
> +			i++;
> +		cpu_relax();
> +	}
> +}

With changes around RMI_BUSY to return early in patch 8, I think this is
fine for a brief lock-style retry.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
