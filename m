Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A112DC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 12:48:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19B9C61039
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 12:48:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 19B9C61039
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 846034B285;
	Mon,  4 Oct 2021 08:48:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xFrYLVTVWcHr; Mon,  4 Oct 2021 08:48:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B1A84B286;
	Mon,  4 Oct 2021 08:48:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69D064B23C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 08:47:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UpHTsX-KjGFO for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 08:47:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23D254B286
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 08:47:58 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B64B81FB;
 Mon,  4 Oct 2021 05:47:57 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 12DA63F70D;
 Mon,  4 Oct 2021 05:47:55 -0700 (PDT)
Message-ID: <7b629634-0d0d-5601-3a64-c418ef2fc1e6@arm.com>
Date: Mon, 4 Oct 2021 13:49:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 3/5] KVM: arm64: vgic-v3: Don't advertise ICC_CTLR_EL1.SEIS
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20210924082542.2766170-1-maz@kernel.org>
 <20210924082542.2766170-4-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
In-Reply-To: <20210924082542.2766170-4-maz@kernel.org>
Cc: kernel-team@android.com
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

On 9/24/21 09:25, Marc Zyngier wrote:
> Since we are trapping all sysreg accesses when ICH_VTR_EL2.SEIS
> is set, and that we never deliver an SError when emulating
> any of the GICv3 sysregs, don't advertise ICC_CTLR_EL1.SEIS.

Makes sense, we don't emulate it, so don't advertise it. Checked
__vgic_v3_write_ctlr(), and we only allow the guest to modify EOI mode and which
register is responsible for determining the binary point for the interrupt priority.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 39f8f7f9227c..b3b50de496a3 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -987,8 +987,6 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  	val = ((vtr >> 29) & 7) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
>  	/* IDbits */
>  	val |= ((vtr >> 23) & 7) << ICC_CTLR_EL1_ID_BITS_SHIFT;
> -	/* SEIS */
> -	val |= ((vtr >> 22) & 1) << ICC_CTLR_EL1_SEIS_SHIFT;
>  	/* A3V */
>  	val |= ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
>  	/* EOImode */
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
