Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503854E0B9C
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 14:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790606569; cv=none; b=PR+jXdujwbKZr9Ct3MuC8XtftuswYux1Ed/sZPr9CZYjZbvOO0pMbn32mfDSJCrwhnve9gtDgBdtXAZcWjS/G6GwjCCog/HorLM5+/25WRCDs3rit52sJ6ACsIVxdBuvFqCPlJWJ1Hnm82ie9xBjS20xq2K7OMUy5xMxNYf8Lco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790606569; c=relaxed/simple;
	bh=T2yBRBL6vN5jLO3K+Ha1Kq184jaU+Bh/rRV3I4OkDTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=PYYB8O9L0MM1IEbSLPotWW9g5OjInO043FxHj2xlzKRWFSL2WgrYadVZo0qwKG5ye6oPBTVXcdZQYouQvpNwo/6jvfK0rnybm6KIgG5qFvflBdVkaHSnZ1FUEiIrqd6k266xhdBiACmgXn45BQLIpZcIA4p0O1rYuGKdizQjj50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Fc7vR5yF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Fc7vR5yF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0A031655;
	Mon, 28 Sep 2026 07:42:34 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E618E3F86F;
	Mon, 28 Sep 2026 07:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790606558; bh=T2yBRBL6vN5jLO3K+Ha1Kq184jaU+Bh/rRV3I4OkDTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fc7vR5yFhS5Nybd5/FMzYNsdIg4kCn/qOmr5y9Yo1HAa0ebyxZ3yoHwMn1GAKT7NL
	 sgKwr27afMR8HHTqALmuwv7QWqeaPEfKHxkhPKMHKOW1qooJDik+wN5K9uX71yFEzD
	 9M0oUa59AxM1/UOz2F+0vKHWZLE0nA7tMgXQlLag=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 19/22] KVM: arm64: nv: Expose FEAT_HAFT
Date: Mon, 28 Sep 2026 15:42:34 +0100
Message-ID: <arp82kTyY9SCPDmz@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-20-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-20-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:58AM -0700, Oliver Upton wrote:
> Both stages of translation now support the access flag on table
> descriptors, advertise the feature.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 6f540d3481d5..dc2a8b6483c2 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1799,7 +1799,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>  		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
>  			val &= ~ID_AA64MMFR1_EL1_VH;
>  
> -		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, DBM);
> +		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, HAFT);
>  		break;
>  
>  	case SYS_ID_AA64MMFR2_EL1:
> -- 
> 2.47.3
> 

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
