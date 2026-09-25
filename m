Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79BB4D8DBF
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 15:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790351650; cv=none; b=Une5KdqtAvYQuphbe3uK3KUT2LaTiN/xNs+8F2B+Fp/djUoJBOZvE6tPKv5V/WwaIWv558XfKNsa/o9fG6chsI1n6eiBeWtW0kEmPX4/BOVLHtBjStNqYg8qPGgCeSVgJxuEZYlEdwTJUuf1lkEj9vOfbQqL1gg00WEQPHEbcfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790351650; c=relaxed/simple;
	bh=g663YX9Fr6L7+XWdnhZTVBhUO4IibM0cx81qljccie8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=N+wNdOcyPjBJAi471rBYeIyjidUtaB9omyAXdAhL9bp8lWaG57BA9O+BncJFKuesilRmoeux19X9HAmgmt2FaZxyi9AKYpoM50UvfUyFHWP0RO/NtfrYcmnU2avq2HLTOvZ/s/08KSMX+OljmxE28iGWrk7ArJKK9JqhuRCtQHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nO5sF56A; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nO5sF56A"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43B27169C;
	Fri, 25 Sep 2026 08:54:00 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E7FD3F86F;
	Fri, 25 Sep 2026 08:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790351643; bh=g663YX9Fr6L7+XWdnhZTVBhUO4IibM0cx81qljccie8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nO5sF56As61L2ShxTRgADUUKBJE/IhcyPJ4r8aLZNcpdmIuir4PmF53MVj6V2ui8p
	 xUgnbN010lkq0JGY9PPnq5jING+mSM1ZWmzHaB8dvTwmCGHA7rMTrmucCKN9tPsypU
	 nvJJbdb/23bv9KnzzH/Cd1tbPxmAhOHDUaLb+IB0=
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
Subject: Re: [PATCH 16/22] KVM: arm64: nv: Expose FEAT_HAFDBS
Date: Fri, 25 Sep 2026 16:53:59 +0100
Message-ID: <araZFy_-gphqMs0G@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-17-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-17-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:55AM -0700, Oliver Upton wrote:
> Everything is in place now to support hardware dirty state management.
> Flip the corresponding bit and advertise the feature to the guest.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 4d128003ae7a..2408d604a1e1 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1790,7 +1790,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>  		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
>  			val &= ~ID_AA64MMFR1_EL1_VH;
>  
> -		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, AF);
> +		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, DBM);
>  		break;
>  
>  	case SYS_ID_AA64MMFR2_EL1:
> -- 
> 2.47.3
> 

LGTM! FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
