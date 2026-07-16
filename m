Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90AAD40A95E;
	Thu, 16 Jul 2026 10:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784197342; cv=none; b=CxTlBxus522CNI5VqMbzvXp/YZTWw7fssJik6QSoP7/ZRQtvJ6s7PcjpdH+1DGuknqzTdC7eVW7lEoIwji6xG41zYBV3c2FCIJ9Y7rZIOUhxPvMLJUcDFP4YIfMA2kNrl7SxH+9iGM2oG1h/zkvQ8eT4EkPulzy0msv+QgfPUGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784197342; c=relaxed/simple;
	bh=en5X+Gmc8TvyimGGC5fjEFfAJUjSA+Q3WgnPuRiMC4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aOmaGvPQ/ZrH6UpSIs5ZI+RgoKpEvA49a2vR0snAZeIRLWhT3IeNrMkBrHmILDA4NOftt1ZsdKaOxZKljBNfzDmUlsPrUpM2pIJ5MCJfcn5fwRSYNQv9xlGSRheKLiXu7+n4fXUbphVZmsjo8D+jsbmAN+K/vypC48yxbZ/s9kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qVHlpNKj; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qVHlpNKj"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C229E2F;
	Thu, 16 Jul 2026 03:22:15 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D5CE3F7B4;
	Thu, 16 Jul 2026 03:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784197339; bh=en5X+Gmc8TvyimGGC5fjEFfAJUjSA+Q3WgnPuRiMC4o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qVHlpNKjhvKn3xQ+CNDb0jNA6crT5j1kcZIOGpapBhTks1C9/NkDV1ed8MvKjQNsD
	 Lq0haMITs7kx1z9rHbbn4orzHSIACc33v0EXF5UvcU3sHl4iOaS8PJHMeqR4Od64ak
	 eZpHu80hfxd7/rjOWxIrT1OkCvVZrEPQOpALUZkU=
Message-ID: <96dbe4f6-a425-4118-afb8-56361e04263b@arm.com>
Date: Thu, 16 Jul 2026 11:22:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 28/37] KVM: arm64: CCA: Support RSI_HOST_CALL
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-29-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260715142841.80544-29-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/07/2026 15:28, Steven Price wrote:
> From: Joey Gouly <joey.gouly@arm.com>
> 
> Realm VMs can talk to the hypervisor using the RSI_HOST_CALL SMC. The
> RMM forwards this to the host and KVM handles them as regular
> hypercalls.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> ---

minor nit: Populating the results back to the Realm is added in the 
Patch 14: KVM: arm64: CCA: Handle realm enter/exit

May be a good idea to move to this one here ?

Either ways:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> Changes since v7:
>   * Avoid turning a negative return from kvm_smccc_call_handler() into a
>     error response to the guest. Instead propagate the error back to user
>     space.
> Changes since v4:
>   * Setting GPRS is now done by kvm_rec_enter() rather than
>     rec_exit_host_call() (see previous patch - arm64: RME: Handle realm
>     enter/exit). This fixes a bug where the registers set by user space
>     were being ignored.
> ---
>   arch/arm64/kvm/rmi-exit.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
> index c668cbfa971a..78d9189fd5ca 100644
> --- a/arch/arm64/kvm/rmi-exit.c
> +++ b/arch/arm64/kvm/rmi-exit.c
> @@ -113,6 +113,19 @@ static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
>   	return -EFAULT;
>   }
>   
> +static int rec_exit_host_call(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +
> +	vcpu->stat.hvc_exit_stat++;
> +
> +	for (i = 0; i < REC_RUN_GPRS; i++)
> +		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
> +
> +	return kvm_smccc_call_handler(vcpu);
> +}
> +
>   static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
>   {
>   	struct realm_rec *rec = &vcpu->arch.rec;
> @@ -188,6 +201,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
>   		return rec_exit_psci(vcpu);
>   	case RMI_EXIT_RIPAS_CHANGE:
>   		return rec_exit_ripas_change(vcpu);
> +	case RMI_EXIT_HOST_CALL:
> +		return rec_exit_host_call(vcpu);
>   	}
>   
>   	kvm_pr_unimpl("Unsupported exit reason: %u\n",

