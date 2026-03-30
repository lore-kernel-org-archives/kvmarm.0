Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E47F2FFFB5;
	Mon, 30 Mar 2026 10:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774866979; cv=none; b=TYtWl4fPa9kbzXbv+w6jcFipdOmylZIQLtEkmRo3HEE2FBI8Ql5HDuuYFbveoZCzxzC5rQ25e2oCWK0dfZGDoAV3akx+LkjeaNAxJICPTc5dTaqH33zd4OG6NPK03WfmMMgBCxWhXktVC9gsjYp4778bR10Dxb/cGcwKs25oIQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774866979; c=relaxed/simple;
	bh=jz2gi11NiG/KZMld4u+nIsujltktGVyGRcWg97yjGS0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=r6cSxc5D1fbrLd72puTDW5iygL2FnWnvEvF8ZB0/n5pDH9db/HCf35TspR1xampBCdocU7dKu00fPZSUBc4fmN5NwzkD/A0KwAtCZMsqVk6qnct4cjJ5ax3wfFaBQe3b3UF9+R2LZ7zHdr9MP2D/APJ5kQNLkbFEShHPyNcZCbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZVn46wu2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZVn46wu2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C50A1684;
	Mon, 30 Mar 2026 03:36:11 -0700 (PDT)
Received: from [10.57.13.56] (unknown [10.57.13.56])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B9B03F915;
	Mon, 30 Mar 2026 03:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774866977; bh=jz2gi11NiG/KZMld4u+nIsujltktGVyGRcWg97yjGS0=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=ZVn46wu2i0+k6UlKc80S1S6R1+BCanT5RW1OehNARboz2md1u1ESA54kYJcVM8fBY
	 ru8ufmp1ujB0annXg4MAPeQhzK9RROmf01Ve0Ua31mnUjJcUxFQL236bmdNf52m0M+
	 JJcgTQyjFMTTQ5Snfcr4hbVwbu765iwiOSlaGI9I=
Message-ID: <9bf7ad5a-9a07-4150-9dbb-c3cf7cac0cb7@arm.com>
Date: Mon, 30 Mar 2026 11:36:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v13 30/48] KVM: arm64: Handle Realm PSCI requests
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-31-steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20260318155413.793430-31-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/03/2026 15:53, Steven Price wrote:
> The RMM needs to be informed of the target REC when a PSCI call is made
> with an MPIDR argument. Expose an ioctl to the userspace in case the PSCI
> is handled by it.
> 
> [NOTE: A future version of the RMM specification is likely to remove the
> need for this ioctl.]

This will need to stay for the PSCI_CPU_ON case, where the host has to
acknowledge the onlining of a vCPU.

> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>

For the record, we can drop the UAPI following our discussions and 
implicitly do the PSCI complete before REC_ENTER, similar to what
we do for the SET_RIPAS request. The VMM/KVM can treat the case
as a normal PSCI_CPU_ON request and return the result as in normal
VMs.

The target REC may ENTER before we complete the reporting, but we can
handle this error case (RMI_ERROR_REC) and return -EAGAIN to the
userspace.

Suzuki


