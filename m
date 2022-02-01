Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EC8C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 16:38:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4047449F10;
	Tue,  1 Feb 2022 11:38:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armlinux.org.uk
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a5Y8-Vh9Cpll; Tue,  1 Feb 2022 11:38:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 917B241016;
	Tue,  1 Feb 2022 11:38:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 835E541016
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 11:38:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mJfdn0Lbo17I for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 11:38:09 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FF8340FD3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 11:38:09 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=1lTsDEbwIELOLsQQ3LW7YTALtUz0mwSPckKDI4izXLA=; b=MBrbQx2kPnS1qOhHR005ucRtL2
 QUby9b49hytlEAupmcgr6Lex8Lk+lBOpUqlEmuPYmUywvUjGI+mdVf3p87XZo6xKoue25YQHu2AmD
 LIgZ4VJrDA06LB4AqGx5DcB3++FmZ2AlnYQkdVwByjsfwHrhLTjrrQGA4Qq2ElyGlfQtt0QDRToZB
 C2YKg10OI51HN52UCV2ja7zIcO35E8mPUzZyxbswIRV6n0jeqtNvezBp9K7n2BBOLoulB+kg0lmNw
 MWPYxtCUk+ANHPmRxLQNU7WUrDVFKZYb7vQrHksQmrRyUf/gv2cAKE/r4NLEJKqSNdvu3jDeZp9/R
 OYHfBUVg==;
Received: from shell.armlinux.org.uk
 ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56968)
 by pandora.armlinux.org.uk with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@armlinux.org.uk>)
 id 1nEwAJ-0000oc-3y; Tue, 01 Feb 2022 16:37:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
 (envelope-from <linux@shell.armlinux.org.uk>)
 id 1nEwA5-0002D4-92; Tue, 01 Feb 2022 16:37:45 +0000
Date: Tue, 1 Feb 2022 16:37:45 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 12/64] KVM: arm64: nv: Add non-VHE-EL2->EL1
 translation helpers
Message-ID: <Yflh2ad0lkoqTSqX@shell.armlinux.org.uk>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-13-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-13-maz@kernel.org>
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

On Fri, Jan 28, 2022 at 12:18:20PM +0000, Marc Zyngier wrote:
> Some EL2 system registers immediately affect the current execution
> of the system, so we need to use their respective EL1 counterparts.
> For this we need to define a mapping between the two. In general,
> this only affects non-VHE guest hypervisors, as VHE system registers
> are compatible with the EL1 counterparts.
> 
> These helpers will get used in subsequent patches.
> 
> Co-developed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

> ---
>  arch/arm64/include/asm/kvm_nested.h | 54 +++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index fd601ea68d13..5a85be6d8eb3 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -2,6 +2,7 @@
>  #ifndef __ARM64_KVM_NESTED_H
>  #define __ARM64_KVM_NESTED_H
>  
> +#include <linux/bitfield.h>
>  #include <linux/kvm_host.h>
>  
>  static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
> @@ -11,4 +12,57 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
>  		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
>  }
>  
> +/* Translation helpers from non-VHE EL2 to EL1 */
> +static inline u64 tcr_el2_ps_to_tcr_el1_ips(u64 tcr_el2)
> +{
> +	return (u64)FIELD_GET(TCR_EL2_PS_MASK, tcr_el2) << TCR_IPS_SHIFT;

I frowned about the use of FIELD_GET() but not FIELD_PREP(), which
would be:

	return FIELD_PREP(TCR_IPS_MASK, FIELD_GET(TCR_EL2_PS_MASK, tcr_el2));

However, I'm not bothered by this beyond frowning!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
