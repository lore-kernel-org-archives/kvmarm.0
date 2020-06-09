Return-Path: <SRS0=btD/=7W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737DEC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jun 2020 11:41:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F04F22064C
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jun 2020 11:41:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F04F22064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B6FD4B2BA;
	Tue,  9 Jun 2020 07:41:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N-videec+oX9; Tue,  9 Jun 2020 07:41:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F5F14B254;
	Tue,  9 Jun 2020 07:41:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 919DE4B254
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 07:41:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1eAzXUwIsqqh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2020 07:41:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 398904B1D6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 07:41:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 788251FB;
 Tue,  9 Jun 2020 04:41:25 -0700 (PDT)
Received: from [10.57.11.57] (unknown [10.57.11.57])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 048F93F66F;
 Tue,  9 Jun 2020 04:41:23 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20200609084921.1448445-1-maz@kernel.org>
 <20200609084921.1448445-2-maz@kernel.org>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <7c173265-3f8e-51df-d700-7e3658a0e4d8@arm.com>
Date: Tue, 9 Jun 2020 12:41:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609084921.1448445-2-maz@kernel.org>
Content-Language: en-GB
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-06-09 09:49, Marc Zyngier wrote:
> AArch32 CP1x registers are overlayed on their AArch64 counterparts
> in the vcpu struct. This leads to an interesting problem as they
> are stored in their CPU-local format, and thus a CP1x register
> doesn't "hit" the lower 32bit portion of the AArch64 register on
> a BE host.
> 
> To workaround this unfortunate situation, introduce a bias trick
> in the vcpu_cp1x() accessors which picks the correct half of the
> 64bit register.
> 
> Cc: stable@vger.kernel.org
> Reported-by: James Morse <james.morse@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_host.h | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 59029e90b557..e80c0e06f235 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -404,8 +404,14 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
>    * CP14 and CP15 live in the same array, as they are backed by the
>    * same system registers.
>    */
> -#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r)])
> -#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r)])
> +#ifdef CPU_BIG_ENDIAN

Ahem... I think you're missing a "CONFIG_" there ;)

Bonus trickery - for a 0 or 1 value you can simply use IS_ENABLED().

Robin.

> +#define CPx_OFFSET	1
> +#else
> +#define CPx_OFFSET	0
> +#endif
> +
> +#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_OFFSET])
> +#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_OFFSET])
>   
>   struct kvm_vm_stat {
>   	ulong remote_tlb_flush;
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
