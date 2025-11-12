Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AFB72264B8
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 09:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762940385; cv=none; b=FTJxSaLOCoLkYC6joGBgqSm74xVBRTyo7m1bgmvX/oYCwIVUqG5CBpi5kiUxm3gpAuHWa78HVIhvshBY1Jkibu5jEoyjHQPSfwClKM6XdzeAh7e8ASTVgzRLMIux1LTcP8ZZH75Q2/53AKwvVbsyTPXNGqmZnysYIR8nisgwYxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762940385; c=relaxed/simple;
	bh=Zwnrqa+yxv5RwlUmajy89qZa8LeC6PgamAyJWYF2zfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oCNpZJtOzAKmGpHcH5ZpM/RFxQQAlrE/5Sn9qNRxFXuKGXvRwaOJMvXaQ3fJuF3dCxonrwFictgmzDgCn4vdWV2S+vPQ8b9o638dok49fd9m5watL6s2kaqS4QN7JdId785/i8ufT88MJAzrZjgvcYs3FDvWAp3XfOvd7JttQ30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8139B1515;
	Wed, 12 Nov 2025 01:39:29 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF8CE3F66E;
	Wed, 12 Nov 2025 01:39:35 -0800 (PST)
Message-ID: <ac271094-97f5-49d1-85cf-4450e60d44b2@arm.com>
Date: Wed, 12 Nov 2025 09:39:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/8] KVM: arm64: Fix MTE flag initialization for
 protected VMs
To: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, vladimir.murzin@arm.com
References: <20251112092051.1376245-1-tabba@google.com>
 <20251112092051.1376245-4-tabba@google.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20251112092051.1376245-4-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 11/12/25 09:20, Fuad Tabba wrote:
> The function pkvm_init_features_from_host() initializes guest
> features, propagating them from the host. The logic to propagate
> KVM_ARCH_FLAG_MTE_ENABLED (Memory Tagging Extension)
> has a couple of issues.
> 
> First, the check was in the common path, before the divergence for
> protected and non-protected VMs. For non-protected VMs, this was
> unnecessary, as 'kvm->arch.flags' is completely overwritten by
> host_arch_flags immediately after, which already contains the MTE flag.
> For protected VMs, this was setting the flag even if the feature is not
> allowed.
> 
> Second, the check was reading 'host_kvm->arch.flags' instead of using
> the local 'host_arch_flags', which is read once from the host flags.
> 
> Fix these by moving the MTE flag check inside the protected-VM-only
> path, checking if the feature is allowed, and changing it to use the
> correct host_arch_flags local variable. This ensures non-protected VMs
> get the flag via the bulk copy, and protected VMs get it via an explicit
> check.
> 
> Fixes: b7f345fbc32a ("KVM: arm64: Fix FEAT_MTE in pKVM")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

LGTM

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben

