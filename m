Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBC3C5517A
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 08:24:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6DE3822253
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 08:24:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YIU+hAqz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DE3822253
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A29BB4B36F;
	Fri, 30 Oct 2020 04:24:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ibHUflEwyAtb; Fri, 30 Oct 2020 04:24:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 960A54B38A;
	Fri, 30 Oct 2020 04:24:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BED614B385
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 04:24:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f7i2J28rkw5f for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 04:24:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF81E4B36F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 04:24:06 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 797B922249;
 Fri, 30 Oct 2020 08:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604046245;
 bh=DMS3Pow1PsWdDZjc0sYpclAumQvYZCqVBrfrHHMP+kc=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=YIU+hAqzrOuysVC0PXni/igSgrnyo5t8TQus7rLrDrrAYT/kKMLuQyHtF+IWqK2Zc
 nLqUz9XaPe3+KrnoL4dl2ZMQFbVJicoBjbdJsKM8HT4yeTyFBMPflp0mYN8sGQe+wd
 J9ZqKjc7+NIxNMKvvLKM1tsPmE+7EhziOabMXDlc=
Date: Fri, 30 Oct 2020 08:24:01 +0000
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv2 3/3] arm64: cpufeature: upgrade hyp caps to final
Message-ID: <20201030082400.GB32163@willie-the-truck>
References: <20201026134931.28246-1-mark.rutland@arm.com>
 <20201026134931.28246-4-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201026134931.28246-4-mark.rutland@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Mon, Oct 26, 2020 at 01:49:31PM +0000, Mark Rutland wrote:
> We finalize caps before initializing kvm hyp code, and any use of
> cpus_have_const_cap() in kvm hyp code generates redundant and
> potentially unsound code to read the cpu_hwcaps array.
> 
> A number of helper functions used in both hyp context and regular kernel
> context use cpus_have_const_cap(), as some regular kernel code runs
> before the capabilities are finalized. It's tedious and error-prone to
> write separate copies of these for hyp and non-hyp code.
> 
> So that we can avoid the redundant code, let's automatically upgrade
> cpus_have_const_cap() to cpus_have_final_cap() when used in hyp context.
> With this change, there's never a reason to access to cpu_hwcaps array
> from hyp code, and we don't need to create an NVHE alias for this.
> 
> This should have no effect on non-hyp code.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: David Brazdil <dbrazdil@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/cpufeature.h | 26 ++++++++++++++++++++++++--
>  arch/arm64/include/asm/virt.h       | 12 ------------
>  arch/arm64/kernel/image-vars.h      |  1 -
>  3 files changed, 24 insertions(+), 15 deletions(-)

[...]

> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index 61684a5009148..c615b285ff5b3 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -87,7 +87,6 @@ KVM_NVHE_ALIAS(__icache_flags);
>  /* Kernel symbols needed for cpus_have_final/const_caps checks. */
>  KVM_NVHE_ALIAS(arm64_const_caps_ready);
>  KVM_NVHE_ALIAS(cpu_hwcap_keys);
> -KVM_NVHE_ALIAS(cpu_hwcaps);

Nice!

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
