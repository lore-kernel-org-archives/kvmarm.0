Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794955605;
	b=2ooMvwUiy3SxlRkP0mKhySiYIBpNWq9E/oPI4k9kbcpYYouGWC4B44oGQtVkZ7tjGNs3
	 ScrlP0oGflK5PdsKIfi7O+XomjFpEHATaZGXukHpJiBqv4PxRMgraw7X+X4oXIKCnnxhx
	 XU0uWlJyFswFXJ+Kz7Oxy/dzMgDMLcVNxDudC7vyTnlFFk06Pm9SQXEiJKsl3G0AluXYT
	 z+5u02czVy/B7q/u8/p2w7Tz2kf5PJ4CezOXchdHUdrV3YncLhst2yxa000m4Qzmt5cDM
	 1x5/JZ5r5d6Bo4S4ArapSXGR2rBnz5o2rHKygvw+0aFAD0Zc/huYw+X6HFKRTQlChCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794955605;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=O42IkrS9jeTCK/NHaai3Y1tyVx5hVS+EWpn+Yy3d8yI=;
	b=n64q5YS0EgMdViA0tsMzQpbVoSkY+gfJ3HYLSrq4z1LT1zTIV/turwP+483TfeV5m6c6
	 6gGa4aEsGD0MJ235Zkzk+IIh9uZZ/JSZH7sc/5oKCHCfGMscwixxj9XNoq2gtP/P4trqs
	 pxwa783rFJcqMxp7440APl5c7dFokEuikU/3S0NTc5XdEJzuPAe5cHVsApCaANJ8J47GZ
	 /P2Pa19GEPzS6W90P4PeGZvTrtH+rAAqhnA2mL8HJFsY+6NZEyno5gxEIbuf4XIClm/H+
	 OKemIxeEt5J2sDO02EFElVDOK71C6e/IRg+4w00l8PX8US1lwDjaAYwV/ysMHaGbV4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iyO9GWF2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FC7606A32A;
	Tue, 17 Nov 2026 22:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iyO9GWF2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46F41F000C4;
	Tue, 17 Nov 2026 22:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794955605;
	bh=O42IkrS9jeTCK/NHaai3Y1tyVx5hVS+EWpn+Yy3d8yI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iyO9GWF2tAcGIGrZynM3V9LMbB3J3bzToMv8b0reAugTl73Sx4KZii0IJsV1VBfx2
	 WGvl6RFuotOhxRMGJoU5ayKO92eMS8kwLZx140AxWWqTpy1TxTk7iygRo06VzvBHN8
	 KgfG5jrSvA2PiQ2lsc3Hi8WtAeEc1rF1q65+j9gD3pvTbBZ3l2yVzKr4usIwcq/JDY
	 1Q9IWj5Xy4plv83pxJOrsAZLBVGf/2uNbBCzHtYS7sCo6FbiBMr4DZC2tt/7qHdLew
	 Unjnf5r8pOmNdxp5RiA1ljIGfHRjlqUJWM/5YFgQaHNYPv+MkAG8YQg8pzZumR8Sg/
	 0JwSgIuselQYw==
Date: Tue, 17 Nov 2026 14:46:43 -0800
From: Oliver Upton <oupton@kernel.org>
To: Colton Lewis <coltonlewis@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Leonardo Bras <leo.bras@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: Fix inverted E2H0 check for
 HCR_EL2.NV1
Message-ID: <avzZUyu9EhxAWtbd@kernel.org>
References: <20261117204535.4036191-1-coltonlewis@google.com>
 <20261117204535.4036191-2-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117204535.4036191-2-coltonlewis@google.com>

On Tue, Nov 17, 2026 at 08:45:34PM +0000, Colton Lewis wrote:
> ID_AA64MMFR4_EL1.E2H0 is a signed 4-bit field where:
>   - 0b0000 (IMP, 0): FEAT_E2H0 is implemented.
>   - 0b1111 (NI, -1): FEAT_E2H0 is not implemented, except HCR_EL2.NV1
>     is implemented.
>   - 0b1110 (NI_NV1, -2): Neither HCR_EL2.E2H == 0 nor HCR_EL2.NV1 is
>     implemented, and HCR_EL2.NV1 is RES0.
> 
> Prior to commit b2a324ff01fe ("KVM: arm64: Use HCR_EL2 feature map to
> drive fixed-value bits"), kvm_init_nv_sysregs() marked HCR_EL2.NV1 as
> RES0 when !kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, NI), i.e., when the
> signed E2H0 field is less than NI (-1), which matches NI_NV1 (-2).
> 
> When converting HCR_EL2 to the feature map, feat_nv2_e2h0_ni() was
> written as !kvm_has_feat(kvm, FEAT_E2H0), where FEAT_E2H0 checks
> E2H0 >= IMP (0). This inverted the condition: feat_nv2_e2h0_ni()
> evaluates to true when E2H0 < 0 (including NI_NV1), leaving HCR_EL2.NV1
> writable instead of RES0 for VHE-only nested guests where KVM advertises
> ID_AA64MMFR4_EL1.E2H0 = NI_NV1.
> 
> Check kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, NI) so that HCR_EL2.NV1
> is treated as implemented only when E2H0 is IMP or NI, and forced to
> RES0 when E2H0 is NI_NV1. Rename the helper from feat_nv2_e2h0_ni() to
> feat_nv2_nv1_not_res0() to clearly reflect what it tests.
> 
> Fixes: b2a324ff01fe ("KVM: arm64: Use HCR_EL2 feature map to drive fixed-value bits")
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  arch/arm64/kvm/config.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index adaf26ab93b85..a975ac73ed876 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -256,9 +256,10 @@ static bool feat_nv2(struct kvm *kvm)
>  		kvm_has_feat(kvm, ID_AA64MMFR2_EL1, NV, NV2));
>  }
>  
> -static bool feat_nv2_e2h0_ni(struct kvm *kvm)
> +static bool feat_nv2_nv1_not_res0(struct kvm *kvm)
>  {
> -	return feat_nv2(kvm) && !kvm_has_feat(kvm, FEAT_E2H0);
> +	return feat_nv2(kvm) &&
> +	       kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, NI);
>  }

This could benefit from a comment, because testing for NI as a feature
is very misleading. Also, I don't why this needs to spill onto another
line.

	/*
	 * The E2H0 field is a 'negative' feature field, where a value
	 * of -1 implies FEAT_E2H0 is not implemented but does not
	 * restrict the use of HCR_EL2.NV1.
	 */
	return feat_nv2(kvm) && kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, NI);

Thanks,
Oliver
