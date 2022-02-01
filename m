Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437A1C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 18:07:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6AD349E27;
	Tue,  1 Feb 2022 13:07:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9Y1GblkzHhQY; Tue,  1 Feb 2022 13:07:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FD8A49DED;
	Tue,  1 Feb 2022 13:07:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A454F43C96
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 13:07:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W4qsSBTjEF6T for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 13:07:08 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9AB34120D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 13:07:08 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=R0yDYfpqv6G0qJ4TWP//kGvyk3PTrL93oe5AIU5CW6c=; b=alv69qVY7neZLMb2jWDPTVT/gY
 csZplivBxQyArYTFpA01gUCYds1v3D3yjk/04JAmQowplxF/zLpHbgRywYjI7MZzhpe8b5rTJImCF
 8u+e30lFOLj+u6F0l5J9Rnp02ujyEJqlxg61WIA68z6D+DmBLzzHSXtsFpBZcFO6Tvh/Mjmq4Iz8h
 va2Q1cUEIJ828sh6a+JiVB9LIqPaOD4FVTdK5/xdQ/N6VwVMMxtJtvzVjrpXYTbWhQeRKig5mCKd8
 VgsngbRgHt71xMyadE56GZRHyZpxMpQaK/i7az1CJ5mVALEVElJWPO3co4hU1oyuYv2UIbTxLYtP9
 quo/zp8w==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56978)
 by pandora.armlinux.org.uk with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@armlinux.org.uk>)
 id 1nExYR-0000vL-FQ; Tue, 01 Feb 2022 18:06:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1nExYJ-0002GW-9U; Tue, 01 Feb 2022 18:06:51 +0000
Date: Tue, 1 Feb 2022 18:06:51 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 17/64] KVM: arm64: nv: Emulate PSTATE.M for a guest
 hypervisor
Message-ID: <Yfl2u69WA2sYcyom@shell.armlinux.org.uk>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-18-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-18-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
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

On Fri, Jan 28, 2022 at 12:18:25PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> We can no longer blindly copy the VCPU's PSTATE into SPSR_EL2 and return
> to the guest and vice versa when taking an exception to the hypervisor,
> because we emulate virtual EL2 in EL1 and therefore have to translate
> the mode field from EL2 to EL1 and vice versa.
> 
> This requires keeping track of the state we enter the guest, for which
> we transiently use a dedicated flag.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h          |  1 +
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 19 ++++++++++++++++-
>  arch/arm64/kvm/hyp/vhe/switch.c            | 24 ++++++++++++++++++++++
>  3 files changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8fffe2888403..fa253f08e0fd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -472,6 +472,7 @@ struct kvm_vcpu_arch {
>  #define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
>  #define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
>  #define KVM_ARM64_FP_FOREIGN_FPSTATE	(1 << 14)
> +#define KVM_ARM64_IN_HYP_CONTEXT	(1 << 15) /* Guest running in HYP context */
>  
>  #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
>  				 KVM_GUESTDBG_USE_SW_BP | \
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index 283f780f5f56..e3689c6ce4cc 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -157,9 +157,26 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
>  	write_sysreg_el1(ctxt_sys_reg(ctxt, SPSR_EL1),	SYS_SPSR);
>  }
>  
> +/* Read the VCPU state's PSTATE, but translate (v)EL2 to EL1. */
> +static inline u64 to_hw_pstate(const struct kvm_cpu_context *ctxt)
> +{
> +	u64 mode = ctxt->regs.pstate & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +
> +	switch (mode) {
> +	case PSR_MODE_EL2t:
> +		mode = PSR_MODE_EL1t;
> +		break;
> +	case PSR_MODE_EL2h:
> +		mode = PSR_MODE_EL1h;
> +		break;
> +	}
> +
> +	return (ctxt->regs.pstate & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
> +}
> +

Wondering if it makes sense to also have the reverse translation as an
inline function after the above too, so the two translations are
together - but as it's only used (in this patch at least) in switch.c
there probably isn't too much point.

So:

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
