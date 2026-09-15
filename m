Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65E9480947
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 10:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789469286; cv=none; b=hDeeFx1p7xxNb6/PIRCMfYHmFSw8+FbWh0eUsDJnAqEzMsvgabPMisS63sOEXstVs8OxVedsLViIkHLt9lvNEATv+xNnuPd1cnhD/BxO79ICvB9J+NRnplsZuTHsL1aY8SZ7jCM5f5Nv6uc5SDjkeYTzYnU/HIlE2Cikvs6D5QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789469286; c=relaxed/simple;
	bh=brY21PorPsciGcHuNVN5/hjjXSISCVYon+MJGGX8R/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LLB9xxQqlHqN0GWgmcZuzOZW0cNkGFq6+whHTEl29MeTlGBX8p1UqPyshEitULkeOr4OA7EB8auWhF38UXJSUIeLHgaFhVCbtwgrCu5MT5V173iLwddPOPpI9EHyhxHVBDMKz1fATRh0Y4mMyk8A5JS46/zcqXjAPdETTlwCP8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=i002nmcy; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="i002nmcy"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31AD91570;
	Tue, 15 Sep 2026 03:47:59 -0700 (PDT)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D081C3F7B4;
	Tue, 15 Sep 2026 03:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789469282; bh=brY21PorPsciGcHuNVN5/hjjXSISCVYon+MJGGX8R/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i002nmcy+W/6o87jdKBxvVPr5ompRaptkrUIwoJVN0YsKCZq3yEA3vZ3h1YSRkm0n
	 nbXsSZVKReqgQjPKucdtcz6WChsPcMzZ4y86LmCByEvaiWWCCBAeOVFNbmQirN4hDF
	 2NVNWpGXprPVwk+jAfMB6HML5wnEZUw4NpkMTjHY=
Date: Tue, 15 Sep 2026 11:47:58 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	steven.price@arm.com, vdonnefort@google.com, qperret@google.com,
	tabba@google.com
Subject: Re: [PATCH v2 2/2] KVM: arm64: Pin the host vCPU before adjusting
 its PC under pKVM
Message-ID: <aqkiXqjSZyyqHZ5y@e143914.arm.com>
References: <20260915070418.3209779-1-fuad.tabba@linux.dev>
 <20260915070418.3209779-3-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915070418.3209779-3-fuad.tabba@linux.dev>

Hi,

On Tue, Sep 15, 2026 at 08:04:18AM +0100, Fuad Tabba wrote:
> Under pKVM, a page the host shares with EL2 is mapped at EL2 only while
> it's pinned, and the host vCPU is pinned at its first KVM_RUN.
> KVM_SET_VCPU_EVENTS with ext_dabt_pending reaches __kvm_adjust_pc() at
> EL2 before that, and dereferencing the unmapped host vCPU panics the
> hypervisor. Any process holding /dev/kvm on a pKVM host can trigger it.
> 
> Pin the host vCPU around the adjustment when no hyp vCPU is loaded for
> it. A loaded hyp vCPU implies it's pinned. A pin fails only for memory
> the host never shared, and the request is then dropped like any other
> bad host pointer.
> 
> Fixes: efa1368ba9f4b ("KVM: arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 9a3b92e626adb..4cb7347db2514 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -542,8 +542,25 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>  	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	struct kvm_vcpu *host_vcpu;
>  
> -	__kvm_adjust_pc(kern_hyp_va(vcpu));
> +	host_vcpu = __get_host_hyp_vcpus(vcpu, &hyp_vcpu);
> +	if (host_vcpu) {
> +		__kvm_adjust_pc(host_vcpu);
> +		return;
> +	}
> +
> +	/*
> +	 * With no hyp vCPU loaded for it, the host vCPU may be unpinned,
> +	 * and so unmapped at EL2: its first run pins it.

* A pin only fails if the memory was never shared, drop the request if
* it is a bad host pointer.

Or something like the commit message says.

> +	 */
> +	host_vcpu = kern_hyp_va(vcpu);
> +	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
> +		return;
> +
> +	__kvm_adjust_pc(host_vcpu);
> +	hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
>  }
>  
>  static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
