Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD039194C98
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 03:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785814472; cv=none; b=AXcnBLnjsKBHAAWtsez91CIi2R50ka5sh1sv6O15f+4X5ttoNv1yPQsZ5E9IS2STCKq6TGM18T6uOSAwo4vSLOIsBN56hieYvXmUTCoQO/YGcxYEnfG/49tV3j+klJnLUjj2QAkTCrrEd0dJMtGImA15+wcw5o4bDzzOozGkY3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785814472; c=relaxed/simple;
	bh=TZzW/PJMPDU1jXSTqByWg76Kcq5EsBAxg6JD2M28RHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GloOTOOwjKKcp1YCWuSn0g+EVCVfL5C6a4bSbdzng4JjWmTmEGYFzfrgfcsygDfJrFjIpm+olTj6WL82MjbaoW/9qIRN9m0YS55v1xv9RinYHpvuOvACRIQia1VV7vsr1Lf3IO3uSqMMYlWfbInU8BxdxomWqFAJFtnoUNZ1ZFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CDTpmPiL; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CDTpmPiL"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785814466; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=TTOKzgHuD3KRtjS03wNmLdJVCRW00bEzm0RyWyZwqBI=;
	b=CDTpmPiLHmKqq3jOZmSIsQHNezWD+IUN9i59bdtI0AAgKPB94yMKIBN6Sd4Gz7xPbMGoCx4CY0quQp4N4JPrHGHFRRvGgLalJib8aC9x6aOa8OpuDqaDIP7dQlXK15G6VPMPMZ9pDTJ4POcRJue7ELyHFmOraYC6R3SLQrjZIXk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X8MUQlp_1785814464;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X8MUQlp_1785814464 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 04 Aug 2026 11:34:25 +0800
Date: Tue, 4 Aug 2026 11:34:24 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Hyunwoo Kim <imv4bel@gmail.com>
Subject: Re: [PATCH 5/6] KVM: arm64: Couple VNCR fixmap clearing and CPU
 number invalidation
Message-ID: <wlcvwmmsu3ryj3zytcnx5xhmuhjbgofqsaw5o54qwbdwc3n7ca@wj5n4swgeokb>
References: <20260801124818.366274-1-maz@kernel.org>
 <20260801124818.366274-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801124818.366274-6-maz@kernel.org>

On Sat, Aug 01, 2026 at 01:48:17PM +0800, Marc Zyngier wrote:
> A mapped VNCR translation must indicate which CPU it is resident.
> Unmapping such a translation must make this CPU number -1.
>
> Couple the unmap and the setting to -1 in a helper, so that we
> are always sure they are done together.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 47d61d3cf053c..84915e2cff604 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -894,6 +894,12 @@ void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>  	}
>  }
>
> +static void unmap_l1_vncr(struct vncr_tlb *vt)
> +{
> +	clear_fixmap(vncr_fixmap(vt->cpu));
> +	vt->cpu = -1;
> +}
> +
>  static void this_cpu_reset_vncr_fixmap(struct kvm_vcpu *vcpu)
>  {
>  	if (!host_data_test_flag(L1_VNCR_MAPPED))
> @@ -902,8 +908,7 @@ static void this_cpu_reset_vncr_fixmap(struct kvm_vcpu *vcpu)
>  	BUG_ON(vcpu->arch.vncr_tlb->cpu != smp_processor_id());
>  	BUG_ON(is_hyp_ctxt(vcpu));
>
> -	clear_fixmap(vncr_fixmap(vcpu->arch.vncr_tlb->cpu));
> -	vcpu->arch.vncr_tlb->cpu = -1;
> +	unmap_l1_vncr(vcpu->arch.vncr_tlb);
>  	host_data_clear_flag(L1_VNCR_MAPPED);
>  }
>
> @@ -996,7 +1001,7 @@ static void invalidate_vncr(struct vncr_tlb *vt)
>  {
>  	vt->valid = false;
>  	if (vt->cpu != -1)
> -		clear_fixmap(vncr_fixmap(vt->cpu));
> +		unmap_l1_vncr(vt);

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>  }
>
>  static bool vncr_tlb_intersects(struct vncr_tlb *vt, u64 addr,
> --
> 2.47.3
>
