Return-Path: <SRS0=mAhA=D5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88624C388F2
	for <kvmarm@archiver.kernel.org>; Thu, 22 Oct 2020 12:03:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96C89221FE
	for <kvmarm@archiver.kernel.org>; Thu, 22 Oct 2020 12:03:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YRpZPXny"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96C89221FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1B584B6C8;
	Thu, 22 Oct 2020 08:03:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J2cxAXQ6bQNO; Thu, 22 Oct 2020 08:03:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9A1C4B676;
	Thu, 22 Oct 2020 08:03:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B60664B63E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2020 08:03:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HEeey6gwe-nR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Oct 2020 08:03:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCD4C4B66A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2020 08:03:14 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 174A9221FE;
 Thu, 22 Oct 2020 12:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603368193;
 bh=QoNlR6rIRYPKupL4AS+eEnrxGc2IW3lD5dGdm24WsAc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=YRpZPXnyyuQqVeCuey02XRVYLQwVvODglK08tP2UEGvxxpkV11lo/bsqQocZZiQBF
 IORypbWtJatWmO7ydVc1b+3GWAxzeqJ7ho5jNwJic0m8c791iIaxHjQ+Z1WH+S0yvT
 uI5ELeVmCraFXhb7NYAwdiZqgYO8KhRG4GLwCwqE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kVZJG-003Iwo-Vu; Thu, 22 Oct 2020 13:03:11 +0100
MIME-Version: 1.0
Date: Thu, 22 Oct 2020 13:03:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: Re: [RFC] KVM: arm64: Don't force broadcast tlbi when guest is running
In-Reply-To: <1603331829-33879-1-git-send-email-zhangshaokun@hisilicon.com>
References: <1603331829-33879-1-git-send-email-zhangshaokun@hisilicon.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <be1d84d42df6203ad993e8d20d9bd6da@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhangshaokun@hisilicon.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 tangnianyao@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2020-10-22 02:57, Shaokun Zhang wrote:
> From: Nianyao Tang <tangnianyao@huawei.com>
> 
> Now HCR_EL2.FB is set to force broadcast tlbi to all online pcpus,
> even those vcpu do not resident on. It would get worse as system
> gets larger and more pcpus get online.
> Let's disable force-broadcast. We flush tlbi when move vcpu to a
> new pcpu, in case old page mapping still exists on new pcpu.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Nianyao Tang <tangnianyao@huawei.com>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 2 +-
>  arch/arm64/kvm/arm.c             | 4 +++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h 
> b/arch/arm64/include/asm/kvm_arm.h
> index 64ce29378467..f85ea9c649cb 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -75,7 +75,7 @@
>   * PTW:		Take a stage2 fault if a stage1 walk steps in device memory
>   */
>  #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | 
> HCR_VM | \
> -			 HCR_BSU_IS | HCR_FB | HCR_TAC | \
> +			 HCR_BSU_IS | HCR_TAC | \
>  			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
>  			 HCR_FMO | HCR_IMO | HCR_PTW )
>  #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index acf9a993dfb6..845be911f885 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -334,8 +334,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int 
> cpu)
>  	/*
>  	 * We might get preempted before the vCPU actually runs, but
>  	 * over-invalidation doesn't affect correctness.
> +	 * Dirty tlb might still exist when vcpu ran on other pcpu
> +	 * and modified page mapping.
>  	 */
> -	if (*last_ran != vcpu->vcpu_id) {
> +	if (*last_ran != vcpu->vcpu_id || vcpu->cpu != cpu) {
>  		kvm_call_hyp(__kvm_tlb_flush_local_vmid, mmu);
>  		*last_ran = vcpu->vcpu_id;
>  	}

This breaks uniprocessor semantics for I-cache invalidation. What could
possibly go wrong? You also fail to provide any data that would back up
your claim, as usual.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
