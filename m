Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B21339855
	for <kvmarm@lists.linux.dev>; Wed, 21 Jan 2026 16:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769012628; cv=none; b=tA/0eSIVKqesJxQgrHZ0kCWlxizh8b1Uo4abFwSF8RwnTb4A4EOC3QLthTb2ewaw9h5YMpuze5X9650vx9ZBYAkcU4QH3tcEMX+LlEhlElEh8SGkwcVJNfYPn91qB5FkNnA4mCp59+Icm+vvpkZs+Qty1wTd6p1/mHQQpj8kmQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769012628; c=relaxed/simple;
	bh=OdsdWoj5bitWH44V1FFwMrwQesA+OP83xj6JU1BgNCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AFLvu6IniZGZ81hg31tFyTggxztvYdBEwHTXYCx68qzET7J3wmT6SoymtjXY6CzHyWj0LpiCmIfe0pQcuOnhVtXuEo8ezdq1VD6et3tHf0gyOx6QGdQBHvnJ/jpUTHowDepxkn5LNqAmSlcEUnWLavd/bjSfpD0wey5lxxugOa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1ACDE1476;
	Wed, 21 Jan 2026 08:23:39 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C6D23F694;
	Wed, 21 Jan 2026 08:23:44 -0800 (PST)
Date: Wed, 21 Jan 2026 16:23:39 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 0/6] KVM: arm64: ... and FWB for all
Message-ID: <20260121162339.GA1846642@e124191.cambridge.arm.com>
References: <20260119105651.255693-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119105651.255693-1-maz@kernel.org>

After a crash course in FWB,

On Mon, Jan 19, 2026 at 10:56:45AM +0000, Marc Zyngier wrote:
> [Yes, you can tell what I was listening to]
> 
> Today, running in protected mode puts the host under it's own S2 with
> FWB=0, even if the rest of the guests are running with FWB=1. The
> rationale for this special-casing of the host is that we want the
> combined attributes to actually reflect the ones exposed by S1.
> 
> We therefore use NormalCacheable (which is the weakest memory type) as
> the default attributes at S2 so that S1 can only strengthen the final
> memory type.
> 
> But there is no reason why we cannot achieve the same effect with
> FWB. We normally use FWB to enforce cacheable memory from S2,
> irrespective of S1. But it is possible to configure the S2 attributes
> as "pass-through", so that the S1 attributes are always used.
> 
> This small series implements that change, adding a flag that actually
> describes what we are trying to do (instead of the NOFWB flag which is
> pretty obscure), and fixes an interesting gotcha with CMOs.
> Interestingly, CMOs never actually worked with NOFWB on an FWB-aware
> platform...

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
> 
> Patches on top of 6.19-rc5.
> 
> Marc Zyngier (6):
>   arm64: Add MT_S2{,_FWB}_AS_S1 encodings
>   KVM: arm64: Add KVM_PGTABLE_S2_AS_S1 flag
>   KVM: arm64: Make stage2_pte_cacheable() return false when S2_AS_S1 is
>     set
>   KVM: arm64: Switch pKVM host S2 over to KVM_PGTABLE_S2_AS_S1
>   KVM: arm64: Kill KVM_PGTABLE_S2_NOFWB
>   KVM: arm64: Simplify PAGE_S2_MEMATTR
> 
>  arch/arm64/include/asm/kvm_pgtable.h  |  7 +++---
>  arch/arm64/include/asm/memory.h       | 11 ++++++---
>  arch/arm64/include/asm/pgtable-prot.h |  4 ++--
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  4 +++-
>  arch/arm64/kvm/hyp/pgtable.c          | 32 +++++++++++++++++++--------
>  5 files changed, 39 insertions(+), 19 deletions(-)
> 
> -- 
> 2.47.3
> 
