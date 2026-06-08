Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73443EF649
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 15:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780932192; cv=none; b=sW4qaco3gyZP7OvlQW4e8wiSnFV4YVTfz8pAw+XDdwvEf3PHAv5Rc3G5tg/ZJPeOphNM0gg47BILdqPx7BS+5Y714nzZNiky192wLiDSl6peDuxs7q5LpUq0xwhCvxzPA3Dvtl9VcuHQNSD0xZET9cqVkpeTlihIL+yy8AMivD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780932192; c=relaxed/simple;
	bh=U1QnQ8FNiiJRG5/VviIte+UekKuf/B5wCMRztBquyPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=cwxFkegzizl8lUnsnfAs8VWg59UYSU+/gQHpoGZxTwQYBoz8MQ2nEDigM6gzbSWiA7mEmxvvNZKXCxXEfepzHT4F3SlEE3Mnm/KYzQ73zCfCVdgtagGjoRvGaPo9DUspo9JVNedRAGD2k6u8OjuXAkizNdQSCDX0TBp7rG94ZWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jHAcC9N/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jHAcC9N/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E50321BF3;
	Mon,  8 Jun 2026 08:23:04 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B5713F86F;
	Mon,  8 Jun 2026 08:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780932189; bh=U1QnQ8FNiiJRG5/VviIte+UekKuf/B5wCMRztBquyPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHAcC9N/vOvn59nMvvqwoenkkcnDUrGPzUeSKiRxTczMxoZGZ4LPRzy4sRP6mrK2A
	 y0Xja/AGpGl0iBvGgDBhIeSeUI46dVszHRenwY4R41VmPuuDN/C9Ps40fA1gcFOhrv
	 OQHauRT+9IRJiV9DuCoXEiQKXaR+brjzZL/ZLbe4=
From: Leonardo Bras <leo.bras@arm.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Remove superfluous aligning of gfn for dirty logging
Date: Mon,  8 Jun 2026 16:23:05 +0100
Message-ID: <aibeWQY48zEsjqOt@devkitleo>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605153248.2412064-3-weilin.chang@arm.com>
References: <20260605153248.2412064-1-weilin.chang@arm.com> <20260605153248.2412064-3-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jun 05, 2026 at 04:32:48PM +0100, Wei-Lin Chang wrote:
> Stage-2 mapping size is forced to PAGE_SIZE when dirty logging is
> enabled for a memslot, therefore we don't need to align it down to
> a possibly larger vma size or THP adjusted size, they won't happen.
> 

IIRC there was some effort being made in terms of tracking in LEVEL2 block 
granularity instead of LEVEL3 (PAGE_SIZE). It makes sense as some platforms 
can have very fast networking so setup time is more relevant than actual 
sending time.

Would not making this change affect such effort?

Thanks!
Leo


> Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> ---
>  arch/arm64/kvm/mmu.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 06c46124d3e7..d1f6ff7c2943 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2050,13 +2050,12 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  
>  	/*
>  	 * Mark the page dirty only if the fault is handled successfully,
> -	 * making sure we adjust the canonical IPA if the mapping size has
> -	 * been updated (via a THP upgrade, for example).
> +	 * mapping size is forced to PAGE_SIZE if dirty logging is enabled,
> +	 * so we don't have to adjust the canonical IPA here.
>  	 */
>  	if (writable && !ret) {
> -		phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
> -		ipa &= ~(mapping_size - 1);
> -		mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
> +		gfn_t canonical_gfn = get_canonical_gfn(s2fd, s2vi);
> +		mark_page_dirty_in_slot(kvm, s2fd->memslot, canonical_gfn);
>  	}
>  
>  	if (ret != -EAGAIN)
> -- 
> 2.43.0
> 
