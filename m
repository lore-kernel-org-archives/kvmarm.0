Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA4220F97E
	for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 11:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736853196; cv=none; b=dZQkwlZOSlxgCEv2LVtY/IECgkoiKKh0wIdS8FPRTYcQ1cMXSz2uK2FiNl6paAkRjF1INcDBumeUAyrKtq5HuT5f5g9UQZTrSQ628SUTv5ASA67gRusEZLiXw4b2Yotr9tdIvDwo2pDBaXkcFIdptV1dMf0ffk5H/6wYjx1mlTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736853196; c=relaxed/simple;
	bh=zFaf5kTMHUz0TfNJ+32cNY1IyhUd5nDg6JJHZkJ0db0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PaOk4g+YsSJw5Fzdmw7pvz1C+JbQDSG/s4rl5SkKA2HUvoBkBUwaAtPrGiFAfjYQb2K4ZAO6CmXppcGTbxhkxxnAjS5k4K2WSTaQ49BibNWS62iICsWqZRa5AuyUBN8wY9FgLO7tn3PbIBNxkhBWdxwVd3+aFEF5u1SeFKqd5SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33F4C11FB;
	Tue, 14 Jan 2025 03:13:42 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A99BF3F66E;
	Tue, 14 Jan 2025 03:13:12 -0800 (PST)
Date: Tue, 14 Jan 2025 11:13:07 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: nv: Fix sysreg RESx-ication
Message-ID: <20250114111307.GA3312699@e124191.cambridge.arm.com>
References: <20250112165029.1181056-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250112165029.1181056-1-maz@kernel.org>

On Sun, Jan 12, 2025 at 04:50:27PM +0000, Marc Zyngier wrote:
> Joey recently reported that some rather basic tests were failing on
> NV, and managed to track it down to critical register fields (such as
> HCR_EL2.E2H) not having their expect value.
> 
> Further investigation has outlined a couple of critical issues:
> 
> - Evaluating HCR_EL2.E2H must always be done with a sanitising
>   accessor, no ifs, no buts. Given that KVM assumes a fixed value for
>   this bit, we cannot leave it to the guest to mess with.
> 
> - Resetting the sysreg file must result in the RESx bits taking
>   effect. Otherwise, we may end-up making the wrong decision (see
>   above), and we definitely expose invalid values to the guest. Note
>   that because we compute the RESx masks very late in the VM setup, we
>   need to apply these masks at that particular point as well.
> 
> The two patches in this series are enough to fix the current set of
> issues, but __vcpu_sys_reg() needs some extra work as it is doing the
> wrong thing when used as a lvalue. I'll post a separate series for
> that, as the two problems are fairly orthogonal, and this results in a
> significant amount of churn.
> 
> All kudos to Joey for patiently tracking that one down. This was
> hidden behind a myriad of other issues, and nailing this sucker down
> is nothing short of a debugging lesson. Drinks on me next time.
> 
> Unless someone shouts, I'll take this in for 6.14.
> 

Testing using the updated kvm-arm64/nv-next branch:
Tested-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks!
Joey

> Marc Zyngier (2):
>   KVM: arm64: nv: Always evaluate HCR_EL2 using sanitising accessors
>   KVM: arm64: nv: Apply RESx settings to sysreg reset values
> 
>  arch/arm64/include/asm/kvm_emulate.h | 36 ++++++++++++----------------
>  arch/arm64/include/asm/kvm_nested.h  |  2 +-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c   |  4 ++--
>  arch/arm64/kvm/nested.c              |  9 +++++--
>  arch/arm64/kvm/sys_regs.c            |  5 +++-
>  5 files changed, 29 insertions(+), 27 deletions(-)
> 
> -- 
> 2.39.2
> 
