Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86297C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:29:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8F7564E13
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:29:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8F7564E13
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39E3C4B5CA;
	Wed, 17 Mar 2021 10:29:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i8QSz6VhJmX6; Wed, 17 Mar 2021 10:29:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86DF54B654;
	Wed, 17 Mar 2021 10:29:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BB2D4B5CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:29:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VISzryiA+iZd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 10:29:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 623834B578
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:29:46 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD26164E13;
 Wed, 17 Mar 2021 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615991385;
 bh=pRyeN3C9RR8ZoBn+JDrcnrqSXZm0FGBncn5ju3CW/pg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=WEtBnbK+2Lv2Z95b90URCO95CaLSHi8BkVGa4AzUCI/lR62SGM/PCdaBk2q7lWEku
 5odB8LN8WIB4VXbZZ9K2RoKnkyc71245IMA30gq0GoD9TiDd8PkUcP7Y7kmcJFQ5CL
 kBbmXPfPb19bsDgc2YtNNaM9YxQuwH0wrK5m28BEo6Vomu6iu3ilAZJGMWtek7h6tg
 KZUT88WgMgnaVzjfI0tujzlvs6jxcbN8KQYHaTEbD5lgx8EQ1aY0/b9Qu+BcpZDpDY
 twx4K3ctZLfZI1M06qYEroOSMX1p+6tx162z7etwaSfS1a6TXhQ8I4479VeAr1DQZ9
 rr3TiqL2M7m5A==
Date: Wed, 17 Mar 2021 14:29:39 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 05/10] KVM: arm64: Rework SVE host-save/guest-restore
Message-ID: <20210317142938.GA5393@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-6-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-6-maz@kernel.org>
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

On Tue, Mar 16, 2021 at 10:13:07AM +0000, Marc Zyngier wrote:
> In order to keep the code readable, move the host-save/guest-restore
> sequences in their own functions, with the following changes:
> - the hypervisor ZCR is now set from C code
> - ZCR_EL2 is always used as the EL2 accessor
> 
> This results in some minor assembler macro rework.
> No functional change intended.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimdmacros.h   |  8 +++--
>  arch/arm64/include/asm/kvm_hyp.h        |  2 +-
>  arch/arm64/kvm/hyp/fpsimd.S             |  2 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 41 +++++++++++++++----------
>  4 files changed, 33 insertions(+), 20 deletions(-)

[...]

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index fb68271c1a0f..d34dc220a1ce 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -196,6 +196,25 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
> +{
> +	struct thread_struct *thread;
> +
> +	thread = container_of(vcpu->arch.host_fpsimd_state, struct thread_struct,
> +			      uw.fpsimd_state);
> +
> +	__sve_save_state(sve_pffr(thread), &vcpu->arch.host_fpsimd_state->fpsr);
> +}
> +
> +static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
> +{
> +	if (read_sysreg_s(SYS_ZCR_EL2) != (vcpu_sve_vq(vcpu) - 1))

Strictly speaking, we should probably be extracting the LEN field from
ZCR_EL2, otherwise this has the potential to go horribly wrong if any of
the RES0 bits are allocated in future.

Other than that:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
