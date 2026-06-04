Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB8B84219E4
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 12:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780576880; cv=none; b=R7vDMiW0k7zdmIJTff1xCtP/6WejQ0xmxzWpg+231L90SN3lkDWAMWZLI46M8mSB4m2l20AtS0ZOJ1YFUq8WrPumVeXznH43pzIENxlMme9NGwxQtrRrYEloPA1Z53ReMSUFRTyP/KJkuQ/T1fi6O8RYkU1ZrVzGmcz9vmkeGC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780576880; c=relaxed/simple;
	bh=ippKhuymBSJMxocMrGkGF47Cq8dbrZQ4SwWYwY91XZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ewd3Lodq7pjLPA9bVfSvpH/GZ35p28LIAuaGt4nY+koRFB+yhXPRA6VP/jBweQ7J1WxRn2YMsumI/r2WRNILuspKsfwlp0EQQ7xKkFNlv0dm5WD6tTF+crsimrt6M8zPTYI4bgIBZKbIK5u3qMctwTWI67/FSMAaMhvT0R/4baU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dl3uSrR/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dl3uSrR/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57EFA3297;
	Thu,  4 Jun 2026 05:41:13 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 25C7E3F7D8;
	Thu,  4 Jun 2026 05:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780576878; bh=ippKhuymBSJMxocMrGkGF47Cq8dbrZQ4SwWYwY91XZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dl3uSrR/sLttmUqAWvgSW3uM6wj3aA3U583UEyG/yO+VuzoIffPSfuODvXX+0Ifaw
	 4qpnJvjO5+ne440otKZcmF9j1zdj50rss6PhRcKcKrhFjMJFmLYXO1pPDMKd3ecn4U
	 ouSlJ4/gaC/jCIZA33wae288tFrfUQOPNrbn64Fs=
Date: Thu, 4 Jun 2026 13:41:09 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Correctly identify executable PTEs at
 stage-2
Message-ID: <erjlb6kfa6ogzfpybb4rvqy753idniprdwcsgvlbpjwi75qajg@x3y6lu4m7jfo>
References: <20260602165901.52800-1-oupton@kernel.org>
 <20260602165901.52800-3-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602165901.52800-3-oupton@kernel.org>

On Tue, Jun 02, 2026 at 09:59:01AM -0700, Oliver Upton wrote:
> KVM invalidates the I-cache before installing an executable PTE on
> implementations without DIC. Unfortunately, support for FEAT_XNX
> broke this check as KVM_PTE_LEAF_ATTR_HI_S2_XN was expanded to a
> bitfield.
> 
> Fix it by reusing kvm_pgtable_stage2_pte_prot() and testing the abstract
> permission bits instead.
> 
> Fixes: 2608563b466b ("KVM: arm64: Add support for FEAT_XNX stage-2 permissions")
> Reported-by: Sashiko (gemini/gemini-3.1-pro-preview)
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 0c1defa5fb0f..91a7dfad6686 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -925,7 +925,9 @@ static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
>  
>  static bool stage2_pte_executable(kvm_pte_t pte)
>  {
> -	return kvm_pte_valid(pte) && !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
> +	enum kvm_pgtable_prot prot = kvm_pgtable_stage2_pte_prot(pte);
> +
> +	return prot & (KVM_PGTABLE_PROT_UX | KVM_PGTABLE_PROT_PX);
>  }
>  
>  static u64 stage2_map_walker_phys_addr(const struct kvm_pgtable_visit_ctx *ctx,
> -- 
> 2.47.3
> 

Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>

Thanks,
Wei-Lin Chang
