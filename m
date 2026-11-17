Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794936079;
	b=xpO5x6bUaUJQx//c0Bn82RS5Hq56WOkO6XLA8xZF0HT9/UscvEMmZBXjKbnnQMGMMZJw
	 kEfDXcmCQ2EBE7Tj8OsOPMSPJanRh9+y1wl6duKmz0mYSj7pvXhG/RhCkpMhOq8dArXAe
	 TUKuboJCtURqPd2PDDivvGPl3Sw2kaymb9Zr/WZc6LqqZ9peHguGwS/ywlUAW+s6hCNDz
	 pBQXZA77hRcc3V6Kwi8Y+J9RA2bDtqOWmN1jw04JNeL+GQ895bc21EypFEsS8gEPZ6cmy
	 tZDGFvLBZQ0eC+sc2p+ISh29Xo6lmZS+Q/DXV5y0Oh92uO/MAfYupvzKGN75Jz+5TGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794936079;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=j49FQqF/5AAaYAE+Xw+IyqdKqNIf0oE/qvi3zUpU3es=;
	b=Dg+D8F6geJmf+2EbtsUCv5xKJQ74JNE5oCa5ArWLH2NOxpnN14qZoJyy26Phi+u28oqW
	 XD+yqMvmWDVIO7CquBqnb5apKLGKSC5QYsQ6lFZZwiMywS5EvqlKiVhs4RDtaF4jzTt9M
	 njhfFTc2T8UCeJF4QWoZrrcT7Kc4Gr+GLjktZfj4BXape24y8k22Q/PYosKFU6FYzCO44
	 ytJkjK/8wgOADLr3616304IFJj+aMDviCzclf/non0RTgGhv+ixaRMxltLa8RW+Pv0XoI
	 SZqmfxMaT9ziVyC9guANObp95d7gA2KZFf7zEwC4KeCQtLFFh8vsYnwo8JrQOhgUCmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XISAVZ4i;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13993606A885
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:21:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13993606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XISAVZ4i
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DAC11A00;
	Tue, 17 Nov 2026 09:21:14 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B426A3F632;
	Tue, 17 Nov 2026 09:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794936077; bh=UF4/WZWpnvhVbjnhm5Fhiug3i+G9AJ9V+I3bAy37IEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XISAVZ4i0KKFtENmf4YZAeVOf0w1jBZnBhSZ+hU3sV8p6PBglO0PqWm9emUhFpc9a
	 5P4dH5Z+qPk/6NH+bBWt69XFuo+en5u+hsdgjg5xg3eFIcViu1jN33qiwD5BXvWKzf
	 ywluq+Q2pDqzs9KM9otMDaTb7/VRQ8XTyeE450SQ=
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
Subject: Re: [PATCH v1 1/2] KVM: arm64: Fix inverted E2H0 check for HCR_EL2.NV1
Date: Tue, 17 Nov 2026 17:21:10 +0000
Message-ID: <avyNBn24sLjxrfgR@LeoBrasDK>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261116200418.3535619-2-coltonlewis@google.com>
References: <20261116200418.3535619-1-coltonlewis@google.com> <20261116200418.3535619-2-coltonlewis@google.com>
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

On Mon, Nov 16, 2026 at 08:04:17PM +0000, Colton Lewis wrote:
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
> Check kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, NI) in
> feat_nv2_e2h0_ni() so that HCR_EL2.NV1 is treated as implemented only
> when E2H0 is IMP or NI, and forced to RES0 when E2H0 is NI_NV1.
> 
> Fixes: b2a324ff01fe ("KVM: arm64: Use HCR_EL2 feature map to drive fixed-value bits")
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  arch/arm64/kvm/config.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index adaf26ab93b85..b4f555d39f54a 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -258,7 +258,8 @@ static bool feat_nv2(struct kvm *kvm)
>  
>  static bool feat_nv2_e2h0_ni(struct kvm *kvm)
>  {
> -	return feat_nv2(kvm) && !kvm_has_feat(kvm, FEAT_E2H0);
> +	return feat_nv2(kvm) &&
> +	       kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, NI);
>  }
>  
>  static bool feat_rasv1p1(struct kvm *kvm)
> -- 
> 2.56.1.750.gf70dc682cf-goog
> 

Hi Colton,

I just read the code that uses feat_nv2_e2h0_ni(). IIUC if it returns 
false, we get HCR_EL2.NV1 to be RES0. Otherwise it's writable.

The change you suggest is returning (ID_AA64MMFR4_EL1.E2H0 >= -1), which 
would return false in the case of NI_NV1 (-2), and make the field RES0 only 
in that case.

I think it does make sense, but maybe we should also change the name of the 
helper from feat_nv2_e2h0_ni() to something that reflects what is being 
tested now. feat_nv2_e2h0_imp_or_ni() would be confuse, and maybe 
feat_nv2_e2h0_not_ni_nv1() would be as well. 

Maybe feat_nv2_e2h0_not_res0(). What do you think?

Thanks!
Leo
