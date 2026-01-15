Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37232D060E
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 19:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768504138; cv=none; b=Iy1miSHx0Q9wVVAieRCz2HR/NbLt/lCn8Hv/BtPW4ixZS0p4yWhO5OvoFmefIhwaJ1HGE/koD2wA/lWuwvqCYuVyK4TuJ8mo1BFpi0qwJi9kpf4+IHde8hYinCxiojfvbQ6cpYh5dGOEVKVjkzuMGW1tSiaUVH/Htj7XcycRjic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768504138; c=relaxed/simple;
	bh=oRCS6RtfED9FzzOq2iqQVwNKLaYUe1rjgmRyM0CBbnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QzE92lk/lkoMbBE5nx3oMFpv0AdO0+VDVV3xGmZcZjZOoiYQINHb2/knOcBrx+KNHdcvHx+jrl8J/C/+nXrA3rlI4vCGR2cBs+3SbqGJ91Iho89fmIfoCxCoz2+se6Yw2hHU23Sv16iRU3G/cU0Xyox0gP9nkH54Ox2rJeP51Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3BC101515;
	Thu, 15 Jan 2026 11:08:49 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 933E43F59E;
	Thu, 15 Jan 2026 11:08:50 -0800 (PST)
Date: Thu, 15 Jan 2026 19:08:47 +0000
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
Subject: Re: [PATCH v3 10/47] arm64: mpam: Initialise and context switch the
 MPAMSM_EL1 register
Message-ID: <aWk7Pyai4AcoQc_J@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-11-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112165914.4086692-11-ben.horgan@arm.com>

On Mon, Jan 12, 2026 at 04:58:37PM +0000, Ben Horgan wrote:
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 0cdfb3728f43..2ede543b3eeb 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2491,6 +2491,8 @@ cpu_enable_mpam(const struct arm64_cpu_capabilities *entry)
>  		regval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
>  
>  	write_sysreg_s(regval, SYS_MPAM1_EL1);
> +	if (system_supports_sme())
> +		write_sysreg_s(regval & (MPAMSM_EL1_PARTID_D | MPAMSM_EL1_PMG_D), SYS_MPAMSM_EL1);
>  	isb();

Do we know for sure that system_supports_sme() returns true at this
point (if SME supported)? Digging into the code, system_supports_sme()
uses alternative_has_cap_unlikely() which relies on instruction
patching. setup_system_capabilities(), IIUC, patches the alternatives
after enable_cpu_capabilities(). I think you better use cpus_have_cap().

-- 
Catalin
