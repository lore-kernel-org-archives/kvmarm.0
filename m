Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795090187;
	b=HW4jSdtAhmuIdLtdlSYvr2IyWJso6Z6NsW3ACxAgXzHhn3re2cnmEjybN0geRw8+VNw6
	 9C96ICl6Dfm1bjEb+8gju55iuyQyvy1yxTeNJMIUQmZ8DTddmuOCR43+PVI1I/GnHRULb
	 GNZpBakIF0QwUmm0FxB/9IvEKMiPF5RLVz+QjU+m+UiSK4w7NYYr7IAHFam/K447Blfnd
	 XK1iXNFqHp1y3wl8vrxdzNVpUf3PAm/tiVNBu/bMH5vFrm70k5ig4Roh4kjAIs7mkGHwW
	 t9REJqQCFE+uGWxpQJgfvXBOj5wzAXWb/EO1ntC0bNxJ4j9gUTknWjwdcDnUnb3Cx3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795090187;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=lGbG2L4q6RTjy90wDXOhxvLRZROy91QQyYQgPEuX3bg=;
	b=HtFzHEHFp2eieA47oW0BAbgsLsBrIYQJ8Snac0m2OmdKMYKdLBdEL+vhp+wJlFeUiylR
	 8BD+uybeQkTY7QXlgziO/UE2CXIACScKUNI8z4M9ZIYp8wbuj/K4EzI2qyZ57ttto/vBW
	 h5GHCx+/CRrC8/qvNDr6hzSBVPutC4+X1XIwtL5uIz1z/HOqyDwn/nsoFMg2NfFxWE4Pb
	 eUDf/S7AhFz1Pm9bTsXPrl/E57e/Vt/8TLEZy4qHrDfldeNUgHTF5enljSglu8sVzoGFn
	 p0TTLA+oNNDp49Auap/cyFmCJOCs73oCWOzZd/kybuT826D9YMZKwYGQ1ilwCKeg+2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vJUzndq5;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6515606A325
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 12:09:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6515606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vJUzndq5
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D43B51575;
	Thu, 19 Nov 2026 04:09:41 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03AF63F673;
	Thu, 19 Nov 2026 04:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795090184; bh=1fgCKNJyc0tTlHTT1RIfQJggRcZMC0RxEy2L4qzqKbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJUzndq5Ok01/Kqcwshxgwd92G+eiNBaLToglFYnZSlRd4AoA1JRLhuV2E2+WKLoY
	 kC8dh/QxIrV8b/I0GHgE9OAzzkl92ZXhysnUrbeeSmFhsvcLRJauvN6yp+6t8czB1c
	 ooM5FN96dMskIbJkKmUkfgI6LIiEUyWAucO4zaQY=
From: Leonardo Bras <leo.bras@arm.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] KVM: arm64: Force HCR_EL2.NV1 to RES0 unconditionally
Date: Thu, 19 Nov 2026 12:09:29 +0000
Message-ID: <av7m-W5ataGJ8dNc@LeoBrasDK>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118203625.743428-2-coltonlewis@google.com>
References: <20261118203625.743428-1-coltonlewis@google.com> <20261118203625.743428-2-coltonlewis@google.com>
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
Content-Transfer-Encoding: 8bit

On Wed, Nov 18, 2026 at 08:36:24PM +0000, Colton Lewis wrote:
> ID_AA64MMFR4_EL1.E2H0 is a signed 4-bit field where:
>   - 0b0000 (IMP, 0): FEAT_E2H0 is implemented.
>   - 0b1111 (NI, -1): FEAT_E2H0 is not implemented, except HCR_EL2.NV1
>     is implemented.
>   - 0b1110 (NI_NV1, -2): Neither HCR_EL2.E2H == 0 nor HCR_EL2.NV1 is
>     implemented, and HCR_EL2.NV1 is RES0.
> 
> When commit b2a324ff01fe ("KVM: arm64: Use HCR_EL2 feature map to drive
> fixed-value bits") converted HCR_EL2 to hcr_feat_map[], feat_nv2_e2h0_ni()
> was written as !kvm_has_feat(kvm, FEAT_E2H0), where FEAT_E2H0 checks
> E2H0 >= IMP (0). This inverted the condition: feat_nv2_e2h0_ni() evaluates
> to true when E2H0 < 0 (including NI_NV1), leaving HCR_EL2.NV1 writable
> instead of RES0 for VHE-only nested guests where KVM advertises
> ID_AA64MMFR4_EL1.E2H0 = NI_NV1.
> 
> In practice, KVM cannot handle HCR_EL2.NV1 being non-RES0 in any
> configuration: limit_nv_id_reg() exposes either VHE-only EL2 with
> ID_AA64MMFR4_EL1.E2H0 = NI_NV1 (and E2H0 is not userspace-writable), or
> FEAT_E2H0 without FEAT_VHE or FEAT_NV. Checking E2H0 in a feature helper
> is therefore unnecessary.
> 
> Drop feat_nv2_e2h0_ni() and mark HCR_EL2_NV1 as an unconditional RES0 bit
> using NEEDS_FEAT_FLAG(HCR_EL2_NV1, FORCE_RESx) in hcr_feat_map[] (shared
> by HCR_EL2 and NVHCR_EL2). Because HCR_EL2_NV1 is not part of the
> architectural HCR_EL2_RES0 mask, check_feat_map() accounts for it as an
> implementation-defined FORCE_RESx bit.
> 
> Fixes: b2a324ff01fe ("KVM: arm64: Use HCR_EL2 feature map to drive fixed-value bits")
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  arch/arm64/kvm/config.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index adaf26ab93b85..2e81f45dc9921 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -256,11 +256,6 @@ static bool feat_nv2(struct kvm *kvm)
>  		kvm_has_feat(kvm, ID_AA64MMFR2_EL1, NV, NV2));
>  }
>  
> -static bool feat_nv2_e2h0_ni(struct kvm *kvm)
> -{
> -	return feat_nv2(kvm) && !kvm_has_feat(kvm, FEAT_E2H0);
> -}
> -
>  static bool feat_rasv1p1(struct kvm *kvm)
>  {
>  	return (kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, V1P1) ||
> @@ -1034,7 +1029,7 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>  		   HCR_EL2_NV2		|
>  		   HCR_EL2_NV,
>  		   feat_nv2),
> -	NEEDS_FEAT(HCR_EL2_NV1, feat_nv2_e2h0_ni), /* Missing from JSON */
> +	NEEDS_FEAT_FLAG(HCR_EL2_NV1, FORCE_RESx), /* Missing from JSON, RES0 as an IMPDEF choice */
>  	NEEDS_FEAT(HCR_EL2_API		|
>  		   HCR_EL2_APK,
>  		   feat_pauth),
> -- 
> 2.56.1.750.gf70dc682cf-goog
> 

Right,
KVM nested requires VHE, which uses E2H, which conflicts with NV1.

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
