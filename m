Return-Path: <SRS0=DM5G=KP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 569D9C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 12:56:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 95A8861184
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 12:56:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95A8861184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 142244B3A3;
	Thu, 20 May 2021 08:56:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BGkBGrw0px7f; Thu, 20 May 2021 08:55:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E22034B39E;
	Thu, 20 May 2021 08:55:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 992D04B389
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 08:55:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L2Iw3aJahT6k for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 May 2021 08:55:54 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 448C34B2A1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 08:55:54 -0400 (EDT)
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fm8ms1KGbzmXlB;
 Thu, 20 May 2021 20:53:33 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 20:55:49 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 20:55:49 +0800
Subject: Re: [PATCH v4 09/66] KVM: arm64: nv: Support virtual EL2 exceptions
To: Marc Zyngier <maz@kernel.org>
References: <20210510165920.1913477-1-maz@kernel.org>
 <20210510165920.1913477-10-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <c573a93e-58ac-ae1e-2b84-9bc148d40e2f@huawei.com>
Date: Thu, 20 May 2021 20:55:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210510165920.1913477-10-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 jintack.lim@linaro.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On 2021/5/11 0:58, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> Support injecting exceptions and performing exception returns to and
> from virtual EL2.  This must be done entirely in software except when
> taking an exception from vEL0 to vEL2 when the virtual HCR_EL2.{E2H,TGE}
> == {1,1}  (a VHE guest hypervisor).
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> [maz: switch to common exception injection framework]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h     |  17 +++
>  arch/arm64/include/asm/kvm_emulate.h |  10 ++
>  arch/arm64/kvm/Makefile              |   2 +-
>  arch/arm64/kvm/emulate-nested.c      | 176 +++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/exception.c       |  45 +++++--
>  arch/arm64/kvm/inject_fault.c        |  63 ++++++++--
>  arch/arm64/kvm/trace_arm.h           |  59 +++++++++
>  7 files changed, 354 insertions(+), 18 deletions(-)
>  create mode 100644 arch/arm64/kvm/emulate-nested.c

[...]

>  static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
>  {
>  	unsigned long cpsr = *vcpu_cpsr(vcpu);
>  	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
>  	u32 esr = 0;
>  
> -	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
> -			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
> -			     KVM_ARM64_PENDING_EXCEPTION);
> -
> -	vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
> +	pend_sync_exception(vcpu);
>  
>  	/*
>  	 * Build an {i,d}abort, depending on the level and the
> @@ -45,16 +79,22 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
>  	if (!is_iabt)
>  		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
>  
> -	vcpu_write_sys_reg(vcpu, esr | ESR_ELx_FSC_EXTABT, ESR_EL1);
> +	esr |= ESR_ELx_FSC_EXTABT;
> +
> +	if (vcpu->arch.flags & KVM_ARM64_EXCEPT_AA64_EL1) {

This isn't the right way to pick between EL1 and EL2 since
KVM_ARM64_EXCEPT_AA64_EL1 is (0 << 11), we will not be able
to inject abort to EL1 that way.

> +		vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
> +		vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
> +	} else {
> +		vcpu_write_sys_reg(vcpu, addr, FAR_EL2);
> +		vcpu_write_sys_reg(vcpu, esr, ESR_EL2);
> +	}
>  }
>  
>  static void inject_undef64(struct kvm_vcpu *vcpu)
>  {
>  	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
>  
> -	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
> -			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
> -			     KVM_ARM64_PENDING_EXCEPTION);
> +	pend_sync_exception(vcpu);
>  
>  	/*
>  	 * Build an unknown exception, depending on the instruction
> @@ -63,7 +103,10 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>  	if (kvm_vcpu_trap_il_is32bit(vcpu))
>  		esr |= ESR_ELx_IL;
>  
> -	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
> +	if (vcpu->arch.flags & KVM_ARM64_EXCEPT_AA64_EL1)
> +		vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
> +	else
> +		vcpu_write_sys_reg(vcpu, esr, ESR_EL2);

Same here.

Thanks,
Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
