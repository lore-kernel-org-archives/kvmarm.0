Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C643C1EF096
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 21:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741814606; cv=none; b=kbFDFsZXxl26L+YrXeXIpVM6gnH1tAtiZ6kVQCNRyvoBCi2vLdI1PNcbYYIPdL3l1GzPKptRIHHto9TEuo6HssP5qH9ZzCXoxm8UBCw8kAqQ3mjoq94ZSpXzuPBNfon03CVIY8Ets2CPd7KVoj+WWWlb8oaZV6B5ub+pegudzVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741814606; c=relaxed/simple;
	bh=2m2bVFSu5ILkd+xnMLHcPH3KQqSjmXv4J+SuPqMNwwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EgL1e4zyJi9mwH4GwJyJoJVptIkSvoQJZZcqKrzDQrPbDME3xMSoJF4G5E+dwxDCWbE9xZrCKQOAbSSTbQnmk3VOjuwpk9joe9NsFXjqxhEW7fzrE/FXxXa2+Jru9Y8XZAFGeONTuzp/GTobOK9JZv84bFZA80diN2xQHnRvapw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TtVPrJCZ; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TtVPrJCZ"
Date: Wed, 12 Mar 2025 14:23:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741814602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nDTuzwNOrfnRWzb35HLSmzXt08GEKPQgr4fYc5Z/ZD4=;
	b=TtVPrJCZGys80899AIs26b1+F9CgqiQotdcfYeWFwylBeD++8Wl5es4XbkJ2ve2pvh4JEx
	BnqZEhXeqdU2VXDiiP1Jz0CsyTJHB40ppG97regrCRFek3z/LJkIDyJgN0DecQsGYmbaAi
	p57J3CTrLudNMoOntMTJlWajGndLhNk=
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
Subject: Re: [PATCH v3 6/6] KVM: arm64: Reload PMCNTENSET_EL0
Message-ID: <Z9H7RYEI_cPwNe7h@linux.dev>
References: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
 <20250312-pmc-v3-6-0411cab5dc3d@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312-pmc-v3-6-0411cab5dc3d@daynix.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 12, 2025 at 08:56:00PM +0900, Akihiko Odaki wrote:
> Disable counters that are no longer included in PMCNTENSET_EL0. It is
> not necessary to enable counters included in PMCNTENSET_EL0 because
> kvm_pmu_handle_pmcr() does so if appropriate.
> 
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  arch/arm64/kvm/pmu-emul.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 2d19c6048091..b14655dda6db 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -831,6 +831,8 @@ void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
>  {
>  	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
>  
> +	kvm_pmu_disable_counter_mask(vcpu, ~__vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
> +

Just so this function appears consistent, can we move this after the
point where the mask is applied?

There's no functional impact of course since PMCR_EL0.N can only be
changed before the VM is started, i.e. not possible to have running
counters >= N.

Thanks,
Oliver