> ---
> Changes since v12:
>   * Chance return code for non-realms to -ENXIO to better represent that
>     the ioctl is invalid for non-realms (checkpatch is insistent that
>     "ENOSYS means 'invalid syscall nr' and nothing else").
> Changes since v11:
>   * RMM->RMI renaming.
> Changes since v6:
>   * Use vcpu_is_rec() rather than kvm_is_realm(vcpu->kvm).
>   * Minor renaming/formatting fixes.
> ---
>   arch/arm64/include/asm/kvm_rmi.h |  3 +++
>   arch/arm64/kvm/arm.c             | 25 +++++++++++++++++++++++++
>   arch/arm64/kvm/psci.c            | 30 ++++++++++++++++++++++++++++++
>   arch/arm64/kvm/rmi.c             | 14 ++++++++++++++
>   4 files changed, 72 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index 38208be3c602..1ee5ed0f5ab2 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -117,6 +117,9 @@ int realm_map_non_secure(struct realm *realm,
>   			 unsigned long size,
>   			 enum kvm_pgtable_prot prot,
>   			 struct kvm_mmu_memory_cache *memcache);
> +int realm_psci_complete(struct kvm_vcpu *source,
> +			struct kvm_vcpu *target,
> +			unsigned long status);
>   
>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>   						unsigned long addr)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 304fb1f2b3ff..61182eb0cf70 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1846,6 +1846,22 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>   	return __kvm_arm_vcpu_set_events(vcpu, events);
>   }
>   
> +static int kvm_arm_vcpu_rmi_psci_complete(struct kvm_vcpu *vcpu,
> +					  struct kvm_arm_rmi_psci_complete *arg)
> +{
> +	struct kvm_vcpu *target = kvm_mpidr_to_vcpu(vcpu->kvm, arg->target_mpidr);
> +
> +	if (!target)
> +		return -EINVAL;
> +
> +	/*
> +	 * RMM v1.0 only supports PSCI_RET_SUCCESS or PSCI_RET_DENIED
> +	 * for the status. But, let us leave it to the RMM to filter
> +	 * for making this future proof.
> +	 */
> +	return realm_psci_complete(vcpu, target, arg->psci_status);
> +}
> +
>   long kvm_arch_vcpu_ioctl(struct file *filp,
>   			 unsigned int ioctl, unsigned long arg)
>   {
> @@ -1974,6 +1990,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   
>   		return kvm_arm_vcpu_finalize(vcpu, what);
>   	}
> +	case KVM_ARM_VCPU_RMI_PSCI_COMPLETE: {
> +		struct kvm_arm_rmi_psci_complete req;
> +
> +		if (!vcpu_is_rec(vcpu))
> +			return -ENXIO;
> +		if (copy_from_user(&req, argp, sizeof(req)))
> +			return -EFAULT;
> +		return kvm_arm_vcpu_rmi_psci_complete(vcpu, &req);
> +	}
>   	default:
>   		r = -EINVAL;
>   	}
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 3b5dbe9a0a0e..a68f3c1878a5 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -103,6 +103,12 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>   
>   	reset_state->reset = true;
>   	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> +	/*
> +	 * Make sure we issue PSCI_COMPLETE before the VCPU can be
> +	 * scheduled.
> +	 */
> +	if (vcpu_is_rec(vcpu))
> +		realm_psci_complete(source_vcpu, vcpu, PSCI_RET_SUCCESS);
>   
>   	/*
>   	 * Make sure the reset request is observed if the RUNNABLE mp_state is
> @@ -115,6 +121,11 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>   
>   out_unlock:
>   	spin_unlock(&vcpu->arch.mp_state_lock);
> +	if (vcpu_is_rec(vcpu) && ret != PSCI_RET_SUCCESS) {
> +		realm_psci_complete(source_vcpu, vcpu,
> +				    ret == PSCI_RET_ALREADY_ON ?
> +				    PSCI_RET_SUCCESS : PSCI_RET_DENIED);
> +	}
>   	return ret;
>   }
>   
> @@ -142,6 +153,25 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>   	/* Ignore other bits of target affinity */
>   	target_affinity &= target_affinity_mask;
>   
> +	if (vcpu_is_rec(vcpu)) {
> +		struct kvm_vcpu *target_vcpu;
> +
> +		/* RMM supports only zero affinity level */
> +		if (lowest_affinity_level != 0)
> +			return PSCI_RET_INVALID_PARAMS;
> +
> +		target_vcpu = kvm_mpidr_to_vcpu(kvm, target_affinity);
> +		if (!target_vcpu)
> +			return PSCI_RET_INVALID_PARAMS;
> +
> +		/*
> +		 * Provide the references of the source and target RECs to the
> +		 * RMM so that the RMM can complete the PSCI request.
> +		 */
> +		realm_psci_complete(vcpu, target_vcpu, PSCI_RET_SUCCESS);
> +		return PSCI_RET_SUCCESS;
> +	}
> +
>   	/*
>   	 * If one or more VCPU matching target affinity are running
>   	 * then ON else OFF
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 30292814b1ec..e56c8af2ad61 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -353,6 +353,20 @@ static void free_rtt(phys_addr_t phys)
>   	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>   }
>   
> +int realm_psci_complete(struct kvm_vcpu *source, struct kvm_vcpu *target,
> +			unsigned long status)
> +{
> +	int ret;
> +
> +	ret = rmi_psci_complete(virt_to_phys(source->arch.rec.rec_page),
> +				virt_to_phys(target->arch.rec.rec_page),
> +				status);
> +	if (ret)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>   static int realm_rtt_create(struct realm *realm,
>   			    unsigned long addr,
>   			    int level,

