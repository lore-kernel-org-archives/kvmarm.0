Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1AD2FF675
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 06:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873110; cv=none; b=h8ljeZe1PVqB/breH4bFiMbbWkSNz02JkJaAO7S3JI69DTRk6ab96MC2XQZhvffwR1pVOzOzxPPWCvMcC7WDSsRfKO0M38IEkpSZEQww5sIx3dDdPDxhZ41ASamHfBBJ7Le9TMCmjj1IOMpOwuSF+L8zAMgS7vXus5ZOkESj/Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873110; c=relaxed/simple;
	bh=zZueFxGVHgitf5Wcs7bnMi8GO7HQLQPPp88NO0QH4AE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VO+jvSZh6mxN/cDyhr5pDn9FaaDONWOTnGSS9rHvKQSKv9z/+2knw59EGcm7nNbI2QyAornNbi74SWP2DATYfjPqqrBBgFU0qXbDAQxhwRiqqxu+YYtPUhh4wSmkzsSgu6xDH03bxoSZyXDOHNPyG7jKDQOxOnvzS5Q2gtH4bzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Veli/8jx; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Veli/8jx"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784873099; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=SnV5QCYs96+b5L9vYPvdSR5j/BEGUkoqeIIiwjVfNWA=;
	b=Veli/8jx3x06PPKIa9tYka9J9/b79sgybHob5wMZnYiWSllcL5BboYh7mofSNNnDfJXnYcntyjDd4vnIlLUAyufqq+5q1CYuTWCgWPKw7FMbdaLWRm/k810sLKsUS6Xktofo06QLdgwM+vme2PNBcbarMdQ13JrxVk1m1Cxp7cM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X7i9h0p_1784873098;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X7i9h0p_1784873098 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Jul 2026 14:04:58 +0800
Date: Fri, 24 Jul 2026 14:04:57 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 07/28] KVM: arm64: Don't evaluate HCR_EL2.NV nor
 HFGITR_EL2.ERET on ERET fast path
Message-ID: <syytdlctsuj4ixszpy76bjdovdr4bxgfofgpfzjvo3hotwmjti@qfnfzngfuxcy>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-8-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722074234.3330999-8-maz@kernel.org>

On Wed, Jul 22, 2026 at 08:42:13AM +0800, Marc Zyngier wrote:
> We currently avoid using the ERET fast path if the guest has HCR_EL2.NV
> set. This is an odd check, as NV doesn't mean much if HCR_EL2.TGE==1.
>
> Similarly, evaluating HFGITR_EL2.ERET makes little sense, as
> this only applies to the nested context, while the ERET fast-path
> is purely for the benefit of L1.
>
> Replace these bizarre checks with is_nested_ctxt() which makes a lot
> more sense: if we are running an L2, the ERET trap must go to L1.
>
> Fixes: dd0717a998f77 ("KVM: arm64: nv: Fast-track 'InHost' exception returns")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vhe/switch.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index bbe9cebd3d9d5..684cebf23aa0e 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -344,13 +344,15 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	 * if this is a VHE guest hypervisor returning to its own
>  	 * userspace, or the hypervisor performing a local exception
>  	 * return. No need to save/restore registers, no need to
> -	 * switch S2 MMU. Just do the canonical ERET.
> +	 * switch S2 MMU. Just do the canonical ERET unless we are in
> +	 * nested context.
>  	 *
> -	 * Unless the trap has to be forwarded further down the line,
> -	 * of course...
> +	 * Note that this is made possible because KVM itself never traps
> +	 * ERET when running an L2. The consequence is that any ERET trap is
> +	 * the result of HCR_EL2 or HFGITR_EL2 programming by L1 for its own
> +	 * guest, and the exception must be forwarded to L1.

Yes, right.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>  	 */
> -	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV) ||
> -	    (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_ERET))
> +	if (is_nested_ctxt(vcpu))
>  		return false;
>
>  	spsr = read_sysreg_el1(SYS_SPSR);
> --
> 2.47.3
