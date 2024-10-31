Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B50641C77
	for <kvmarm@lists.linux.dev>; Thu, 31 Oct 2024 02:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730342308; cv=none; b=XzkIB4A/UKbMDXsTYcVJtsJ9Sf7MuBS2d6tqVZa55eN75XJsWQlhoCpmye4E0EwXWXqOZga8k/kEvoSprnlYN6L6E9gdKcYm1CGzH4TSSPG/PxHjRLS1m7XOf87xaTOOP2yMF7MnKrU/8pth1a9DLBQwox13W+qa4U1e2BWvVUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730342308; c=relaxed/simple;
	bh=JcULz0Smc/FsXgAgjJTZlYy882rqjBNrAxzcnjR6lzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ta+rtZ5MqVrEn4kAVe/NDOV/RPXzeRb/nI6LrKbQdsANhL/6YxTAkVrJ88D0F9xIjiXwUaLy7LduLDQCEoo6yJQz1hb6wIlGSnTY71teJpu3Ejq/HscBgmrSLGXeGemDkTfUGdbVBaLzQJRTSIC5BU01Si8JHKVK25Z7afMM3NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dkeeX5TZ; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dkeeX5TZ"
Date: Wed, 30 Oct 2024 19:38:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730342303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g4SWEots0xlx10lLgo/CdaPxF6EJK3d8uGUzYbN09y4=;
	b=dkeeX5TZ0DEv7nA3oF5JKE5ZflsOWunTNrvPxKunpVHbLQ/3ZSrBvoOdZ6g3jNSDSPug/u
	vTh8Gqf9d2bRw1IJaoXznhDIrgWOfZIAhj/ru0Kyj9/yO7qBFI6aWbiq631c0QPDhYQ0w8
	l0s7Q5eNV5bUoZFDJ/HIFP8ePAPmzjA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	anshuman.khandual@arm.com, gshan@redhat.com, james.morse@arm.com,
	shameerali.kolothum.thodi@huawei.com, Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v6 0/7] KVM: arm64: Hide unsupported MPAM from the guest
Message-ID: <ZyLtl6lLSEczqHjF@linux.dev>
References: <20241030160317.2528209-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030160317.2528209-1-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi,

Thanks for respinning this Joey.

On Wed, Oct 30, 2024 at 04:03:10PM +0000, Joey Gouly wrote:
> Hi,
> 
> changes since v5 [1]:
> 	- Removed Kconfig option, the KVM traps shouldn't rely on host kernel support
> 	- Renamed cpus_support_* to system_supports_* since that matches other functions
> 	- Replace static branch arm64_mpam_has_hcr with a normal cpufeature capability
> 	- Add MPAM*_EL2 regs to KVM (undef_access)
> 	- Use constants in the test, instead of hardcoded values
> 	- Added R-b and T-b tags
> 	- Rebased on v6.12-rc5
>
> James wrote:
> 	This series fixes up a long standing bug where MPAM was accidentally exposed
> 	to a guest, but the feature was not otherwise trapped or context switched.
> 	This could result in KVM warning about unexpected traps, and injecting an
> 	undef into the guest contradicting the ID registers.
> 	This would prevent an MPAM aware kernel from booting - fortunately, there
> 	aren't any of those.
> 
> 	Ideally, we'd take the MPAM feature away from the ID registers, but that
> 	would leave existing guests unable to migrate to a newer kernel. Instead,
> 	just ignore that field when it matches the hardware. KVM wasn't going to
> 	expose MPAM anyway. The guest will not see MPAM in the id registers.
> 
> 	This series includes the head.S and KVM changes to enable/disable traps. If
> 	MPAM is neither enabled nor emulated by EL3 firmware, these system register
> 	accesses will trap to EL3.
> 	If your kernel doesn't boot, and the problem bisects here - please update
> 	your firmware. MPAM has been supported by trusted firmware since v1.6 in
> 	2018. (also noted on patch 3).

This is looking pretty good to me, and I'd really like to have it in for
6.13.

Will/Catalin, first 3 patches look OK to you?

-- 
Thanks,
Oliver
