Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E113C11F64
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 12:53:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 16C3161400
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 12:53:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16C3161400
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94F024A483;
	Thu,  1 Jul 2021 08:53:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zF7bWyadVFAG; Thu,  1 Jul 2021 08:53:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67B304A4C0;
	Thu,  1 Jul 2021 08:53:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDD794A483
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 08:53:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4X0HIljXJV-L for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 08:53:37 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 907C540895
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 08:53:37 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 845E2613BE;
 Thu,  1 Jul 2021 12:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1625144015;
 bh=lUbZyslvIOApmJ3hMzsa+q09UUNK1kyPxQPQLRvNARk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=WN2ySd5/C6RxYl93s45H3vKYUHhhteWZ7l1QH8rVPIMSBIYV7+uSeaEkBG/jkxMLG
 y8PeMQ66ViWP9V8dCe89O3UoxNeqUuIb0it1O7I15mRl4nlPIb8pt9Agn/0D4MDPze
 MqUp+yfd4oQwnH6mdqPx/fYUYoIlar6MOPLzUNddjIvAupEAPMVxg/+/u5EmwItz3B
 BXeYGcC4ZMMzNb6Uc/AfqI3LpT8ZHSax9b87kT3grXH69rMhTvfrbbtD58yANt3Y44
 3F1YONYR1qzxbhmEWGSvt0R3Ey7nphkvveefxX1OL8buONagat49nWsqZWt65tRW1T
 2R1NoCclowjnA==
Date: Thu, 1 Jul 2021 13:53:30 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 02/13] KVM: arm64: MDCR_EL2 is a 64-bit register
Message-ID: <20210701125329.GA9757@willie-the-truck>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-3-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210615133950.693489-3-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Jun 15, 2021 at 02:39:39PM +0100, Fuad Tabba wrote:
> Fix the places in KVM that treat MDCR_EL2 as a 32-bit register.
> More recent features (e.g., FEAT_SPEv1p2) use bits above 31.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h   | 20 ++++++++++----------
>  arch/arm64/include/asm/kvm_asm.h   |  2 +-
>  arch/arm64/include/asm/kvm_host.h  |  2 +-
>  arch/arm64/kvm/debug.c             |  5 +++--
>  arch/arm64/kvm/hyp/nvhe/debug-sr.c |  2 +-
>  arch/arm64/kvm/hyp/vhe/debug-sr.c  |  2 +-
>  6 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 692c9049befa..25d8a61888e4 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -280,18 +280,18 @@
>  /* Hyp Debug Configuration Register bits */
>  #define MDCR_EL2_E2TB_MASK	(UL(0x3))
>  #define MDCR_EL2_E2TB_SHIFT	(UL(24))
> -#define MDCR_EL2_TTRF		(1 << 19)
> -#define MDCR_EL2_TPMS		(1 << 14)
> +#define MDCR_EL2_TTRF		(UL(1) << 19)
> +#define MDCR_EL2_TPMS		(UL(1) << 14)
>  #define MDCR_EL2_E2PB_MASK	(UL(0x3))
>  #define MDCR_EL2_E2PB_SHIFT	(UL(12))
> -#define MDCR_EL2_TDRA		(1 << 11)
> -#define MDCR_EL2_TDOSA		(1 << 10)
> -#define MDCR_EL2_TDA		(1 << 9)
> -#define MDCR_EL2_TDE		(1 << 8)
> -#define MDCR_EL2_HPME		(1 << 7)
> -#define MDCR_EL2_TPM		(1 << 6)
> -#define MDCR_EL2_TPMCR		(1 << 5)
> -#define MDCR_EL2_HPMN_MASK	(0x1F)
> +#define MDCR_EL2_TDRA		(UL(1) << 11)
> +#define MDCR_EL2_TDOSA		(UL(1) << 10)
> +#define MDCR_EL2_TDA		(UL(1) << 9)
> +#define MDCR_EL2_TDE		(UL(1) << 8)
> +#define MDCR_EL2_HPME		(UL(1) << 7)
> +#define MDCR_EL2_TPM		(UL(1) << 6)
> +#define MDCR_EL2_TPMCR		(UL(1) << 5)
> +#define MDCR_EL2_HPMN_MASK	(UL(0x1F))

Personally, I prefer to use the BIT() macro for these things, but what
you've got here is consistent with the rest of the file and I think that's
more important.

>  /* For compatibility with fault code shared with 32-bit */
>  #define FSC_FAULT	ESR_ELx_FSC_FAULT
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 5e9b33cbac51..d88a5550552c 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -209,7 +209,7 @@ extern u64 __vgic_v3_read_vmcr(void);
>  extern void __vgic_v3_write_vmcr(u32 vmcr);
>  extern void __vgic_v3_init_lrs(void);
>  
> -extern u32 __kvm_get_mdcr_el2(void);
> +extern u64 __kvm_get_mdcr_el2(void);
>  
>  #define __KVM_EXTABLE(from, to)						\
>  	"	.pushsection	__kvm_ex_table, \"a\"\n"		\
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 5645af2a1431..45fdd0b7063f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -286,7 +286,7 @@ struct kvm_vcpu_arch {
>  
>  	/* HYP configuration */
>  	u64 hcr_el2;
> -	u32 mdcr_el2;
> +	u64 mdcr_el2;
>  
>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index d5e79d7ee6e9..f7385bfbc9e4 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -21,7 +21,7 @@
>  				DBG_MDSCR_KDE | \
>  				DBG_MDSCR_MDE)
>  
> -static DEFINE_PER_CPU(u32, mdcr_el2);
> +static DEFINE_PER_CPU(u64, mdcr_el2);
>  
>  /**
>   * save/restore_guest_debug_regs
> @@ -154,7 +154,8 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
>  
>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long mdscr, orig_mdcr_el2 = vcpu->arch.mdcr_el2;
> +	unsigned long mdscr;
> +	u64 orig_mdcr_el2 = vcpu->arch.mdcr_el2;

This is arm64 code, so 'unsigned long' is fine here and you can leave the
existing code as-is.

With that:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
