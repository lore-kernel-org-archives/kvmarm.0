Return-Path: <SRS0=+uR8=P5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6E9C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 13:19:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B063D611BF
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 13:19:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B063D611BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 238A04B2FD;
	Wed, 10 Nov 2021 08:19:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ra3mceoCzbum; Wed, 10 Nov 2021 08:19:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 449F14B2E2;
	Wed, 10 Nov 2021 08:19:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 034E24B2DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 08:19:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8d73tMcA5k4l for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 08:19:32 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC8414B2DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 08:19:31 -0500 (EST)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hq53p6jBXzZcxW;
 Wed, 10 Nov 2021 21:17:10 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:19:25 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:19:23 +0800
Subject: Re: [PATCH v2 2/5] KVM: arm64: Get rid of host SVE tracking/saving
To: Marc Zyngier <maz@kernel.org>
References: <20211028111640.3663631-1-maz@kernel.org>
 <20211028111640.3663631-3-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5ab3836f-2b39-2ff5-3286-8258addd01e4@huawei.com>
Date: Wed, 10 Nov 2021 21:19:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20211028111640.3663631-3-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 broonie@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2021/10/28 19:16, Marc Zyngier wrote:
> The SVE host tracking in KVM is pretty involved. It relies on a
> set of flags tracking the ownership of the SVE register, as well
> as that of the EL0 access.
> 
> It is also pretty scary: __hyp_sve_save_host() computes
> a thread_struct pointer and obtains a sve_state which gets directly
> accessed without further ado, even on nVHE. How can this even work?
> 
> The answer to that is that it doesn't, and that this is mostly dead
> code. Closer examination shows that on executing a syscall, userspace
> loses its SVE state entirely. This is part of the ABI. Another
> thing to notice is that although the kernel provides helpers such as
> kernel_neon_begin()/end(), they only deal with the FP/NEON state,
> and not SVE.
> 
> Given that you can only execute a guest as the result of a syscall,
> and that the kernel cannot use SVE by itself, it becomes pretty
> obvious that there is never any host SVE state to save, and that
> this code is only there to increase confusion.
> 
> Get rid of the TIF_SVE tracking and host save infrastructure altogether.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 5621020b28de..38ca332c10fe 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -73,15 +73,11 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
>  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  {
>  	BUG_ON(!current->mm);
> +	BUG_ON(test_thread_flag(TIF_SVE));
>  
> -	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
> -			      KVM_ARM64_HOST_SVE_IN_USE |
> -			      KVM_ARM64_HOST_SVE_ENABLED);
> +	vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
>  	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
>  
> -	if (test_thread_flag(TIF_SVE))
> -		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;

The comment about TIF_SVE on top of kvm_arch_vcpu_load_fp() becomes
obsolete now. Maybe worth removing it?

| *
| * TIF_SVE is backed up here, since it may get clobbered with guest state.
| * This flag is restored by kvm_arch_vcpu_put_fp(vcpu).

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index a0e78a6027be..722dfde7f1aa 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -207,16 +207,6 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
>  	return __get_fault_info(esr, &vcpu->arch.fault);
>  }
>  
> -static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
> -{
> -	struct thread_struct *thread;
> -
> -	thread = container_of(vcpu->arch.host_fpsimd_state, struct thread_struct,
> -			      uw.fpsimd_state);
> -
> -	__sve_save_state(sve_pffr(thread), &vcpu->arch.host_fpsimd_state->fpsr);
> -}

Nit: This removes the only user of __sve_save_state() helper. Should we
still keep it in fpsimd.S?

Thanks,
Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
