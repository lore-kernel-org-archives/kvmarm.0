Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBF442857CD
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 18:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501212; cv=none; b=s1DyeAMZtojfO3n1qIwdWZ2Yi2Okb/GbXbzBCACQK0AkqBvJaBbDOZJrER1q7ASuwLUELczqR7c2ux06we0gypUiY8WCBvBOZYX9wzxsqRuMs485T9muAfmwB9iqhxBlcx/lQajbqFz9DhNG0NiZ4QDH4e5WU/WVTFjQW8H2HeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501212; c=relaxed/simple;
	bh=KPoynAePCDPyPst9uXCLzbkFncttkYqJv6+6SXThhqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s2y5WlTrmSOOd90tLfAvs7wh8xzL1FLZgQTp2b1LDvKX/2Rf1dHi9WHZwFDUCA5hnBavdWPEWQy8DCylXgt2iTFYQ4uEEhLUiHUId0+gxIAmE9DilQS9QQYHsmbWSaivpLWZ+qcLjkXvnhHnuwOwaGQAhaTMx26kjP6MAg067WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C5691515;
	Thu, 15 Jan 2026 10:20:03 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF1DC3F632;
	Thu, 15 Jan 2026 10:20:04 -0800 (PST)
Date: Thu, 15 Jan 2026 18:20:02 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
	dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
	fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
	jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	peternewman@google.com, punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com, reinette.chatre@intel.com,
	rohit.mathew@arm.com, scott@os.amperecomputing.com,
	sdonthineni@nvidia.com, tan.shaopeng@fujitsu.com,
	xhao@linux.alibaba.com, will@kernel.org, corbet@lwn.net,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 09/47] arm64: mpam: Add cpu_pm notifier to restore
 MPAM sysregs
Message-ID: <aWkv0jsX-tMHEo9G@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-10-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112165914.4086692-10-ben.horgan@arm.com>

On Mon, Jan 12, 2026 at 04:58:36PM +0000, Ben Horgan wrote:
> +static int mpam_pm_notifier(struct notifier_block *self,
> +			    unsigned long cmd, void *v)
> +{
> +	u64 regval;
> +	int cpu = smp_processor_id();
> +
> +	switch (cmd) {
> +	case CPU_PM_EXIT:
> +		/*
> +		 * Don't use mpam_thread_switch() as the system register
> +		 * value has changed under our feet.
> +		 */
> +		regval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
> +		write_sysreg_s(regval, SYS_MPAM1_EL1);
> +		isb();
> +
> +		write_sysreg_s(regval, SYS_MPAM0_EL1);
> +
> +		return NOTIFY_OK;
> +	default:
> +		return NOTIFY_DONE;
> +	}
> +}

This looks fine unless we decide to save/restore them in the low-level
suspend/resume functions.

-- 
Catalin
