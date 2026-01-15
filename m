Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F19E2DAFCA
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 19:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768504435; cv=none; b=Oy3vTiSKLx+4TmCnmOvLyD1aJBrC1Yy86k1c/ff4FYdsgFtv4i8EFN2dXCwxZUUPEvH5y9ILjN2hX1NmrxulwxuY9AdecOzCejDCKvc0FkFFsnagScI/AfDSlq+kNoxL5wqZx8fMgt4VMh1FF1XFV6ozNuQTlAkTn+SBqawmvHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768504435; c=relaxed/simple;
	bh=6ug1PNtNTVRGMhPl9Bb6HEV2QG2zz5SA94F1Q3aFOfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l/VjkkWFHWc613ed6vpNzFLGfgcegERwwQd22gx1KlxOtjZQRX+DHV7SsEx22DpHwrJ7C8JEY47TId7hDP/UsTVjvvd7wD4FAp0Hp6aCN+yhp0HxNy6kgJ/c+N65Bx5SvwVUqcMcATEP8Pg4kkiTAc+SRABuFLFx+6cTXwX+D3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 12A451515;
	Thu, 15 Jan 2026 11:13:47 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 690DC3F59E;
	Thu, 15 Jan 2026 11:13:48 -0800 (PST)
Date: Thu, 15 Jan 2026 19:13:45 +0000
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
Subject: Re: [PATCH v3 11/47] arm64: mpam: Add helpers to change a task or
 cpu's MPAM PARTID/PMG values
Message-ID: <aWk8aZafbtXx5bPu@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-12-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112165914.4086692-12-ben.horgan@arm.com>

On Mon, Jan 12, 2026 at 04:58:38PM +0000, Ben Horgan wrote:
> +static inline void mpam_set_task_partid_pmg(struct task_struct *tsk,
> +					    u16 partid_d, u16 partid_i,
> +					    u8 pmg_d, u8 pmg_i)
> +{
> +#ifdef CONFIG_ARM64_MPAM
> +	u64 regval = __mpam_regval(partid_d, partid_i, pmg_d, pmg_i);
> +
> +	WRITE_ONCE(task_thread_info(tsk)->mpam_partid_pmg, regval);
> +#endif
> +}

Isn't this function, together with mpam_thread_switch(), in an enclosing
#ifdef already?

> +
>  static inline void mpam_thread_switch(struct task_struct *tsk)
>  {
>  	u64 oldregval;
> -- 
> 2.43.0
> 

-- 
Catalin
