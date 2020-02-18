Return-Path: <SRS0=SKU0=4G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BD0C34026
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 17:43:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 463D424125
	for <kvmarm@archiver.kernel.org>; Tue, 18 Feb 2020 17:43:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 463D424125
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B74324AF51;
	Tue, 18 Feb 2020 12:43:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lwNYXmlZzftI; Tue, 18 Feb 2020 12:43:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A11484AF3E;
	Tue, 18 Feb 2020 12:43:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6F514AF0F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 12:43:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WpY2mI0G35Mj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Feb 2020 12:43:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 062A04AEE0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Feb 2020 12:43:32 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3FD0AFEC;
 Tue, 18 Feb 2020 09:43:31 -0800 (PST)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2BBB03F703;
 Tue, 18 Feb 2020 09:43:30 -0800 (PST)
Subject: Re: [PATCH 1/5] KVM: arm64: Fix missing RES1 in emulation of DBGBIDR
To: Marc Zyngier <maz@kernel.org>
References: <20200216185324.32596-1-maz@kernel.org>
 <20200216185324.32596-2-maz@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <c1bd5c57-666e-0d54-1e7c-e45d0535ffe3@arm.com>
Date: Tue, 18 Feb 2020 17:43:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200216185324.32596-2-maz@kernel.org>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

$subject typo: ~/DBGBIDR/DBGDIDR/

On 16/02/2020 18:53, Marc Zyngier wrote:
> The AArch32 CP14 DBGDIDR has bit 15 set to RES1, which our current
> emulation doesn't set. Just add the missing bit.

So it does.

Reviewed-by: James Morse <james.morse@arm.com>


> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3e909b117f0c..da82c4b03aab 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1658,7 +1658,7 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
>  		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
>  			     (((dfr >> ID_AA64DFR0_BRPS_SHIFT) & 0xf) << 24) |
>  			     (((dfr >> ID_AA64DFR0_CTX_CMPS_SHIFT) & 0xf) << 20)
> -			     | (6 << 16) | (el3 << 14) | (el3 << 12));
> +			     | (6 << 16) | (1 << 15) | (el3 << 14) | (el3 << 12));

Hmmm, where el3 is:
| u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);

Aren't we depending on the compilers 'true' being 1 here?



Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
