Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE468C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:14:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B9FD64EF9
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 14:14:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B9FD64EF9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C57E34B74F;
	Thu, 18 Mar 2021 10:14:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5cxl+gAEeOw6; Thu, 18 Mar 2021 10:14:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B98454B6C8;
	Thu, 18 Mar 2021 10:14:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B1D24B3EA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:14:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FIOq5Hweu82C for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 10:14:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 475474B399
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 10:14:07 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DE7464E01;
 Thu, 18 Mar 2021 14:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616076844;
 bh=aUVF0Ydr7cFuRiZVzu9loYt6i7SML2c2a9mIIBakwxs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=XffV7mEr8cWu7NBXBLOufsNJUerPiVzf6ncfT+/kpr+PJChg1Io5bvtS036WzRaF6
 HbloftOXtPrFEKvbjOnaas3BiPyBf6bHzDmOJcC/GOIvdnn/kXRs//4JZLfYdiSXzL
 vHDGgsH05fJqFJbAh9I2ox/dCANiytHXoGUyAHenReMUnxktogaenPEXMJUuQm74yY
 XOhmBOrKmqHILKnmJrSOOAvVIlgDrxNQh37XYft851Y6hJjgKH0+yGY8usdokklTlU
 F8h5GuqDACqlfK6VS2gtP+NcrwPsSa2mjhENjemy3Zz3M3WAuGD3vLiHBw2G5/a9na
 FNR6nuH3RyUFg==
Date: Thu, 18 Mar 2021 14:13:58 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 10/11] KVM: arm64: Save/restore SVE state for nVHE
Message-ID: <20210318141358.GF7055@willie-the-truck>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-11-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210318122532.505263-11-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, broonie@kernel.org, kernel-team@android.com,
 dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, daniel.kiss@arm.com
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

On Thu, Mar 18, 2021 at 12:25:31PM +0000, Marc Zyngier wrote:
> Implement the SVE save/restore for nVHE, following a similar
> logic to that of the VHE implementation:
> 
> - the SVE state is switched on trap from EL1 to EL2
> 
> - no further changes to ZCR_EL2 occur as long as the guest isn't
>   preempted or exit to userspace
> 
> - ZCR_EL2 is reset to its default value on the first SVE access from
>   the host EL1, and ZCR_EL1 restored to the default guest value in
>   vcpu_put()
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c                 | 10 +++++--
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 37 +++++++++----------------
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  4 +--
>  3 files changed, 23 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 14ea05c5134a..5621020b28de 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -121,11 +121,17 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  	local_irq_save(flags);
>  
>  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> -		if (guest_has_sve)
> +		if (guest_has_sve) {
>  			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
>  
> +			/* Restore the VL that was saved when bound to the CPU */
> +			if (!has_vhe())
> +				sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1,
> +						       SYS_ZCR_EL1);

You end up reading ZCR_EL1 twice here, but it's probably not the end of the
world.

Anyway:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
