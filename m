Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86910C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:31:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C3CB20706
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 10:31:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C3CB20706
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B7204B07F;
	Mon, 22 Jun 2020 06:31:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tujCfjugyq6d; Mon, 22 Jun 2020 06:31:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F5374B098;
	Mon, 22 Jun 2020 06:31:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 624714B0A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:31:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KqQesyX3-1qk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 06:31:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B65C4B08E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 06:31:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95BC61FB;
 Mon, 22 Jun 2020 03:31:38 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.15.132])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C1963F71E;
 Mon, 22 Jun 2020 03:31:36 -0700 (PDT)
Date: Mon, 22 Jun 2020 11:31:33 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: arm64: Simplify PtrAuth alternative patching
Message-ID: <20200622103133.GD88608@C02TD0UTHF1T.local>
References: <20200622080643.171651-1-maz@kernel.org>
 <20200622080643.171651-6-maz@kernel.org>
 <20200622091508.GB88608@C02TD0UTHF1T.local>
 <422da5e4a8cfb9f9d7870d0a50985e55@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <422da5e4a8cfb9f9d7870d0a50985e55@kernel.org>
Cc: kvm@vger.kernel.org, Dave Martin <Dave.Martin@arm.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
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

On Mon, Jun 22, 2020 at 11:25:41AM +0100, Marc Zyngier wrote:
> On 2020-06-22 10:15, Mark Rutland wrote:
> > On Mon, Jun 22, 2020 at 09:06:43AM +0100, Marc Zyngier wrote:
> I have folded in the following patch:
> 
> diff --git a/arch/arm64/include/asm/kvm_ptrauth.h
> b/arch/arm64/include/asm/kvm_ptrauth.h
> index 7a72508a841b..0ddf98c3ba9f 100644
> --- a/arch/arm64/include/asm/kvm_ptrauth.h
> +++ b/arch/arm64/include/asm/kvm_ptrauth.h
> @@ -68,29 +68,29 @@
>   */
>  .macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
>  alternative_if_not ARM64_HAS_ADDRESS_AUTH
> -	b	1000f
> +	b	.L__skip_switch\@
>  alternative_else_nop_endif
>  	mrs	\reg1, hcr_el2
>  	and	\reg1, \reg1, #(HCR_API | HCR_APK)
> -	cbz	\reg1, 1000f
> +	cbz	\reg1, .L__skip_switch\@
>  	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
>  	ptrauth_restore_state	\reg1, \reg2, \reg3
> -1000:
> +.L__skip_switch\@:
>  .endm
> 
>  .macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
>  alternative_if_not ARM64_HAS_ADDRESS_AUTH
> -	b	2000f
> +	b	.L__skip_switch\@
>  alternative_else_nop_endif
>  	mrs	\reg1, hcr_el2
>  	and	\reg1, \reg1, #(HCR_API | HCR_APK)
> -	cbz	\reg1, 2000f
> +	cbz	\reg1, .L__skip_switch\@
>  	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
>  	ptrauth_save_state	\reg1, \reg2, \reg3
>  	add	\reg1, \h_ctxt, #CPU_APIAKEYLO_EL1
>  	ptrauth_restore_state	\reg1, \reg2, \reg3
>  	isb
> -2000:
> +.L__skip_switch\@:
>  .endm

Looks good to me; thanks!

Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
