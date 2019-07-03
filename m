Return-Path: <SRS0=95sP=VA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59126C0650E
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 14:13:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DFD2021881
	for <kvmarm@archiver.kernel.org>; Wed,  3 Jul 2019 14:13:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFD2021881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 605F84A4FC;
	Wed,  3 Jul 2019 10:13:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aKEzMJd0aGUJ; Wed,  3 Jul 2019 10:13:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18CF34A4FB;
	Wed,  3 Jul 2019 10:13:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A93754A4FB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 10:13:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bqRVWyGOuqa2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Jul 2019 10:13:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BDC44A4FA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Jul 2019 10:13:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AED2B2B;
 Wed,  3 Jul 2019 07:13:10 -0700 (PDT)
Received: from [10.1.31.185] (unknown [10.1.31.185])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F9943F718;
 Wed,  3 Jul 2019 07:13:09 -0700 (PDT)
Subject: Re: [PATCH 33/59] KVM: arm64: nv: Pretend we only support
 larger-than-host page sizes
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-34-marc.zyngier@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f99c2f11-a59c-485f-a264-69848e1e40c7@arm.com>
Date: Wed, 3 Jul 2019 15:13:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-34-marc.zyngier@arm.com>
Content-Language: en-US
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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


On 6/21/19 10:38 AM, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
>
> Exposing memory management support to the virtual EL2 as is exposed to
> the host hypervisor would make the implementation too complex and
> inefficient. Therefore expose limited memory management support for the
> following two cases.
>
> We expose same or larger page granules than the one host uses.  We can
> theoretically support a guest hypervisor having smaller-than-host
> granularities but it is not worth it since it makes the implementation
> complicated and it would waste memory.
>
> We expose 40 bits of physical address range to the virtual EL2, because
> we only support a 40bit IPA for the guest. Eventually, this will change.
>
>   [ This was only trapping on the 32-bit encoding, also using the
>     current target register value as a base for the sanitisation.
>
>     Use as the handler for the 64-bit sysreg as well, also load the
>     sanitised version of the sysreg before clearing and setting bits.
>
>     -- Andre Przywara ]
>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 50 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 49 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ec34b81da936..cc994ec3c121 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1710,6 +1710,54 @@ static bool access_spsr_el2(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool access_id_aa64mmfr0_el1(struct kvm_vcpu *v,
> +				    struct sys_reg_params *p,
> +				    const struct sys_reg_desc *r)
> +{
> +	u64 val;
> +
> +	if (p->is_write)
> +		return write_to_read_only(v, p, r);
> +
> +	val = read_id_reg(v, r, false);
> +
> +	if (!nested_virt_in_use(v))
> +		goto out;
> +
> +	/*
> +	 * Don't expose granules smaller than the host's granule to the guest.
> +	 * We can theoretically support a guest hypervisor having
> +	 * smaller-than-host granularities but it is not worth it since it
> +	 * makes the implementation complicated and it would waste memory.
> +	 */
> +	switch (PAGE_SIZE) {
> +	case SZ_64K:
> +		/* 16KB granule not supported */
> +		val &= ~(0xf << ID_AA64MMFR0_TGRAN16_SHIFT);
> +		val |= (ID_AA64MMFR0_TGRAN16_NI << ID_AA64MMFR0_TGRAN16_SHIFT);
> +		/* fall through */
> +	case SZ_16K:
> +		/* 4KB granule not supported */
> +		val &= ~(0xf << ID_AA64MMFR0_TGRAN4_SHIFT);
> +		val |= (ID_AA64MMFR0_TGRAN4_NI << ID_AA64MMFR0_TGRAN4_SHIFT);
> +		break;
> +	case SZ_4K:
> +		/* All granule sizes are supported */
> +		break;
> +	default:
> +		unreachable();
> +	}
> +
> +	/* Expose only 40 bits physical address range to the guest hypervisor */
> +	val &= ~(0xf << ID_AA64MMFR0_PARANGE_SHIFT);
> +	val |= (0x2 << ID_AA64MMFR0_PARANGE_SHIFT); /* 40 bits */

There are already defines for ID_AA64MMFR0_PARANGE_48 and
ID_AA64MMFR0_PARANGE_52 in sysreg.h, perhaps a similar define for
ID_AA64MMFR0_PARANGE_40 would be appropriate?

> +
> +out:
> +	p->regval = val;
> +
> +	return true;
> +}
> +
>  static bool access_id_aa64pfr0_el1(struct kvm_vcpu *v,
>  				   struct sys_reg_params *p,
>  				   const struct sys_reg_desc *r)
> @@ -1846,7 +1894,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	ID_UNALLOCATED(6,7),
>  
>  	/* CRm=7 */
> -	ID_SANITISED(ID_AA64MMFR0_EL1),
> +	ID_SANITISED_FN(ID_AA64MMFR0_EL1, access_id_aa64mmfr0_el1),
>  	ID_SANITISED(ID_AA64MMFR1_EL1),
>  	ID_SANITISED(ID_AA64MMFR2_EL1),
>  	ID_UNALLOCATED(7,3),
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
