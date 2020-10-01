Return-Path: <SRS0=046z=DI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF4CC4727C
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 08:31:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4F45B20780
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 08:31:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hz+UFbqd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F45B20780
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A58184B2E6;
	Thu,  1 Oct 2020 04:31:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mXr0SXajfN9Z; Thu,  1 Oct 2020 04:31:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F18C4B25B;
	Thu,  1 Oct 2020 04:31:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B675B4B25B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2020 04:31:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 23hjcXOsMWW3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Oct 2020 04:31:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41FD34B0EF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2020 04:31:02 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4AF3320780;
 Thu,  1 Oct 2020 08:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1601541060;
 bh=mOjOwXFy/3k7ygL/qfSOhxFp+h1gkdtJ+osWQg12ZiU=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=hz+UFbqd+Liq8djx8/IWbvxqSX01+jnwip+HSQBPL+KwIS/XdQGI/dv4Bn4sOcTVX
 kxO1U+gxF4WZ2nOu2bnr/BNzIAHxF5NKknSosN3OYZ1gvc1Q0ImKnoYUhQBxzQzJNh
 BmByEQdlpKeymL+F2mWGdSdn67tbs364w8SfQMqw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kNtzO-00GOkS-FP; Thu, 01 Oct 2020 09:30:58 +0100
MIME-Version: 1.0
Date: Thu, 01 Oct 2020 09:30:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: Thomas Tai <thomas.tai@oracle.com>
Subject: Re: [PATCH] KVM: arm64: Fixes ARM VM hangs at boot
In-Reply-To: <20200930221239.488744-1-thomas.tai@oracle.com>
References: <20200930221239.488744-1-thomas.tai@oracle.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <f906ecd23609bbdf4a1db991624943d5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: thomas.tai@oracle.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Thomas,

On 2020-09-30 23:12, Thomas Tai wrote:
> When using the latest kernel v5.9-rc7 on an ARM server, VMs could
> hang at boot with no output. The commit a0e50aa3f4a8 removed
> asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT)),
> it looks like isb is still needed for non
> ARM64_WORKAROUND_SPECULATIVE_AT host when switching to guest.

Is that on an eMAG system, by any chance?

> 
> The code fragment for the original patch:
> -       /* __load_guest_stage2() includes an ISB for the workaround. */
> -       __load_guest_stage2(kvm);
> -       asm(ALTERNATIVE("isb", "nop", 
> ARM64_WORKAROUND_SPECULATIVE_AT));
> +       __load_guest_stage2(mmu);
> 
> The code should have been:
> -       /* __load_guest_stage2() includes an ISB for the workaround. */
> -       __load_guest_stage2(kvm);
> -       asm(ALTERNATIVE("isb", "nop", 
> ARM64_WORKAROUND_SPECULATIVE_AT));
> +       __load_guest_stage2(mmu);
> +       asm(ALTERNATIVE("isb", "nop", 
> ARM64_WORKAROUND_SPECULATIVE_AT));
> ie, the workaround is still needed.
> 
> Fixes: a0e50aa3f4a8 ("KVM: arm64: Factor out stage 2 page table data 
> from
> struct kvm")
> 
> Signed-off-by: Thomas Tai <thomas.tai@oracle.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/tlb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c 
> b/arch/arm64/kvm/hyp/nvhe/tlb.c
> index 69eae60..536496e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> @@ -32,6 +32,7 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu 
> *mmu,
>  	}
> 
>  	__load_guest_stage2(mmu);
> +	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
>  }
> 
>  static void __tlb_switch_to_host(struct tlb_inv_context *cxt)

Ouch. I remember fixing this a while ago, but somehow dropped it
after applying it and *not* merging it...

Thanks a lot for the heads up!

         M.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/pre-nv-5.9
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
