Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE0F306764
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 03:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788320507; cv=none; b=ghVTV084YTnJgN0/ovIJDd3wJ3FTIgVeK6iSBznkNl14LhR9S8UVrF/lKteetMLXgVb/qnpPq1ci2RtKyPlcbZjVT4e09YIlPhTqpvLnfaMZR8w78l67FvuiR3rbVVPUSjQ/3ZpGKp4SqJpB0lNyTPi348315YBT2lvF6Zjswrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788320507; c=relaxed/simple;
	bh=WAqfUmRYWN7fsydH4ejT9o5RephmRbQCv1dvnXIQrpk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BrYgP0NSF3MXCIi8uC2DcFjzULwm9aZ6s7vBqGG5X0JHXuuVONBwTkJ0bpxB31Ags3Tg4yVwpAR/2teK6e2XqMiAKYcdT2ZpPg3Cy2HceKxjJTRqL0U/Z9/i5shE2sdLjzXJlFLKXYqzFIYW3BVwOeC0CBLtu9p7q52anL2tGIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=apudg3fM; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="apudg3fM"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Y5qp/1tLbmRpVusogjo+SBt+4hrWyvtZXYZWQyBVWfs=;
	b=apudg3fMEwrmT5Hy7usbj0TCKIHLezzw0xYnNt3GVB/3U1iWyjDy/N7SecSkuy6cGTsSqchL3
	XRTXSQHZKFxrEpjnN5mG9OmXEd46D0m+z1+1zNFVt6WlERSFO0rQW7BUPgcWWUhwwExdYfNAKk7
	S++BIDtspilGrGTJhewLJmU=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hZSsr1ynQz12LHv;
	Wed,  2 Sep 2026 11:30:24 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id A1A8040575;
	Wed,  2 Sep 2026 11:41:40 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 2 Sep 2026 11:41:39 +0800
Message-ID: <c8a6b6ac-aa4a-4cbc-b4f0-8dd6f4f02341@huawei.com>
Date: Wed, 2 Sep 2026 11:41:39 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/5] KVM: arm64: Add KVM_REQ_RELOAD_STAGE2
To: Leonardo Bras <leo.bras@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver
 Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly
	<joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Raghavendra Rao Ananta <rananta@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com>
 <20260901171558.2674031-5-leo.bras@arm.com>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260901171558.2674031-5-leo.bras@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/2/2026 1:15 AM, Leonardo Bras wrote:
> Add a vcpu request to exit guest, reload Stage2, and then come back to
> guest.
> 
> This will be used on future patches that enable S2 HAFDBS and HDBSS, as
> they may need to change VTCR bits for enabling/disabling the feature when
> the vcpus are still running.
> 
> Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 2 ++
>   arch/arm64/kvm/arm.c              | 8 ++++++++
>   2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27fe0cd5b2d7..00fe169f239f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -48,20 +48,22 @@
>   #define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(2)
>   #define KVM_REQ_RECORD_STEAL		KVM_ARCH_REQ(3)
>   #define KVM_REQ_RELOAD_GICv4		KVM_ARCH_REQ(4)
>   #define KVM_REQ_RELOAD_PMU		KVM_ARCH_REQ(5)
>   #define KVM_REQ_SUSPEND			KVM_ARCH_REQ(6)
>   #define KVM_REQ_RESYNC_PMU_EL0		KVM_ARCH_REQ(7)
>   #define KVM_REQ_NESTED_S2_UNMAP		KVM_ARCH_REQ(8)
>   #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
>   #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
>   #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
> +#define KVM_REQ_RELOAD_STAGE2 \
> +	KVM_ARCH_REQ_FLAGS(12, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   
>   #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>   				     KVM_DIRTY_LOG_INITIALLY_SET)
>   
>   #define KVM_HAVE_MMU_RWLOCK
>   
>   /*
>    * Mode of operation configurable with kvm-arm.mode early param.
>    * See Documentation/admin-guide/kernel-parameters.txt for more information.
>    */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90..1e528d53d093 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1164,20 +1164,28 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>   
>   		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
>   			kvm_vcpu_pmu_restore_guest(vcpu);
>   
>   		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
>   			return kvm_vcpu_suspend(vcpu);
>   
>   		if (kvm_dirty_ring_check_request(vcpu))
>   			return 0;
>   
> +		if (kvm_check_request(KVM_REQ_RELOAD_STAGE2, vcpu)) {
> +			unsigned long flags;
> +
> +			local_irq_save(flags);
> +			__load_stage2(vcpu->arch.hw_mmu);
> +			local_irq_restore(flags);
> +		}
> +
>   		check_nested_vcpu_requests(vcpu);
>   	}
>   
>   	return 1;
>   }
>   
>   static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
>   {
>   	if (likely(!vcpu_mode_is_32bit(vcpu)))
>   		return false;
Hi Leo,

Thanks for sending this out. I actually implemented a similar request in
my v5 HDBSS series to reload VTCR on enable/disable, but I named it
KVM_REQ_HDBSS_RELOAD_VTCR.

Without such a request, the new VTCR value only takes effect on the next
vcpu_load, which means enable/disable could be delayed indefinitely if
the vCPU never goes through a load/put cycle. So I think this request is
necessary for HDBSS as well.

Since your KVM_REQ_RELOAD_STAGE2 is more generic, I'd like to rebase on
top of your patch and reuse it in v5. Would that work for you? Or do you
prefer to keep them separate for now?

Thanks,
Tian
