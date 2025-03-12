Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A671EE00F
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 21:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741814300; cv=none; b=oUqFqBhzK3cTOag7pEcIJV/j04vwzSTuTfRWhe4Jwq6utQVAe21pA4Gac2m5iIZ/oEU/7bRfPPgxCd77LqfO7KTcqh63SBHWZZAKTYCbsrJkd3KHR2ll5RqDjKOetRMWfQVfbeooV+POFxkAMYQ8Gbep245nwIbl7hPopha5pS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741814300; c=relaxed/simple;
	bh=PtjexfcFdoeu/5qbU0udRLgm8sY5gNlZZs0MGmbeEeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QeUSJ+OOqICw+BqaWNfYqxIM6otTLzeUI7YCjZSluSbygrd4DG8z0R+0bp09fG0nlLUW+TfomCT8vYDBGHmnxii7QGvLK3tM0Ydsg2unTpGPkhWeHglA+i6aa1ltVZvPCEYAFMArdevFoR1AX7U5CP9Mj9OSCWATOzDVwoESKyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gqGnRc88; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gqGnRc88"
Date: Wed, 12 Mar 2025 14:18:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741814287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N3AyGAijYqYgOgHQR7L9d8btXgT+uidlAsKc8Qo2ewk=;
	b=gqGnRc88hux9lbrnVxYQRdyKyDt4MJa18YG4n8yivznQI2fZptvDXvQakLM+ZAi8JSenHg
	bNWcugfm8kRNaWtNMSwYnVZTwpCDVCfQ6T4hcRsXy95beKjTfNbM8667Vbc8Rnhv3A5DxX
	TwENYecYloS9cQ+jbcLLnF5fTA1hqBk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Andrew Jones <drjones@redhat.com>,
	Shannon Zhao <shannon.zhao@linaro.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, devel@daynix.com
Subject: Re: [PATCH v3 4/6] KVM: arm64: PMU: Reload when user modifies
 registers
Message-ID: <Z9H6CWz1Z_v7DxvI@linux.dev>
References: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
 <20250312-pmc-v3-4-0411cab5dc3d@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312-pmc-v3-4-0411cab5dc3d@daynix.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 12, 2025 at 08:55:58PM +0900, Akihiko Odaki wrote:
> Commit d0c94c49792c ("KVM: arm64: Restore PMU configuration on first
> run") added the code to reload the PMU configuration on first run.
> 
> It is also important to keep the correct state even if system registers
> are modified after first run, specifically when debugging Windows on
> QEMU with GDB; QEMU tries to write back all visible registers when
> resuming the VM execution with GDB, corrupting the PMU state. Windows
> always uses the PMU so this can cause adverse effects on that particular
> OS.
> 
> The usual register writes are already handled independently, but
> register writes from userspace and ones for reset are not covered.

Ah -- that explains why you're moving the KVM_REQ_RELOAD_PMU from
kvm_arm_pmuv3_enable().

> @@ -4259,6 +4262,9 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>  	}
>  
>  	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
> +
> +	if (kvm_vcpu_has_pmu(vcpu))
> +		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);

nitpick, but maybe this can be added to kvm_pmu_vcpu_reset() instead.

Thanks,
Oliver
