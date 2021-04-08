Return-Path: <SRS0=McpZ=JF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD86CC433B4
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 15:36:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0D84B610A3
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 15:36:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D84B610A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C18A4BA6F;
	Thu,  8 Apr 2021 11:36:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IXMJVcHNZ2VD; Thu,  8 Apr 2021 11:36:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D7434BA8C;
	Thu,  8 Apr 2021 11:36:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1F6D4BA6F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 11:36:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AZ8hQteqBy4c for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Apr 2021 11:36:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F4194B42F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 11:36:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64F18D6E;
 Thu,  8 Apr 2021 08:36:17 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 52BE03F694;
 Thu,  8 Apr 2021 08:36:16 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Fully zero the vcpu state on reset
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210407181308.2265808-1-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <c34842b2-215a-e9d0-7d9d-a8cd64ed1171@arm.com>
Date: Thu, 8 Apr 2021 16:36:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407181308.2265808-1-maz@kernel.org>
Content-Language: en-US
Cc: kernel-team@android.com, stable@vger.kernel.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 4/7/21 7:13 PM, Marc Zyngier wrote:
> On vcpu reset, we expect all the registers to be brought back
> to their initial state, which happens to be a bunch of zeroes.
>
> However, some recent commit broke this, and is now leaving a bunch
> of registers (such as a FP state) with whatever was left by the
> guest. My bad.
>
> Just zero the whole vcpu context on reset. It is more than we
> strictly need, but at least we won't miss anything. This also
> zeroes the __hyp_running_vcpu pointer, which is always NULL
> for a vcpu anyway.

Had a look at struct kvm_cpu_context and indeed the only field which doesn't
represent a guest register is __hyp_running_vcpu. Did a grep for all the places
where __hyp_running_vcpu is used, and indeed the assumption is that for a guest
the pointer is NULL, as __sysreg_restore_el1_state() relies on it.

>
> Cc: stable@vger.kernel.org
> Fixes: e47c2055c68e ("KVM: arm64: Make struct kvm_regs userspace-only")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/reset.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index bd354cd45d28..ef1c49a1a3ad 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -240,8 +240,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  		break;
>  	}
>  
> -	/* Reset core registers */
> -	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
> +	/* Zero all registers */
> +	memset(&vcpu->arch.ctxt, 0, sizeof(vcpu->arch.ctxt));

Checked that code earlier in the function does not touch the guest registers from
vcpu->arch.ctxt, to make sure we're not overwriting other reset values by mistake.
Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>  	vcpu_gp_regs(vcpu)->pstate = pstate;
>  
>  	/* Reset system registers */
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
