Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77175C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 13:45:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBC554B966;
	Fri, 25 Feb 2022 08:45:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E+vf8cwiDcFZ; Fri, 25 Feb 2022 08:45:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B4354B9D3;
	Fri, 25 Feb 2022 08:45:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 383294B9D3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:45:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M9NvGZGsH7d9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 08:45:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F008F4B966
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:45:24 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B8D6106F;
 Fri, 25 Feb 2022 05:45:24 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EBA73F5A1;
 Fri, 25 Feb 2022 05:45:20 -0800 (PST)
Date: Fri, 25 Feb 2022 13:45:45 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 42/64] KVM: arm64: nv: Fold guest's HCR_EL2
 configuration into the host's
Message-ID: <YhjdiTiHNApGkRuc@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-43-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-43-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
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

Hi,

On Fri, Jan 28, 2022 at 12:18:50PM +0000, Marc Zyngier wrote:
> When entering a L2 guest (nested virt enabled, but not in hypervisor
> context), we need to honor the traps the L1 guest has asked enabled.
> 
> For now, just OR the guest's HCR_EL2 into the host's. We may have to do
> some filtering in the future though.

Hmm... looks to me like the filtering is already implemented via the
HCR_GUEST_NV_FILTER_FLAGS. Or am I misunderstanding something?

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vhe/switch.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 0e164cc8e913..5e8eafac27c6 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -78,6 +78,11 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  			if (!vcpu_el2_tge_is_set(vcpu))
>  				hcr |= HCR_AT | HCR_TTLB;
>  		}
> +	} else if (vcpu_has_nv(vcpu)) {
> +		u64 vhcr_el2 = __vcpu_sys_reg(vcpu, HCR_EL2);
> +
> +		vhcr_el2 &= ~HCR_GUEST_NV_FILTER_FLAGS;


> +		hcr |= vhcr_el2;

This makes sense, we only the guest to add extra traps on top of what KVM
already traps, not remove traps from what KVM has configured.

However, HCR_EL2.FIEN (bit 47) disables traps when the bit is 1. Shouldn't
it be part of the HCR_GUEST_NV_FILTER_FLAGS?

Thanks,
Alex

>  	}
>  
>  	___activate_traps(vcpu, hcr);
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
