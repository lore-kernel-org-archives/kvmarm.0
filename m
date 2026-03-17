Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC6937B002
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 17:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773770063; cv=none; b=dio/d0kSvCmivTtSN+GFrTfjO03z3Rzgimm4qk/zvXd4ZyotUlk0iEVsQ0Nf/I5p/mlb7WOVSklHujWxYHTMgpZPWj1jP7PRPbjgTRYeImqHlctdBUffQM6XaYLhJBzlCeITBrnOHA/cSn989EESeIQTSEC9cf30y6dD0pFp0AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773770063; c=relaxed/simple;
	bh=c7FybBxiVeqSe4aVQ1BJ7MfxPWAAOFXkRgC2wDAFltE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QyFZba5+xgS5X74Jfk1LK6PHj8ztl80bJHzP4HqYREs7pjr4m6yKgycDKY3/LThF+Lgqyd9sPrr2YNf2HjscmIKN0vGfu8EIRqSXxGG6QXjJdT3Rcdx4rh0sxkt8kjFCqfCBqPGHb8z11rFsh6RUUsYcbt2A6ACRAiKDcm2MYIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fb02H1BPZzHnGfG;
	Wed, 18 Mar 2026 01:53:59 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 2155240572;
	Wed, 18 Mar 2026 01:54:19 +0800 (CST)
Received: from localhost (10.48.149.62) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 17 Mar
 2026 17:54:18 +0000
Date: Tue, 17 Mar 2026 17:54:17 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Fuad Tabba <tabba@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, "Joey
 Gouly" <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, "KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64"
	<linux-arm-kernel@lists.infradead.org>, KERNEL VIRTUAL MACHINE FOR ARM64
 KVM/arm64 <kvmarm@lists.linux.dev>, "open list"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] KVM: arm64: Use guard(spinlock) in psci.c
Message-ID: <20260317175417.0000201b@huawei.com>
In-Reply-To: <20260316-tabba-el2_guard-v1-8-456875a2c6db@google.com>
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
	<20260316-tabba-el2_guard-v1-8-456875a2c6db@google.com>
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

On Mon, 16 Mar 2026 17:35:29 +0000
Fuad Tabba <tabba@google.com> wrote:

> Migrate manual spin_lock() and spin_unlock() calls managing
> the vcpu->arch.mp_state_lock to use the guard(spinlock) macro.
> 
> This eliminates manual unlock calls on return paths and simplifies
> error handling during PSCI calls by replacing unlock goto labels
> with direct returns.
> 
> Change-Id: Iaf72da18b18aaec8edff91bc30379bed9dd04b2b
> Signed-off-by: Fuad Tabba <tabba@google.com>


> @@ -176,9 +172,8 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
>  	 * re-initialized.
>  	 */
>  	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> -		spin_lock(&tmp->arch.mp_state_lock);
> -		WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
> -		spin_unlock(&tmp->arch.mp_state_lock);
> +		scoped_guard(spinlock, &tmp->arch.mp_state_lock)
No benefit over guard() and causes more churn.

> +			WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
>  	}
>  	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
>  
> 

