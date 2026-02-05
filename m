Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A898A3A9620
	for <kvmarm@lists.linux.dev>; Thu,  5 Feb 2026 16:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770310472; cv=none; b=WATlNd+2emt/g7V4YLLhUuR1n/uJV5uRTYah6u5pqh36z+3gQumVOJpG5SQYbx/z6ljpWKe7e/7CWBto/kB7Tw2Z2gdZ0lOw0L8rmKSKwgmP6DLyVCe41BaBaMxs1Kaw5oKxsGBL7I1zucGRERC3xojLBUZKIaaMbxtQfiiJyeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770310472; c=relaxed/simple;
	bh=0ywU1iCJv4gW2vXVQpb2iwpF39boGjzpBGJIVYkpIRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AasmXLM3CIk2T3nFWbK/VlUAcgcMVHtT9Qd4zPPBhs3BLZP1zTrKZ16DqggguJVC0+au4t+PyoApQVh0Tsibe8kW6SA6tAy+0gmHCfr/B4CPjEbkPGoWuWWFv84LeNYgRFxs/B24ejpFBv1Gs4F3exdfyc4NrUjrKADyWNXfG3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3637339;
	Thu,  5 Feb 2026 08:54:24 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44C3E3F778;
	Thu,  5 Feb 2026 08:54:25 -0800 (PST)
Date: Thu, 5 Feb 2026 16:54:22 +0000
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
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
	zengheng4@huawei.com, linux-doc@vger.kernel.org,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Subject: Re: [PATCH v4 08/41] arm64: mpam: Add cpu_pm notifier to restore
 MPAM sysregs
Message-ID: <aYTLPqpRmwDap6fM@arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-9-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203214342.584712-9-ben.horgan@arm.com>

On Tue, Feb 03, 2026 at 09:43:09PM +0000, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> The MPAM system registers will be lost if the CPU is reset during PSCI's
> CPU_SUSPEND.
> 
> Add a PM notifier to restore them.
> 
> mpam_thread_switch(current) can't be used as this won't make any changes if
> the in-memory copy says the register already has the correct value. In
> reality the system register is UNKNOWN out of reset.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
