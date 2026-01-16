Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CED0C313552
	for <kvmarm@lists.linux.dev>; Fri, 16 Jan 2026 15:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768578447; cv=none; b=g0u9DuPWfrrAk/HpaogHpx9y6jNKNJyQ+LG8hdav0mm+o/vtqKlmUaTE+wT4hLsjjMFpCcXGi6cKB1+H+L4rTXzqaGb5s7bpZ2SPpMQoULsCH4HzCct70cQpnbNr28ZMBr88wkq3WmUhQgRw9Blvp1VQem1OPEMUAKz8EjbzpWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768578447; c=relaxed/simple;
	bh=LOk3H7X0+snX+ioxaI3xJu1BvLsKDiJpoPnCwfjlPxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSBeS50THltLwSRyJNb266NgllM1pCXxSXdilEiHSDItkYQulhbqSHXfpyDuefY5hOAlBznxzA3/qvFg2y6D6CP3gs5wuDMKCXNtvPFG/KjsHxTk6pumC3J/5iGVX6a36poiT1n9aFOeHBxt6GkaLj+0pEoB45eA0fhJrTdcSik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 308061515;
	Fri, 16 Jan 2026 07:47:16 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A48A3F59E;
	Fri, 16 Jan 2026 07:47:18 -0800 (PST)
Date: Fri, 16 Jan 2026 15:47:15 +0000
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
Subject: Re: (subset) [PATCH v3 00/47] arm_mpam: Add KVM/arm64 and resctrl
 glue code
Message-ID: <176857842299.2010442.11311136147408507199.b4-ty@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112165914.4086692-1-ben.horgan@arm.com>

On Mon, 12 Jan 2026 16:58:27 +0000, Ben Horgan wrote:
> This new version of the mpam missing pieces has no major rework from the
> previous version. It's mainly small corrections and code tidying based on
> review and things I spotted along the way. To be able to merge this we need
> review from more people and people to start testing on their platforms and
> giving some Tested-by tags.
> 
> Change list in patches.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[01/47] arm_mpam: Remove duplicate linux/srcu.h header
        https://git.kernel.org/arm64/c/b5a69c486921
[02/47] arm_mpam: Use non-atomic bitops when modifying feature bitmap
        https://git.kernel.org/arm64/c/b9f5c38e4af1

-- 
Catalin
