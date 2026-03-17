Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1836D332628
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 17:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773770015; cv=none; b=qv7gMRauPLKDmAM5rRFcLp+8mthp4uLu1pPs+/rHDCyMKzpOO9RqfgkIVilnhR5fOWImL5fK+DcH4a1LkjjKoslz3NaLtg0DA18ECTn5m7AYQvrhL/cZmiLhIA5z3I6a0U1nyVutBYuiV2aXI77QyaNZcjepIcGou+iAObZ7F14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773770015; c=relaxed/simple;
	bh=JZoWwvwmBlGT4+GRNq7uIUdHPKbTnuOOMcvemPtlZdI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HduPZCz4PZsYVHm/NRm4nASTosAJuF5bFm2Zf9jSY69DqKr4P8ZUcOh7EIyoQDZzwoi6nqUeTyl+qeHYuVX55Xhwwyg0qydFbTCIRYSaK++ASxGNLBgyGzWLaBYYJ/HuKg9yCgGhsnn+M6U38VoGgbUaLL3up04/HBLcY+isKUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fb00b4Bj3zJ46DJ;
	Wed, 18 Mar 2026 01:52:31 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 0833040584;
	Wed, 18 Mar 2026 01:53:28 +0800 (CST)
Received: from localhost (10.48.149.62) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 17 Mar
 2026 17:53:27 +0000
Date: Tue, 17 Mar 2026 17:53:26 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Fuad Tabba <tabba@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, "Joey
 Gouly" <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, "KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64"
	<linux-arm-kernel@lists.infradead.org>, KERNEL VIRTUAL MACHINE FOR ARM64
 KVM/arm64 <kvmarm@lists.linux.dev>, "open list"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] KVM: arm64: Use scoped resource management in
 arm.c
Message-ID: <20260317175326.000074be@huawei.com>
In-Reply-To: <20260316-tabba-el2_guard-v1-7-456875a2c6db@google.com>
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
	<20260316-tabba-el2_guard-v1-7-456875a2c6db@google.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Mon, 16 Mar 2026 17:35:28 +0000
Fuad Tabba <tabba@google.com> wrote:

> Migrate manual spin_lock() calls managing mp_state_lock and manual
> mutex_lock() calls managing kvm->arch.config_lock to use the
> guard(spinlock) and guard(mutex) macros.
> 
> This eliminates manual unlock calls on early return paths and
> simplifies the vCPU suspend/resume control flow.
> 
> Change-Id: Ifcd8455d08afa5d00fc200daaa3fb13f6736e6ed
> Signed-off-by: Fuad Tabba <tabba@google.com>
Trivial stuff.
> ---
>  arch/arm64/kvm/arm.c | 53 ++++++++++++++++++++--------------------------------
>  1 file changed, 20 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 410ffd41fd73..017f5bfabe19 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c

>  
>  /**
> @@ -738,9 +736,8 @@ static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
>  
>  void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
>  {
> -	spin_lock(&vcpu->arch.mp_state_lock);
> +	guard(spinlock)(&vcpu->arch.mp_state_lock);
>  	__kvm_arm_vcpu_power_off(vcpu);
> -	spin_unlock(&vcpu->arch.mp_state_lock);
>  }
>  
>  bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
> @@ -773,7 +770,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  {
>  	int ret = 0;
>  
> -	spin_lock(&vcpu->arch.mp_state_lock);
> +	guard(spinlock)(&vcpu->arch.mp_state_lock);
>  
>  	switch (mp_state->mp_state) {
>  	case KVM_MP_STATE_RUNNABLE:
> @@ -789,8 +786,6 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  		ret = -EINVAL;
		return -EINVAL;
	}

	return 0;

Or even return in the switch legs instead of breaking out.

>  	}
>  
> -	spin_unlock(&vcpu->arch.mp_state_lock);
> -
>  	return ret;
>  }

>  /*
> @@ -944,9 +937,8 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  			return ret;
>  	}
>  
> -	mutex_lock(&kvm->arch.config_lock);
> +	guard(mutex)(&kvm->arch.config_lock);
>  	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
> -	mutex_unlock(&kvm->arch.config_lock);
>  
>  	return ret;

Personally I'd make this return 0 whilst you are here so it's obvious this
path only ever returns success.

>  }


