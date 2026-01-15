Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA3D22E1EE7
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 19:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768504619; cv=none; b=qBy7rznGBGnFf2nSSbuDQical2fKMdzogsAnloiCfdFhQGFz7YG7svwV3QvBKY3Kph9rHSDoI8/mnSEg4h2Eko6iKv792p6TkYTc1N2OvSxfEO/KlLZrh4GKYw7wRd7bx51H9nHkoBaqiUSP0US+8ecXuyYMhURNg72MAR7iy74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768504619; c=relaxed/simple;
	bh=9STXpVcMo3ONvOLtTOYm3EubXycqH72/uQIA8g5DvPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZ3rY1Ud4aeTCdo9woEQr6CKZqaWVvat5Tzi79jIN7Ri7v8KtYJngaykT8IDSMdjOjubfFDXcz6JwSSEUSW6qbppFX2f7Lkf3d+ZfFQgZiiJtV1arhnO4L1HxhZAWP0Tt8kgeFrDkQzSZUEakXuCWsOfndzOBqzLPjWGmkUtb+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 544361515;
	Thu, 15 Jan 2026 11:16:50 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A88313F59E;
	Thu, 15 Jan 2026 11:16:51 -0800 (PST)
Date: Thu, 15 Jan 2026 19:16:48 +0000
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
Subject: Re: [PATCH v3 39/47] arm64: mpam: Select ARCH_HAS_CPU_RESCTRL
Message-ID: <aWk9ILetLYozhx9D@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-40-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112165914.4086692-40-ben.horgan@arm.com>

On Mon, Jan 12, 2026 at 04:59:06PM +0000, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Enough MPAM support is present to enable ARCH_HAS_CPU_RESCTRL.  Let it
> rip^Wlink!
> 
> ARCH_HAS_CPU_RESCTRL indicates resctrl can be enabled. It is enabled by the
> arch code simply because it has 'arch' in its name.
> 
> This removes ARM_CPU_RESCTRL as a mimic of X86_CPU_RESCTRL.  While here,
> move the ACPI dependency to the driver's Kconfig file.
> 
> In anticipation of MPAM being useful remove the CONFIG_EXPERT restriction.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
