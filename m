Return-Path: <SRS0=ArdN=KA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021E2C433B4
	for <kvmarm@archiver.kernel.org>; Wed,  5 May 2021 14:23:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 305ED61182
	for <kvmarm@archiver.kernel.org>; Wed,  5 May 2021 14:23:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 305ED61182
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 844434B4B9;
	Wed,  5 May 2021 10:23:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UQn5PSdJdNhK; Wed,  5 May 2021 10:23:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E0BE4B4B3;
	Wed,  5 May 2021 10:23:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 225E94B4B3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 May 2021 10:23:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mVJwo5JF6wIO for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 May 2021 10:23:14 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 202C34B4AB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 May 2021 10:23:14 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FZzPQ2QyszqSVy;
 Wed,  5 May 2021 22:19:54 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Wed, 5 May 2021 22:23:02 +0800
Subject: Re: [PATCH v2 03/11] KVM: arm64: Make kvm_skip_instr() and co private
 to HYP
To: Marc Zyngier <maz@kernel.org>
References: <20201102164045.264512-1-maz@kernel.org>
 <20201102164045.264512-4-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <cef3517b-e66d-4d26-68a9-2d5fb433377c@huawei.com>
Date: Wed, 5 May 2021 22:23:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20201102164045.264512-4-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, kernel-team@android.com, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2020/11/3 0:40, Marc Zyngier wrote:
> In an effort to remove the vcpu PC manipulations from EL1 on nVHE
> systems, move kvm_skip_instr() to be HYP-specific. EL1's intent
> to increment PC post emulation is now signalled via a flag in the
> vcpu structure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

[...]

> @@ -133,6 +134,8 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  	__load_guest_stage2(vcpu->arch.hw_mmu);
>  	__activate_traps(vcpu);
>  
> +	__adjust_pc(vcpu);

If the INCREMENT_PC flag was set (e.g., for WFx emulation) while we're
handling PSCI CPU_ON call targetting this VCPU, the *target_pc* (aka
entry point address, normally provided by the primary VCPU) will be
unexpectedly incremented here. That's pretty bad, I think.

This was noticed with a latest guest kernel, at least with commit
dccc9da22ded ("arm64: Improve parking of stopped CPUs"), which put the
stopped VCPUs in the WFx loop. The guest kernel shouted at me that

	"CPU: CPUs started in inconsistent modes"

*after* rebooting. The problem is that the secondary entry point was
corrupted by KVM as explained above. All of the secondary processors
started from set_cpu_boot_mode_flag(), with w0=0. Oh well...

I write the below diff and guess it will help. But I have to look at all
other places where we adjust PC directly to make a right fix. Please let
me know what do you think.


Thanks,
Zenghui

---->8----
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 956cdc240148..ed647eb387c3 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -265,7 +265,12 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
  		if (vcpu->arch.reset_state.be)
  			kvm_vcpu_set_be(vcpu);

+		/*
+		 * Don't bother with the KVM_ARM64_INCREMENT_PC flag while
+		 * using this version of __adjust_pc().
+		 */
  		*vcpu_pc(vcpu) = target_pc;
+		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
  		vcpu_set_reg(vcpu, 0, vcpu->arch.reset_state.r0);

  		vcpu->arch.reset_state.reset = false;
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
