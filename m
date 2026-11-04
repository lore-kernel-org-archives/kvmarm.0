Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811369;
	b=ridBeWTJoBLNjQO5bm6Y4WTpS20kpj3uACJOw451CTJoXO1j77Gzy7N1ZnYU9EMV1Wlg
	 YQZe0MeCOWky2687G9IGJCAZjP/zyM1QxER4gMneyi8p0KHn0hDld/W03LmlTI7bkRRrV
	 c4NY5cuN/bYBaxAm1JlKhHiZLYnIo9RBLMmrpEADZcONdXhmJbkz9sZG5atB4svgODEzE
	 rn4GP5IhN6eDpHqdqpk9X0hydaMLpVtyCRUTrjDEOi1vKu/NspBDMwBTOwxOsrstYRAQv
	 OxxnPHwxpIvax97SMYl84s1bCTlj/ydM4N5v0+WVd3HXT8Mc6R8RwCBFzteNXaqKF9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811369;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=n5CfQrX5gYgElD9nmLgL3JWj0n+BYQaK8mRSUfHEs4c=;
	b=p5uFqIJS1unD7Eqmi8jQGERpayJJcYGbAjImoPBwX6piE9DVL3yqVLups1y8NerJCSJh
	 AmheyVzgA/d2UlcpMnHqE0zKgcGYJPlBJOSSBcWawpmefEZ8E/S1cOrVJDVlupsjdeD0N
	 eISs52Abu/XANev6KKNrZKM5bvL9F8FzSRx6pgkVtItaqe/pwEiGTvxChBqbD1wiOcgGV
	 NHR6+vmxjb8QHHbfaRBdxyhPtDT8BGJ9jMKlL+lb+97ZiEFdS2G9O3FPNLYmAcu2OZ/Zj
	 WHNGL+jKnUsmBiB2Q1wEXGoLg1erqeamuQ0gnKtCqmyZzdmCPEL4C5pRXKuPEO12NYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Tlv+ddeq;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75B70606A333
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 16:56:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75B70606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Tlv+ddeq
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF157169C;
	Wed,  4 Nov 2026 08:56:04 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45E743F632;
	Wed,  4 Nov 2026 08:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793811367; bh=H6WXOZLzE/kPOEiQJwDAZV3W2GVLRCXUeaTjQo+nWEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tlv+ddeqtWBWsgBbs3Z4vsXkvv6y8KWSHi3X2EqJJpAW1+dl78E8VM8yPNYlwt8UM
	 BhDZrT3HS1RMVOJaq/dGlay9SHu2UWe/u7WlY5JQpbMcdf90Jz8Y4fboTZqXDiJ0N2
	 055zXffzT5fDTWKp5a/Wxd47iQERLa8hzj2fdKkA=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 21/28] KVM: arm64: nv: Expose FEAT_HAFDBS
Date: Wed,  4 Nov 2026 16:56:03 +0000
Message-ID: <autjo4fzUat4cYQT@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023205610.1044532-22-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-22-oupton@kernel.org>
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

On Fri, Oct 23, 2026 at 01:56:03PM -0700, Oliver Upton wrote:
> Everything is in place now to support hardware dirty state management.
> Flip the corresponding bit and advertise the feature to the guest.
> 
> Reviewed-by: Leonardo Bras <leo.bras@arm.com>
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 46fcc75f4c20..eb20409a14b1 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -2040,7 +2040,12 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>  		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
>  			val &= ~ID_AA64MMFR1_EL1_VH;
>  
> -		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, AF);
> +		/* FEAT_S2FWB implies IDC */
> +		if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) &&
> +		    cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
> +			val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, DBM);
> +		else
> +			val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, AF);

I suppose it makes sense, if we are skipping the cache maintenance we have 
to make sure it's not actually needed.

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks,
Leo
