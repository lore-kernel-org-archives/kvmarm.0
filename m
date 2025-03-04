Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AEB024EAA0;
	Tue,  4 Mar 2025 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741111168; cv=none; b=f5h/UaMkg3u96j3YHwctE8WQE7GjAaKm+H/6qBKaPdEc6Z95pzcB5ATezUGnF7u4rStcIDwYhAUpsaPU+mR7iANvVp/O7TMDrBSzjhp6GSsM3F93rx4yxBWQJUFC8eTWGrM3Hk1DyWwvKlE/Yj+E113GlHSDrwLWXfYOayhYA8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741111168; c=relaxed/simple;
	bh=oVD1GE3NzUYwD56omqTkMkV8FxpM5ALoGZ32XZaFoUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mh7d/LNATevCBubYPglKDSabDqlJZ4iAn9d5qpdTN8lMZMZYgUocmjA95aTE6Y4D1nD6XQ10DCgPMG21dkrl1QPbVAWd2BLqkKYse9m1tiw2IEbsKl1U3Qhg3GiglUO2U/2uI6HNtMBZeKxh27DqpTC5/stlsIV1BZURb2v4Zvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23A042F;
	Tue,  4 Mar 2025 09:59:38 -0800 (PST)
Received: from [10.57.39.179] (unknown [10.57.39.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E329B3F5A1;
	Tue,  4 Mar 2025 09:59:20 -0800 (PST)
Message-ID: <d3181dde-1070-4101-a5f7-7e42d0ec2f99@arm.com>
Date: Tue, 4 Mar 2025 17:59:19 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 15/45] KVM: arm64: Support timers in realm RECs
Content-Language: en-GB
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
 <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-16-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250213161426.102987-16-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/02/2025 16:13, Steven Price wrote:
> The RMM keeps track of the timer while the realm REC is running, but on
> exit to the normal world KVM is responsible for handling the timers.
> 
> A later patch adds the support for propagating the timer values from the
> exit data structure and calling kvm_realm_timers_update().
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arch_timer.c  | 45 ++++++++++++++++++++++++++++++++----
>   include/kvm/arm_arch_timer.h |  2 ++
>   2 files changed, 43 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index d3d243366536..06b68bcd244f 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -148,6 +148,13 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
>   
>   static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>   {
> +	struct kvm_vcpu *vcpu = ctxt->vcpu;
> +
> +	if (kvm_is_realm(vcpu->kvm)) {
> +		WARN_ON(offset);
> +		return;
> +	}
> +
>   	if (!ctxt->offset.vm_offset) {
>   		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
>   		return;
> @@ -464,6 +471,21 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>   	}
>   }
>   
> +void kvm_realm_timers_update(struct kvm_vcpu *vcpu)
> +{
> +	struct arch_timer_cpu *arch_timer = &vcpu->arch.timer_cpu;
> +	int i;
> +
> +	for (i = 0; i < NR_KVM_EL0_TIMERS; i++) {
> +		struct arch_timer_context *timer = &arch_timer->timers[i];
> +		bool status = timer_get_ctl(timer) & ARCH_TIMER_CTRL_IT_STAT;
> +		bool level = kvm_timer_irq_can_fire(timer) && status;
> +
> +		if (level != timer->irq.level)
> +			kvm_timer_update_irq(vcpu, level, timer);
> +	}
> +}
> +
>   /* Only called for a fully emulated timer */
>   static void timer_emulate(struct arch_timer_context *ctx)
>   {
> @@ -889,6 +911,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>   	if (unlikely(!timer->enabled))
>   		return;
>   
> +	kvm_timer_unblocking(vcpu);
> +
>   	get_timer_map(vcpu, &map);
>   
>   	if (static_branch_likely(&has_gic_active_state)) {
> @@ -902,8 +926,6 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>   		kvm_timer_vcpu_load_nogic(vcpu);
>   	}
>   
> -	kvm_timer_unblocking(vcpu);
> -
>   	timer_restore_state(map.direct_vtimer);
>   	if (map.direct_ptimer)
>   		timer_restore_state(map.direct_ptimer);
> @@ -1094,7 +1116,9 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>   
>   	ctxt->vcpu = vcpu;
>   
> -	if (timerid == TIMER_VTIMER)
> +	if (kvm_is_realm(vcpu->kvm))
> +		ctxt->offset.vm_offset = NULL;
> +	else if (timerid == TIMER_VTIMER)
>   		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;

I think we need to disable the KVM_CAP_COUNTER_OFFSET for Realms and
also deny KVM_ARM_SET_COUNTER_OFFSET vm_ioctl.

Suzuki


