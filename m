Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3740279DC0
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 19:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767900143; cv=none; b=SgKj0UbMVslCp1FgiTcNXuZ3MrOehZkVg5r21+CiGpc9wIosnSU3oEI37ZSXyNcKvUtNv39Jv5THtwb5h8QNWL1yrpC+EPsfA5tPK6YQkxlwNYUlfq9CzDmtELQn1XiuWfH5CaOvSvVpk0ycrrtVbdx06FsmolSb/BQU0nakaSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767900143; c=relaxed/simple;
	bh=1gI9GJkkVKqnYQ1STRQErRstGC2wY17BPExi5MA5a20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lAMtrxTr+OuCwDcEI+nGR6qBY1GBK6S8pIpu9rUX/cH/ddue2nJBFcC1qgu0RubAYLgJp+MitgK/TAGjsbA3lRfLMh9qDQIAAdRhESGQaKNELziE6YOWa0Dj7LOCKXohvaziDHoL12cOATAaoNsYr9Ynvl+gGmRJ9qShGp1z5Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAA0F497;
	Thu,  8 Jan 2026 11:22:09 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 592353F6A8;
	Thu,  8 Jan 2026 11:22:06 -0800 (PST)
Date: Thu, 8 Jan 2026 19:22:01 +0000
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
Subject: Re: (subset) [PATCH v2 00/45] arm_mpam: Add KVM/arm64 and resctrl
 glue code
Message-ID: <176790010619.2057507.2252517783260979848.b4-ty@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219181147.3404071-1-ben.horgan@arm.com>

On Fri, 19 Dec 2025 18:11:02 +0000, Ben Horgan wrote:
> As James is otherwise engaged this version of the MPAM missing pieces comes
> from me. I hope this does justice to all his hardwork. The changes that
> I've brought to this version are the handling of systems with SME, some rework
> of the KVM parts, a few small bug fixes and some tidying.
> 
> This may be the first time you are seeing this series as James spared some
> of you as the rfc was posted during merge window.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[01/45] arm_mpam: Stop using uninitialized variables in __ris_msmon_read()
        https://git.kernel.org/arm64/c/c2803bd580db

-- 
Catalin
