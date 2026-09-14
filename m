Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA09541A93A
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 09:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789378979; cv=none; b=HVb3OUAT+zRDjze4nsBfr+cHxeshkzoDA6lamw1eE+plxXDEOyUoKwuh6+bXVTWpfzNbTgGKRcJA0wJTaktuxdOdRHCyvvSmpOCYhEgef3Wt7y6IgiAaFUijO5rtTs1lVLfzyRaj3bz/JQYJhzRR4mdMXWITdzi0oCIGChTWYYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789378979; c=relaxed/simple;
	bh=Xg4bUL7yzEXMUEjQqIolCpCM3xjY/H/uXxIijcBMiTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m7bFOyavQ4g9f+ve3vXLdrudpjDMFdZQUslDrLgrnfqbKtDekFrJmrwTsnnuVwSm2zwb+d80Aa/kl2VuBFOPsynddDOImUPZ4eLgZwd4601eRdxg1ym6KUTBQov6LTfa6ADj6eAhKjOI0hSWjSr8bnb4fXgSgWLZ63UtmFIdZmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BgTCe4ze; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BgTCe4ze"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D230152B;
	Mon, 14 Sep 2026 02:42:53 -0700 (PDT)
Received: from [10.0.128.139] (unknown [10.0.128.139])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6831F3F59E;
	Mon, 14 Sep 2026 02:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789378977; bh=Xg4bUL7yzEXMUEjQqIolCpCM3xjY/H/uXxIijcBMiTE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BgTCe4zeLwNWaya0LVmV+TiodXsEebvsIa8e9wyJC/d5MUM3UYdPN0S5TN2XlTVOZ
	 WfPOHyz2V2YkVR5SUDRxLNS19QDHeDRnfnD4UeE3/9mgpwOKsW5nCVrMo4sebjEOaJ
	 DFEY9QOAilgH359pCY5ZZnd4hKEW2KvjJfCbFzIk=
Message-ID: <979a2e1a-eebb-46c2-9cb4-d65428ebaeb8@arm.com>
Date: Mon, 14 Sep 2026 10:42:53 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Don't WARN on an unknown VM ioctl in
 protected mode
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260914093838.1082637-1-fuad.tabba@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260914093838.1082637-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/09/2026 10:38, Fuad Tabba wrote:
> kvm_pkvm_ioctl_allowed() WARNs when kvm_get_cap_for_kvm_ioctl() doesn't
> find the ioctl number in vm_ioctl_caps[], and kvm_arch_vm_ioctl() calls
> it for every number the generic code doesn't handle, so
> ioctl(vm_fd, 0xdeadbeef) from userspace taints a pKVM host and panics it
> under panic_on_warn. The lookup is fed userspace input: return false,
> and userspace gets the -EINVAL kvm_arch_vm_ioctl() returns for that
> number on a host without pKVM.
> 
> Fixes: b12b3b04f6ba0 ("KVM: arm64: Check whether a VM IOCTL is allowed in pKVM")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

I hit this myself ;-) and had a patch in my series. Thanks for posting
this

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> ---
>   arch/arm64/include/asm/kvm_pkvm.h | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index beea00e693a0a..cad60569f0619 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -65,8 +65,7 @@ static inline bool kvm_pkvm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
>   	int r;
>   
>   	r = kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
> -
> -	if (WARN_ON_ONCE(r < 0))
> +	if (r < 0)
>   		return false;
>   
>   	return kvm_pkvm_ext_allowed(kvm, ext);

