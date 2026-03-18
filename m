Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 034923CEBA8
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 11:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773834131; cv=none; b=vFXYX5LaJGHyLLuGjFRwMhu2+lORox6Dek5Uhvqh2RH7AMBk0Qt6BEJAz0nK0l7SNi95YRCR3T56yw8j/0vaAuPqRm5vB91Is+IFYapiQsfctBPzUrEB9oNCnMegXDsrzItq0+BAyVdFIh8shbGLOOxU5VC86rVYqsouo3VQBQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773834131; c=relaxed/simple;
	bh=hFjPVeUOB2eTISa5tGSFNav9l/LGlqJi7qnJChZEK+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FN+0TsO9/dGZ5tVeFAmim1U29jkCa6AOUdHceP04EnIhPfARNoAvjbQlG/qagBqf6Kzykqj+j6TXwfdqE+qMHCnkUtvM3atfRM4Td02LHBnb7EfkKo+4rqwoH4g6LOWxZ9hAoaS5j7WrAPwJo2bsvpJH9qQV4XgM9bFGYYoibGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AD721E2F;
	Wed, 18 Mar 2026 04:42:01 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA6013F73B;
	Wed, 18 Mar 2026 04:42:05 -0700 (PDT)
Date: Wed, 18 Mar 2026 11:42:00 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 0/2] KVM: arm64: nv: Expose shadow page tables in
 debugfs
Message-ID: <20260318114200.GA3905508@e124191.cambridge.arm.com>
References: <20260317182638.1592507-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317182638.1592507-1-weilin.chang@arm.com>

On Tue, Mar 17, 2026 at 06:26:36PM +0000, Wei-Lin Chang wrote:
> Hi,
> 
> This is v2 of exposing shadow page tables in debugfs, there are a few
> small improvements, please see below.
> 
> Changes in v2:
>  - move debugfs_nv_dentry also behind CONFIG_PTDUMP_STAGE2_DEBUGFS
>  - use a macro to define the file names of shadow ptdumps, also
>    explicitly spell out the string to get its maximum size
>  - add Reviewed-by tag from Sebastian (thanks!)
>  - Link to v1: https://lore.kernel.org/kvmarm/20260308231829.864983-1-weilin.chang@arm.com/
> 
> Wei-Lin Chang (2):
>   KVM: arm64: ptdump: Make KVM ptdump code s2 mmu aware
>   KVM: arm64: nv: Expose shadow page tables in debugfs

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> 
>  arch/arm64/include/asm/kvm_host.h |  9 +++++
>  arch/arm64/include/asm/kvm_mmu.h  |  4 +++
>  arch/arm64/kvm/nested.c           |  6 +++-
>  arch/arm64/kvm/ptdump.c           | 60 ++++++++++++++++++++++---------
>  4 files changed, 62 insertions(+), 17 deletions(-)
> 
> -- 
> 2.43.0
> 
