Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D572B443307;
	Mon, 28 Sep 2026 09:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790587716; cv=none; b=e2zZ9yjQ+Tq0+sg1xngC9/UNqZquJocirHVHMscpQNkUw/yR1QUT0+2BTTrWSR0kRQMVzIg25WgtmLSZLVUDixQ1r6hBUdCYc45Avm69yMCGSpNC7S/hNXnJ6pT4KCKMc2+xTgg6CwHBqFeRXgehYzju02ok/eWQELT8XuSdsJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790587716; c=relaxed/simple;
	bh=uP3vTQXZtzAeaAZv+6YX+YSO0w12PlBKUn8pseTb+Yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rzWkYoMKHBZ/BNhLV81f2G6psTcLWoElJVX7/6ATsTyNTTySNkbMHiCT3kFJw1KWtEY0AJrY9tbqXgTHDIeT0yDuUcQec/ZLyNYWAor53vs/oUgcr47/fHmDcQh5LG8D3Z8/bPB5n07pFqjKIBex018aRYEMKtKwYhuUCNFALqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bM9akU5S; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bM9akU5S"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B53681595;
	Mon, 28 Sep 2026 02:28:30 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C5C13F763;
	Mon, 28 Sep 2026 02:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790587714; bh=uP3vTQXZtzAeaAZv+6YX+YSO0w12PlBKUn8pseTb+Yo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bM9akU5SlyI3b64Zov0KeHC1Sj09KC1x8hbI82z6m+V4PSOd5TpznWKQUsy22jDf1
	 ucZSePmQCDQp85e3rY8vm2KWD73kE8B+0GSQofWdwddw/npvyQW9/kCJ43rUwhnsPD
	 JANrhcdXIcnY8JGgT8Y++SNmZimsYiHsAQqObTvg=
Date: Mon, 28 Sep 2026 10:28:20 +0100
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
Subject: Re: [PATCH v19 4/7] firmware: arm_rmm: Add support for SRO
Message-ID: <arozNIQ-fQ0XQViI@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-5-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924135201.850038-5-suzuki.poulose@arm.com>

On Thu, Sep 24, 2026 at 02:51:58PM +0100, Suzuki K Poulose wrote:
> +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
> +{
> +	struct arm_smccc_1_2_regs *regs = &sro->regs;
> +	bool cancelled = false;
> +	unsigned long sro_handle;
> +
> +	rmi_smccc_invoke(regs);
> +
> +	sro_handle = regs->a1;
> +	while (RMI_RESULT_STATUS(regs->a0) == RMI_INCOMPLETE) {
> +		bool can_cancel = RMI_RESULT_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
> +		int ret = 0;
> +
> +		switch (RMI_RESULT_MEMREQ(regs->a0)) {
> +		case RMI_OP_MEM_REQ_NONE:
> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
> +					regs);
> +			break;
> +		case RMI_OP_MEM_REQ_DONATE:
> +			ret = rmi_sro_donate(sro, sro_handle, regs->a2, regs,
> +					     gfp);
> +			break;
> +		case RMI_OP_MEM_REQ_RECLAIM:
> +			ret = rmi_sro_reclaim(sro, sro_handle, regs);
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			ret = -ENXIO;
> +			break;
> +		}

Another thing I came across while looking whether we can defer the
activation. It seems that the spec (I_JVYCH) lists some SROs as
PE-bound. Nothing here or in rmi_sro_execute() disables migration and
the memory allocation paths can even sleep with GFP_KERNEL.

Do we need to disable preemption (only for rmi_sro_execute()) or at
least migration (the memxfer path)? We did something similar for the RSI
attestation token loop, commit 24f55f511b9e ("virt: arm-cca-guest: use
migrate_disable() for attestation token requests").

With only migration disabled, another thread on the same CPU
issuing a PE-bound SRO would get RMI_BLOCKED (R_NDXSG). In theory, we
can get a priority inversion case (maybe this doesn't happen with the
current implementation, just looking at the API design). The RMI_BLOCKED
fix not to loop forever probably saves us but the caller would have to
actively sleep or give up before retrying (i.e. don't move the busy loop
higher app the call stack).

Another option is to have a per-CPU mutex here and serialise the SROs
which are PE-bound (there are some precedents for per-CPU mutexes in the
kernel).

-- 
Catalin
