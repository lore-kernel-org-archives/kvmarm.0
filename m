Return-Path: <SRS0=6Unu=T5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA82BC07542
	for <kvmarm@archiver.kernel.org>; Wed, 29 May 2019 08:26:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 456FF21670
	for <kvmarm@archiver.kernel.org>; Wed, 29 May 2019 08:26:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 456FF21670
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0CB64A4EE;
	Wed, 29 May 2019 04:26:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oElTJGwo2LDg; Wed, 29 May 2019 04:26:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B5E14A4AA;
	Wed, 29 May 2019 04:26:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 112C54A479
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 May 2019 04:26:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x49p8zcUit+k for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 May 2019 04:26:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E0FF4A332
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 May 2019 04:26:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D98F580D;
 Wed, 29 May 2019 01:26:41 -0700 (PDT)
Received: from [10.37.8.255] (unknown [10.37.8.255])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2030D3F5AF;
 Wed, 29 May 2019 01:26:37 -0700 (PDT)
Subject: Re: [PATCH v2 09/15] arm64: KVM: add support to save/restore SPE
 profiling buffer controls
To: Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
References: <20190523103502.25925-1-sudeep.holla@arm.com>
 <20190523103502.25925-10-sudeep.holla@arm.com>
From: Julien Thierry <julien.thierry@arm.com>
Message-ID: <fbd9f15d-2322-5808-de62-9e1010c9c961@arm.com>
Date: Wed, 29 May 2019 09:26:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190523103502.25925-10-sudeep.holla@arm.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org
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

Hi Sudeep,

On 05/23/2019 11:34 AM, Sudeep Holla wrote:
> Currently since we don't support profiling using SPE in the guests,
> we just save the PMSCR_EL1, flush the profiling buffers and disable
> sampling. However in order to support simultaneous sampling both in
> the host and guests, we need to save and reatore the complete SPE
> profiling buffer controls' context.
> 
> Let's add the support for the same and keep it disabled for now.
> We can enable it conditionally only if guests are allowed to use
> SPE.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>  arch/arm64/kvm/hyp/debug-sr.c | 44 ++++++++++++++++++++++++++++-------
>  1 file changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> index a2714a5eb3e9..a4e6eaf5934f 100644
> --- a/arch/arm64/kvm/hyp/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -66,7 +66,8 @@
>  	default:	write_debug(ptr[0], reg, 0);			\
>  	}
>  
> -static void __hyp_text __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt)
> +static void __hyp_text
> +__debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)

Rather that add a boolean to just indicate "do more stuff" I'd suggest
having two separate functions.

Also this would be an opportunity to fix the naming of this function
which doesn't just save sve context, it also flushes the context and
disables it.

So maybe have a: void __debug_spe_flush_ctx(struct kvm_cpu_context *ctx);

Maybe adapt the name to make it understandable that it does save PMSCR.

and void __debug_spe_save_ctx(struct kvm_cpu_context *ctx);

Which would save the registers you save under the full_ctx condition.

Cheers,

Julien
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
