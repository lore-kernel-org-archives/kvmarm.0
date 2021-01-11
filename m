Return-Path: <SRS0=NVHA=GO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A535C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 13:53:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA64C222B3
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 13:53:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA64C222B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11CD44B215;
	Mon, 11 Jan 2021 08:53:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vL3PszWQ-o02; Mon, 11 Jan 2021 08:53:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7C904B20C;
	Mon, 11 Jan 2021 08:53:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 639284B1E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 08:53:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oUmqtm85EBgN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jan 2021 08:53:22 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00FA64B1DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 08:53:21 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C694922283;
 Mon, 11 Jan 2021 13:53:20 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kyxdG-006hJn-Sx; Mon, 11 Jan 2021 13:53:18 +0000
MIME-Version: 1.0
Date: Mon, 11 Jan 2021 13:53:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/21] arm64: Provide an 'upgrade to VHE' stub hypercall
In-Reply-To: <20210111132811.2455113-5-maz@kernel.org>
References: <20210111132811.2455113-1-maz@kernel.org>
 <20210111132811.2455113-5-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <017892d274a0a2ba20ad83f3eb9bc6e3@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 mark.rutland@arm.com, jingzhangos@google.com, psodagud@codeaurora.org,
 sramana@codeaurora.org, suzuki.poulose@arm.com, catalin.marinas@arm.com,
 alexandru.elisei@arm.com, james.morse@arm.com, pajay@qti.qualcomm.com,
 kernel-team@android.com, dbrazdil@google.com, will@kernel.org, ardb@kernel.org,
 julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Will Deacon <will@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 Prasad Sodagudi <psodagud@codeaurora.org>
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

On 2021-01-11 13:27, Marc Zyngier wrote:
> As we are about to change the way a VHE system boots, let's
> provide the core helper, in the form of a stub hypercall that
> enables VHE and replicates the full EL1 context at EL2, thanks
> to EL1 and VHE-EL2 being extremely similar.
> 
> On exception return, the kernel carries on at EL2. Fancy!
> 
> Nothing calls this new hypercall yet, so no functional change.

Famous last words...

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/virt.h |  7 +++-
>  arch/arm64/kernel/hyp-stub.S  | 67 +++++++++++++++++++++++++++++++++--
>  2 files changed, 71 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/virt.h 
> b/arch/arm64/include/asm/virt.h
> index ee6a48df89d9..7379f35ae2c6 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -35,8 +35,13 @@
>   */
>  #define HVC_RESET_VECTORS 2
> 
> +/*
> + * HVC_VHE_RESTART - Upgrade the CPU from EL1 to EL2, if possible
> + */
> +#define HVC_VHE_RESTART	3
> +
>  /* Max number of HYP stub hypercalls */
> -#define HVC_STUB_HCALL_NR 3
> +#define HVC_STUB_HCALL_NR 4
> 
>  /* Error returned when an invalid stub number is passed into x0 */
>  #define HVC_STUB_ERR	0xbadca11
> diff --git a/arch/arm64/kernel/hyp-stub.S 
> b/arch/arm64/kernel/hyp-stub.S
> index 160f5881a0b7..0a84602344eb 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -8,9 +8,9 @@
> 
>  #include <linux/init.h>
>  #include <linux/linkage.h>
> -#include <linux/irqchip/arm-gic-v3.h>
> 
>  #include <asm/assembler.h>
> +#include <asm/el2_setup.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/ptrace.h>
> @@ -47,10 +47,13 @@ SYM_CODE_END(__hyp_stub_vectors)
> 
>  SYM_CODE_START_LOCAL(el1_sync)
>  	cmp	x0, #HVC_SET_VECTORS
> -	b.ne	2f
> +	b.ne	1f
>  	msr	vbar_el2, x1
>  	b	9f
> 
> +1:	cmp	x0, #HVC_VHE_RESTART
> +	b	mutate_to_vhe

And of course, I managed to send the *wrong* version of this patch.
This should obviously be a "b.eq", otherwise none of the other
hypercalls are reachable...

The correct version of this is now pushed in my tree[1].

Thanks,

         M.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=hack/arm64-early-cpufeature
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
