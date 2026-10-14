Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 186D741A922
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 09:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791968641; cv=none; b=WvGnbBmKYbF9m/0zUdOK+kj1f2DFblcn43BAVgerEx0XZsuHAiML1a+gV4FQNHMXzNXwtusm6uugOhYPU55HZzRM/fz+O9D78AoXs7ruKM4hJDo/rph3tNYxTbmyhP7y06N2s/NaJtwdAzVP6dZGADGhLKlwlC8nFhd5Do89GSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791968641; c=relaxed/simple;
	bh=hCdDlst7bj1m0LOdOKYBlBTkqQdM2UjFhwxu9lQemtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XXukZE2fu+8FoLCu6mUC/w2wYSWilRn2nazz5pSlf+Wmt4jfRby3GcA+ob3hvCzm7dYgh4+TfXYkJml/c3Tqx3/J5l37NGD/2MWM6ld7fQdTB+c3yr+RLtn9E3i1dqRhNCTcKkiXXXFGxo1uoqMJvPrQH+iB0xOSN2o6ZtngHd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ijVPr1gs; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ijVPr1gs"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5276C1596;
	Wed, 14 Oct 2026 02:03:55 -0700 (PDT)
Received: from [10.57.9.28] (unknown [10.57.9.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5E273F7B4;
	Wed, 14 Oct 2026 02:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791968638; bh=hCdDlst7bj1m0LOdOKYBlBTkqQdM2UjFhwxu9lQemtI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ijVPr1gskGK9HqirlaUq87YsLpFcaxA4i/EGXPaCKbl9LjDy7uu+ifwdQVGlFeD+9
	 Y2p6nkbHGsvQZt2dvb6riWzfilwHBhBwP4eRJ+gzMS5alvMK4sPXfd17yo3loVrSse
	 pYMoURvmQ0LrEhinDltBP44DkzenKF4KytnDpRV4=
Message-ID: <bd9c0add-8317-4aa9-bb8b-479efbf3164f@arm.com>
Date: Wed, 14 Oct 2026 10:03:55 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: arm64: Don't WARN on SMCCC filter reserved range
 allocation failure
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org
References: <20261013164334.1492070-1-fuad.tabba@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261013164334.1492070-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/10/2026 17:43, Fuad Tabba wrote:
> The first time userspace sets an SMCCC filter, kvm_smccc_set_filter()
> inserts the reserved architecture ranges into the maple tree and WARNs
> if that fails. The insertion allocates with GFP_KERNEL_ACCOUNT, so a
> tight memory cgroup limit is enough for userspace to hit the WARN, even
> though the -ENOMEM is also returned to it. The WARN dates back to when
> the ranges were inserted at VM creation.
> 
> Leave -ENOMEM out of the WARN and keep it for every other error. The
> two reserved ranges are fixed and disjoint and go into an empty tree
> under config_lock, so any other error is a KVM bug.
> 
> Fixes: fb88707dd39bd ("KVM: arm64: Use a maple tree to represent the SMCCC filter")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/20260829055809.29AD31F000E9@smtp.kernel.org/
> Suggested-by: Oliver Upton <oupton@kernel.org>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
> Changes since v1 [1]:
>    - Keep the WARN for any error other than -ENOMEM. (Oliver)
>    - Split out of v1 as its own patch. (Marc)
> 
> Based on Linux 7.3-rc3 (fd73f4a665989).
> 
> [1] https://lore.kernel.org/all/20260928152507.2116110-2-fuad.tabba@linux.dev/
> 
>   arch/arm64/kvm/hypercalls.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index b11b8821c9fbc..c9d488c586e5f 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -197,8 +197,10 @@ static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user
>   
>   	if (!kvm_smccc_filter_configured(kvm)) {
>   		r = kvm_smccc_filter_insert_reserved(kvm);
> -		if (WARN_ON_ONCE(r))
> +		if (r) {
> +			WARN_ON_ONCE(r != -ENOMEM);
>   			goto out_unlock;
> +		}
>   	}
>   
>   	r = mtree_insert_range(&kvm->arch.smccc_filter, start, end,
> 
> base-commit: fd73f4a6659897191fa0d40695fe370925dd3780

