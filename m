Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD0324E4CB
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 10:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742380161; cv=none; b=CGVxLdTlKTQJldMxWjAMtmTVQ5vN014761ruAuAB/XZVLW+eyNUGYev4OQAQLPl7Z4Y8sGOVS/i1pfuw3G6eRT/Ft62gzQzOEDu/ebzhWo2JZvTMMZowmmq9pdACCfcqAQ5h6E646U+5AKy3IxB4KaAqPRxPK+FwFjf9bsKyd5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742380161; c=relaxed/simple;
	bh=qVfF5fC8VPa2jvIi5+vIGvyynDxrHKwWPbHvTNGZ+6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5q4AMo8AAygFK0GTz6br+MkMLz9+Uo+egOjzaLIGmJnc8nA705WTDy1OH52xBg2mf2wZe7A+uchl+vDZ71fgyKZgKgRWJqebdyVWp2DIybWeBKnFghbogxIEu61GfIFaRu5eIQyvmV71FNRmRnyjOucsah6KmQotSSlQS6wino=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B52412FC;
	Wed, 19 Mar 2025 03:29:27 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14C713F694;
	Wed, 19 Mar 2025 03:29:16 -0700 (PDT)
Date: Wed, 19 Mar 2025 10:29:14 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 6.13 8/8] KVM: arm64: Eagerly switch ZCR_EL{1,2}
Message-ID: <Z9qcem7BVeuRd5XD@J2N7QTR9R3>
References: <20250312-stable-sve-6-13-v1-0-c7ba07a6f4f7@kernel.org>
 <20250312-stable-sve-6-13-v1-8-c7ba07a6f4f7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312-stable-sve-6-13-v1-8-c7ba07a6f4f7@kernel.org>

On Wed, Mar 12, 2025 at 11:49:16PM +0000, Mark Brown wrote:
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 7262983c75fbc18ab44f52753bff1dd9167a68d3..84326765c66087d992a517a19fea94b04c39c994 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -5,6 +5,7 @@
>   */
>  
>  #include <hyp/adjust_pc.h>
> +#include <hyp/switch.h>
>  
>  #include <asm/pgtable-types.h>
>  #include <asm/kvm_asm.h>
> @@ -178,8 +179,12 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
>  		sync_hyp_vcpu(hyp_vcpu);
>  		pkvm_put_hyp_vcpu(hyp_vcpu);
>  	} else {
> +		struct kvm_vcpu *vcpu = kern_hyp_va(host_vcpu);
> +
>  		/* The host is fully trusted, run its vCPU directly. */
> -		ret = __kvm_vcpu_run(host_vcpu);
> +		fpsimd_lazy_switch_to_guest(vcpu);
> +		ret = __kvm_vcpu_run(vcpu);
> +		fpsimd_lazy_switch_to_host(vcpu);
>  	}

As Gavin noted [1] for the v6.12 backport, the addition of kern_hyp_va()
is not correct, since 'host_vcpu' has already been converted to a hyp VA
at this point.

[1] https://lore.kernel.org/linux-arm-kernel/019afc2d-b047-4e33-971c-7debbbaec84d@redhat.com/#t

Mark.
