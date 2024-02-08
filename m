Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CCAD7604D
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 12:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707395359; cv=none; b=iVypQqVOnUf1i8/YkZOMVQMBNNvtT2Ul7ggp6Z0JHRCdvsrPXoTP8kqLpixPMkvXdxOEii7ymSuRb1xJZxeRO15EaA33A2VJvQOhPg7JOhF8IOpk2+u7uqPbEa3dRxpjRAdN9ocPuuEGjyl1EXOO9WvVmZtc3BA4vzfcdcR2lrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707395359; c=relaxed/simple;
	bh=Xvc89Y9A0kMcrgww/JKgtlJiwjqjZk/TIc8pQaNjYNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UjpZT5ovzkE+/PVrcBgzaRCnOsyC6ZHDwkzDiOSEu1BCu4BKkjz+JiMYmfVCllQvNqlcyIxjNSS9PLvPwjEGtEUFIeUz2XVwsq1SCvDiSvFC70+0rjT67Cyf2tF2jK/s00H8i6PkCukFzCAg528KgNQNWLuPiSJTm1PU+EQJooM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2C2A1FB;
	Thu,  8 Feb 2024 04:29:58 -0800 (PST)
Received: from arm.com (RQ4T19M611.cambridge.arm.com [10.1.31.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FA793F5A1;
	Thu,  8 Feb 2024 04:29:15 -0800 (PST)
Date: Thu, 8 Feb 2024 12:29:13 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 10/10] KVM: arm64: Handle Apple M2 as not having
 HCR_EL2.NV1 implemented
Message-ID: <ZcTJGQmk51HgbH4p@arm.com>
References: <20240122181344.258974-1-maz@kernel.org>
 <20240122181344.258974-11-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122181344.258974-11-maz@kernel.org>

On Mon, Jan 22, 2024 at 06:13:44PM +0000, Marc Zyngier wrote:
> Although the Apple M2 family of CPUs can have HCR_EL2.NV1 being
> set and clear, with the change in trap behaviour being OK, they
> explode spectacularily on an EL2 S1 page table using the nVHE
> format. This is no good.
> 
> Let's pretend this HW doesn't have NV1, and move along.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
