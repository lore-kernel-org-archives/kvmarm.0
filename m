Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F71470E80
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 10:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789467479; cv=none; b=i0kDEKv6NPJlAthMJ6BIxzssGxohUQkBiujBuDlYdBV3vhgTkFZO0/1q+IX2rRrtWSwSutyLZXAT1FSGSskM03PVk9vVh8llFgi9Vdzr0szrKxmkRxjBKGnOTydmnn20YqhazSmA5b9nmSpqDzywgGfnjwvZjrcmCI/7ZqkJLrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789467479; c=relaxed/simple;
	bh=P4PqmTwHRDzYg7hMT1E2FJIJY8F1LWd3zY+fMsfPU7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6R7uxiK97PyZsKwBPJi0AI6BuZv1ovU2e8zrZlV2qUKO6nuasvW7Z4vI1I8LpNKg1YWg3gTmOWtuwsYhtKaQiZuwtmpsjTAjf7F7xYJ1Xkb6Xyobey0u2/xWBF3T9q5xA5SF/vQ6I0f+XjWCaG/ZdcCUCv3WaeJIiO5gyZ71S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S/hml+qL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S/hml+qL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31F011570;
	Tue, 15 Sep 2026 03:17:52 -0700 (PDT)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70FB13F7B4;
	Tue, 15 Sep 2026 03:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789467475; bh=P4PqmTwHRDzYg7hMT1E2FJIJY8F1LWd3zY+fMsfPU7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S/hml+qLVnuLeH/JBLdhCpUUwqMM+oYk4IvEwrtZfj4AgvWOtNRZ2Ax30mwEwVj2z
	 1FWGSE7jMgPg/AoG53rg+phueBRKiPf8uF7Cr4xRN1L65L15Qsuu5GODmGiMnBbn7o
	 +X+/czrB57fCcCQgKPPEpQvPqOXiqYaTSsbBHfgo=
Date: Tue, 15 Sep 2026 11:17:47 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	steven.price@arm.com, vdonnefort@google.com, qperret@google.com,
	tabba@google.com
Subject: Re: [PATCH v2 1/2] KVM: arm64: Validate the host vCPU's VM before
 reading it under pKVM
Message-ID: <aqkbS810aDLyfS7D@e143914.arm.com>
References: <20260915070418.3209779-1-fuad.tabba@linux.dev>
 <20260915070418.3209779-2-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915070418.3209779-2-fuad.tabba@linux.dev>

Hi,

On Tue, Sep 15, 2026 at 08:04:17AM +0100, Fuad Tabba wrote:
> On an MTE-capable host under pKVM, enter_exception64() reads the VM's
> MTE flag through vcpu->kvm, which for a host vCPU is a host-writable
> pointer nothing validates. The host can point it at any address in the
> hyp linear map and read back bit 1 of that word through PSR_TCO in the
> vCPU's CPSR, or panic the hypervisor with an unmapped one.
> 
> Get the VM through a get/put pair around the read: a loaded vCPU's is
> the hyp VM, an unloaded host vCPU's is read once and pinned, and a
> pointer the host never shared leaves TCO clear.
> 
> Fixes: ea7fc1bb1cd1b ("KVM: arm64: Introduce MTE VM feature")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/20260914070536.877D91F000FF@smtp.kernel.org/
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/hyp/exception.c             |  5 ++-
>  arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 18 ++++++++++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c             | 39 ++++++++++++++++++++++
>  3 files changed, 61 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
> index 754e2dc1df54a..6e60d890afa4a 100644
> --- a/arch/arm64/kvm/hyp/exception.c
> +++ b/arch/arm64/kvm/hyp/exception.c
> @@ -70,6 +70,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>  			      enum exception_type type)
>  {
>  	unsigned long sctlr, vbar, old, new, mode;
> +	struct kvm *kvm;
>  	u64 exc_offset;
>  
>  	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
> @@ -109,8 +110,10 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
>  	new |= (old & PSR_C_BIT);
>  	new |= (old & PSR_V_BIT);
>  
> -	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
> +	kvm = vcpu_get_kvm(vcpu);
> +	if (kvm && kvm_has_mte(kvm))

It's fine to use the "host->kvm" here because even if sets this bit on
the host vCPU, the per-entry handlers in the other series won't copy
across the TCO bit.
Right?

>  		new |= PSR_TCO_BIT;
> +	vcpu_put_kvm(vcpu, kvm);
>  
>  	new |= (old & PSR_DIT_BIT);
>  

[snip]

Agree with the nits that Vincent suggested!

Let's see if this sticks this time:
Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
