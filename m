Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6311C43463
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:05:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3DEB12068E
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:05:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RW9Go77W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DEB12068E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EEB34B3DF;
	Fri, 18 Sep 2020 05:05:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id duIMs95icGZz; Fri, 18 Sep 2020 05:05:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D0BF4B3A9;
	Fri, 18 Sep 2020 05:05:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EF8A4B391
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:05:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qJThJk3hlIUO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 05:05:40 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F36E4B38B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:05:40 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E677D20684;
 Fri, 18 Sep 2020 09:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600419939;
 bh=8bbkGB04wpb31wFP8bwL1MzqYlfmTRKDty4Y+cqJkqs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=RW9Go77Wx9GYu/FTIOjFFIKGYaoJQirk92/zZmytjdUrm67V87Lxb3ZtGXddUhikA
 y0b+5uBv4Qb+wfOCqKhzOzwoifzGdX575HxGkW8mgmedHIXMHX44v/XngCe+JAGMS7
 UimHKWTCG8MVKk0k7OI0G4qumwIfcUNQgpQyH1uE=
Date: Fri, 18 Sep 2020 10:05:33 +0100
From: Will Deacon <will@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 05/11] kvm: arm64: Remove hyp_adr/ldr_this_cpu
Message-ID: <20200918090533.GE30834@willie-the-truck>
References: <20200916173439.32265-1-dbrazdil@google.com>
 <20200916173439.32265-6-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200916173439.32265-6-dbrazdil@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
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

On Wed, Sep 16, 2020 at 06:34:33PM +0100, David Brazdil wrote:
> The hyp_adr/ldr_this_cpu helpers were introduced for use in hyp code
> because they always needed to use TPIDR_EL2 for base, while
> adr/ldr_this_cpu from kernel proper would select between TPIDR_EL2 and
> _EL1 based on VHE/nVHE.
> 
> Simplify this now that the hyp mode case can be handled using the
> __KVM_VHE/NVHE_HYPERVISOR__ macros.
> 
> Acked-by: Andrew Scull <ascull@google.com>
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/assembler.h | 27 +++++++++++++++++----------
>  arch/arm64/include/asm/kvm_asm.h   | 14 +-------------
>  arch/arm64/kvm/hyp/hyp-entry.S     |  2 +-
>  3 files changed, 19 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index 54d181177656..f79231a0f949 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -218,6 +218,21 @@ lr	.req	x30		// link register
>  	str	\src, [\tmp, :lo12:\sym]
>  	.endm
>  
> +	/*
> +	 * @dst: destination register (32 or 64 bit wide)
> +	 */
> +	.macro	this_cpu_offset, dst
> +#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
> +	mrs	\dst, tpidr_el2
> +#else
> +alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
> +	mrs	\dst, tpidr_el1
> +alternative_else
> +	mrs	\dst, tpidr_el2
> +alternative_endif
> +#endif

Cosmetic, but I think it would be cleaner just to define two variants of the
macro here:

#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
	.macro  this_cpu_offset, dst
	mrs     \dst, tpidr_el2
	.endm
#else
	.macro  this_cpu_offset, dst
alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
	mrs     \dst, tpidr_el1
alternative_else
	mrs     \dst, tpidr_el2
alternative_endif
	.endm
#endif

(and should we have a shorthand __HYPERVISOR define to avoid the NVHE || VHE
logic?)

With that:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
